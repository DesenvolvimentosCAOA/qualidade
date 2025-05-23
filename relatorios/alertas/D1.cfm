<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

<cfif structKeyExists(form, "n_controle")>
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.ALERTAS_8D
    </cfquery>

    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = '#cookie.user_apontamento_fa#'
    </cfquery>

    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.ALERTAS_8D (ID, DATA_REGISTRO, N_CONTROLE, DATA_OCORRENCIA, BARREIRA, 
        RESP_ABERTURA, VIN, PECA, POSICAO, PROBLEMA, DESCRICAO_NC, STATUS, MODELO, SETOR_RESPONSAVEL, CRITICIDADE,
        HISTORICO, QUANTIDADE
        )
        VALUES(
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
            <cfqueryparam value="#form.n_controle#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.data_ocorrencia#" cfsqltype="CF_SQL_TIMESTAMP">,
            <cfqueryparam value="#UCase(form.barreira)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(login.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.peca)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.posicao)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.problema)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.descricao)#" cfsqltype="CF_SQL_CLOB">,
            <cfqueryparam value="#UCase('D1-D2')#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.modelo)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.setor)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(form.criticidade)#" cfsqltype="CF_SQL_CLOB">,
            <cfqueryparam value="#UCase(form.historico)#" cfsqltype="CF_SQL_CLOB">,
            <cfqueryparam value="#UCase(form.quantidade)#" cfsqltype="CF_SQL_NUMERIC">
        )
    </cfquery>
    <cflocation url="d_principal.cfm">

</cfif>
    
