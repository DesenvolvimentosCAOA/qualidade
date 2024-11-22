<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfif isDefined("url.tabela") and isDefined("url.id_editar")>
        <!--- Valida se o nome da tabela é permitido para evitar SQL injection --->
        <cfset tabelaPermitida = ListFind("sistema_qualidade,sistema_qualidade_body,sistema_qualidade_fa,sistema_qualidade_fai,sistema_qualidade_pdi_saida", url.tabela)>
    
        <cfif tabelaPermitida>
            <cfquery name="consulta_editar" datasource="#BANCOSINC#">
                SELECT * 
                FROM INTCOLDFUSION.#url.tabela#
                WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
                ORDER BY ID DESC
            </cfquery>
        <cfelse>
            <cfoutput>Erro: Tabela não permitida.</cfoutput>
        </cfif>
    <cfelse>
        <cfoutput>Erro: Parâmetros inválidos.</cfoutput>
    </cfif>

<cfif structKeyExists(form, "data_registro")>
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
       SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.VEREAGIR2
    </cfquery>


<cfquery name="insere" datasource="#BANCOSINC#">
    INSERT INTO INTCOLDFUSION.VEREAGIR2 (ID, DATA_REGISTRO, DATA_SGQ, MODELO, ID_SGQ, VIN, PECA, POSICAO, PROBLEMA, SEVERIDADE, DETECCAO, OCORRENCIA, RPN, TURNO, GRUPO_RESPONSAVEL, STATUS, BARREIRA)
    VALUES(
        <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
        <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
        <cfqueryparam value="#DateFormat(form.data_sgq, 'yyyy-mm-dd')# #TimeFormat(form.data_sgq, 'HH:mm:ss')#" cfsqltype="CF_SQL_TIMESTAMP">,
        <cfqueryparam value="#UCase(form.ver_modelo)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_vin)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_peca)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_posicao)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_problema)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_severidade)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_deteccao)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_ocorrencia)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_rpn)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_turno)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_grupo)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_status)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.ver_barreira)#" cfsqltype="CF_SQL_VARCHAR">
    )
</cfquery>
<cflocation url="ver_agir.cfm">

