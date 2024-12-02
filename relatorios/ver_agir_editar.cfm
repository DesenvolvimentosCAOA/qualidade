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

                
    <cfif isDefined("form.BP_CONTENCAO_PROCESSO") and form.BP_CONTENCAO_PROCESSO neq "">
        <cfquery name="atualiza" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.VEREAGIR2
            SET
                BP_CONTENCAO_PROCESSO = '#UCase(form.BP_CONTENCAO_PROCESSO)#',
                GRUPO_RESPONSAVEL = '#UCase(form.GRUPO_RESPONSAVEL)#',
                DESCRICAO_CONTENCAO = '#UCase(form.DESCRICAO_CONTENCAO)#',
                NECESSITA_QUALIDADE = '#UCase(form.NECESSITA_QUALIDADE)#',
                BP_CONTENCAO_QUALIDADE = '#UCase(form.BP_CONTENCAO_QUALIDADE)#',
                DESCRICAO_CONT_QA = '#UCase(form.DESCRICAO_CONT_QA)#',
                RESPONSAVEL_QUALIDADE = '#UCase(form.RESPONSAVEL_QUALIDADE)#',
                BP_DEFINITIVO_PROCESSO = '#UCase(form.BP_DEFINITIVO_PROCESSO)#',
                DESCRICAO_DEFINITIVO = '#UCase(form.DESCRICAO_DEFINITIVO)#',
                RESPONSAVEL_DEFINITIVO = '#UCase(form.RESPONSAVEL_DEFINITIVO)#',
                DATA_BP_DEFINITIVO_QUALIDADE = <cfqueryparam value="#form.data_bp_definitivo_qualidade#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE ID = '#url.id_editar#'
        </cfquery>
    </cfif>

    <html lang="pt-BR">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>VER & AGIR</title>
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
                                <label for="searchData">Data da Implementação</label>
                                <input readonly type="date" id="searchValidacao" name="edit_data_validacao" placeholder="Data da validação" value="#DateFormat(consulta_editar.data_bp_processo, 'yyyy-mm-dd')#">
                            </div>
                                                  
                            <div class="input-group">
                                <label for="BP_CONTENCAO_PROCESSO">Ponto de Corte Contenção</label>
                                <input type="text" id="BP_CONTENCAO_PROCESSO" name="BP_CONTENCAO_PROCESSO" placeholder="BP - VIN/BARCODE" value="#consulta_editar.bp_contencao_processo#">
                            </div>
                            <div class="input-group">
                                <label for="grupo_responsavel">Responsável pela Contenção</label>
                                <input type="text" id="grupo_responsavel" name="grupo_responsavel" placeholder="Responsável" value="#consulta_editar.grupo_responsavel#">
                            </div>
                            <div class="input-group">
                                <label for="descricao_contencao">O que foi feito?</label>
                                <input type="text" id="descricao_contencao" name="descricao_contencao" placeholder="Responsável" value="#consulta_editar.descricao_contencao#">
                            </div>
                            <div class="input-group">
                                <label for="necessita_qualidade">Foi Necessário Ação da Qualidade?</label>
                                <input type="text" id="necessita_qualidade" name="necessita_qualidade" value="#consulta_editar.necessita_qualidade#">
                            </div>
                            <div class="input-group">
                                <label for="bp_contencao_qualidade">BP da Qualidade - Contenção (Se houver)</label>
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
                                <label for="data_bp_definitivo_processo">Data da Ação Definitiva</label>
                                <input readonly type="date" id="data_bp_definitivo_processo" name="data_bp_definitivo_processo" placeholder="Data da validação" value="#DateFormat(consulta_editar.data_bp_definitivo_processo, 'yyyy-mm-dd')#">
                            </div>
                                                  
                            <div class="input-group">
                                <label for="bp_definitivo_processo">Ponto de Corte Definitivo</label>
                                <input type="text" id="bp_definitivo_processo" name="bp_definitivo_processo" placeholder="BP - VIN/BARCODE" value="#consulta_editar.bp_definitivo_processo#">
                            </div>
                            <div class="input-group">
                                <label for="descricao_definitivo">O que foi feito?</label>
                                <input type="text" id="descricao_definitivo" name="descricao_definitivo" placeholder="Responsável" value="#consulta_editar.descricao_definitivo#">
                            </div>
                            <div class="input-group">
                                <label for="responsavel_definitivo">Responsável pela Ação Definitiva</label>
                                <input type="text" id="responsavel_definitivo" name="responsavel_definitivo" placeholder="Responsável" value="#consulta_editar.responsavel_definitivo#">
                            </div>
                            <div class="input-group">
                                <label for="bp_definitivo_qualidade">BP da Qualidade - Definitivo</label>
                                <input type="text" id="bp_definitivo_qualidade" name="bp_definitivo_qualidade" placeholder="Responsável" value="#consulta_editar.bp_definitivo_qualidade#">
                            </div>
                        </div>
                        <div class="search-container">
                            <div class="search-container">
                                <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                                <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                            </div>
                            <script>
                                function voltar() {
                                        // Redireciona para a página anterior
                                        window.history.back(); // ou utilize: window.location.href = 'pagina-desejada.cfm'; para redirecionar a uma página específica
                                    }
                            </script>
                        </div>
            </div>
            
        </form>
                </cfoutput>
    </body>
</html>
        