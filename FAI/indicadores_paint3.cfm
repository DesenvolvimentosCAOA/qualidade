﻿<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>
    
    <!-- Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->
    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
            BARREIRA, BARCODE,
            CASE 
                WHEN INTERVALO = '01:00' THEN '01:02~02:00'
                WHEN INTERVALO = '02:00' THEN '02:00~03:00'
                WHEN INTERVALO = '03:00' THEN '03:00~04:00'
                WHEN INTERVALO = '04:00' THEN '04:00~05:00'
                WHEN INTERVALO = '05:00' THEN '05:00~06:10'
                WHEN INTERVALO = '06:00' THEN '05:00~06:10' 
            END HH,
            CASE 
                    WHEN COUNT(CASE WHEN PROBLEMA IS NULL OR PROBLEMA = '' THEN 1 END) > 0 THEN 1
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT BARCODE) AS totalVins,
                COUNT(CASE WHEN PROBLEMA IS NOT NULL THEN 1 END) AS totalProblemas
            FROM sistema_qualidade
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                    -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                    ))
                )
            GROUP BY BARREIRA, BARCODE, INTERVALO
        )
        SELECT BARREIRA, HH, 
               COUNT(BARCODE) AS TOTAL, 
               SUM(APROVADO_FLAG) AS APROVADOS, 
               COUNT(BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
               ROUND(SUM(APROVADO_FLAG) / COUNT(BARCODE) * 100, 1) AS PORCENTAGEM, 
               ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
               1 AS ordem
        FROM CONSULTA
        WHERE HH IS NOT NULL
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
               'TTL' AS HH, 
               COUNT(BARCODE) AS TOTAL, 
               SUM(APROVADO_FLAG) AS APROVADOS, 
               COUNT(BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
               ROUND(SUM(APROVADO_FLAG) / COUNT(BARCODE) * 100, 1) AS PORCENTAGEM, 
               ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
               2 AS ordem
        FROM CONSULTA
        WHERE HH IS NOT NULL
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>
    
    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND PROBLEMA IS NOT NULL
                AND (
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                ))
            )
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_primer" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'Primer'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                ))
            )
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

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
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                ))
            )
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_val" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'Validacao'
                        AND (
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                ))
            )
            -- Exemplo de filtro adicional baseado na coluna INTERVALO
            -- AND INTERVALO IN ('06:00', '07:00', '08:00')  -- Substitua pelos valores reais dos intervalos que deseja filtrar
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_lib" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'CP6'
            AND (
            -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
            -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
            -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                )))
                GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_ecoat" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'ECOAT'
            AND (
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                )))
                GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <!-- Verificando se está logado -->
    <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = 'index.cfm'
        </script>
    </cfif>
    
    <html lang="pt-BR">
        <head>
            <!-- Meta tags necessárias -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Indicadores - 3º turno</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>
            <h2>Indicadores 3º Turno</h2>
            <!-- Filtro de data -->
            <div class="container">
                <form method="get" action="indicadores_paint3.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                    </div>
                    <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='indicadores_paint3.cfm'">Limpar</button>
                </form>
            </div>
          
            <div class="container-fluid">
                <div class="row">
                    <!-- Tabela H/H -->
                    <div class="col-md-4">
                        <h3>E-COAT</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width">
                                <thead class="bg-danger">
                                    <tr>
                                        <th>H/H</th>
                                        <th>Prod</th>
                                        <th>Aprov</th>
                                        <th>%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif BARREIRA eq 'ECOAT'>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td>#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
            
                    <!-- Tabela de Pareto -->
                    <div class="col-md-4">
                        <h3>Pareto - E-COAT</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="3" class="bg-danger">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto (%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_ecoat">
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
                        <h3>E-COAT</h3>
                        <canvas id="paretochart33" width="400" height="300"></canvas>
                    </div>
                </div>
            </div>
            
            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    var ctx = document.getElementById('paretochart33').getContext('2d');
                    var data = {
                        labels: [
                            <cfoutput query="consulta_nconformidades_ecoat">
                                '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                            </cfoutput>
                        ],
                        datasets: [
                            {
                                label: 'Total de Defeitos',
                                type: 'bar',
                                data: [
                                    <cfoutput query="consulta_nconformidades_ecoat">
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
                                    <cfoutput query="consulta_nconformidades_ecoat">
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
            <!-- Exibindo tabelas e gráficos para cada barreira -->
            <div class="container-fluid">
                <div class="row">
                    <!-- Tabela H/H para Primer -->
                    <div class="col-md-4">
                        <h3>Primer</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width">
                                <thead class="bg-primary">
                                    <tr>
                                        <th>Hora/Hora</th>
                                        <th>Prod</th>
                                        <th>Aprov</th>
                                        <th>%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif BARREIRA eq 'Primer'>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td>#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
            
                    <!-- Tabela Pareto para Primer -->
                    <div class="col-md-4">
                        <h3>Pareto - Primer</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="3" class="bg-primary">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_primer">
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
            
                    <!-- Gráfico para Pareto - Primer -->
                    <div class="col-md-4">
                        <h3>Primer</h3>
                        <canvas id="paretoChart" width="600" height="300"></canvas>
                    </div>
                </div>
            </div>
            
            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    var ctx = document.getElementById('paretoChart').getContext('2d');
                    var data = {
                        labels: [
                            <cfoutput query="consulta_nconformidades_Primer">
                                '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                            </cfoutput>
                        ],
                        datasets: [
                            {
                                label: 'Total de Defeitos',
                                type: 'bar',
                                data: [
                                    <cfoutput query="consulta_nconformidades_Primer">
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
                                    <cfoutput query="consulta_nconformidades_Primer">
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
                                  
                    <!-- Tabela e Gráfico para Top Coat -->
            <div class="container-fluid">
                        <div class="row">
                            <!-- Tabela H/H -->
                            <div class="col-md-4">
                                <h3>Top Coat</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead class="bg-success">
                                            <tr>
                                                <th>Hora/Hora</th>
                                                <th>Prod</th>
                                                <th>Aprov</th>
                                                <th>%</th>
                                                <th>DPV</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_barreira">
                                                <cfif BARREIRA eq 'Top Coat'>
                                                    <tr>
                                                        <td>#HH#</td>
                                                        <td>#TOTAL#</td>
                                                        <td>#APROVADOS#</td>
                                                        <td>#PORCENTAGEM#%</td>
                                                        <td>#DPV#</td>
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
                                                <th scope="col" colspan="3" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                                <canvas id="paretoChart1" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            var ctx = document.getElementById('paretoChart1').getContext('2d');
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
                    <!-- Tabela e Gráfico para Validação de Qualidade -->
                    <div class="container-fluid">
                        <div class="row">
                            <!-- Tabela H/H -->
                            <div class="col-md-4">
                                <h3>Validação de Qualidade</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead class="bg-danger">
                                            <tr>
                                                <th>Hora/Hora</th>
                                                <th>Prod</th>
                                                <th>Aprov</th>
                                                <th>%</th>
                                                <th>DPV</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_barreira">
                                                <cfif BARREIRA eq 'Validacao'>
                                                    <tr>
                                                        <td>#HH#</td>
                                                        <td>#TOTAL#</td>
                                                        <td>#APROVADOS#</td>
                                                        <td>#PORCENTAGEM#%</td>
                                                        <td>#DPV#</td>
                                                    </tr>
                                                </cfif>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                
                            <!-- Tabela de Pareto -->
                            <div class="col-md-4">
                                <h3>Pareto - Validação de Qualidade</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                        <thead>
                                            <tr class="text-nowrap">
                                                <th scope="col" colspan="3" class="bg-danger">Principais Não Conformidades - Top 5</th>
                                            </tr>
                                            <tr class="text-nowrap">
                                                <th scope="col">Problema</th>
                                                <th scope="col">Total</th>
                                                <th scope="col">Pareto (%)</th>
                                            </tr>
                                        </thead>
                                        <tbody class="table-group-divider">
                                            <cfoutput query="consulta_nconformidades_val">
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
                                <h3>Validação de Qualidade</h3>
                                <canvas id="paretochart3" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            var ctx = document.getElementById('paretochart3').getContext('2d');
                            var data = {
                                labels: [
                                    <cfoutput query="consulta_nconformidades_val">
                                        '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ],
                                datasets: [
                                    {
                                        label: 'Total de Defeitos',
                                        type: 'bar',
                                        data: [
                                            <cfoutput query="consulta_nconformidades_val">
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
                                            <cfoutput query="consulta_nconformidades_val">
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
                    <!-- Tabela e Gráfico para Liberação Final -->
                    
                    <div class="container-fluid">
                        <div class="row">
                            <!-- Tabela H/H -->
                            <div class="col-md-4">
                                <h3>Liberação Final</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead class="bg-secondary">
                                            <tr>
                                                <th>Hora/Hora</th>
                                                <th>Prod</th>
                                                <th>Aprov</th>
                                                <th>%</th>
                                                <th>DPV</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_barreira">
                                                <cfif BARREIRA eq 'CP6'>
                                                    <tr>
                                                        <td>#HH#</td>
                                                        <td>#TOTAL#</td>
                                                        <td>#APROVADOS#</td>
                                                        <td>#PORCENTAGEM#%</td>
                                                        <td>#DPV#</td>
                                                    </tr>
                                                </cfif>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                
                            <!-- Tabela de Pareto -->
                            <div class="col-md-4">
                                <h3>Pareto - Liberação Final</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                        <thead>
                                            <tr class="text-nowrap">
                                                <th scope="col" colspan="3" class="bg-secondary">Principais Não Conformidades - Top 5</th>
                                            </tr>
                                            <tr class="text-nowrap">
                                                <th scope="col">Problema</th>
                                                <th scope="col">Total</th>
                                                <th scope="col">Pareto (%)</th>
                                            </tr>
                                        </thead>
                                        <tbody class="table-group-divider">
                                            <cfoutput query="consulta_nconformidades_lib">
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
                                <h3>Liberação Final</h3>
                                <canvas id="paretochart4" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            var ctx = document.getElementById('paretochart4').getContext('2d');
                            var data = {
                                labels: [
                                    <cfoutput query="consulta_nconformidades_lib">
                                        '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ],
                                datasets: [
                                    {
                                        label: 'Total de Defeitos',
                                        type: 'bar',
                                        data: [
                                            <cfoutput query="consulta_nconformidades_lib">
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
                                            <cfoutput query="consulta_nconformidades_lib">
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
    
                    <!-- Tabela e Gráfico de Pareto das Não Conformidades -->
                <div class="container-fluid">
                    <div class="row">
                    <div class="col-md-4">
                        <h3>Pareto das Não Conformidades</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="3" class="bg-warning">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades">
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
                    <div class="col-md-6">
                        <div class="container">
                            <h3>Pareto Geral Buy Off's</h3>
                            <canvas id="paretoChart2"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Script para o gráfico de Pareto -->
            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    var ctx = document.getElementById('paretoChart2').getContext('2d');
                    var data = {
                        labels: [
                            <cfoutput query="consulta_nconformidades">
                                '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                            </cfoutput>
                        ],
                        datasets: [
                            {
                                label: 'Total de Defeitos',
                                type: 'bar',
                                data: [
                                    <cfoutput query="consulta_nconformidades">
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
                                    <cfoutput query="consulta_nconformidades">
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
    
            </div>      
    <meta http-equiv="refresh" content="40,URL=indicadores_paint3.cfm">
        </body>
    </html>    