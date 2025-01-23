<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<cfquery name="obterMaxId" datasource="#BANCOSINC#">
    SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.ALERTA_QUALIDADE
</cfquery>

<cfquery name="insere" datasource="#BANCOSINC#">
    insert into INTCOLDFUSION.ALERTA_QUALIDADE (ID, DATA_ALERTA)
        VALUES (<cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">)
</cfquery>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alerta da Qualidade</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 90%;
            margin: 20px auto;
            background: #fff;
            border: 1px solid #ddd;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .title {
            text-align: center;
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 10px;
            color:red;
        }
        .subtitle {
            font-size: 12px;
            font-weight: bold;
            margin: 20px 0 10px;
            text-align: left;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            text-align: center;
            padding: 10px;
        }
        th {
            background-color: #f2f2f2;
        }
        .merged-cell {
            text-align: left;
            font-weight: bold;
            background-color: #f9f9f9;
        }
        input[type="text"] {
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 2px;
            font-size: 14px;
            background-color: #f9f9f9;
            box-sizing: border-box;
            text-align: center;
        }
        input[type="text"]:focus {
            border-color: #007BFF;
            outline: none;
            background-color: #fff;
        }
        .radio-group {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
        }
        .radio-group label {
            font-size: 14px;
            font-weight: normal;
        }
        .radio-group input[type="radio"] {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }
        .flex-row {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        .flex-row .column {
            flex: 1;
        }
        .flex-row .column-2-3 {
            flex: 2;
        }
        .preview {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .preview img {
            width: 100px;  /* Define o tamanho da miniatura */
            height: 100px;
            object-fit: cover;  /* Faz a imagem se ajustar sem distorção */
            cursor: pointer;
            border-radius: 8px;  /* Cantos arredondados nas miniaturas */
        }

        .preview img:hover {
            opacity: 0.7;  /* Dá um efeito visual quando o usuário passa o mouse */
        }

        /* Estilo para o modal (exibição da imagem em tamanho maior) */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            justify-content: center;
            align-items: center;
        }

        .modal img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }

        .modal .close {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 30px;
            color: white;
            cursor: pointer;
        }
        /* Caixa para separar as seções */
        .section-box {
            background-color: #fff;  /* Cor de fundo branca */
            border: 1px solid #ddd;  /* Borda sutil */
            padding: 15px;
            margin-bottom: 20px;  /* Espaçamento inferior para separar as seções */
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);  /* Sombra sutil para dar destaque */
            border-radius: 8px;  /* Bordas arredondadas */
        }

        .section-box label {
            font-weight: bold;
            display: block;
            margin-bottom: 8px;  /* Espaço entre o label e o input */
        }

        .section-box .preview {
            margin-top: 10px;
        }

        /* Definir um espaço mais generoso entre o campo 'DETALHES DA NÃO CONFORMIDADE' e o campo anterior */
        .flex-row + .flex-row {
            margin-top: 30px;
        }
        .section-box {
            padding: 10px;
            border: 1px solid #ccc;
            margin-top: 10px;
        }
        .flex-row {
            display: flex;
            justify-content: space-between;
        }
        .column {
            flex: 1;
            margin: 0 10px;
        }
        .preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
            background-color: #f9f9f9;
            padding: 10px;
            border: 1px dashed #ccc;
        }
        .preview img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 1px solid #ddd;
        }
        .preview .image-wrapper {
            position: relative;
        }
        .preview .remove-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: red;
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 12px;
            width: 20px;
            height: 20px;
        }
        .btn {
            margin-top: 10px;
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
    <body>
        <div class="container">
            <div class="title">ALERTA DA QUALIDADE</div> <div>Nº: <input  style="width:100px;" type="text" name="id_alerta"></div>
            <div style="background-color: #ddd;font-weight:bold;">ETAPA 1</div>
                <form method="post" id="form_envio">
                    <table>
                        <tr>
                            <td class="subtitle"class="merged-cell" colspan="2">CLIENTE:</td>
                            <td class="subtitle"colspan="2"><input type="text" name="cliente" required></td>
                            <td class="subtitle"colspan="2">MODELO:</td>
                            <td class="subtitle"colspan="2"><input type="text" name="modelo"></td>
                        </tr>
                        <tr>
                            <td class="subtitle"class="merged-cell" colspan="2">VIN/BARCODE DA OCORRÊNCIA:</td>
                            <td class="subtitle"colspan="2"><input type="text" name="vin_barcode"></td>
                            <td class="subtitle"colspan="2">PONTO DE CORTE:</td>
                            <td class="subtitle"colspan="2"><input type="text" name="ponto_corte"></td>
                        </tr>

                        <tr>
                            <th class="subtitle"colspan="2">DATA/HORA DA OCORRÊNCIA</th>
                            <th class="subtitle"colspan="2">SHOP RESPONSÁVEL</th>
                            <th class="subtitle"colspan="2">REINCIDÊNCIA</th>
                            <td class="subtitle"colspan="2">DESCRIÇÃO DA OCORRÊNCIA</td>
                        </tr>
                        <tr>
                            <td colspan="2"><input type="text" name="data_hora"></td>
                            <td colspan="2"><input type="text" name="shop_responsavel"></td>
                            <td colspan="2">
                                <div class="radio-group">
                                    <label><input type="radio" name="reincidencia" value="sim"> Sim</label>
                                    <label><input type="radio" name="reincidencia" value="nao"> Não</label>
                                </div>
                                <td colspan="2">
                                    <div class="radio-group">
                                        <label><input type="radio" name="origem" value="interno"> Interno</label>
                                        <label><input type="radio" name="origem" value="externo"> Externo</label>
                                    </div>
                                </td>
                            </td>
                        </tr>
                    </table>
                    <div style="background-color: #ddd;font-weight:bold;">OCORRÊNCIA</div>
                    <div class="section-box">
                        <div class="flex-row">
                            <div class="column">
                                <label style="background-color:green;color:white;text-align:center;" for="comparacao">PRODUTO CONFORME:</label>
                                <input type="file" id="comparacao" name="comparacao" accept="image/*" multiple>
                                <div class="preview" id="comparacao-preview"></div>
                                <button class="btn" onclick="removeAllImages('comparacao-preview')">Apagar todas as imagens</button>
                            </div>
                            <div class="column">
                                <label style="background-color:red;color:white;text-align:center;" for="produto_nao_conforme">PRODUTO NÃO CONFORME:</label>
                                <input type="file" id="produto_nao_conforme" name="produto_nao_conforme" accept="image/*" multiple>
                                <div class="preview" id="produto_nao_conforme-preview"></div>
                                <button class="btn" onclick="removeAllImages('produto_nao_conforme-preview')">Apagar todas as imagens</button>
                            </div>
                        </div>
                    </div>
                    <script>
                        function handleFileInput(event, previewId) {
                            const previewContainer = document.getElementById(previewId);
                            const files = event.target.files;
                            Array.from(files).forEach(file => {
                                const reader = new FileReader();
                                reader.onload = function(e) {
                                    const imgWrapper = document.createElement('div');
                                    imgWrapper.classList.add('image-wrapper');

                                    const img = document.createElement('img');
                                    img.src = e.target.result;

                                    const removeBtn = document.createElement('button');
                                    removeBtn.innerText = 'x';
                                    removeBtn.classList.add('remove-btn');
                                    removeBtn.onclick = () => imgWrapper.remove();

                                    imgWrapper.appendChild(img);
                                    imgWrapper.appendChild(removeBtn);
                                    previewContainer.appendChild(imgWrapper);
                                };
                                reader.readAsDataURL(file);
                            });

                            // Clear the input value to allow re-uploading the same file
                            event.target.value = '';
                        }

                        function removeAllImages(previewId) {
                            const previewContainer = document.getElementById(previewId);
                            previewContainer.innerHTML = '';
                        }

                        document.getElementById('comparacao').addEventListener('change', (e) => handleFileInput(e, 'comparacao-preview'));
                        document.getElementById('produto_nao_conforme').addEventListener('change', (e) => handleFileInput(e, 'produto_nao_conforme-preview'));
                    </script>
                    <!-- Caixa para PRODUTO NÃO CONFORME -->
                    <div class="section-box">
                        <div class="flex-row">
                            <div class="column-2-3">
                                <label style="background-color:yellow;text-align:center;" for="detalhes">DETALHES DA NÃO CONFORMIDADE:</label>
                                <input type="file" id="detalhes" name="detalhes" accept="image/*" multiple>
                                <div class="preview" id="detalhes-preview"></div>
                                <button class="btn" onclick="removeAllImages('detalhes-preview')">Apagar todas as imagens</button>
                            </div>
                        </div>
                    </div>
                    <script>
                        // Gerenciadores de arquivos por campo de input
                        const fileData = {
                            detalhes: []
                        };
                
                        function handleFileInput(event, previewId, inputName) {
                            const previewContainer = document.getElementById(previewId);
                            const files = event.target.files;
                
                            // Adicionar novos arquivos ao array e mostrar na interface
                            Array.from(files).forEach(file => {
                                fileData[inputName].push(file);
                
                                const reader = new FileReader();
                                reader.onload = function(e) {
                                    const imgWrapper = document.createElement('div');
                                    imgWrapper.classList.add('image-wrapper');
                
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                
                                    const removeBtn = document.createElement('button');
                                    removeBtn.innerText = 'x';
                                    removeBtn.classList.add('remove-btn');
                                    removeBtn.onclick = () => {
                                        imgWrapper.remove();
                                        removeFileFromList(inputName, file);
                                    };
                
                                    imgWrapper.appendChild(img);
                                    imgWrapper.appendChild(removeBtn);
                                    previewContainer.appendChild(imgWrapper);
                                };
                                reader.readAsDataURL(file);
                            });
                
                            // Limpar o campo para permitir reenvio do mesmo arquivo
                            event.target.value = '';
                        }
                
                        function removeAllImages(previewId) {
                            const previewContainer = document.getElementById(previewId);
                            previewContainer.innerHTML = '';
                            const inputName = previewId.replace('-preview', '');
                            fileData[inputName] = [];
                        }
                
                        function removeFileFromList(inputName, fileToRemove) {
                            fileData[inputName] = fileData[inputName].filter(file => file !== fileToRemove);
                        }
                
                        document.getElementById('detalhes').addEventListener('change', (e) => handleFileInput(e, 'detalhes-preview', 'detalhes'));
                    </script>
                    <div class="container">
                        <div style="background-color: #ddd;font-weight:bold;">ETAPA 2 - ESCALONAMENTO DAS INFORMAÇÕES</div>
                        <table>
                            <tr>
                                <td style="font-size:12px;text-align:left;" class="merged-cell" colspan="2">OPERADOR:</td>
                                <td colspan="2"><input type="text" name="operador"></td>
                                <td style="font-size:12px;text-align:left;" class="merged-cell" colspan="2">LÍDER:</td>
                                <td colspan="2"><input type="text" name="lider"></td>
                            </tr>
                        </table>
                    
                        <!-- ETAPA 3: MONITORAMENTO DA EFICÁCIA -->
                        <div style="background-color: #ddd;font-weight:bold;">ETAPA 3 - MONITORAMENTO DA EFICÁCIA</div>
                        <table>
                            <tr>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="1">EFICÁCIA:</th>
                                <td>
                                    <div class="radio-group">
                                        <label><input type="radio" name="eficacia1" value="ok"> OK</label>
                                        <label><input type="radio" name="eficacia1" value="ng"> NG</label>
                                    </div>
                                </td>
                                <td>
                                    <div class="radio-group">
                                        <label><input type="radio" name="eficacia2" value="ok"> OK</label>
                                        <label><input type="radio" name="eficacia2" value="ng"> NG</label>
                                    </div>
                                </td>
                                <td>
                                    <div class="radio-group">
                                        <label><input type="radio" name="eficacia3" value="ok"> OK</label>
                                        <label><input type="radio" name="eficacia3" value="ng"> NG</label>
                                    </div>
                                </td>
                            </tr>
                            
                            <tr>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="1">VIN/BARCODE:</th>
                                <td><input type="text" name="VIN1"></td>
                                <td><input type="text" name="VIN2"></td>
                                <td><input type="text" name="VIN3"></td>
                            </tr>
                            <tr>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="1">DATA DE ENTRADA:</th>
                                <td><input type="date" name="data1"></td>
                                <td><input type="date" name="data2"></td>
                                <td><input type="date" name="data3"></td>
                            </tr>

                        </table>

                        <div style="background-color: #ddd;font-weight:bold;">ETAPA 4 - APROVAÇÃO</div>
                        <table>
                            <tr>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="3">PRODUÇÃO:</th>
                                <td><input type="text" name="producao"></td>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="3">QUALIDADE:</th>
                                <td><input type="text" name="qualidade"></td>
                                <th style="font-size:12px;text-align:left;" class="subtitle" colspan="3">ENGENHEIRO DE QUALIDADE:</th>
                                <td><input type="text" name="engenheiro"></td>
                            </tr>
                        </table>
                        <button type="submit">enviar</button>
                </form>
            </div>
        <script>
                function previewImages(input, previewId) {
                const preview = document.getElementById(previewId);
                preview.innerHTML = "";  // Limpa a área de visualização

                const files = input.files;
                if (files.length > 0) {
                    for (let i = 0; i < files.length; i++) {
                        const file = files[i];
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const img = document.createElement("img");
                            img.src = e.target.result;
                            img.setAttribute("data-src", e.target.result);  // Armazena o caminho original da imagem
                            preview.appendChild(img);

                            // Evento de clique para abrir imagem em tamanho maior
                            img.addEventListener("click", function() {
                                openModal(e.target.result);
                            });
                        };
                        reader.readAsDataURL(file);
                    }
                }
            }

            document.getElementById("comparacao").addEventListener("change", function() {
                previewImages(this, "comparacao-preview");
            });

            document.getElementById("detalhes").addEventListener("change", function() {
                previewImages(this, "detalhes-preview");
            });

            document.getElementById("produto_nao_conforme").addEventListener("change", function() {
                previewImages(this, "produto_nao_conforme-preview");
            });

            // Função para abrir a imagem em um modal
            function openModal(src) {
                const modal = document.createElement("div");
                modal.classList.add("modal");

                const modalImage = document.createElement("img");
                modalImage.src = src;
                modal.appendChild(modalImage);

                // Criar o botão de fechar
                const closeButton = document.createElement("div");
                closeButton.classList.add("close");
                closeButton.innerHTML = "&times;";
                modal.appendChild(closeButton);

                // Exibir o modal
                document.body.appendChild(modal);
                modal.style.display = "flex";

                // Fechar o modal ao clicar no botão
                closeButton.addEventListener("click", function() {
                    modal.style.display = "none";
                    document.body.removeChild(modal);  // Remove o modal do DOM
                });

                // Fechar o modal ao clicar fora da imagem
                modal.addEventListener("click", function(event) {
                    if (event.target === modal) {
                        modal.style.display = "none";
                        document.body.removeChild(modal);
                    }
                });
            }
        </script>
    </body>
</html>
