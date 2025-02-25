
<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
    <cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "I">
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_fai
        WHERE 1 = 1 
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroPeca") and url.filtroPeca neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroPeca#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        <cfif isDefined("url.filtroBarreira") and url.filtroBarreira neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBarreira#%')
        </cfif>
        <cfif isDefined("url.filtroShowerTest") and url.filtroShowerTest neq "">
            AND UPPER(SHOWER_TEST) LIKE UPPER('%#url.filtroShowerTest#%')
        </cfif>
        <cfif isDefined("url.filtroRoadTest") and url.filtroRoadTest neq "">
            AND UPPER(ROAD_TEST) LIKE UPPER('%#url.filtroRoadTest#%')
        </cfif>
        AND (BARREIRA = 'ROAD TEST' AND (STATUS IS NULL))
        AND (CRITICIDADE IS NOT NULL OR CRITICIDADE NOT IN ('N0', 'OK A-'))
        AND PROBLEMA IS NOT NULL
        ORDER BY ID DESC
    </cfquery>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>FAI - REPARO-ROAD TEST</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo.css?v1">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw" class="titulo2">REPARO - ROAD TEST</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="row">
                            <div class="col-md-2 offset-md-1">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroModelo">Barreira:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroPeca">VIN:</label>
                                <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined('url.filtroPeca')>#url.filtroPeca#</cfif>"/>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='fai_reparo_pista.cfm'">Limpar</button>
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
                                    <th scope="col">Data</th>
                                    <th scope="col">Inspetor</th>
                                    <th scope="col">VIN</th>
                                    <th scope="col">Barreira</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Posição</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Estação</th>
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="fai_reparo_pista.cfm">
                                            <cfif PROBLEMA NEQ "">
                                                <tr class="align-middle">
                                                    <td class="text-center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td class="text-center" style="font-size:15px">#USER_COLABORADOR#</td>
                                                    <td class="text-center">#VIN#</td>
                                                    <td class="text-center">#BARREIRA#</td>
                                                    <td class="text-center">#PECA#</td>
                                                    <td class="text-center">#POSICAO#</td>
                                                    <td class="text-center">#PROBLEMA#</td>
                                                    <td class="text-center">#ESTACAO#</td>
                                                    <td class="text-nowrap">
                                                        <a href="reparo_editar.cfm?id_editar=#id#" class="btn btn-primary">Editar</a>
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
            
            <!-- Footer com uma imagem e o copyright -->
            <footer class="text-center py-4">
                <p>&copy; 2024 Sistema de gestão da qualidade.</p>
            </footer>
        </body>
    </html>

