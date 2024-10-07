<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfif isDefined("url.filtroCor")>
        <cfset filtroCor = url.filtroCor> 
    <cfelse>
        <cfset filtroCor = "">
    </cfif>
    <cfif isDefined("url.filtroProblema")>
        <cfset filtroProblema = url.filtroProblema>
    <cfelse>
        <cfset filtroProblema = "">
    </cfif>

    <cfquery name="consulta_nconformidades_cor" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT PROBLEMA, 
                   REGEXP_SUBSTR(MODELO, '[^ ]+$') AS COR,
                   COUNT(*) TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
            WHERE CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
                  = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
                  ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
                AND PROBLEMA IS NOT NULL
                <cfif filtroCor neq "">
                    AND REGEXP_SUBSTR(MODELO, '[^ ]+$') = '#filtroCor#'
                </cfif>
                <cfif filtroProblema neq "">
                    AND PROBLEMA = '#filtroProblema#'
                </cfif>
            GROUP BY PROBLEMA, REGEXP_SUBSTR(MODELO, '[^ ]+$')
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT *
            FROM CONSULTA
        ),
        CONSULTA3 AS (
            SELECT CONSULTA2.*, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT CONSULTA3.*, 
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>
    

    <cfquery name="consulta_nconformidades" datasource="#BANCOSINC#">
        WITH CONSULTA AS (
            SELECT POSICAO, PROBLEMA, COUNT(*) TOTAL_POR_DEFEITO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
            WHERE CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
                  = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
                  ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
                AND PROBLEMA IS NOT NULL
            GROUP BY POSICAO, PROBLEMA
            ORDER BY COUNT(*) DESC
        ),
        CONSULTA2 AS (
            SELECT *
            FROM CONSULTA
        ),
        CONSULTA3 AS (
            SELECT CONSULTA2.*, 
            SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) TOTAL_ACUMULADO
            FROM CONSULTA2
        ),
        CONSULTA4 AS (
            SELECT CONSULTA3.*, 
            ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) PARETO
            FROM CONSULTA3
        )
        SELECT * FROM CONSULTA4
    </cfquery>
    


<cfif isDefined("url.filtroNCM")>
    <cfset filtroNCM = url.filtroNCM> 
<cfelse>
    <cfset filtroNCM = "">
</cfif>

<cfif isDefined("url.filtroProblema")>
    <cfset filtroProblema = url.filtroProblema>
<cfelse>
    <cfset filtroProblema = "">
</cfif>

<cfquery name="consulta_nconformidades_ncm" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT POSICAO,
               PROBLEMA, 
               REGEXP_SUBSTR(MODELO, '([^ ]+ [^ ]+)') AS NCM,
               COUNT(*) TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE PAINT
        WHERE CASE WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) ELSE TRUNC(USER_DATA) END 
              = CASE WHEN SUBSTR('#url.filtroData#', 12,5) <= '01:02' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')-1) 
              ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) END
            AND PROBLEMA IS NOT NULL
            <cfif filtroNCM neq "">
                AND REGEXP_SUBSTR(MODELO, '([^ ]+ [^ ]+)') = '#filtroNCM#'
            </cfif>
            <cfif filtroProblema neq "">
                AND PROBLEMA = '#filtroProblema#'
            </cfif>
        GROUP BY POSICAO, PROBLEMA, REGEXP_SUBSTR(MODELO, '([^ ]+ [^ ]+)')
        ORDER BY COUNT(*) DESC
    ),
    CONSULTA2 AS (
        SELECT *
        FROM CONSULTA
    ),
    CONSULTA3 AS (
        SELECT CONSULTA2.*, 
        SUM(TOTAL_POR_DEFEITO) OVER (ORDER BY TOTAL_POR_DEFEITO DESC) TOTAL_ACUMULADO
        FROM CONSULTA2
    ),
    CONSULTA4 AS (
        SELECT CONSULTA3.*, 
        ROUND(TOTAL_ACUMULADO / SUM(TOTAL_POR_DEFEITO) OVER () * 100, 1) PARETO
        FROM CONSULTA3
    )
    SELECT * FROM CONSULTA4
</cfquery>



    <!-- Verificando se está logado -->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = 'index.cfm'
        </script>
    </cfif>
    
    <html lang="pt-BR">
        <head>
            <!-- Meta tags necessárias -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Indicadores - Gerais</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
            <link rel="stylesheet" href="assets/css/style.css?v=11"> 
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br>
          
            <!-- Filtro de data -->
            <h2>Indicador geral dos Turnos</h2>
            <div class="container">
                <form method="get" action="indicadores_paint_geral.cfm" class="form-inline">
                    <div class="form-group mx-sm-3 mb-2">
                        <label for="filtroData" class="sr-only">Data:</label>
                        <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
                    </div>
                    <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
                    <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='indicadores_paint_geral.cfm'">Limpar</button>
                </form>
            </div>
            
            <!-- Tabelas e Gráficos -->
            <div class="container">
                <div class="row">
                    <!-- Tabela 1 -->
                    <div class="col-md-4">
                        <h3>N.C. por Posição</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="4" class="bg-warning">Principais Não Conformidades do Dia</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Posição</th>
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades">
                                        <tr class="align-middle">
                                            <td style="font-weight: bold">#POSICAO#</td>
                                            <td style="font-weight: bold">#PROBLEMA#</td>
                                            <td>#TOTAL_POR_DEFEITO#</td>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
        
                    <!-- Tabela 2 -->
                    <div class="col-md-4">
                        <h3>N.C. por Cor</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="4" class="bg-warning">Principais Não Conformidades</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Cor</th>
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_cor">
                                        <tr class="align-middle">
                                            <td style="font-weight: bold">#COR#</td>
                                            <td style="font-weight: bold">#PROBLEMA#</td>
                                            <td>#TOTAL_POR_DEFEITO#</td>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
        
                    <!-- Tabela 3 -->
                    <div class="col-md-4">
                        <h3>N.C por modelo</h3>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm table-custom-width" border="1" id="tblStocks" data-excel-name="Veículos">
                                <thead>
                                    <tr class="text-nowrap">
                                        <th scope="col" colspan="4" class="bg-warning">Principais Não Conformidades</th>
                                    </tr>
                                    <tr class="text-nowrap">
                                        <th scope="col">Modelo</th>
                                        <th scope="col">Posição</th>
                                        <th scope="col">Problema</th>
                                        <th scope="col">Total</th>
                                    </tr>
                                </thead>
                                <tbody class="table-group-divider">
                                    <cfoutput query="consulta_nconformidades_ncm">
                                        <tr class="align-middle">
                                            <td style="font-weight: bold; font-size:13px">#NCM#</td>
                                            <td style="font-weight: bold">#POSICAO#</td>
                                            <td style="font-weight: bold">#PROBLEMA#</td>
                                            <td>#TOTAL_POR_DEFEITO#</td>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <meta http-equiv="refresh" content="40,URL=indicadores_paint_geral.cfm">

            <div class="floating-arrow" onclick="scrollToTop();">
                <i class="material-icons">arrow_upward</i>
            </div>
        
            <!-- Script para voltar ao topo suavemente -->
            <script>
                function scrollToTop() {
                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth'
                    });
                }
            </script>
    </body>
</html>
        