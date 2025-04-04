﻿<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->
    <cfquery name="consulta_totais" datasource="#BANCOSINC#">
        WITH Totais AS (
            SELECT 
                NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'UNDER BODY' 
                     AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) AS UNDER_BODY_TOTAL,
        
                NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'ROAD TEST' 
                     AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) AS ROAD_TEST_TOTAL,
        
                NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'SHOWER' 
                     AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) AS SHOWER_TOTAL,
        
                NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'SIGN OFF' 
                     AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) AS SIGN_OFF_TOTAL,
        
                ROUND(NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'UNDER BODY' 
                     AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT VIN) 
                              FROM sistema_qualidade_fai 
                              WHERE BARREIRA = 'UNDER BODY' 
                              AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                              AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) * 100, 2) AS UNDER_BODY_PERC,
        
                ROUND(NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'ROAD TEST' 
                     AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT VIN) 
                              FROM sistema_qualidade_fai 
                              WHERE BARREIRA = 'ROAD TEST' 
                              AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                              AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) * 100, 2) AS ROAD_TEST_PERC,
        
                ROUND(NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'SHOWER' 
                     AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT VIN) 
                              FROM sistema_qualidade_fai 
                              WHERE BARREIRA = 'SHOWER' 
                              AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                              AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) * 100, 2) AS SHOWER_PERC,
        
                ROUND(NVL((SELECT COUNT(DISTINCT VIN) 
                     FROM sistema_qualidade_fai 
                     WHERE BARREIRA = 'SIGN OFF' 
                     AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
                     AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'
                     AND (PROBLEMA IS NULL OR CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-')), 0) /
                      NULLIF((SELECT COUNT(DISTINCT VIN) 
                              FROM sistema_qualidade_fai 
                              WHERE BARREIRA = 'SIGN OFF' 
                              AND TRUNC(USER_DATA) = <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                              AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '06:00' AND '15:00'), 0) * 100, 2) AS SIGN_OFF_PERC
        
            FROM DUAL
        )
        SELECT 
            UNDER_BODY_TOTAL,
            ROAD_TEST_TOTAL,
            SHOWER_TOTAL,
            SIGN_OFF_TOTAL,
            UNDER_BODY_PERC,
            ROAD_TEST_PERC,
            SHOWER_PERC,
            SIGN_OFF_PERC
        FROM Totais
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
            FROM INTCOLDFUSION.sistema_qualidade_fai
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
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

    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND PROBLEMA IS NOT NULL
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

    <cfquery name="consulta_nconformidades_underbody2" datasource="#BANCOSINC#">
         WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'UNDER BODY'
            AND CRITICIDADE NOT IN ('OK A-')
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

    <cfquery name="consulta_nconformidades_roadtest" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'ROAD TEST'
            
            AND CRITICIDADE NOT IN ('OK A-')
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
    <cfquery name="consulta_nconformidades_shower" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'SHOWER'
              AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
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

    <cfquery name="consulta_nconformidades_exok" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'SIGN OFF'
            AND CRITICIDADE NOT IN ('OK A-','N0','AVARIA')
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

    <cfquery name="consulta_nconformidades_reinspecao" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'TUNEL DE LIBERACAO'
            AND CRITICIDADE NOT IN ('OK A-')
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

    <cfquery name="consulta_criticidade" datasource="#BANCOSINC#">
        SELECT 
            CRITICIDADE, 
            MODELO, 
            COUNT(*) AS TOTAL_POR_CRITICIDADE_MODELO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE TRUNC(USER_DATA) =
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND PROBLEMA IS NOT NULL
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
        )
        GROUP BY CRITICIDADE, MODELO
        ORDER BY CRITICIDADE, MODELO
    </cfquery>

    <cfquery name="consulta_nconformidades_cp8_n0" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND BARREIRA = 'SIGN OFF'
            AND CRITICIDADE NOT IN ('N1', 'N2', 'N3', 'N4','AVARIA','OK A-')
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
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

<cfquery name="consulta_barreira_reparo" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            BARREIRA, 
            VIN,
            MIN(CASE 
                WHEN INTERVALO_REPARO = '06:00' THEN '06:00~07:00'
                WHEN INTERVALO_REPARO = '07:00' THEN '07:00~08:00'
                WHEN INTERVALO_REPARO = '08:00' THEN '08:00~09:00'
                WHEN INTERVALO_REPARO = '09:00' THEN '09:00~10:00'
                WHEN INTERVALO_REPARO = '10:00' THEN '10:00~11:00'
                WHEN INTERVALO_REPARO = '11:00' THEN '11:00~12:00'
                WHEN INTERVALO_REPARO = '12:00' THEN '12:00~13:00'
                WHEN INTERVALO_REPARO = '13:00' THEN '13:00~14:00'
                WHEN INTERVALO_REPARO = '14:00' THEN '14:00~15:00'
                WHEN INTERVALO_REPARO = '15:00' THEN '15:00~16:00'
                ELSE 'OUTROS'
            END) AS HH
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE TRUNC(REPARO_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
            AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
        GROUP BY BARREIRA, VIN
    )
    SELECT BARREIRA, HH, 
           COUNT(VIN) AS TOTAL, 
           1 AS ordem
    FROM CONSULTA
    GROUP BY BARREIRA, HH
    UNION ALL
    SELECT BARREIRA, 
           'TTL' AS HH, 
           COUNT(VIN) AS TOTAL, 
           2 AS ordem
    FROM CONSULTA
    GROUP BY BARREIRA
    ORDER BY ordem, HH
</cfquery>
<cfquery name="consulta_nconformidades_shower_reparo" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
    SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE TRUNC(REPARO_DATA) =
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            #CreateODBCDate(url.filtroData)#
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
    AND PROBLEMA_REPARO IS NOT NULL
    AND BARREIRA = 'SHOWER'
    AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
    GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
    ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>
<cfquery name="consulta_nconformidades_pista_reparo" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
    SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE TRUNC(REPARO_DATA) =
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            #CreateODBCDate(url.filtroData)#
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
    AND PROBLEMA_REPARO IS NOT NULL
    AND BARREIRA = 'ROAD TEST'
    AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
    GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
    ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>
<cfquery name="consulta_nconformidades_ub2_reparo" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
    SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, COUNT(*) AS TOTAL_POR_DEFEITO
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE TRUNC(REPARO_DATA) =
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            #CreateODBCDate(url.filtroData)#
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
    AND PROBLEMA_REPARO IS NOT NULL
    AND BARREIRA = 'UNDER BODY'
    AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
    GROUP BY PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO
    ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA_REPARO) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
    ),
    CONSULTA3 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT PROBLEMA_REPARO, PECA_REPARO, RESPONSAVEL_REPARO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>

    <!-- Verificando se está logado -->
    <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/qualidade/buyoff_linhat/index.cfm'
        </script>
    </cfif>
    
