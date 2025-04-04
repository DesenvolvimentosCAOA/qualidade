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
    
    <cfif isDefined("form.ver_bp") and form.ver_bp neq "">
        <cfquery name="atualiza" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.VEREAGIR2
            SET
                DATA_BP_PROCESSO = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,                
                BP_CONTENCAO_PROCESSO = <cfqueryparam value="#UCase(form.ver_bp)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = <cfqueryparam value="#form.ver_status#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_CONTENCAO = <cfqueryparam value="#UCase(form.ver_contencao)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_CONTENCAO2 = <cfqueryparam value="#UCase(form.ver_contencao2)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_CONTENCAO3 = <cfqueryparam value="#UCase(form.ver_contencao3)#" cfsqltype="CF_SQL_VARCHAR">,
                NECESSITA_QUALIDADE = <cfqueryparam value="#UCase(form.ver_qc)#" cfsqltype="CF_SQL_VARCHAR">,
                RESPONSAVEL_CONTENCAO = <cfqueryparam value="#UCase(form.ver_responsavel)#" cfsqltype="CF_SQL_VARCHAR">,
                BP_CONTENCAO_QUALIDADE = <cfqueryparam value="#UCase(form.ver_bp_contencao_qa)#" cfsqltype="CF_SQL_VARCHAR">,
                MOTIVO_NAO_QUALIDADE = <cfqueryparam value="#UCase(form.ver_motivo)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_CONT_QA = <cfqueryparam value="#UCase(form.ver_bp_descricao_qa)#" cfsqltype="CF_SQL_VARCHAR">,
                RESPONSAVEL_QUALIDADE = <cfqueryparam value="#UCase(form.ver_resp_qa)#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cflocation url="ver_agir.cfm">
    </cfif>
    
    
<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>CONTENÇÃO - VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v4">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_shop.css?v1">
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
        <div id="loading-screen">
            <div class="spinner"></div>
        </div>
        <div id="tableBody" class="table-container">
            <h2 style="color: blue; font-size:30px;margin-top:5vw;">Dados do Item</h2>
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
            </cfoutput>
        </div>

        <div id="tableProcess" class="table-container Process">
            <h2 style="color: yellow; font-size:30px;">AÇÃO DE CONTENÇÃO</h2>
            <form id="for-edit" method="POST">
                <cfoutput>
                    <div class="search-container">
                        <div hidden class="input-group">
                            <label for="searchData">Data da Validação</label>
                            <input readonly type="date" id="searchValidacao" name="data_validacao" placeholder="Data da validação" value="#dateFormat(now(), 'yyyy-mm-dd')#">
                        </div>
                        <div class="input-group">
                            <label for="searchStatus">STATUS</label>
                            <input readonly required type="text" id="searchSTATUS" name="ver_status" placeholder="Status de Conclusão" value="FALTA CONTENÇÃO" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchBP">Ponto de Corte</label>
                            <input required type="text" id="searchBP" name="ver_bp" placeholder="BP - VIN/BARCODE" value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchResponsavel">Responsável</label>
                            <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchDescricaoC">Descrição de Contenção 1</label>
                            <input type="text" id="searchDescricaoC" name="ver_contencao" placeholder="Max 250 Caracteres" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchDescricaoC2">Descrição de Contenção 2</label>
                            <input type="text" id="searchDescricaoC2" name="ver_contencao2" placeholder="Max 250 Caracteres" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchDescricaoC3">Descrição de Contenção 3</label>
                            <input type="text" id="searchDescricaoC3" name="ver_contencao3" placeholder="Max 250 Caracteres" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchQC">Necessita da validação Q.A?</label>
                            <div class="radio-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ver_qc" id="descricaoSim" value="SIM" required onclick="handleRadioClick(true);">
                                    <label class="form-check-label" for="descricaoSim">Sim</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ver_qc" id="descricaoNao" value="NAO" required onclick="handleRadioClick(false);">
                                    <label class="form-check-label" for="descricaoNao">Não</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="search-container" id="bpContencaoQA" style="display:none; width:700px">
                        <div class="input-group" style="display: flex; align-items: center;">
                            <div style="flex: 2; margin-right: 10px;">
                                <label for="searchBPcontQA">BP Contenção QA</label>
                                <input type="text" id="searchBPcontQA" name="ver_bp_contencao_qa" placeholder="Ponto de Corte">
                            </div>
                            <div style="flex: 2;">
                                <label for="searchDescricaocontQA">Descrição da Contenção QA</label>
                                <input type="text" id="searchDescricaocontQA" name="ver_bp_descricao_qa" placeholder="Max 250 caracteres">
                            </div>
                            <div style="flex: 2;">
                                <label for="searchResp_QA">Responsável QA</label>
                                <input type="text" id="searchResp_QA" name="ver_resp_qa" placeholder="Responsável pela Implementação">
                            </div>
                        </div>
                    </div>
                    <div class="search-container" id="bpContencaoMotivo" style="display:none; width:500px;">
                        <div class="input-group">
                            <label for="searchMotivo">Motivo</label>
                            <input type="text" id="searchMotivo" name="ver_motivo" placeholder="Motivo">
                        </div>
                    </div>
                    <div class="search-container">
                        <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                        <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                    </div>
                </cfoutput>
            </form>
        </div>
        <script src="/qualidade/relatorios/assets/script.js"></script>
    </body>
</html>
    