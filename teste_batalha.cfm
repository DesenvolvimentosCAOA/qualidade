<cfquery name="consulta_nconformidades_cp7" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT PROBLEMA, PECA, ESTACAO, POSICAO, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE TRUNC(USER_DATA) =
            <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                #CreateODBCDate(url.filtroData)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND PROBLEMA IS NOT NULL
        AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA','CRIPPLE')
        AND BARREIRA = 'SIGN OFF'
        AND (
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '15:48:00'))
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
        )
        GROUP BY PROBLEMA, PECA, ESTACAO, POSICAO
        ORDER BY POSICAO
    )
    SELECT POSICAO, SUM(TOTAL_POR_DEFEITO) AS TOTAL_POR_POSICAO
    FROM CONSULTA
    GROUP BY POSICAO
    ORDER BY POSICAO
</cfquery>

<cfoutput>
    <div class="container">
        <h2>FA SUV CP7 1º Turno</h2>
        <form method="get" action="teste_batalha.cfm" class="form-inline">
            <div class="form-group mx-sm-3 mb-2">
                <label for="filtroData" class="sr-only">Data:</label>
                <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
            </div>
            <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='teste_batalha.cfm'">Limpar</button>
        </form>
    </div>
    </cfoutput>

<cfoutput>
    <cfif consulta_nconformidades_cp7.recordCount GT 0>
        <div id="tabela-container">
            <table border="1">
                <thead>
                    <tr>
                        <th>POSICAO</th>
                        <th>Total de Defeitos</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="consulta_nconformidades_cp7">
                        <tr>
                            <td>#consulta_nconformidades_cp7.POSICAO#</td>
                            <td>#consulta_nconformidades_cp7.TOTAL_POR_POSICAO#</td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    <cfelse>
        <p>Nenhum dado encontrado.</p>
    </cfif>
</cfoutput>
