<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

    <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
        </script>
    </cfif>

    <cfif not isDefined("cookie.user_level_fai") or (cookie.user_level_fai eq "R" or cookie.user_level_fai eq "I" or cookie.user_level_fai eq "P")>
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
    FROM (
        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
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

        UNION ALL

        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
        
        FROM INTCOLDFUSION.sistema_qualidade_fa
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

        UNION ALL

        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
        
        FROM INTCOLDFUSION.sistema_qualidade_body
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

        UNION ALL

        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
        FROM INTCOLDFUSION.sistema_qualidade
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

        UNION ALL

        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE
        FROM INTCOLDFUSION.sistema_qualidade_body
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
    )
    WHERE ROWNUM <= 40 -- Limita o número de linhas retornadas
    ORDER BY ID ASC
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
    
        
            <h2 class="titulo2">Relatórios Completo</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                ORDER BY DEFEITO
            </cfquery>
            <form method="get">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroVIN" id="formVIN">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formBARREIRA">Barreira</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARREIRA" id="formBARREIRA">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formBARCODE">BARCODE</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARCODE" id="formVIN">
                    </div>
                </div><br>
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="submit" class="btn btn-primary">Pesquisar</button>
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                            <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='fai_relatorios_completo.cfm'">Limpar</button>
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
    