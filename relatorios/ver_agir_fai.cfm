<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!--- Verificando se está logado  --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
        </cfif>
        <cfif not isDefined("cookie.user_level_final_assembly") or ListFind("R,P,I", cookie.user_level_final_assembly)>
            <script>
                alert("É necessário autorização!!");
                history.back(); // Voltar para a página anterior
            </script>
        </cfif>

    <cfquery name="consultas_fai" datasource="#BANCOSINC#">
        SELECT *
        FROM (
            SELECT *
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
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
            AND PROBLEMA IS NOT NULL
            ORDER BY ID DESC
        )
        WHERE USER_DATA >= TRUNC(SYSDATE) -5
    </cfquery>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>FAI - VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_shop.css?v1">
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div id="loading-screen">
            <div class="spinner"></div>
        </div>

        <!-- Container para os botões -->
        <div class="btn-container">
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir.cfm')">Acompanhamento</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_body.cfm')">Body</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_paint.cfm')">Paint</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_fa.cfm')">Final Assembly</button>
            <button class="btn-rounded" style='background-color:grey;color:black;'>FAI</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_pdi.cfm')">PDI</button>
        </div>

        <!-- Tabelas -->
        <div id="tableFAI" class="table-container">
            <h2 style="color:gray">FAI</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDFAI" placeholder="Pesquisar ID" onkeyup="filterTableFAI()">
                <input type="text" id="searchVINFAI" placeholder="Pesquisar Vin" onkeyup="filterTableFAI()">
                <input type="text" id="searchPecaFAI" placeholder="Pesquisar Peça" onkeyup="filterTableFAI()">
                <input type="text" id="searchPosicaoFAI" placeholder="Pesquisar Posição" onkeyup="filterTableFAI()">
                <input type="text" id="searchProblemaFAI" placeholder="Pesquisar Problema" onkeyup="filterTableFAI()">
            </div>

            <table border="1" id="FAITable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data</th>
                        <th>VIN</th>
                        <th>Modelo</th>
                        <th>Peça</th>
                        <th>Posição</th>
                        <th>Problema</th>
                        <th>Inserir</th>
                    </tr>
                </thead>
                <tbody style="font-size:12px;">
                    <cfoutput>
                        <cfloop query="consultas_fai">
                            <tr>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#VIN#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#POSICAO#</td>
                                <td>#PROBLEMA#</td>
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_add.cfm?id_editar=#id#&tabela=sistema_qualidade_fai'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>  
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div> 
        <script src="/qualidade/relatorios/assets/script.js"></script>
    </body>
</html>