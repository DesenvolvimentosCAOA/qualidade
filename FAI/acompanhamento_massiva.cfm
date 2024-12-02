<cfinvoke method="inicializando" component="cf.ini.index">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!-- Consulta para obter todos os VINs -->
    <cfquery name="consulta_cripple" datasource="#BANCOSINC#">
        SELECT DISTINCT VIN, ID 
        FROM massiva_fai
    </cfquery>

    <!-- Consulta para obter apenas os VINs com Liberados -->
    <cfquery name="consulta_cripple_ok" datasource="#BANCOSINC#">
        SELECT DISTINCT VIN, ID 
        FROM massiva_fai
        WHERE status = 'OK'
    </cfquery>

    <cfquery name="consulta_total" datasource="#BANCOSINC#">
        SELECT COUNT(DISTINCT VIN) AS total_vin
        FROM massiva_fai
        WHERE STATUS IS NULL
    </cfquery>

    <cfquery name="consulta_vins" datasource="#BANCOSINC#">
        SELECT COUNT(DISTINCT VIN) AS total_vin
        FROM massiva_fai
        WHERE status = 'OK'
    </cfquery>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tabela Massiva FAI</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

    <div class="container mt-4">
        <cfoutput>
            <cfset diferenca = consulta_total.total_vin - consulta_vins.total_vin>
            <h2 class="mb-4">Dados Massiva FAI:</h2>
            <h4 style="color:purple">Total de Massiva: #consulta_total.total_vin#</h4>
            <h4 style="color:green">Total de Massiva OK: #consulta_vins.total_vin#</h4>
            <h4 style="color:red">Faltam: #diferenca#</h4>
        </cfoutput><br><br><br>
        <div class="row">
            <div class="col">
                <h3>T1A</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countT1A = 0>
                        <cfset countT1A_OK = 0>
                        
                        <!-- Contagem de todos os VINs que começam com "95PD" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PD">
                                <cfset countT1A = countT1A + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PD" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PD">
                                <cfset countT1A_OK = countT1A_OK + 1>
                            </cfif>
                        </cfoutput>

                        <cfset countT1A_falta = countT1A - countT1A_OK>
                        <cfoutput>
                            <tr>
                                <td style="background:yellow">Total: #countT1A#</td>
                            </tr>
                            <tr>
                                <td style="background:green; color:white">Liberados: #countT1A_OK#</td>
                            </tr>
                            <tr>
                                <td style="background:red; color:white">Falta: #countT1A_falta#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col">
                <h3>T1E</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countT1E = 0>
                        <cfset countT1E_OK = 0>

                        <!-- Contagem de todos os VINs que começam com "95PE" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PE">
                                <cfset countT1E = countT1E + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PE" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PE">
                                <cfset countT1E_OK = countT1E_OK + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Cálculo da Falta -->
                        <cfset countT1E_falta = countT1E - countT1E_OK>
                        <cfoutput>
                        <tr>
                            <td style="background:yellow">Total: #countT1E#</td>
                        </tr>
                        <tr>
                            <td style="background:green; color:white">Liberados: #countT1E_OK#</td>
                        </tr>
                        <tr>
                            <td style="background:red; color:white">Falta: #countT1E_falta#</td>
                        </tr>
                    </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col">
                <h3>T19</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countT19 = 0>
                        <cfset countT19_OK = 0>

                        <!-- Contagem de todos os VINs que começam com "95PB" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PB">
                                <cfset countT19 = countT19 + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PB" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PB">
                                <cfset countT19_OK = countT19_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                        
                        <!-- Cálculo da Falta -->
                        <cfset countT19_falta = countT19 - countT19_OK>

                        <tr>
                            <td style="background:yellow">Total: #countT19#</td>
                        </tr>
                        <tr>
                            <td style="background:green; color:white">Liberados: #countT19_OK#</td>
                        </tr>
                        <tr>
                            <td style="background:red; color:white">Falta: #countT19_falta#</td>
                        </tr>
                    </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col">
                <h3>T18</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countT18 = 0>
                        <cfset countT18_OK = 0>

                        <!-- Contagem de todos os VINs que começam com "95PF" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PF">
                                <cfset countT18 = countT18 + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PF" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PF">
                                <cfset countT18_OK = countT18_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                        <!-- Cálculo da Falta -->
                        <cfset countT18_falta = countT18 - countT18_OK>

                        <tr>
                            <td style="background:yellow">Total: #countT18#</td>
                        </tr>
                        <tr>
                            <td style="background:green; color:white">Liberados: #countT18_OK#</td>
                        </tr>
                        <tr>
                            <td style="background:red; color:white">Falta: #countT18_falta#</td>
                        </tr>
                    </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col">
                <h3>HR</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countHR = 0>
                        <cfset countHR_OK = 0>

                        <!-- Contagem de todos os VINs que começam com "95PZ" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PZ">
                                <cfset countHR = countHR + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PZ" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PZ">
                                <cfset countHR_OK = countHR_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                        <!-- Cálculo da Falta -->
                        <cfset countHR_falta = countHR - countHR_OK>

                        <tr>
                            <td style="background:yellow">Total: #countHR#</td>
                        </tr>
                        <tr>
                            <td style="background:green; color:white">Liberados: #countHR_OK#</td>
                        </tr>
                        <tr>
                            <td style="background:red; color:white">Falta: #countHR_falta#</td>
                        </tr>
                    </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col">
                <h3>TL</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Contagem de Massiva</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset countTL = 0>
                        <cfset countTL_OK = 0>

                        <!-- Contagem de todos os VINs que começam com "95PJ" -->
                        <cfoutput query="consulta_cripple">
                            <cfif left(VIN, 4) EQ "95PJ">
                                <cfset countTL = countTL + 1>
                            </cfif>
                        </cfoutput>

                        <!-- Contagem de VINs com status 'OK' que começam com "95PJ" -->
                        <cfoutput query="consulta_cripple_ok">
                            <cfif left(VIN, 4) EQ "95PJ">
                                <cfset countTL_OK = countTL_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                        <!-- Cálculo da Falta -->
                        <cfset countTL_falta = countTL - countTL_OK>

                        <tr>
                            <td style="background:yellow">Total: #countTL#</td>
                        </tr>
                        <tr>
                            <td style="background:green; color:white">Liberados: #countTL_OK#</td>
                        </tr>
                        <tr>
                            <td style="background:red; color:white">Falta: #countTL_falta#</td>
                        </tr>
                    </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <meta http-equiv="refresh" content="40,URL=acompanhamento_massiva.cfm">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
