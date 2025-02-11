<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE 1 = 1 
        
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
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
        )
        
        AND INTERVALO BETWEEN '06:00' AND '15:00'
    
        ORDER BY ID DESC
    </cfquery>
    
    <cfquery name="consulta_barreira_tiggo7" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            AND MODELO LIKE 'TIGGO 7%'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <cfquery name="consulta_barreira_tiggo5" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <cfquery name="consulta_barreira_t1a" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <cfquery name="consulta_barreira_tiggo18" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <cfquery name="consulta_barreira_tl" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <cfquery name="consulta_barreira_hr" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, BARCODE, MODELO,
                CASE 
                    WHEN INTERVALO BETWEEN '06:00' AND '15:00' THEN 'OUTROS'
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
            AND MODELO LIKE 'CABINE %'
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, BARCODE, INTERVALO, MODELO
        )
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

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
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
        <title>Relatório CP6 1º Turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
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
            /* Estilização geral do container */
            .container {
                max-width: 800px;
                margin: 20px auto;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }

            /* Botões estilizados */
            .btn {
                font-size: 16px;
                font-weight: bold;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-warning {
                background-color: #ffcc00;
                color: #333;
            }

            .btn-warning:hover {
                background-color: #e6b800;
            }

            /* Ajustando o botão do 1º turno para manter o verde */
            .btn-primary {
                background-color: green !important;
                color: white !important;
            }

            /* Estilização do título */
            h2 {
                margin-top: 20px;
                color: #333;
                font-size: 24px;
                font-weight: bold;
            }

            /* Estilização do formulário */
            .form-row {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: 15px;
            }

            .form-group input {
                font-size: 16px;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            /* Melhorando a responsividade */
            @media (max-width: 600px) {
                .form-row {
                    flex-direction: column;
                }
                .btn {
                    width: 100%;
                }
            }
            /* Estilização geral da tabela */
            #tblStocks {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background-color: #fff;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;
            }

            /* Estilização do cabeçalho da tabela */
            #tblStocks thead {
                background-color: #007bff;
                color: black;
                font-weight: bold;
            }

            #tblStocks thead th {
                padding: 12px;
                text-align: left;
                border-bottom: 2px solid #0056b3;
            }

            /* Estilização das células da tabela */
            #tblStocks tbody tr {
                border-bottom: 1px solid #ddd;
                transition: background 0.3s ease;
            }

            #tblStocks tbody tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            #tblStocks tbody tr:hover {
                background-color: #e9ecef;
            }

            #tblStocks tbody td {
                padding: 10px;
                color: #333;
            }

            /* Melhorando a responsividade */
            @media (max-width: 768px) {
                #tblStocks thead {
                    display: none;
                }
                
                #tblStocks tbody tr {
                    display: block;
                    margin-bottom: 10px;
                    background: #fff;
                    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
                    border-radius: 8px;
                    padding: 10px;
                }
                
                #tblStocks tbody td {
                    display: block;
                    text-align: right;
                    padding: 5px 10px;
                    position: relative;
                }
                
                #tblStocks tbody td::before {
                    content: attr(data-label);
                    font-weight: bold;
                    text-transform: uppercase;
                    position: absolute;
                    left: 10px;
                    text-align: left;
                }
            }
        </style>

    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>

        <div class="container">
            <button style="background-color:green; color:white;" class="btn btn-warning mb-2 ml-2" onclick="self.location='paint_relatorios_buy_1.cfm'">1º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='paint_relatorios_buy_2.cfm'">2º Turno</button>
            <button class="btn btn-warning mb-2 ml-2" onclick="self.location='paint_relatorios_buy_3.cfm'">3º Turno</button>
            <h2>Relatório CP6 1º Turno</h2>
            <form method="get">
                <div class="form-row">
                    <cfoutput>
                        <div class="form-group mx-sm-3 mb-2">
                            <label for="filtroData" class="sr-only">Data:</label>
                            <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                        </div>
                        <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='paint_relatorios_buy_1.cfm'">Limpar</button>
                        <button class="btn btn-warning mb-2 ml-2" type="button" id="report">Download</button>
                    </cfoutput>
                </div>
            </form>
        </div>
            <h2 class="titulo2">Relatórios</h2>
            
            <div style="margin-top:1vw" class="col-12 bg-white rounded metas">
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
                            <th scope="col">BARCODE</th>
                            <th scope="col">Turno</th>
                            <th scope="col">Criticidade</th>
                            <th scope="col">Cor</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr style="font-size:12px"  class="align-middle">
                                    <td>#BARREIRA#</td>
                                    <td>
                                        <cfif FindNoCase("CABINE", MODELO) neq 0>
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
                                    <td>#PROBLEMA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PECA#</td>
                                    <td></td>
                                    <td>
                                        <cfif len(PROBLEMA) GT 0>
                                            1
                                        <cfelse>
                                            
                                        </cfif>
                                    </td>
                                    <td>#ESTACAO#</td>
                                    <td>#BARCODE#</td>
                                    <td>1º TURNO</td>
                                    <td>#CRITICIDADE#</td>
                                    <td>#ListLast(MODELO, " ")#</td>
                            </cfloop>
                            
                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "ECOAT">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>ECOAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "Primer">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>PRIMER</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "Validacao">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>VALIDACAO</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "CP6">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>CP6</strong></td>
                                        <td colspan="1" class="text-end"><strong>HR</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_hr.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo7.recordcount#">
                                <cfif consulta_barreira_tiggo7.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1E</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo7.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo5.recordcount#">
                                <cfif consulta_barreira_tiggo5.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T19</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo5.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tiggo18.recordcount#">
                                <cfif consulta_barreira_tiggo18.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T18</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tiggo18.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_t1a.recordcount#">
                                <cfif consulta_barreira_t1a.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>T1A</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_t1a.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_tl.recordcount#">
                                <cfif consulta_barreira_tl.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
                                        <td colspan="1" class="text-end"><strong>TL</strong></td>
                                        <td></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.TOTAL[i]#</strong></td>
                                        <td colspan="1" class="text-end"><strong>#consulta_barreira_tl.APROVADOS[i]#</strong></td>
                                    </tr>
                                </cfif>
                            </cfloop>

                            <cfloop index="i" from="1" to="#consulta_barreira_hr.recordcount#">
                                <cfif consulta_barreira_hr.BARREIRA[i] EQ "Top Coat">
                                    <tr class="align-middle">
                                        <td colspan="1" class="text-end"><strong>TOP COAT</strong></td>
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

  