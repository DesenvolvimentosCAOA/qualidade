    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!---  Consulta  --->
    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE 1 = 1 
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        <cfif isDefined("url.filtroCRITICIDADE") and url.filtroCRITICIDADE neq "">
            AND UPPER(CRITICIDADE) LIKE UPPER('%#url.filtroCRITICIDADE#%')
        </cfif>
        <cfif isDefined("url.filtroPECA") and url.filtroPECA neq "">
            AND UPPER(PECA) LIKE UPPER('%#url.filtroPECA#%')
        </cfif>
        AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
        AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
        ORDER BY ID DESC
    </cfquery>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Relatórios</title>
        <link rel="stylesheet" href="assets/stylerelatorio.css?v1">
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
    <div class="container">
            <h1 class="titulo">Pesquisa</h1><br><br><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <form method="get">
                <!-- Todos os campos na mesma linha -->
                <div class="form-row">
                    <div class="form-group col-md-1">
                        <label for="formDataStart">Data Inicial</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataStart" id="formDataStart">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formDataEnd">Data Final</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataEnd" id="formDataEnd">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formBARREIRA">Barreira</label>
                        <select class="form-control form-control-sm" name="filtroBARREIRA" id="formBARREIRA">
                            <option value="">Selecione</option>
                            <option value="UNDER BODY">UNDER BODY</option>
                            <option value="SHOWER">SHOWER</option>
                            <option value="ROAD TEST">ROAD TEST</option>
                            <option value="TUNEL DE LIBERACAO">TTUNEL DE LIBERACAO33</option>
                            <option value="SIGN OFF">SIGN OFF</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formESTACAO">Estação</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroESTACAO" id="formESTACAO">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formCRITICIDADE">Criticidade</label>
                        <select class="form-control form-control-sm" name="filtroCRITICIDADE" id="formCRITICIDADE">
                            <option value="">Selecione</option>
                            <option value="AVARIA">Avaria</option>
                            <option value="OK A-">OK A-</option>
                            <option value="N0">N0</option>
                            <option value="N1">N1</option>
                            <option value="N2">N2</option>
                            <option value="N3">N3</option>
                            <option value="N4">N4</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formPECA">Peça</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPECA" id="formPECA">
                    </div>
                    <div class="form-group col-md-3">
                        <button type="submit" class="btn btn-primary mt-4">Pesquisar</button>
                        <button type="reset" class="btn btn-primary mt-4" style="background:gold; color:black; border-color: gold" onclick="self.location='fai_relatorios.cfm'">Limpar</button>
                        <button type="button" id="report" class="btn btn-secondary mt-4">Download</button>
                    </div>
                </div>
            </form>
            
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">ID</th>
                            <th scope="col">Data</th>
                            <th scope="col">Inspetor</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Estação</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Intervalo</th>
                            <th scope="col">Criticidade</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy HH:nn:ss')#</td>
                                    <td>#USER_COLABORADOR#</td>
                                    <td>#VIN#</td>
                                    <td>#MODELO#</td>
                                    <td>#BARREIRA#</td>
                                    <td>#PECA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PROBLEMA#</td>
                                    <td>#ESTACAO#</td>
                                    <td>#TIPO_REPARO#</td>
                                    <td>#INTERVALO#</td>
                                    <td>#CRITICIDADE#</td>
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
            <script>
                // Gerando Excel da tabela
                var table2excel = new Table2Excel();
                document.getElementById('report').addEventListener('click', function() {
                    table2excel.export(document.querySelectorAll('#tblStocks'));
                });
            </script>
        </div>
    </div>
    </body>
    </html>
    