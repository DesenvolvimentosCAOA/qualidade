<cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("url.filtroData")>
        <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
    <cfelse>
        <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()), 'yyyy-mm-dd HH:nn:ss')>
    </cfif>

    <cfquery name="contaVINporColaborador" datasource="#BANCOSINC#">
        SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE BARREIRA = 'ROAD TEST'
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
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
                AND INTERVALO BETWEEN '06:00' AND '15:00'
        GROUP BY USER_COLABORADOR, INTERVALO
        ORDER BY USER_COLABORADOR, TO_DATE(INTERVALO, 'HH24:MI')
    </cfquery>

    <cfquery name="contaVINporColaborador2" datasource="#BANCOSINC#">
        SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE BARREIRA = 'ROAD TEST'
        AND INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
        AND (
            (TO_CHAR(USER_DATA, 'D') BETWEEN 2 AND 6 -- Segunda a Quinta-feira
                        AND INTERVALO IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                        AND CASE 
                                WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) 
                                ELSE TRUNC(USER_DATA) 
                            END = CASE 
                                    WHEN SUBSTR('#url.filtroData#', 12, 5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                                    ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                                END
                    )
                OR (TO_CHAR(USER_DATA, 'D') = '7' -- Sexta-feira
                    AND INTERVALO IN ('15:00', '15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
                    AND TO_CHAR(USER_DATA, 'HH24:MI') BETWEEN '15:00' AND '23:00'
                    AND CASE 
                            WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '02:00' THEN TRUNC(USER_DATA - 1) 
                            ELSE TRUNC(USER_DATA) 
                        END = CASE 
                                WHEN SUBSTR('#url.filtroData#', 12, 5) <= '02:00' THEN TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS') - 1) 
                                ELSE TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS')) 
                            END
                    )
                )
        GROUP BY USER_COLABORADOR, INTERVALO
        ORDER BY USER_COLABORADOR, TO_DATE(INTERVALO, 'HH24:MI')
    </cfquery>

    <cfquery name="contaVINporColaborador3" datasource="#BANCOSINC#">
        SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE BARREIRA = 'ROAD TEST'
        AND TRUNC(USER_DATA) = 
                <cfif isDefined("url.filtroData") AND NOT isNull(url.filtroData) AND len(trim(url.filtroData)) gt 0>
                    #CreateODBCDate(url.filtroData)#
                <cfelse>
                    TRUNC(SYSDATE)
                </cfif>
                AND (
                    -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                    -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                    ))
                )
        GROUP BY USER_COLABORADOR, INTERVALO
        ORDER BY USER_COLABORADOR, TO_DATE(INTERVALO, 'HH24:MI')
    </cfquery>

<!-- Cria uma estrutura para armazenar os intervalos -->
<cfset intervals = StructNew()>

<cfoutput query="contaVINporColaborador">
    <cfset intervals[INTERVALO] = 1>
</cfoutput>

<!-- Transformar os intervalos em uma lista e ordenar -->
<cfset intervalList = StructKeyList(intervals)>
<cfset intervalArray = ListToArray(intervalList, ",")>
<cfset ArraySort(intervalArray, "text", "asc")>

<!--- Definindo um valor padrão para url.filtroData caso não esteja definido --->
<cfparam name="url.filtroData" default="#DateFormat(Now(), 'yyyy-mm-dd')# 15:00:00">

<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_fai") or (cookie.user_level_fai eq "R" or cookie.user_level_fai eq "P" or cookie.user_level_fai eq "I")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acompanhamento</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Estilos personalizados para a tabela */
        .small-table {
            width: 50%; /* Ajuste o valor conforme necessário para diminuir a tabela */
            margin: 0 auto; /* Centraliza a tabela */
            font-size: 14px; /* Tamanho da fonte menor */
        }
        .small-table th, .small-table td {
            padding: 8px; /* Reduz o preenchimento das células para economizar espaço */
            text-align: left;
        }
        .small-text {
            font-size: 0.7rem; /* Ajuste o tamanho conforme necessário */
        }
        h1{
            text-align:center;
        }
    </style>
