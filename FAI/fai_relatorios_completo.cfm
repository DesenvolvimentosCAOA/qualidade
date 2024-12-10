<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

    <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/qualidade/buyoff_linhat/index.cfm'
        </script>
    </cfif>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
        FROM (
            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
            WHERE 1 = 1 
            <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
            </cfif>
            <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
                AND UPPER(BARCODE) LIKE UPPER('%#url.filtroBARCODE#%')
            </cfif>
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
                AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
            </cfif>
            <cfif isDefined("url.filtrarProblema") and url.filtrarProblema eq "true">
                AND PROBLEMA IS NOT NULL
            </cfif>

            UNION ALL

            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
            
            FROM INTCOLDFUSION.sistema_qualidade_fa
            WHERE 1 = 1 
            <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
            </cfif>
            <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
                AND UPPER(BARCODE) LIKE UPPER('#url.filtroBARCODE#')
            </cfif>
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
                AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
            </cfif>
            <cfif isDefined("url.filtrarProblema") and url.filtrarProblema eq "true">
                AND PROBLEMA IS NOT NULL
            </cfif>

            UNION ALL

            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
            
            FROM INTCOLDFUSION.sistema_qualidade_body
            WHERE 1 = 1 
            <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
            </cfif>
            <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
                AND UPPER(BARCODE) LIKE UPPER('#url.filtroBARCODE#')
            </cfif>
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
                AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
            </cfif>
            <cfif isDefined("url.filtrarProblema") and url.filtrarProblema eq "true">
                AND PROBLEMA IS NOT NULL
            </cfif>

            UNION ALL

            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
            FROM INTCOLDFUSION.sistema_qualidade
            WHERE 1 = 1 
            <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
            </cfif>
            <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
                AND UPPER(BARCODE) LIKE UPPER('#url.filtroBARCODE#')
            </cfif>
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
                AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
            </cfif>
            <cfif isDefined("url.filtrarProblema") and url.filtrarProblema eq "true">
                AND PROBLEMA IS NOT NULL
            </cfif>

            UNION ALL

            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE, CRITICIDADE
            FROM INTCOLDFUSION.sistema_qualidade_pdi_saida
            WHERE 1 = 1 
            <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
            </cfif>
            <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
                AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
            </cfif>
            <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
                AND UPPER(BARCODE) LIKE UPPER('#url.filtroBARCODE#')
            </cfif>
            <cfif isDefined("url.filtroMODELO") and url.filtroMODELO neq "">
                AND UPPER(MODELO) LIKE UPPER('%#url.filtroMODELO#%')
            </cfif>
            <cfif isDefined("url.filtrarProblema") and url.filtrarProblema eq "true">
                AND PROBLEMA IS NOT NULL
            </cfif>
        )
        WHERE ROWNUM <= 400 -- Limita o número de linhas retornadas
        ORDER BY USER_DATA DESC
    </cfquery>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Relatórios</title>
        <!-- Bootstrap CSS -->
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/stylerelatorio.css?v2">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br><br>
    
        
            <h2 class="titulo2">Relatórios Completo</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <cfoutput>
                <form method="get">
                    <input type="hidden" name="filtrarProblema" id="filtrarProblema" value="">
                
                    <div class="form-row">
                        <div class="form-group col-md-2">
                            <label for="formVIN">VIN</label>
                            <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN" value="<cfif isDefined('url.filtroVIN')>#url.filtroVIN#</cfif>">
                        </div>
                        <div class="form-group col-md-2">
                            <label for="formBARREIRA">Barreira</label>
                            <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARREIRA" id="formBARREIRA" value="<cfif isDefined('url.filtroBARREIRA')>#url.filtroBARREIRA#</cfif>">
                        </div>
                        <div class="form-group col-md-2">
                            <label for="formBARCODE">BARCODE</label>
                            <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARCODE" id="formBARCODE" value="<cfif isDefined('url.filtroBARCODE')>#url.filtroBARCODE#</cfif>">
                        </div>
                        <div class="form-group col-md-2">
                            <label for="formMODELO">MODELO</label>
                            <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroMODELO" id="formMODELO" value="<cfif isDefined('url.filtroMODELO')>#url.filtroMODELO#</cfif>">
                        </div>
                    </div><br>
                
                    <div class="form-row">
                        <div class="col-md-12">
                            <div class="form-buttons">
                                <!-- Botão para Pesquisar Tudo -->
                                <button type="submit" class="btn btn-primary" onclick="document.getElementById('filtrarProblema').value = '';">Filtro Geral</button>
                                <!-- Botão para Filtrar Apenas Problemas -->
                                <button type="submit" class="btn btn-danger" onclick="document.getElementById('filtrarProblema').value = 'true';">Filtro Problema</button>
                                <!-- Botão para Limpar -->
                                <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='fai_relatorios_completo.cfm'">Limpar</button>
                                <button type="button" id="report" class="btn btn-secondary">Download</button>
                            </div>
                        </div>
                    </div>
                </form>
            </cfoutput>
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">ID</th>
                            <th scope="col">Data</th>
                            <th scope="col">Colaborador</th>
                            <th scope="col">VIN</th>
                            <th scope="col">BARCODE</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Barreira</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Estação</th>
                            <th scope="col">Reparo Realizado</th>
                            <th scope="col">Intervalo</th>
                            <th scope="col">Reparador</th>
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
                                    <td>#BARCODE#</td>
                                    <td>#MODELO#</td>
                                    <td>#BARREIRA#</td>
                                    <td>#PECA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PROBLEMA#</td>
                                    <td>#ESTACAO#</td>
                                    <td>#TIPO_REPARO#</td>
                                    <td>#INTERVALO#</td>
                                    <td>#REPARADOR#</td>
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
    