<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO_REPARO = '06:00' THEN '06:00~07:00'
                    WHEN INTERVALO_REPARO = '07:00' THEN '07:00~08:00'
                    WHEN INTERVALO_REPARO = '08:00' THEN '08:00~09:00'
                    WHEN INTERVALO_REPARO = '09:00' THEN '09:00~10:00'
                    WHEN INTERVALO_REPARO = '10:00' THEN '10:00~11:00'
                    WHEN INTERVALO_REPARO = '11:00' THEN '11:00~12:00'
                    WHEN INTERVALO_REPARO = '12:00' THEN '12:00~13:00'
                    WHEN INTERVALO_REPARO = '13:00' THEN '13:00~14:00'
                    WHEN INTERVALO_REPARO = '14:00' THEN '14:00~15:00'
                    WHEN INTERVALO_REPARO = '15:00' THEN '15:00~16:00'
                    ELSE 'OUTROS'
                END HH,
                CASE 
                    WHEN COUNT(CASE WHEN PROBLEMA_REPARO IS NULL THEN 1 WHEN PROBLEMA_REPARO IS NOT NULL 
                        AND (CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-') THEN 1 END) > 0 THEN 1
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                COUNT(CASE WHEN PROBLEMA_REPARO IS NOT NULL AND (CRITICIDADE IS NULL OR CRITICIDADE <> 'OK A-') THEN 1 END) AS totalPROBLEMA_REPAROs
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO
        )
        SELECT BARREIRA, HH, 
                COUNT(VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>

    <cfquery name="consulta_nconformidades_underbody2" datasource="#BANCOSINC#">
            WITH CONSULTA AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA_REPARO IS NOT NULL
            AND BARREIRA = 'UNDER BODY'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
            GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_roadtest" datasource="#BANCOSINC#">
            WITH CONSULTA AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA_REPARO IS NOT NULL
            AND BARREIRA = 'ROAD TEST'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
            GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_shower" datasource="#BANCOSINC#">
            WITH CONSULTA AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA_REPARO IS NOT NULL
            AND BARREIRA = 'SHOWER'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
            GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_exok" datasource="#BANCOSINC#">
            WITH CONSULTA AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA_REPARO IS NOT NULL
            AND BARREIRA = 'SIGN OFF'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
            GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>


<html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicador Reparo - 1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v=11"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br>

        <div class="container">
            <h2>Indicador Reparo 1º Turno</h2>
            <form method="get" action="fai_indicadores_1turno_reparo.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                    <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fai_indicadores_1turno_reparo.cfm'">Limpar</button>
            </form>
        </div>

        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Under Body 2 -->
                <div class="col-md-3">
                    <h3>Under Body 2</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-75">
                            <thead class="bg-success">
                                <tr>
                                    <th>H/H</th>
                                    <th>Qtd Reparados</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'UNDER BODY'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4">
                    <h3>Pareto - Under Body 2</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_underbody2">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif RESPONSAVEL_REPARO eq 'TRIM'>color: gold;<cfelseif RESPONSAVEL_REPARO eq 'Paint'> color: orange;<cfelseif RESPONSAVEL_REPARO eq 'BODY'>color: blue;<cfelseif RESPONSAVEL_REPARO eq 'CKD'>color: green;</cfif>">#RESPONSAVEL_REPARO#</td>
                                        <td>#PECA_REPARO#</td>
                                        <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                        <td>#PARETO#%</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4 move-left">
                    <h3>Under Body 2</h3>
                    <canvas id="paretoChart" width="600" height="300"></canvas>
                  </div>
            </div>
        </div><br><br>
        
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_underbody2">
                            '#PROBLEMA_REPARO# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_underbody2">
                                    #TOTAL_POR_DEFEITO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pareto (%)',
                            type: 'line',
                            data: [
                                <cfoutput query="consulta_nconformidades_underbody2">
                                    #PARETO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(255, 99, 132, 0.5)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 2,
                            fill: false,
                            yAxisID: 'y-axis-2'
                        }
                    ]
                };
        
                var options = {
                    scales: {
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
                                },
                                position: 'left',
                                id: 'y-axis-1'
                            },
                            {
                                ticks: {
                                    beginAtZero: true,
                                    callback: function(value) {
                                        return value + "%";
                                    }
                                },
                                position: 'right',
                                id: 'y-axis-2'
                            }
                        ]
                    }
                };
        
                new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: options
                });
            });
        </script>

        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Under Body 2 -->
                <div class="col-md-3">
                    <h3>Road Test</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-75">
                            <thead class="bg-success">
                                <tr>
                                    <th>H/H</th>
                                    <th>Qtd Reparados</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'ROAD TEST'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4">
                    <h3>Pareto - Road Test</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_roadtest">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif RESPONSAVEL_REPARO eq 'TRIM'>color: gold;<cfelseif RESPONSAVEL_REPARO eq 'Paint'> color: orange;<cfelseif RESPONSAVEL_REPARO eq 'BODY'>color: blue;<cfelseif RESPONSAVEL_REPARO eq 'CKD'>color: green;</cfif>">#RESPONSAVEL_REPARO#</td>
                                        <td>#PECA_REPARO#</td>
                                        <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                        <td>#PARETO#%</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4 move-left">
                    <h3>Road Test</h3>
                    <canvas id="paretoChart1" width="600" height="300"></canvas>
                </div>
            </div>
        </div><br><br>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart1').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_roadtest">
                            '#PROBLEMA_REPARO# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_roadtest">
                                    #TOTAL_POR_DEFEITO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pareto (%)',
                            type: 'line',
                            data: [
                                <cfoutput query="consulta_nconformidades_roadtest">
                                    #PARETO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(255, 99, 132, 0.5)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 2,
                            fill: false,
                            yAxisID: 'y-axis-2'
                        }
                    ]
                };

                var options = {
                    scales: {
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
                                },
                                position: 'left',
                                id: 'y-axis-1'
                            },
                            {
                                ticks: {
                                    beginAtZero: true,
                                    callback: function(value) {
                                        return value + "%";
                                    }
                                },
                                position: 'right',
                                id: 'y-axis-2'
                            }
                        ]
                    }
                };

                new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: options
                });
            });
        </script>

        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Under Body 2 -->
                <div class="col-md-3">
                    <h3>Shower</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-75">
                            <thead class="bg-success">
                                <tr>
                                    <th>H/H</th>
                                    <th>Qtd Reparados</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'SHOWER'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4">
                    <h3>Pareto - Shower</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_shower">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif RESPONSAVEL_REPARO eq 'TRIM'>color: gold;<cfelseif RESPONSAVEL_REPARO eq 'Paint'> color: orange;<cfelseif RESPONSAVEL_REPARO eq 'BODY'>color: blue;<cfelseif RESPONSAVEL_REPARO eq 'CKD'>color: green;</cfif>">#RESPONSAVEL_REPARO#</td>
                                        <td>#PECA_REPARO#</td>
                                        <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                        <td>#PARETO#%</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4 move-left">
                    <h3>Shower</h3>
                    <canvas id="paretoChart2" width="600" height="300"></canvas>
                </div>
            </div>
        </div><br><br>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart2').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_roadtest">
                            '#PROBLEMA_REPARO# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_shower">
                                    #TOTAL_POR_DEFEITO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pareto (%)',
                            type: 'line',
                            data: [
                                <cfoutput query="consulta_nconformidades_roadtest">
                                    #PARETO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(255, 99, 132, 0.5)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 2,
                            fill: false,
                            yAxisID: 'y-axis-2'
                        }
                    ]
                };

                var options = {
                    scales: {
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
                                },
                                position: 'left',
                                id: 'y-axis-1'
                            },
                            {
                                ticks: {
                                    beginAtZero: true,
                                    callback: function(value) {
                                        return value + "%";
                                    }
                                },
                                position: 'right',
                                id: 'y-axis-2'
                            }
                        ]
                    }
                };

                new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: options
                });
            });
        </script>

        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Under Body 2 -->
                <div class="col-md-3">
                    <h3>Sign Off</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-75">
                            <thead class="bg-success">
                                <tr>
                                    <th>H/H</th>
                                    <th>Qtd Reparados</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'SIGN OFF'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4">
                    <h3>Pareto - Sign Off</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_exok">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif RESPONSAVEL_REPARO eq 'TRIM'>color: gold;<cfelseif RESPONSAVEL_REPARO eq 'Paint'> color: orange;<cfelseif RESPONSAVEL_REPARO eq 'BODY'>color: blue;<cfelseif RESPONSAVEL_REPARO eq 'CKD'>color: green;</cfif>">#RESPONSAVEL_REPARO#</td>
                                        <td>#PECA_REPARO#</td>
                                        <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                        <td>#PARETO#%</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4 move-left">
                    <h3>Sign Off</h3>
                    <canvas id="paretoChart3" width="600" height="300"></canvas>
                </div>
            </div>
        </div><br><br>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart3').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_exok">
                            '#PROBLEMA_REPARO# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_exok">
                                    #TOTAL_POR_DEFEITO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pareto (%)',
                            type: 'line',
                            data: [
                                <cfoutput query="consulta_nconformidades_exok">
                                    #PARETO#<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            backgroundColor: 'rgba(255, 99, 132, 0.5)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 2,
                            fill: false,
                            yAxisID: 'y-axis-2'
                        }
                    ]
                };

                var options = {
                    scales: {
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
                                },
                                position: 'left',
                                id: 'y-axis-1'
                            },
                            {
                                ticks: {
                                    beginAtZero: true,
                                    callback: function(value) {
                                        return value + "%";
                                    }
                                },
                                position: 'right',
                                id: 'y-axis-2'
                            }
                        ]
                    }
                };

                new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: options
                });
            });
        </script>
        <meta http-equiv="refresh" content="60,URL=fai_indicadores_1turno_reparo.cfm">
    </body>
</html>
          