<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado--->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = 'index.cfm';
        </script>
    </cfif>

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE 1 = 1 
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        and TIPO_REPARO is null
        ORDER BY ID DESC
    </cfquery>


    <!--- Atualizar Item --->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade
            SET TIPO_REPARO = <cfqueryparam value="#form.Tipo#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#form.Reparador#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'Reparo.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        </cfquery>

        <!--- Dump para verificar valores --->
        <cfdump var="#form#">
        <cfdump var="#obterMaxId#">

        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "Reparo.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <!--- Atualizar Item --->
    <cfif structKeyExists(url, 'btSalvarID') and url.btSalvarID neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade
            SET TIPO_REPARO = '#url.Tipo#',
            REPARADOR = '#url.Reparador#'
            WHERE ID = '#url.btSalvarID#'
        </cfquery>
        <script>
            alert("Salvo com sucesso!")
            self.location = 'controle_correcoes.cfm';
        </script>
    </cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE
            WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'selecao_paint.cfm';
        </script>
    </cfif>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Reparo</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="assets/StyleBuyOFF.css?v6">
            <link rel="stylesheet" href="assets/custom.css"> <!-- Seu arquivo CSS personalizado -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css"> <!-- Material Icons -->
        </head>
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links.cfm">
            </header>

            <div class="container mt-4">
                <h2 class="titulo2">Reparo</h2><br>
                
                    <div class="mt-4">

                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PAINT#'
                        </cfquery>
                        
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Data</th>
                                    <th>Inspetor</th>
                                    <th style="min-width: 210px;">Reparador</th>
                                    <th>VIN</th>
                                    <th>Barreira</th>
                                    <th>Peça</th>
                                    <th>Posição</th>
                                    <th>Problema</th>
                                    <th style="min-width: 150px;">Reparo</th>
                                    <th>Salvar</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="Reparo.cfm">
                                        <cfif PROBLEMA NEQ ""> <!-- Verifica se o campo problema não está em branco -->
                                            <tr>
                                                <td>#ID#</td>
                                                <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                <td>#USER_COLABORADOR#</td>
                                                <td>
                                                    <input type="text" class="form-control" name="REPARADOR" id="formReparador" value="#login.USER_SIGN#" readonly>
                                                </td>
                                                <td>#VIN#</td>
                                                <td>#BARREIRA#</td>
                                                <td>#PECA#</td>
                                                <td>#POSICAO#</td>
                                                <td>#PROBLEMA#</td>
                                                <td>
                                                    <select class="form-control" name="Tipo" id="formTipo" required>
                                                        <option value="">Selecione o tipo:</option>
                                                        <option value="LP - Lixado e polido">LP - Lixado e polido</option>
                                                        <option value="P - Polido">P - Polido</option>
                                                        <option value="PA - Palitado">PA - Palitado</option>
                                                        <option value="TQ - Tanqueado">TQ - Tanqueado</option>
                                                        <option value="PT - Pintura">PT - Pintura</option>
                                                        <option value="RP - Repintura">RP - Repintura</option>
                                                        <option value="#TIPO_REPARO#" SELECTED >#TIPO_REPARO#</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <button type="submit" class="btn btn-info" name="btSalvarID" value="#ID#">Salvar</button>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </form>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="10" class="text-center">Nenhum registro encontrado.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
              
            </div>

            <!-- Footer com uma imagem e o copyright -->
            <footer class="text-center py-4">
                <p>&copy; 2024 Sistema de gestão da qualidade.</p>
            </footer>

            <!-- Bootstrap JS e dependências -->
            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        </body>
    </html>

    <cfcatch type="any">
        <cfoutput>
            Ocorreu um erro ao inserir os dados no banco de dados.<br>
            Detalhes do erro: #cfcatch.message#<br>
            Stack Trace: #cfcatch.stacktrace#
        </cfoutput>
    </cfcatch>
</cftry>
