<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>


    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
        WHERE 1 = 1 
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        <!--- Novo filtro de intervalo, modelo, barreira e data --->
        AND INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
        AND BARREIRA NOT IN 'TUNEL DE LIBERACAO'
        AND CASE 
            WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) 
            ELSE TRUNC(USER_DATA) 
        END = CASE 
            WHEN SUBSTR('#url.filtroData#', 12, 5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
        END
        ORDER BY ID DESC
    </cfquery>
    
    <cfquery name="consulta_barreira_tiggo7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'TIGGO 7%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_tiggo5" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'TIGGO 5%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_t1a" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'TIGGO 8 %'
                AND MODELO NOT IN 'TIGGO 8 FL3'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_tiggo18" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'TIGGO 8 FL3'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_tl" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'TUCSON %'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_hr" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'HR %'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_azera" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'AZERA%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_kona" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'KONA%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_ioniq" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'IONIQ%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_subaru" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'SUBARU%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_forester" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'FORESTER%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_outback" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'OUTBACK%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_santa" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'SANTA %'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_hd" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'HD80'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <cfquery name="consulta_barreira_arrizo" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('OK A-', 'AVARIA') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND MODELO LIKE 'ARRIZO%'
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
            = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
            ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
        )
        SELECT BARREIRA,
            'TTL' AS HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
            ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY HH
    </cfquery>

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_PDI") or cookie.USER_APONTAMENTO_PDI eq "">
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
        <title>Relatório PDI 2º Turno</title>
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
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>

        <div class="container">
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='pdi_relatorios_1.cfm'">1º Turno</button>
            <button style="background-color:green; color:white;" class="btn btn-warning mb-2 ml-2" onclick="self.location='pdi_relatorios_2.cfm'">2º Turno</button>
