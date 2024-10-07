<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>


    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE,
                CASE 
                    WHEN INTERVALO = '23:00' THEN '23:00~01:00'
                    WHEN INTERVALO = '00:00' THEN '00:00~01:00'
                    WHEN INTERVALO = '01:00' THEN '01:00~02:00'
                    WHEN INTERVALO = '02:00' THEN '02:00~03:00'
                    WHEN INTERVALO = '03:00' THEN '03:00~04:00'
                    WHEN INTERVALO = '04:00' THEN '04:00~05:00'
                    WHEN INTERVALO = '05:00' THEN '05:00~06:00'
                    ELSE 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o BARCODE só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    
                    -- Verifica se o BARCODE contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
    
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT BARCODE) AS totalVins,
                
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_body
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
                COUNT(DISTINCT BARCODE) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
                
                -- Cálculo do DPV: total de BARCODEs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(DISTINCT BARCODE) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>

    <cfquery name="consulta_nconformidades_processo" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'PROCESSO'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
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
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_cp5" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'CP5'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
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
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_superficie" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'SUPERFICIE'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
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
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_chassi" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'CHASSI'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
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
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_hr" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'HR'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
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
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_BODY") or cookie.USER_APONTAMENTO_BODY eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
    
<html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Body Indicador-3º turno</title>
        <link rel="icon" href="/cf/auth/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v1"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }           
            th, td {
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br>
        <!-- Filtro de data -->
        <cfoutput>
            <div class="container">
                <h2>BODY 3º Turno</h2>
                <form method="get" action="body_indicadores_3.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                    </div>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='body_indicadores_3.cfm'">Limpar</button>
                </form>
            </div>
            </cfoutput>
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                        <div class="col-md-3">
                            <h3>Processo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" style="font-size:12px">
                                    <thead class="bg-success">
                                        <tr>
                                            <th style="width:3vw">H/H</th>
                                            <th style="width:1vw">Prod</th>
                                            <th style="width:1vw">Aprov</th>
                                            <th style="width:1vw">%</th>
                                            <th>DPV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira">
                                            <cfif BARREIRA eq 'PROCESSO'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td style="font-weight: bold;<cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Tabela Pareto para CP5 -->
                        <div class="col-md-4">
                            <h3>Pareto - Processo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size:12px">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col" style="width:5vw">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_processo">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoChartprocesso);
                            function drawParetoChartprocesso() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_processo">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                                var options = {
                                    title: 'Pareto - Processo',
                                    seriesType: 'bars',
                                    series: {
                                        1: { type: 'line', color: 'red', targetAxisIndex: 1 }
                                    },
                                    hAxis: {
                                        title: 'Problema',
                                        slantedText: true,
                                        slantedTextAngle: 45
                                    },
                                    vAxis: {
                                        title: 'Total de Defeitos',
                                        viewWindow: {
                                            min: 0
                                        },
                                        maxValue: 10 // Ajustar o máximo do eixo y para 10
                                    },
                                    vAxes: {
                                        1: {
                                            title: 'Pareto (%)',
                                            textStyle: { color: 'red' },
                                            titleTextStyle: { color: 'red' },
                                            viewWindow: {
                                                min: 0,
                                                max: 100 // Ajustar conforme necessário
                                            }
                                        }
                                    },
                                    colors: ['#36a2eb', '#ff6384']
                                };
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoChartprocesso'));
                                chart.draw(data, options);
                            }
                        </script>
                        <div id="paretoChartprocesso" style="width: 500px; height: 400px;"></div>


        <div class="container-fluid">
            <div class="row">
                        <div class="col-md-3">
                            <h3>CP5</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" style="font-size:12px">
                                    <thead class="bg-success">
                                        <tr>
                                            <th style="width:3vw">H/H</th>
                                            <th style="width:1vw">Prod</th>
                                            <th style="width:1vw">Aprov</th>
                                            <th style="width:1vw">%</th>
                                            <th>DPV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira">
                                            <cfif BARREIRA eq 'CP5'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td style="font-weight: bold;<cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Tabela Pareto para CP5 -->
                        <div class="col-md-4">
                            <h3>Pareto - CP5</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size:12px">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col" style="width:5vw">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_cp5">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoChartcp5);
                            function drawParetoChartcp5() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_cp5">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                                var options = {
                                    title: 'Pareto - CP5',
                                    seriesType: 'bars',
                                    series: {
                                        1: { type: 'line', color: 'red', targetAxisIndex: 1 }
                                    },
                                    hAxis: {
                                        title: 'Problema',
                                        slantedText: true,
                                        slantedTextAngle: 45
                                    },
                                    vAxis: {
                                        title: 'Total de Defeitos',
                                        viewWindow: {
                                            min: 0
                                        },
                                        maxValue: 10 // Ajustar o máximo do eixo y para 10
                                    },
                                    vAxes: {
                                        1: {
                                            title: 'Pareto (%)',
                                            textStyle: { color: 'red' },
                                            titleTextStyle: { color: 'red' },
                                            viewWindow: {
                                                min: 0,
                                                max: 100 // Ajustar conforme necessário
                                            }
                                        }
                                    },
                                    colors: ['#36a2eb', '#ff6384']
                                };
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoChartcp5'));
                                chart.draw(data, options);
                            }
                        </script>
                        <div id="paretoChartcp5" style="width: 500px; height: 400px;"></div>


        
            
                        <div class="col-md-3">
                            <h3>Insp. Superfície</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" style="font-size:12px">
                                    <thead class="bg-success">
                                        <tr>
                                            <th style="width:3vw">H/H</th>
                                            <th style="width:1vw">Prod</th>
                                            <th style="width:1vw">Aprov</th>
                                            <th style="width:1vw">%</th>
                                            <th>DPV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira">
                                            <cfif BARREIRA eq 'SUPERFICIE'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td style="font-weight: bold;<cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Tabela Pareto para CP5 -->
                        <div class="col-md-4">
                            <h3>Pareto - Insp. Superfície</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size:12px">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col" style="width:5vw">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_superficie">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoChartsuperficie);
                            function drawParetoChartsuperficie() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_superficie">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                                var options = {
                                    title: 'Pareto - Insp. Superfície',
                                    seriesType: 'bars',
                                    series: {
                                        1: { type: 'line', color: 'red', targetAxisIndex: 1 }
                                    },
                                    hAxis: {
                                        title: 'Problema',
                                        slantedText: true,
                                        slantedTextAngle: 45
                                    },
                                    vAxis: {
                                        title: 'Total de Defeitos',
                                        viewWindow: {
                                            min: 0
                                        },
                                        maxValue: 10 // Ajustar o máximo do eixo y para 10
                                    },
                                    vAxes: {
                                        1: {
                                            title: 'Pareto (%)',
                                            textStyle: { color: 'red' },
                                            titleTextStyle: { color: 'red' },
                                            viewWindow: {
                                                min: 0,
                                                max: 100 // Ajustar conforme necessário
                                            }
                                        }
                                    },
                                    colors: ['#36a2eb', '#ff6384']
                                };
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoChartsuperficie'));
                                chart.draw(data, options);
                            }
                        </script>
                        <div id="paretoChartsuperficie" style="width: 500px; height: 400px;"></div>


        <div class="container-fluid">
            <div class="row">
                        <div class="col-md-3">
                            <h3>Chassi</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" style="font-size:12px">
                                    <thead class="bg-success">
                                        <tr>
                                            <th style="width:3vw">H/H</th>
                                            <th style="width:1vw">Prod</th>
                                            <th style="width:1vw">Aprov</th>
                                            <th style="width:1vw">%</th>
                                            <th>DPV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira">
                                            <cfif BARREIRA eq 'CHASSI'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td style="font-weight: bold;<cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Tabela Pareto para CP5 -->
                        <div class="col-md-4">
                            <h3>Pareto - Chassi</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size:12px">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col" style="width:5vw">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_chassi">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoChartchassi);
                            function drawParetoChartchassi() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_chassi">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                                var options = {
                                    title: 'Pareto - Chassi',
                                    seriesType: 'bars',
                                    series: {
                                        1: { type: 'line', color: 'red', targetAxisIndex: 1 }
                                    },
                                    hAxis: {
                                        title: 'Problema',
                                        slantedText: true,
                                        slantedTextAngle: 45
                                    },
                                    vAxis: {
                                        title: 'Total de Defeitos',
                                        viewWindow: {
                                            min: 0
                                        },
                                        maxValue: 10 // Ajustar o máximo do eixo y para 10
                                    },
                                    vAxes: {
                                        1: {
                                            title: 'Pareto (%)',
                                            textStyle: { color: 'red' },
                                            titleTextStyle: { color: 'red' },
                                            viewWindow: {
                                                min: 0,
                                                max: 100 // Ajustar conforme necessário
                                            }
                                        }
                                    },
                                    colors: ['#36a2eb', '#ff6384']
                                };
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoChartchassi'));
                                chart.draw(data, options);
                            }
                        </script>
                    <div id="paretoChartchassi" style="width: 500px; height: 400px;"></div>


        <div class="container-fluid">
            <div class="row">
                        <div class="col-md-3">
                            <h3>CP5</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" style="font-size:12px">
                                    <thead class="bg-success">
                                        <tr>
                                            <th style="width:3vw">H/H</th>
                                            <th style="width:1vw">Prod</th>
                                            <th style="width:1vw">Aprov</th>
                                            <th style="width:1vw">%</th>
                                            <th>DPV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira">
                                            <cfif BARREIRA eq 'HR'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td style="font-weight: bold;<cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- Tabela Pareto para CP5 -->
                        <div class="col-md-4">
                            <h3>Pareto - HR</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size:12px">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col" style="width:5vw">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_hr">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoCharthr);
                            function drawParetoCharthr() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_hr">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                                var options = {
                                    title: 'Pareto - HR',
                                    seriesType: 'bars',
                                    series: {
                                        1: { type: 'line', color: 'red', targetAxisIndex: 1 }
                                    },
                                    hAxis: {
                                        title: 'Problema',
                                        slantedText: true,
                                        slantedTextAngle: 45
                                    },
                                    vAxis: {
                                        title: 'Total de Defeitos',
                                        viewWindow: {
                                            min: 0
                                        },
                                        maxValue: 10 // Ajustar o máximo do eixo y para 10
                                    },
                                    vAxes: {
                                        1: {
                                            title: 'Pareto (%)',
                                            textStyle: { color: 'red' },
                                            titleTextStyle: { color: 'red' },
                                            viewWindow: {
                                                min: 0,
                                                max: 100 // Ajustar conforme necessário
                                            }
                                        }
                                    },
                                    colors: ['#36a2eb', '#ff6384']
                                };
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoCharthr'));
                                chart.draw(data, options);
                            }
                        </script>
                        <div id="paretoCharthr" style="width: 500px; height: 400px;"></div>
                    </div>
                </div>
        <meta http-equiv="refresh" content="40,URL=body_indicadores_3.cfm">
    </body>
</html>