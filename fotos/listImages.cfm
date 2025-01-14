<cfif structKeyExists(url, "folder")>
    <cfset folder = url.folder>
    <cfset folderPath = "C:/Users/jefferson.teixeira/Downloads/ArquivosExcel/" & folder & "/">
    <cfdirectory action="list" directory="#folderPath#" name="imageList" type="file">
    <cfoutput>
        #serializeJSON(imageList)#
    </cfoutput>
</cfif>
