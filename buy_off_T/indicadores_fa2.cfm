<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>
    
    <!-- Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->
    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            BARREIRA, VIN,
            CASE 
                WHEN INTERVALO = '16:00' THEN '01'
                WHEN INTERVALO = '17:00' THEN '02'
                WHEN INTERVALO = '18:00' THEN '03'
                WHEN INTERVALO = '19:00' THEN '04'
                WHEN INTERVALO = '20:00' THEN '05'
                WHEN INTERVALO = '21:00' THEN '06'
                WHEN INTERVALO = '22:00' THEN '07'
                WHEN INTERVALO = '23:00' THEN '08'
                WHEN INTERVALO = '00:00' THEN '09'
                WHEN INTERVALO = '01:00' THEN '10'
            END HH,
            CASE 
                WHEN COUNT(CASE WHEN PROBLEMA IS NULL OR PROBLEMA = '' THEN 1 END) > 0 THEN 1
                ELSE 0
            END AS APROVADO_FLAG
        FROM SISTEMA_QUALIDADE_FA
        WHERE TRUNC(USER_DATA) = 
            <cfqueryparam cfsqltype="CF_SQL_DATE" value="#url.filtroData#">
            AND (
                -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
            )
        GROUP BY BARREIRA, VIN, INTERVALO
    )
    SELECT BARREIRA, HH, 
           COUNT(VIN) AS TOTAL, 
           SUM(APROVADO_FLAG) AS APROVADOS, 
           COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
           ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
           1 AS ordem
    FROM CONSULTA
    WHERE HH IS NOT NULL
    GROUP BY BARREIRA, HH
    UNION ALL
    SELECT BARREIRA, 
           'TTL' AS HH, 
           COUNT(VIN) AS TOTAL, 
           SUM(APROVADO_FLAG) AS APROVADOS, 
           COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
           ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
           2 AS ordem
    FROM CONSULTA
    WHERE HH IS NOT NULL
    GROUP BY BARREIRA

    ORDER BY ordem, HH
</cfquery>

    
    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA PAINT
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND PROBLEMA IS NOT NULL
                AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
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
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT CONSULTA3.*, 
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_nconformidades_primer" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'Primer'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
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

    <cfquery name="consulta_nconformidades_TopCoat" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'Top Coat'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
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

    <cfquery name="consulta_nconformidades_val" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'Validação de Qualidade'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
                )
            -- Exemplo de filtro adicional baseado na coluna INTERVALO
            -- AND INTERVALO IN ('06:00', '07:00', '08:00')  -- Substitua pelos valores reais dos intervalos que deseja filtrar
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

    <cfquery name="consulta_nconformidades_lib" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'Liberação Final'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
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

    <cfquery name="consulta_nconformidades_libFinal" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'Liberação Final'
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 15:50 e termina às 01:02 do dia seguinte
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '15:50:00' AND '23:59:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '3' AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '01:02:00')))
                    -- Sexta-feira: turno inicia às 14:48 e termina às 23:17
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '14:48:00' AND '23:17:00'))
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

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
    
    <html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicadores - 2º turno</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Seus arquivos CSS personalizados -->
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <link rel="stylesheet" href="assets/custom.css">
        <!-- Ícones Material -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <!-- Biblioteca Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <!-- Header com as imagens e o menu-->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
        <h2>Indicadores 2º Turno</h2>
        <!-- Filtro de data -->
        <div class="container">
            <form method="get" action="indicadores_fa2.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='indicadores_fa2.cfm'">Limpar</button>
            </form>
        </div>
      
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela e Gráfico para Primer -->
                <div class="col-md-6">
                    <h3>Primer</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead class="bg-success">
                                <tr>
                                    <th>H/H</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>%</th>
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
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-md-6">
                    <h3>Pareto - Primer</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="3" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                
                
                <!-- Tabela e Gráfico para Top Coat -->
                <div class="col-md-6">
                    <h3>Top Coat</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead class="bg-danger">
                                <tr>
                                    <th>H/H</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>%</th>
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
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-md-6">
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
                
                <!-- Tabela e Gráfico para Validação de Qualidade -->
                <div class="col-md-6">
                    <h3>Validação de Qualidade</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead class="bg-primary">
                                <tr>
                                    <th>H/H</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>%</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'Validação de Qualidade'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td>#PORCENTAGEM#%</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <h3>Pareto - Validação de Qualidade</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="3" class="bg-primary">Principais Não Conformidades - Top 10</th>
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
                
                <!-- Tabela e Gráfico para Liberação Final -->
                <div class="col-md-6">
                    <h3>Liberação Final</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead class="bg-warning">
                                <tr>
                                    <th>H/H</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>%</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif BARREIRA eq 'Liberação Final'>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td>#PORCENTAGEM#%</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-md-6">
                    <h3>Pareto - Liberação Final</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="3" class="bg-warning">Principais Não Conformidades - Top 10</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto (%)</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades_libFinal">
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
                
                <!-- Tabela e Gráfico de Pareto das Não Conformidades -->
                <div class="col-md-6">
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
                        <canvas id="paretoChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </body>
    </html>
    
  
        <!-- Script para o gráfico de Pareto -->
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart').getContext('2d');
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
  <meta http-equiv="refresh" content="40,URL=indicadores_fa2.cfm">
    </body>
</html>
  