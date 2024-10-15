<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--COnsulta para PDI ESTEIRA SUV-->
    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
                CASE 
                    WHEN INTERVALO = '06:00' THEN '06:00~07:00'
                    WHEN INTERVALO = '07:00' THEN '07:00~08:00'
                    WHEN INTERVALO = '08:00' THEN '08:00~09:00'
                    WHEN INTERVALO = '09:00' THEN '09:00~10:00'
                    WHEN INTERVALO = '10:00' THEN '10:00~11:00'
                    WHEN INTERVALO = '11:00' THEN '11:00~12:00'
                    WHEN INTERVALO = '12:00' THEN '12:00~13:00'
                    WHEN INTERVALO = '13:00' THEN '13:00~14:00'
                    WHEN INTERVALO = '14:00' THEN '14:00~15:00'
                    WHEN INTERVALO = '15:00' THEN '15:00~16:00'
                    ELSE 'OUTROS'
                END HH,
                COUNT(DISTINCT VIN) AS totalVins
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND INTERVALO BETWEEN '06:00' AND '15:00'
            GROUP BY BARREIRA, VIN, INTERVALO
        )
        SELECT BARREIRA, HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>

    <cfquery name="consulta_barreira2" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, VIN,
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
                COUNT(DISTINCT VIN) AS totalVins
            FROM INTCOLDFUSION.sistema_qualidade_pdi
            WHERE INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                AND CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
                = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            GROUP BY BARREIRA, VIN, INTERVALO
        )
        SELECT BARREIRA, HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, HH
        UNION ALL
        SELECT BARREIRA, 
                'TTL' AS HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA
        ORDER BY ordem, HH
    </cfquery>
 
    <cfquery name="qryVINs" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS quantidade_vins
        FROM sistema_qualidade_pdi p
        WHERE 
            NOT EXISTS (
                SELECT 1 
                FROM sistema_qualidade_pdi_saida ps 
                WHERE ps.vin = p.vin AND ps.status = 'LIBERADO'
            )
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
        <title>PDI Indicador Geral-1º turno</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
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
        <!-- Filtro de data -->
        <cfoutput>
            <div class="container">
                <h2>PDI ENTRADA 1º e 2º Turno</h2>
                <form method="get" action="pdi_indicadores_1_entrada.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                    </div>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='pdi_indicadores_1_entrada.cfm'">Limpar</button>
                </form>
            </div>
            </cfoutput>
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <!-- Tabela H/H para Primer - 1º Turno -->
                <div class="col-md-6">
                    <h3>PDI - ENTRADA 1º Turno</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-100" style="font-size:20px">
                            <thead class="bg-danger">
                                <tr>
                                    <th>Hora/Hora</th>
                                    <th>Produzidos</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Tabela H/H para Primer - 2º Turno -->
                <div class="col-md-6">
                    <h3>PDI - ENTRADA 2º Turno</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm w-100" style="font-size:20px">
                            <thead class="bg-success">
                                <tr>
                                    <th>Hora/Hora</th>
                                    <th>Produzidos</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira2">
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                        </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <cfoutput query="qryVINs">
            <cfif qryVINs.quantidade_vins GT 0>
                <div class="col-md-2">
                <div class="container">
                            <table class="table table-sm table-bordered table-striped">
                                <thead class="bg-warning">
                                    <tr>
                                        <th>WIP</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>#qryVINs.quantidade_vins#</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                </div>
            <cfelse>
                <div class="alert alert-warning" role="alert">
                    Não há VINs para mostrar.
                </div>
            </cfif>
        </cfoutput>
            <meta http-equiv="refresh" content="40,URL=pdi_indicadores_1_entrada.cfm">
    </body>
</html>

  