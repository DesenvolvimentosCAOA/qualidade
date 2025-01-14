<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload de Fotos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #f0f0f0;
        }

        h1 {
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        input[type="file"], input[type="text"] {
            margin-bottom: 10px;
        }

        button {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        table {
            margin-top: 20px;
            border-collapse: collapse;
            width: 80%;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
    <h1>Upload de Fotos</h1>
    <form id="uploadForm" action="upload.cfm" method="post" enctype="multipart/form-data">
        <input type="text" name="vin" placeholder="Digite o VIN" maxlength="17" required>
        <input type="file" name="photo" accept="image/*" required>
        <button type="submit">Enviar</button>
    </form>

    <!-- Código CFML para gerar a tabela -->
    <cfscript>
        // Caminho do diretório
        directoryPath = "C:/Users/jefferson.teixeira/Downloads/ArquivosExcel/";

        // Obter a lista de pastas
        folderList = directoryList(directoryPath, true, "directory");

        // Gerar o código HTML para a tabela
        htmlTable = "<table>";
        htmlTable &= "<tr><th>Nome da Pasta</th></tr>";

        for (folder in folderList) {
            folderName = listLast(folder, "\");
            htmlTable &= "<tr><td>" & folderName & "</td></tr>";
        }

        htmlTable &= "</table>";
    </cfscript>

    <!-- Exibir a tabela HTML -->
    <cfoutput>#htmlTable#</cfoutput>

    <script>
        document.getElementById('uploadForm').addEventListener('submit', function(event) {
            alert('Foto enviada com sucesso!');
        });
    </script>
</body>
</html>