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
                DATA_BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#UCase(form.ver_bp)#" cfsqltype="CF_SQL_VARCHAR">,
                RESPONSAVEL_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_responsavel)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_descricao)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = 'CONCLUÍDO',
                BP_DEFINITIVO_QUALIDADE = <cfqueryparam value="#UCase(form.save_bp)#" cfsqltype="CF_SQL_VARCHAR">,
                DATA_BP_DEFINITIVO_QUALIDADE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
    
        <cflocation url="ver_agir.cfm">
    </cfif>


<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>DEFINITIVO - VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v5">
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
            <h2 style="color: gold; font-size:30px;">Ação de Contenção</h2>
                <div class="search-container">
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
                            <input type="text" id="descricao_contencao" name="descricao_contencao" placeholder="Responsável" value="#consulta_editar.descricao_contencao#">
                        </div>
                        <div class="input-group">
                            <label for="necessita_qualidade" style="color:red">Foi Necessário Ação da Qualidade?</label>
                            <input type="text" id="necessita_qualidade" name="necessita_qualidade" value="#consulta_editar.necessita_qualidade#">
                        </div>
                        <div class="input-group">
                            <label for="bp_contencao_qualidade" style="color:red">BP da Qualidade - Contenção (Se houver)</label>
                            <input type="text" id="bp_contencao_qualidade" name="bp_contencao_qualidade" value="#consulta_editar.bp_contencao_qualidade#">
                        </div>
                        <div class="input-group">
                            <label for="descricao_cont_qa" style="color:red">Descrição da Contenção QA (Se houver)</label>
                            <input type="text" id="descricao_cont_qa" name="descricao_cont_qa" value="#consulta_editar.descricao_cont_qa#">
                        </div>
                        <div class="input-group">
                            <label for="responsavel_qualidade" style="color:red">Responsável QA pela Contenção (Se houver)</label>
                            <input type="text" id="responsavel_qualidade" name="responsavel_qualidade" value="#consulta_editar.responsavel_qualidade#">
                        </div>
                    </div>
                </div>
            </cfoutput>
        </div>
        <div id="tableProcess" class="table-container Process">
            <h2 style="color: green; font-size:30px;">AÇÃO DEFINITIVA</h2>
            <form id="for-edit" method="POST">
                <cfoutput>
                    <div class="search-container">
                        <div hidden class="input-group">
                            <label for="searchData">Data da Validação</label>
                            <input readonly type="date" id="searchValidacao" name="data_validacao" value="#dateFormat(now(), 'yyyy-mm-dd')#">
                        </div>
                        <div class="input-group">
                            <label for="searchBP">Ponto de Corte Definitivo do Processo</label>
                            <input required type="text" id="searchBP" name="ver_bp"  value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="ver_responsavel">Responsável (Processo)</label>
                            <input required type="text" id="ver_responsavel" name="ver_responsavel"  value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchDescricao">Descrição Definitivo (Processo)</label>
                            <input required type="text" id="searchDescricao" name="ver_descricao" placeholder="Max 250 caracteres" value="" oninput="verificaCamposPreenchidos()">
                        </div>   
                        <div class="input-group">
                            <label for="save_bp">BP Definitivo (Qualidade)</label>
                            <input type="text" id="save_bp" name="save_bp">
                        </div>      
                        <div class="input-group">
                            <label for="searchStatus">STATUS</label>
                            <input readonly type="text" id="searchSTATUS" name="ver_status" placeholder="Status de Conclusão" value="">
                        </div>              
                        <script>
                            // Função para voltar
                            function voltar() {
                                // Redireciona para a página anterior
                                window.history.back(); // ou utilize: window.location.href = 'pagina-desejada.cfm'; para redirecionar a uma página específica
                                }
                            function verificaCamposPreenchidos() {
                                // Obtém os valores dos campos
                                var pontoCorte = document.getElementById("searchBP").value;
                                var responsavel = document.getElementById("ver_responsavel").value;
                                var descricao = document.getElementById("searchDescricao").value;
                                var statusField = document.getElementById("searchSTATUS");
                        
                                // Verifica se os campos estão preenchidos e exibe no console para debugging
                                console.log("Ponto de Corte:", pontoCorte);
                                console.log("Responsável:", responsavel);
                                console.log("Descrição:", descricao);
                        
                                if (pontoCorte.trim() !== "" && responsavel.trim() !== "" && descricao.trim() !== "") {
                                    statusField.value = "CONCLUÍDO"; // Define o status como "CONCLUÍDO"
                                    console.log("Status definido como: CONCLUÍDO");
                                } else {
                                    statusField.value = ""; // Deixa o status em branco
                                    console.log("Status definido como: em branco");
                                }
                            }
                        
                            // Adiciona event listener para os inputs
                            document.addEventListener('DOMContentLoaded', function() {
                                document.getElementById("searchBP").addEventListener('input', verificaCamposPreenchidos);
                                document.getElementById("searchResponsavel").addEventListener('input', verificaCamposPreenchidos);
                                document.getElementById("searchDescricao").addEventListener('input', verificaCamposPreenchidos);
                            });
                        </script>
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
    