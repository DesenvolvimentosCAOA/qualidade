<cfinvoke method="inicializando" component="cf.ini.index">

    <!---  Consulta  --->
    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_SMALL
        WHERE 1 = 1 
        <cfif isDefined("url.data") and url.data neq "">
            AND TO_CHAR(USER_DATA, 'dd/mm/yy') = '#lsdateformat(url.data, 'dd/mm/yy')#'
        <cfelse>
            AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
        </cfif>
        <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
        </cfif>
        <cfif isDefined("url.filtroPECA") and url.filtroPECA neq "">
            AND UPPER(PECA) LIKE UPPER('%#url.filtroPECA#%')
        </cfif>
        <cfif isDefined("url.filtroCOR") and url.filtroCOR neq "">
            AND UPPER(COR) LIKE UPPER('%#url.filtroCOR#%')
        </cfif>
        <cfif isDefined("url.filtroDEFEITO") and url.filtroDEFEITO neq "">
            AND UPPER(DEFEITO) LIKE UPPER('%#url.filtroDEFEITO#%')
        </cfif>
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
            
            <form method="get">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <cfoutput>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfif isDefined('url.data')>#url.data#<cfelse>#lsdateformat(now(),'yyyy-mm-dd')#</cfif>">
                        </cfoutput>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formMODELO">MODELO</label>
                        <input type="text" class="form-control form-control-sm" name="filtroMODELO" id="formMODELO">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formPECA">PEÇA</label>
                        <input type="text" class="form-control form-control-sm" name="filtroPECA" id="formPECA">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formCOR">COR</label>
                        <input type="text" class="form-control form-control-sm" name="filtroCOR" id="formCOR">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formDEFEITO">DEFEITO</label>
                        <input type="text" class="form-control form-control-sm" name="filtroDEFEITO" id="formDEFEITO">
                    </div>
                </div>
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="submit" class="btn btn-primary">Pesquisar</button>
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                            <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='small_relatorio.cfm'">Limpar</button>
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
                            <th scope="col">Modelo</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Cor</th>
                            <th scope="col">Defeito</th>
                            <th scope="col">Quantidade OK</th>
                            <th scope="col">Quantidade NG</th>
                            <th scope="col">Total Produzido</th>
                            <th scope="col">%</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <!-- Soma as quantidades de OK e NG -->
                                <cfset soma = QUANTIDADE_OK + QUANTIDADE_NG>
                                
                                <!-- Inicializa a variável divisao -->
                                <cfset divisao = 0>
                                
                                <!-- Verifica se a soma é diferente de zero para evitar divisão por zero -->
                                <cfif soma neq 0>
                                    <cfset divisao = (QUANTIDADE_OK / soma) * 100>
                                    <!-- Formatação com 2 casas decimais -->
                                    <cfset divisao = NumberFormat(divisao, "0.00")> 
                                </cfif>
                                
                                <!-- Exibe os dados na tabela -->
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy HH:nn:ss')#</td>
                                    <td>#USER_COLABORADOR#</td>
                                    <td>#MODELO#</td>
                                    <td>#PECA#</td>
                                    <td>#COR#</td>
                                    <td>#DEFEITO#</td>
                                    <td>#QUANTIDADE_OK#</td>
                                    <td>#QUANTIDADE_NG#</td>
                                    <td>#soma#</td>
                                    <td>#divisao#%</td>
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
    