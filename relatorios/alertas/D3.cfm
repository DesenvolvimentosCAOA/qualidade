<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfif isDefined("url.id_editar")>
        <cfquery name="consulta_editar" datasource="#BANCOSINC#">
            SELECT * 
            FROM INTCOLDFUSION.ALERTAS_8D
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
            ORDER BY ID DESC
        </cfquery>
    </cfif>

    <cfif isDefined("form.acao_contencao") and form.acao_contencao neq "">
        <cfquery name="atualiza" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.ALERTAS_8D
            SET              
                ACAO_CONTENCAO = <cfqueryparam value="#UCase(form.acao_contencao)#" cfsqltype="CF_SQL_CLOB">,
                DATA_ACAO_CONTENCAO = <cfqueryparam value="#form.data_acao_contencao#" cfsqltype="CF_SQL_TIMESTAMP">,
                RESPONSAVEL_ACAO_CONTENCAO = <cfqueryparam value="#UCase(form.responsavel_acao_contencao)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = 'D3',
                DATA_RESPOSTA = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cflocation url="d_principal.cfm">
    </cfif>
    
    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = '#cookie.user_apontamento_fa#'
    </cfquery>

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

            .folder-content {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                padding: 20px;
            }

            .folder-content ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
            }

            .folder-content li {
                text-align: center;
                max-width: 120px;
                margin-bottom: 20px;
            }

            .folder-content img {
                width: 100px;
                height: auto;
                border-radius: 4px;
                transition: transform 0.3s ease-in-out;
                cursor: pointer;
            }

            .folder-content img:hover {
                transform: scale(1.1);
            }

            .folder-content a {
                display: block;
                margin-top: 10px;
                text-decoration: none;
                font-size: 14px;
                color: #333;
                transition: color 0.3s;
            }

            .folder-content a:hover {
                color: #007bff;
            }

        </style>
    </head>        
        <body>
            <header class="titulo">
                <cfinclude template="/qualidade/relatorios/auxi/nav_links.cfm">
            </header>
    
            <div id="tableBody" class="table-container" style="margin-top:100px;">                
                <div class="form-container">
                        <cfoutput>
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
                                    <input type="text" name="n_controle" style="background-color:lightgrey; text-align:center;" value="#consulta_editar.n_controle#" readonly>
                                </th>

                                <th colspan="3" style="background-color:lightgrey;text-align:center;">
                                    <input type="text" name="responsavel_abertura" style="background-color:lightgrey;text-align:center;" value="#consulta_editar.resp_abertura#" readonly required>
                                </th>
                                <th colspan="2" style="background-color:lightgrey; text-align:center;">
                                    <input type="text" name="setor" id="setor" list="setores" style="background-color:lightgrey; text-align:center;" value="#consulta_editar.setor_responsavel#">
                                </th>
                                <th colspan="2" style="background-color:lightgrey;">
                                    <input style="background-color:lightgrey; text-align:center;"  type="text" name="data_ocorrencia" value="#DateFormat(consulta_editar.data_ocorrencia, 'dd/mm/yyyy')#" readonly>
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
                                    <input type="text" name="barreira" id="barreira" list="barreiras" style="text-align:center;" value="#consulta_editar.barreira#">
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
                                    <input type="text" name="modelo" id="modelo" style="text-align:center;" value="#consulta_editar.modelo#" readonly>
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
                                    <input type="text" name="vin" placeholder="Vin/Barcode" style="text-align:center;" value="#consulta_editar.vin#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="peca" placeholder="Peça" style="text-align:center;" value="#consulta_editar.peca#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="posicao" placeholder="Posição" style="text-align:center;" value="#consulta_editar.posicao#" readonly>
                                </th>
                                <th colspan="2" style="text-align:center;">
                                    <input type="text" name="problema" placeholder="Problema" style="text-align:center;" value="#consulta_editar.problema#" readonly>
                                </th>                            
                                <tr>
                                    <td class="label-bold" colspan="1">DESCRIÇÃO DA NÃO CONFORMIDADE:</td>
                                    <td colspan="8">
                                        <textarea name="descricao" placeholder="DESCREVA DETALHADAMENTE A NÃO CONFORMIDADE" required style="width: 100%; height: 100px;">#consulta_editar.descricao_nc#</textarea>
                                    </td>
                                </tr>   
                                <tr>
                                    <td class="label-bold" colspan="1" style="text-align:center;">QTD OCORRÊNCIA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">CRITICIDADE:</td>
                                    <td class="label-bold" colspan="6" style="text-align:center;">HISTÓRICO DE TRATATIVA:</td>
                                </tr>
                                <th colspan="1">
                                    <input type="text" name="qtd_ocorrencia" value="#consulta_editar.quantidade#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="criticidade" value="#consulta_editar.criticidade#" readonly>
                                </th>
                                <th colspan="6" style="text-align:center;">
                                    <input type="text" name="historico" value="#consulta_editar.historico#" readonly>
                                </th>
                                <form method="POST">
                                    <tr>
                                        <td rowspan="3" colspan="1" style="text-align:center; font-size:30px; background-color:lightgrey;">D3</td>
                                        <td class="label-bold" colspan="1" style="background-color:lightgrey;">AÇÃO DE CONTENÇÃO:</td>
                                        <td colspan="8" style="background-color:lightgrey;">
                                            <textarea name="acao_contencao" placeholder="DESCREVA A AÇÃO DE CONTENÇÃO REALIZADA" 
                                                style="background-color:lightgrey; width: 100%; height: 100px; resize: vertical;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label-bold" colspan="4" style="text-align:center;background-color:lightgrey;">RESPONSÁVEL PELA AÇÃO DE CONTENÇÃO:</td>
                                        <td class="label-bold" colspan="3" style="text-align:center;background-color:lightgrey;">DATA DA AÇÃO DE CONTENÇÃO:</td>
                                    </tr>
                                    <th colspan="4" style="text-align:center;background-color:lightgrey;">
                                        <input readonly type="text" name="responsavel_acao_contencao" style="text-align:center;background-color:lightgrey;" value="#login.user_sign#">
                                    </th>
                                    
                                    <th colspan="3" style="text-align:center;background-color:lightgrey;">
                                        <input type="date" name="data_acao_contencao" style="text-align:center;background-color:lightgrey;" required>
                                    </th>
                            </table>
                                    <button type="button" class="btn-rounded back-btn" id="btnback" onclick="window.location.href = 'd_principal.cfm';">Voltar</button>
                                    <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                                </form>
                    </cfoutput>
                </div>
            </div>
            
            <cfscript>
                // Caminho do diretório
                directoryPath = "E:/arquivo_foto/";
            
                // Obter a lista de pastas
                folderList = directoryList(directoryPath, true, "directory");
            
                // Recupera o parâmetro da URL id_nc
                idNc = url.id_nc;
            
                // Gerar o código HTML para a tabela
                htmlTable = "<style>
                                table { width: 100%; border-collapse: collapse; }
                                th, td { border: 1px solid black; padding: 8px; text-align: center; }
                             </style>";
                htmlTable &= "<table id='dataTable'>";
                htmlTable &= "<tr><th>ID</th><th>N CONTROLE</th><th>Ação</th></tr>";
            
                for (folder in folderList) {
                    folderName = listLast(folder, "\");
            
                    // Verifica se a pasta corresponde ao id_nc
                    if (folderName == idNc) {
                        // Consulta ao banco de dados para buscar os dados da tabela ALERTAS_8D
                        query = new Query();
                        query.setDatasource("#BANCOSINC#");
                        query.setSQL("SELECT ID, N_CONTROLE FROM ALERTAS_8D WHERE N_CONTROLE = :idNc");
                        query.addParam(name="idNc", value=folderName, cfsqltype="cf_sql_varchar");
                        result = query.execute().getResult();
            
                        if (result.recordCount > 0) {
                            htmlTable &= "<tr>";
                            htmlTable &= "<td>" & result.ID & "</td>";
                            
                            // Verifica se o N_CONTROLE está vazio ou nulo e coloca "Falta Lançamento"
                            caixaValue = (len(trim(result.N_CONTROLE)) == 0 or isNull(result.N_CONTROLE)) ? "Falta Lançamento" : result.N_CONTROLE;
                            
                            htmlTable &= "<td>" & caixaValue & "</td>";
                            htmlTable &= "<td><a href='downloadFolder.cfm?id_nc=" & folderName & "'>Baixar Pasta</a>";
                            htmlTable &= "</tr>";
                        }
                    }
                }
            
                htmlTable &= "</table>";
            </cfscript>
            <cfoutput>#htmlTable#</cfoutput>

            <script>
                async function processAndSubmit(event) {
                    event.preventDefault();
            
                    const input = document.getElementById('photoInput');
                    const base64Array = [];
                    for (let file of input.files) {
                        const reader = new FileReader();
                        const result = await new Promise(resolve => {
                            reader.onload = () => resolve(reader.result.split(',')[1]);
                            reader.readAsDataURL(file);
                        });
                        base64Array.push({ fileName: file.name, base64: result });
                    }
            
                    document.getElementById('photoBase64').value = JSON.stringify(base64Array);
                    document.getElementById('uploadForm').submit();
                }
            
                // Filtrar a tabela com base na entrada do usuário
                document.getElementById('searchInput').addEventListener('input', function() {
                    const filter = this.value.toLowerCase();
                    const rows = document.querySelectorAll('#dataTable tr:not(:first-child)');
                    rows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        row.style.display = text.includes(filter) ? '' : 'none';
                    });
                });
            </script>

