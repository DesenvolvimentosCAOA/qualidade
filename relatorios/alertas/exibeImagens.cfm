<cfparam name="imagem" default="">
<cfset caminhoBase = "E:\arquivo_foto\">
<cfset caminhoImagem = caminhoBase & imagem>

<cfif NOT Len(imagem)>
    <cfoutput>Erro: Nenhuma imagem especificada.</cfoutput>
<cfelseif Find("..", imagem)>
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
