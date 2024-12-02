<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfquery name="consulta" datasource="#BANCOMES#">
        DECLARE @filtroData DATE;
    
        SET @filtroData = 
        <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
            <cfqueryparam value="#url.filtroData#" cfsqltype="cf_sql_date">
        <cfelse>
            CAST(GETDATE() AS DATE)
        </cfif>;
    
        SELECT COUNT(DISTINCT l.code) AS distinct_count
        FROM TBLMovEv m
        LEFT JOIN TBLProduct p ON m.IDProduct = p.IDProduct
        LEFT JOIN TBLLot l ON l.IDLot = m.IDLot
        LEFT JOIN TBLAddress a ON m.IDAddress = a.IDAddress
        LEFT JOIN TBLMovType mt ON mt.IDMovType = m.IDMovType
        WHERE a.code IN ('T03_SUV')  
          AND mt.code LIKE 'E%'
          AND (
              -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48
              (
                  DATEPART(WEEKDAY, m.DtTimeStamp) BETWEEN 2 AND 5 
                  AND m.DtTimeStamp BETWEEN 
                      DATEADD(HOUR, 6, CAST(@filtroData AS DATETIME)) 
                      AND DATEADD(MINUTE, 948, CAST(@filtroData AS DATETIME))
              )
              -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
              OR (
                  DATEPART(WEEKDAY, m.DtTimeStamp) = 6 
                  AND m.DtTimeStamp BETWEEN 
                      DATEADD(HOUR, 6, CAST(@filtroData AS DATETIME)) 
                      AND DATEADD(MINUTE, 888, CAST(@filtroData AS DATETIME))
              )
              -- Sábado: turno inicia às 06:00 e termina às 14:48
              OR (
                  DATEPART(WEEKDAY, m.DtTimeStamp) = 7 
                  AND m.DtTimeStamp BETWEEN 
                      DATEADD(HOUR, 6, CAST(@filtroData AS DATETIME)) 
                      AND DATEADD(MINUTE, 948, CAST(@filtroData AS DATETIME))
              )
          )
          AND CAST(m.DtTimeStamp AS DATE) = @filtroData;
    </cfquery>
    
    <cfquery name="consulta_sgq" datasource="#BANCOSINC#">
        select count(distinct VIN) as distinct_sgq
        from sistema_qualidade_fa
        where barreira = 'T19'
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        )
        AND TRUNC(USER_DATA) =
                    <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                        #CreateODBCDate(url.filtroData)#
                    <cfelse>
                        TRUNC(SYSDATE)
                    </cfif>
    </cfquery>

    <cfquery name="consulta_sgq_t30" datasource="#BANCOSINC#">
        select count(distinct VIN) as distinct_sgq
        from sistema_qualidade_fa
        where barreira = 'T30'
        AND (
            -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            -- Sábado: turno inicia às 06:00 e termina às 15:48
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        )
        AND TRUNC(USER_DATA) =
                    <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                        #CreateODBCDate(url.filtroData)#
                    <cfelse>
                        TRUNC(SYSDATE)
                    </cfif>
    </cfquery>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicadores - 1º turno</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <title>Contagem MES</title>
        <style>
            table { border-collapse: collapse; width: 15%; }
            th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
            th { background-color: #f2f2f2; }
            .container {
                margin-top:2vw;
            }
        </style>
</head>
<body>
    <div class="container">
        <form method="get" action="teste_contagem.cfm" class="form-inline">
            <div class="form-group mx-sm-3 mb-2">
                <label for="filtroData" class="sr-only">Data:</label>
                <input type="date" class="form-control" name="filtroData" id="filtroData" 
                    value="<cfif isDefined('url.filtroData') AND NOT isNull(url.filtroData)>#url.filtroData#</cfif>"/>
            </div>
            <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
            <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='teste_contagem.cfm'">Limpar</button>
        </form>

        <h2>Resultado da Consulta</h2>
        <div style="display: flex;">
            <table style="margin-right: 20px;">
                <thead>
                    <tr>
                        <th>T03 e T19</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="consulta">
                        <tr>
                            <td>#consulta.distinct_count#</td>
                        </tr>
                    </cfoutput>
                    <cfoutput query="consulta_sgq">
                        <tr>
                            <td>#consulta_sgq.distinct_sgq#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>

            <table>
                <thead>
                    <tr>
                        <th>T03 e T30</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="consulta">
                        <tr>
                            <td>#consulta.distinct_count#</td>
                        </tr>
                    </cfoutput>
                        <cfoutput query="consulta_sgq_t30">
                            <tr>
                                <td>#consulta_sgq_t30.distinct_sgq#</td>
                            </tr>
                        </cfoutput>
                </tbody>
                </tbody>
            </table>
        </div>
    </div>
</body>

</html>