<cfparam name="id_nc" default="">
<!-- Verifica se ID foi passado -->
<cfif NOT Len(id_nc)>
    <cfoutput>Erro: ID NC não especificado.</cfoutput>
    <cfabort>
</cfif>

<cfset caminhoBase = "E:\arquivo_foto\">
<cfset pastaImagens = caminhoBase & id_nc>

<!-- Verifica se a pasta existe -->
<cfif NOT directoryExists(pastaImagens)>
    <cfoutput>Erro: Diretório não encontrado.</cfoutput>
    <cfabort>
</cfif>

<!-- Lista as imagens na pasta -->
<cfscript>
    htmlContent = "<div class='folder-content'><ul style='list-style: none; padding: 0;'>";

    folderContent = directoryList(pastaImagens, false, "name");

    for (contentName in folderContent) {
        if (
            findNoCase(".jpg", contentName) or 
            findNoCase(".png", contentName) or 
            findNoCase(".jpeg", contentName) or 
            findNoCase(".gif", contentName) or 
            findNoCase(".bmp", contentName) or 
            findNoCase(".webp", contentName)
        ) {
            fileUrl = "/qualidade/relatorios/alertas/exibeImagens.cfm?imagem=" & urlEncodedFormat(contentName) & "&id_nc=" & urlEncodedFormat(id_nc);

            htmlContent &= "<li style='margin-bottom: 10px;'>";
                htmlContent = "";
                htmlContent &= "<ul style='display: flex; flex-wrap: wrap; gap: 15px;'>";  // Contêiner para as imagens na horizontal
                
                for (content in folderContent) {
                    contentName = listLast(content, "\");  // Extrair apenas o nome do arquivo
                
                    // Gerar o caminho relativo para a imagem
                    fileUrl = "/qualidade/relatorios/alertas/exibeImagens.cfm?imagem=" & urlEncodedFormat(contentName) & "&id_nc=" & urlEncodedFormat(id_nc);
                
                    // Verificar se é uma imagem (jpg, png, jpeg, gif)
                    if (findNoCase(".jpg", contentName) or findNoCase(".png", contentName) or findNoCase(".jpeg", contentName) or findNoCase(".gif", contentName)) {
                        // Adicionar a imagem e o link à lista
                        htmlContent &= "<li style='text-align: center; list-style-type: none;'>";
                        htmlContent &= "<a href='" & fileUrl & "' class='image-link' data-image='" & fileUrl & "' target='_blank' style='display: flex; flex-direction: column; align-items: center; gap: 5px; text-decoration: none;'>";
                        
                        // Exibir a imagem maior
                        htmlContent &= "<img src='" & fileUrl & "' style='width: 100px; height: 100px; object-fit: cover; border-radius: 4px;'>";
                        
                        // Nome da imagem abaixo da miniatura
                        htmlContent &= "<span style='color: blue; font-size: 12px; margin-top: 5px;'>" & contentName & "</span>";
                        htmlContent &= "</a>";
                        htmlContent &= "</li>";
                    }
                }
                
                htmlContent &= "</ul>";
                
            htmlContent &= "</li>";
        }
    }

    htmlContent &= "</ul></div>";
</cfscript>

<cfoutput>#htmlContent#</cfoutput>

<!-- CSS para posicionar a prévia -->
<style>
    #imagePreview {
        display: none;
        position: absolute;
        border: 1px solid #ccc;
        background: #fff;
        padding: 5px;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
    }
