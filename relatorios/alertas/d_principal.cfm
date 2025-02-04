<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

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
        </style>
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="/qualidade/relatorios/auxi/nav_links.cfm">
        </header>

        <div class="btn-container">
            <button class="btn-rounded" onclick="window.location.href = 'd1.cfm';">Inserir Alerta</button>
            <button class="btn-rounded"></button>
            <button class="btn-rounded"></button>
        </div>

        <div class="table-containerr">
            <h2 style="color:red">Alertas Da Qualidade</h2>
            <div class="search-container">
                <input type="text" id="searchID" placeholder="Pesquisar ID" onkeyup="filterTable()">
                <input type="text" id="searchNumero" placeholder="Nº Controle" onkeyup="filterTable()">
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
                        <th>enviar e-mail</th>
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
                                <cfif STATUS eq 'EVIDENCIAS'>
                                    <td>
                                        <cfif BARREIRA eq 'BODY'>
                                            <button class="btn-rounded btn-primary" onclick="window.location.href = 'email_body.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif BARREIRA eq 'PAINT'>
                                            <button class="btn-rounded btn-secondary" onclick="window.location.href = 'email_paint.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif BARREIRA eq 'SMALL'>
                                            <button class="btn-rounded btn-success" onclick="window.location.href = 'email_small.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif BARREIRA eq 'FA'>
                                            <button class="btn-rounded btn-warning" onclick="window.location.href = 'email_fa.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif BARREIRA eq 'FAI'>
                                            <button class="btn-rounded btn-danger" onclick="window.location.href = 'email_fai.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        <cfelseif BARREIRA eq 'PDI'>
                                            <button class="btn-rounded btn-dark" onclick="window.location.href = 'email_pdi.cfm?id_editar=#ID#';">
                                                <i class="mdi mdi-pencil-outline"></i>Enviar
                                            </button>
                                        </cfif>
                                    </td>
                                </cfif>
                                 <!---<td>
                                    <button class="btn-rounded" onclick="window.location.href = 'email.cfm?id_editar=#ID#'">enviar email</button>
                                </td>   --->
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>
        <script>
            function filterTable() {
                var inputID = document.getElementById("searchID").value.toUpperCase();
                var inputNumero = document.getElementById("searchNumero").value.toUpperCase();

                var table = document.getElementById("bodyTable");
                var tr = table.getElementsByTagName("tr");

                for (var i = 0; i < tr.length; i++) {
                    var tdID = tr[i].getElementsByTagName("td")[0];
                    var tdNumero = tr[i].getElementsByTagName("td")[2];

                    if (tdID && tdNumero) {
                        var matchID = tdID.textContent.toUpperCase().indexOf(inputID) > -1;
                        var matchNumero = tdNumero.textContent.toUpperCase().indexOf(inputNumero) > -1;

                        if (matchID && matchNumero) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        </script>
    </body>
</html>
