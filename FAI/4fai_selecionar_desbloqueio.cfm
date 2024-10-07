<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

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

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE,
               STATUS_BLOQUEIO, RESPONSAVEL_BLOQUEIO, RESPONSAVEL_DESBLOQUEIO, DATA_BLOQUEIO, DATA_DESBLOQUEIO, MOTIVO_BLOQUEIO, MOTIVO_DESBLOQUEIO, BARREIRA_BLOQUEIO
        FROM (
            SELECT USER_DATA, VIN, BARREIRA, ID, USER_COLABORADOR, MODELO, PECA, POSICAO, PROBLEMA, ESTACAO, TIPO_REPARO, INTERVALO, REPARADOR, BARCODE,
                   STATUS_BLOQUEIO, RESPONSAVEL_BLOQUEIO, RESPONSAVEL_DESBLOQUEIO, DATA_BLOQUEIO, DATA_DESBLOQUEIO, MOTIVO_BLOQUEIO, MOTIVO_DESBLOQUEIO, BARREIRA_BLOQUEIO
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE 1 = 1 
            and BARREIRA = 'CP5'
            <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroBARCODE") and url.filtroBARCODE neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroBARCODE#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        )
        WHERE ROWNUM <= 30 -- Limita o número de linhas retornadas
        AND STATUS_BLOQUEIO = 'BLOQUEADO'
        ORDER BY ID ASC
    </cfquery>
    
    
    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Desbloqueio Sistêmico - selecionar</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo.css?v1">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw ;color:green" class="titulo2">Desbloqueio Sistêmico</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                        </cfquery>
                        <div class="row">
                            <div hidden class="col-md-4"> <!-- Aumenta a largura da coluna para o nome -->
                                <label class="form-label" for="formNome">Inspetor</label>
                                <input type="text" class="form-control" name="nome" id="formNome" value="#login.USER_SIGN#" readonly="readonly">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroModelo">Barreira:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroBARCODE">BARCODE:</label>
                                <input type="text" class="form-control" name="filtroBARCODE" id="filtroBARCODE" value="<cfif isDefined('url.filtroBARCODE')>#url.filtroBARCODE#</cfif>">
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 d-flex justify-content-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='./4fai_selecionar_desbloqueio.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                    
                </cfoutput>
            
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">VIN</th>
                                    <th scope="col">BARCODE</th>
                                    <th scope="col">MODELO</th>
                                    <th scope="col">STATUS</th>
                                    <th scope="col">Responsável</th>
                                    <th scope="col">Barreira de Desbloqueio</th>
                                    <th scope="col">Motivo do Desbloqueio</th>
                                    <th hidden scope="col">Salvar</th>
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post">
                                                <tr class="align-middle">
                                                    <td>#ID#</td>
                                                    <td>#VIN#</td>
                                                    <td>#BARCODE#</td>
                                                    <td>#MODELO#</td>
                                                    <td>#STATUS_BLOQUEIO#</td>
                                                    <td id="responsavelBloqueio_#ID#">#RESPONSAVEL_DESBLOQUEIO#</td>
                                                    <td>#BARREIRA_BLOQUEIO#</td>
                                                    <td>#MOTIVO_DESBLOQUEIO#</td>
                                                    <td style="display:none;">
                                                        <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                    </td>
                                                    <td class="text-nowrap">
                                                        <button class="btn btn-primary" onclick="self.location='3fai_editar_desbloqueio.cfm?id_editar=#id#'">
                                                            <i class="mdi mdi-pencil-outline"></i> Editar
                                                        </button>
                                                    </td>
                                                </tr>
                                        </form>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="12" class="text-center">Nenhum registro encontrado.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Footer com uma imagem e o copyright -->
            <footer class="text-center py-4">
                <p>&copy; 2024 Sistema de gestão da qualidade.</p>
            </footer>
        </body>
    </html>

    <cfcatch type="any">
        <cfoutput>
            Ocorreu um erro ao inserir os dados no banco de dados.<br>
            Detalhes do erro: #cfcatch.message#<br>
            Stack Trace: #cfcatch.stacktrace#
        </cfoutput>
    </cfcatch>
</cftry>
