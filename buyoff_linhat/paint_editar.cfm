<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

   <!--- Verificando se está logado --->
   <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = 'index.cfm'
    </script>
</cfif>
<cfif not isDefined("cookie.user_level_paint") or (cookie.user_level_paint eq "R" or cookie.user_level_paint eq "P")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
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
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        <cfif cgi.QUERY_STRING does not contain "filtro">
            AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
        </cfif>
        <cfif isDefined("url.data") and url.data neq "">
            AND TO_CHAR(USER_DATA, 'dd/mm/yy') = '#lsdateformat(url.data, 'dd/mm/yy')#'
        <cfelse>
            AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
        </cfif>
        ORDER BY ID asc
    </cfquery>    
    <!--- Atualizar Item--->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade
            SET TIPO_REPARO = <cfqueryparam value="#form.Tipo#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#form.Reparador#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'paint_editar.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade
        </cfquery>

        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "paint_editar.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <script>
        function atualizarRegistro(id) {
            if (confirm("Tem certeza que deseja limpar os dados deste registro?")) {
                // Redireciona para a página de edição passando o ID como parâmetro
                window.location.href = 'paint_editar.cfm?id=' + id;
            }
        }
    </script>

<cfif structKeyExists(url, "id") and url.id neq "">
    <!-- Consulta para obter o USER_SIGN e salvar no campo RESPONSAVEL_LIBERACAO -->
    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN 
        FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = <cfqueryparam value="#cookie.USER_APONTAMENTO_FA#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>

    <!-- Atualizando as colunas específicas e setando o STATUS como OK -->
    <cfquery name="update" datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.sistema_qualidade
        SET PECA = NULL,
            POSICAO = NULL,
            PROBLEMA = NULL,
            ESTACAO = NULL,
            TIPO_REPARO = NULL,
            REPARADOR = NULL,
            CRITICIDADE = NULL,
            REPARO_DATA = NULL,
            PECA_REPARO = NULL,
            POSICAO_REPARO = NULL,
            PROBLEMA_REPARO = NULL,
            RESPONSAVEL_REPARO = NULL,
            STATUS = 'OK',
            RESPONSAVEL_LIBERACAO = <cfqueryparam value="#login.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">
        WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>

    <!-- Redirecionamento -->
    <script>
        self.location = 'paint_editar.cfm';
    </script>
</cfif>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>PAINT - Editar</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo.css?v2">
            <style>
                /* Estilo normal do botão */
            .btn-apagar {
                background-color: #dc3545; /* Vermelho (Bootstrap danger) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }

            /* Estilo ao passar o mouse (hover) */
            .btn-apagar:hover {
                background-color: #c82333; /* Vermelho mais escuro */
                box-shadow: 0 0 8px rgba(220, 53, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }
        </style>
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw" class="titulo2">Editar de Estação</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="row">
                            <div style="margin-left:3vw" class="form-group col-md-1">
                                <label for="formData">Data</label>
                                <cfoutput>
                                <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfif isDefined('url.data')>#url.data#<cfelse>#lsdateformat(now(),'yyyy-mm-dd')#</cfif>">
                                </cfoutput> 
                            </div>
                            <div class="col-md-2 offset-md-1">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroModelo">Barreira:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroVIN">VIN:</label>
                                <input type="text" class="form-control" name="filtroVIN" id="filtroVIN" value="<cfif isDefined('url.filtroVIN')>#url.filtroVIN#</cfif>"/>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='paint_editar.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </cfoutput>
            
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PAINT#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">Data</th>
                                    <th scope="col">Inspetor</th>
                                    <th scope="col">BARCODE</th>
                                    <th scope="col">Barreira</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Posição</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Estação</th>
                                    <th scope="col">Salvar</th>
                                    <th scope="col">Editar</i></th>
                                    <th scope="col">Apagar NC</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="fai_reparo.cfm">
                                                <tr class="align-middle">
                                                    <td class="text-center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td class="text-center" style="font-size:15px">#USER_COLABORADOR#</td>
                                                   <!---- <td>
                                                        <input type="text" class="form-control" name="REPARADOR" id="formReparador" style="font-size:10px" value="#login.USER_SIGN#" readonly>
                                                    </td> ---->
                                                    <td class="text-center">#BARCODE#</td>
                                                    <td class="text-center">#BARREIRA#</td>
                                                    <td class="text-center">#PECA#</td>
                                                    <td class="text-center">#POSICAO#</td>
                                                    <td class="text-center">#PROBLEMA#</td>
                                                    <td class="text-center">#ESTACAO#</td>
                                                    <td style="display:none;">
                                                        <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                    </td>
                                                    <td>
                                                        <button type="submit" class="btn-save" name="btSalvarID" value="#ID#">Salvar</button>
                                                    </td>
                                                    <td class="text-nowrap">
                                                        <button class="btn btn-primary" onclick="self.location='paint_editar_editar.cfm?id_editar=#id#'">
                                                            <i class="mdi mdi-pencil-outline"></i> Editar
                                                        </button>
                                                    </td>
                                                    <td class="text-nowrap">
                                                        <button class="btn-apagar" onclick="atualizarRegistro(#ID#);">
                                                            <i class="material-icons delete-icon"></i> Apagar
                                                        </button>
                                                    </td>   
                                                </tr>
                                        </form>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="12" class="text-center">Nenhum registro encontrado.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Footer com uma imagem e o copyright -->
            <footer class="text-center py-4">
                <p>&copy; 2024 Sistema de gestão da qualidade.</p>
            </footer>
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
