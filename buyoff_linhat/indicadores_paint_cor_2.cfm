<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

<!--- branco --->
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
                -- Verifica se o BARCODE só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                
                -- Verifica se o BARCODE contém N1, N2, N3 ou N4 (Reprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0

                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT BARCODE) AS totalVins,

            -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
            COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
        = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
        ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
        AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
        AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
        GROUP BY BARREIRA, BARCODE, INTERVALO
    )
    SELECT BARREIRA, HH, 
            COUNT(DISTINCT BARCODE) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
            
            -- Cálculo do DPV: total de BARCODEs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
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
<cfquery name="consulta_nconformidades_ecoat" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'ECOAT'
            AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
            AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_primer" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'Primer'
            AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
            AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_topcoat" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'Top Coat'
            AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
            AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_validacao" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'Validacao'
            AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
            AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_cp6" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'CP6'
            AND (MODELO LIKE '%WAP' OR MODELO LIKE '%BRANCO' OR MODELO LIKE '%BRANCA')
            AND MODELO NOT IN 'CABINE  HR HDB 4WD BRANCA'
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                   ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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

<!--- cinza --->
<cfquery name="consulta_barreira_cinza" datasource="#BANCOSINC#">
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
                -- Verifica se o BARCODE só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                
                -- Verifica se o BARCODE contém N1, N2, N3 ou N4 (Reprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0

                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT BARCODE) AS totalVins,

            -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
            COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
        = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
        ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
        AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
        GROUP BY BARREIRA, BARCODE, INTERVALO
    )
    SELECT BARREIRA, HH, 
            COUNT(DISTINCT BARCODE) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
            
            -- Cálculo do DPV: total de BARCODEs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
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
<cfquery name="consulta_nconformidades_ecoat_cinza" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
            SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'ECOAT'
            AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
            GROUP BY PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                    ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_primer_cinza" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Primer'
        AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_topcoat_cinza" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Top Coat'
        AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_validacao_cinza" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Validacao'
        AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_cp6_cinza" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'CP6'
        AND (MODELO LIKE '%GRB' OR MODELO LIKE '%CINZA')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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

<!--- preto --->
<cfquery name="consulta_barreira_preto" datasource="#BANCOSINC#">
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
                -- Verifica se o BARCODE só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                
                -- Verifica se o BARCODE contém N1, N2, N3 ou N4 (Reprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0

                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT BARCODE) AS totalVins,

            -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
            COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
        = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
        ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY BARREIRA, BARCODE, INTERVALO
    )
    SELECT BARREIRA, HH, 
            COUNT(DISTINCT BARCODE) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
            
            -- Cálculo do DPV: total de BARCODEs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
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
<cfquery name="consulta_nconformidades_ecoat_preto" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'ECOAT'
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_primer_preto" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Primer'
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_topcoat_preto" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Top Coat'
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_validacao_preto" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Validacao'
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_cp6_preto" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'CP6'
        AND (MODELO LIKE '%PRETO' OR MODELO LIKE '%BLP')
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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

<!--- azul --->
<cfquery name="consulta_barreira_azul" datasource="#BANCOSINC#">
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
                -- Verifica se o BARCODE só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                
                -- Verifica se o BARCODE contém N1, N2, N3 ou N4 (Reprovado)
                WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0

                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT BARCODE) AS totalVins,

            -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
            COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
        = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
        ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
        AND MODELO LIKE '%AZUL'
        GROUP BY BARREIRA, BARCODE, INTERVALO
    )
    SELECT BARREIRA, HH, 
            COUNT(DISTINCT BARCODE) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT BARCODE) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT BARCODE) * 100, 1) AS PORCENTAGEM, 
            
            -- Cálculo do DPV: total de BARCODEs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
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
<cfquery name="consulta_nconformidades_ecoat_azul" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'ECOAT'
        AND MODELO LIKE '%AZUL'
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_primer_azul" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Primer'
        AND MODELO LIKE '%AZUL'
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_topcoat_azul" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Top Coat'
        AND MODELO LIKE '%AZUL'
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_validacao_azul" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'Validacao'
        AND MODELO LIKE '%AZUL'
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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
<cfquery name="consulta_nconformidades_cp6_azul" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
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
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
        AND BARREIRA = 'CP6'
        AND MODELO LIKE '%AZUL'
        GROUP BY PROBLEMA
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT PROBLEMA, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
        FROM CONSULTA
        WHERE ROWNUM <= 5
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

