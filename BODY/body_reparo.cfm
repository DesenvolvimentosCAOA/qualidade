<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

        <!--- Verificando se está logado  --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_BODY") or cookie.USER_APONTAMENTO_BODY eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/qualidade/buyoff_linhat/index.cfm'
        </script> 
    </cfif>

    <cfif not isDefined("cookie.USER_LEVEL_BODY") or cookie.USER_LEVEL_BODY eq "P">
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_body
        WHERE 1 = 1
        <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
        </cfif>
        <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroBARCODE#%')
        </cfif>
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND UPPER(ID) LIKE UPPER('%#url.filtroID#%')
        </cfif>
        AND TIPO_REPARO is null
        AND USER_DATA >= SYSDATE - 1 -- Filtra os últimos 1 dia
        ORDER BY ID DESC
    </cfquery>

    <!--- Atualizar Item --->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade_body
            SET TIPO_REPARO = <cfqueryparam value="#form.Tipo#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#form.Reparador#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'body_reparo.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade_body
        </cfquery>

        <!--- Dump para verificar valores --->
        <cfdump var="#form#">
        <cfdump var="#obterMaxId#">

        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "body_reparo.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <!--- Atualizar Item --->
    <cfif structKeyExists(url, 'btSalvarID') and url.btSalvarID neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade_body
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
            DELETE FROM INTCOLDFUSION.sistema_qualidade_body
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
            <link rel="stylesheet" href="/qualidade/FAI/assets/stylereparo.css?v1">
        </head>
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header>

            <div class="container col-12 bg-white rounded metas">
                <h2 class="titulo2">Reparo Buy Off</h2><br>
                <cfoutput>
                    
                    <form class="filterTable" name="filtro" method="GET" >
                        <div class="row" >
                            <div class="col-1"style="margin-left:15vw">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined("url.filtroID")>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-2">
                                <label class="form-label" for="filtroModelo">MODELO:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined("url.filtroModelo")>#url.filtroModelo#</cfif>"/>
                            </div>
                            <div class="col-3">
                                <label class="form-label" for="filtroBARCODE">BARCODE:</label>
                                <input type="text" class="form-control" name="filtroBARCODE" id="filtroBARCODE" value="<cfif isDefined("url.filtroBARCODE")>#url.filtroBARCODE#</cfif>"/>
                            </div>
                            <div class="col-2 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='body_reparo.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </cfoutput>

                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_BODY#'
                        </cfquery>
                        
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Data</th>
                                    <th>Inspetor</th>
                                    <th style="min-width: 210px;">Reparador</th>
                                    <th>BARCODE</th>
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
                                        <form method="post" action="body_reparo.cfm">
                                        <cfif PROBLEMA NEQ ""> <!-- Verifica se o campo problema não está em branco -->
                                            <tr>
                                                <td>#ID#</td>
                                                <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                <td>#USER_COLABORADOR#</td>
                                                <td>
                                                    <input type="text" class="form-control" name="REPARADOR" id="formReparador" value="#login.USER_SIGN#" readonly>
                                                </td>
                                                <td>#BARCODE#</td>
                                                <td>#BARREIRA#</td>
                                                <td>#PECA#</td>
                                                <td>#POSICAO#</td>
                                                <td>#PROBLEMA#</td>
                                                <td>
                                                    <select class="form-control" name="Tipo" id="formTipo" required>
                                                        <option value="LIXADO">LIXADO</option>
                                                        <option value="LIMADO_E_LIXADO">LIMADO E LIXADO</option>
                                                        <option value="SPOTER_E_LIXADO">SPOTER E LIXADO</option>
                                                        <option value="SPOTER_LIXADO_E_LIMADO">SPOTER, LIXADO E LIMADO</option>
                                                        <option value="SOLDA_MIG_E_LIXADO">SOLDA MIG E LIXADO</option>
                                                        <option value="LIMPEZA_DA_ROSCA_MACHO">LIMPEZA DA ROSCA (MACHO)</option>
                                                        <option value="SOLDA_MIG">SOLDA MIG</option>
                                                        <option value="PREECHIMENTO_DE_MIG">PREECHIMENTO DE MIG</option>
                                                        <option value="TROCA_DE_PECA">TROCA DE PEÇA</option>
                                                        <option value="REGULADO">REGULADO</option>
                                                        <option value="TORQUEADO">TORQUEADO</option>
                                                        <option value="OBLONGADO">OBLONGADO</option>
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


