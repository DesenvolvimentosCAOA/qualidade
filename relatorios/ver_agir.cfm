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
        WHERE ROWNUM <= 400
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
        v2.PECA AS PECA_VEREAGIR2,
        v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
        v2.ID AS ID_VEREAGIR2,
        v2.BARREIRA,
        MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
        MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
        v2.DATA_BP_DEFINITIVO_PROCESSO AS DATA_BP_DEFINITIVO,

        -- Contagem de ocorrências em `sistema_qualidade_fa` após a data e hora do BP definitivo
        (SELECT COUNT(*)
        FROM SISTEMA_QUALIDADE_FA sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN 'N0'
        ) AS TOTAL_OCORRENCIAS_APOS_BP,
         -- Última data da ocorrência em sistema_qualidade_fa após o BP definitivo
        (SELECT MAX(sqf_inner.USER_DATA)
        FROM SISTEMA_QUALIDADE_FA sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN ('N0')
        ) AS ULTIMA_DATA_OCORRENCIA_APOS_BP
    FROM 
        SISTEMA_QUALIDADE_FA sqf
    LEFT JOIN
        VEREAGIR2 v2
    ON
        sqf.PECA = v2.PECA 
        AND sqf.PROBLEMA = v2.PROBLEMA
    WHERE 
        v2.BARREIRA = 'FINAL ASSEMBLY'
    GROUP BY 
        sqf.PECA, sqf.PROBLEMA, 
        v2.PECA, v2.PROBLEMA, 
        v2.ID, v2.BARREIRA, v2.DATA_BP_DEFINITIVO_PROCESSO

    UNION ALL

    SELECT 
        sqf.PECA AS PECA_SQF, 
        sqf.PROBLEMA AS PROBLEMA_SQF,
        v2.PECA AS PECA_VEREAGIR2,
        v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
        v2.ID AS ID_VEREAGIR2,
        v2.BARREIRA,
        MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
        MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
        v2.DATA_BP_DEFINITIVO_PROCESSO AS DATA_BP_DEFINITIVO,

        -- Contagem de ocorrências em `sistema_qualidade_fa` após a data e hora do BP definitivo
        (SELECT COUNT(*)
        FROM SISTEMA_QUALIDADE_FAI sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN 'N0'
        ) AS TOTAL_OCORRENCIAS_APOS_BP,
         -- Última data da ocorrência em sistema_qualidade_fa após o BP definitivo
        (SELECT MAX(sqf_inner.USER_DATA)
        FROM SISTEMA_QUALIDADE_FAI sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN ('N0')
        ) AS ULTIMA_DATA_OCORRENCIA_APOS_BP

    FROM 
        SISTEMA_QUALIDADE_FAI sqf
    LEFT JOIN
        VEREAGIR2 v2
    ON
        sqf.PECA = v2.PECA 
        AND sqf.PROBLEMA = v2.PROBLEMA
    WHERE 
        v2.BARREIRA = 'FAI'
    GROUP BY 
        sqf.PECA, sqf.PROBLEMA, 
        v2.PECA, v2.PROBLEMA, 
        v2.ID, v2.BARREIRA, v2.DATA_BP_DEFINITIVO_PROCESSO

    UNION ALL

    SELECT 
        sqf.PECA AS PECA_SQF, 
        sqf.PROBLEMA AS PROBLEMA_SQF,
        v2.PECA AS PECA_VEREAGIR2,
        v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
        v2.ID AS ID_VEREAGIR2,
        v2.BARREIRA,
        MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
        MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
        v2.DATA_BP_DEFINITIVO_PROCESSO AS DATA_BP_DEFINITIVO,

        -- Contagem de ocorrências em `sistema_qualidade_fa` após a data e hora do BP definitivo
        (SELECT COUNT(*)
        FROM SISTEMA_QUALIDADE sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN 'N0'
        ) AS TOTAL_OCORRENCIAS_APOS_BP,
         -- Última data da ocorrência em sistema_qualidade_fa após o BP definitivo
        (SELECT MAX(sqf_inner.USER_DATA)
        FROM SISTEMA_QUALIDADE sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN ('N0')
        ) AS ULTIMA_DATA_OCORRENCIA_APOS_BP

    FROM 
        SISTEMA_QUALIDADE sqf
    LEFT JOIN
        VEREAGIR2 v2
    ON
        sqf.PECA = v2.PECA 
        AND sqf.PROBLEMA = v2.PROBLEMA
    WHERE 
        v2.BARREIRA = 'PAINT'
    GROUP BY 
        sqf.PECA, sqf.PROBLEMA, 
        v2.PECA, v2.PROBLEMA, 
        v2.ID, v2.BARREIRA, v2.DATA_BP_DEFINITIVO_PROCESSO

    UNION ALL

    SELECT 
        sqf.PECA AS PECA_SQF, 
        sqf.PROBLEMA AS PROBLEMA_SQF,
        v2.PECA AS PECA_VEREAGIR2,
        v2.PROBLEMA AS PROBLEMA_VEREAGIR2,
        v2.ID AS ID_VEREAGIR2,
        v2.BARREIRA,
        MAX(sqf.USER_DATA) AS ULTIMA_DATA_SQF,
        MAX(v2.DATA_REGISTRO) AS ULTIMA_DATA_VEREAGIR2,
        v2.DATA_BP_DEFINITIVO_PROCESSO AS DATA_BP_DEFINITIVO,
        -- Contagem de ocorrências em `sistema_qualidade_fa` após a data e hora do BP definitivo
        (SELECT COUNT(*)
        FROM SISTEMA_QUALIDADE_BODY sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND TRUNC(sqf_inner.USER_DATA) >= TRUNC(v2.DATA_BP_DEFINITIVO_PROCESSO)
        AND CRITICIDADE NOT IN 'N0'
        ) AS TOTAL_OCORRENCIAS_APOS_BP,
         -- Última data da ocorrência em sistema_qualidade_fa após o BP definitivo
        (SELECT MAX(sqf_inner.USER_DATA)
        FROM SISTEMA_QUALIDADE_BODY sqf_inner
        WHERE sqf_inner.PECA = sqf.PECA
        AND sqf_inner.PROBLEMA = sqf.PROBLEMA
        AND sqf_inner.USER_DATA >= v2.DATA_BP_DEFINITIVO_PROCESSO
        AND CRITICIDADE NOT IN ('N0')
        ) AS ULTIMA_DATA_OCORRENCIA_APOS_BP

    FROM 
        SISTEMA_QUALIDADE_BODY sqf
    LEFT JOIN
        VEREAGIR2 v2
    ON
        sqf.PECA = v2.PECA 
        AND sqf.PROBLEMA = v2.PROBLEMA
    WHERE 
        v2.BARREIRA = 'BODY'
    GROUP BY 
        sqf.PECA, sqf.PROBLEMA, 
        v2.PECA, v2.PROBLEMA, 
        v2.ID, v2.BARREIRA, v2.DATA_BP_DEFINITIVO_PROCESSO
