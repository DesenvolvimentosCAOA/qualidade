<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE 1 = 1 
        AND BARREIRA NOT IN 'LIBERACAO'
        <!--- Filtros de barreira e estação --->
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        
        <!--- Filtro de data e lógica de turnos --->
        AND TRUNC(REPARO_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
    
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
        AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            AND PROBLEMA_REPARO IS NOT NULL
        ORDER BY BARREIRA DESC
    </cfquery>
    
    <cfquery name="consulta_barreira_tiggo7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE 'TIGGO 7%'
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            AND PROBLEMA_REPARO IS NOT NULL
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE 'TIGGO 5%'
            AND PROBLEMA_REPARO IS NOT NULL
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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

    <cfquery name="consulta_barreira_t1a" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE 'TIGGO 8 %'
            AND PROBLEMA_REPARO IS NOT NULL
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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

    <cfquery name="consulta_barreira_tiggo18" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE 'TIGGO 83%'
            AND PROBLEMA_REPARO IS NOT NULL
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE 'TL %'
            AND PROBLEMA_REPARO IS NOT NULL
                AND INTERVALO_REPARO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO_REPARO BETWEEN '00:00' AND '23:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE TRUNC(REPARO_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(REPARO_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '6') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(REPARO_DATA, 'D') = '7') AND (TO_CHAR(REPARO_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
            AND MODELO LIKE '%HR %'
            AND PROBLEMA_REPARO IS NOT NULL
                AND INTERVALO_REPARO BETWEEN '00:00' AND '23:00'
            GROUP BY BARREIRA, VIN, INTERVALO_REPARO, MODELO
        )
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
        <title>Relatório CP8 1º Turno</title>
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
            <cfinclude template="auxi/nav_links1.cfm">
        </header>

        <div class="container">
            <button style="background-color:green; color:white;" class="btn btn-warning mb-2 ml-2" onclick="self.location='fai_relatorios_1reparo.cfm'">1º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='fai_relatorios_2reparo.cfm'">2º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='fai_relatorios_3reparo.cfm'">3º Turno</button>
            <h2>Relatório CP8 1º Turno</h2>
            <form method="get">
                <div class="form-row">
                    <cfoutput>
                        <div class="form-group mx-sm-3 mb-2">
                            <label for="filtroData" class="sr-only">Data:</label>
                            <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                        </div>
                        <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fai_relatorios_1reparo.cfm'">Limpar</button>
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
                            <th scope="col">Reparo realizado</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr style="font-size:12px"  class="align-middle">
                                    <td>#BARREIRA#</td>
                                    <td>
                                        <cfif FindNoCase("CHASSI HR", MODELO) neq 0>
                                            HR
                                        <cfelseif FindNoCase("TIGGO 5", MODELO) neq 0>
                                            T19
                                        <cfelseif FindNoCase("TIGGO 7", MODELO) neq 0>
                                            T1E
                                        <cfelseif FindNoCase("TIGGO 8 ADAS", MODELO) neq 0>
                                            T1A
                                        <cfelseif FindNoCase("TIGGO 83 ICE", MODELO) neq 0>
                                            T18
                                        <cfelseif FindNoCase("TL", MODELO) neq 0>
                                            TL
                                        </cfif>
                                    </td>
                                    <td>#lsdatetimeformat(REPARO_DATA, 'dd/mm/yyyy')#⠀</td>
                                    <td></td>
                                    <td></td>
                                    <td>#PROBLEMA_REPARO#</td>
                                    <td>#POSICAO_REPARO#</td>
                                    <td>#PECA_REPARO#</td>
                                    <td>
                                        <cfif RESPONSAVEL_REPARO eq "BODY">
                                            B
                                        <cfelseif ListFind("PCPM", RESPONSAVEL_REPARO)>
                                            PCPM
                                        <cfelseif ListFind("FAI", RESPONSAVEL_REPARO)>
                                            FAI
                                        <cfelseif ListFind("TRIM", RESPONSAVEL_REPARO)>
                                            T
                                        <cfelseif ListFind("PCP", RESPONSAVEL_REPARO)>
                                            PCP
                                        <cfelseif ListFind("PVT", RESPONSAVEL_REPARO)>
                                            PVT
                                        <cfelseif ListFind("ENGENHARIA", RESPONSAVEL_REPARO)>
                                            ENG
                                        <cfelseif ListFind("MANUTENÇÃO", RESPONSAVEL_REPARO)>
                                            MANUTENÇÃO
                                        <cfelseif ListFind("LOGISTICA", RESPONSAVEL_REPARO)>
                                            LOG
                                        <cfelseif ListFind("CKDL", RESPONSAVEL_REPARO)>
                                            CKDL
                                        <cfelseif ListFind("DOOWON", RESPONSAVEL_REPARO)>
                                            DOOWON
                                        <cfelseif ListFind("SMALL", RESPONSAVEL_REPARO)>
                                            S
                                        <cfelseif ListFind("CKD", RESPONSAVEL_REPARO)>
                                            CKD
                                        <cfelseif ListFind("PAINT", RESPONSAVEL_REPARO)>
                                            P
                                        <cfelseif ListFind("LINHA T", RESPONSAVEL_REPARO)>
                                            T
                                        <cfelseif ListFind("LINHA F", RESPONSAVEL_REPARO)>
                                            T
                                        <cfelseif ListFind("LINHA C", RESPONSAVEL_REPARO)>
                                            C
                                        <cfelseif ListFind("SUB-MONTAGEM", RESPONSAVEL_REPARO)>
                                            T
                                        </cfif>
                                    </td>
                                    <td> 
                                        <cfif PROBLEMA_REPARO Neq "">
                                            1
                                        </cfif>
                                        </td>
                                    <td>#RESPONSAVEL_REPARO#</td>
                                    <td>#VIN#</td>
                                    <td>1º TURNO</td>
                                    <td>#CRITICIDADE#</td>
                                    <td>#TIPO_REPARO#</td>
                                </tr>
                            </cfloop>
                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "UNDER BODY">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>UNDER BODY</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "ROAD TEST">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ROAD TEST</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "SHOWER">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SHOWER</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "SIGN OFF">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "SIGN OFF">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "SIGN OFF">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "SIGN OFF">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "SIGN OFF">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>SIGN OFF</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "TUNEL DE LIBERACAO">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TUNEL DE LIBERACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
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

  