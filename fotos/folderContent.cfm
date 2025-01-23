<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><cfoutput>#url.folder#</cfoutput></title>

    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: 100vh;
            background-color: #f0f0f0;
            padding: 20px;
        }

        h1 {
            color: #333;
        }

        .back-button {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            margin-bottom: 20px;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .folder-content {
            width: 100%;
            max-width: 800px;
        }

        .folder-content ul {
            list-style-type: none;
            padding-left: 0;
        }

        .folder-content li {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .folder-content img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 10px;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .folder-content a {
            text-decoration: none;
            color: #007BFF;
        }

        .folder-content a:hover {
            text-decoration: underline;
        }

        /* Estilo do modal */
        #imageModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        #imageModal img {
            max-width: 90%;
            max-height: 90%;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <h1>VIN: <cfoutput>#url.folder#</cfoutput></h1>

    <!-- Voltar para a página anterior -->
    <button class="back-button" onclick="window.history.back()">Voltar</button>

    <!-- Código para mostrar o conteúdo da pasta -->
    <cfscript>
        folderPath = "#raizpasta#/qualidade/arquivo_foto/#url.folder#";
        folderContent = directoryList(folderPath, true, "all");

        htmlContent = "<div class='folder-content'>";
        htmlContent &= "<ul>";

        for (content in folderContent) {
            contentName = listLast(content, "\");

            // Gerar o link para o arquivo
            fileUrl = "/qualidade/arquivo_foto/#url.folder#/#contentName#";

            // Verificar se é uma imagem
            if (findNoCase(".jpg", contentName) or findNoCase(".png", contentName) or findNoCase(".jpeg", contentName) or findNoCase(".gif", contentName)) {
                // Adicionar a miniatura da imagem e o link à lista
                htmlContent &= "<li>";
                htmlContent &= "<img src='" & fileUrl & "' alt='" & contentName & "' onclick='openModal(this)'>";
                htmlContent &= "<a href='" & fileUrl & "' target='_blank'>" & contentName & "</a>";
                htmlContent &= "</li>";
            }
        }

        htmlContent &= "</ul>";
        htmlContent &= "</div>";
    </cfscript>

    <cfoutput>#htmlContent#</cfoutput>

    <!-- Modal para exibir a imagem ampliada -->
    <div id="imageModal" onclick="closeModal()">
        <img id="modalImage" src="" alt="Imagem ampliada">
    </div>

    <script>
        // Abre o modal com a imagem ampliada
        function openModal(image) {
            const modal = document.getElementById('imageModal');
            const modalImage = document.getElementById('modalImage');
            modalImage.src = image.src;
            modal.style.display = 'flex';
        }

        // Fecha o modal ao clicar nele
        function closeModal() {
            const modal = document.getElementById('imageModal');
            modal.style.display = 'none';
        }
    </script>
</body>
</html>