<!---             <button class="btn btn-warning mb-2 ml-2" onclick="self.location='pdi_relatorios_3.cfm'">3º Turno</button> --->
            <h2>Relatório PDI 2º Turno</h2>
            <form method="get">
                <div class="form-row">
                    <cfoutput>
                        <div class="form-group mx-sm-3 mb-2">
                            <label for="filtroData" class="sr-only">Data:</label>
                            <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                        </div>
                        <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='pdi_relatorios_2.cfm'">Limpar</button>
                        <button class="btn btn-warning mb-2 ml-2" type="button" id="report">Download</button>
                    </cfoutput>
                </div>
            </form>
        </div>
        
        <h2 class="titulo2">Relatórios</h2>
        <div style="margin-top:1vw" class="container col-12 bg-white rounded metas">
            <table id="tblStocks" class="table">
                <thead>
                    <tr class="text-nowrap">
                        <th scope="col">Barreira</th>
                        <th scope="col">Modelo</th>
                        <th scope="col">Data</th>
                        <th scope="col">Prod</th>
                        <th scope="col">Aprov</th>
                        <th scope="col">Problema</th>
                        <th scope="col">Posição</th>
                        <th scope="col">Peça</th>
                        <th scope="col">Resp</th>
                        <th scope="col">Qtd</th>
                        <th scope="col">Time</th>
                        <th scope="col">VIN/BARCODE</th>
                        <th scope="col">Turno</th>
                        <th scope="col">Criticidade</th>
                        <th scope="col">Bateria</th>
                    </tr>
                </thead>
                <tbody class="table-group-divider">
                    <cfoutput>
                        <cfloop query="consulta_adicionais">
                            <tr style="font-size:12px"  class="align-middle">
                                <td>
                                    <cfif FindNoCase("PDI", BARREIRA) neq 0>
                                        PDI
                                    <cfelseif FindNoCase("NACIONAL", BARREIRA) neq 0>
                                        PATIO NACIONAL
                                    <cfelseif FindNoCase("PATIO", BARREIRA) neq 0>
                                        PATIO
                                    <cfelseif FindNoCase("RAMPA", BARREIRA) neq 0>
                                        RAMPA
                                    </cfif>
                                </td>
                                <td>
                                    <cfif FindNoCase("IX35 GLS", MODELO) neq 0>
                                        LM
                                    <cfelseif FindNoCase("Tucson", MODELO) neq 0>
                                        TL
                                    <cfelseif FindNoCase("HR DA10/12", MODELO) neq 0>
                                        HR
                                    <cfelseif FindNoCase("HD80", MODELO) neq 0>
                                        HD
                                    <cfelseif FindNoCase("Tiggo 5", MODELO) neq 0>
                                        T19
                                    <cfelseif FindNoCase("Arrizo 6", MODELO) neq 0>
                                        M1D
                                    <cfelseif FindNoCase("Tiggo 7", MODELO) neq 0>
                                        T1E
                                    <cfelseif FindNoCase("Tiggo 8 ADAS", MODELO) neq 0>
                                        T1A
                                    <cfelseif FindNoCase("Tiggo 8 TXS", MODELO) neq 0>
                                        T1A
                                    <cfelseif FindNoCase("TIGGO 8 FL3",MODELO) neq 0>
                                        T18
                                    <cfelseif FindNoCase("Tiggo 8 PHEV", MODELO) neq 0>
                                        T1D
                                    <cfelseif FindNoCase("FORESTER", MODELO) neq 0>
                                        FORESTER
                                    <cfelseif FindNoCase("AZERA", MODELO) neq 0>
                                        AZERA
                                    <cfelseif FindNoCase("SUBARU ", MODELO) neq 0>
                                        SUBARU
                                    <cfelseif FindNoCase("SANTA FÉ", MODELO) neq 0>
                                        SANTA FÉ
                                    <cfelseif FindNoCase("IONIQ", MODELO) neq 0>
                                        IONIQ
                                    <cfelseif FindNoCase("OUTBACK", MODELO) neq 0>
                                        OUTBACK
                                    <cfelseif FindNoCase("KONA ", MODELO) neq 0>
                                        KONA
                                    </cfif>
                                </td>

                                <td>#lsdatetimeformat(url.filtroData, 'dd/mm/yyyy')#⠀</td>
                                <td></td>
                                <td></td>
                                <td>#PROBLEMA#</td>
                                <td>#POSICAO#</td>
                                <td>#PECA#</td>
                                <td>
                                    <cfif ESTACAO eq "BODY">
                                        B
                                    <cfelseif ListFind("PCPM", ESTACAO)>
                                        PCPM
                                    <cfelseif ListFind("FAI", ESTACAO)>
                                        FAI
                                    <cfelseif ListFind("TRIM", ESTACAO)>
                                        T
                                    <cfelseif ListFind("PCP", ESTACAO)>
                                        PCP
                                    <cfelseif ListFind("PVT", ESTACAO)>
                                        PVT
                                    <cfelseif ListFind("ENGENHARIA", ESTACAO)>
                                        ENGENHARIA
                                    <cfelseif ListFind("MANUTENÇÃO", ESTACAO)>
                                        MANUTENÇÃO
                                    <cfelseif ListFind("LOGISTICA", ESTACAO)>
                                        LOG
                                    <cfelseif ListFind("CKDL", ESTACAO)>
                                        CKDL
                                    <cfelseif ListFind("DOOWON", ESTACAO)>
                                        DOOWON
                                    <cfelseif ListFind("SMALL", ESTACAO)>
                                        SMALL
                                    <cfelseif ListFind("CKD", ESTACAO)>
                                        Q1
                                    <cfelseif ListFind("PAINT", ESTACAO)>
                                        P    
                                    <cfelseif ListFind("LINHA T", ESTACAO)>
                                        T
                                    <cfelseif ListFind("LINHA F", ESTACAO)>
                                        T
                                    <cfelseif ListFind("LINHA C", ESTACAO)>
                                        C
                                    <cfelseif ListFind("SUB-MONTAGEM", ESTACAO)>
                                        T
                                    </cfif>
                                </td>
                                <td> 
                                    <cfif PROBLEMA Neq "">
                                        1
                                    </cfif>
                                    </td>
                                <td>#ESTACAO#</td>
                                <td>#VIN#</td>
                                <td>
                                    <!-- Verificação de turno com base no INTERVALO -->
                                    <cfif ListFind("06:00,07:00,08:00,09:00,10:00,11:00,12:00,13:00,14:00,15:00", INTERVALO)>
                                        1º TURNO
                                    <cfelseif ListFind("15:50,16:00,17:00,18:00,19:00,20:00,21:00,22:00,23:00,00:00", INTERVALO)>
                                        2º TURNO
                                    <cfelseif ListFind("01:00,02:00,03:00,04:00,05:00", INTERVALO)>
                                        3º TURNO
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#CRITICIDADE#</td>
                                <td>#BATERIA#</td>
                            </tr>
                        </cfloop>

                        <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_azera.recordcount#">
                                <cfif consulta_barreira_azera.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>AZERA</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_azera.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_azera.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_kona.recordcount#">
                                <cfif consulta_barreira_kona.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>KONA</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_kona.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_kona.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_ioniq.recordcount#">
                                <cfif consulta_barreira_ioniq.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>IONIQ</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_ioniq.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_ioniq.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_subaru.recordcount#">
                                <cfif consulta_barreira_subaru.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>SUBARU</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_subaru.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_subaru.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_forester.recordcount#">
                                <cfif consulta_barreira_forester.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>FORESTER</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_forester.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_forester.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_outback.recordcount#">
                                <cfif consulta_barreira_outback.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>OUTBACK</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_outback.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_outback.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_santa.recordcount#">
                                <cfif consulta_barreira_santa.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>SANTA FÉ</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_santa.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_santa.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hd.recordcount#">
                                <cfif consulta_barreira_hd.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>HD80</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hd.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hd.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_arrizo.recordcount#">
                                <cfif consulta_barreira_arrizo.BARREIRA[i] EQ "PDI">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SAÍDA</strong></td>
                                        <td colspan="1" class="text-end"><strong>M1D</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_arrizo.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_arrizo.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                    </cfoutput>
                </tbody>
            </table>
                <!-- jQuery first, then Popper.js, then Bootstrap JS -->
                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
                <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
                <script>
                    // Gerando Excel da tabela
                    var table2excel = new Table2Excel();
                    document.getElementById('report').addEventListener('click', function() {
                        table2excel.export(document.querySelectorAll('#tblStocks'));
                    });
                </script>
        </div>
    </body>
</html>

  