
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "R">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fai_selecionar_reparo.cfm'
    </script>
</cfif>
<cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fai_indicadores_1turno.cfm'
    </script>
</cfif>
    
    <!--- Captura e Atualização de Dados--->
    <cfif isDefined("form.updateID") and isDefined("form.status")>
        <cfquery datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            SET 
            STATUS = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_varchar">
            WHERE ID = <cfqueryparam value="#form.updateID#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
    
    
    <!--- Consulta --->
    <cfquery name="consulta_cripple" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE PROBLEMA is not null
        and TIPO_REPARO is not null
        AND STATUS is null 
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
        ORDER BY ID DESC
    </cfquery>

<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
</cfquery>
    
    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>FAI - Liberação</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo.css?v2">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br>
    
        <cfoutput>
            <h2 class="titulo2">Liberação</h2><br><br>
            <form class="filterTable" name="fitro" method="GET" >
                <div class="row" >
                    <div class="col-1"style="margin-left:15vw">
                        <label class="form-label" for="filtroID">ID:</label>
                        <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined("url.filtroID")>#url.filtroID#</cfif>"/>
                    </div>
                    <div class="col-2">
                        <label class="form-label" for="filtroModelo">Barreira:</label>
                        <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined("url.filtroModelo")>#url.filtroModelo#</cfif>"/>
                    </div>
                    <div class="col-3">
                        <label class="form-label" for="filtroPeca">VIN:</label>
                        <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined("url.filtroPeca")>#url.filtroPeca#</cfif>"/>
                    </div>
                    <div class="col-2 d-flex align-items-end">
                        <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                        <button class="btn btn-warning" type="reset" onclick="self.location='fai_liberacao.cfm'">Limpar</button>
                    </div>
                </div>
            </form>
        </cfoutput>
    
        <div class="container-fluid p-0">
            <form method="post" action="fai_liberacao.cfm">
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
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Status</th>
                            <th scope="col">Salvar</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_cripple">   
                                    <tr class="align-middle">
                                        <td>#ID#</td>
                                        <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                        <td>
                                            <input type="text" class="form-control" name="LIBERACAO" id="formLiberacao" value="#login.USER_SIGN#" readonly>
                                        </td>
                                        <td>#VIN#</td>
                                        <td>#BARREIRA#</td>
                                        <td>#PECA#</td>
                                        <td>#POSICAO#</td>
                                        <td>#PROBLEMA#</td>
                                        <td>#TIPO_REPARO#</td>
                                        <td>
                                            <!-- Dropdown de Status e Botão Salvar -->
                                            <div class="d-flex align-items-center">
                                                <select class="form-select status-dropdown mr-2" name="status" onchange="changeDropdownColor(this)">
                                                    <option value="">Selecione</option>
                                                    <option value="OK">OK</option>
                                                    <option value="NG">NG</option>
                                                    <option value="NG">Dispensado</option>
                                                    <option value="#STATUS#" SELECTED >#STATUS#</option>
                                                </select>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-primary salvar-btn" type="submit" name="updateID" value="#ID#">Salvar</button></td>
                                    </tr>
                            </cfloop>
                        </cfoutput>
                    </tbody>
                </table>
            </form>
        </div>
        <script>
            function changeDropdownColor(selectElement) {
                var color;
                if (selectElement.value === '') {
                    color = 'white';
                } else {
                    color = selectElement.value === 'OK' ? 'green' : 'red';
                }
                selectElement.style.backgroundColor = color;
            }
        </script>
    </body>
    </html>
    