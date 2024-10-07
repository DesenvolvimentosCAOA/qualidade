<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_indicadores_1.cfm'
    </script>
</cfif>


    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_fa
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
        <cfif isDefined("url.filtroPeca") and url.filtroPeca neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroPeca#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        <cfif cgi.QUERY_STRING does not contain "filtro">
            AND TRUNC(USER_DATA) =  TRUNC(SYSDATE)
        </cfif>
        and TIPO_REPARO is null
        ORDER BY ID DESC
    </cfquery>
    <!--- Atualizar Item--->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade_fa
            SET TIPO_REPARO = <cfqueryparam value="#form.Tipo#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#form.Reparador#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'fa_reparo_C13.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        </cfquery>

        <!--- Dump para verificar valores --->
        <cfdump var="#form#">
        <cfdump var="#obterMaxId#">

        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "fa_reparo_C13.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'fa_reparo_C13.cfm';
        </script>
    </cfif>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>REPARO</title>
            <link rel="stylesheet" href="assets/stylereparo.css?v2">
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links.cfm">
            </header>

            <div class="container mt-4">
                <h2 style="font-size:2vw" class="titulo2">Reparo</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="form-group">
                            <label class="form-label" for="filtroID">ID:</label>
                            <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="filtroModelo">Barreira:</label>
                            <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="filtroPeca">VIN:</label>
                            <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined('url.filtroPeca')>#url.filtroPeca#</cfif>" />
                        </div>
                        <div class="form-group">
                            <button class="btn btn-primary" type="submit">Filtrar</button>
                            <button class="btn btn-warning" type="reset" onclick="self.location='fa_reparo_C13.cfm'">Limpar</button>
                        </div>
                    </form>
                    
                    
                </cfoutput>
                
                    <div class="overflow-x-auto">
                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
                        </cfquery>
                        
                        <div class="container table-container">
                            <table class="table table-bordered table-striped rounded">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col">ID</th>
                                        <th scope="col">Data</th>
                                        <th scope="col">Inspetor</th>
                                        <th scope="col">Reparador</th>
                                        <th scope="col">VIN</th>
                                        <th scope="col">Barreira</th>
                                        <th scope="col">Peça</th>
                                        <th scope="col">Posição</th>
                                        <th scope="col">Problema</th>
                                        <th scope="col">Reparo</th>
                                        <th scope="col">Salvar</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfif consulta.recordCount gt 0>
                                        <cfoutput query="consulta">
                                            <form method="post" action="fa_reparo_C13.cfm">
                                            <cfif PROBLEMA NEQ "">
                                                <tr class="align-middle">
                                                    <td style="text-align:center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td style="font-size:15px">#USER_COLABORADOR#</td>
                                                    <td>
                                                        <input type="text" class="form-control" name="REPARADOR" id="formReparador" style="font-size:10px" value="#login.USER_SIGN#" readonly>
                                                    </td>
                                                    <td style="text-align:center">#VIN#</td>
                                                    <td style="text-align:center">#BARREIRA#</td>
                                                    <td style="text-align:center">#PECA#</td>
                                                    <td style="text-align:center">#POSICAO#</td>
                                                    <td style="text-align:center">#PROBLEMA#</td>
                                                    <td>
                                                        <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                    </td>
                                                    <td>
                                                        <button type="submit" class="btn btn-save" name="btSalvarID" value="#ID#">Salvar</button>
                                                    </td>
                                                </tr>
                                            </cfif>
                                            </form>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="11" class="text-center">Nenhum registro encontrado.</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                            </table>
                        </div>
                        
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