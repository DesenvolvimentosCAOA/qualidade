<cfscript>
    // Obter o caminho da pasta a partir do parâmetro da URL
    folderPath = url.folder;

    // Obter a lista de arquivos na pasta
    fileList = directoryList(folderPath, false, "file");

    // Gerar o código HTML para a lista de arquivos
    htmlFileList = "<ul>";

    for (file in fileList) {
        fileName = listLast(file, "\");
        htmlFileList &= "<li>" & fileName & "</li>";
    }

    htmlFileList &= "</ul>";
</cfscript>

<!-- Exibir a lista de arquivos -->
<cfoutput>#htmlFileList#</cfoutput>