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

    <cfquery name="consulta_f" datasource="#BANCOMES#">
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
        WHERE a.code IN ('KEEPER_F_SUV')  
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

    <cfquery name="consulta_2" datasource="#BANCOMES#">
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
            -- Segunda a Quinta-feira
            (
                DATEPART(WEEKDAY, m.DtTimeStamp) BETWEEN 2 AND 5
                AND (
                    (CONVERT(VARCHAR(5), m.DtTimeStamp, 108) BETWEEN '15:50' AND '23:59')
                    OR (CONVERT(VARCHAR(5), m.DtTimeStamp, 108) BETWEEN '00:00' AND '02:00' AND CAST(DATEADD(DAY, -1, m.DtTimeStamp) AS DATE) = @filtroData)
                )
            )
            OR -- Sexta-feira
            (
                DATEPART(WEEKDAY, m.DtTimeStamp) = 6
                AND (
                    (CONVERT(VARCHAR(5), m.DtTimeStamp, 108) BETWEEN '15:00' AND '23:59')
                    OR (CONVERT(VARCHAR(5), m.DtTimeStamp, 108) BETWEEN '00:00' AND '02:00' AND CAST(DATEADD(DAY, -1, m.DtTimeStamp) AS DATE) = @filtroData)
                )
            )
        )
        AND (
            CASE 
                WHEN CONVERT(VARCHAR(5), m.DtTimeStamp, 108) <= '02:00' THEN CAST(DATEADD(DAY, -1, m.DtTimeStamp) AS DATE) 
                ELSE CAST(m.DtTimeStamp AS DATE) 
            END = CASE 
                WHEN SUBSTRING('#url.filtroData#', 12, 5) <= '02:00' THEN CAST(DATEADD(DAY, -1, CONVERT(DATETIME, '#url.filtroData#', 120)) AS DATE) 
                ELSE CAST(CONVERT(DATETIME, '#url.filtroData#', 120) AS DATE) 
            END
        )
    </cfquery>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Uhuuulll Deu Certo</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }
        .form-inline {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
            background-color: #fff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-right: 10px;
        }
        .form-control {
            border: 2px solid #007BFF;
            border-radius: 5px;
            padding: 5px 10px;
            font-size: 16px;
        }
        .btn {
            padding: 5px 15px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
        }
        .btn-primary {
            background-color: #007BFF;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
        .btn-warning {
            background-color: #FFC107;
            color: #fff;
        }
        .btn-warning:hover {
            background-color: #e0a800;
            transform: scale(1.05);
        }
        .mapa-mental {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            position: relative;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .nodo {
            margin: 10px;
            padding: 15px;
            border: 2px solid #007BFF;
            border-radius: 10px;
            text-align: center;
            position: relative;
            background-color: #e9f5ff;
            transition: transform 0.3s, background-color 0.3s, box-shadow 0.3s;
        }
        .nodo:hover {
            transform: scale(1.05);
            background-color: #d0eaff;
            box-shadow: 0 6px 12px rgba(0, 123, 255, 0.2);
        }
        .ramo {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }
        .ramo .nodo {
            margin: 0 20px;
        }
        svg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
        }
        input {
            border: none;
            background-color: transparent;
            text-align: center;
            font-size: 16px;
            width: calc(100% - 20px);
        }
        input::placeholder {
            color: #007BFF;
        }
        input:hover::placeholder {
            color: #0056b3;
        }
        input:focus {
            outline: none;
        }
    </style>
</head>
<body>
    <cfoutput>
        <form method="get" action="teste.cfm" class="form-inline">
            <div class="form-group mx-sm-3 mb-2">
                <label for="filtroData" class="sr-only">Data 1º Turno</label>
                <input type="date" class="form-control" name="filtroData" id="filtroData" 
                    value="<cfif isDefined('url.filtroData') AND NOT isNull(url.filtroData)>#url.filtroData#</cfif>"/>
            </div>
            <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
            <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='teste.cfm'">Limpar</button>
        </form>
    </cfoutput>
    <div class="mapa-mental">
        <cfoutput query="consulta">
            <div class="nodo" id="central">
                <label>Apontamento T03 1º Turno</label>
                <input style="color:red;font-weight: bold;font-size:24px;" type="text" placeholder="Conceito Central" value="#consulta.distinct_count#">
            </div>
        </cfoutput>
        <cfoutput query="consulta_f">
            <div class="nodo" id="central">
                <label>Apontamento Linha F 1º Turno</label>
                <input style="color:red;font-weight: bold;font-size:24px;" type="text" placeholder="Conceito Central" value="#consulta_f.distinct_count#">
            </div>
        </cfoutput>
        <cfoutput query="consulta_2">
            <div class="nodo" id="central">
                <label>Apontamento Linha F 2º turno</label>
                <input style="color:red;font-weight: bold;font-size:24px;" type="text" placeholder="Conceito Central" value="#consulta_2.distinct_count#">
            </div>
        </cfoutput>
        <svg id="svg"></svg>
    </div>

    <script>
        function drawLine(from, to) {
            const fromRect = from.getBoundingClientRect();
            const toRect = to.getBoundingClientRect();

            const x1 = fromRect.left + fromRect.width / 2;
            const y1 = fromRect.bottom + window.scrollY; // Adjust for scroll position
            const x2 = toRect.left + toRect.width / 2;
            const y2 = toRect.top + window.scrollY; // Adjust for scroll position

            const svg = document.getElementById('svg');
            
            // Create a path instead of a line for a smoother curve
            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path.setAttribute('d', `M ${x1} ${y1} C ${x1} ${(y1 + y2) / 2}, ${x2} ${(y1 + y2) / 2}, ${x2} ${y2}`);
            path.setAttribute('stroke', '#007BFF');
            path.setAttribute('stroke-width', '2');
            path.setAttribute('fill', 'none');

            svg.appendChild(path);
        }

        window.onload = function() {
            const central = document.getElementById('central');
            const ideias = document.querySelectorAll('.ramo .nodo');

            ideias.forEach(ideia => {
                drawLine(central, ideia);
            });
        };
    </script>
</body>
</html>