<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>FAI Indicador-1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
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
                .table-custom {
                    font-size: 12px;
                    border-collapse: separate;
                    border-spacing: 0;
                    width: 100%;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0px 2px 8px rgba(0, 0, 0, 0.1);
                }

                .table-custom thead {
                    background-color: #198754; /* Verde sucesso */
                    color: white;
                    text-align: center;
                }

                .table-custom th,
                .table-custom td {
                    padding: 8px;
                    text-align: center;
                    border-bottom: 1px solid #ddd;
                }

                .table-custom tbody tr:hover {
                    background-color: #f1f1f1;
                }

                /* Personalizando cores da segunda tabela */
                .table-custom tbody td:first-child {
                    font-weight: bold;
                }

                .table-custom tbody td[colspan="5"] {
                    background-color: #198754;
                    color: white;
                    font-weight: bold;
                }

                /* Cores condicionais */
                .table-custom .percentage {
                    font-weight: bold;
                }

                .table-custom .percentage.green {
                    color: green;
                }

                .table-custom .percentage.red {
                    color: red;
                }

                /* Cores para a coluna "Estação" */
                .table-custom .station-gold {
                    color: gold;
                    font-weight: bold;
                }

                .table-custom .station-orange {
                    color: orange;
                    font-weight: bold;
                }

                .table-custom .station-blue {
                    color: blue;
                    font-weight: bold;
                }

                .table-custom .station-green {
                    color: green;
                    font-weight: bold;
                }

        </style>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br>
        
        <cfif IsNumeric(consulta_totais.UNDER_BODY_PERC) AND IsNumeric(consulta_totais.ROAD_TEST_PERC) AND IsNumeric(consulta_totais.SHOWER_PERC) AND IsNumeric(consulta_totais.SIGN_OFF_PERC)>
            <cfset resultadoFinal = 1>
            <cfif consulta_totais.UNDER_BODY_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.UNDER_BODY_PERC / 100)>
            </cfif>
            <cfif consulta_totais.ROAD_TEST_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.ROAD_TEST_PERC / 100)>
            </cfif>
            <cfif consulta_totais.SHOWER_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.SHOWER_PERC / 100)>
            </cfif>
            <cfif consulta_totais.SIGN_OFF_PERC NEQ 0>
                <cfset resultadoFinal = resultadoFinal * (consulta_totais.SIGN_OFF_PERC / 100)>
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
            <h2>FAI - Indicadores 1º Turno</h2>
            <form method="get" action="fai_indicadores_1turno.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                </div>
                <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fai_indicadores_1turno.cfm'">Limpar</button>
            </form>
        </div>
        
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Under Body 2 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela ub2 -->
                        <div class="col-md-3">
                            <h3>H/H UB2 Inspeção</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom">
                                    <thead>
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
                                            <cfif BARREIRA eq 'UNDER BODY'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td class="percentage <cfif PORCENTAGEM gt '86.0'>green<cfelseif PORCENTAGEM lt '86.0'>red</cfif>">
                                                        #PORCENTAGEM#%
                                                    </td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela Pareto - Shower -->
                        <div class="col-md-3">
                            <h3>Top 5 UB2 Inspeção</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_underbody2">
                                            <tr>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela UB2 Reparo -->
                        <div class="col-md-3">
                            <h3 style="color:red;">H/H UB2 Reparo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom">
                                    <thead>
                                        <tr>
                                            <th>H/H</th>
                                            <th>Qtd Reparados</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira_reparo">
                                            <cfif BARREIRA eq 'UNDER BODY'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela Pareto - UB2 Reparo -->
                        <div class="col-md-3">
                            <h3 style="color:red;">Top 5 - UB2 Reparo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_ub2_reparo">
                                            <tr>
                                                <td class="<cfif RESPONSAVEL_REPARO eq 'TRIM'>station-gold
                                                            <cfelseif RESPONSAVEL_REPARO eq 'Paint'>station-orange
                                                            <cfelseif RESPONSAVEL_REPARO eq 'BODY'>station-blue
                                                            <cfelseif RESPONSAVEL_REPARO eq 'CKD'>station-green</cfif>">
                                                    #RESPONSAVEL_REPARO#
                                                </td>
                                                <td>#PECA_REPARO#</td>
                                                <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>



                <!-- Tabela e Gráfico para Road Test -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela Pista -->
                        <div class="col-md-3">
                            <h3>H/H Pista Inspeção</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom">
                                    <thead>
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
                                            <cfif BARREIRA eq 'ROAD TEST'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td class="percentage <cfif PORCENTAGEM gt '86.0'>green<cfelseif PORCENTAGEM lt '86.0'>red</cfif>">
                                                        #PORCENTAGEM#%
                                                    </td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela Pareto - Pista -->
                        <div class="col-md-3">
                            <h3>Top 5 Pista Inspeção</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_roadtest">
                                            <tr>
                                                <td>#PECA#</td>
                                                <td style="font-weight: bold">#PROBLEMA#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela Pista Reparo -->
                        <div class="col-md-3">
                            <h3 style="color:red;">H/H Pista Reparo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom">
                                    <thead>
                                        <tr>
                                            <th>H/H</th>
                                            <th>Qtd Reparados</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_barreira_reparo">
                                            <cfif BARREIRA eq 'ROAD TEST'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                
                        <!-- Tabela Pareto - Pista Reparo -->
                        <div class="col-md-3">
                            <h3 style="color:red;">Top 5 - Pista Reparo</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_pista_reparo">
                                            <tr>
                                                <td class="<cfif RESPONSAVEL_REPARO eq 'TRIM'>station-gold
                                                            <cfelseif RESPONSAVEL_REPARO eq 'Paint'>station-orange
                                                            <cfelseif RESPONSAVEL_REPARO eq 'BODY'>station-blue
                                                            <cfelseif RESPONSAVEL_REPARO eq 'CKD'>station-green</cfif>">
                                                    #RESPONSAVEL_REPARO#
                                                </td>
                                                <td>#PECA_REPARO#</td>
                                                <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                                <td>#TOTAL_POR_DEFEITO#</td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Tabela e Gráfico para Shower -->
                    <div class="container-fluid">
                        <div class="row">
                            <!-- Tabela Shower -->
                            <div class="col-md-3">
                                <h3>H/H Shower Inspeção</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom">
                                        <thead>
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
                                                <cfif BARREIRA eq 'SHOWER'>
                                                    <tr>
                                                        <td>#HH#</td>
                                                        <td>#TOTAL#</td>
                                                        <td>#APROVADOS#</td>
                                                        <td class="percentage <cfif PORCENTAGEM gt '86.0'>green<cfelseif PORCENTAGEM lt '86.0'>red</cfif>">
                                                            #PORCENTAGEM#%
                                                        </td>
                                                        <td>#DPV#</td>
                                                    </tr>
                                                </cfif>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                    
                            <!-- Tabela Pareto - Shower -->
                            <div class="col-md-3">
                                <h3>Top 5 Shower Inspeção</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                        <thead>
                                            <tr>
                                                <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                            </tr>
                                            <tr>
                                                <th scope="col">Peça</th>
                                                <th scope="col">Problema</th>
                                                <th scope="col">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_nconformidades_shower">
                                                <tr>
                                                    <td>#PECA#</td>
                                                    <td style="font-weight: bold">#PROBLEMA#</td>
                                                    <td>#TOTAL_POR_DEFEITO#</td>
                                                </tr>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                    
                            <!-- Tabela Shower Reparo -->
                            <div class="col-md-3">
                                <h3 style="color:red;">H/H Shower Reparo</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom">
                                        <thead>
                                            <tr>
                                                <th>H/H</th>
                                                <th>Qtd Reparados</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_barreira_reparo">
                                                <cfif BARREIRA eq 'SHOWER'>
                                                    <tr>
                                                        <td>#HH#</td>
                                                        <td>#TOTAL#</td>
                                                    </tr>
                                                </cfif>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                    
                            <!-- Tabela Pareto - Shower Reparo -->
                            <div class="col-md-3">
                                <h3 style="color:red;">Top 5 - Shower Reparo</h3>
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                        <thead>
                                            <tr>
                                                <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                            </tr>
                                            <tr>
                                                <th scope="col">Shop</th>
                                                <th scope="col">Peça</th>
                                                <th scope="col">Problema</th>
                                                <th scope="col">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfoutput query="consulta_nconformidades_shower_reparo">
                                                <tr>
                                                    <td class="<cfif RESPONSAVEL_REPARO eq 'TRIM'>station-gold
                                                                <cfelseif RESPONSAVEL_REPARO eq 'Paint'>station-orange
                                                                <cfelseif RESPONSAVEL_REPARO eq 'BODY'>station-blue
                                                                <cfelseif RESPONSAVEL_REPARO eq 'CKD'>station-green</cfif>">
                                                        #RESPONSAVEL_REPARO#
                                                    </td>
                                                    <td>#PECA_REPARO#</td>
                                                    <td style="font-weight: bold">#PROBLEMA_REPARO#</td>
                                                    <td>#TOTAL_POR_DEFEITO#</td>
                                                </tr>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                <!-- Tabela e Gráfico para SIGN OFF -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H -->
                        <div class="col-md-4">
                            <h3>Sign Off</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom">
                                    <thead>
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
                                            <cfif BARREIRA eq 'SIGN OFF'>
                                                <tr>
                                                    <td>#HH#</td>
                                                    <td>#TOTAL#</td>
                                                    <td>#APROVADOS#</td>
                                                    <td class="percentage <cfif PORCENTAGEM gt '86.0'>green<cfelseif PORCENTAGEM lt '86.0'>red</cfif>">
                                                        #PORCENTAGEM#%
                                                    </td>
                                                    <td>#DPV#</td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Tabela Pareto para Under Body 2 -->
                        <div class="col-md-4">
                            <h3>Top 5 - Sign Off</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_exok">
                                            <tr>
                                                <td class="<cfif ESTACAO eq 'TRIM'>station-gold
                                                            <cfelseif ESTACAO eq 'Paint'>station-orange
                                                            <cfelseif ESTACAO eq 'BODY'>station-blue
                                                            <cfelseif ESTACAO eq 'CKD'>station-green</cfif>">
                                                    #ESTACAO#
                                                </td>
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

                        
                        <div class="col-md-4">
                            <h3>Top 10 - Sign Off N0</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="5">Principais Não Conformidades - Top 10</th>
                                        </tr>
                                        <tr>
                                            <th scope="col">Shop</th>
                                            <th scope="col">Peça</th>
                                            <th scope="col">Problema</th>
                                            <th scope="col">Total</th>
                                            <th scope="col">Pareto</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="consulta_nconformidades_cp8_N0">
                                            <tr>
                                                <td class="<cfif ESTACAO eq 'TRIM'>station-gold
                                                            <cfelseif ESTACAO eq 'Paint'>station-orange
                                                            <cfelseif ESTACAO eq 'BODY'>station-blue
                                                            <cfelseif ESTACAO eq 'CKD'>station-green</cfif>">
                                                    #ESTACAO#
                                                </td>
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

                        <div class="container-fluid">
                            <div class="row">
                                <!-- Tabela H/H -->
                                <div class="col-md-4">
                                    <h3>Túnel de Liberação</h3>
                                    <div class="table-responsive">
                                        <table class="table table-hover table-sm table-custom">
                                            <thead>
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
                                                    <cfif BARREIRA eq 'TUNEL DE LIBERACAO'>
                                                        <tr>
                                                            <td>#HH#</td>
                                                            <td>#TOTAL#</td>
                                                            <td>#APROVADOS#</td>
                                                            <td class="percentage <cfif PORCENTAGEM gt '86.0'>green<cfelseif PORCENTAGEM lt '86.0'>red</cfif>">
                                                                #PORCENTAGEM#%
                                                            </td>
                                                            <td>#DPV#</td>
                                                        </tr>
                                                    </cfif>
                                                </cfoutput>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <h3>Top 5 - Túnel de Liberação</h3>
                                    <div class="table-responsive">
                                        <table class="table table-hover table-sm table-custom" id="tblStocks" data-excel-name="Veículos">
                                            <thead>
                                                <tr>
                                                    <th scope="col" colspan="5">Principais Não Conformidades - Top 5</th>
                                                </tr>
                                                <tr>
                                                    <th scope="col">Shop</th>
                                                    <th scope="col">Peça</th>
                                                    <th scope="col">Problema</th>
                                                    <th scope="col">Total</th>
                                                    <th scope="col">Pareto</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfoutput query="consulta_nconformidades_reinspecao">
                                                    <tr>
                                                        <td class="<cfif ESTACAO eq 'TRIM'>station-gold
                                                                    <cfelseif ESTACAO eq 'Paint'>station-orange
                                                                    <cfelseif ESTACAO eq 'BODY'>station-blue
                                                                    <cfelseif ESTACAO eq 'CKD'>station-green</cfif>">
                                                            #ESTACAO#
                                                        </td>
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

                <!-- Tabela e Gráfico de Pareto das Não Conformidades -->
                                <div class="container-fluid">
                                    <div class="row">
                                    <div class="col-md-5">
                                        <h3>Pareto das Não Conformidades</h3>
                                        <div class="table-responsive">
                                            <table style="font-size:12px;" class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
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
                                </div>
                            </div>
                        </div>      

    <meta http-equiv="refresh" content="40,URL=fai_indicadores_1turno.cfm">

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
    