<cfquery name="qMassivaFaiVins" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT 
            mf.VIN,
            mf.STATUS,
            MAX(sq.CRITICIDADE) AS CRITICIDADE,
            MAX(sq.RESPONSAVEL_LIBERACAO) AS RESPONSAVEL_LIBERACAO,
            CASE 
                WHEN COUNT(CASE WHEN sq.CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') THEN 1 END) = 0 
                    AND COUNT(CASE WHEN sq.CRITICIDADE IN ('N0', 'OK A-', 'AVARIA','CRIPPLE') OR sq.CRITICIDADE IS NULL THEN 1 END) > 0 
                    THEN 'SIM'
                WHEN COUNT(CASE WHEN sq.CRITICIDADE IN ('N1', 'N2', 'N3', 'N4') AND sq.RESPONSAVEL_LIBERACAO IS NOT NULL THEN 1 END) > 0 
                    THEN 'SIM'
                WHEN COUNT(CASE WHEN sq.CRITICIDADE IS NULL AND sq.RESPONSAVEL_LIBERACAO IS NOT NULL THEN 1 END) > 0 
                    THEN 'SIM'
                ELSE 'NÃO'
            END AS ExisteNoSistema
        FROM 
            massiva_fai mf
        LEFT JOIN 
            sistema_qualidade_fa sq ON mf.VIN = sq.VIN
        WHERE 
            mf.STATUS IS NULL
            AND sq.BARREIRA = 'CP7'
        GROUP BY
            mf.VIN, mf.STATUS
        ORDER BY ExisteNoSistema DESC
    )
    SELECT * FROM CONSULTA
    WHERE ExisteNoSistema = 'NÃO'
</cfquery>

<!DOCTYPE html>
<html lang="pt">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tabela Massiva FA</title>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br><br><br><br>

        <div class="row">
            <div class="col">
                <h3>T1A</h3>
                <table class="table">
                    <tbody>
                        <cfset countT1A = 0>
                        <cfset countT1A_OK = 0>
                        
                        <!-- Contagem de todos os VINs que começam com "95PD" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PD">
                                <cfset countT1A = countT1A + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PD" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PD" AND STATUS EQ "OK">
                                <cfset countT1A_OK = countT1A_OK + 1>
                            </cfif>
                        </cfoutput>
            
                        <cfset countT1A_falta = countT1A - countT1A_OK>
                        <cfoutput>
                            <tr>
                                <td style="background:yellow">Total: #countT1A#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableT1A" aria-expanded="false" aria-controls="vinTableT1A">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableT1A">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PD">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col">
                <h3>T1E</h3>
                <table class="table">
                    <tbody>
                        <cfset countT1E = 0>
                        <cfset countT1E_OK = 0>
            
                        <!-- Contagem de todos os VINs que começam com "95PE" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PE">
                                <cfset countT1E = countT1E + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PE" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PE" AND STATUS EQ "OK">
                                <cfset countT1E_OK = countT1E_OK + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Cálculo da Falta -->
                        <cfset countT1E_falta = countT1E - countT1E_OK>
                        <cfoutput>
                            <tr>
                                <td style="background:yellow">Total: #countT1E#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableT1E" aria-expanded="false" aria-controls="vinTableT1E">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableT1E">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PE">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col">
                <h3>T19</h3>
                <table class="table">
                    <tbody>
                        <cfset countT19 = 0>
                        <cfset countT19_OK = 0>
            
                        <!-- Contagem de todos os VINs que começam com "95PB" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PB">
                                <cfset countT19 = countT19 + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PB" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PB" AND STATUS EQ "OK">
                                <cfset countT19_OK = countT19_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                            <!-- Cálculo da Falta -->
                            <cfset countT19_falta = countT19 - countT19_OK>
            
                            <tr>
                                <td style="background:yellow">Total: #countT19#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableT19" aria-expanded="false" aria-controls="vinTableT19">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableT19">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PB">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col">
                <h3>T18</h3>
                <table class="table">
                    <tbody>
                        <cfset countT18 = 0>
                        <cfset countT18_OK = 0>
            
                        <!-- Contagem de todos os VINs que começam com "95PF" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PF">
                                <cfset countT18 = countT18 + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PF" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PF" AND STATUS EQ "OK">
                                <cfset countT18_OK = countT18_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                            <!-- Cálculo da Falta -->
                            <cfset countT18_falta = countT18 - countT18_OK>
            
                            <tr>
                                <td style="background:yellow">Total: #countT18#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableT18" aria-expanded="false" aria-controls="vinTableT18">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableT18">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PF">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col">
                <h3>HR</h3>
                <table class="table">
                    <tbody>
                        <cfset countHR = 0>
                        <cfset countHR_OK = 0>
            
                        <!-- Contagem de todos os VINs que começam com "95PZ" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PZ">
                                <cfset countHR = countHR + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PZ" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PZ" AND STATUS EQ "OK">
                                <cfset countHR_OK = countHR_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                            <!-- Cálculo da Falta -->
                            <cfset countHR_falta = countHR - countHR_OK>
            
                            <tr>
                                <td style="background:yellow">Total: #countHR#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableHR" aria-expanded="false" aria-controls="vinTableHR">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableHR">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PZ">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>            

            <div class="col">
                <h3>TL</h3>
                <table class="table">
                    <tbody>
                        <cfset countTL = 0>
                        <cfset countTL_OK = 0>
            
                        <!-- Contagem de todos os VINs que começam com "95PJ" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PJ">
                                <cfset countTL = countTL + 1>
                            </cfif>
                        </cfoutput>
            
                        <!-- Contagem de VINs com status 'OK' que começam com "95PJ" -->
                        <cfoutput query="qMassivaFaiVins">
                            <cfif left(VIN, 4) EQ "95PJ" AND STATUS EQ "OK">
                                <cfset countTL_OK = countTL_OK + 1>
                            </cfif>
                        </cfoutput>
                        <cfoutput>
                            <!-- Cálculo da Falta -->
                            <cfset countTL_falta = countTL - countTL_OK>
            
                            <tr>
                                <td style="background:yellow">Total: #countTL#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            
                <!-- Botão para mostrar/esconder a tabela de VINs -->
                <div class="text-center">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vinTableTL" aria-expanded="false" aria-controls="vinTableTL">
                        Mostrar/Esconder VINs
                    </button>
                </div>
            
                <!-- Tabela de VINs filtrados em formato dropdown -->
                <div class="collapse mt-3" id="vinTableTL">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>VIN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="qMassivaFaiVins">
                                <cfif left(VIN, 4) EQ "95PJ">
                                    <tr>
                                        <td>#currentRow#</td>
                                        <td>#VIN#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <meta http-equiv="refresh" content="40,URL=acompanhamento_massiva_fa.cfm">
    </body>
</html>