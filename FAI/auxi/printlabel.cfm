<cftry>
    <!-- Executa o arquivo .bat -->
    <cfexecute 
        name="Y:\PBEV_LABEL\2024\PVT204000-T1E-SPORT\print.bat" 
        timeout="60" 
        variable="output">
    </cfexecute>

    <!-- Mensagem de sucesso -->
    <cfset message = "Etiqueta enviada para a impressora com sucesso! Saída: #output#">
    <cfcatch type="any">
        <!-- Mensagem de erro -->
        <cfset message = "Erro ao enviar etiqueta: #cfcatch.message#">
    </cfcatch>
</cftry>

<!-- Retorna a mensagem -->
<cfoutput>#message#</cfoutput>
