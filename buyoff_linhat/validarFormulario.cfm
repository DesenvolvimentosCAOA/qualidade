<cfquery name="defeitos" datasource="#BANCOSINC#">
    SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
    WHERE SHOP = 'PAINT'
    ORDER BY DEFEITO
</cfquery>

<cfset problema = ucase(trim(FORM.problema))>
<cfset defeitoValido = false>

<cfloop query="defeitos">
    <cfif problema EQ ucase(trim(defeitos.DEFEITO))>
        <cfset defeitoValido = true>
        <cfbreak>
    </cfif>
</cfloop>

<cfif NOT defeitoValido>
    <cfoutput>
        <script>
            alert('Por favor, selecione um problema válido da lista.');
            history.back();
        </script>
    </cfoutput>
<cfelse>
    <!-- Processar o formulário normalmente -->
    <cfoutput>
        <p>Formulário enviado com sucesso!</p>
        <script>
            history.back();
        </script>
    </cfoutput>
</cfif>