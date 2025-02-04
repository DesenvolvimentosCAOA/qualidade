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
                STATUS = 'D3'
                WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
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

            body {
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
    
            .logo img {
                width: 100px;
                height: 50px;
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
    
            input, select {
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
                                    <td class="header" colspan="9" style="text-align:center;">
                                        8D - ALERTA DE QUALIDADE
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2" style="text-align:center; font-size:30px;background-color:lightgrey;">D1</td>
                                    <td class="label-bold" colspan="1" style="background-color:lightgrey;text-align:center;">Nº DE CONTROLE:</td>
                                    <td class="label-bold" colspan="1" style="background-color:lightgrey;text-align:center;">SETOR RESPONSÁVEL:</td>
                                    <td class="label-bold" colspan="6" style="background-color:lightgrey;text-align:center;">RESPONSÁVEL PELA ABERTURA DO ALERTA:</td>

                                </tr>
                                <cfquery name="obterMaxId" datasource="#BANCOSINC#">
                                    SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.ALERTAS_8D
                                </cfquery>
                                <th colspan="1" style="background-color:lightgrey;">
                                    <input type="text" name="n_controle" style="background-color:lightgrey; text-align:center;" value="#consulta_editar.n_controle#" readonly>
                                </th>
                                <th colspan="1" style="background-color:lightgrey; text-align:center;">
                                    <input type="text" name="setor" id="setor" list="setores" style="background-color:lightgrey; text-align:center;" value="#consulta_editar.setor_responsavel#">
                                </th>
                                <th colspan="6" style="background-color:lightgrey;text-align:center;">
                                    <input type="text" name="responsavel_abertura" style="background-color:lightgrey;text-align:center;" value="#consulta_editar.resp_abertura#" readonly required>
                                </th>

                                <tr>
                                    <td rowspan="4" style="text-align:center; font-size:30px;">D2</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">BARREIRA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">DATA DA OCORRÊNCIA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">MODELO:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">VIN/BARCODE:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">PEÇA:</td>
                                    <td class="label-bold" colspan="1" style="text-align:center;">POSIÇÃO:</td>
                                </tr>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="barreira" id="barreira" list="barreiras" style="text-align:center;" value="#consulta_editar.barreira#">
                                </th>
                                
                                <th colspan="1">
                                    <input type="text" name="data_ocorrencia" value="#DateFormat(consulta_editar.data_ocorrencia, 'dd/mm/yyyy')#">
                                </th>

                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="modelo" id="modelo" style="text-align:center;" value="#consulta_editar.modelo#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="vin" placeholder="Vin/Barcode" style="text-align:center;" value="#consulta_editar.vin#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="peca" placeholder="Peça" style="text-align:center;" value="#consulta_editar.peca#" readonly>
                                </th>
                                <th colspan="1" style="text-align:center;">
                                    <input type="text" name="posicao" placeholder="Posição" style="text-align:center;" value="#consulta_editar.posicao#" readonly>
                                </th>
                                <tr>
                                    <td class="label-bold" colspan="1" style="text-align:center;">PROBLEMA:</td>
                                    <th colspan="8" style="text-align:center;">
                                        <input type="text" name="problema" placeholder="Problema" style="text-align:center;" value="#consulta_editar.problema#" readonly>
                                    </th>
                                </tr>                                
                                <tr>
                                    <td class="label-bold" colspan="1">DESCRIÇÃO DA NÃO CONFORMIDADE:</td>
                                    <td colspan="8">
                                        <input type="text" name="descricao" placeholder="DESCREVA DETALHADAMENTE A NÃO CONFORMIDADE" value="#consulta_editar.descricao_nc#" readonly>
                                    </td>
                                </tr>
                                <form method="POST">
                                    <tr>
                                        <td rowspan="1" colspan="1" style="text-align:center; font-size:30px;background-color:lightgrey;">D3</td>
                                        <td class="label-bold" colspan="1" style="background-color:lightgrey;">AÇÃO DE CONTENÇÃO:</td>
                                        <td colspan="8" style="background-color:lightgrey;">
                                            <input type="text" name="acao_contencao" placeholder="DESCREVA A AÇÃO DE CONTENÇÃO REALIZADA" style="background-color:lightgrey;">
                                        </td>
                                    </tr>
                            </table>
                                    <button type="button" class="btn-rounded back-btn" id="btnback" onclick="window.location.href = 'd_principal.cfm';">Voltar</button>
                                    <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                                </form>
                    </cfoutput>
                </div>
            </div>
            
            <cfscript>
                // Caminho do diretório
                directoryPath = "C:/ColdFusion2023/cfusion-manuais/wwwroot/qualidade/arquivo_foto/";
            
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
            
            <cfscript>
                // Caminho da pasta com as imagens
                folderPath = "C:/ColdFusion2023/cfusion-manuais/wwwroot/qualidade/arquivo_foto/#url.id_nc#";
                
                // Listar todos os arquivos na pasta (recursivamente)
                folderContent = directoryList(folderPath, true, "all");
                
                // Iniciar o conteúdo HTML
                htmlContent = "<div class='folder-content'>";
                htmlContent &= "<ul>";
                
                // Loop para percorrer todos os arquivos da pasta
                for (content in folderContent) {
                    contentName = listLast(content, "\");  // Extrair apenas o nome do arquivo
                    
                    // Gerar o caminho relativo para a imagem
                    fileUrl = "/qualidade/arquivo_foto/#url.id_nc#/#contentName#";
                    
                    // Verificar se é uma imagem (jpg, png, jpeg, gif)
                    if (findNoCase(".jpg", contentName) or findNoCase(".png", contentName) or findNoCase(".jpeg", contentName) or findNoCase(".gif", contentName)) {
                        // Adicionar a imagem e o link à lista
                        htmlContent &= "<li>";
                        htmlContent &= "<img src='" & fileUrl & "' alt='" & contentName & "' style='width: 100px; height: auto; cursor: pointer;' onclick='openModal(this)'>";
                        htmlContent &= "<a href='" & fileUrl & "' target='_blank'>" & contentName & "</a>";
                        htmlContent &= "</li>";
                    }
                }
                
                htmlContent &= "</ul>";
                htmlContent &= "</div>";
            </cfscript>
            
            <cfoutput>#htmlContent#</cfoutput>
    
            <!-- Modal para visualizar as imagens -->
            <script>
                function openModal(imageElement) {
                    var modal = document.createElement("div");
                    modal.style.position = "fixed";
                    modal.style.top = "0";
                    modal.style.left = "0";
                    modal.style.width = "100%";
                    modal.style.height = "100%";
                    modal.style.backgroundColor = "rgba(0, 0, 0, 0.7)";
                    modal.style.display = "flex";
                    modal.style.justifyContent = "center";
                    modal.style.alignItems = "center";
            
                    var modalImage = document.createElement("img");
                    modalImage.src = imageElement.src;
                    modalImage.style.maxWidth = "80%";
                    modalImage.style.maxHeight = "80%";
            
                    modal.appendChild(modalImage);
                    document.body.appendChild(modal);
            
                    modal.onclick = function() {
                        modal.remove();
                    };
                }
            </script>
            
        </body>
</html>
    