</cfquery>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>ACOMPANHAMENTO - VER & AGIR</title>
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
            <button class="btn-rounded" style='background-color:red;color:black;'>Acompanhamento</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_body.cfm')">Body</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_paint.cfm')">Paint</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_fa.cfm')">Final Assembly</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_fai.cfm')">FAI</button>
            <button class="btn-rounded" onclick="navigateTo('/qualidade/relatorios/ver_agir_pdi.cfm')">PDI</button>
        </div>

        <div id="tableACOMP" class="table-container">
            <h2 style="color:gray">Acompanhamento BP</h2>
            <!-- Inputs de pesquisa -->
            <div class="search-container">
                <button class="Btn" id="report" type="Button">
                <svg class="svgIcon" viewBox="0 0 384 512" height="1em" xmlns="http://www.w3.org/2000/svg"><path d="M169.4 470.6c12.5 12.5 32.8 12.5 45.3 0l160-160c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L224 370.8 224 64c0-17.7-14.3-32-32-32s-32 14.3-32 32l0 306.7L54.6 265.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3l160 160z"></path></svg>
                <span class="icon2"></span>
                <span class="tooltip">Download</span>
                </button>
                <input type="text" id="searchIDACOMP" placeholder="Pesquisar ID" onkeyup="filterTableACOMP()">
                <input type="text" id="searchVINACOMP" placeholder="SIM ou NÃO" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPecaACOMP" placeholder="Pesquisar Peça" onkeyup="filterTableACOMP()">
                <input type="text" id="searchPosicaoACOMP" placeholder="Pesquisar Posição" onkeyup="filterTableACOMP()">
                <input type="text" id="searchProblemaACOMP" placeholder="Pesquisar Problema" onkeyup="filterTableACOMP()">
            </div>
            <div class="search-container">
                <button style="background-color:blue" class="btn-rounded" onclick="toggleBarreiraFilter('BODY')">BODY</button>
                <button style="background-color:orange" class="btn-rounded" onclick="toggleBarreiraFilter('PAINT')">PAINT</button>
                <button style="background-color:gold" class="btn-rounded" onclick="toggleBarreiraFilter('FINAL ASSEMBLY')">FA</button>
                <button style="background-color:gray" class="btn-rounded" onclick="toggleBarreiraFilter('FAI')">FAI</button>
                <button style="background-color:purple" class="btn-rounded" onclick="toggleBarreiraFilter('PDI')">PDI</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('FALTA CONTENÇÃO')">FALTA CONTENÇÃO</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('CONCLUÍDO')">CONCLUÍDO</button>
                <button class="btn-rounded" onclick="toggleStatusFilter('AG. BP DEFINITIVO')">AG. BP DEFINITIVO</button>
                <button style="background-color:red" class="btn-rounded" onclick="clearFilters()">LIMPAR</button> <!-- Botão para limpar filtros -->
            </div>
            <table border="1" id="ACOMPTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data</th>
                        <th>Modelo</th>
                        <th>Houve Intervenção Q.A?</th>
                        <th>Peça</th>
                        <th>Posição</th>
                        <th>Problema</th>
                        <th>Barreira</th>
                        <th>Status</th>
                        <th>Tempo Contenção</th>
                        <th>Tempo Definitivo</th>
                        <th>Ocorrências Após BP</th>
                        <th>Status BP</th>
                        <th>Selecionar</th>
                        <th>Última Ocorrência</th>
                    </tr>
                </thead>
                <tbody style="font-size:12px;background-color:red;">
                    <cfoutput query="consultas_acomp_cont">
                        <tr>
                            <td>#ID#</td>
                            <td>#lsdatetimeformat(DATA_REGISTRO, 'dd/mm/yyyy')#</td>
                            <td>#MODELO#</td>
                            <td>#NECESSITA_QUALIDADE#</td>
                            <td>#PECA#</td>
                            <td>#POSICAO#</td>
                            <td>#PROBLEMA#</td>
                            <td>#BARREIRA#</td>
                            <td class="wide-column">
                                <cfif STATUS EQ "FALTA CONTENÇÃO">
                                    <span class="status-span" style="background-color: yellow; color: black;">#STATUS#</span>
                                <cfelseif STATUS EQ "AG. BP DEFINITIVO">
                                    <span class="status-span" style="background-color: darkorange; color: white;">#STATUS#</span>
                                <cfelseif STATUS EQ "CONCLUÍDO">
                                    <span class="status-span" style="background-color: green; color: white;">#STATUS#</span>
                                <cfelse>
                                    <span class="status-span">#STATUS#</span>
                                </cfif>
                            </td>
                            <!-- Coluna Total de Dias -->
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

                            <!--Coluna Total de Ocorrências Após BP -->
                            <td>
                                <cfset totalOcorrenciasAposBP = 0>
                                <cfloop query="result">
                                    <cfif result.ID_VEREAGIR2 EQ consultas_acomp_cont.ID>
                                        <cfset totalOcorrenciasAposBP = result.TOTAL_OCORRENCIAS_APOS_BP>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                                #totalOcorrenciasAposBP#
                            </td>
                            <td>
                                <cfif totalOcorrenciasAposBP GTE 1>
                                    <span style="color: red; font-weight: bold;">QUEBRA DE BP</span>
                                    <cfelse>
                                        <span style="color: green; font-weight: bold;">BP VÁLIDO</span>
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
                                    <button class="btn-rounded" onclick="self.location='ver_agir_edit_def.cfm?id_editar=#id#'"><i class="mdi mdi-pencil-outline"></i>Selecionar</button>
                                </td>
                            <cfelseif STATUS eq "CONCLUÍDO">
                                <td class="text-nowrap">
                                    <button class="btn-rounded" onclick="self.location='ver_agir_edit_conc.cfm?id_editar=#id#'">
                                        <i class="mdi mdi-pencil-outline"></i>Selecionar
                                    </button>
                                </td>
                            </cfif>
                            <td>
                                <cfset ultimaDataOcorrenciaAposBP = ""> <!-- Inicializa a variável -->
                                <!-- Loop para obter a última data da ocorrência após BP -->
                                <cfloop query="result">
                                    <cfif result.ID_VEREAGIR2 EQ consultas_acomp_cont.ID>
                                        <cfset ultimaDataOcorrenciaAposBP = result.ULTIMA_DATA_OCORRENCIA_APOS_BP>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                                <!-- Exibe a data formatada ou N/A -->
                                <cfif Len(ultimaDataOcorrenciaAposBP)>
                                    #lsdatetimeformat(ultimaDataOcorrenciaAposBP, 'dd/mm/yyyy HH:mm')#
                                <cfelse>
                                    N/A
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
             <!-- jQuery first, then Popper.js, then Bootstrap JS -->
             <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
             <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
             <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
             <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
             <script>
                 // Gerando Excel da tabela
                 var table2excel = new Table2Excel();
                 document.getElementById('report').addEventListener('click', function() {
                     table2excel.export(document.querySelectorAll('#ACOMPTable'));
                 });
             </script>
        </div> 
        <script src="/qualidade/relatorios/assets/script.js"></script>
    </body>
</html>