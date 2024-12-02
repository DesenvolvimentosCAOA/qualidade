<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
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
        AND TRUNC(USER_DATA) = 
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
    
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:49:59'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
        AND INTERVALO BETWEEN '06:00' AND '15:00'
        ORDER BY VIN ASC
    </cfquery>
    
    <cfquery name="consulta_barreira_tiggo7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                )
            AND MODELO LIKE 'TIGGO 7%'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
            AND MODELO LIKE 'TIGGO 5%'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
            AND MODELO LIKE 'TIGGO 8 %'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
            AND MODELO LIKE 'TIGGO 83%'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
            AND MODELO LIKE 'TL %'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
                END HH,
                CASE 
                    -- Verifica se o VIN só contém criticidades N0, OK A- ou AVARIA (Aprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR CRITICIDADE IS NULL THEN 1 END) > 0 THEN 1
                    -- Verifica se o VIN contém N1, N2, N3 ou N4 (Reprovado)
                    WHEN COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) > 0 THEN 0
                    ELSE 0
                END AS APROVADO_FLAG,
                COUNT(DISTINCT VIN) AS totalVins,
                -- Contagem de problemas apenas para criticidades N1, N2, N3 e N4
                COUNT(CASE WHEN CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) AS totalProblemas
            FROM INTCOLDFUSION.sistema_qualidade_fa
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
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
            AND MODELO = 'CHASSI HR HDB 4WD DBLE'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO, MODELO
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
        <title>Relatório CP7 1º Turno</title>
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
            <button style="background-color:green; color:white;" class="btn btn-warning mb-2 ml-2" onclick="self.location='fa_relatorios_1.cfm'">1º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='fa_relatorios_2.cfm'">2º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='fa_relatorios_3.cfm'">3º Turno</button>
            <h2>Relatório CP7 1º Turno</h2>
            <form method="get">
                <div class="form-row">
                    <cfoutput>
                        <div class="form-group mx-sm-3 mb-2">
                            <label for="filtroData" class="sr-only">Data:</label>
                            <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                        </div>
                        <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='fa_relatorios_1.cfm'">Limpar</button>
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
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Resp</th>
                            <th scope="col">Qtd</th>
                            <th scope="col">Time</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Turno</th>
                            <th scope="col">Criticidade</th>
                            <th scope="col">Intervalo</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr style="font-size:12px"  class="align-middle">
                                    <td>
                                        <cfif FindNoCase("CP7", BARREIRA) neq 0>
                                            ASSEMBLY
                                        <cfelseif FindNoCase("T19", BARREIRA) neq 0>
                                            BUY OFF - T19
                                        <cfelseif FindNoCase("T30", BARREIRA) neq 0>
                                            BUY OFF - T30
                                        <cfelseif FindNoCase("T33", BARREIRA) neq 0>
                                            BUY OFF - T33
                                        <cfelseif FindNoCase("C13", BARREIRA) neq 0>
                                            BUY OFF - C13
                                        <cfelseif FindNoCase("F05", BARREIRA) neq 0>
                                            BUY OFF - F5
                                        <cfelseif FindNoCase("F10", BARREIRA) neq 0>
                                            BUY OFF - F10
                                        <cfelseif FindNoCase("HR", BARREIRA) neq 0>
                                            ASSEMBLY
                                        </cfif>
                                    </td>

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

                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                    <td></td>
                                    <td></td>
                                    <td>#PECA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PROBLEMA#</td>
                                    <td>
                                        <cfif ESTACAO eq "BODY">
                                            B
                                        <cfelseif ListFind("PCPM", ESTACAO)>
                                            PCPM
                                        <cfelseif ListFind("CP7", ESTACAO)>
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
                                    <td>1</td>
                                    <td>#ESTACAO#</td>
                                    <td>#VIN#</td>
                                    <td>1º TURNO</td>
                                    <td>#CRITICIDADE#</td>
                                    <td>#INTERVALO#</td>
                                </tr>
                            </cfloop>
                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "T19">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T19</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "T30">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T30</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "T33">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - T33</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "C13">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - C13</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "F05">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F5</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "F10">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - F10</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "CP7">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "CP7">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "CP7">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "CP7">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "CP7">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "HR">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ASSEMBLY</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "BUY OFF HR">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>BUY OFF - HR</strong></td>
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

  