<cfquery name="queryResult" datasource="#BANCOSINC#">
    SELECT * FROM intcoldfusion.ferramenta_rastreio
</cfquery>

<!--- Caminho do arquivo Excel --->
<cfset filePath = expandPath('auxi/docs/relatorio.xlsx')>

<!--- Criação do arquivo Excel usando cfspreadsheet --->
<cfspreadsheet action="write"
               filename="#filePath#"
               query="queryResult"
               sheetname="Relatorio"
               overwrite="true">

<cfoutput>
    <p>Relatorio gerado com sucesso.</p>
    <a href="auxi/docs/relatorio.xlsx" target="_blank">Baixar aqui</a><br><br>
    <button onclick="window.location.href='relatorio.cfm'">Retornar</button>
</cfoutput>
