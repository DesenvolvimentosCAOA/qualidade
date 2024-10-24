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
                RESPONSAVEL_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_responsavel)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_descricao)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = <cfqueryparam value="#form.ver_status#" cfsqltype="CF_SQL_VARCHAR" >
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
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v4">        
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    
        <div id="tableBody" class="table-container">
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
                        <div class="search-container">
                            <div class="input-group">
                                <label for="searchData">Data de Contenção</label>
                                <input readonly required type="text" id="searchData" name="ver_data" value="#dateFormat(consulta_editar.data_bp_processo, 'dd/mm/yyyy')#">
                            </div>                            
                        </div>
                        <div class="input-group">
                            <label for="searchData">BP de Contenção</label>
                            <input readonly required type="text" id="searchData" name="ver_data" value="#consulta_editar.bp_contencao_processo#">
                        </div> 
                    </div>
                    <div class="input-group">
                        <label for="searchData">Descrição de Contenção</label>
                        <input style="width: 500px" readonly required type="text" id="searchData" name="ver_data" value="#consulta_editar.descricao_contencao#">
                    </div> 
                </div>
                <div class="search-container">
                    <div class="input-group" id="containerBPContencao" style="width:20vw;">
                        <label for="searchBPQA">BP de Contenção Q.A</label>
                        <input readonly type="text" id="searchBPQA" name="ver_data" value="#consulta_editar.bp_contencao_qualidade#">
                    </div>
                    <div class="input-group" id="containerDescricaoContencao" style="width:30vw;">
                        <label for="searchDescricaoQA">Descrição de Contenção Q.A</label>
                        <input readonly type="text" id="searchDescricaoQA" name="ver_data" value="#consulta_editar.DESCRICAO_CONT_QA#">
                    </div>
                </div>
                
        </div>
            </cfoutput>

        <div id="tableProcess" class="table-container Process">
            <h2 style="color: green; font-size:30px;">AÇÃO DEFINITIVA</h2>
            <form id="for-edit" method="POST">
                <cfoutput>
                    <div class="search-container">
                        <div hidden class="input-group">
                            <label for="searchData">Data da Validação</label>
                            <input readonly type="date" id="searchValidacao" name="data_validacao" placeholder="Data da validação" value="#dateFormat(now(), 'yyyy-mm-dd')#">
                        </div>
                        <div class="input-group">
                            <label for="searchStatus">STATUS</label>
                            <input readonly type="text" id="searchSTATUS" name="ver_status" placeholder="Status de Conclusão" value="">
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
                            <label for="searchDescricao">Descrição</label>
                            <input required type="text" id="searchDescricao" name="ver_descricao" placeholder="Max 250 caracteres" value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        
                        <script>
                            function verificaCamposPreenchidos() {
                                // Obtém os valores dos campos
                                var pontoCorte = document.getElementById("searchBP").value;
                                var responsavel = document.getElementById("searchResponsavel").value;
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
                        <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                    </div>
                </cfoutput>
            </form>
        </div>
    </body>
    </html>
    