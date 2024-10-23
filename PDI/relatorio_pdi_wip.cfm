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
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
        WHERE 1 = 1 
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
        </cfif>
        <cfif isDefined("url.filtroCRITICIDADE") and url.filtroCRITICIDADE neq "">
            AND UPPER(CRITICIDADE) LIKE UPPER('%#url.filtroCRITICIDADE#%')
        </cfif>
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        <cfif isDefined("url.filtroPECA") and url.filtroPECA neq "">
            AND UPPER(PECA) LIKE UPPER('%#url.filtroPECA#%')
        </cfif>
        AND USER_DATA >= TO_DATE('#filtroDataStart#', 'yyyy-mm-dd') 
        AND USER_DATA < TO_DATE('#filtroDataEnd#', 'yyyy-mm-dd') + 1
        ORDER BY ID DESC
    </cfquery>
    
    <cfquery name="verificarVinBarreira" datasource="#BANCOSINC#">
        SELECT USER_DATA, USER_COLABORADOR, VIN, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, CRITICIDADE, STATUS
        FROM SISTEMA_QUALIDADE_PDI_SAIDA
        WHERE (VIN, USER_DATA) IN (
            SELECT VIN, MAX(USER_DATA) AS MAX_USER_DATA
            FROM SISTEMA_QUALIDADE_PDI_SAIDA
            GROUP BY VIN
        )
        ORDER BY 
            VIN,
            CASE 
                WHEN BARREIRA = 'NACIONAL' THEN 1
                WHEN BARREIRA = 'PDI' THEN 2
                WHEN BARREIRA = 'PATIO' THEN 3
                WHEN BARREIRA = 'RAMPA' THEN 4
                ELSE 5
            END
    </cfquery>
    
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Relatórios</title>
        <link rel="stylesheet" href="/qualidade/buyoff_linhat/assets/stylerelatorio.css?v1">
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
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
                <!-- Todos os campos na mesma linha -->
                <cfoutput>
                <div class="form-row">
                    <div class="form-group col-md-1">
                        <label for="formDataStart">Data Inicial</label>
                        <input value="<cfif isDefined('url.filtroDataStart')>#url.filtroDataStart#</cfif>" type="date" class="form-control form-control-sm" name="filtroDataStart" id="formDataStart">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formDataEnd">Data Final</label>
                        <input value="<cfif isDefined('url.filtroDataEnd')>#url.filtroDataEnd#</cfif>" type="date" class="form-control form-control-sm" name="filtroDataEnd" id="formDataEnd">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formEstacao">Responsável</label>
                        <select class="form-control form-control-sm" name="filtroestacao" id="formEstacao">
                            <option value="" disables selected>Selecione o Responsável:</option>
                            <option value="TRIM" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "TRIM">selected</cfif>>TRIM</option>
                            <option value="FAI" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "FAI">selected</cfif>>FAI</option>
                            <option value="BODY" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "BODY">selected</cfif>>BODY</option>
                            <option value="PAINT" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "PAINT">selected</cfif>>PAINT</option>
                            <option value="SMALL" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "SMALL">selected</cfif>>SMALL</option>
                            <option value="LOGISTICA" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "LOGISTICA">selected</cfif>>LOGISTICA</option>
                            <option value="CKD" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "CKD">selected</cfif>>CKD</option>
                            <option value="ENGENHARIA" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "ENGENHARIA">selected</cfif>>ENGENHARIA</option>
                            <option value="MANUTENÇÃO" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "MANUTENÇÃO">selected</cfif>>MANUTENÇÃO</option>
                            <option value="PVT" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "PVT">selected</cfif>>PVT</option>
                            <option value="QA" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "QA">selected</cfif>>QA</option>
                            <option value="CKDL" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "CKDL">selected</cfif>>CKDL</option>
                            <option value="DOOWON" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "DOOWON">selected</cfif>>DOOWON</option>
                            <option value="CP7" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "CP7">selected</cfif>>CP7</option>
                            <option value="SUB-MONTAGEM" <cfif isDefined('url.filtroESTACAO') AND url.filtroESTACAO EQ "SUB-MONTAGEM">selected</cfif>>SUB-MONTAGEM</option>
                        </select>
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formCRITICIDADE">Criticidade</label>
                        <select class="form-control form-control-sm" name="filtroCRITICIDADE" id="formCRITICIDADE">
                            <option value="">Selecione</option>
                            <option value="AVARIA" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "AVARIA">selected</cfif>>Avaria</option>
                            <option value="OK A-" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "OK A-">selected</cfif>>OK A-</option>
                            <option value="N0" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "N0">selected</cfif>>N0</option>
                            <option value="N1" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "N1">selected</cfif>>N1</option>
                            <option value="N2" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "N2">selected</cfif>>N2</option>
                            <option value="N3" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "N3">selected</cfif>>N3</option>
                            <option value="N4" <cfif isDefined('url.filtroCRITICIDADE') AND url.filtroCRITICIDADE EQ "N4">selected</cfif>>N4</option>
                        </select>
                    </div>
                </cfoutput>
                    <div class="form-group col-md-1">
                        <label for="formPECA">Peça</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroPECA" id="formPECA">
                    </div>
                    <div class="form-group col-md-1">
                        <label for="formBARREIRA">Barreira</label>
                        <select class="form-control form-control-sm" name="filtroBARREIRA" id="formBARREIRA">
                            <option value="">Selecione</option>
                            <option value="PDI" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "PDI">selected</cfif>>PDI SAIDA</option>
                            <option value="RAMPA" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "RAMPA">selected</cfif>>RAMPA</option>
                            <option value="PATIO" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "PATIO">selected</cfif>>PATIO</option>
                            <option value="NACIONAL" <cfif isDefined('url.filtroBARREIRA') AND url.filtroBARREIRA EQ "NACIONAL">selected</cfif>>PATIO NACIONAL</option>
                        </select>
                    </div>
                    <div class="form-group col-md-3">
                        <button type="submit" class="btn btn-primary mt-4">Pesquisar</button>
                        <button type="reset" class="btn btn-primary mt-4" style="background:gold; color:black; border-color: gold" onclick="self.location='relatorio_pdi_wip.cfm'">Limpar</button>
                        <button type="button" id="report" class="btn btn-secondary mt-4">Download</button>
                    </div>
                </div>
            </form>
            
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
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
                            <th scope="col">Criticidade</th>
                            <th scope="col">STATUS</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="verificarVinBarreira">
                                <tr class="align-middle">
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
                                    <td>#CRITICIDADE#</td>
                                    <td>#STATUS#</td>
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
    