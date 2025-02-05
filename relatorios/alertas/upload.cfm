<cfif structKeyExists(form, "vin") and structKeyExists(form, "photoBase64")>
    <cfset vin = form.vin>
    <cfset destinationPath = "C:/ColdFusion2023/cfusion-manuais/wwwroot/qualidade/arquivo_foto/#vin#/">

    <!--- Cria o diretório VIN dentro do caminho de destino se não existir --->
    <cfif not directoryExists(destinationPath)>
        <cfdirectory action="create" directory="#destinationPath#">
    </cfif>

    <!--- Decodifica o Base64 e salva os arquivos dentro do diretório VIN --->
    <cfset photoData = deserializeJSON(form.photoBase64)>
    <cfloop array="#photoData#" index="image">
        <cfset filePath = destinationPath & image.fileName>
        <cfset binaryData = toBinary(image.base64)>
        <cffile action="write" file="#filePath#" output="#binaryData#">
    </cfloop>

    <!--- Atualiza o STATUS na tabela ALERTAS_8D no datasource BANCOSINC --->
    <cfquery datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.ALERTAS_8D
        SET STATUS = 'EVIDENCIAS'
        WHERE ID = <cfqueryparam value="#id_editar#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfoutput>
        <p>Fotos enviadas com sucesso para a pasta #vin#!</p>
    </cfoutput>

    <script>
        alert("Criado com Sucesso!!");
        self.location = 'd_principal.cfm';
    </script>
</cfif>

