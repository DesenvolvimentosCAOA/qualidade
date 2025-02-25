<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfif structKeyExists(form, "turno") and structKeyExists(form, "fai") >
        <cfquery name="obterMaxID" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID),0) + 1 AS ID FROM INTCOLDFUSION.PRESENCA_VER_E_AGIR
        </cfquery>
        <cfquery name="insere" datasource="#BANCOSINC#">
            INSERT INTO INTCOLDFUSION.PRESENCA_VER_E_AGIR (ID, DATA, TURNO, AREA, GERENCIA, SUPERVISOR, LIDERANCA,
            TECNICO, ENGENHEIRO, SUPORTE_BODY, SUPORTE_PAINT, SUPORTE_SMALL, SUPORTE_FA, SUPORTE_FAI, SUPORTE_SQE, SUPORTE_LOGISTICA, OBSERVACAO,
            LIDER_BODY_SOLDAGEM, LIDER_BODY_LOGISTICA, LIDER_BODY_METAL, LIDER_PAINT_PREPARACAO, LIDER_PAINT_FINALIZACAO, LIDER_FA_T, LIDER_FA_C, LIDER_FA_F, LIDER_FAI_PINTURA, LIDER_FAI_ELETRICO)
            VALUES(
                <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                <cfqueryparam value="#form.turno#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.area#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.gerencia#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.supervisor#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.lideranca#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.tecnico#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.engenheiro#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.body#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.paint#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.small#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.fa#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.fai#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.sqe#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.log#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.observacoes#" cfsqltype="cf_sql_varchar">,
            <!--- Usando NULL quando o campo não estiver presente --->
            <cfqueryparam value="#(isDefined('form.soldagem') ? form.soldagem : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.soldagem')#">,
            <cfqueryparam value="#(isDefined('form.logistica') ? form.logistica : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.logistica')#">,
            <cfqueryparam value="#(isDefined('form.metalfinish') ? form.metalfinish : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.metalfinish')#">,
            <cfqueryparam value="#(isDefined('form.preparacaoP') ? form.preparacaoP : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.preparacaoP')#">,
            <cfqueryparam value="#(isDefined('form.finalizacaoP') ? form.finalizacaoP : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.finalizacaoP')#">,
            <cfqueryparam value="#(isDefined('form.lider_t') ? form.lider_t : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.lider_t')#">,
            <cfqueryparam value="#(isDefined('form.lider_c') ? form.lider_c : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.lider_c')#">,
            <cfqueryparam value="#(isDefined('form.lider_f') ? form.lider_f : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.lider_f')#">,
            <cfqueryparam value="#(isDefined('form.pintura') ? form.pintura : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.pintura')#">,
            <cfqueryparam value="#(isDefined('form.eletrico') ? form.eletrico : '')#" cfsqltype="cf_sql_varchar" null="#not isDefined('form.eletrico')#">
            )
        </cfquery>        
    </cfif>

