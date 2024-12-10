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
                DATA_BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#dateFormat(form.data_validacao, 'yyyy-mm-dd')#" cfsqltype="CF_SQL_DATE">,
                BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#UCase(form.ver_bp)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = <cfqueryparam value="#form.ver_status#" cfsqltype="CF_SQL_VARCHAR">,
                NECESSITA_QUALIDADE = <cfqueryparam value="#form.ver_qc#" cfsqltype="CF_SQL_VARCHAR"> <!--- Aqui é onde o valor do rádio será salvo --->
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        
        <cflocation url="ver_agir.cfm">
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
        
            <div id="tableProcess" class="table-container Process">
                <h2 style="color: yellow; font-size:30px;">AÇÃO DE CONTENÇÃO</h2>
                        <div class="search-container">
                            <div class="input-group">
                                <label for="searchData">Data da Implementação</label>
                                <input readonly type="date" id="searchValidacao" name="data_validacao" placeholder="Data da validação" value="#DateFormat(consulta_editar.data_bp_processo, 'yyyy-mm-dd')#">
                            </div>
                                                  
                            <div class="input-group">
                                <label for="searchBP">Ponto de Corte</label>
                                <input required type="text" id="searchBP" name="ver_bp" placeholder="BP - VIN/BARCODE" value="#consulta_editar.bp_contencao_processo#">
                            </div>
                            <div class="input-group">
                                <label for="searchResponsavel">Responsável pela Contenção</label>
                                <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="#consulta_editar.grupo_responsavel#">
                            </div>
                            <div class="input-group">
                                <label for="searchResponsavel">O que foi feito?</label>
                                <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="#consulta_editar.descricao_contencao#">
                            </div>
                            <div class="input-group">
                                <label for="searchqc">Foi Necessário BP da Qualidade?</label>
                                <input required type="text" id="searchqc" name="ver_qc" value="#consulta_editar.necessita_qualidade#">
                            </div>
                            <div class="input-group">
                                <label for="searchqc">BP da Qualidade - Contenção</label>
                                <input required type="text" id="searchqc" name="ver_qc" value="#consulta_editar.bp_contencao_qualidade#">
                            </div>
                            <div class="input-group">
                                <label for="searchqc">Descrição da Contenção</label>
                                <input required type="text" id="searchqc" name="ver_qc" value="#consulta_editar.descricao_cont_qa#">
                            </div>
                            <div class="input-group">
                                <label for="searchqc">Responsável QA pela Contenção</label>
                                <input required type="text" id="searchqc" name="ver_qc" value="#consulta_editar.responsavel_qualidade#">
                            </div>
                        </div>
            </div>

            <div id="tableProcess" class="table-container Process">
                <h2 style="color: green; font-size:30px;">AÇÃO DEFINITIVA</h2>
                        <div class="search-container">
                            <div class="input-group">
                                <label for="searchData">Data da Implementação</label>
                                <input readonly type="date" id="searchValidacao" name="data_validacao" placeholder="Data da validação" value="#DateFormat(consulta_editar.data_bp_definitivo_processo, 'yyyy-mm-dd')#">
                            </div>
                                                  
                            <div class="input-group">
                                <label for="searchBP">Ponto de Corte</label>
                                <input required type="text" id="searchBP" name="ver_bp" placeholder="BP - VIN/BARCODE" value="#consulta_editar.bp_definitivo_processo#">
                            </div>
                            <div class="input-group">
                                <label for="searchResponsavel">O que foi feito?</label>
                                <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="#consulta_editar.descricao_definitivo#">
                            </div>
                            <div class="input-group">
                                <label for="searchResponsavel">Responsável pela implementação</label>
                                <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="#consulta_editar.responsavel_definitivo#">
                            </div>
                            <div class="input-group">
                                <label for="searchResponsavel">Status de Conclusão</label>
                                <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="#consulta_editar.status#">
                            </div>
                        </div>
                        <div class="search-container">
                            <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                            <button type="button" onclick="self.location='auxi/email_qa.cfm'" form="form_meta" class="btn-rounded back-btn" id="btnVoltar">Enviar e-mail</button>
                            <script>
                                function voltar() {
                                        // Redireciona para a página anterior
                                        window.history.back(); // ou utilize: window.location.href = 'pagina-desejada.cfm'; para redirecionar a uma página específica
                                    }
                            </script>
                        </div>
            </div>
                </cfoutput>
    </body>
</html>
        