<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->

    <cfquery name="consulta_nconformidades_T30" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>
    
    <cfquery name="consulta_nconformidades_T19" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
              -- Exemplo de filtro adicional baseado na coluna INTERVALO
              -- AND INTERVALO IN ('06:00', '07:00', '08:00')  -- Substitua pelos valores reais dos intervalos que deseja filtrar
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
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
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
                    WHEN COUNT(CASE WHEN PROBLEMA IS NULL OR PROBLEMA = '' THEN 1 END) > 0 THEN 1
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                COUNT(CASE WHEN PROBLEMA IS NOT NULL THEN 1 END) AS totalProblemas
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
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>    
<!--- <cfdump var="#consulta_barreira#"> --->
    <cfquery name="consulta_nconformidades_C13" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
       WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
                AND (
                        -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                        ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                        -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                        OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                    )
                    GROUP BY PROBLEMA, PECA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_F05" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_F10" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                   ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_submotor" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA,ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
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
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, 
                   SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA,ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
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
                <!-- Tabela Pareto para T19 -->
                <div class="col-md-6">
                    <h3>Pareto - Barreira T19</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="4" class="bg-success">Principais Não Conformidades</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Responsável</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_T19">
                                    <tr class="align-middle">
                                        <td>#ESTACAO#</td>
                                        <td>#PECA#</td>
                                        <td style="font-weight: bold">#PROBLEMA#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Tabela e Gráfico para T30 -->
                <div class="col-md-6">
                    <h3>Pareto - Barreira T30</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Responsável</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_T30">
                                    <tr class="align-middle">
                                        <td>#ESTACAO#</td>
                                        <td>#PECA#</td>
                                        <td style="font-weight: bold">#PROBLEMA#</td>
                                        <td>#TOTAL_POR_DEFEITO#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
                        
                <!-- Tabela e Gráfico para Validação de Qualidade -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela de Pareto para T33 -->
                        <div class="col-md-6">
                            <h3>Pareto - Barreira T33</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Responsável</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_T33">
                                            <tr class="align-middle">
                                                <td>#ESTACAO#</td>
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
                        
                        <!-- Tabela de Pareto para C13 -->
                        <div class="col-md-6">
                            <h3>Pareto - Barreira C13</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Responsável</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_C13">
                                            <tr class="align-middle">
                                                <td>#ESTACAO#</td>
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
                
                        
                 <!-- Tabela e Gráfico para F05 -->
                 <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela de Pareto para F05 -->
                        <div class="col-md-6">
                            <h3>Pareto - Barreira F05</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-danger">Principais Não Conformidades</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Responsável</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_F05">
                                            <tr class="align-middle">
                                                <td>#ESTACAO#</td>
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
                
                        <!-- Tabela de Pareto para F10 -->
                        <div class="col-md-6">
                            <h3>Pareto - Barreira F10</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="3" class="bg-danger">Principais Não Conformidades</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Responsável</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_F10">
                                            <tr class="align-middle">
                                                <td>#ESTACAO#</td>
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
                

                <!-- Tabela e Gráfico para F10 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela de Pareto -->
                        <div class="col-md-6">
                            <h3>Pareto - Barreira SUB MOTOR</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades</th>
                                        </tr>
                                        <tr class="text-nowrap">
                                            <th scope="col">Responsável</th>
                                            <th scope="col">Estação</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_submotor">
                                            <tr class="align-middle">
                                                <td>#ESTACAO#</td>
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
   <meta http-equiv="refresh" content="40,URL=fa_indicadores_outros.cfm">
    </body>
</html>
  