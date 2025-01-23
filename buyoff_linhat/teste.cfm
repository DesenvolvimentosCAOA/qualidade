<cfquery name="consulta_barreira" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            BARREIRA, 
            BARCODE,
            MODELO,
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
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT BARCODE) AS totalVins,
            COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE TRUNC(USER_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
            AND (
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND INTERVALO BETWEEN '06:00' AND '15:00'
        GROUP BY BARREIRA, BARCODE, MODELO, INTERVALO
    )
    SELECT BARREIRA, HH, MODELO,
            COUNT(DISTINCT BARCODE) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
            1 AS ordem
    FROM CONSULTA
    GROUP BY BARREIRA, HH, MODELO
    UNION ALL
    SELECT BARREIRA, 
            'TTL' AS HH, 
            NULL AS MODELO,
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

<cfquery name="consulta_nconformidades_ecoat" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE TRUNC(USER_DATA) =
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND PROBLEMA IS NOT NULL
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'ECOAT'
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        )
        GROUP BY PROBLEMA, MODELO, ESTACAO -- Adicionado MODELO no GROUP BY
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            TOTAL_ACUMULADO,
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>

<cfquery name="consulta_nconformidades_TopCoat" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE TRUNC(USER_DATA) =
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND PROBLEMA IS NOT NULL
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Top Coat'
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        )
        GROUP BY PROBLEMA, MODELO, ESTACAO -- Adicionado MODELO no GROUP BY
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            TOTAL_ACUMULADO,
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>

