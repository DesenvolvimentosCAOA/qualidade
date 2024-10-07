<cfcontent type="application/json">
<cfinvoke method="inicializando" component="cf.ini.index">
<cfparam name="form.imagemBase64" default="">
<cfset rootFolder = "C:\ColdFusion2023\cfusion\wwwroot\">
<cfset saveFolder = rootFolder & "imagens\">

<cfif not directoryExists(saveFolder)>
   <cfdirectory action="create" directory="#saveFolder#">
</cfif>

<cfset fileName = "imagem_" & createUUID() & ".png">
<cfset filePath = saveFolder & fileName>

<!-- Decodifica a imagem base64 em dados binários -->
<cfset binaryImageData = binaryDecode(form.imagemBase64, "base64")>

<!-- Escreve os dados binários no arquivo -->
<cffile action="write"
        file="#filePath#"
        output="#binaryImageData#">

<!-- Retorna uma resposta para o JavaScript -->
<cfoutput>
   {"success": true, "fileName": "#fileName#", "filePath": "#filePath#"}
</cfoutput>

