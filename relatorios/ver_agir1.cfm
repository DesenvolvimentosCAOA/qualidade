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
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            WHERE 1 = 1
            <cfif isDefined("url.searchID") and url.searchID neq "">
                AND ID = <cfqueryparam value="#url.searchID#" cfsqltype="CF_SQL_INTEGER">
            </cfif>
            <cfif isDefined("url.searchVIN") and url.searchVIN neq "">
                AND UPPER(BARCODE) LIKE UPPER('%' || <cfqueryparam value="#url.searchVIN#" cfsqltype="CF_SQL_VARCHAR"> || '%')
            </cfif>
            <cfif isDefined("url.searchPeca") and url.searchPeca neq "">
                AND UPPER(PECA) LIKE UPPER('%' || <cfqueryparam value="#url.searchPeca#" cfsqltype="CF_SQL_VARCHAR"> || '%')
            </cfif>
            <cfif isDefined("url.searchPosicao") and url.searchPosicao neq "">
                AND UPPER(POSICAO) LIKE UPPER('%' || <cfqueryparam value="#url.searchPosicao#" cfsqltype="CF_SQL_VARCHAR"> || '%')
            </cfif>
            <cfif isDefined("url.searchProblema") and url.searchProblema neq "">
                AND UPPER(PROBLEMA) LIKE UPPER('%' || <cfqueryparam value="#url.searchProblema#" cfsqltype="CF_SQL_VARCHAR"> || '%')
            </cfif>
            AND PROBLEMA IS NOT NULL
            ORDER BY ID DESC
        )
        WHERE USER_DATA >= TRUNC(SYSDATE, 'IW') -- Início da semana atual
        AND USER_DATA < TRUNC(SYSDATE, 'IW') + 7 -- Final da semana atual
    </cfquery>

    <cfquery name="consultas_paint" datasource="#BANCOSINC#">
        SELECT *
        FROM (
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE 1 = 1
        <cfif isDefined("url.searchID") and url.searchID neq "">
            AND ID = <cfqueryparam value="#url.searchID#" cfsqltype="CF_SQL_INTEGER">
        </cfif>
        <cfif isDefined("url.searchVIN") and url.searchVIN neq "">
            AND UPPER(BARCODE) LIKE UPPER('%<cfqueryparam value="#url.searchVIN#" cfsqltype="CF_SQL_VARCHAR">%')
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
        WHERE USER_DATA >= TRUNC(SYSDATE, 'IW') -- Início da semana atual
        AND USER_DATA < TRUNC(SYSDATE, 'IW') + 7 -- Final da semana atual
    </cfquery>

    <cfquery name="consultas_fa" datasource="#BANCOSINC#">
        SELECT *
        FROM (
            SELECT *
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
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
        WHERE USER_DATA >= TRUNC(SYSDATE, 'IW') -- Início da semana atual
        AND USER_DATA < TRUNC(SYSDATE, 'IW') + 7 -- Final da semana atual
    </cfquery>

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
        WHERE USER_DATA >= TRUNC(SYSDATE, 'IW') -- Início da semana atual
        AND USER_DATA < TRUNC(SYSDATE, 'IW') + 7 -- Final da semana atual
    </cfquery>

    <cfquery name="consultas_pdi" datasource="#BANCOSINC#">
        SELECT *
        FROM (
            SELECT *
            FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
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
        WHERE USER_DATA >= TRUNC(SYSDATE, 'IW') -- Início da semana atual
        AND USER_DATA < TRUNC(SYSDATE, 'IW') + 7 -- Final da semana atual
    </cfquery>

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

    <cfquery name="consulta_datas" datasource="#BANCOSINC#">
        SELECT
            ID,
            DATA_BP_PROCESSO,
            DATA_BP_DEFINITIVO_PROCESSO,
            ROUND(
                CASE 
                    WHEN DATA_BP_PROCESSO IS NULL THEN SYSDATE - DATA_REGISTRO
                    ELSE DATA_BP_PROCESSO - DATA_REGISTRO
                END
            ) AS DIAS
        FROM VEREAGIR2
    </cfquery>

    <cfquery name="consulta_data_definitivo" datasource="#BANCOSINC#">
        SELECT
            ID,
            DATA_REGISTRO,
            DATA_BP_DEFINITIVO_PROCESSO,
            ROUND(
                CASE
                WHEN DATA_BP_DEFINITIVO_PROCESSO IS NULL THEN SYSDATE - DATA_REGISTRO
                ELSE DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO
                END
                ) AS DIAS_DEFINITIVO
        FROM VEREAGIR2
    </cfquery>

    <cfquery name="result" datasource="#BANCOSINC#">
        SELECT 
            sqf.PECA AS PECA_SQF, 
            sqf.PROBLEMA AS PROBLEMA_SQF,
            sqf.MODELO AS MODELO_SQF,
            v2.PECA AS PECA_VEREAGIR2,
            v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
            v2.MODELO AS MODELO_VEREAGIR2,
            v2.ID AS ID_VEREAGIR2,
            v2.BARREIRA,
            MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
            MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
            CASE 
                WHEN MAX(v2.DATA_REGISTRO) IS NOT NULL AND MAX(v2.DATA_REGISTRO) < MAX(sqf.USER_DATA) THEN 'BP QUEBRADO'
                WHEN MAX(sqf.USER_DATA) IS NOT NULL AND MAX(v2.DATA_REGISTRO) > MAX(sqf.USER_DATA) THEN 'TRATANDO'
                WHEN MAX(v2.DATA_REGISTRO) IS NULL THEN NULL
            END AS STATUS_NOVO
        FROM 
            SISTEMA_QUALIDADE_FA sqf
        LEFT JOIN 
            VEREAGIR2 v2
        ON 
            sqf.PECA = v2.PECA AND sqf.PROBLEMA = v2.PROBLEMA AND sqf.MODELO = v2.MODELO
        WHERE 
            v2.BARREIRA = 'TRIM'
        GROUP BY 
            sqf.PECA, sqf.PROBLEMA, sqf.MODELO, v2.PECA, v2.PROBLEMA, v2.MODELO, v2.ID, v2.BARREIRA

        UNION ALL

        SELECT 
            sqf.PECA AS PECA_SQF, 
            sqf.PROBLEMA AS PROBLEMA_SQF,
            sqf.MODELO AS MODELO_SQF,
            v2.PECA AS PECA_VEREAGIR2,
            v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
            v2.MODELO AS MODELO_VEREAGIR2,
            v2.ID AS ID_VEREAGIR2,
            v2.BARREIRA,
            MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
            MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
            CASE 
                WHEN MAX(v2.DATA_REGISTRO) IS NOT NULL AND MAX(v2.DATA_REGISTRO) < MAX(sqf.USER_DATA) THEN 'BP QUEBRADO'
                WHEN MAX(sqf.USER_DATA) IS NOT NULL AND MAX(v2.DATA_REGISTRO) > MAX(sqf.USER_DATA) THEN 'TRATANDO'
                WHEN MAX(v2.DATA_REGISTRO) IS NULL THEN NULL
            END AS STATUS_NOVO
        FROM 
            SISTEMA_QUALIDADE_FAI sqf
        LEFT JOIN 
            VEREAGIR2 v2
        ON 
            sqf.PECA = v2.PECA AND sqf.PROBLEMA = v2.PROBLEMA AND sqf.MODELO = v2.MODELO
        WHERE 
            v2.BARREIRA = 'FAI'
        GROUP BY 
            sqf.PECA, sqf.PROBLEMA, sqf.MODELO, v2.PECA, v2.PROBLEMA, v2.MODELO, v2.ID, v2.BARREIRA

        UNION ALL

        SELECT 
            sqf.PECA AS PECA_SQF, 
            sqf.PROBLEMA AS PROBLEMA_SQF,
            sqf.MODELO AS MODELO_SQF,
            v2.PECA AS PECA_VEREAGIR2,
            v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
            v2.MODELO AS MODELO_VEREAGIR2,
            v2.ID AS ID_VEREAGIR2,
            v2.BARREIRA,
            MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
            MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
            CASE 
                WHEN MAX(v2.DATA_REGISTRO) IS NOT NULL AND MAX(v2.DATA_REGISTRO) < MAX(sqf.USER_DATA) THEN 'BP QUEBRADO'
                WHEN MAX(sqf.USER_DATA) IS NOT NULL AND MAX(v2.DATA_REGISTRO) > MAX(sqf.USER_DATA) THEN 'TRATANDO'
                WHEN MAX(v2.DATA_REGISTRO) IS NULL THEN NULL
            END AS STATUS_NOVO
        FROM 
            SISTEMA_QUALIDADE sqf
        LEFT JOIN 
            VEREAGIR2 v2
        ON 
            sqf.PECA = v2.PECA AND sqf.PROBLEMA = v2.PROBLEMA AND sqf.MODELO = v2.MODELO
        WHERE 
            v2.BARREIRA = 'PAINT'
        GROUP BY 
            sqf.PECA, sqf.PROBLEMA, sqf.MODELO, v2.PECA, v2.PROBLEMA, v2.MODELO, v2.ID, v2.BARREIRA

        UNION ALL

        SELECT 
            sqf.PECA AS PECA_SQF, 
            sqf.PROBLEMA AS PROBLEMA_SQF,
            sqf.MODELO AS MODELO_SQF,
            v2.PECA AS PECA_VEREAGIR2,
            v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
            v2.MODELO AS MODELO_VEREAGIR2,
            v2.ID AS ID_VEREAGIR2,
            v2.BARREIRA,
            MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
            MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
            CASE 
                WHEN MAX(v2.DATA_REGISTRO) IS NOT NULL AND MAX(v2.DATA_REGISTRO) < MAX(sqf.USER_DATA) THEN 'BP QUEBRADO'
                WHEN MAX(sqf.USER_DATA) IS NOT NULL AND MAX(v2.DATA_REGISTRO) > MAX(sqf.USER_DATA) THEN 'TRATANDO'
                WHEN MAX(v2.DATA_REGISTRO) IS NULL THEN NULL
            END AS STATUS_NOVO
        FROM 
            SISTEMA_QUALIDADE_BODY sqf
        LEFT JOIN 
            VEREAGIR2 v2
        ON 
            sqf.PECA = v2.PECA AND sqf.PROBLEMA = v2.PROBLEMA AND sqf.MODELO = v2.MODELO
        WHERE 
            v2.BARREIRA = 'BODY'
        GROUP BY 
            sqf.PECA, sqf.PROBLEMA, sqf.MODELO, v2.PECA, v2.PROBLEMA, v2.MODELO, v2.ID, v2.BARREIRA

        UNION ALL

        SELECT 
            sqf.PECA AS PECA_SQF, 
            sqf.PROBLEMA AS PROBLEMA_SQF,
            sqf.MODELO AS MODELO_SQF,
            v2.PECA AS PECA_VEREAGIR2,
            v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
            v2.MODELO AS MODELO_VEREAGIR2,
            v2.ID AS ID_VEREAGIR2,
            v2.BARREIRA,
            MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
            MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
            CASE 
                WHEN MAX(v2.DATA_REGISTRO) IS NOT NULL AND MAX(v2.DATA_REGISTRO) < MAX(sqf.USER_DATA) THEN 'BP QUEBRADO'
                WHEN MAX(sqf.USER_DATA) IS NOT NULL AND MAX(v2.DATA_REGISTRO) > MAX(sqf.USER_DATA) THEN 'TRATANDO'
                WHEN MAX(v2.DATA_REGISTRO) IS NULL THEN NULL
            END AS STATUS_NOVO
        FROM 
            SISTEMA_QUALIDADE_PDI_SAIDA sqf
        LEFT JOIN 
            VEREAGIR2 v2
        ON 
            sqf.PECA = v2.PECA AND sqf.PROBLEMA = v2.PROBLEMA AND sqf.MODELO = v2.MODELO
        WHERE 
            v2.BARREIRA = 'PDI'
        GROUP BY 
            sqf.PECA, sqf.PROBLEMA, sqf.MODELO, v2.PECA, v2.PROBLEMA, v2.MODELO, v2.ID, v2.BARREIRA
    </cfquery>

    
<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style.css?v2">
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>

        <!-- Container para os botões -->
        <div class="btn-container">
            <div class="btn-rounded">
                Novo Relatório
                <div class="submenu">
                        <a href="#" onclick="showTable('tableBody')">Body</a>
                        <a href="#" onclick="showTable('tablePaint')">Paint</a>
                        <a href="#" onclick="showTable('tableFA')">FA</a>
                        <a href="#" onclick="showTable('tableFAI')">FAI</a>
                        <a href="#" onclick="showTable('tablePDI')">PDI</a>
                </div>
            </div>
            <button class="btn-rounded" onclick="showTable('tableACOMP')">Acompanhamento Contenção</button>
            <button class="btn-rounded"></button>
            <button class="btn-rounded"></button>
        </div>

        <!-- Tabelas -->
        <div id="tableBody" class="table-container">
            <h2 style="color:#0000CD">Body Shop</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchID" placeholder="Pesquisar ID" onkeyup="filterTable()">
                <input type="text" id="searchVIN" placeholder="Pesquisar Barcode" onkeyup="filterTable()">
                <input type="text" id="searchPeca" placeholder="Pesquisar Peça" onkeyup="filterTable()">
                <input type="text" id="searchPosicao" placeholder="Pesquisar Posição" onkeyup="filterTable()">
                <input type="text" id="searchProblema" placeholder="Pesquisar Problema" onkeyup="filterTable()">
            </div>
            
        
            <table border="1" id="bodyTable">
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
                        <cfloop query="consultas">
                            <tr>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#BARCODE#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#POSICAO#</td>
                                <td>#PROBLEMA#</td>
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_add.cfm?id_editar=#id#&tabela=sistema_qualidade_body'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>  
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div> 

        <div id="tablePaint" class="table-container">
            <h2 style="color:#f6722c">Paint Shop</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDP" placeholder="Pesquisar ID" onkeyup="filterTablePaint()">
                <input type="text" id="searchVINP" placeholder="Pesquisar Barcode" onkeyup="filterTablePaint()">
                <input type="text" id="searchPecaP" placeholder="Pesquisar Modelo" onkeyup="filterTablePaint()">
                <input type="text" id="searchPosicaoP" placeholder="Pesquisar Peça" onkeyup="filterTablePaint()">
                <input type="text" id="searchProblemaP" placeholder="Pesquisar Posição" onkeyup="filterTablePaint()">
            </div>
            <table border="1">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data</th>
                        <th>Barcode</th>
                        <th>Modelo</th>
                        <th>Peça</th>
                        <th>Posição</th>
                        <th>Problema</th>
                        <th>Inserir</th>
                    </tr>
                </thead>
                <tbody style="font-size:12px;">
                    <cfoutput>
                        <cfloop query="consultas_paint">
                            <tr>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#BARCODE#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#POSICAO#</td>
                                <td>#PROBLEMA#</td>
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_add.cfm?id_editar=#id#&tabela=sistema_qualidade'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>                                
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>

        <div id="tableFA" class="table-container">
            <h2 style="color:gold">Final Assembly</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDFA" placeholder="Pesquisar ID" onkeyup="filterTableFA()">
                <input type="text" id="searchVINFA" placeholder="Pesquisar Vin" onkeyup="filterTableFA()">
                <input type="text" id="searchPecaFA" placeholder="Pesquisar Modelo" onkeyup="filterTableFA()">
                <input type="text" id="searchPosicaoFA" placeholder="Pesquisar Peça" onkeyup="filterTableFA()">
                <input type="text" id="searchProblemaFA" placeholder="Pesquisar Posição" onkeyup="filterTableFA()">
            </div>
            <table border="1" id="FATable">
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
                        <cfloop query="consultas_fa">
                            <tr>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#VIN#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#POSICAO#</td>
                                <td>#PROBLEMA#</td>
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_add.cfm?id_editar=#id#&tabela=sistema_qualidade_fa'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>  
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div> 

        <div id="tableFAI" class="table-container">
            <h2 style="color:gray">FAI</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDFAI" placeholder="Pesquisar ID" onkeyup="filterTableFAI()">
                <input type="text" id="searchVINFAI" placeholder="Pesquisar Vin" onkeyup="filterTableFAI()">
                <input type="text" id="searchPecaFAI" placeholder="Pesquisar Modelo" onkeyup="filterTableFAI()">
                <input type="text" id="searchPosicaoFAI" placeholder="Pesquisar Peça" onkeyup="filterTableFAI()">
                <input type="text" id="searchProblemaFAI" placeholder="Pesquisar Posição" onkeyup="filterTableFAI()">
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

        <div id="tablePDI" class="table-container">
            <h2 style="color:purple">PDI</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDPDI" placeholder="Pesquisar ID" onkeyup="filterTablePDI()">
                <input type="text" id="searchVINPDI" placeholder="Pesquisar Vin" onkeyup="filterTablePDI()">
                <input type="text" id="searchPecaPDI" placeholder="Pesquisar Modelo" onkeyup="filterTablePDI()">
                <input type="text" id="searchPosicaoPDI" placeholder="Pesquisar Peça" onkeyup="filterTablePDI()">
                <input type="text" id="searchProblemaPDI" placeholder="Pesquisar Posição" onkeyup="filterTablePDI()">
            </div>
            
        
            <table border="1" id="PDITable">
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
                        <cfloop query="consultas_pdi">
                            <tr>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#VIN#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#POSICAO#</td>
                                <td>#PROBLEMA#</td>
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_add.cfm?id_editar=#id#&tabela=sistema_qualidade_pdi_saida'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>  
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div> 

        <div id="tableACOMP" class="table-container">
            <h2 style="color:gray">Acompanhamento BP</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <input type="text" id="searchIDACOMP" placeholder="Pesquisar ID" onkeyup="filterTableACOMP()">
                <input type="text" id="searchVINACOMP" placeholder="Pesquisar Vin" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPecaACOMP" placeholder="Pesquisar Peça" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPosicaoACOMP" placeholder="Pesquisar Posição" onkeyup="filterTableACOMP()">
                <input type="text" id="searchProblemaACOMP" placeholder="Pesquisar Problema" onkeyup="filterTableACOMP()">
            </div>
            <div class="search-container">
                <button style="background-color:blue" class="btn-rounded" onclick="toggleBarreiraFilter('BODY')">BODY</button>
                <button style="background-color:orange" class="btn-rounded" onclick="toggleBarreiraFilter('PAINT')">PAINT</button>
                <button style="background-color:gold" class="btn-rounded" onclick="toggleBarreiraFilter('TRIM')">TRIM</button>
                <button style="background-color:gray" class="btn-rounded" onclick="toggleBarreiraFilter('FAI')">FAI</button>
                <button style="background-color:purple" class="btn-rounded" onclick="toggleBarreiraFilter('PDI')">PDI</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('FALTA CONTENÇÃO')">FALTA CONTENÇÃO</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('CONCLUÍDO')">CONCLUÍDO</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('AG. BP DEFINITIVO')">AG. BP DEFINITIVO</button>
                <button style="background-color:red" class="btn-rounded" onclick="clearFilters()">LIMPAR</button> <!-- Botão para limpar filtros -->
            </div>
            <cfquery name="consulta_datas" datasource="#BANCOSINC#">
                SELECT
                    ID,
                    DATA_BP_PROCESSO,
                    DATA_BP_DEFINITIVO_PROCESSO,
                    ROUND(DATA_BP_PROCESSO - DATA_REGISTRO) AS DIAS
                FROM VEREAGIR2
            </cfquery>
            
            <table border="1" id="ACOMPTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>RPN</th>
                        <th>Data</th>
                        <th>Modelo</th>
                        <th>VIN/ Barcode</th>
                        <th>Peça</th>
                        <th>Posição</th>
                        <th>Problema</th>
                        <th>Barreira</th>
                        <th>Status</th>
                        <th>Status Novo</th>
                        <th>Total de Dias Contenção</th>
                        <th>Total de Dias Definitivo</th>
                        <th>Selecionar</th>
                    </tr>
                </thead>
                <tbody style="font-size:12px;">
                    <cfoutput query="consultas_acomp_cont">
                        <tr>
                            <td>#ID#</td>
                            <td>#RPN#</td>
                            <td>#lsdatetimeformat(DATA_REGISTRO, 'dd/mm/yyyy')#</td>
                            <td>#MODELO#</td>
                            <td>#VIN#</td>
                            <td>#PECA#</td>
                            <td>#POSICAO#</td>
                            <td>#PROBLEMA#</td>
                            <td>#BARREIRA#</td>
                            <td>
                                <cfif STATUS EQ "FALTA CONTENÇÃO">
                                    <span style="background-color: yellow; color: black; padding: 5px;">#STATUS#</span>
                                <cfelseif STATUS EQ "AG. BP DEFINITIVO">
                                    <span style="background-color: darkorange; color: white; padding: 5px;">#STATUS#</span>
                                <cfelseif STATUS EQ "CONCLUÍDO">
                                    <span style="background-color: green; color: white; padding: 5px;">#STATUS#</span>
                                <cfelse>
                                    <span>#STATUS#</span>
                                </cfif>
                            </td>
                            <td>
                                <cfloop query="result">
                                    <cfif result.ID_VEREAGIR2 EQ consultas_acomp_cont.ID>
                                        <cfif STATUS_NOVO EQ "BP QUEBRADO">
                                            <span style="background-color: red; color: white; padding: 5px;">#STATUS_NOVO#</span>
                                        <cfelseif STATUS_NOVO EQ "TRATANDO">
                                            <span style="background-color: blue; color: white; padding: 5px;">#STATUS_NOVO#</span>
                                        <cfelse>
                                            <span>#STATUS_NOVO#</span>
                                        </cfif>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                            </td>
                            <td>
                                <cfset diasCalculado = "">
                                <cfset dataBpProcesso = ""> <!-- Inicializa dataBpProcesso com valor padrão -->
                                <cfset statusPrazo = "">
                                
                                <!-- Loop para obter o valor de diasCalculado e a data DATA_BP_PROCESSO para o ID correspondente -->
                                <cfloop query="consulta_datas">
                                    <cfif consulta_datas.ID EQ consultas_acomp_cont.ID>
                                        <cfset diasCalculado = consulta_datas.DIAS>
                                        <cfset dataBpProcesso = consulta_datas.DATA_BP_PROCESSO>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                                
                                <!-- Definição do status baseado nas condições para o title -->
                                <cfif NOT Len(dataBpProcesso) AND diasCalculado LTE 1>
                                    <cfset statusPrazo = "Dentro do Prazo">
                                <cfelseif diasCalculado EQ 1>
                                    <cfset statusPrazo = "Finalizado no Prazo">
                                <cfelseif diasCalculado GT 1>
                                    <cfset statusPrazo = "Finalizado Fora do Prazo">
                                </cfif>
                            
                                <!-- Exibição do valor com o status no tooltip -->
                                <span style="<cfif diasCalculado GT 1>color: red;<cfelseif diasCalculado LTE 1>color: green;</cfif> font-weight: bold;" title="#statusPrazo#">
                                    #diasCalculado#
                                </span>
                            </td>
                            
                            <!-- Coluna Total de Dias Definitivo -->
                            <td>
                                <cfset diasDefinitivoCalculado = "">
                                <cfset statusDefinitivoPrazo = ""> <!-- Inicializa a variável de status -->
                            
                                <!-- Loop para obter o valor de diasDefinitivoCalculado para o ID correspondente -->
                                <cfloop query="consulta_data_definitivo">
                                    <cfif consulta_data_definitivo.ID EQ consultas_acomp_cont.ID>
                                        <cfset diasDefinitivoCalculado = consulta_data_definitivo.DIAS_DEFINITIVO>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
            
                                <!-- Definição do status para o tooltip -->
                                <cfif diasDefinitivoCalculado GT 7>
                                    <cfset statusDefinitivoPrazo = "Atrasado">
                                    <span style="color: red; font-weight: bold;" title="#statusDefinitivoPrazo#">
                                        #diasDefinitivoCalculado#
                                    </span>
                                <cfelse>
                                    <cfset statusDefinitivoPrazo = "Dentro do Prazo">
                                    <span style="color: green; font-weight: bold;" title="#statusDefinitivoPrazo#">
                                        #diasDefinitivoCalculado#
                                    </span>
                                </cfif>
                            </td>
                            
                            <cfif STATUS eq "FALTA CONTENÇÃO">
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_edit.cfm?id_editar=#id#'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>
                            <cfelseif STATUS eq "AG. BP DEFINITIVO">
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_edit_def.cfm?id_editar=#id#'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>
                            <cfelseif STATUS eq "CONCLUÍDO">
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_edit_conc.cfm?id_editar=#id#'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </div> 
        <script src="/qualidade/relatorios/assets/script.js?v8"></script>
    </body>
</html>