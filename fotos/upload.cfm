<cfif structKeyExists(form, "vin") and structKeyExists(form, "photo")>
    <cfset vin = form.vin>
    <cfset destinationPath = "C:/Users/jefferson.teixeira/Downloads/ArquivosExcel/" & vin & "/">
    
    <!--- Cria a pasta se não existir --->
    <cfdirectory action="create" directory="#destinationPath#">
    
    <!--- Faz o upload do arquivo --->
    <cffile action="upload" 
            filefield="photo" 
            destination="#destinationPath#" 
            nameconflict="overwrite">
    
    <cfoutput>
        <p>Foto enviada com sucesso para a pasta #vin#!</p>
    </cfoutput>
    <script>
        alert("Criado com Sucesso!!");
        self.location= 'cadastro_defeitos.cfm'
     </script>
</cfif>