<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <title>Formulário 8D</title>
        <style>
            @font-face {
            font-family: 'Bahnschrift Regular';
            src: url('bahnschrift-regular.ttf') format('truetype');
            }

            body, textarea {
                font-family: 'Bahnschrift Regular', Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f5f5;
            }
    
            .form-container {
                width: 90%;
                margin: 20px auto;
                background-color: #fff;
                border: 1px solid #000;
                border-collapse: collapse;
            }
    
            .form-container table {
                width: 100%;
                border-collapse: collapse;
            }
    
            .form-container th, .form-container td {
                border: 1px solid #000;
                text-align: left;
                padding: 5px;
            }
    
            .header {
                text-align: center;
                font-weight: bold;
                font-size: 18px;
            }
    
            .logo {
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .logo img {
                width: 100px;
                height: 100px;
            }
    
            .row-span {
                height: 50px;
            }
    
            .dashed {
                border-style: dashed;
            }
    
            .label-bold {
                font-weight: bold;
            }
    
            input, select, textarea {
                width: 100%;
                box-sizing: border-box;
                border: none;
            }
            input:focus {
                border:none;
                outline:none;
            }
            select {
                border: none;
                outline: none;
                -webkit-appearance: none; /* Para remover bordas no Safari */
                -moz-appearance: none;    /* Para remover bordas no Firefox */
                appearance: none;         /* Para remover bordas em navegadores modernos */
            }
            #btnSalvarEdicao {
                background-color: #4CAF50;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                border-radius: 12px;
                transition: background-color 0.3s;
            }

            /* Efeito ao passar o mouse */
            #btnSalvarEdicao:hover {
                background-color: #00FA9A; /* Cor de fundo ao passar o mouse */
            }

            #btnback {
                background-color: red;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                border-radius: 12px;
                transition: background-color 0.3s;
            }

            /* Efeito ao passar o mouse */
            #btnback:hover {
                background-color: #8B0000; /* Cor de fundo ao passar o mouse */
            }
        </style>
    </head>        
        <body>
            <header class="titulo">
                <cfinclude template="/qualidade/relatorios/auxi/nav_links.cfm">
            </header>
    
            <div id="tableBody" class="table-container" style="margin-top:100px;">                
                <div class="form-container">
                    <form method="POST">
                        <cfoutput>
                            <cfquery name="login" datasource="#BANCOSINC#">
                                SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                                WHERE USER_NAME = '#cookie.user_apontamento_fa#'
                            </cfquery>
                            <table>
                                <tr>
                                    <td class="logo">
                                        <img src="/qualidade/relatorios/img/Logo_Caoa.webp" alt="Logo CAOA">
                                    </td>
                                    <td class="header" colspan="9" style="text-align:center;font-size:40px; color:red;">
                                        8D - ALERTA DE QUALIDADE
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2" style="text-align:center; font-size:30px;background-color:lightgrey;">D1</td>
                                    <td class="label-bold" colspan="1" style="background-color:lightgrey;text-align:center;">Nº DE CONTROLE:</td>
                                    <td class="label-bold" colspan="3" style="background-color:lightgrey;text-align:center;">RESPONSÁVEL PELA ABERTURA DO ALERTA:</td>
                                    <td class="label-bold" colspan="2" style="background-color:lightgrey;text-align:center;">SETOR RESPONSÁVEL:</td>
                                    <td class="label-bold" colspan="2" style="background-color:lightgrey;text-align:center;">DATA DA OCORRÊNCIA:</td>
                                </tr>
                                <cfquery name="obterMaxId" datasource="#BANCOSINC#">
                                    SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.ALERTAS_8D
                                </cfquery>
                                <th colspan="1" style="background-color:lightgrey;">
                                    <input type="text" name="n_controle" style="background-color:lightgrey; text-align:center;" value="#obterMaxId.id#-25" readonly>
                                </th>

                                <th colspan="3" style="background-color:lightgrey;text-align:center;">
                                    <input type="text" name="responsavel_abertura" style="background-color:lightgrey;text-align:center;" value="#login.USER_SIGN#" readonly required>
                                </th>
                                <th colspan="2" style="background-color:lightgrey; text-align:center;">
                                    <input type="text" name="setor" id="setor" list="setores" placeholder="Setor" required style="background-color:lightgrey; text-align:center;" oninput="validarSetor(this)" title="Digite um setor válido">
                                    <datalist id="setores">
                                        <option value="LOGISTICA"></option>
                                        <option value="BODY SHOP"></option>
                                        <option value="PAINT SHOP"></option>
                                        <option value="SMALL PARTS"></option>
                                        <option value="FINAL ASSEMBLY"></option>
                                        <option value="FAI"></option>
                                        <option value="PDI"></option>
                                    </datalist>
                                </th>
                                <th colspan="2" style="background-color:lightgrey;">
                                    <input type="date" name="data_ocorrencia" style="background-color:lightgrey;" required>
                                </th>

                                <tr>
                                    <td rowspan="5" style="text-align:center; font-size:30px;">D2</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">BARREIRA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">MODELO:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">VIN/BARCODE:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">PEÇA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">POSIÇÃO:</td>
                                    <td class="label-bold" colspan="2" style="text-align:center;">PROBLEMA:</td>
                                </tr>
                                <th colspan="1" style="text-align:center;">
                                    <select type="text" name="barreira" style="text-align:center;" required>
                                        <option value="">Selecione</option>
                                        <option value="BODY">BODY</option>
                                        <option value="PAINT">PAINT</option>
                                        <option value="SMALL">SMALL</option>
                                        <option value="FA">FA</option>
                                        <option value="FAI">FAI</option>
                                        <option value="PDI">PDI</option>
                                    </select>
                                </th>

                                <script>
                                    function validarSetor(input) {
                                        let valor = input.value;
                                        let lista = document.getElementById("setores").getElementsByTagName("option"); // Forma segura para CFML
                                        let valido = false;
                                
                                        for (let i = 0; i < lista.length; i++) {
                                            if (lista[i].value === valor) {
                                                valido = true;
                                                break;
                                            }
                                        }
                                
                                        if (!valido) {
                                            input.setCustomValidity("Digite um setor válido");
                                            input.reportValidity();
                                        } else {
                                            input.setCustomValidity("");
                                        }
                                    }
                                </script>

                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="modelo" id="modelo" list="modelos" placeholder="Modelo" required style="text-align:center;" oninput="validarModelo(this)" title="Digite um modelo válido">
                                    <datalist id="modelos">
                                        <option value="T19"></option>
                                        <option value="T1E"></option>
                                        <option value="T18"></option>
                                        <option value="T1A"></option>
                                        <option value="HR"></option>
                                        <option value="TL"></option>
                                    </datalist>
                                </th>
                                <script>
                                    function validarModelo(input) {
                                        let valor = input.value;
                                        let lista = document.getElementById("modelos").getElementsByTagName("option"); // Forma segura para CFML
                                        let valido = false;
                                
                                        for (let i = 0; i < lista.length; i++) {
                                            if (lista[i].value === valor) {
                                                valido = true;
                                                break;
                                            }
                                        }
                                
                                        if (!valido) {
                                            input.setCustomValidity("Digite um modelo válido");
                                            input.reportValidity();
                                        } else {
                                            input.setCustomValidity("");
                                        }
                                    }
                                </script>
                                
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="vin" placeholder="Vin/Barcode" style="text-align:center;" required>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="peca" placeholder="Peça" style="text-align:center;" required>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="posicao" placeholder="Posição" style="text-align:center;" required>
                                </th>
                                <th colspan="2" style="text-align:center;">
                                    <input type="text" name="problema" placeholder="Problema" style="text-align:center;" required>
                                </th>                            
                                <tr>
                                    <td class="label-bold" colspan="1">DESCRIÇÃO DA NÃO CONFORMIDADE:</td>
                                    <td colspan="8">
                                        <textarea name="descricao" placeholder="DESCREVA DETALHADAMENTE A NÃO CONFORMIDADE" required style="width: 100%; height: 100px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label-bold" colspan="1" style="text-align:center;">QTD OCORRÊNCIA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">CRITICIDADE:</td>
                                    <td class="label-bold" colspan="6" style="text-align:center;">HISTÓRICO DE TRATATIVA:</td>
                                </tr>
                                <th colspan="1">
                                    <input type="text" name="quantidade" required>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <select type="text" name="criticidade" style="text-align:center;" required>
                                        <option value="">Selecione</option>
                                        <option value="N1">N1</option>
                                        <option value="N2">N2</option>
                                        <option value="N3">N3</option>
                                        <option value="N4">N4</option>
                                    </select>
                                </th>
                                <th colspan="6" style="text-align:center;">
                                    <select type="text" name="historico" style="text-align:center;" required>
                                        <option value="">Selecione</option>
                                        <option value="PRIMEIRA NOTIFICAÇÃO">PRIMEIRA NOTIFICAÇÃO</option>
                                        <option value="REINCIDÊNCIA DE ALERTA">REINCIDÊNCIA DE ALERTA</option>
                                        <option value="TRATADO VIA VER & AGIR">TRATADO VIA VER & AGIR</option>
                                    </select>
                                </th>
                            </table>
                            <div style="text-align:center">
                                <button type="button" class="btn-rounded back-btn" id="btnback" onclick="window.location.href = 'd_principal.cfm';">Voltar</button>
                                <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                            </div>
                        </cfoutput>
                    </form>
                </div>
            </div>
            <script>
                // Função para voltar
                function voltar() {
                    // Redireciona para a página anterior
                    window.history.back(); // ou utilize: window.location.href = 'pagina-desejada.cfm'; para redirecionar a uma página específica
                }
            </script>
        </body>
</html>
    