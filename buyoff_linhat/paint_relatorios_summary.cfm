<cfinvoke method="inicializando" component="cf.ini.index">

     <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_paint") or (cookie.user_level_paint eq "R" or cookie.user_level_paint eq "P")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>

    <!---  Consulta  --->

    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

<cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE
    WHERE 1 = 1 
    <cfif isDefined("url.filtroBARREIRA") and url.filtroBARREIRA neq "">
        AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBARREIRA#%')
    </cfif>
    <cfif isDefined("url.filtroESTACAO") and url.filtroESTACAO neq "">
        AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroESTACAO#%')
    </cfif>
    <cfif isDefined("url.filtroPeriodo") and url.filtroPeriodo neq "">
        <cfset periodo = url.filtroPeriodo>
        <cfif periodo EQ "1º">
            AND (
                -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
                -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
                -- Sábado: turno inicia às 06:00 e termina às 15:48
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
            )
        <cfelseif periodo EQ "2º">
            AND (
                CASE 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
                END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
            )
        <cfelseif periodo EQ "3º">
            AND (
                    -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:00:00'))
                    -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                    OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:00:00'))
                    -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                    OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                        (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                    ))
                )
        </cfif>
    </cfif>
    AND BARREIRA NOT IN 'CP6'
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
        <!-- Bootstrap CSS -->
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/stylerelatorio1.css?v1">
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
                    <div class="form-group col-md-2">
                        <label for="formDataStart">Data Inicial</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataStart" id="formDataStart">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formDataEnd">Data Final</label>
                        <input type="date" class="form-control form-control-sm" name="filtroDataEnd" id="formDataEnd">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formBARREIRA">Barreira</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="filtroBARREIRA" id="formBARREIRA">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formPeriodo">Período do Dia</label>
                        <select class="form-control form-control-sm" name="filtroPeriodo" id="formPeriodo">
                            <option value="">Selecione</option>
                            <option value="1º">1º</option>
                            <option value="2º">2º</option>
                            <option value="3º">3º</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="submit" class="btn btn-primary">Pesquisar</button>
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                            <button type="reset" class="btn btn-primary" style="background:gold; color:black; border-color: gold" onclick="self.location='paint_relatorios_summary.cfm'">Limpar</button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="container col-12 bg-white rounded metas">

                <cfquery name="contagemVin" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                </cfquery>

                <!-- Calcula a contagem distinta de VIN onde PROBLEMA é NULL -->
                <cfquery name="contagemVinSemProblema" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintosSemProblema
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                </cfquery>

                <cfquery name="contagemVinT7" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TIGGO 7%'
                </cfquery>

                <cfquery name="contagemtiggo7" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totaltiggo7
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TIGGO 7%'
                </cfquery>


                <cfquery name="contagemVinT5" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TIGGO 5%'
                </cfquery>

                <cfquery name="contagemtiggo5" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totaltiggo5
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TIGGO 5%'
                </cfquery>

                <cfquery name="contagemVinT18" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TIGGO 83 ICE'
                </cfquery>

                <cfquery name="contagemtiggo18" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totaltiggo18
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TIGGO 83 ICE'
                </cfquery>
                
                <cfquery name="contagemVinHR" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE (UPPER(MODELO) IS NULL OR UPPER(MODELO) = '')
                </cfquery>
                
                <cfquery name="contagemHR" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalHR
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND (UPPER(MODELO) IS NULL OR UPPER(MODELO) = '')
                </cfquery>
                

                <cfquery name="contagemVinTL" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TL%'
                </cfquery>

                <cfquery name="contagemTL" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalTL
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TL%'
                </cfquery>

                <cfquery name="contagemtiggo8" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TIGGO 8 ADAS'
                </cfquery>

                <cfquery name="contagemtiggo8" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totaltiggo8
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TIGGO 8 ADAS'
                </cfquery>

                <cfquery name="contagemVinT8" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totalDistintos
                    FROM consulta_adicionais
                    WHERE UPPER(MODELO) LIKE 'TIGGO 8 ADAS'
                </cfquery>

                <cfquery name="contagemtiggo8" dbtype="query">
                    SELECT COUNT(DISTINCT BARCODE) AS totaltiggo8
                    FROM consulta_adicionais
                    WHERE PROBLEMA IS NULL
                    AND UPPER(MODELO) LIKE 'TIGGO 8 ADAS'
                </cfquery>

                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">Barreira</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Data</th>
                            <th scope="col">Prod</th>
                            <th scope="col">Aprov</th>
                            <th scope="col">Problema</th>
                            <th scope="col">Posição</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Resp</th>
                            <th scope="col">Qtd</th>
                            <th scope="col">Time</th>
                            <th scope="col">VIN/BARCODE</th>
                            <th scope="col">Turno</th>
                            <th scope="col">Intervalo</th>
                            <th scope="col">Criticidade</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#BARREIRA#</td>
                                    <td>#MODELO#</td>
                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                    <td></td>
                                    <td></td>
                                    <td>#PROBLEMA#</td>
                                    <td>#POSICAO#</td>
                                    <td>#PECA#</td>
                                    <td></td>
                                    <td></td>
                                    <td>#ESTACAO#</td>
                                    <td>#BARCODE#</td>
                                    <td>
                                        <!-- Verificação de turno com base no INTERVALO -->
                                        <cfif INTERVALO gte "06:00" and INTERVALO lt "15:00">
                                            1º
                                        <cfelseif ListFind("15:50,16:00,17:00,18:00,19:00,20:00,21:00,22:00,23:00,00:00", INTERVALO)>
                                            2º
                                        <cfelseif ListFind("01:00,02:00,03:00,04:00,05:00", INTERVALO)>
                                            3º
                                        <cfelse>
                                            -
                                        </cfif>
                                    </td>
                                    <td>#INTERVALO#</td>
                                    <td>#CRITICIDADE#</td>
                                </tr>
                            </cfloop>
                            
                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod Tiggo 7:</strong></td>
                                <td><strong>#contagemVinT7.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov Tiggo 7:</strong></td>
                                <td><strong>#contagemtiggo7.totaltiggo7#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod Tiggo 5:</strong></td>
                                <td><strong>#contagemVinT5.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov Tiggo 5:</strong></td>
                                <td><strong>#contagemtiggo5.totaltiggo5#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod Tiggo T18:</strong></td>
                                <td><strong>#contagemVinT18.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov Tiggo T18:</strong></td>
                                <td><strong>#contagemtiggo18.totaltiggo18#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod HR:</strong></td>
                                <td><strong>#contagemVinHR.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov HR:</strong></td>
                                <td><strong>#contagemHR.totalHR#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod TL:</strong></td>
                                <td><strong>#contagemVinTL.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov TL:</strong></td>
                                <td><strong>#contagemTL.totalTL#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="3" class="text-end"><strong>Total Prod Tiggo 8:</strong></td>
                                <td><strong>#contagemVinT8.totalDistintos#</strong></td>
                            </tr>

                            <tr class="align-middle">
                                <td colspan="4" class="text-end"><strong>Total Aprov Tiggo 8:</strong></td>
                                <td><strong>#contagemtiggo8.totaltiggo8#</strong></td>
                            </tr>

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
    