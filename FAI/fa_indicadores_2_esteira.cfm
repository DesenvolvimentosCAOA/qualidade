<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta SQL para obter dados agrupados por barreira e intervalo de hora -->
    <cfquery name="consulta_nconformidades_cp7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            AND CASE 
                -- Se for até 02:00, considerar o dia anterior
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1)
                -- Senão, considerar o próprio dia
                ELSE TRUNC(USER_DATA) 
            END = CASE 
                -- Filtragem similar para o parâmetro de filtroData
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
            AND PROBLEMA IS NOT NULL
              AND BARREIRA = 'CP7'
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

    <cfquery name="consulta_nconformidades_cp7_n0" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'CP7'
            AND CRITICIDADE NOT IN ('N1', 'N2', 'N3', 'N4','AVARIA','OK A-')
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

    <cfquery name="consulta_nconformidades_cp7_AVARIA" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'CP7'
            AND CRITICIDADE NOT IN ('N1', 'N2', 'N3', 'N4','N0','OK A-')
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
                COUNT(DISTINCT VIN) AS totalVins,
                
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
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
        WHERE 
        -- Verifica o filtro de data fornecido pela URL
        CASE 
            WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) -- Considera dia anterior se for até 02:00
            ELSE TRUNC(USER_DATA) -- Considera o dia atual
        END = 
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            CASE 
                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
            END
        <cfelse>
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') <= '02:00' THEN TRUNC(SYSDATE - 1)
                ELSE TRUNC(SYSDATE)
            END
        </cfif>
        
        AND PROBLEMA IS NOT NULL
        AND BARREIRA = 'CP7'
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        
        AND (
            CASE 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
            END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00', '01:00')
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
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            AND STATUS IS NOT NULL
            AND BARREIRA = 'CP7'
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
            AND BARREIRA = 'CP7'
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
        AND BARREIRA = 'CP7'
        GROUP BY TRUNC(SYSDATE) - TRUNC(USER_DATA)
        ORDER BY DIAS_EM_REPARO
    </cfquery>

    <cfquery name="consulta_nconformidades_liberacao" datasource="#BANCOSINC#">
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
            AND BARREIRA = 'LIBERACAO'
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

    <cfquery name="consulta_barreira_liberacao" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
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
                COUNT(DISTINCT VIN) AS totalVins,
                
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
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

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
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
        <title>FA SUV CP7 Indicador-2º turno</title>
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
            <cfinclude template="/qualidade/fai/auxi/nav_links1.cfm">
        </header><br>
        <!-- Filtro de data -->
        <cfoutput>
        <div class="container">
            <h2>FA SUV CP7 2º Turno</h2>
            <form method="get" action="fa_indicadores_2_esteira.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroData" class="sr-only">Data:</label>
                    <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                </div>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fa_indicadores_2_esteira.cfm'">Limpar</button>
            </form>
        </div>
        </cfoutput>
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Primer -->
                <div class="col-md-3">
                    <h3>CP7</h3>
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
                                    <cfif BARREIRA eq 'CP7'>
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
        
                <!-- Tabela Pareto para CP7 -->
                <div class="col-md-4">
                    <h3>Pareto - CP7</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-100" border="1" id="tblStocks" data-excel-name="Veículos" style="font-size: 12px">
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
                                <cfoutput query="consulta_nconformidades_cp7">
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
                <div class="col-md-5" style="padding-left: 0;">
                    <div id="paretoChart" style="width: 100%; height: 400px;"></div>
                </div>

                <div class="container-fluid">
                    <div class="row">
                        <!-- Tabela H/H para Primer -->
                        <div class="col-md-3">
                            <h3>Liberação</h3>
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
                                        <cfoutput query="consulta_barreira_liberacao">
                                            <cfif BARREIRA eq 'LIBERACAO'>
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
                
                        <!-- Tabela Pareto para LIBERACAO -->
                        <div class="col-md-4">
                            <h3>Pareto - Liberação</h3>
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
                                        <cfoutput query="consulta_nconformidades_liberacao">
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
                        <div class="col-md-5" style="padding-left: 0;">
                            <div id="paretoChartCP7" style="width: 100%; height: 400px;"></div>
                        </div>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script>
                            google.charts.load('current', {'packages':['corechart', 'line']});
                            google.charts.setOnLoadCallback(drawParetoChartCP7);
                        
                            function drawParetoChartCP7() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Problema');
                                data.addColumn('number', 'Total de Defeitos');
                                data.addColumn('number', 'Pareto (%)');
                        
                                data.addRows([
                                    <cfoutput query="consulta_nconformidades_liberacao">
                                        ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                                    </cfoutput>
                                ]);
                        
                                var options = {
                                    title: 'Pareto - Liberação',
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
                        
                                var chart = new google.visualization.ComboChart(document.getElementById('paretoChartCP7'));
                                chart.draw(data, options);
                            }
                        </script>
                <!-- Gráfico para Pareto - CP7 -->
                <div class="container-fluid">
                    <div class="row">
                        <!-- Primeira tabela -->
                        <div class="col-md-5">
                            <h3>Pareto - CP7 N0</h3>
                            <div class="table-responsive">
                                <table style="font-size:12px" class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" style="width: 100%;" data-excel-name="Veículos" >
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
                                        <cfoutput query="consulta_nconformidades_cp7_N0">
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
                            <h3>Pareto - CP7 AVARIA</h3>
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
                                        <cfoutput query="consulta_nconformidades_cp7_AVARIA">
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
                <cfoutput query="consulta_nconformidades_cp7">
                    ['#PECA# #PROBLEMA# (#TOTAL_POR_DEFEITO#)', #TOTAL_POR_DEFEITO#, #PARETO#]<cfif currentRow neq recordCount>,</cfif>
                </cfoutput>
            ]);

            var options = {
                title: 'Pareto - CP7',
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
        

     <!---   <script type="text/javascript">
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
                                    <th>Total de VINs</th>
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
    <meta http-equiv="refresh" content="40,URL=fa_indicadores_2_esteira.cfm">
    </body>
</html>

  