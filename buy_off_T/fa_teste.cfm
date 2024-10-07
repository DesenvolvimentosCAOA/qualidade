
<cfset filtroData = "" />
<cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
    <cfset filtroData = CreateODBCDate(url.filtroData)>
<cfelse>
    <cfset filtroData = "TRUNC(SYSDATE - 1)">
</cfif>
<cfquery name="consulta_barreira" datasource="#BANCOSINC#">
           WITH CONSULTA AS (
        SELECT 
            BARREIRA, 
            VIN,
            CASE 
                WHEN INTERVALO = '06:00' THEN '01'
                WHEN INTERVALO = '07:00' THEN '02'
                WHEN INTERVALO = '08:00' THEN '03'
                WHEN INTERVALO = '09:00' THEN '04'
                WHEN INTERVALO = '10:00' THEN '05'
                WHEN INTERVALO = '11:00' THEN '06'
                WHEN INTERVALO = '12:00' THEN '07'
                WHEN INTERVALO = '13:00' THEN '08'
                WHEN INTERVALO = '14:00' THEN '09'
                WHEN INTERVALO = '15:00' THEN '10'
                ELSE 'OUTROS'
            END HH,
            CASE 
                WHEN COUNT(CASE WHEN PROBLEMA IS NULL THEN 1 WHEN PROBLEMA IS NOT NULL 
                    AND (CRITICIDADE = 'N0' OR CRITICIDADE = 'OK A-') THEN 1 END) > 0 THEN 1
                ELSE 0
            END AS APROVADO_FLAG,
            COUNT(DISTINCT VIN) AS totalVins,
            COUNT(CASE WHEN PROBLEMA IS NOT NULL AND (CRITICIDADE IS NULL OR CRITICIDADE <> 'OK A-') THEN 1 END) AS totalProblemas
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE TRUNC(USER_DATA) = #filtroData#
        AND INTERVALO BETWEEN '06:00' AND '15:00'
        AND BARREIRA = 'CP7'
        GROUP BY BARREIRA, VIN, INTERVALO, PROBLEMA, CRITICIDADE
    )
    SELECT BARREIRA, HH, 
            COUNT(DISTINCT VIN) AS TOTAL, 
            SUM(APROVADO_FLAG) AS APROVADOS, 
            COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
            ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
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


<div class="col-md-4">
    <table class="table table-hover table-sm table-custom-width">
        <thead class="bg-success">
            <tr>
                <th>Barreira</th>
                <th>Intervalo</th>
                <th>Total</th>
                <th>Aprovados</th>
                <th>Reprovados</th>
                <th>Porcentagem</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="consulta_barreira">
                <tr>
                    <td>#BARREIRA#</td>
                    <td>#HH#</td>
                    <td>#TOTAL#</td>
                    <td>#APROVADOS#</td>
                    <td>#REPROVADOS#</td>
                    <td>#PORCENTAGEM#%</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
</div>
