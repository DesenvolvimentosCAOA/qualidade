<cfscript>
    // Obter o nome da pasta a partir do parâmetro da URL
    folderName = url.id_nc;  // Use o parâmetro id_nc
    // Caminho completo da pasta
    directoryPath = "#raizpasta#/qualidade/arquivo_foto/" & folderName;

    // Verificar se a pasta existe
    if (directoryExists(directoryPath)) {
        // Excluir a pasta e seu conteúdo
        directoryDelete(directoryPath, true);

        // Exibir mensagem de sucesso
        writeOutput("<div class='message success'><h1>Sucesso</h1><p>A pasta foi excluída com sucesso.</p></div>");
    } else {
        // Exibir mensagem de erro se a pasta não existir
        writeOutput("<div class='message error'><h1>Erro</h1><p>A pasta especificada não existe.</p></div>");
    }
</cfscript>

<!-- Adicionar um timer de 2 segundos para redirecionar -->
<script>
    setTimeout(function() {
        window.location.href = 'd_principal.cfm';
    }, 2000);
</script>

<!-- Estilos personalizados -->
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        background-color: #f0f0f0;
        margin: 0;
        padding: 20px;
    }

    .message {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        text-align: center;
        max-width: 400px;
        width: 100%;
    }

    .message.success {
        border-left: 5px solid #28a745;
    }

    .message.error {
        border-left: 5px solid #dc3545;
    }

    h1 {
        color: #333;
        margin-bottom: 10px;
    }

    p {
        color: #666;
        margin: 0;
    }
</style>
