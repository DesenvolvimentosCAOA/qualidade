<cfinvoke method="inicializando" component="cf.ini.index">

    <!---  Consulta  --->
    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE 1 = 1 
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroVIN#%')
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
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <style>
            .form-row {
            display: flex;
            flex-wrap: wrap;
            margin-right: -15px;
            margin-left: -15px;
            }
            .form-group.col-md-1 {
                flex: 0 0 8.333333%;
                max-width: 8.333333%;
                margin-left:5vw;
            }

            .form-group {
                margin-left: 15px; /* Adiciona o espaçamento entre os inputs */
            }

            /* Remove a margem à direita no último item para evitar um espaço extra */
            .form-group:last-child {
                margin-right: 0;
            }

            .form-group label {
                font-weight: bold;
                font-size: 14px;
                color: #333;
                margin-right: 10px; /* Adiciona um pequeno espaçamento entre o label e o input */
            }

            .form-control-sm {
                font-size: 14px;
                padding: 5px;
                border-radius: 5px;
                border: 1px solid #ccc;
                transition: border 0.3s ease;
                width: 100%; /* Garante que o input ocupe todo o espaço disponível */
            }

            .form-control-sm:focus {
                border-color: #007bff;
                box-shadow: 0px 0px 5px rgba(0, 123, 255, 0.5);
            }

            /* Estilização dos botões */
            .form-buttons {
                display: flex;
                justify-content: center;
                gap: 10px; /* Adiciona espaçamento entre os botões */
                margin-top: 20px;
                width: 100%;
            }

            .btn {
                font-size: 14px;
                font-weight: bold;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background-color: #007bff;
                color: white;
                border: none;
            }

            .btn-primary:hover {
                background-color: #0056b3;
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
                border: none;
            }

            .btn-secondary:hover {
                background-color: #545b62;
            }

            .btn[style*='background:gold'] {
                background-color: gold !important;
                color: black !important;
                border-color: gold !important;
            }

            .btn[style*='background:gold']:hover {
                background-color: #e6c200 !important;
            }

            /* Melhorando a responsividade */
            @media (max-width: 768px) {
                .form-row {
                    align-items: stretch;
                }
                .form-group {
                    width: 100%;
                    flex-direction: column; /* Em telas menores, os inputs ficam empilhados */
                    margin-right: 0; /* Remove o espaçamento à direita em telas menores */
                }
                .form-buttons {
                    flex-direction: column;
                    align-items: center;
                }
                .btn {
                    width: 100%;
                }
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
                border: none;
                font-size: 14px;
                font-weight: bold;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background-color: #0056b3;
            }
            /* Estilização geral da tabela */
            #tblStocks {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background-color: #fff;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;
            }
            #tblStocks thead th {
                padding: 12px;
                text-align: left;
                border-bottom: 2px solid #0056b3;
            }
            /* Estilização das células da tabela */
            #tblStocks tbody tr {
                border-bottom: 1px solid #ddd;
                transition: background 0.3s ease;
            }

            #tblStocks tbody tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            #tblStocks tbody tr:hover {
                background-color: #e9ecef;
            }

            #tblStocks tbody td {
                padding: 10px;
                color: #333;
            }

            /* Melhorando a responsividade */
            @media (max-width: 768px) {
                #tblStocks thead {
                    display: none;
                }
                
                #tblStocks tbody tr {
                    display: block;
                    margin-bottom: 10px;
                    background: #fff;
                    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
                    border-radius: 8px;
                    padding: 10px;
                }
                
                #tblStocks tbody td {
                    display: block;
                    text-align: right;
                    padding: 5px 10px;
                    position: relative;
                }
                
                #tblStocks tbody td::before {
                    content: attr(data-label);
                    font-weight: bold;
                    text-transform: uppercase;
                    position: absolute;
                    left: 10px;
                    text-align: left;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
    <div class="container">
            <h1 class="titulo">Pesquisa</h1><br><br><br>
        <cfoutput>
            <form method="get">
                <div class="form-row">
                    <div class="form-group col-md-1">
                        <label for="formDataStart">Data Inicial</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataStart" id="formDataStart" value="<cfif isDefined('url.filtroDataStart')>#url.filtroDataStart#</cfif>">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formDataEnd">Data Final</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataEnd" id="formDataEnd" value="<cfif isDefined('url.filtroDataEnd')>#url.filtroDataEnd#</cfif>">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formVIN">BARCODE</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN" value="<cfif isDefined('url.filtroVIN')>#url.filtroVIN#</cfif>">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formBARREIRA">Barreira</label>
                        <select class="form-control form-control-sm" name="filtroBARREIRA" id="formBARREIRA">
                            <option value="">Selecione</option>
                            <option value="Primer" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ 'Primer'>selected</cfif>>Primer</option>
                            <option value="Top Coat" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ 'Top Coat'>selected</cfif>>Top Coat</option>
                            <option value="Validacao" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ 'Validacao'>selected</cfif>>Validacao</option>
                            <option value="CP6" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ 'CP6'>selected</cfif>>CP6</option>
                            <option value="ECOAT" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ 'ECOAT'>selected</cfif>>ECOAT</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formESTACAO">Estação</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroESTACAO" id="formESTACAO" value="<cfif isDefined('url.filtroESTACAO')>#url.filtroESTACAO#</cfif>">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formCRITICIDADE">Criticidade</label>
                        <select class="form-control form-control-sm" name="filtroCRITICIDADE" id="formCRITICIDADE">
                            <option value="">Selecione</option>
                            <option value="AVARIA" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'AVARIA'>selected</cfif>>Avaria</option>
                            <option value="OK A-" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'OK A-'>selected</cfif>>OK A-</option>
                            <option value="N0" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'N0'>selected</cfif>>N0</option>
                            <option value="N1" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'N1'>selected</cfif>>N1</option>
                            <option value="N2" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'N2'>selected</cfif>>N2</option>
                            <option value="N3" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'N3'>selected</cfif>>N3</option>
                            <option value="N4" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ 'N4'>selected</cfif>>N4</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formPECA">Peça</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPECA" id="formPECA" value="<cfif isDefined('url.filtroPECA')>#url.filtroPECA#</cfif>">
                    </div>
                    <div class="form-group col-md-3 form-buttons">
                        <button type="submit" class="btn btn-primary mt-4">Pesquisar</button>
                        <button type="reset" class="btn btn-primary mt-4" style="background:gold; color:black; border-color: gold" onclick="self.location='relatorios_paint.cfm'">Limpar</button>
                        <button type="button" id="report" class="btn btn-secondary mt-4">Download</button>
                    </div>
                </div>
            </form>
        </cfoutput>
            <div style="margin-top:1vw" class="col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">Inspetor</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">BARCODE</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Data</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Resp</th>
                            <th scope="col">Criticidade</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr style="font-size:12px"  class="align-middle">
                                    <td>#USER_COLABORADOR#</td>
                                    <td>#BARREIRA#</td>
                                    <td>#BARCODE#</td>
                                    <td>#MODELO#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy HH:MM:ss')#</td>
                                    <td>#PECA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PROBLEMA#</td>
                                    <td>#ESTACAO#</td>
                                    <td>#CRITICIDADE#</td>
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
    