<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--COnsulta para HR ESTEIRA SUV-->
    <cfquery name="consulta_nconformidades_HR" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'HR'
              
              AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
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

    <cfquery name="consulta_nconformidades_HR_n0" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'HR'
            AND CRITICIDADE NOT IN ('N1', 'N2', 'N3', 'N4')
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
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

    <cfquery name="consulta_nconformidades_HR_AVARIA" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'HR'
            AND CRITICIDADE NOT IN ('N1', 'N2', 'N3', 'N4','N0','OK A-')
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
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
    
    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO = '06:00' THEN '06:00~07:00'
                    WHEN INTERVALO = '07:00' THEN '07:00~08:00'
                    WHEN INTERVALO = '08:00' THEN '08:00~09:00'
                    WHEN INTERVALO = '09:00' THEN '09:00~10:00'
                    WHEN INTERVALO = '10:00' THEN '10:00~11:00'
                    WHEN INTERVALO = '11:00' THEN '11:00~12:00'
                    WHEN INTERVALO = '12:00' THEN '12:00~13:00'
                    WHEN INTERVALO = '13:00' THEN '13:00~14:00'
                    WHEN INTERVALO = '14:00' THEN '14:00~15:00'
                    WHEN INTERVALO = '15:00' THEN '15:00~16:00'
                    ELSE 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
    
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
                COUNT(DISTINCT VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
                
                -- Cálculo do DPV: total de VINs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>
    
    <cfquery name="consulta_nconformidades_defeitos" datasource="#BANCOSINC#">
        SELECT ESTACAO, COUNT(PROBLEMA) AS TOTAL_PROBLEMAS
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE TRUNC(USER_DATA) = 
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            <cfqueryparam value="#CreateODBCDate(url.filtroData)#" cfsqltype="cf_sql_date">
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
        AND PROBLEMA IS NOT NULL
        AND BARREIRA = 'HR'
        AND CRITICIDADE NOT IN ('N0', 'OK A-','AVARIA')
        AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
        GROUP BY ESTACAO
        ORDER BY TOTAL_PROBLEMAS DESC
    </cfquery>

    <cfquery name="consulta_nconformidades_status" datasource="#BANCOSINC#">
        WITH PrioritizedStatus AS (
            SELECT 
                VIN,
                STATUS,
                ROW_NUMBER() OVER (PARTITION BY VIN 
                                ORDER BY 
                                CASE 
                                    WHEN STATUS = 'EM REPARO' THEN 1
                                    WHEN STATUS = 'LIBERADO' THEN 2
                                    WHEN STATUS = 'OK' THEN 3
                                    ELSE 4
                                END) AS row_num
            FROM sistema_qualidade_fa
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            AND STATUS IS NOT NULL
            AND BARREIRA = 'HR'
        )
        SELECT STATUS, COUNT(*) AS TOTAL_STATUS
        FROM PrioritizedStatus
        WHERE row_num = 1
        GROUP BY STATUS
    </cfquery>

    <cfquery name="consulta_nconformidades_criticidade" datasource="#BANCOSINC#">
        WITH MaxCriticidade AS (
            SELECT 
                VIN, 
                CRITICIDADE,
                ROW_NUMBER() OVER (PARTITION BY VIN ORDER BY 
                    CASE 
                        WHEN CRITICIDADE = 'N1' THEN 4
                        WHEN CRITICIDADE = 'N2' THEN 3
                        WHEN CRITICIDADE = 'N3' THEN 2
                        WHEN CRITICIDADE = 'N4' THEN 1
                    END
                ) AS rn
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                <cfqueryparam value="#CreateODBCDate(url.filtroData)#" cfsqltype="cf_sql_date">
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
            AND STATUS = 'EM REPARO'
            AND BARREIRA = 'HR'
            AND (
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
        )
        SELECT 
            CRITICIDADE, 
            COUNT(DISTINCT VIN) AS TOTAL_VINS
        FROM MaxCriticidade
        WHERE rn = 1
        GROUP BY CRITICIDADE
        ORDER BY TOTAL_VINS DESC
    </cfquery>

    <cfquery name="verificar_dados_reparo" datasource="#BANCOSINC#">
        SELECT 
            TRUNC(SYSDATE) - TRUNC(USER_DATA) AS DIAS_EM_REPARO,
            COUNT(DISTINCT VIN) AS TOTAL_VINS
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE STATUS = 'EM REPARO'
        AND USER_DATA <= SYSDATE
        AND BARREIRA = 'HR'
        GROUP BY TRUNC(SYSDATE) - TRUNC(USER_DATA)
        ORDER BY DIAS_EM_REPARO
    </cfquery>

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
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
        <title>FA SUV HR Indicador-1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v1"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
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
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
      
        <!-- Filtro de data -->
        
        <div class="container">
            <h2>FA SUV HR 1º Turno</h2>
            <form method="get" action="fa_indicadores_1_hr.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fa_indicadores_1_hr.cfm'">Limpar</button>
            </form>
        </div>

        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Primer -->
                <div class="col-md-3">
                    <h3>HR</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-100" style="font-size:12px">
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
        
                <!-- Tabela Pareto para HR -->
                <div class="col-md-4" style="padding-left: 0;">
                    <h3>Pareto - HR</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-100" style="font-size: 12px";>
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col" style="width: 5vw;">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_HR">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'> color: gold;<cfelseif ESTACAO eq 'Linha F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'LOGISTICA'>color: lightblue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        
                <!-- Gráfico -->
                <div class="col-md-5" style="padding-left: 0;">
                    <div id="paretoChart" style="width: 100%; height: 400px;"></div>
                </div>
            </div>
        </div> 
                <div class="container-fluid">
                    <div class="row">
                        <!-- Primeira tabela -->
                        <div class="col-md-5">
                            <h3>Pareto - HR N0</h3>
                            <div class="table-responsive">
                                <table style="font-size:12px" class="table table-hover table-sm" border="1" id="tblStocks" style="width: 100%;" data-excel-name="Veículos" style="font-size: 12px;>
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
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
                                        <cfoutput query="consulta_nconformidades_HR_N0">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'>color: gold;<cfelseif ESTACAO eq 'Linha F'>color: gold;<cfelseif ESTACAO eq 'Paint'>color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                
                        <!-- Segunda tabela -->
                        <div class="col-md-5">
                            <h3>Pareto - HR AVARIA</h3>
                            <div class="table-responsive">
                                <table style="font-size:12px" class="table table-hover table-sm" border="1" id="tblStocks" style="width: 100%;" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 10</th>
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
                                        <cfoutput query="consulta_nconformidades_HR_AVARIA">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'Linha T'>color: gold;<cfelseif ESTACAO eq 'Linha C'>color: gold;<cfelseif ESTACAO eq 'Linha F'>color: gold;<cfelseif ESTACAO eq 'Paint'>color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                    </div>
                </div>
                
                
                
                
                <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <script>
                google.charts.load('current', {'packages':['corechart', 'line']});
                google.charts.setOnLoadCallback(drawChart);

                function drawChart() {
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'Problema');
                    data.addColumn('number', 'Total de Defeitos');
                    data.addColumn('number', 'Pareto (%)');

                    data.addRows([
                        <cfoutput query="consulta_nconformidades_HR">
                            ['#PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
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

                    var chart = new google.visualization.ComboChart(document.getElementById('paretoChart'));
                    chart.draw(data, options);
                }
            </script> <br><br><br>
        
        
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3">
                    <h3>Problemas por Estação</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm custom-table-width" border="1" id="tblProblemas" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="2" class="bg-warning">Defeitos por Estação</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Estação</th>
                                    <th scope="col">Total de Problemas</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_defeitos">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold">#ESTACAO#</td>
                                        <td>#TOTAL_PROBLEMAS#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-3">
                    <div id="piechart_3d" style="width: 300; height: 300px;"></div>
                </div>
                <div class="col-md-3">
                    <div id="piechart_3d1" style="width: 300; height: 300px;"></div>
                </div>
                <div class="col-md-3">
                    <div id="piechart_3d2" style="width: 300; height: 300px;"></div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // Carregar a biblioteca de gráficos do Google
            google.charts.load('current', {'packages':['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {
                // Crie uma instância do gráfico de pizza
                var data = google.visualization.arrayToDataTable([
                    ['Estação', 'Total de Problemas'],
                    // Adicione os dados da consulta aqui
                    <cfoutput>
                        <cfset firstRow = true>
                        <cfloop query="consulta_nconformidades_defeitos">
                            <cfif not firstRow>,</cfif>
                            ['#ESTACAO#', #TOTAL_PROBLEMAS#]
                            <cfset firstRow = false>
                        </cfloop>
                    </cfoutput>
                ]);

                // Configurações do gráfico
                var options = {
                    title:'Problemas por Estação',
                    pieSliceText: 'label',
                    slices: {
                        0: {offset: 0.1}
                        // Se você tiver mais fatias, ajuste conforme necessário
                    },
                    legend: { position: 'bottom' },
                    pieHole: 0.4 // Para criar um gráfico de pizza em 3D
                };

                // Desenhe o gráfico no elemento com o id 'piechart_3d'
                var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
                chart.draw(data, options);
            }
        </script>
        
<script type="text/javascript">
    // Carregar a biblioteca de gráficos do Google
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        // Crie uma instância do gráfico de pizza
        var data = google.visualization.arrayToDataTable([
            ['Status', 'Total'],
            <cfoutput>
                <cfset firstRow = true>
                <cfloop query="consulta_nconformidades_status">
                    <cfif not firstRow>,</cfif>
                    ['#STATUS#', #TOTAL_STATUS#]
                    <cfset firstRow = false>
                </cfloop>
            </cfoutput>
        ]);

        // Define as cores baseadas no status
        var statusColors = {
            'EM REPARO': 'red',
            'INSPEÇÃO QA': 'yellow',
            'LIBERADO': 'green',
            'OK': 'blue' // Adicionei a cor azul para o status OK
        };

        // Construa a configuração de cores para cada fatia
        var sliceColors = {};
        for (var i = 0; i < data.getNumberOfRows(); i++) {
            var status = data.getValue(i, 0);
            var color = statusColors[status] || 'gray'; // Usa cinza se o status não estiver definido
            sliceColors[i] = {color: color};
        }

        // Configurações do gráfico
        var options = {
            title: 'Controle de OFF LINE',
            pieSliceText: 'label', // Exibe o rótulo da fatia
            slices: sliceColors,
            legend: { position: 'bottom' },
            pieHole: 0.4, // Gráfico de pizza com "buraco"
            pieSliceTextStyle: { color: 'black' } // Ajusta a cor do texto dos rótulos
        };

        // Desenhe o gráfico no elemento com o id 'piechart_3d1'
        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d1'));
        chart.draw(data, options);
    }
</script>
        

      <!---  <script type="text/javascript">
            // Carregar a biblioteca de gráficos do Google
            google.charts.load('current', {'packages':['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {
                // Crie uma instância do gráfico de pizza
                var data = google.visualization.arrayToDataTable([
                    ['Criticidade', 'Total VINS'],
                    <cfoutput>
                        <cfset firstRow = true>
                        <cfloop query="consulta_nconformidades_criticidade">
                            <cfif not firstRow>,</cfif>
                            ['#CRITICIDADE#', #TOTAL_VINS#]
                            <cfset firstRow = false>
                        </cfloop>
                    </cfoutput>
                ]);

                // Define as cores baseadas na criticidade
                var criticidadeColors = {
                    'N1': 'green',
                    'N2': 'yellow',
                    'N3': 'orange',
                    'N4': 'red',
                    'OK A-': 'blue',
                    'AVARIA': 'gray',
                    // Adicione cores adicionais para outras criticidades se necessário
                };

                // Construa a configuração de cores para cada fatia
                var sliceColors = {};
                for (var i = 0; i < data.getNumberOfRows(); i++) {
                    var criticidade = data.getValue(i, 0);
                    var color = criticidadeColors[criticidade] || 'gray'; // Usa cinza se a criticidade não estiver definida
                    sliceColors[i] = {offset: 0.1, color: color};
                }

                // Configurações do gráfico
                var options = {
                    title: 'Quantidade de veículos em Reparo por Criticidade',
                    pieSliceText: 'label',
                    slices: sliceColors,
                    legend: { position: 'bottom' },
                    pieHole: 0.4 // Cria um gráfico de pizza em formato de rosca
                };

                // Desenhe o gráfico no elemento com o id 'piechart_3d2'
                var chart = new google.visualization.PieChart(document.getElementById('piechart_3d2'));
                chart.draw(data, options);
            }
        </script> --->

                <div class="container mt-4">
                    <div class="table-wrapper">
                        <table class='reparo'>
                            <thead>
                                <tr>
                                    <th>Total veículos</th>
                                    <th>Dias em Reparo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="verificar_dados_reparo">
                                    <tr>
                                        <td>#TOTAL_VINS#</td>
                                        <td>#DIAS_EM_REPARO#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            <meta http-equiv="refresh" content="40,URL=fa_indicadores_1_hr.cfm">
    </body>
</html>

  