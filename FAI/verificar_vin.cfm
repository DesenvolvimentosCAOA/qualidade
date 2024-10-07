<cfparam name="vin" default="">
<cfparam name="barreira" default="">

<cfquery name="verificaVIN" datasource="#BANCOSINC#">
    SELECT VIN, PROBLEMA
    FROM SISTEMA_QUALIDADE_FAI 
    WHERE VIN = <cfqueryparam value="#vin#" cfsqltype="CF_SQL_VARCHAR">
    AND BARREIRA = <cfqueryparam value="#barreira#" cfsqltype="CF_SQL_VARCHAR">
</cfquery>

<cfif verificaVIN.recordCount GT 0>
    <cfset problemaExiste = 0>
    <cfset problemaNulo = 0>
    
    <cfloop query="verificaVIN">
        <cfif verificaVIN.PROBLEMA is not "">
            <cfset problemaExiste = 1>
        </cfif>
        <cfif verificaVIN.PROBLEMA is "">
            <cfset problemaNulo = 1>
        </cfif>
    </cfloop>

    <cfif problemaExiste AND problemaNulo>
        EXISTE_COM_CONDICAO
    <cfelseif problemaExiste AND problemaNulo EQ 0 AND form.problema NEQ "">
        PERMITIR_ENVIO
    <cfelseif problemaExiste AND problemaNulo EQ 0>
        PROBLEMA_EXISTE_FORM_NULO
    <cfelse>
        EXISTE
    </cfif>
<cfelse>
    NAO_EXISTE
</cfif>
