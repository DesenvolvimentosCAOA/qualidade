<cfinvoke method="inicializando" component="cf.ini.index">

    <!---  Consulta  --->
    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
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
                <form method="get">
                    <!-- Todos os campos na mesma linha -->
                    <div class="form-row">
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
                            <th scope="col">SHOP</th>
                            <th scope="col">BATALHA</th>
                            <th scope="col">DEFEITO</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#lsdatetimeformat(DATA_CRIACAO, 'dd/mm/yyyy hh:nn:ss')#</td>
                                    <td>#SHOP#</td>
                                    <td>#BATALHA#</td>
                                    <td>#DEFEITO#</td>
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
    