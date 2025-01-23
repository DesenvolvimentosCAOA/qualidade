<cfif structKeyExists(form, "vin") and structKeyExists(form, "photoBase64")>
    <cfset vin = form.vin>
    <cfset destinationPath = "#raizpasta#/qualidade/arquivo_foto/" & vin & "/">

    <!--- Cria o diretório se não existir --->
    <cfif not directoryExists(destinationPath)>
        <cfdirectory action="create" directory="#destinationPath#">
    </cfif>

    <!--- Decodifica o Base64 e salva os arquivos --->
    <cfset photoData = deserializeJSON(form.photoBase64)>
    <cfloop array="#photoData#" index="image">
        <cfset filePath = destinationPath & image.fileName>
        <cfset binaryData = toBinary(image.base64)>
        <cffile action="write" file="#filePath#" output="#binaryData#">
    </cfloop>

    <cfoutput>
        <p>Fotos enviadas com sucesso para a pasta #vin#!</p>
    </cfoutput>

    <script>
        alert("Criado com Sucesso!!");
        self.location = 'cadastro_defeitos.cfm';
    </script>
</cfif>
