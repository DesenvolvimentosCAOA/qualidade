<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfif isDefined("url.id_editar")>
        <cfquery name="consulta_editar" datasource="#BANCOSINC#">
            SELECT * 
            FROM INTCOLDFUSION.VEREAGIR2
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
            ORDER BY ID DESC
        </cfquery>
    </cfif>

                
    <cfif isDefined("form.edit_data_validacao") and form.edit_data_validacao neq "">
        <cfquery name="atualiza" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.VEREAGIR2
            SET
                BP_CONTENCAO_PROCESSO = '#UCase(form.BP_CONTENCAO_PROCESSO)#',
                GRUPO_RESPONSAVEL = '#UCase(form.grupo_responsavel)#',
                DESCRICAO_CONTENCAO = '#UCase(form.descricao_contencao)#',
                necessita_qualidade = '#UCase(form.necessita_qualidade)#',
                RESPONSAVEL_QUALIDADE = '#UCase(form.responsavel_qualidade)#',
                bp_contencao_qualidade = '#UCase(form.bp_contencao_qualidade)#',
                descricao_cont_qa = '#UCase(form.descricao_cont_qa)#',

                bp_definitivo_processo = '#UCase(form.savedefinitivo)#',
                descricao_definitivo = '#UCase(form.save_descricao)#',
                responsavel_definitivo ='#UCase(form.save_resp)#',
                bp_definitivo_qualidade = '#UCase(form.save_bp)#'
            WHERE ID = '#url.id_editar#'
        </cfquery>
        <cflocation url="ver_agir_apagar.cfm">
    </cfif>

    <html lang="pt-BR">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>EDITAR - VER & AGIR</title>
            <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v3">
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
                <h2 style="color: blue; font-size:30px;">Dados do Item</h2>
                <cfoutput>
                    <div class="search-container">
                        <div class="input-group">
                            <label for="searchVIN">Vin/ Barcode</label>
                            <input readonly required type="text" id="searchVIN" name="ver_vin" placeholder="VIN" value="#consulta_editar.vin#">
                        </div>
                        <div hidden class="input-group">
                            <label for="searchData">Data</label>
                            <input readonly type="date" id="searchData" name="data_registro" placeholder="Data" value="#dateFormat(now(), 'yyyy-mm-dd')#">
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
                            <input readonly required type="text" id="searchSeveridade" name="ver_severidade" placeholder="Severidade" value="#consulta_editar.severidade#">
                        </div>                       
                        <div class="input-group">
                            <label for="searchOcorrencia">Ocorrência</label>
                            <input readonly required type="text" id="searchOcorrencia" name="ver_ocorrencia" placeholder="Ocorrência" value="#consulta_editar.ocorrencia#">
                        </div>
                        <div class="input-group">
                            <label for="searchDeteccao">Detecção</label>
                            <input readonly required type="text" id="searchDeteccao" name="ver_deteccao" placeholder="Detecção" value="#consulta_editar.deteccao#">
                        </div>
                        <div class="input-group">
                            <label for="searchRPN">RPN</label>
                            <input required style="font-weight:bold;color:red;" readonly name="ver_rpn" type="text" id="searchRPN" placeholder="RPN" value="#consulta_editar.rpn#">
                        </div>
                    </div>
            </div>

        <form id="for-edit" method="POST">
            <div id="tableProcess" class="table-container Process">
                <h2 style="color: yellow; font-size:30px;">AÇÃO DE CONTENÇÃO</h2>
                <div class="search-container">
                    <div class="input-group">
                        <label for="searchData">Data de Contenção Processo</label>
                        <input readonly type="date" id="searchValidacao" name="edit_data_validacao" placeholder="Data da validação" value="#DateFormat(consulta_editar.data_bp_processo, 'yyyy-mm-dd')#">
                    </div>
                    <div class="input-group">
                        <label for="BP_CONTENCAO_PROCESSO">BP de Contenção Processo</label>
                        <input type="text" id="BP_CONTENCAO_PROCESSO" name="BP_CONTENCAO_PROCESSO" placeholder="BP - VIN/BARCODE" value="#consulta_editar.bp_contencao_processo#">
                    </div>
                    <div class="input-group">
                        <label for="grupo_responsavel">Responsável pela Contenção Processo</label>
                        <input type="text" id="grupo_responsavel" name="grupo_responsavel" placeholder="Responsável" value="#consulta_editar.grupo_responsavel#">
                    </div>
                    <div class="input-group">
                        <label for="descricao_contencao">Descrição da Contenção Processo</label>
                        <input type="text" id="descricao_contencao" name="descricao_contencao" placeholder="Descrição" value="#consulta_editar.descricao_contencao#">
                    </div>
                    <div class="input-group">
                        <label for="necessita_qualidade">Foi Necessário Ação da Qualidade?</label>
                        <input list="necessita_qualidade_options" id="necessita_qualidade" name="necessita_qualidade" value="#consulta_editar.necessita_qualidade#" oninput="validateDatalist()">
                        <datalist id="necessita_qualidade_options">
                            <option value="SIM">
                            <option value="NAO">
                        </datalist>
                        <span id="validationMessage" style="color: red; display: none;">Por favor, insira um valor válido da lista.</span>
                    </div>
                    <script>
                        function validateDatalist() {
                            const input = document.getElementById('necessita_qualidade');
                            const datalist = document.getElementById('necessita_qualidade_options');
                            const validationMessage = document.getElementById('validationMessage');
                            const options = Array.from(datalist.options).map(option => option.value);
                    
                            if (!options.includes(input.value)) {
                                validationMessage.style.display = 'block';
                            } else {
                                validationMessage.style.display = 'none';
                            }
                        }
                    </script>
                    <div class="input-group">
                        <label for="bp_contencao_qualidade">BP de contenção da Qualidade (Se houver)</label>
                        <input type="text" id="bp_contencao_qualidade" name="bp_contencao_qualidade" value="#consulta_editar.bp_contencao_qualidade#">
                    </div>
                    <div class="input-group">
                        <label for="descricao_cont_qa">Descrição da Contenção</label>
                        <input type="text" id="descricao_cont_qa" name="descricao_cont_qa" value="#consulta_editar.descricao_cont_qa#">
                    </div>
                    <div class="input-group">
                        <label for="responsavel_qualidade">Responsável QA pela Contenção</label>
                        <input type="text" id="responsavel_qualidade" name="responsavel_qualidade" value="#consulta_editar.responsavel_qualidade#">
                    </div>
                </div>
            </div>

            <div id="tableProcess" class="table-container Process">
                <h2 style="color: green; font-size:30px;">AÇÃO DEFINITIVA</h2>
                <div class="search-container">
                    <div class="input-group">
                        <label for="saveData">Data Definitivo (Processo)</label>
                        <input readonly type="date" id="saveData" name="saveData" value="#DateFormat(consulta_editar.data_bp_definitivo_processo, 'yyyy-mm-dd')#">
                    </div>
                    <div class="input-group">
                        <label for="savedefinitivo">BP Definitivo (Processo)</label>
                        <input type="text" id="savedefinitivo" name="savedefinitivo" value="#consulta_editar.bp_definitivo_processo#">
                    </div>
                    <div class="input-group">
                        <label for="save_descricao">Descrição Definitivo (Processo)</label>
                        <input type="text" id="save_descricao" name="save_descricao" value="#consulta_editar.descricao_definitivo#">
                    </div>
                    <div class="input-group">
                        <label for="save_resp">Responsável Definitivo (Processo)</label>
                        <input type="text" id="save_resp" name="save_resp" value="#consulta_editar.RESPONSAVEL_DEFINITIVO#">
                    </div>
                    <div class="input-group">
                        <label for="save_def">Data BP Definitivo (Qualidade)</label>
                        <input readonly type="date" id="save_def" name="save_def" value="#DateFormat(consulta_editar.data_bp_definitivo_qualidade, 'yyyy-mm-dd')#">
                    </div>
                    <div class="input-group">
                        <label for="save_bp">BP Definitivo (Qualidade)</label>
                        <input type="text" id="save_bp" name="save_bp" value="#consulta_editar.bp_definitivo_qualidade#">
                    </div>
                </div>
                <div class="search-container">
                    <div class="search-container">
                        <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                        <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao" >Salvar</button>
                    </div>
                    <script>
                        function voltar() {
                                // Redireciona para a página anterior
                                window.history.back(); // ou utilize: window.location.href = '/qualidade/relatorios/ver_agir_apagar.cfm'; para redirecionar a uma página específica
                            }
                    </script>
                </div>
            </div>
        </form>
                </cfoutput>
    </body>
</html>
        