<cfinvoke method="inicializando" component="cf.ini.index">

    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE 1 = 1 
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        <!--- Filtro de Periodo --->
        <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
            <cfset periodo = url.filtroPeriodo>
            
            <!--- 1º turno: Segunda a Quinta (06:00 às 15:48), Sexta (06:00 às 14:48), Sábado (06:00 às 15:48) --->
            <cfif periodo EQ "1º">
                AND (
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                )
            
            <!--- 2º turno: 15:50 às 00:00, de acordo com horários ajustados --->
            <cfelseif periodo EQ "2º">
                AND (
                    CASE 
                        WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                        WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                        ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                    END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                )
    
            <!--- 3º turno: Segunda a Quinta (01:02 às 06:10), Sexta (01:02 às 06:10), Sábado (23:00 às 04:25) --->
            <cfelseif periodo EQ "3º">
                AND (
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                    ))
                )
            </cfif>
        <cfelse>
        </cfif>
        AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
        AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
        ORDER BY ID DESC
    </cfquery>

    <cfquery name="consulta_barreira_tiggo7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') +1
            AND MODELO LIKE 'TIGGO 7%'
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

    <cfquery name="consulta_barreira_tiggo5" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
            AND MODELO LIKE 'TIGGO 5%'
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

    <cfquery name="consulta_barreira_tiggo83" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
            AND MODELO LIKE 'TIGGO 83%'
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

    <cfquery name="consulta_barreira_tiggo8adas" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
            AND MODELO LIKE 'TIGGO 8 %'
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

    <cfquery name="consulta_barreira_tl" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
            AND MODELO LIKE 'TL%'
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

    <cfquery name="consulta_barreira_hr" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO BETWEEN '01:00' AND '00:00' THEN 'OUTROS'
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
            WHERE 1 = 1
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
                AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
            </cfif>
            <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
                <cfset periodo = url.filtroPeriodo>
                <cfif periodo EQ "1º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00','06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00','15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "2º">
                    AND TO_CHAR(INTERVALO) IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                <cfelseif periodo EQ "3º">
                    AND TO_CHAR(INTERVALO) IN ('01:00', '02:00', '03:00', '04:00', '05:00')
                </cfif>
            </cfif>
            AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
            AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
            AND MODELO LIKE 'CHASSI HR%'
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
        <title>FA CP7 Summary</title>
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
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
        <div class="container">
            <h2>FA CP7 Summary</h2>
            <form method="get">
                <div class="form-row">
                    <cfoutput>
                        <div class="form-group col-md-2">
                            <label for="formDataStart">Data Inicial</label>
                            <input value="<cfif isDefined('url.filtroDataStart')>#url.filtroDataStart#</cfif>" type="date" class="form-control form-control-sm" name="filtroDataStart" id="formDataStart">
                        </div>
                    
                        <div class="form-group col-md-2">
                            <label for="formDataEnd">Data Final</label>
                            <input value="<cfif isDefined('url.filtroDataEnd')>#url.filtroDataEnd#</cfif>" type="date" class="form-control form-control-sm" name="filtroDataEnd" id="formDataEnd">
                        </div>
                    </cfoutput>
                    <cfoutput>
                        <div class="form-group col-md-2">
                            <label for="formBARREIRA">Barreira</label>
                            <select class="form-control form-control-sm" name="filtroBARREIRA" id="formBARREIRA">
                                <option value="">Selecione</option>
                                <option value="HR" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "HR">selected</cfif>>HR</option>
                                <option value="CP7" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "CP7">selected</cfif>>CP7</option>
                                <option value="T19" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "T19">selected</cfif>>T19</option>
                                <option value="T30" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "T30">selected</cfif>>T30</option>
                                <option value="T33" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "T33">selected</cfif>>T33</option>
                                <option value="C13" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "C13">selected</cfif>>C13</option>
                                <option value="F05" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "F05">selected</cfif>>F05</option>
                                <option value="F10" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "F10">selected</cfif>>F10</option>
                                <option value="SUBMOTOR" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "SUBMOTOR">selected</cfif>>SUBMOTOR</option>
                            </select>
                        </div>
                    </cfoutput>
                    <cfoutput>
                        <div class="form-group col-md-2">
                            <label for="formPeriodo">Período do Dia</label>
                            <select class="form-control form-control-sm" name="filtroPeriodo" id="formPeriodo">
                                <option value="">Selecione</option>
                                <option value="1º" <cfif isDefined('url.filtroPeriodo') AND url.filtroPeriodo EQ "1º">selected</cfif>>1º</option>
                                <option value="2º" <cfif isDefined('url.filtroPeriodo') AND url.filtroPeriodo EQ "2º">selected</cfif>>2º</option>
                                <option value="3º" <cfif isDefined('url.filtroPeriodo') AND url.filtroPeriodo EQ "3º">selected</cfif>>3º</option>
                            </select>
                        </div>
                    </cfoutput>  
                </div>
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="submit" class="btn btn-primary">Pesquisar</button>
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                            <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='fa_relatorios_summary_cp7.cfm'">Limpar</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-2">
                    <h3>TIGGO 7</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_tiggo7">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2">
                    <h3>TIGGO 5</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_tiggo5">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2">
                    <h3>T 18</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_tiggo83">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2">
                    <h3>T1A</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_tiggo8adas">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2">
                    <h3>TL</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_tl">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2">
                    <h3>HR</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-50" style="font-size:12px">
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:1vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira_hr">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div> 

            <h2 class="titulo2">Relatórios</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">Barreira</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Data</th>
                            <th scope="col">Prod</th>
                            <th scope="col">Aprov</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Resp</th>
                            <th scope="col">Qtd</th>
                            <th scope="col">Time</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Intervalo</th>
                            <th scope="col">Criticidade</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#BARREIRA#</td>
                                    <td>#MODELO#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                    <td></td>
                                    <td></td>
                                    <td>#PECA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PROBLEMA#</td>
                                    <td></td>
                                    <td></td>
                                    <td>#ESTACAO#</td>
                                    <td>#VIN#</td>
                                    <td>#INTERVALO#</td>
                                    <td>#CRITICIDADE#</td>
                                </tr>
                            </cfloop>
                        </cfoutput>
                    </tbody>

</table>
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>

<!-- Script para deletar -->
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
  