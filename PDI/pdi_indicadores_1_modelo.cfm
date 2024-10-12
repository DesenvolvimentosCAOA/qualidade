<cfinvoke method="inicializando" component="cf.ini.index">

    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <!--Consulta para PDI-->
    <cfquery name="consulta_nconformidades_pdi" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, PECA, ESTACAO, COUNT(*) AS TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE TRUNC(USER_DATA) =
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
            AND PROBLEMA IS NOT NULL
            AND CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA')
            AND BARREIRA = 'PDI'
                          
              AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
            )
              GROUP BY PROBLEMA, PECA, ESTACAO
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                ROW_NUMBER() OVER (ORDER BY TOTAL_POR_DEFEITO DESC, PROBLEMA) AS RNUM
            FROM CONSULTA
            WHERE ROWNUM <= 10
        ),
        CONSULTA3 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, 
                SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY RNUM) AS TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT PROBLEMA, PECA, ESTACAO, TOTAL_POR_DEFEITO, TOTAL_ACUMULADO,
                ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) AS PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>

    <cfquery name="consulta_barreira" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT 
                BARREIRA, MODELO, VIN,
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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
            WHERE TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND INTERVALO BETWEEN '06:00' AND '15:00'
                -- AND MODELO LIKE 'TIGGO 7%'
            GROUP BY BARREIRA, MODELO, VIN, INTERVALO
        )
        SELECT BARREIRA, MODELO, HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
                
                -- Cálculo do DPV: total de VINs distintos dividido pelo número de registros com criticidades N1, N2, N3 e N4
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                1 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, MODELO, HH
        UNION ALL
        SELECT BARREIRA, MODELO,
                'TTL' AS HH, 
                COUNT(DISTINCT VIN) AS TOTAL, 
                SUM(APROVADO_FLAG) AS APROVADOS, 
                COUNT(DISTINCT VIN) - SUM(APROVADO_FLAG) AS REPROVADOS,
                ROUND(SUM(APROVADO_FLAG) / COUNT(DISTINCT VIN) * 100, 1) AS PORCENTAGEM, 
                ROUND(SUM(totalProblemas) / NULLIF(SUM(totalVins), 0), 2) AS DPV,
                2 AS ordem
        FROM CONSULTA
        GROUP BY BARREIRA, MODELO
        ORDER BY ordem, HH
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
        <title>PDI Indicador-1º turno</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br>
        
        <!-- Filtro de data -->
        <cfoutput>
            <div class="container">
                <h2>PDI 1º Turno</h2>
                <form method="get" action="pdi_indicadores_1_modelo.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>" onchange="this.form.submit();"/>
                    </div>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='pdi_indicadores_1_modelo.cfm'">Limpar</button>
                </form>
            </div>
        </cfoutput>
    
        <!-- Exibindo tabelas e gráficos para cada barreira -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-2 p-0">
                    <h3>Tiggo 7</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #f8d7da;"> <!-- Troquei a cor de fundo -->
                            <thead class="bg-danger"> <!-- Troquei a cor do cabeçalho -->
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('TIGGO 7', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Tabela H/H para Tiggo 8 -->
                <div class="col-md-2 p-0">
                    <h3>Tiggo 8</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #d1ecf1;"> <!-- Troquei a cor de fundo -->
                            <thead class="bg-info"> <!-- Troquei a cor do cabeçalho -->
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('TIGGO 8', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Tabela H/H para Tiggo 5 -->
            
                <div class="col-md-2 p-0">
                    <h3>Tiggo 5</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #d4edda;"> <!-- Troquei a cor de fundo -->
                            <thead class="bg-success">
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('TIGGO 5', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2 p-0">
                    <h3>Tucson</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #DAA520;">
                            <thead class="bg-warning">
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('TUCSON', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-2 p-0">
                    <h3>HR</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #9370DB;">
                            <thead class="bg-info">
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('HR', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="row">
                    <div class="col-md-2 p-0">
                        <h3>IX35</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #f8d7da;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-danger"> <!-- Troquei a cor do cabeçalho -->
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('IX35', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>

                <!-- Tabela H/H para FOrester -->
                <div class="col-md-2 p-0">
                    <h3>FORESTER</h3>
                    <div class="table-responsive">
                        <table class="table table-hover table-sm" style="font-size:12px; background-color: #d1ecf1;"> <!-- Troquei a cor de fundo -->
                            <thead class="bg-info"> <!-- Troquei a cor do cabeçalho -->
                                <tr>
                                    <th style="width:3vw">H/H</th>
                                    <th style="width:1vw">Prod</th>
                                    <th style="width:1vw">Aprov</th>
                                    <th style="width:1vw">%</th>
                                    <th>DPV</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="consulta_barreira">
                                    <cfif FindNoCase('FORESTER', MODELO)>
                                        <tr>
                                            <td>#HH#</td>
                                            <td>#TOTAL#</td>
                                            <td>#APROVADOS#</td>
                                            <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                            <td>#DPV#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Tabela H/H para azera -->
                    <div class="col-md-2 p-0">
                        <h3>AZERA</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #d4edda;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-success">
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('AZERA', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-2 p-0">
                        <h3>SUBARU</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #DAA520;">
                                <thead class="bg-warning">
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('SUBARU', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="col-md-2 p-0">
                        <h3>SANTA FÉ</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #9370DB;">
                                <thead class="bg-info">
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('SANTA', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
            </div>
            <div class="row">
                    <div class="col-md-2 p-0">
                        <h3>IONIQ</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #f8d7da;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-danger"> <!-- Troquei a cor do cabeçalho -->
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('IONIQ', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                
                <!-- Tabela H/H para outback-->
                    <div class="col-md-2 p-0">
                        <h3>OUTBACK</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #d1ecf1;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-info"> <!-- Troquei a cor do cabeçalho -->
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('OUTBACK', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <!-- Tabela H/H para kona -->
                    <div class="col-md-2 p-0">
                        <h3>KONA</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #d4edda;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-success">
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('KONA', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <!-- Tabela H/H para kona -->
                    <div class="col-md-2 p-0">
                        <h3>HD 80</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm" style="font-size:12px; background-color: #d4edda;"> <!-- Troquei a cor de fundo -->
                                <thead class="bg-DANGER">
                                    <tr>
                                        <th style="width:3vw">H/H</th>
                                        <th style="width:1vw">Prod</th>
                                        <th style="width:1vw">Aprov</th>
                                        <th style="width:1vw">%</th>
                                        <th>DPV</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="consulta_barreira">
                                        <cfif FindNoCase('HD', MODELO)>
                                            <tr>
                                                <td>#HH#</td>
                                                <td>#TOTAL#</td>
                                                <td>#APROVADOS#</td>
                                                <td style="font-weight: bold; <cfif PORCENTAGEM gt '86.0'>color: green;<cfelseif PORCENTAGEM lt '86.0'> color: red;</cfif>">#PORCENTAGEM#%</td>
                                                <td>#DPV#</td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        <meta http-equiv="refresh" content="40,URL=pdi_indicadores_1_modelo.cfm">
    </body>
</html>

  