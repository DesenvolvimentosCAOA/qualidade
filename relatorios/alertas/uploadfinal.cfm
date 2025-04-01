<cfif structKeyExists(form, "vin") and structKeyExists(form, "photoBase64")>
    <cfset vin = form.vin>
    <cfset destinationPath = "E:/arquivo_foto/#vin#/">

    <!--- Cria o diretório VIN dentro do caminho de destino se não existir --->
    <cfif not directoryExists(destinationPath)>
        <cfdirectory action="create" directory="#destinationPath#">
    </cfif>

    <!--- Decodifica o Base64 e salva os arquivos dentro do diretório VIN --->
    <cfset photoData = deserializeJSON(form.photoBase64)>
    <cfset counter = 1>
    
    <cfloop array="#photoData#" index="image">
        <!--- Obtém a extensão do arquivo original --->
        <cfset fileExt = listLast(image.fileName, ".")>
        
        <!--- Cria o novo nome do arquivo --->
        <cfset newFileName = "EVIDENCIAS FINALIZADAS " & counter & "." & fileExt>
        <cfset filePath = destinationPath & newFileName>
        
        <!--- Verifica se o arquivo já existe para evitar sobrescrita --->
        <cfloop condition="fileExists(filePath)">
            <cfset counter++>
            <cfset newFileName = "EVIDENCIAS FINALIZADAS " & counter & "." & fileExt>
            <cfset filePath = destinationPath & newFileName>
        </cfloop>
        
        <cfset binaryData = toBinary(image.base64)>
        <cffile action="write" file="#filePath#" output="#binaryData#">
        
        <cfset counter++>
    </cfloop>

    <!--- Atualiza o STATUS na tabela ALERTAS_8D no datasource BANCOSINC --->
    <cfquery datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.ALERTAS_8D
        SET STATUS = 'FINALIZADO'
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