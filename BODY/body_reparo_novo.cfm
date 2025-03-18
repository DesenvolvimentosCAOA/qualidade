
<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_BODY") or cookie.USER_APONTAMENTO_BODY eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
    <cfif not isDefined("cookie.user_level_body") or cookie.user_level_body eq "I">
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_body
        WHERE 1 = 1 
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroPeca") and url.filtroPeca neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroPeca#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        <cfif isDefined("url.filtroBarreira") and url.filtroBarreira neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBarreira#%')
        </cfif>
        AND (CRITICIDADE NOT IN ('N0', 'OK A-'))
        AND PROBLEMA IS NOT NULL
        AND RESPONSAVEL_REPARO IS NULL
        AND BARREIRA = 'CP5'
        OR STATUS = 'NG'

        ORDER BY ID DESC
    </cfquery>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Body - Reparo</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <style>
                .filterTable {
                    display: flex;
                    align-items: center; /* Alinha verticalmente os itens ao centro */
                    gap: 1rem; /* Espaço entre os campos e botões */
                    margin-top: 2rem; /* Margem superior para afastar do topo da página */
                }

                .filterTable .row {
                    display: flex;
                    align-items: center; /* Alinha os itens dentro das colunas ao centro */
                    width: 100%; /* Garante que a linha ocupe toda a largura disponível */
                }

                .filterTable .col {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem; /* Espaço entre o rótulo e o campo de entrada */
                }

                /* Estiliza o rótulo dos campos do formulário */
                .form-label {
                    margin-right: 0.5rem; /* Espaço entre o rótulo e o campo */
                    font-weight: 500;
                    white-space: nowrap; /* Impede que o texto do rótulo quebre em várias linhas */
                }

                /* Estiliza os campos de entrada */
                .form-control {
                    width: 150px; /* Largura fixa para os campos */
                    padding: 0.375rem 0.75rem;
                    font-size: 0.875rem;
                    line-height: 1.5;
                    border-radius: 0.25rem;
                    border: 1px solid #ced4da;
                    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.075);
                }

                /* Estiliza os botões do formulário */
                .btn {
                    font-size: 0.875rem; /* Fonte menor para botões mais compactos */
                    line-height: 1.5;
                    border-radius: 0.25rem;
                    padding: 0.375rem 0.75rem;
                    cursor: pointer;
                    border: 1px solid transparent;
                    margin-left: 0.5rem; /* Espaço entre os botões */
                }

                .btn-primary {
                    color: #fff;
                    background-color: #007bff;
                    border-color: #007bff;
                }

                .btn-primary:hover {
                    background-color: #0056b3;
                    border-color: #004085;
                }

                .btn-warning {
                    color: #212529;
                    background-color: #ffc107;
                    border-color: #ffc107;
                }

                .btn-warning:hover {
                    background-color: #e0a800;
                    border-color: #d39e00;
                }


                /* Estilo para a tabela */
                .table {
                    width: 100%;
                    border-collapse: collapse;
                    background-color: #fff;
                    margin-top: 2rem; /* Margem superior para afastar do topo da página */
                }

                /* Estilo para o cabeçalho da tabela */
                .table thead th {
                    background-color: #f8f9fa;
                    color: #495057;
                    font-weight: 500;
                    text-align: center;
                    padding: 0.75rem;
                    border-bottom: 2px solid #dee2e6;
                }

                /* Estilo para as células do corpo da tabela */
                .table tbody td {
                    padding: 0.75rem;
                    vertical-align: middle;
                    border-bottom: 1px solid #dee2e6;
                }

                /* Estilo para linhas alternadas do corpo da tabela */
                .table tbody tr:nth-of-type(even) {
                    background-color: #f8f9fa;
                }

                /* Estilo para as linhas da tabela */
                .table tbody tr:hover {
                    background-color: #e9ecef;
                }

                /* Estilo para os botões dentro da tabela */
                .table tbody .btn {
                    font-size: 0.875rem;
                    padding: 0.375rem 0.75rem;
                    border-radius: 0.25rem;
                    border: 1px solid transparent;
                }

                /* Estilo específico para o botão Salvar */
                .table tbody .btn-save {
                    background-color: #28a745;
                    color: #fff;
                }

                .table tbody .btn-save:hover {
                    background-color: #218838;
                }

                /* Estilo para a tabela dentro de um container */
                .container {
                    padding: 0;
                }

                .table-container {
                    width: 100%; /* O container ocupa toda a largura disponível */
                    overflow-x: auto; /* Permite rolagem horizontal apenas se necessário */
                    margin-top: 1rem;
                }

                /* Estilo para o body e html para garantir que o footer fique no fundo da página */
                html, body {
                    height: 100%;
                    margin: 0;
                }

                /* Estilo para o container principal */
                .container {
                    display: flex;
                    flex-direction: column;
                    min-height: 100vh; /* Garante que o container ocupe toda a altura da viewport */
                }

                /* Estilo para o conteúdo principal */
                .main-content {
                    flex: 1; /* Faz com que o conteúdo principal expanda para preencher o espaço disponível */
                }

                /* Estilo para o footer */
                footer {
                    background-color: #f8f9fa; /* Cor de fundo do footer */
                    border-top: 1px solid #dee2e6; /* Linha superior do footer */
                    color: #212529; /* Cor do texto */
                    padding: 1rem 0; /* Padding superior e inferior */
                    text-align: center; /* Alinhamento do texto */
                }


                /* Estilo específico para o botão Salvar */
                .btn-save {
                    background-color: #28a745; /* Cor de fundo verde */
                    color: #fff; /* Cor do texto branco */
                    border: 1px solid #28a745; /* Borda na mesma cor do fundo */
                    padding: 0.375rem 0.75rem; /* Padding para tornar o botão mais espaçoso */
                    font-size: 0.875rem; /* Tamanho da fonte */
                    border-radius: 0.25rem; /* Bordas arredondadas */
                    cursor: pointer; /* Cursor de ponteiro ao passar o mouse */
                }

                .btn-save:hover {
                    background-color: #218838; /* Cor de fundo verde escuro ao passar o mouse */
                    border-color: #1e7e34; /* Borda com cor mais escura para hover */
                }

                .table th, table  td {
                    font-size: 12px;
                }
            </style>
        </head>

        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw" class="titulo2">Reparo - Body</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="row">
                            <div class="col-md-2 offset-md-1">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroModelo">Barreira:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroPeca">VIN:</label>
                                <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined('url.filtroPeca')>#url.filtroPeca#</cfif>"/>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='body_reparo_novo.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </cfoutput>
            
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_BODY#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">Data</th>
                                    <th scope="col">Inspetor</th>
                                    <th scope="col">Barcode</th>
                                    <th scope="col">Barreira</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Posição</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Estação</th>
                                    <th scope="col">Criticidade</th>
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="body_reparo_novo.cfm">
                                            <cfif PROBLEMA NEQ "">
                                                <tr class="align-middle">
                                                    <td class="text-center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td class="text-center" style="font-size:15px">#USER_COLABORADOR#</td>
                                                    <td class="text-center">#BARCODE#</td>
                                                    <td class="text-center">#BARREIRA#</td>
                                                    <td class="text-center">#PECA#</td>
                                                    <td class="text-center">#POSICAO#</td>
                                                    <td class="text-center">#PROBLEMA#</td>
                                                    <td class="text-center">#ESTACAO#</td>
                                                    <td class="text-center">#CRITICIDADE#</td>
                                                    <td class="text-nowrap">
                                                        <a href="reparo_editar.cfm?id_editar=#id#" class="btn btn-primary">Editar</a>
                                                    </td>
                                                </tr>
                                            </cfif>
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

