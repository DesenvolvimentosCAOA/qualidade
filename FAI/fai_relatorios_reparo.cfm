<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

    <!---  Consulta  --->
    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE 1 = 1 
        <cfif isDefined("url.data") and url.data neq "">
            AND TO_CHAR(REPARO_DATA, 'dd/mm/yy') = '#lsdateformat(url.data, 'dd/mm/yy')#'
        <cfelse>
            AND TRUNC(REPARO_DATA) = TRUNC(SYSDATE)
        </cfif>
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(RESPONSAVEL_REPARO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        <cfif isDefined("url.filtroPROBLEMA") and url.filtroPROBLEMA neq "">
            AND UPPER(PROBLEMA_REPARO) LIKE UPPER('%#url.filtroPROBLEMA#%')
        </cfif>
        <cfif isDefined("url.filtroCRITICIDADE") and url.filtroCRITICIDADE neq "">
            AND UPPER(CRITICIDADE) LIKE UPPER('%#url.filtroCRITICIDADE#%')
        </cfif>
        <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
        </cfif>
        AND TIPO_REPARO IS NOT NULL
        
        ORDER BY ID DESC
    </cfquery>

    <html lang="pt-BR">
    <head>
        <!-- Required meta tags-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Relatórios</title>
        <!-- Bootstrap CSS -->
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/stylerelatorio.css?v1">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br><br>
    
        
            <h2 class="titulo2">Relatórios</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <form method="get">
                <div class="form-row">
                    <div class="form-group col-md-23">
                        <label for="formData">Data</label>
                        <cfoutput>
                            <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfif isDefined('url.data')>#url.data#<cfelse>#lsdateformat(now(),'yyyy-mm-dd')#</cfif>">
                        </cfoutput>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN">
                    </div>
                    <div class="form-group col-md-23">
                        <label for="formBARREIRA">Barreira</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARREIRA" id="formBARREIRA">
                    </div>
                    <div class="form-group col-md-23">
                        <label for="formESTACAO">SHOP</label>
                        <input type="text" class="form-control form-control-sm" name="filtroESTACAO" id="formESTACAO">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formPROBLEMA">Problema</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPROBLEMA" id="formPROBLEMA">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-23">
                        <label for="formCRITICIDADE">Criticidade</label>
                        <select class="form-control form-control-sm" name="filtroCRITICIDADE" id="formCRITICIDADE">
                            <option value="">SELECIONE</option>
                            <option value="N0">N0</option>
                            <option value="N1">N1</option>
                            <option value="N2">N2</option>
                            <option value="N3">N3</option>
                            <option value="N4">N4</option>
                            <option value="OK A-">OK A-</option>
                        </select>
                    </div>
                    
                    <div class="form-group col-md-2">
                        <label for="formMODELO">Modelo</label>
                        <select class="form-control form-control-sm" name="filtroMODELO" id="formMODELO">
                            <option value="">SELECIONE</option>
                            <option value="TIGGO 5">T19</option>
                            <option value="TIGGO 7">T1E</option>
                            <option value="TIGGO 8 ADAS">T1A</option>
                            <option value="TIGGO 83">T18</option>
                            <option value="HR">HR</option>
                            <option value="TL">TL</option>
                        </select>
                    </div>
                    
                </div>
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="submit" class="btn btn-primary">Pesquisar</button>
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                            <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='fai_relatorios_reparo.cfm'">Limpar</button>
                        </div>
                    </div>
                </div>
            </form>
            
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">ID</th>
                            <th scope="col">Data</th>
                            <th scope="col">Colaborador</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Estação</th>
                            <th scope="col">Criticidade</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Intervalo</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#lsdatetimeformat(REPARO_DATA, 'dd/mm/yyyy')#</td>
                                    <td>#REPARADOR#</td>
                                    <td>#VIN#</td>
                                    <td>#MODELO#</td>
                                    <td>#BARREIRA#</td>
                                    <td>#PECA_REPARO#</td>
                                    <td>#POSICAO_REPARO#</td>
                                    <td>#PROBLEMA_REPARO#</td>
                                    <td>#RESPONSAVEL_REPARO#</td>
                                    <td>#CRITICIDADE#</td>
                                    <td>#TIPO_REPARO#</td>
                                    <td>#INTERVALO_REPARO#</td>
                                </tr>
                            </cfloop>
                        </cfoutput>
                    </tbody>
                </table>
            
    
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
            <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
    
            <!-- Script para deletar -->
            <script>
               
                // Gerando Excel da tabela
                var table2excel = new Table2Excel();
                document.getElementById('report').addEventListener('click', function() {
                    table2excel.export(document.querySelectorAll('#tblStocks'));
                });
            </script>
        </div>
    </body>
    </html>
    