<cfquery name="consulta_nconformidades_primer" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE TRUNC(USER_DATA) =
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND PROBLEMA IS NOT NULL
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Primer'
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        )
        GROUP BY PROBLEMA, MODELO, ESTACAO -- Adicionado MODELO no GROUP BY
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT 
            PROBLEMA, 
            MODELO,
            TOTAL_POR_DEFEITO, 
            TOTAL_ACUMULADO,
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
        <title>Indicadores - 1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .container-fluid {
                display: none;
            }
            .container-fluid.active {
                display: block;
            }
            .table th, .table td {
                font-size: 12px; /* Ajuste o tamanho da fonte das tabelas */
            }
            .table-container {
            margin-right: 80px; /* Espaço entre as tabelas */
            }
            h1 {
                color: red;
                text-align: center;
            }
            .arrow-btn {
                position: fixed;
                top: 50%;
                background-color: #007bff; /* Cor de fundo chamativa */
                color: white;
                border: none;
                padding: 15px;
                font-size: 30px;
                cursor: pointer;
                z-index: 9999;
                border-radius: 50%; /* Bordas arredondadas */
                transition: background-color 0.3s, transform 0.3s; /* Efeitos de transição */
            }

            .arrow-btn:hover {
                background-color: #0056b3; /* Cor de fundo no hover */
                transform: scale(1.2); /* Aumenta o tamanho ao passar o mouse */
            }

            .left {
                left: 20px; /* Distância da borda esquerda */
            }

            .right {
                right: 20px; /* Distância da borda direita */
            }
        </style>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br><br>

        <!-- Filtro de data -->
        <h2>Indicadores 1º Turno</h2>
        <div class="container">
            <form method="get" action="indicadores_paint_cor.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='indicadores_paint_cor.cfm'">Limpar</button>
            </form>
        </div>

        <button class="arrow-btn left" onclick="toggleDivs('left')">&#8592;</button>
        <button class="arrow-btn right" onclick="toggleDivs('right')">&#8594;</button>

        <div class="container-fluid" id="div1">
            <h1> E-COAT</h1>
            <div class="d-flex">
                <div class="table-container">
                    <h3 style="text-align:center;">BRANCO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:white;">
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
                                    <cfif BARREIRA eq 'ECOAT' AND REFindNoCase("BRANCO$", MODELO)>
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

                <div class="table-container">
                    <h3 style="text-align:center;">CINZA</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:grey;">
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
                                    <cfif BARREIRA eq 'ECOAT' AND REFindNoCase("CINZA$", MODELO)>
                                        <tr style="background-color:rgba(128, 128, 128, 0.7);color:black;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">PRETO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:black;color:white">
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
                                    <cfif BARREIRA eq 'ECOAT' AND REFindNoCase("PRETO$", MODELO)>
                                        <tr style="background-color:rgba(0, 0, 0, 0.7);color:white;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">AZUL</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:blue;color:white">
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
                                    <cfif BARREIRA eq 'ECOAT' AND REFindNoCase("AZUL$", MODELO)>
                                        <tr style="background-color:rgba(0, 191, 255, 0.7);color:black;">
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
            </div>

            <div class="container-fluid">
                <h1>PARETO | ECOAT</h1>
                    <div class="d-flex">
                        <div class="table-container">
                            <h3 style="text-align:center;">BRANCO</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width">
                                    <thead style="font-size:12px">
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="5" style="background-color:white; color:black;">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto (%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_ecoat">
                                        <cfif REFindNoCase("BRANCO$", MODELO)>
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">CINZA</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:grey; color:black;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:grey;color:black;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("CINZA$", MODELO)>
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">PRETO</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:black; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:black;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("PRETO$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">AZUL</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:blue; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:blue;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("AZUL$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container-fluid" id="div2">
            <h1> TOP COAT</h1>
            <div class="d-flex">
                <div class="table-container">
                    <h3 style="text-align:center;">BRANCO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:white;">
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
                                    <cfif BARREIRA eq 'Top Coat' AND REFindNoCase("BRANCO$", MODELO)>
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

                <div class="table-container">
                    <h3 style="text-align:center;">CINZA</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:grey;">
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
                                    <cfif BARREIRA eq 'Top Coat' AND REFindNoCase("CINZA$", MODELO)>
                                        <tr style="background-color:rgba(128, 128, 128, 0.7);color:black;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">PRETO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:black;color:white">
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
                                    <cfif BARREIRA eq 'Top Coat' AND REFindNoCase("PRETO$", MODELO)>
                                        <tr style="background-color:rgba(0, 0, 0, 0.7);color:white;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">AZUL</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:blue;color:white">
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
                                    <cfif BARREIRA eq 'Top Coat' AND REFindNoCase("AZUL$", MODELO)>
                                        <tr style="background-color:rgba(0, 191, 255, 0.7);color:black;">
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
            </div>

            <div class="container-fluid">
                <h1>PARETO | TOP COAT</h1>
                    <div class="d-flex">
                        <div class="table-container">
                            <h3 style="text-align:center;">BRANCO</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width">
                                    <thead style="font-size:12px">
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="5" style="background-color:white; color:black;">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto (%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_TopCoat">
                                        <cfif REFindNoCase("BRANCO$", MODELO)>
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">CINZA</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:grey; color:black;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:grey;color:black;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_TopCoat">
                                            <cfif REFindNoCase("CINZA$", MODELO)>
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">PRETO</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:black; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:black;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_TopCoat">
                                            <cfif REFindNoCase("PRETO$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">AZUL</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:blue; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:blue;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_TopCoat">
                                            <cfif REFindNoCase("AZUL$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid" id="div3">
            <h1> PRIMER</h1>
            <div class="d-flex">
                <div class="table-container">
                    <h3 style="text-align:center;">BRANCO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:white;">
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
                                    <cfif BARREIRA eq 'Primer' AND REFindNoCase("BRANCO$", MODELO)>
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

                <div class="table-container">
                    <h3 style="text-align:center;">CINZA</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:grey;">
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
                                    <cfif BARREIRA eq 'Primer' AND REFindNoCase("CINZA$", MODELO)>
                                        <tr style="background-color:rgba(128, 128, 128, 0.7);color:black;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">PRETO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:black;color:white">
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
                                    <cfif BARREIRA eq 'Primer' AND REFindNoCase("PRETO$", MODELO)>
                                        <tr style="background-color:rgba(0, 0, 0, 0.7);color:white;">
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

                <div class="table-container">
                    <h3 style="text-align:center;">AZUL</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:blue;color:white">
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
                                    <cfif BARREIRA eq 'Primer' AND REFindNoCase("AZUL$", MODELO)>
                                        <tr style="background-color:rgba(0, 191, 255, 0.7);color:black;">
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
            </div>

            <div class="container-fluid">
                <h1>PARETO | PRIMER</h1>
                    <div class="d-flex">
                        <div class="table-container">
                            <h3 style="text-align:center;">BRANCO</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom-width">
                                    <thead style="font-size:12px">
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="5" style="background-color:white; color:black;">Principais Não Conformidades - Top 5</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                        <th scope="col">Pareto (%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_ecoat">
                                        <cfif REFindNoCase("BRANCO$", MODELO)>
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">CINZA</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:grey; color:black;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:grey;color:black;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("CINZA$", MODELO)>
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">PRETO</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:black; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:black;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("PRETO$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex">
                            <div class="table-container">
                                <h3 style="text-align:center;">AZUL</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom-width">
                                        <thead style="font-size:12px">
                                        <tr class="text-nowrap">
                                            <th scope="col" colspan="5" style="background-color:blue; color:white;">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr style="background-color:blue;color:white;">
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto (%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat">
                                            <cfif REFindNoCase("AZUL$", MODELO)>
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            let currentDiv = 0;
            const divs = document.querySelectorAll('.container-fluid');
            divs[currentDiv].classList.add('active');
            console.log('Initial div:', currentDiv);

            function toggleDivs(direction) {
                console.log('Direction:', direction);
                divs[currentDiv].classList.remove('active');
                if (direction === 'left') {
                    currentDiv = (currentDiv === 0) ? divs.length - 1 : currentDiv - 1;
                } else if (direction === 'right') {
                    currentDiv = (currentDiv === divs.length - 1) ? 0 : currentDiv + 1;
                }
                console.log('New div:', currentDiv);
                divs[currentDiv].classList.add('active');
            }
        </script>
    </body>
</html>