<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfquery name="consultas_acomp_cont" datasource="#BANCOSINC#">
        SELECT *
        FROM (
            SELECT *
            FROM INTCOLDFUSION.vereagir2
            WHERE 1 = 1
            <cfif isDefined("url.searchID") and url.searchID neq "">
                AND ID = <cfqueryparam value="#url.searchID#" cfsqltype="CF_SQL_INTEGER">
            </cfif>
            <cfif isDefined("url.searchVIN") and url.searchVIN neq "">
                AND UPPER(VIN) LIKE UPPER('%<cfqueryparam value="#url.searchVIN#" cfsqltype="CF_SQL_VARCHAR">%')
            </cfif>
            <cfif isDefined("url.searchPeca") and url.searchPeca neq "">
                AND UPPER(PECA) LIKE UPPER('%<cfqueryparam value="#url.searchPeca#" cfsqltype="CF_SQL_VARCHAR">%')
            </cfif>
            <cfif isDefined("url.searchPosicao") and url.searchPosicao neq "">
                AND UPPER(POSICAO) LIKE UPPER('%<cfqueryparam value="#url.searchPosicao#" cfsqltype="CF_SQL_VARCHAR">%')
            </cfif>
            <cfif isDefined("url.searchProblema") and url.searchProblema neq "">
                AND UPPER(PROBLEMA) LIKE UPPER('%<cfqueryparam value="#url.searchProblema#" cfsqltype="CF_SQL_VARCHAR">%')
            </cfif>
            <cfif isDefined("url.searchStatus") and url.searchStatus neq "">
                AND UPPER(STATUS) LIKE UPPER('%<cfqueryparam value="#url.searchStatus#" cfsqltype="CF_SQL_VARCHAR">%')
            </cfif>
            AND PROBLEMA IS NOT NULL
            -- AND BP_CONTENCAO_PROCESSO IS NULL
            ORDER BY DATA_REGISTRO DESC
        )
        WHERE ROWNUM <= 200
    </cfquery>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
           DELETE FROM INTCOLDFUSION.vereagir2 WHERE ID = 
           <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
           self.location = 'ver_agir_apagar.cfm';
        </script>
    </cfif>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_shop.css?v1">
        <style>
            /* Botão principal */
            .delete-button {
            width: 50px;
            height: 50px;
            background-color: #f44336; /* Vermelho sério e forte */
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            /* Hover com efeito visual */
            .delete-button:hover {
            background-color: #c62828;
            transform: scale(1.1);
            }

            /* Feedback de clique */
            .delete-button:active {
            transform: scale(0.95);
            background-color: #b71c1c;
            }

            /* Ícone da lixeira */
            .icon-trash {
            position: relative;
            width: 24px;
            height: 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            }

            /* Tampa da lixeira */
            .icon-trash .lid {
            width: 24px;
            height: 4px;
            background-color: #fff;
            border-radius: 2px;
            margin-bottom: 2px;
            }

            /* Corpo da lixeira */
            .icon-trash .can {
            width: 20px;
            height: 20px;
            background-color: #fff;
            border-radius: 2px;
            position: relative;
            }

            /* Linhas decorativas (detalhes no corpo) */
            .icon-trash .lines {
            position: absolute;
            top: 4px;
            left: 4px;
            width: 12px;
            height: 12px;
            background: repeating-linear-gradient(
                to bottom,
                #c62828,
                #c62828 2px,
                #fff 2px,
                #fff 4px
            );
            border-radius: 1px;
            }
        </style>
    </head>

    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br><br><br><br><br>
        <div id="loading-screen">
            <div class="spinner"></div>
        </div>
        <h2>Editar</h2>
        <div>
            <div class="search-container">
                <input type="text" id="searchIDACOMP" placeholder="Pesquisar ID" onkeyup="filterTableACOMP()">
                <input type="text" id="searchVINACOMP" placeholder="Pesquisar Vin" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPecaACOMP" placeholder="Pesquisar Peça" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPosicaoACOMP" placeholder="Pesquisar Posição" onkeyup="filterTableACOMP()">
                <input type="text" id="searchProblemaACOMP" placeholder="Pesquisar Problema" onkeyup="filterTableACOMP()">
            </div>
            <table border="1" id="ACOMPTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data</th>
                        <th>Modelo</th>
                        <th>VIN/Barcode</th>
                        <th>Peça</th>
                        <th>Posição</th>
                        <th>Problema</th>
                        <th>Barreira</th>
                        <th>Status</th>
                        <th>Editar</th>
                        <th>Deletar</th>
                    </tr>
                </thead>
                <tbody style="font-size:12px;background-color:red;" id="tableBody">
                    <cfoutput query="consultas_acomp_cont">
                        <tr>
                            <td>#ID#</td>
                            <td>#lsdatetimeformat(DATA_REGISTRO, 'dd/mm/yyyy')#</td>
                            <td>#MODELO#</td>
                            <td>#VIN#</td>
                            <td>#PECA#</td>
                            <td>#POSICAO#</td>
                            <td>#PROBLEMA#</td>
                            <td>#BARREIRA#</td>
                            <td>#STATUS#</td>
                            <td class="text-nowrap">
                                <button class="btn btn-primary" onclick="self.location='ver_agir_editar.cfm?id_editar=#id#'">
                                    <i class="mdi mdi-pencil-outline"></i>Editar</button>
                            </td>
                            <td>
                                <button class="delete-button" onclick="deletar(#ID#);">
                                  <span class="icon-trash">
                                    <div class="lid"></div>
                                    <div class="can"></div>
                                    <div class="lines"></div>
                                  </span>
                                </button>
                              </td>                              
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </div> 
        
        <script src="/qualidade/relatorios/assets/script.js"></script>

        <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "ver_agir_apagar.cfm?id=" + id;
                }
            }
        </script>
         
    </body>
</html>