<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->

<cfquery name="consulta_nconformidades_TopCoat" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
              AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'Top Coat'
              AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                )
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT *
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT CONSULTA2.*, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT CONSULTA3.*, 
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
</cfquery>

<cfquery name="consulta_unificada" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            BARREIRA, VIN,
            CASE 
                WHEN INTERVALO = '06:00' THEN '01'
                WHEN INTERVALO = '07:00' THEN '02'
                WHEN INTERVALO = '08:00' THEN '03'
                WHEN INTERVALO = '09:00' THEN '04'
                WHEN INTERVALO = '10:00' THEN '05'
                WHEN INTERVALO = '11:00' THEN '06'
                WHEN INTERVALO = '12:00' THEN '07'
                WHEN INTERVALO = '13:00' THEN '08'
                WHEN INTERVALO = '14:00' THEN '09'
                WHEN INTERVALO = '15:00' THEN '10'
                ELSE 'OUTROS'
            END HH,
            CASE 
                WHEN COUNT(CASE WHEN PROBLEMA IS NULL OR PROBLEMA = '' THEN 1 END) > 0 THEN 1
                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT VIN) AS totalVins,
            COUNT(CASE WHEN PROBLEMA IS NOT NULL THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE TRUNC(USER_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
            AND INTERVALO BETWEEN '06:00' AND '15:00'
        GROUP BY BARREIRA, VIN, INTERVALO
    )
    SELECT BARREIRA, HH, 
            COUNT(VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
            1 AS ordem
    FROM CONSULTA
    GROUP BY BARREIRA, HH
    UNION ALL
    SELECT BARREIRA, 
            'TTL' AS HH, 
            COUNT(VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
            2 AS ordem
    FROM CONSULTA
    GROUP BY BARREIRA
    ORDER BY ordem, HH
</cfquery>

<cfquery name="consulta_principal" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            BARREIRA, VIN,
            CASE 
                WHEN INTERVALO = '06:00' THEN '01'
                WHEN INTERVALO = '07:00' THEN '02'
                WHEN INTERVALO = '08:00' THEN '03'
                WHEN INTERVALO = '09:00' THEN '04'
                WHEN INTERVALO = '10:00' THEN '05'
                WHEN INTERVALO = '11:00' THEN '06'
                WHEN INTERVALO = '12:00' THEN '07'
                WHEN INTERVALO = '13:00' THEN '08'
                WHEN INTERVALO = '14:00' THEN '09'
                WHEN INTERVALO = '15:00' THEN '10'
                ELSE 'OUTROS'
            END HH,
            COUNT(DISTINCT VIN) AS totalVins,
            COUNT(CASE WHEN PROBLEMA IS NOT NULL THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE TRUNC(USER_DATA) = TRUNC(SYSDATE)
        AND INTERVALO BETWEEN '06:00' AND '15:00'
        AND BARREIRA = 'Top Coat'
        GROUP BY BARREIRA, VIN, INTERVALO
    )
    SELECT 
        HH AS INTERVALO_HORA,
        SUM(totalVins) AS totalVins,
        SUM(totalProblemas) AS totalProblemas,
        ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
    FROM CONSULTA
    GROUP BY HH

    UNION ALL

    SELECT 
        'TTL' AS INTERVALO_HORA,
        SUM(totalVins) AS totalVins,
        SUM(totalProblemas) AS totalProblemas,
        ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
    FROM CONSULTA
</cfquery>

    <html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicadores - 1º turno</title>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v=11"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <!-- Ícones Material -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <!-- Biblioteca Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
      
        <!-- Filtro de data -->
        <h2>Indicadores 1º Turno</h2>
        <div class="container">
            <form method="get" action="pagina4.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='pagina4.cfm'">Limpar</button>
            </form>
        </div>
                <!-- Tabela e Gráfico para Top Coat -->
        <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>Top Coat</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width">
                                    <thead class="bg-danger">
                                        <tr>
                                            <th>H/H</th>
                                            <th>Prod</th>
                                            <th>Aprov</th>
                                            <th>%</th>
                                            <th>DPV</th> <!-- Nova coluna DPV -->
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_unificada">
                                            <cfif BARREIRA eq 'Top Coat'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td>#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td> <!-- Exibir DPV -->
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                                    
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - Top Coat</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="3" class="bg-danger">Principais Não Conformidades - Top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_TopCoat">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>Top Coat</h3>
                            <canvas id="paretoChart7" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretoChart7').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_TopCoat">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_TopCoat">
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
                                        <cfoutput query="consulta_nconformidades_TopCoat">
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
    </body>
</html>
  