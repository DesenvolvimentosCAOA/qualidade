<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->

    <cfquery name="consulta_totais" datasource="#BANCOSINC#">
        WITH Totais AS (
            SELECT 
                NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'CP5' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END), 0) AS CP5_TOTAL,
        
                NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'VALIDACAO' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END), 0) AS VALIDACAO_TOTAL,
        
                NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'PROCESSO' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END), 0) AS PROCESSO_TOTAL,
    
                ROUND(NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'CP5' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT BARCODE) 
                              FROM sistema_qualidade_body 
                              WHERE BARREIRA = 'CP5' 
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                                  ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                              END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                                  ELSE TRUNC(USER_DATA) 
                              END = CASE 
                                  WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                                  ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                              END), 0) * 100, 2) AS CP5_PERC,
        
                ROUND(NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'VALIDACAO' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT BARCODE) 
                              FROM sistema_qualidade_body 
                              WHERE BARREIRA = 'VALIDACAO' 
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                                  ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                              END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                                  ELSE TRUNC(USER_DATA) 
                              END = CASE 
                                  WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                                  ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                              END), 0) * 100, 2) AS VALIDACAO_PERC,
        
                ROUND(NVL((SELECT COUNT(DISTINCT BARCODE) 
                     FROM sistema_qualidade_body 
                     WHERE BARREIRA = 'PROCESSO' 
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                         ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                     END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                     AND CASE 
                         WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                         ELSE TRUNC(USER_DATA) 
                     END = CASE 
                         WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                         ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                     END
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT BARCODE) 
                              FROM sistema_qualidade_body 
                              WHERE BARREIRA = 'PROCESSO' 
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                                  ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                              END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                              AND CASE 
                                  WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                                  ELSE TRUNC(USER_DATA) 
                              END = CASE 
                                  WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                                  ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                              END), 0) * 100, 2) AS PROCESSO_PERC
        
        
            FROM DUAL)
        SELECT 
            CP5_TOTAL,
            VALIDACAO_TOTAL,
            PROCESSO_TOTAL,
            CP5_PERC,
            VALIDACAO_PERC,
            PROCESSO_PERC
        FROM Totais
    </cfquery>

    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE,
                CASE 
                    WHEN INTERVALO = '15:50' THEN '16:00~17:00'
                    WHEN INTERVALO = '16:00' THEN '16:00~17:00'
                    WHEN INTERVALO = '17:00' THEN '17:00~18:00'
                    WHEN INTERVALO = '18:00' THEN '18:00~19:00'
                    WHEN INTERVALO = '19:00' THEN '19:00~20:00'
                    WHEN INTERVALO = '20:00' THEN '20:00~21:00'
                    WHEN INTERVALO = '21:00' THEN '21:00~22:00'
                    WHEN INTERVALO = '22:00' THEN '22:00~23:00'
                    WHEN INTERVALO = '23:00' THEN '23:00~00:00'
                    WHEN INTERVALO = '00:00' THEN '00:00~01:00'
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
                COUNT(DISTINCT BARCODE) AS totalVins,
                
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_body
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, BARCODE, INTERVALO
        )
        SELECT BARREIRA, HH, 
                COUNT(DISTINCT BARCODE) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
                
                -- Cálculo do DPV: total de VINs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
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

    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.sistema_qualidade_body
            WHERE 
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
                    ELSE TRUNC(USER_DATA) 
                END = CASE 
                    WHEN SUBSTR('#url.filtroData#', 12, 5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                    ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                END
                AND PROBLEMA IS NOT NULL
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
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
            AND CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '05:00' THEN TRUNC(USER_DATA - 1) 
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '05:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
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

    <cfquery name="consulta_nconformidades_validacao" datasource="#BANCOSINC#">
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
              AND BARREIRA = 'VALIDACAO'
              AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
              AND (
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
            AND CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '05:00' THEN TRUNC(USER_DATA - 1) 
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '05:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
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
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
            AND CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '05:00' THEN TRUNC(USER_DATA - 1) 
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '05:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
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
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
            AND CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '05:00' THEN TRUNC(USER_DATA - 1) 
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '05:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
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
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
            AND CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '05:00' THEN TRUNC(USER_DATA - 1) 
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '05:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
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
    
   <!-- Verificando se está logado -->
   <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
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
        <title>Indicadores - 2º turno</title>
        <link rel="icon" href="/cf/auth/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v=11"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .ticker {
                    width: 10%;
                    height: 50px;
                    overflow: hidden;
                    position: relative;
                    background-color: #f0f0f0; /* Fundo cinza */
                    border: 1px solid #ddd;
                    box-sizing: border-box;
                }

                .ticker .ticker-content {
                    position: absolute;
                    white-space: nowrap;
                    display: inline-block;
                    animation: tickerMove 15s linear infinite; /* Reduzido o tempo para aumentar a velocidade */
                    /* Ajusta a largura da tabela */
                    width: auto;
                    box-sizing: border-box;
                }
                .ticker:hover .ticker-content {
                    animation-play-state: paused;
        }

                @keyframes tickerMove {
                    0% { transform: translateX(100%); }
                    100% { transform: translateX(-100%); }
                }
          </style>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="/cf/auth/qualidade/fai/auxi/nav_links1.cfm">
        </header><br><br><br>

        <cfif IsNumeric(consulta_totais.CP5_PERC) AND IsNumeric(consulta_totais.VALIDACAO_PERC) AND IsNumeric(consulta_totais.PROCESSO_PERC)>
            <cfset resultadoFinal = 1>
            <cfif consulta_totais.CP5_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.CP5_PERC / 100)>
            </cfif>
            <cfif consulta_totais.VALIDACAO_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.VALIDACAO_PERC / 100)>
            </cfif>
            <cfif consulta_totais.PROCESSO_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.PROCESSO_PERC / 100)>
            </cfif>
            <cfset resultadoFinal = NumberFormat(resultadoFinal * 100, "9,999,999.00")>
        <cfelse>
            <cfset resultadoFinal = "Sem dados suficientes"> <!-- ou qualquer valor padrão que você queira usar -->
        </cfif>
        
        <div class="ticker">
            <div class="ticker-content">
                <cfoutput query="consulta_totais">
                    <table border="1" cellpadding="5" cellspacing="0">
                        <tbody>
                            <tr>
                                <td><strong>DRR</strong></td>
                                <td colspan="2"><strong>#resultadoFinal#%</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </cfoutput>
            </div>
        </div>

        <!-- Filtro de data -->
        <div class="container">
            <h2>BODY - Indicadores 2º Turno</h2>
            <form method="get" action="body_indicadores_2turno.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='body_indicadores_2turno.cfm'">Limpar</button>
            </form>
        </div>
      
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para CP5 -->
                <div class="col-md-4">
                    <h3>CP5</h3>
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
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                                <cfoutput query="consulta_nconformidades_cp5">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        
                <!-- Gráfico para Pareto - CP5 -->
                <div class="col-md-4">
                    <h3>CP5</h3>
                    <canvas id="paretoChart" width="600" height="300"></canvas>
                </div>
            </div>
        </div>
        
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_cp5">
                            '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_cp5">
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
                                <cfoutput query="consulta_nconformidades_cp5">
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

        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para validacao -->
                <div class="col-md-4">
                    <h3 style="margin-left:50px">Validação</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-75">
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
                                    <cfif BARREIRA eq 'VALIDACAO'>
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
                <!-- Tabela Pareto para VALIDAÇÃO-->
                <div class="col-md-4">
                    <h3>Pareto - VALIDAÇÃO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                                <cfoutput query="consulta_nconformidades_validacao">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                <!-- Gráfico para Pareto - CP5 -->
                <div class="col-md-4 move-left">
                    <h3>VALIDAÇÃO</h3>
                    <canvas id="paretoChart1" width="600" height="300"></canvas>
                </div>
            </div>
        </div><br><br>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart1').getContext('2d');
                var data = {
                    labels: [
                        <cfoutput query="consulta_nconformidades_validacao">
                            '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                        </cfoutput>
                    ],
                    datasets: [
                        {
                            label: 'Total de Defeitos',
                            type: 'bar',
                            data: [
                                <cfoutput query="consulta_nconformidades_validacao">
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
                                <cfoutput query="consulta_nconformidades_validacao">
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


        <div class="container-fluid">
        <div class="row">
        <!-- Tabela H/H para validacao -->
        <div class="col-md-4">
            <h3 style="margin-left:50px">Processo</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm w-75">
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
        <!-- Tabela Pareto para VALIDAÇÃO-->
        <div class="col-md-4">
            <h3>Pareto - PROCESSO</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                        <cfoutput query="consulta_nconformidades_processo">
                            <tr class="align-middle">
                                <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        <!-- Gráfico para Pareto - CP5 -->
        <div class="col-md-4 move-left">
            <h3>Processo</h3>
            <canvas id="paretoChart2" width="600" height="300"></canvas>
        </div>
        </div>
        </div><br><br>

        <script>
        document.addEventListener("DOMContentLoaded", function() {
        var ctx = document.getElementById('paretoChart2').getContext('2d');
        var data = {
            labels: [
                <cfoutput query="consulta_nconformidades_processo">
                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                </cfoutput>
            ],
            datasets: [
                {
                    label: 'Total de Defeitos',
                    type: 'bar',
                    data: [
                        <cfoutput query="consulta_nconformidades_processo">
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
                        <cfoutput query="consulta_nconformidades_processo">
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

<div class="container-fluid">
    <div class="row">
        <!-- Tabela H/H para CP5 2 -->
        <div class="col-md-4">
            <h3 style="margin-left:50px">CHASSI</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm w-75">
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
        <!-- Tabela Pareto para CP5 2 -->
        <div class="col-md-4">
            <h3>Pareto - CHASSI</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                        <cfoutput query="consulta_nconformidades_chassi">
                            <tr class="align-middle">
                                <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        <!-- Gráfico para Pareto - CP5 -->
        <div class="col-md-4 move-left">
            <h3>CHASSI</h3>
            <canvas id="paretoChart5" width="600" height="300"></canvas>
        </div>
    </div>
</div><br><br>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var ctx = document.getElementById('paretoChart5').getContext('2d');
        var data = {
            labels: [
                <cfoutput query="consulta_nconformidades_chassi">
                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                </cfoutput>
            ],
            datasets: [
                {
                    label: 'Total de Defeitos',
                    type: 'bar',
                    data: [
                        <cfoutput query="consulta_nconformidades_chassi">
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
                        <cfoutput query="consulta_nconformidades_chassi">
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

<div class="container-fluid">
    <div class="row">
        <!-- Tabela H/H para CP5 2 -->
        <div class="col-md-4">
            <h3 style="margin-left:50px">HR</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm w-75">
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
        <!-- Tabela Pareto para CP5 2 -->
        <div class="col-md-4">
            <h3>Pareto - HR</h3>
            <div class="table-responsive">
                <table class="table table-hover table-sm table-custom-width move-left-table" border="1" id="tblStocks" data-excel-name="Veículos">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col" colspan="5" class="bg-success">Principais Não Conformidades - Top 5</th>
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
                        <cfoutput query="consulta_nconformidades_hr">
                            <tr class="align-middle">
                                <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
        <!-- Gráfico para Pareto - CP5 -->
        <div class="col-md-4 move-left">
            <h3>HR</h3>
            <canvas id="paretoChart6" width="600" height="300"></canvas>
        </div>
    </div>
</div><br><br>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var ctx = document.getElementById('paretoChart6').getContext('2d');
        var data = {
            labels: [
                <cfoutput query="consulta_nconformidades_hr">
                    '#PROBLEMA# (#TOTAL_POR_DEFEITO#)'<cfif currentRow neq recordCount>,</cfif>
                </cfoutput>
            ],
            datasets: [
                {
                    label: 'Total de Defeitos',
                    type: 'bar',
                    data: [
                        <cfoutput query="consulta_nconformidades_hr">
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
                        <cfoutput query="consulta_nconformidades_hr">
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
                <div class="col-md-5">
                    <h3>Pareto das Não Conformidades</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col" colspan="5" class="bg-warning">Principais Não Conformidades - Top 5</th>
                                </tr>
                                <tr class="text-nowrap">
                                    <th scope="col">Shop</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Pareto (%)</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfoutput query="consulta_nconformidades">
                                    <tr class="align-middle">
                                        <td style="font-weight: bold;<cfif ESTACAO eq 'TRIM'>color: gold;<cfelseif ESTACAO eq 'Paint'> color: orange;<cfelseif ESTACAO eq 'BODY'>color: blue;<cfelseif ESTACAO eq 'CKD'>color: green;</cfif>">#ESTACAO#</td>
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
                <div class="col-md-6">
                    <div class="container">
                        <h3>Pareto Geral Buy Off's</h3>
                        <canvas id="paretoChart3"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <!-- Script para o gráfico de Pareto -->
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var ctx = document.getElementById('paretoChart3').getContext('2d');
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
   <meta http-equiv="refresh" content="40,URL=body_indicadores_2turno.cfm">
    </body>
</html>
  