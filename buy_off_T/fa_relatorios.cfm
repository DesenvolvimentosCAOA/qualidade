<cfinvoke method="inicializando" component="cf.ini.index">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!---  Consulta  --->
    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE 1 = 1 
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroSTATUS") and url.filtroSTATUS neq "">
            AND UPPER(STATUS) LIKE UPPER('%#url.filtroSTATUS#%')
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
        <cfif isDefined("url.filtroPOSICAO") and url.filtroPOSICAO neq "">
            AND UPPER(POSICAO) LIKE UPPER('%#url.filtroPOSICAO#%')
        </cfif>
        <cfif isDefined("url.filtroPROBLEMA") and url.filtroPROBLEMA neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroPROBLEMA#%')
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
        <link rel="stylesheet" href="assets/stylerelatorio.css?v3">
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    <div class="container">
            <h1 class="titulo">Pesquisa</h1><br><br><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <form method="get">
                <div class="form-row" style='margin-bottom:2vw;'>
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
                        <label class="form-label" for="filtroBarreira">BARREIRA:</label>
                            <select class="form-control" name="filtroBarreira" id="filtroBarreira" >
                                <option value="" disabled selected>Selecione</option>
                                <option value="T19">T19</option>
                                <option value="T30">T30</option>
                                <option value="T33">T33</option>
                                <option value="C13">C13</option>
                                <option value="F05">F05</option>
                                <option value="F10">F10</option>
                                <option value="SUBMOTOR">SUBMOTOR</option>
                                <option value="CP7">CP7</option>
                                <option value="HR">HR</option>
                                <option value="LIBERACAO">LIBERACAO</option>
                            </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="form-label" for="filtroSTATUS">Status</label>
                        <select class ="form-control" name="filtroSTATUS" id="filtroSTATUS" >
                            <option value="" disabled selected>Selecione</option>
                            <option value="LIBERADO">LIBERADO</option>
                            <option value="REPARO">REPARO</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formEstacao">Responsável</label>
                        <select class="form-control form-control-sm" name="filtroestacao" id="formEstacao">
                            <option value="" disables selected>Selecione o Responsável:</option>
                            <option value="LINHA T">Linha T</option>
                            <option value="LINHA C">Linha C</option>
                            <option value="LINHA F">Linha F</option>
                            <option value="BODY">BODY</option>
                            <option value="PAINT">PAINT</option>
                            <option value="SMALL">SMALL</option>
                            <option value="LOGISTICA">LOGISTICA</option>
                            <option value="CKD">CKD</option>
                            <option value="ENGENHARIA">ENGENHARIA</option>
                            <option value="MANUTENÇÃO">MANUTENÇÃO</option>
                            <option value="PVT">PVT</option>
                            <option value="QA">QA</option>
                            <option value="CKDL">CKDL</option>
                            <option value="DOOWON">DOOWON</option>
                            <option value="CP7">CP7</option>
                            <option value="SUB-PAINEL">SUB-PAINEL</option>
                            <option value="SUB-DISCO">SUB-DISCO</option>
                            <option value="SUB-AGREGADO">SUB-AGREGADO</option>
                            <option value="SUB-MOTOR">SUB-MOTOR</option>
                            <option value="SUB-RADIADOR">SUB-RADIADOR</option>
                            <option value="SUB-PCH">SUB-PCH</option>
                            <option value="SUB-RETROVISOR">SUB-RETROVISOR</option>
                            <option value="SUB-MAÇANETA">SUB-MAÇANETA</option>
                            <option value="SUB-MOLDURAS">SUB-MOLDURAS</option>
                            <option value="SUB-RODAS">SUB-RODAS</option>
                            <option value="SUB-FORRO DE TETO">SUB-FORRO DE TETO</option>
                            <option value="SUB-SPOILER">SUB-SPOILER</option>
                            <option value="PCP">PCP</option>
                            <option value="REPARO FA">REPARO FA</option>
                        </select>
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
                </div>
                <div class="form-row">
                    <div class="form-group col-md-1">
                        <label for="formPECA">Peça</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPECA" id="formPECA">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formPOSICAO">Posição</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPOSICAO" id="formPOSICAO">
                    </div>                    <div class="form-group col-md-1">
                        <label for="formPROBLEMA">Problema</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPROBLEMA" id="formPROBLEMA">
                    </div>
                    <div class="form-group col-md-3">
                        <button type="submit" class="btn btn-primary mt-4">Pesquisar</button>
                        <button type="reset" class="btn btn-primary mt-4" style="background:gold; color:black; border-color: gold" onclick="self.location='fa_relatorios.cfm'">Limpar</button>
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
                            <th scope="col">Reparador</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Descrição do Reparo</th>
                            <th scope="col">Status</th>
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
                                    <td>#REPARADOR#</td>
                                    <td>#TIPO_REPARO#</td>
                                    <td>#DESCRICAO_REPARO#</td>
                                    <td>#STATUS#</td>
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
    