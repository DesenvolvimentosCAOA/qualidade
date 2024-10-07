<!-- letreiro_com_consulta.cfm -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Letreiro com Resultados de Consulta</title>
    <style>
        .ticker {
            width: 100%;
            height: 50px;
            overflow: hidden;
            position: relative;
            background-color: #333;
            color: #fff;
            font-size: 24px;
            line-height: 50px;
        }

        .ticker .ticker-content {
            position: absolute;
            white-space: nowrap;
            animation: tickerMove 30s linear infinite;
        }

        .ticker:hover .ticker-content {
            animation-play-state: paused;
        }

        @keyframes tickerMove {
            0% { left: 100%; }
            100% { left: -100%; }
        }
    </style>
</head>
<body>
    <div class="ticker">
        <div class="ticker-content">
            <!-- Nova consulta para obter os resultados -->
            <cfquery name="consulta_nconformidades_libFinal" datasource="#BANCOSINC#">
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
                    AND BARREIRA = 'Liberação Final'
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
                        SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) AS TOTAL_ACUMULADO,
                        ROUND(SUM(TOTAL_POR_DEFEITO) OVER () * 100 / (SELECT SUM(TOTAL_POR_DEFEITO) FROM CONSULTA), 1) AS PARETO_GERAL
                    FROM CONSULTA2
                )
                SELECT PARETO_GERAL FROM CONSULTA3 WHERE ROWNUM = 1
            </cfquery>

            <!-- Exibir o resultado no letreiro -->
            <cfoutput>
                <span>
                    #consulta_nconformidades_libFinal.PARETO_GERAL#%
                </span>
            </cfoutput>

        </div>
    </div>
</body>
</html>
