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

            #uploadForm {
                max-width: 500px;
                margin: 0 auto;
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 8px;
                background-color: #f9f9f9;
                font-family: Arial, sans-serif;
            }

            #uploadForm label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
                color: #333;
            }

            #uploadForm input[type="text"],
            #uploadForm input[type="file"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
            }

            #uploadForm input[type="text"]:read-only {
                background-color: #e9ecef;
                cursor: not-allowed;
            }

            #uploadForm button {
                width: 100%;
                padding: 10px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            #uploadForm button:hover {
                background-color: #0056b3;
            }

            #uploadForm input[type="file"] {
                padding: 5px;
                font-size: 14px;
            }

            #uploadForm input[type="file"]:focus {
                outline: none;
                border-color: #007bff;
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
                                        <textarea name="descricao" placeholder="DESCREVA DETALHADAMENTE A NÃO CONFORMIDADE" 
                                            required style="width: 100%; height: 100px; resize: vertical;">#consulta_editar.descricao_nc#</textarea>
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
                            </table>

                            <form id="uploadForm" action="upload.cfm" method="post" onsubmit="addIdToUrl(event)">
                                <label for="vin">Nº Controle:</label>
                                <input type="text" name="vin" id="vin" value="#consulta_editar.n_controle#" readonly required>
                                <input type="text" name="id" id="id" value="#consulta_editar.id#" readonly required hidden>
                                <label for="photoInput">Selecionar Arquivos:</label>
                                <input type="file" id="photoInput" multiple>
                                <input type="hidden" name="photoBase64" id="photoBase64">
                                <button type="submit">Enviar</button>
                            </form>
                        </cfoutput>
                        <script>
                            // Adiciona o ID (n_controle) na URL do formulário antes de enviar
                            function addIdToUrl(event) {
                                event.preventDefault(); // Previne o envio imediato
                                const id = document.getElementById('id').value; // Obtém o valor do ID (n_controle)
                                const form = document.getElementById('uploadForm'); // Referência ao formulário
                                const photoInput = document.getElementById('photoInput'); // Campo de arquivos
                        
                                // Verifica se há arquivos selecionados
                                if (!photoInput.files.length) {
                                    alert("Por favor, selecione pelo menos um arquivo.");
                                    return;
                                }
                        
                                // Processa os arquivos e transforma em Base64
                                const base64Array = [];
                                const promises = [];
                                for (let file of photoInput.files) {
                                    promises.push(new Promise((resolve) => {
                                        const reader = new FileReader();
                                        reader.onload = () => {
                                            const base64 = reader.result.split(',')[1];
                                            base64Array.push({ fileName: file.name, base64 });
                                            resolve();
                                        };
                                        reader.readAsDataURL(file);
                                    }));
                                }
                        
                                Promise.all(promises).then(() => {
                                    // Define o valor em Base64 no campo oculto
                                    document.getElementById('photoBase64').value = JSON.stringify(base64Array);
                        
                                    // Adiciona o ID (n_controle) à URL do formulário
                                    form.action += `?id_editar=${encodeURIComponent(id)}`;
                        
                                    // Envia o formulário
                                    form.submit();
                                });
                            }
                        </script>
                </div>
            </div>
            
            <cfscript>
                // Caminho do diretório
                directoryPath = "C:/ColdFusion2023/cfusion-manuais/wwwroot/qualidade/arquivo_foto/";

                // Obter o valor do id_nc da URL
                id_nc = url.id_nc;

                // Obter a lista de pastas
                folderList = directoryList(directoryPath, true, "directory");

                // Gerar o código HTML para a tabela
                htmlTable = "<table id='dataTable'>";
                htmlTable &= "<tr><th>Nome da Pasta</th><th>Ação</th></tr>";

                for (folder in folderList) {
                    folderName = listLast(folder, "\");

                    // Verificar se o nome da pasta corresponde ao id_editar
                    if (directoryExists(folder) && folderName == id_nc) {
                        htmlTable &= "<tr>";
                        htmlTable &= "<td>" & folderName & "</td>";
                        
                        htmlTable &= "</tr>";
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
        </body>
</html>
    