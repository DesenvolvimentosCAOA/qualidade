<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!-- Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->
    <cfquery name="consulta_nconformidades_T19" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PECA, PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
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
            GROUP BY PECA, PROBLEMA
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
                COUNT(*) AS PRODUZIDOS, -- Contagem de itens produzidos
                CASE 
                    WHEN COUNT(CASE WHEN PROBLEMA IS NULL OR PROBLEMA = '' THEN 1 END) > 0 THEN 1
                    ELSE 0
                END AS APROVADO_FLAG
            FROM SISTEMA_QUALIDADE_FA
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
                PRODUZIDOS, -- Adicionando a contagem de produzidos na consulta principal
                ROUND(PRODUZIDOS / NULLIF((COUNT(VIN) - SUM(APROVADO_FLAG)), 0), 3) AS PRODUZIDOS_POR_DEFEITOS -- Cálculo de produzidos por defeitos
        FROM CONSULTA
        GROUP BY BARREIRA, HH, PRODUZIDOS
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
                SUM(PRODUZIDOS) AS PRODUZIDOS, -- Total de itens produzidos
                ROUND(SUM(PRODUZIDOS) / NULLIF((COUNT(VIN) - SUM(APROVADO_FLAG)), 0), 3) AS PRODUZIDOS_POR_DEFEITOS -- Cálculo de produzidos por defeitos
        FROM CONSULTA
        GROUP BY BARREIRA
        UNION ALL
        SELECT 
                NULL AS BARREIRA, 
                'TOTAL GERAL' AS HH, 
                COUNT(VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(VIN) * 100, 1) AS PORCENTAGEM, 
                SUM(PRODUZIDOS) AS PRODUZIDOS, -- Total geral de itens produzidos
                ROUND(SUM(PRODUZIDOS) / NULLIF((COUNT(VIN) - SUM(APROVADO_FLAG)), 0), 3) AS PRODUZIDOS_POR_DEFEITOS -- Cálculo de produzidos por defeitos
        FROM CONSULTA
    </cfquery>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicadores - 1º turno</title>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v=11"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
    </head>
    <body>
        <div class="container mt-4">
            <h1 class="text-center mb-4">Indicadores - 1º turno</h1>
            <form method="get" action="">
                <div class="form-group">
                    <label for="filtroData">Data:</label>
                    <input type="date" class="form-control" id="filtroData" name="filtroData" value="#DateFormat(url.filtroData, 'yyyy-MM-dd')#">
                </div>
                <button type="submit" class="btn btn-primary">Filtrar</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='?filtroData='">Limpar</button>
            </form>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>HH</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>Reprov</th>
                                    <th>%</th>
                                    <th>Produzido</th>
                                    <th>Problemas</th>
                                    <th>DPV</th> <!-- Adicionando a coluna de Produzidos por Problemas -->
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira" group="HH">
                                    <tr>
                                        <td>#HH#</td>
                                        <td>#PRODUZIDOS#</td> <!-- Exibindo a contagem de produzidos -->
                                        <td>#APROVADOS#</td>
                                        <td>#REPROVADOS#</td>
                                        <td>#PORCENTAGEM#%</td>
                                        <td>#REPROVADOS#</td> <!-- Contagem de problemas -->
                                        <td>#PRODUZIDOS#</td> <!-- Contagem de produzidos -->
                                        <td>#PRODUZIDOS_POR_DEFEITOS#</td> <!-- Produzidos por Problemas -->
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
