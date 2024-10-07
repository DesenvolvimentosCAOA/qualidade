
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
        </script>
    </cfif>

    <cfif not isDefined("cookie.user_level_fai") or (cookie.user_level_fai eq "R" or cookie.user_level_fai eq "P")>
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>

    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_body
        WHERE 1 = 1
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroBARCODE#%')
        </cfif>
        <cfif cgi.QUERY_STRING does not contain "filtro">
            AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
        </cfif>
        ORDER BY ID DESC
    </cfquery>    
    
    
    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Bloqueio Sistêmico - Selecionar</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/style_edit_tabelas.css?v2">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw" class="titulo2">Bloqueio Sistêmico</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">

                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                        </cfquery>

                        <div class="row">
                            <div hidden class="col-md-4"> <!-- Aumenta a largura da coluna para o nome -->
                                <label class="form-label" for="formNome">Inspetor</label>
                                <input type="text" class="form-control" name="nome" id="formNome" value="#login.USER_SIGN#" readonly="readonly">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroBARCODE">BARCODE:</label>
                                <input type="text" class="form-control" name="filtroBARCODE" id="filtroBARCODE" value="<cfif isDefined('url.filtroBARCODE')>#url.filtroBARCODE#</cfif>">
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 d-flex justify-content-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='2fai_selecionar_bloqueio.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                    
                </cfoutput>
            
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">VIN</th>
                                    <th scope="col">BARCODE</th>
                                    <th scope="col">MODELO</th>
                                    <th scope="col">BARREIRA</th>
                                    <th scope="col">STATUS</th>
                                    <th scope="col">Responsável</th>
                                    <th scope="col">Barreira de bloqueio</th>
                                    <th scope="col">Motivo do Bloqueio</th>
                                    <th hidden scope="col">Salvar</th>
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post">
                                            <cfif BARREIRA EQ "CP5">
                                                <tr class="align-middle">
                                                    <td>#ID#</td>
                                                    <td>#VIN#</td>
                                                    <td>#BARCODE#</td>
                                                    <td>#MODELO#</td>
                                                    <td>#BARREIRA#</td>
                                                    <td>#STATUS_BLOQUEIO#</td>
                                                    <td>#RESPONSAVEL_BLOQUEIO#</td>
                                                    <td>#BARREIRA_BLOQUEIO#</td>
                                                    <td>#MOTIVO_BLOQUEIO#</td>
                                                    <td style="display:none;">
                                                        <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                    </td>
                                                    <td class="text-nowrap">
                                                        <button class="btn btn-primary" onclick="self.location='1fai_editar_bloqueio.cfm?id_editar=#id#'">
                                                            <i class="mdi mdi-pencil-outline"></i> Editar
                                                        </button>
                                                    </td>
                                                </tr>
                                            </cfif>
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
        </body>
    </html>