</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>
    <h1>Acompanhamento Pista</h1>
    <div class="container mt-5">

        <form method="get" action="acompanhamento_road.cfm" class="form-inline">
            <div class="form-group mx-sm-3 mb-2">
                <label for="filtroData" class="sr-only">Data:</label>
                <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined('url.filtroData')>#url.filtroData#</cfif>"/>
            </div>
            <button class="btn btn-primary mb-2" type="submit">Filtrar</button>
            <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='acompanhamento_road.cfm'">Limpar</button>
        </form>

        <div class="row">
            <div class="col-md-12 table-container">
                <h2 class="mb-4 text-center">Road Test - 1º Turno</h2>
                <table class="table table-striped table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <!-- Construir dinamicamente as colunas dos intervalos -->
                            <cfoutput>
                                <cfset intervals = StructNew()>
                                <cfloop query="contaVINporColaborador">
                                    <cfset intervals[INTERVALO] = 1>
                                </cfloop>
                                
                                <cfset intervalList = StructKeyList(intervals)>
                                <cfset intervalArray = ListToArray(intervalList, ",")>
                                <cfset ArraySort(intervalArray, "text", "asc")>
                                
                                <cfloop array="#intervalArray#" index="interval">
                                    <th>#interval#</th>
                                </cfloop>
                            </cfoutput>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador" group="USER_COLABORADOR">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <!-- Inicializar as contagens por intervalo -->
                                <cfset intervalCounts = StructNew()>
                                <cfloop array="#intervalArray#" index="interval">
                                    <cfset intervalCounts[interval] = 0>
                                </cfloop>
                                <!-- Variável para contar o total de veículos inspecionados -->
                                <cfset totalVeiculos = 0>
                                <!-- Preencher as contagens com dados da consulta -->
                                <cfoutput>
                                    <cfif StructKeyExists(intervalCounts, INTERVALO)>
                                        <cfset intervalCounts[INTERVALO] = total_vin_distintos>
                                        <!-- Adiciona ao total para o colaborador atual -->
                                        <cfset totalVeiculos = totalVeiculos + total_vin_distintos>
                                    </cfif>
                                </cfoutput>
                                <!-- Imprimir as contagens -->
                                <cfloop array="#intervalArray#" index="interval">
                                    <td>#intervalCounts[interval]#</td>
                                </cfloop>
                                <!-- Total de veículos inspecionados -->
                                <td>#totalVeiculos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col-md-12 table-container">
                <h2 class="mb-4 text-center">Road Test - 2º Turno</h2>
                <table class="table table-striped table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <!-- Construir dinamicamente as colunas dos intervalos -->
                            <cfoutput>
                                <cfset intervals = StructNew()>
                                <cfloop query="contaVINporColaborador2">
                                    <cfset intervals[INTERVALO] = 1>
                                </cfloop>
                                
                                <cfset intervalList = StructKeyList(intervals)>
                                <cfset intervalArray = ListToArray(intervalList, ",")>
                                <cfset ArraySort(intervalArray, "text", "asc")>
                                
                                <cfloop array="#intervalArray#" index="interval">
                                    <th>#interval#</th>
                                </cfloop>
                            </cfoutput>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador2" group="USER_COLABORADOR">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <!-- Inicializar as contagens por intervalo -->
                                <cfset intervalCounts = StructNew()>
                                <cfloop array="#intervalArray#" index="interval">
                                    <cfset intervalCounts[interval] = 0>
                                </cfloop>
                                <!-- Variável para contar o total de veículos inspecionados -->
                                <cfset totalVeiculos = 0>
                                <!-- Preencher as contagens com dados da consulta -->
                                <cfoutput>
                                    <cfif StructKeyExists(intervalCounts, INTERVALO)>
                                        <cfset intervalCounts[INTERVALO] = total_vin_distintos>
                                        <!-- Adiciona ao total para o colaborador atual -->
                                        <cfset totalVeiculos = totalVeiculos + total_vin_distintos>
                                    </cfif>
                                </cfoutput>
                                <!-- Imprimir as contagens -->
                                <cfloop array="#intervalArray#" index="interval">
                                    <td>#intervalCounts[interval]#</td>
                                </cfloop>
                                <!-- Total de veículos inspecionados -->
                                <td>#totalVeiculos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col-md-12 table-container">
                <h2 class="mb-4 text-center">Road Test - 3º Turno</h2>
                <table class="table table-striped table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <!-- Construir dinamicamente as colunas dos intervalos -->
                            <cfoutput>
                                <cfset intervals = StructNew()>
                                <cfloop query="contaVINporColaborador3">
                                    <cfset intervals[INTERVALO] = 1>
                                </cfloop>
                                
                                <cfset intervalList = StructKeyList(intervals)>
                                <cfset intervalArray = ListToArray(intervalList, ",")>
                                <cfset ArraySort(intervalArray, "text", "asc")>
                                
                                <cfloop array="#intervalArray#" index="interval">
                                    <th>#interval#</th>
                                </cfloop>
                            </cfoutput>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador3" group="USER_COLABORADOR">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <!-- Inicializar as contagens por intervalo -->
                                <cfset intervalCounts = StructNew()>
                                <cfloop array="#intervalArray#" index="interval">
                                    <cfset intervalCounts[interval] = 0>
                                </cfloop>
                                <!-- Variável para contar o total de veículos inspecionados -->
                                <cfset totalVeiculos = 0>
                                <!-- Preencher as contagens com dados da consulta -->
                                <cfoutput>
                                    <cfif StructKeyExists(intervalCounts, INTERVALO)>
                                        <cfset intervalCounts[INTERVALO] = total_vin_distintos>
                                        <!-- Adiciona ao total para o colaborador atual -->
                                        <cfset totalVeiculos = totalVeiculos + total_vin_distintos>
                                    </cfif>
                                </cfoutput>
                                <!-- Imprimir as contagens -->
                                <cfloop array="#intervalArray#" index="interval">
                                    <td>#intervalCounts[interval]#</td>
                                </cfloop>
                                <!-- Total de veículos inspecionados -->
                                <td>#totalVeiculos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>