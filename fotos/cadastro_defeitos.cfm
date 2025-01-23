<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload de Fotos</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f7f9fc;
            margin: 0;
            padding: 20px;
        }
    
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 36px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
    
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #ffffff;
            padding: 25px 40px;
            border-radius: 12px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }
    
        input[type="file"], input[type="text"], input[type="search"] {
            margin-bottom: 15px;
            padding: 12px 18px;
            border: 2px solid #bbb;
            border-radius: 10px;
            width: 100%;
            font-size: 16px;
            color: #333;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }
    
        input[type="file"]:hover, input[type="text"]:focus, input[type="search"]:focus {
            border-color: #007bff;
            background-color: #fff;
        }
    
        button, input[type="submit"] {
            padding: 12px 25px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
    
        button:hover, input[type="submit"]:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
    
        table {
            width: 85%;
            max-width: 900px;
            border-collapse: collapse;
            margin-top: 40px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
    
        table, th, td {
            border: 1px solid #ddd;
        }
    
        th, td {
            padding: 15px 20px;
            text-align: left;
            font-size: 16px;
            color: #333;
        }
    
        th {
            background-color: #007bff;
            color: white;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
    
        tr:nth-child(even) {
            background-color: #f7f7f7;
        }
    
        tr:nth-child(odd) {
            background-color: #ffffff;
        }
    
        tr:hover {
            background-color: #e1f5fe;
            transform: scale(1.02);
            transition: transform 0.3s ease;
        }
    
        .search-container {
            margin-bottom: 0; /* Remove o espaçamento inferior */
            margin-top: 20px; /* Espaçamento superior para ajustar a posição */
            width: 85%;
            display: flex;
            justify-content: center;
        }
    
        input[type="search"] {
            width: 100%;
            max-width: 350px;
            padding: 12px 18px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 16px;
            color: #555;
            background-color: #f7f7f7;
            transition: all 0.3s ease;
        }
    
        input[type="search"]:focus {
            border-color: #007bff;
            background-color: #fff;
        }
    </style>
    
</head>
<body>
    <h1>Upload de Fotos</h1>
    <form id="uploadForm" action="upload.cfm" method="post">
        <input type="text" name="vin" placeholder="VIN" required>
        <input type="file" id="photoInput" multiple accept="image/*">
        <input type="hidden" name="photoBase64" id="photoBase64">
        <input type="submit" value="Enviar" onclick="processAndSubmit(event)">
    </form>

    <!-- Caixa de pesquisa -->
    <div class="search-container">
        <input type="search" id="searchInput" placeholder="Pesquisar na tabela...">
    </div>

    <cfscript>
        // Caminho do diretório
        directoryPath = "#raizpasta#/qualidade/arquivo_foto/";

        // Obter a lista de pastas
        folderList = directoryList(directoryPath, true, "directory");

        // Gerar o código HTML para a tabela
        htmlTable = "<table id='dataTable'>";
        htmlTable &= "<tr><th>Nome da Pasta</th><th>Ação</th></tr>";

        for (folder in folderList) {
            folderName = listLast(folder, "\");
            if (directoryExists(folder)) {
                htmlTable &= "<tr>";
                htmlTable &= "<td>" & folderName & "</td>";
                htmlTable &= "<td><a href='folderContent.cfm?folder=" & folderName & "'>Visualizar Imagens</a> | <a href='downloadFolder.cfm?folder=" & folderName & "'>Baixar Pasta</a> | <a href='deleteFolder.cfm?folder=" & folderName & "' onclick='return confirm('Tem certeza que deseja excluir esta pasta?')'>Excluir Pasta</a></td>";
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