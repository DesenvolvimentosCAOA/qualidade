<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->

    <cfquery name="consulta_nconformidades_T30" datasource="#BANCOSINC#">
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
              AND BARREIRA = 'T30'
              AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                )
                GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
    
    <cfquery name="consulta_nconformidades_T19" datasource="#BANCOSINC#">
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
              AND BARREIRA = 'T19'
              AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
              )
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
                    WHEN COUNT(CASE WHEN PROBLEMA IS NULL THEN 1 WHEN PROBLEMA IS NOT NULL 
                        AND (CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-') THEN 1 END) > 0 THEN 1
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                COUNT(CASE WHEN PROBLEMA IS NOT NULL AND (CRITICIDADE IS NULL OR CRITICIDADE <> 'OK A-') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
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
    
    <cfquery name="consulta_nconformidades_T33" datasource="#BANCOSINC#">
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
              AND BARREIRA = 'T33'
              AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
              )
              -- Exemplo de filtro adicional baseado na coluna INTERVALO
              -- AND INTERVALO IN ('06:00', '07:00', '08:00')  -- Substitua pelos valores reais dos intervalos que deseja filtrar
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<!--- <cfdump var="#consulta_barreira#"> --->
    <cfquery name="consulta_nconformidades_C13" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'C13'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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

    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA FA
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND PROBLEMA IS NOT NULL
                
              AND BARREIRA not in 'CP7'
                AND (
                        -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                        ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                        -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                        OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
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

    <cfquery name="consulta_nconformidades_F05" datasource="#BANCOSINC#">
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
              AND BARREIRA = 'F05'
              AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                )
                GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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

    <cfquery name="consulta_nconformidades_F10" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'F10'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                )
                GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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

    <cfquery name="consulta_nconformidades_submotor" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'SUB MOTOR'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                )
                GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
        <title>Indicadores - 1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v1"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
      
        <!-- Filtro de data -->
        
        <div class="container">
            <h2>Indicadores 1º Turno</h2>
            <form method="get" action="fa_indicadores_1.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fa_indicadores_1.cfm'">Limpar</button>
            </form>
        </div>
      
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Primer -->
                <div class="col-md-4">
                    <h3>T19</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead class="bg-success">
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
                                    <cfif BARREIRA eq 'T19'>
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
        
                <!-- Tabela Pareto para T19 -->
                <div class="col-md-4">
                    <h3>Pareto - T19</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - top 5</th>
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
                                <cfoutput query="consulta_nconformidades_T19">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        
                <!-- Gráfico para Pareto - T19 -->
                <div class="col-md-4">
                    <h3>T19</h3>
                    <canvas id="paretoChart" width="600" height="300"></canvas>
                </div>
            </div>
        </div>
        
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_T19">
                            '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_T19">
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
                                <cfoutput query="consulta_nconformidades_T19">
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
                
                <!-- Tabela e Gráfico para T30 -->
        <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>T30</h3>
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
                                            <cfif BARREIRA eq 'T30'>
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
            
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - T30</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
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
                                        <cfoutput query="consulta_nconformidades_T30">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>T30</h3>
                            <canvas id="paretoChart7" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretoChart7').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_T30">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_T30">
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
                                        <cfoutput query="consulta_nconformidades_T30">
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
                            <h3>T33</h3>
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
                                            <cfif BARREIRA eq 'T33'>
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
            
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - T33</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
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
                                        <cfoutput query="consulta_nconformidades_T33">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>T33</h3>
                            <canvas id="paretochart3" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretochart3').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_T33">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_T33">
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
                                        <cfoutput query="consulta_nconformidades_T33">
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

                <!-- Tabela e Gráfico para C13 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>C13</h3>
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
                                            <cfif BARREIRA eq 'C13'>
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

                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - C13</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
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
                                        <cfoutput query="consulta_nconformidades_C13">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>C13</h3>
                            <canvas id="paretochart4" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretochart4').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_C13">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_C13">
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
                                        <cfoutput query="consulta_nconformidades_C13">
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

                 <!-- Tabela e Gráfico para F05 -->
                 <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>C13</h3>
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
                                            <cfif BARREIRA eq 'F05'>
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
            
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - F05</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
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
                                        <cfoutput query="consulta_nconformidades_F05">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>F05</h3>
                            <canvas id="paretochart5" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretochart5').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_F05">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_F05">
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
                                        <cfoutput query="consulta_nconformidades_F05">
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

                <!-- Tabela e Gráfico para F10 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>F10</h3>
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
                                            <cfif BARREIRA eq 'F10'>
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
            
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - F10</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
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
                                        <cfoutput query="consulta_nconformidades_F10">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold;<cfif ESTACAO eq 'T'>color: gold;<cfelseif ESTACAO eq 'C'> color: gold;<cfelseif ESTACAO eq 'F'> color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                        <!-- Canvas para o gráfico de Pareto -->
                        <div class="col-md-4">
                            <h3>F10</h3>
                            <canvas id="paretochart6" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretochart6').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_F10">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_F10">
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
                                        <cfoutput query="consulta_nconformidades_F10">
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

                <!-- Tabela e Gráfico para F10 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>SUB MOTOR</h3>
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
                                            <cfif BARREIRA eq 'SUB MOTOR'>
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
            
                        <!-- Tabela de Pareto -->
                        <div class="col-md-4">
                            <h3>Pareto - SUB MOTOR</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades - top 5</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_submotor">
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
                            <h3>SUB MOTOR</h3>
                            <canvas id="paretochart7" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        var ctx = document.getElementById('paretochart7').getContext('2d');
                        var data = {
                            labels: [
                                <cfoutput query="consulta_nconformidades_submotor">
                                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                                </cfoutput>
                            ],
                            datasets: [
                                {
                                    label: 'Total de Defeitos',
                                    type: 'bar',
                                    data: [
                                        <cfoutput query="consulta_nconformidades_submotor">
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
                                        <cfoutput query="consulta_nconformidades_submotor">
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
                                    <th scope="col" colspan="3" class="bg-warning">Principais Não Conformidades - top 5</th>
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


  <meta http-equiv="refresh" content="40,URL=fa_indicadores_1.cfm">

  <!-- Setinha flutuante -->
  <div class="floating-arrow" onclick="scrollToTop();">
    <i class="material-icons">arrow_upward</i>
</div>

<!-- Script para voltar ao topo suavemente -->
<script>
    function scrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }
</script>
    </body>
</html>
  