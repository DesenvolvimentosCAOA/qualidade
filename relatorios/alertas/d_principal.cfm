<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/relatorios/index.cfm'
    </script> 
</cfif>
<!--- impede Inspetor de acessar  --->
<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "I">
    <script>
       alert("É necessário autorização!!");
       self.location= 'fa_indicadores_1.cfm'
    </script>
</cfif>

<cfquery name="consultas" datasource="#BANCOSINC#">
    SELECT * 
    FROM (
        SELECT * 
        FROM INTCOLDFUSION.ALERTAS_8D
        WHERE 1 = 1
        <cfif isDefined("url.searchID") and url.searchID neq "">
            AND ID = <cfqueryparam value="#url.searchID#" cfsqltype="CF_SQL_INTEGER">
        </cfif>
        <cfif isDefined("url.searchNumero") and url.searchNumero neq "">
            AND UPPER(N_CONTROLE) LIKE UPPER('%' || <cfqueryparam value="#url.searchNumero#" cfsqltype="CF_SQL_VARCHAR"> || '%')
        </cfif>
        ORDER BY ID DESC
    )
</cfquery>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>INÍCIO - ALERTAS</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style.css?v5">
        <style>
            .wide-column {
                width: 300px;
            }
            .status-span {
                display: inline-block;
                padding: 5px;
                line-height: 1.8;
                white-space: normal;
                word-wrap: break-word;
                overflow: hidden;
                text-align: center;
                border-radius: 4px;
            }
            table#table th:first-child,
            table#table td:first-child {
                width: auto;
                max-width: 100px; /* Ajuste o valor conforme necessário */
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            table#table th:nth-child(5),
            table#table td:nth-child(5) {
                width: auto;
                max-width: 350px; /* Ajuste o valor conforme necessário */
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            
            .search-container select {
            border-radius: 20px; /* Borda arredondada */
            padding: 10px 15px; /* Espaçamento interno dos inputs */
            font-size: 1rem; /* Tamanho da fonte */
            border: 1px solid #5a8e99; /* Cor da borda */
            outline: none; /* Remove o contorno ao focar */
            width: 200px; /* Largura dos inputs */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1); /* Sombra leve para estilo */
            }

            .search-container select:focus {
            border-color: #f6722c; /* Cor da borda ao focar */
            box-shadow: 0 0 5px #f6722c; /* Sombra ao focar */
            }
        </style>
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="/qualidade/relatorios/auxi/nav_links.cfm">
        </header>

        <div class="btn-container">
            <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
                <button class="btn-rounded" onclick="window.location.href = 'd1.cfm';">Inserir Alerta</button>
            </cfif>
            <button class="btn-rounded"></button>
            <button class="btn-rounded"></button>
        </div>

        <div class="table-containerr">
            <h2 style="color:red">Alertas Da Qualidade</h2>
            <div class="search-container">
                <input type="text" id="searchID" placeholder="Nº Controle" onkeyup="filterTable()">
                <input type="text" id="searchSetor" placeholder="Setor" onkeyup="filterTable()">
                <select id="searchStatus" onchange="filterTable()">
                    <option value="">Status</option>
                    <option value="D1-D2">Evidências</option>
                    <option value="D3">D3</option>
                    <option value="D4">D4</option>
                    <option value="D5/D6">D5/D6</option>
                    <option value="FINALIZADO">Finalizado</option>
                </select>
                
                <button style="background-color:red" class="btn-rounded" onclick="clearFilters()">LIMPAR</button>
            </div>

            <table border="1" id="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data</th>
                        <th>Barreira</th>
                        <th>Descrição</th>
                        <th>Etapa</th>
                        <th>Selecionar</th>
                        <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
                            <th>enviar e-mail</th>
                        </cfif>
                    </tr>
                </thead>
                <tbody id="bodyTable" style="font-size:12px;">
                    <cfoutput>
                        <cfloop query="consultas">
                            <tr>
                                <td>#N_CONTROLE#</td>
                                <td>#lsdatetimeformat(DATA_OCORRENCIA, 'dd/mm/yyyy')#</td>
                                <td>#BARREIRA#</td>
                                <td>#DESCRICAO_NC#</td>
                                <td class="wide-column">
                                    <cfif STATUS EQ "FINALIZADO">
                                        <span class="status-span" style="background-color: yellow; color: black;">#STATUS# Alerta Finalizado</span>
                                    <cfelseif STATUS EQ "D1-D2">
                                        <span class="status-span">#STATUS# <span style="color:green"> Concluído</span> <br>Prox. Etapa: inserir as evidências</span>
                                    <cfelseif STATUS EQ "EVIDENCIAS">
                                        <span class="status-span">#STATUS# <span style="color:green"> Concluído</span> <br>Prox. Etapa: Enviar e-mail</span>
                                    <cfelseif STATUS EQ "EMAIL">
                                        <span class="status-span">E-mail <span style="color:green">Enviado</span> <br>Prox. Etapa: <strong>Ação de Contenção</strong></span>
                                    <cfelseif STATUS EQ "D3">
                                        <span class="status-span">#STATUS# <span style="color:green"> Concluído</span> <br>Prox. Etapa: Ishikawa</span>
                                    <cfelseif STATUS EQ "D4">
                                        <span class="status-span">#STATUS# <span style="color:green"> Concluído</span> <br>Prox. Etapa: Ação definitiva e Ponto de Corte</span>
                                    <cfelseif STATUS EQ "D5/D6">
                                        <span class="status-span">#STATUS# <span style="color:green"> Concluído</span> <br>Prox. Etapa: Análise de eficácia e Lições aprendidas</span>
                                    <cfelse>
                                        <span class="status-span">#STATUS#</span>
                                    </cfif>
                                </td>
                                    <td class="text-nowrap">
                                        <cfif STATUS neq 'EVIDENCIAS'>
                                            <button 
                                                class="btn-rounded" 
                                                onclick="
                                                    var status = '#STATUS#';
                                                    if (status === '' || status === null) {
                                                        window.location.href = 'd1.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'D1-D2') {
                                                        window.location.href = 'd2.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'EMAIL') {
                                                        window.location.href = 'd3.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'D3') {
                                                        window.location.href = 'd4.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'D4') {
                                                        window.location.href = 'd5_d6.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'D5/D6') {
                                                        window.location.href = 'd7_d8.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    } else if (status === 'FINALIZADO') {
                                                        window.location.href = 'd9_relatorio.cfm?id_editar=#ID#&id_nc=#n_controle#';
                                                    }
                                                ">
                                                <i class="mdi mdi-pencil-outline"></i>Selecionar
                                            </button>
                                        </cfif>
                                    </td>
                                <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
                                <cfif STATUS eq 'EVIDENCIAS'>
                                    <td>
                                        <cfif SETOR_RESPONSAVEL eq 'BODY SHOP'>
                                            <button class="btn-rounded btn-primary" onclick="window.location.href = 'email_body.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'PAINT'>
                                            <button class="btn-rounded btn-secondary" onclick="window.location.href = 'email_paint.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'SMALL'>
                                            <button class="btn-rounded btn-success" onclick="window.location.href = 'email_small.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'FINAL ASSEMBLY'>
                                            <button class="btn-rounded btn-warning" onclick="window.location.href = 'email_fa.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'LOGISTICA'>
                                            <button class="btn-rounded btn-warning" onclick="window.location.href = 'email_log.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'FAI'>
                                            <button class="btn-rounded btn-danger" onclick="window.location.href = 'email_fai.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif SETOR_RESPONSAVEL eq 'PDI'>
                                            <button class="btn-rounded btn-dark" onclick="window.location.href = 'email_pdi.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        </cfif>
                                    </td>
                                </cfif> 
                                </cfif>
                                 <!---<td>
                                    <button class="btn-rounded" onclick="window.location.href = 'email_body.cfm?id_editar=#ID#'">enviar email</button>
                                </td>  --->
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>
        <script>
            function filterTable() {
                // Captura os valores dos campos de pesquisa
                var inputID = document.getElementById("searchID").value.toUpperCase();
                var inputSetor = document.getElementById("searchSetor").value.toUpperCase();
                var inputStatus = document.getElementById("searchStatus").value.toUpperCase();
        
                // Captura a tabela e as linhas
                var table = document.getElementById("bodyTable");
                var tr = table.getElementsByTagName("tr");
        
                // Loop através de todas as linhas da tabela
                for (var i = 0; i < tr.length; i++) {
                    var tdID = tr[i].getElementsByTagName("td")[0]; // Coluna ID (1ª coluna)
                    var tdSetor = tr[i].getElementsByTagName("td")[2]; // Coluna Setor (3ª coluna)
                    var tdStatus = tr[i].getElementsByTagName("td")[4]; // Coluna Status (5ª coluna)
        
                    // Verifica se as colunas existem
                    if (tdID && tdSetor && tdStatus) {
                        var matchID = tdID.textContent.toUpperCase().indexOf(inputID) > -1; // Filtra por ID
                        var matchSetor = tdSetor.textContent.toUpperCase().indexOf(inputSetor) > -1; // Filtra por Setor
                        var matchStatus = tdStatus.textContent.toUpperCase().indexOf(inputStatus) > -1; // Filtra por Status
        
                        // Exibe ou oculta a linha com base nos filtros
                        if (matchID && matchSetor && matchStatus) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        </script>

        <script>
            function clearFilters() {
                // Limpa os valores dos campos de filtro
                document.getElementById("searchID").value = "";
                document.getElementById("searchSetor").value = "";
                document.getElementById("searchStatus").value = "";
        
                // Captura a tabela e as linhas
                var table = document.getElementById("bodyTable");
                var tr = table.getElementsByTagName("tr");
        
                // Exibe todas as linhas da tabela
                for (var i = 0; i < tr.length; i++) {
                    tr[i].style.display = "";
                }
            }
        </script>
        
    </body>
</html>
