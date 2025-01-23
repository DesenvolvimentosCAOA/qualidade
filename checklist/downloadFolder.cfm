<cfscript>
    // Obter o nome da pasta a partir do parâmetro da URL
    folderName = url.folder;

    // Caminho completo da pasta
    directoryPath = "#raizpasta#/qualidade/arquivo_checklist/" & folderName;

    // Caminho para o diretório temporário
    tempDirectory = "#raizpasta#/qualidade/arquivo_checklist/temp/";

    // Verificar se o diretório temporário existe, caso contrário, criar
    if (!directoryExists(tempDirectory)) {
        directoryCreate(tempDirectory);
    }

    // Verificar se a pasta existe
    if (directoryExists(directoryPath)) {
        // Caminho para o arquivo zip temporário
        zipFilePath = tempDirectory & folderName & ".zip";

        // Criar o arquivo zip
        cfzip(action="zip", file=zipFilePath, source=directoryPath);

        // Forçar o download do arquivo zip
        cfheader(name="Content-Disposition", value="attachment; filename=#folderName#.zip");
        cfcontent(file=zipFilePath, type="application/zip");

        // Excluir o arquivo zip temporário após o download
        fileDelete(zipFilePath);
    } else {
        // Exibir mensagem de erro se a pasta não existir
        writeOutput("<h1>Erro</h1>");
        writeOutput("<p>A pasta especificada não existe.</p>");
    }
</cfscript>