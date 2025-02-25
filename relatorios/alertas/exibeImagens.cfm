<cfparam name="imagem" default="">
<cfparam name="id_nc" default="">

<cfset caminhoBase = "E:\arquivo_foto\">
<cfset caminhoImagem = caminhoBase & id_nc & "\" & imagem>

<cfif NOT Len(imagem) OR NOT Len(id_nc)>
    <cfoutput>Erro: Parâmetros inválidos.</cfoutput>
<cfelseif Find("..", imagem) OR Find("..", id_nc)>
    <cfoutput>Erro: Caminho inválido.</cfoutput>
<cfelseif NOT FileExists(caminhoImagem)>
    <cfoutput>Erro: Imagem não encontrada.</cfoutput>
<cfelse>
    <cfheader name="Content-Type" value="#getContentType(caminhoImagem)#">
    <cfcontent file="#caminhoImagem#" deletefile="no">
</cfif>

<cfscript>
    function getContentType(filePath) {
        ext = ListLast(filePath, ".");
        mimeTypes = {
            "jpg" = "image/jpeg",
            "jpeg" = "image/jpeg",
            "png" = "image/png",
            "gif" = "image/gif",
            "bmp" = "image/bmp",
            "webp" = "image/webp"
        };
        return StructKeyExists(mimeTypes, ext) ? mimeTypes[ext] : "application/octet-stream";
    }
</cfscript>