</cfif>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v6"> 
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                margin: 0;
                padding: 0;
            }
            .table-container {
                margin: 20px auto;
                padding: 20px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                max-width: 800px;
            }
            h2 {
                text-align: center;
                margin-bottom: 20px;
            }
            .search-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
            }
            .input-group {
                flex: 1 1 45%;
                margin-bottom: 15px;
            }
            .input-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .input-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .btn-rounded {
                display: inline-block;
                padding: 10px 20px;
                margin: 10px 5px;
                border: none;
                border-radius: 20px;
                background-color: #007bff;
                color: white;
                cursor: pointer;
                text-align: center;
            }
            .btn-rounded.back-btn {
                background-color: #6c757d;
            }
            .btn-rounded:hover {
                background-color: #0056b3;
            }
            .btn-rounded.back-btn:hover {
                background-color: #5a6268;
            }
        </style>       
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>

        <div id="tableBody" class="table-container" style="margin-top:100px;">
            <h2 style="color:#f6722c; font-size:30px;">Ver & Agir</h2>
            <form id="for-edit" method="POST">
                <cfoutput>
                    <div class="search-container">
                        <div class="input-group">
                            <label for="searchVIN">
                                <cfif ListFind("sistema_qualidade_fa,sistema_qualidade_fai,sistema_qualidade_pdi_saida", url.tabela)>
                                    VIN
                                <cfelse>
                                    Barcode
                                </cfif>
                            </label>
                            <input readonly type="text" id="searchVIN" name="ver_vin" placeholder="VIN" value="<cfif ListFind('sistema_qualidade_fa,sistema_qualidade_fai,sistema_qualidade_pdi_saida', url.tabela)>#consulta_editar.VIN#<cfelse>#consulta_editar.BARCODE#</cfif>">
                        </div>
                        <div hidden class="input-group">
                            <label for="searchData">Data</label>
                            <input readonly type="date" id="searchData" name="data_registro" placeholder="Data" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>">
                        </div>
                        <div hidden class="input-group">
                            <label for="searchDatasgq">Data e Hora SGQ</label>
                            <input readonly type="datetime-local" id="searchDatasgq" name="data_sgq" placeholder="Data e Hora SGQ" value="#DateFormat(consulta_editar.user_data, 'yyyy-mm-dd')#T#TimeFormat(consulta_editar.user_data, 'HH:nn:ss')#">
                        </div>
                        <div hidden class="input-group">
                            <label for="searchStatus">Status</label>
                            <input type="text" id="searchStatus" name="ver_status" placeholder="Status" value="FALTA CONTENÇÃO">
                        </div>
                        <div class="input-group">
                            <label for="searchModelo">Modelo</label>
                            <input readonly type="text" id="searchModelo" name="ver_modelo" placeholder="Modelo" value="#consulta_editar.modelo#">
                        </div>
                        <div class="input-group">
                            <label for="searchPeca">Peça</label>
                            <input readonly required type="text" id="searchPeca" name="ver_peca" placeholder="Peça" value="#consulta_editar.peca#">
                        </div>
                        <div class="input-group">
                            <label for="searchPosicao">Posição</label>
                            <input readonly required type="text" id="searchPosicao" name="ver_posicao" placeholder="Posição" value="#consulta_editar.posicao#">
                        </div>
                        <div class="input-group">
                            <label for="searchProblema">Problema</label>
                            <input readonly required type="text" id="searchProblema" name="ver_problema" placeholder="Problema" value="#consulta_editar.problema#">
                        </div>
                    </div>
                    <div class="search-container">
                        <div class="input-group">
                            <label for="searchSeveridade">Severidade</label>
                            <select required id="searchSeveridade" name="ver_severidade" disabled>
                                <option value="" disabled selected>selecione</option>
                                <option title="Perigo sem aviso, possível falha catastrófica" value="10">10</option>
                                <option title="Perigo com aviso, possível falha catastrófica" value="9">9</option>
                                <option title="Alta severidade, funcionalidade crítica afetada" value="8">8</option>
                                <option title="Alta severidade, funcionalidade importante afetada" value="7">7</option>
                                <option title="Média severidade, funcionalidade secundária afetada" value="6">6</option>
                                <option title="Média severidade, desconforto notável" value="5">5</option>
                                <option title="Baixa severidade, desconforto menor" value="4">4</option>
                                <option title="Baixa severidade, imperceptível para o cliente" value="3">3</option>
                                <option title="Muito baixa severidade, imperceptível para o cliente" value="2">2</option>
                                <option title="Nenhum efeito perceptível" value="1">1</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label for="searchOcorrência">Ocorrência</label>
                            <select required id="searchOcorrência" name="ver_ocorrencia" disabled>
                                <option value="" disabled selected>selecione</option>
                                <option title="Falha muito alta" value="10">10</option>
                                <option title="Falha alta" value="9">9</option>
                                <option title="Falha significativa" value="8">8</option>
                                <option title="Falha moderada alta" value="7">7</option>
                                <option title="Falha moderada" value="6">6</option>
                                <option title="Falha ocasional" value="5">5</option>
                                <option title="Falha baixa" value="4">4</option>
                                <option title="Falha muito baixa" value="3">3</option>
                                <option title="Falha remota" value="2">2</option>
                                <option title="Falha extremamente remota" value="1">1</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label for="searchDetecção">Detecção</label>
                            <select required id="searchDetecção" name="ver_deteccao" onchange="calcularRPN()" disabled>
                                <option value="" disabled selected>selecione</option>
                                <option title="Nenhuma chance de detecção antes que o produto chegue ao cliente" value="10">10</option>
                                <option title="Muito baixa chance de detecção" value="9">9</option>
                                <option title="Baixa chance de detecção" value="8">8</option>
                                <option title="Moderada baixa chance de detecção" value="7">7</option>
                                <option title="Moderada chance de detecção" value="6">6</option>
                                <option title="Moderada alta chance de detecção" value="5">5</option>
                                <option title="Alta chance de detecção" value="4">4</option>
                                <option title="Muito alta chance de detecção" value="3">3</option>
                                <option title="Detecção quase certa" value="2">2</option>
                                <option title="Detecção certa" value="1">1</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label for="searchRPN">RPN</label>
                            <input required style="font-weight:bold;color:red;" readonly name="ver_rpn" type="text" id="searchRPN" placeholder="RPN">
                        </div>
                    </div>
                    <div class="search-container">
                        <div class="input-group">
                            <label for="searchGrupo">Grupo Responsável</label>
                            <input list="grupos" id="searchGrupo" name="ver_grupo" required disabled placeholder="Selecione">
                            <datalist id="grupos">
                                <option value="BODY">
                                <option value="PAINT">
                                <option value="FA">
                                <option value="FAI">
                                <option value="LOG">
                                <option value="CKD">
                                <option value="GMF">
                            </datalist>
                        </div>
                        <div class="input-group">
                            <label for="searchTurno">Turno</label>
                            <input list="turnos" id="searchTurno" name="ver_turno" required disabled placeholder="Selecione">
                            <datalist id="turnos">
                                <option value="1º Turno">
                                <option value="2º Turno">
                                <option value="3º Turno">
                            </datalist>
                        </div>
                        <div class="input-group">
                            <label for="searchBarreira">Barreira</label>
                            <select id="searchBarreira" name="ver_barreira" onchange="updateInputValue(this)">
                                <option value="" disabled selected>Selecione uma opção</option>
                                <option value="BODY" <cfif isDefined('url.tabela') AND url.tabela EQ 'sistema_qualidade_body'>selected</cfif>>BODY</option>
                                <option value="PAINT" <cfif isDefined('url.tabela') AND url.tabela EQ 'sistema_qualidade'>selected</cfif>>PAINT</option>
                                <option value="FA" <cfif isDefined('url.tabela') AND url.tabela EQ 'sistema_qualidade_fa'>selected</cfif>>FA</option>
                                <option value="FAI" <cfif isDefined('url.tabela') AND url.tabela EQ 'sistema_qualidade_fai'>selected</cfif>>FAI</option>
                                <option value="PDI" <cfif isDefined('url.tabela') AND url.tabela EQ 'sistema_qualidade_pdi_saida'>selected</cfif>>PDI</option>
                            </select>
                            
                        </div>
                        
                        <script>
                            // Função para atualizar o valor do input baseado na seleção do select
                            function updateInputValue(selectElement) {
                                const inputField = document.getElementById('hiddenSearchBarreira');
                                inputField.value = selectElement.value || inputField.value;  // Caso nada seja selecionado, mantém o valor do input original
                            }
                        </script>
                        
                        
                    </div>
                    <div class="search-container">
                        <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                        <button type="button" class="btn-rounded edit-btn" id="btnEditar" onclick="habilitarEdicao()">Editar</button>
                        <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao" style="display:none;">Salvar Edição</button>
                        <button type="button" class="btn-rounded cancel-btn" id="btnCancelarEdicao" style="display:none;" onclick="cancelarEdicao()">Cancelar</button>
                    </div>
            
                </cfoutput>
            </form>
            
        </div>
        <script src="/qualidade/relatorios/assets/script.js?v1"></script>
    </body>
</html>