</style>

<!-- Elemento para mostrar a prévia -->
<div id="imagePreview">
    <img id="previewImg" src="" style="max-width: 350px; max-height: 350px;">
</div>

<!-- Script para exibir a prévia da imagem -->
<script>
        document.addEventListener("DOMContentLoaded", function() {
        const preview = document.getElementById("imagePreview");
        const previewImg = document.getElementById("previewImg");

        document.querySelectorAll(".image-link").forEach(link => {
            link.addEventListener("mouseover", function(event) {
                previewImg.src = this.dataset.image;
                preview.style.display = "block";
                positionPreview(event);
            });

            link.addEventListener("mousemove", function(event) {
                positionPreview(event);
            });

            link.addEventListener("mouseout", function() {
                preview.style.display = "none";
            });

            function positionPreview(event) {
                const previewWidth = preview.offsetWidth;
                const previewHeight = preview.offsetHeight;
                const pageWidth = window.innerWidth;
                const pageHeight = window.innerHeight;

                let top = event.pageY - previewHeight - 10; // Aparecer acima do mouse
                let left = event.pageX + 10; // Posição padrão à direita

                // Se estiver no topo da página, exibir abaixo do mouse
                if (top < window.scrollY) {
                    top = event.pageY + 10;
                }

                // Se a imagem ultrapassar a lateral direita, ajustar para a esquerda
                if (left + previewWidth > pageWidth) {
                    left = event.pageX - previewWidth - 10;
                }

                preview.style.top = top + "px";
                preview.style.left = left + "px";
            }
        });
    });
</script>

        </body>
</html>
    