<html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicador/ COR - 2º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
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
        </style>

    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br><br>
    
        <!-- Filtro de data -->
        <h2>Indicador por cor 2º Turno</h2>
        <div class="container">
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='indicadores_paint_cor_1.cfm'">1º Turno</button>
            <button style="background-color:green; color:white;" class="btn btn-warning mb-2 ml-2" onclick="self.location='indicadores_paint_cor_2.cfm'">2º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='indicadores_paint_cor_3.cfm'">3º Turno</button>
            <cfoutput>
                <form method="get" action="indicadores_paint_cor_2.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#<cfelse>#DateFormat(Now(), 'yyyy-mm-dd')#</cfif>" onchange="this.form.submit()"/>
                    </div>
                    <button class="btn btn-danger mb-2 ml-2" type="reset" onclick="self.location='indicadores_paint_cor_2.cfm'">Limpar</button>
                </form>
            </cfoutput>
        </div>

        <div class="container-fluid" id="div1">
            <h1 style="background-color:black"> E-COAT</h1>
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
                                    <cfif BARREIRA eq 'ECOAT'>
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
                                <cfoutput query="consulta_barreira_cinza">
                                    <cfif BARREIRA eq 'ECOAT'>
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
                    <h3 style="text-align:center;">PRETO</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm table-custom-width">
                            <thead  style="background-color:black; color:white">
                                <tr>
                                    <th>H/H</th>
                                    <th>Prod</th>
                                    <th>Aprov</th>
                                    <th>%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_preto">
                                    <cfif BARREIRA eq 'ECOAT'>
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
                                <cfoutput query="consulta_barreira_azul">
                                    <cfif BARREIRA eq 'ECOAT'>
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
            </div>

            <div class="container-fluid">
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
                                        <th scope="col">Pareto(%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_ecoat">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat_cinza">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat_preto">
                                                <tr class="align-middle"style="background-color:rgba(0, 0, 0, 0.7); color:white;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_ecoat_azul">
                                                <tr class="align-middle"style="background-color:rgba(0, 191, 255, 0.7);color:black;">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
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
        </div>

        <div class="container-fluid" id="div2">
            <h1 style="background-color:black"> PRIMER</h1>
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
                                    <cfif BARREIRA eq 'Primer'>
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
                                <cfoutput query="consulta_barreira_cinza">
                                    <cfif BARREIRA eq 'Primer'>
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
                                <cfoutput query="consulta_barreira_preto">
                                    <cfif BARREIRA eq 'Primer'>
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
                                <cfoutput query="consulta_barreira_azul">
                                    <cfif BARREIRA eq 'Primer'>
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
            </div>

            <div class="container-fluid">
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
                                        <th scope="col">Pareto(%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_primer">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_primer_cinza">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_primer_preto">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_primer_azul">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
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
        </div>

        <div class="container-fluid" id="div3">
            <h1 style="background-color:black"> TOP COAT</h1>
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
                                    <cfif BARREIRA eq 'Top Coat'>
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
                                <cfoutput query="consulta_barreira_cinza">
                                    <cfif BARREIRA eq 'Top Coat'>
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
                                <cfoutput query="consulta_barreira_preto">
                                    <cfif BARREIRA eq 'Top Coat'>
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
                                <cfoutput query="consulta_barreira_azul">
                                    <cfif BARREIRA eq 'Top Coat'>
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
            </div>

            <div class="container-fluid">
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
                                        <th scope="col">Pareto(%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_topcoat">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_topcoat_cinza">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_topcoat_preto">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_topcoat_azul">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
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
        </div>

        <div class="container-fluid" id="div4">
            <h1 style="background-color:black">VALIDAÇÃO DE QUALIDADE</h1>
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
                                    <cfif BARREIRA eq 'Validacao'>
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
                                <cfoutput query="consulta_barreira_cinza">
                                    <cfif BARREIRA eq 'Validacao'>
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
                                <cfoutput query="consulta_barreira_preto">
                                    <cfif BARREIRA eq 'Validacao'>
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
                                <cfoutput query="consulta_barreira_azul">
                                    <cfif BARREIRA eq 'Validacao'>
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
            </div>

            <div class="container-fluid">
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
                                        <th scope="col">Pareto(%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_validacao">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_validacao_cinza">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_validacao_preto">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_validacao_azul">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
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
        </div>

        <div class="container-fluid" id="div5">
            <h1 style="background-color:black">LIBERAÇÃO FINAL</h1>
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
                                    <cfif BARREIRA eq 'CP6'>
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
                                <cfoutput query="consulta_barreira_cinza">
                                    <cfif BARREIRA eq 'CP6'>
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
                                <cfoutput query="consulta_barreira_preto">
                                    <cfif BARREIRA eq 'CP6'>
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
                                <cfoutput query="consulta_barreira_azul">
                                    <cfif BARREIRA eq 'CP6'>
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
            </div>

            <div class="container-fluid">
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
                                        <th scope="col">Pareto(%)</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_cp6">
                                            <tr class="align-middle">
                                                <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                <td>#PARETO#%</td>
                                            </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_cp6_cinza">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_cp6_preto">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
                                                    <td>#PARETO#%</td>
                                                </tr>
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
                                            <th scope="col">Pareto(%)</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-group-divider">
                                        <cfoutput query="consulta_nconformidades_cp6_azul">
                                                <tr class="align-middle">
                                                    <td style="font-weight: bold; font-size:12px">#PROBLEMA#</td>
                                                    <td style="font-size:12px">#TOTAL_POR_DEFEITO#</td>
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
        </div>

    </body>
</html>
  