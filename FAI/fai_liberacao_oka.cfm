
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
    
    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
    </cfquery>

    <!--- Captura e Atualização de Dados--->
    <cfif isDefined("form.updateID") and isDefined("form.updateID")>
        <cfquery datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            SET
                RESPONSAVEL_LIBERACAO = <cfqueryparam value="#login.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = 'LIBERADO'
            WHERE ID = <cfqueryparam value="#form.updateID#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>    
    
    <!--- Consulta --->
    <cfquery name="consulta_cripple" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE PROBLEMA is not null
        AND CRITICIDADE = 'OK A-'
        AND STATUS_OKA IS NULL
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroVin") and url.filtroVin neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVin#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        ORDER BY ID DESC
    </cfquery>

    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN 
        FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = <cfqueryparam value="#cookie.user_apontamento_fai#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <!--- Captura e Atualiza Dados--->
    <cfif isDefined("form.updateID") and isDefined("form.updateID")>
        <cfquery datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            SET
                RESPONSAVEL_LIBERACAO = <cfqueryparam value="#login.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS_OKA = 'LIBERADO'
            WHERE ID = <cfqueryparam value="#form.updateID#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>  

    <cfquery name="combinedQuery" datasource="#BANCOSINC#">
        SELECT 
            fai.PECA, 
            fai.MODELO, 
            cor_table.cor,
            COUNT(*) AS totalGroupedCount
        FROM SISTEMA_QUALIDADE_FAI fai
        LEFT JOIN (
            SELECT 
                BARCODE, 
                SUBSTR(MAX(MODELO), INSTR(MAX(MODELO), ' ', -1) + 1) AS cor
            FROM SISTEMA_QUALIDADE
            GROUP BY BARCODE
        ) cor_table
        ON fai.BARCODE = cor_table.BARCODE
        WHERE fai.CRITICIDADE = 'OK A-'
        AND fai.STATUS_OKA IS NULL
        GROUP BY fai.PECA, fai.MODELO, cor_table.cor
        ORDER BY fai.PECA
    </cfquery>

    <!--- Consulta para contagem total --->
    <cfquery name="countCriticidade" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS totalCount
        FROM SISTEMA_QUALIDADE_FAI
        WHERE CRITICIDADE = 'OK A-'
        AND STATUS_OKA IS NULL
    </cfquery>
    
    <html lang="pt-br">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <title>OK A-</title>
            <link rel="stylesheet" href="assets/styleliberacao.css?v3">
            <style>
                .inputs{
                    margin-left:-30vw;
                }
                .custom-table {
                    width: 20%;
                    border-collapse: collapse;
                    margin: 0 0;
                    font-size: 12px;
                    text-align: center;
                }
                .custom-table th, .custom-table td {
                    padding: 5px;
                    border: 1px solid #ddd;
                }
                .custom-table th {
                    background-color: #f2f2f2;
                    color: red;
                }
                .custom-table tr:nth-child(even) {
                    background-color: #f9f9f9;
                }
                .custom-table tr:hover {
                    background-color: #f1f1f1;
                }
                .styled-button {
                    background-color: #4CAF50; /* Verde */
                    border: none;
                    color: white;
                    padding: 10px 20px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 10px 0;
                    cursor: pointer;
                    border-radius: 5px;
                    transition: background-color 0.3s, transform 0.2s;
                }
    
                .styled-button:hover {
                    background-color: #45a049; /* Verde mais escuro */
                    transform: scale(1.05);
                }
    
                .styled-button:active {
                    background-color: #3e8e41;
                    transform: scale(0.95);
                }
            </style>
        </head>
    
        <body>
            <header>
                <cfinclude template="auxi/nav_links1.cfm">
            </header>
            <div class="container">
                <button id="toggleButton" class="styled-button" onclick="toggleTable()">Mostrar Tabela</button>
                <div id="tableContainer" style="display: none;">
                    <!--- Exibindo a contagem total --->
                    <cfoutput>
                        <table class="custom-table">
                            <tr>
                                <th>Total de OK A-</th>
                            </tr>
                            <tr>
                                <td>#countCriticidade.totalCount#</td>
                            </tr>
                        </table>
                        <br>
                    </cfoutput>
                    <!--- Exibindo a contagem agrupada por PECA, MODELO, BARCODE e COR com tooltips --->
                    <table class="custom-table">
                        <tr>
                            <th>PECA</th>
                            <th>MODELO</th>
                            <th>COR</th>
                            <th>Total</th>
                        </tr>
                        <cfoutput query="combinedQuery">
                            <tr title="Modelos: #combinedQuery.MODELO#">
                                <td>#combinedQuery.PECA#</td>
                                <td>#combinedQuery.MODELO#</td>
                                <td>
                                    <cfif combinedQuery.MODELO EQ "CHASSI HR HDB 4WD DBLE">
                                        BRANCO
                                    <cfelse>
                                        #combinedQuery.cor#
                                    </cfif>
                                </td>
                                <td>#combinedQuery.totalGroupedCount#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
            
            <script>
                function toggleTable() {
                    const tableContainer = document.getElementById('tableContainer');
                    const toggleButton = document.getElementById('toggleButton');
                    
                    if (tableContainer.style.display === 'none') {
                        tableContainer.style.display = 'block';
                        toggleButton.textContent = 'Ocultar Tabela';
                    } else {
                        tableContainer.style.display = 'none';
                        toggleButton.textContent = 'Mostrar Tabela';
                    }
                }
            </script>
            
                <cfoutput>
                    <div class="inputs">
                        <h2>OK A-</h2>
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
                                <label class="form-label" for="filtroVin">VIN:</label>
                                <input type="text" class="form-control" name="filtroVin" id="filtroVin" value="<cfif isDefined("url.filtroVin")>#url.filtroVin#</cfif>"/>
                            </div>
                            <div class="col-2 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='fa_liberacao_oka.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </div>
                </cfoutput>
            
                <div class="container col-12 bg-white rounded metas">
                    <form method="post" action="fa_liberacao_oka.cfm">
                        <table class="table" style="font-size:12px;">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">MODELO</th>
                                    <th scope="col">VIN</th>
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
                                                <td>#MODELO#</td>
                                                <td>#VIN#</td>
                                                <td>#PECA#</td>
                                                <td>#POSICAO#</td>
                                                <td>#PROBLEMA#</td>
                                                <td>#TIPO_REPARO#</td>
                                                <td><button class="btn btn-primary salvar-btn" type="submit" name="updateID" value="#ID#">Liberar</button></td>
                                            </tr>
                                    </cfloop>
                                </cfoutput>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
        </body>
    </html>    