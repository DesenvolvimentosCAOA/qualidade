
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "R">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_reparo.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_indicadores_1.cfm'
    </script>
</cfif>
    
    <!--- Captura e Atualização de Dados--->
    <cfif isDefined("form.updateID") and isDefined("form.status")>
        <cfquery datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            SET 
            STATUS = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_varchar">
            WHERE ID = <cfqueryparam value="#form.updateID#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
    
    <!--- Consulta --->
    <cfquery name="consulta_cripple" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
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
        <cfif cgi.QUERY_STRING does not contain "filtro">
            AND TRUNC(USER_DATA) =  TRUNC(SYSDATE)
        </cfif>
        ORDER BY ID DESC
    </cfquery>
    
    <html lang="pt-br">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>LIBERAÇÃO</title>
            <link rel="stylesheet" href="assets/styleliberacao.css?v1">
            <style>
                .inputs{
                    margin-left:-30vw;
                }
            </style>
        </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    <div class="container">
        <h2> Liberação</h2>
        <cfoutput>
            <div class="inputs">
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
                        <button class="btn btn-warning" type="reset" onclick="self.location='Liberacao_fa.cfm'">Limpar</button>
                    </div>
                </div>
            </form>
        </div>
        </cfoutput>
    
        <div class="container col-12 bg-white rounded metas">
            <form method="post" action="Liberacao_fa.cfm">
                <table class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">ID</th>
                            <th scope="col">Data</th>
                            <th scope="col">Colaborador</th>
                            <th scope="col">VIN</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Status</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_cripple">
                                    <tr class="align-middle">
                                        <td>#ID#</td>
                                        <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                        <td>#USER_COLABORADOR#</td>
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
                                                    <option value="LIBERADO">LIBERADO</option>
                                                    <option value="NG">NG</option>
                                                    <option value="DISPENSADO">DISPENSADO</option>
                                                </select>
                                                <button class="btn btn-primary salvar-btn" type="submit" name="updateID" value="#ID#">Salvar</button>
                                            </div>
                                        </td>
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
                    color = selectElement.value === 'LIBERADO' ? 'green' : 'NG' ? 'red' : 'blue';
                }
                selectElement.style.backgroundColor = color;
            }
        </script>
    </div>
</body>
</html>
    