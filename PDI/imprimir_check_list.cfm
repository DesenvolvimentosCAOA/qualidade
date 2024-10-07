<cfinvoke method="inicializando" component="cf.ini.index">

    <!---  Consulta  --->
    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE 1 = 1 
        <cfif isDefined("url.data") and url.data neq "">
            AND TO_CHAR(USER_DATA, 'dd/mm/yy') = '#lsdateformat(url.data, 'dd/mm/yy')#'
        <cfelse>
            AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
        </cfif>
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
        </cfif>
        ORDER BY ID DESC
    </cfquery>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Relatórios</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v6">
        <link rel="stylesheet" href="assets/custom.css"> <!-- Seu arquivo CSS personalizado -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css"> <!-- Material Icons -->
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    
        
            <h2 class="titulo2">Pesquisa</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <form method="get">
                <div class="form-row">
                    <div style="margin-left:3vw" class="form-group col-md-1">
                        <label for="formData">Data</label>
                        <cfoutput>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfif isDefined('url.data')>#url.data#<cfelse>#lsdateformat(now(),'yyyy-mm-dd')#</cfif>">
                        </cfoutput> 
                    </div>
                    <div class="form-group col-md-3">
                        <label for="formVIN">VIN/BARCODE</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN">
                    </div>
                    <div class="form-group col-md-3">
                        <label for="formBARREIRA">Barreira</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARREIRA" id="formBARREIRA">
                    </div>
                    <div class="form-group col-md-3">
                        <button type="submit" class="btn btn-primary mt-4">Pesquisar</button>
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
                            <th scope="col">Colaborador</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Estação</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Intervalo</th>
                            <th scope="col">Imprimir</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
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
                                    <td>
                                        <button onclick="self.location='gerarqr.cfm?ID=#ID#&PECA=#PECA#&DATA=#DATA#&STATUS=#STATUS#'" type="submit" class="btn btn-info" name="btSalvarID" value="#ID#">Imprimir</button>
                                    </td>
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
    