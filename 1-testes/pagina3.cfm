<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<cfif isDefined("form.fileUpload")>
    <!--- Atualizar o caminho para a pasta Downloads no seu PC --->
    <cfset uploadsPath = "C:\\Users\\jefferson.teixeira\\Downloads\\">
    
    <!--- Processar o upload do arquivo --->
    <cffile action="upload" 
            filefield="fileUpload" 
            destination="#uploadsPath#" 
            nameconflict="overwrite">
    
    <!--- Exibir o caminho do arquivo e nome do arquivo para depuração --->
    <cfset filePath = uploadsPath & cffile.serverFileName>
    <cfoutput>
        Caminho do arquivo: #filePath#<br>
        Nome do arquivo: #cffile.serverFileName#
    </cfoutput>
    
    <!--- Verificar se o arquivo existe antes de tentar ler --->
    <cfif fileExists(filePath)>
        <!--- Ler o arquivo Excel usando o CFSpreadSheet --->
        <cfspreadsheet action="read" src="#filePath#" name="spreadsheetData">
        
        <!--- Conectar ao banco de dados Oracle --->
        <cfset datasource = "#BANCOSINC#">
        
        <!--- Iterar pelos dados e inserir na tabela --->
        <cfloop index="row" from="1" to="#spreadsheetData.rowCount#">
            <cfset rowData = spreadsheetData[row]>
            
            <!--- Supondo que as colunas da tabela são VIN, BARCODE, e MODELO --->
            <cfquery datasource="#BANCOSINC#">
                INSERT INTO temp_barcode_vin (VIN, BARCODE, MODELO)
                VALUES (
                    <cfqueryparam value="#rowData[1]#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#rowData[2]#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#rowData[3]#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
        </cfloop>
        
        <!--- Remover o arquivo depois do processamento --->
        <cffile action="delete" file="#filePath#">
        
        <p>Upload e importação concluídos!</p>
    <cfelse>
        <p>Erro: O arquivo não foi encontrado no caminho especificado.</p>
    </cfif>
</cfif>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Check List PDI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v7">
        <link rel="stylesheet" href="assets/custom.css">
        <link rel="stylesheet" href="assets/css/style.css?v=11">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <body>
            <form action="pagina3.cfm" method="post" enctype="multipart/form-data">
                <input type="file" name="fileUpload" />
                <input type="submit" value="Upload" />
            </form>
    </body>
    </html>