<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_shop.css">
        <title>Presença Ver & Agir</title>
        
        <style>
            /* Estilo geral */
            body {
                font-family: 'Arial', sans-serif;
                background: url('./assets/tiggo8.webp') no-repeat center center fixed;
                background-size: cover;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }
    
            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: -1;
            }
    
            .form-container {
                background-color: #fff;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                max-width: 600px;
                width: 100%;
            }
    
            .form-container h2 {
                font-size: 1.8rem;
                color: #333;
                text-align: center;
                margin-bottom: 10px;
            }
    
            .form-container p {
                font-size: 1rem;
                color: #666;
                text-align: center;
                margin-bottom: 30px;
            }
    
            .form-group {
                margin-bottom: 25px;
            }
    
            .form-group label {
                display: block;
                font-size: 1rem;
                color: #444;
                font-weight: bold;
                margin-bottom: 10px;
            }
    
            .radio-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
    
            .radio-input {
                display: flex;
                align-items: center;
                gap: 10px;
            }
    
            .radio-input input {
                appearance: none;
                width: 20px;
                height: 20px;
                border: 2px solid #666;
                border-radius: 50%;
                background-color: #fff;
                cursor: pointer;
                transition: all 0.3s ease;
            }
    
            .radio-input input:checked {
                background-color: #4285f4;
                border-color: #4285f4;
            }
    
            .radio-input span {
                font-size: 1rem;
                color: #444;
            }
    
            .submit-btn {
                display: block;
                width: 100%;
                padding: 12px;
                background-color: #4285f4;
                color: #fff;
                font-size: 1rem;
                font-weight: bold;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-align: center;
                transition: background-color 0.3s ease;
            }
    
            .submit-btn:hover {
                background-color: #357ae8;
            }
        </style>
    </head>
    <body>
    <header class="titulo" style="margin-bottom:10vw;">
        <cfinclude template="auxi/nav_links.cfm">
    </header>
    <div id="loading-screen">
        <div class="spinner"></div>
    </div>
    <div class="form-container">
        <div class="form-container">
            <h2>FORMULÁRIO DE PRESENÇA - VER E AGIR</h2>
            <p>FORMULÁRIO PARA CONTROLE DE PRESENÇA NAS REUNIÕES DE VER E AGIR</p>
            <form method="post">
                <div class="form-group">
                    <label>1. TURNO *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="turno1" name="turno" value="1º TURNO">
                            <span>1º</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="turno2" name="turno" value="2º TURNO">
                            <span>2º</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="turno3" name="turno" value="3º TURNO">
                            <span>3º</span>
                        </div>
                    </div>
                </div>
                <!-- ÁREA -->
                <div class="form-group">
                    <label>2. ÁREA *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="area-body" name="area" value="BODY" onclick="showOptions('BODY')">
                            <span>BODY</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="area-paint" name="area" value="PAINT" onclick="showOptions('PAINT')">
                            <span>PAINT</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="area-small" name="area" value="SMALL" onclick="hideOptions()">
                            <span>SMALL</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="area-fa" name="area" value="FA" onclick="showOptions('FA')">
                            <span>FA</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="area-fai" name="area" value="FAI" onclick="showOptions('FAI')">
                            <span>FAI</span>
                        </div>
                    </div>
                </div>
                <!-- PRESENÇA DA GERÊNCIA -->
                <div class="form-group">
                    <label>3. PRESENÇA DA GERÊNCIA *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="gerencia-sim" name="gerencia" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="gerencia-nao" name="gerencia" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- PRESENÇA DA SUPERVISÃO -->
                <div class="form-group">
                    <label>4. PRESENÇA DA SUPERVISÃO *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="supervisor-sim" name="supervisor" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="supervisor-nao" name="supervisor" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- PRESENÇA DA LIDERANÇA -->
                <div class="form-group" id="lideranca-group">
                    <label>5. PRESENÇA DA LIDERANÇA *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="lideranca-sim" name="lideranca" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="lideranca-nao" name="lideranca" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="options-body" class="checkbox-group" style="display:none;">
                    <label>Opções para BODY</label>
                    <input type="radio" id="soldagem" name="soldagem" value="Soldagem">Soldagem<br>
                    <input type="radio" id="logistica" name="logistica" value="Logística">Logística<br>
                    <input type="radio" id="metalfinish" name="metalfinish" value="Metal Finish">Metal Finish<br>
                </div>
                
                <div class="form-group" id="options-paint" class="checkbox-group" style="display:none;">
                    <label>Opções para PAINT</label>
                    <input type="radio" id="preparacaoP" name="preparacaoP" value="Preparação"> Preparação e Banhos<br>
                    <input type="radio" id="finalizacaoP" name="finalizacaoP" value="Finalização"> Finalização<br>
                </div>
                
                <div class="form-group" id="options-fa" class="checkbox-group" style="display:none;">
                    <label>Opções para FA</label>
                    <input type="radio" id="lider_t" name="lider_t" value="LINHA T"> Linha T<br>
                    <input type="radio" id="lider_c" name="lider_c" value="LINHA C"> Linha C<br>
                    <input type="radio" id="lider_f" name="lider_f" value="LINHA F"> Linha F<br>
                </div>
                
                <div class="form-group" id="options-fai" class="checkbox-group" style="display:none;">
                    <label>Opções para FAI</label>
                    <input type="radio" id="pintura" name="pintura" value="Pintura"> Pintura Funilaria Montagem<br>
                    <input type="radio" id="eletrico" name="eletrico" value="Elétrico"> Elétrico Shower Pista Alinhamento<br>
                    <input type="radio" id="linhat" name="linhat" value="Linha T">Linha T<br>
                    <input type="radio" id="linhac" name="linhac" value="Linha C">Linha C<br>
                    <input type="radio" id="linhaf" name="linhaf" value="Linha F">Linha F<br>
                </div>
                <!-- PRESENÇA DO TÉCNICO -->
                <div class="form-group">
                    <label>6. PRESENÇA DO TÉCNICO *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="tecnico-sim" name="tecnico" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="tecnico-nao" name="tecnico" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- PRESENÇA DO ENGENHEIRO -->
                <div class="form-group">
                    <label>7. PRESENÇA DO ENGENHEIRO *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="engenheiro-sim" name="engenheiro" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="engenheiro-nao" name="engenheiro" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE BODY -->
                <div class="form-group">
                    <label>8. SUPORTE BODY *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="body-sim" name="body" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="body-nao" name="body" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE PAINT -->
                <div class="form-group">
                    <label>9. SUPORTE PAINT *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="paint-sim" name="paint" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="paint-nao" name="paint" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE SMALL -->
                <div class="form-group">
                    <label>10. SUPORTE SMALL *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="small-sim" name="small" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="small-nao" name="small" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE FA -->
                <div class="form-group">
                    <label>11. SUPORTE FA *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="fa-sim" name="fa" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="fa-nao" name="fa" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE FAI -->
                <div class="form-group">
                    <label>12. SUPORTE FAI *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="fai-sim" name="fai" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="fai-nao" name="fai" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE SQE -->
                <div class="form-group">
                    <label>13. SUPORTE SQE *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="sqe-sim" name="sqe" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="sqe-nao" name="sqe" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- SUPORTE LOGISTICA -->
                <div class="form-group">
                    <label>14. SUPORTE LOGÍSTICA *</label>
                    <div class="radio-group">
                        <div class="radio-input">
                            <input type="radio" id="log-sim" name="log" value="SIM">
                            <span>SIM</span>
                        </div>
                        <div class="radio-input">
                            <input type="radio" id="log-nao" name="log" value="NÃO">
                            <span>NÃO</span>
                        </div>
                    </div>
                </div>
                <!-- OBSERVAÇÕES -->
                <div class="form-group">
                    <label for="observacoes">15. OBSERVAÇÕES</label>
                    <textarea id="observacoes" name="observacoes" rows="4" placeholder="Max. 250 caracteres..." style="width: 100%; padding: 10px; font-size: 1rem; border: 1px solid #ccc; border-radius: 5px;"></textarea>
                </div>

                <!-- Botão de envio -->
                <button type="submit" class="submit-btn">Enviar</button>
            </form>
        </div>
        <script>
            function showOptions(area) {
                // Esconde todas as opções
                hideOptions();

                // Exibe as opções específicas da área selecionada
                if (area === 'BODY') {
                    document.getElementById('options-body').style.display = 'block';
                } else if (area === 'PAINT') {
                    document.getElementById('options-paint').style.display = 'block';
                } else if (area === 'FA') {
                    document.getElementById('options-fa').style.display = 'block';
                } else if (area === 'FAI') {
                    document.getElementById('options-fai').style.display = 'block';
                }
            }

            function hideOptions() {
                document.getElementById('options-body').style.display = 'none';
                document.getElementById('options-paint').style.display = 'none';
                document.getElementById('options-fa').style.display = 'none';
                document.getElementById('options-fai').style.display = 'none';
            }
        </script>
        <script src="/qualidade/relatorios/assets/script.js"></script>
    </body>
</html>
            