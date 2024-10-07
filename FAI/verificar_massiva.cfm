<cfif isDefined("url.vin") and url.vin neq "">
    <cfquery name="verificar_massiva" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS count
        FROM INTCOLDFUSION.MASSIVA_FAI
        WHERE UPPER(VIN) = UPPER('#url.vin#')
    </cfquery>
    
    <cfset exists = (verificar_massiva.count GT 0)>
    
    <cfcontent type="application/json">
    <cfoutput>#SerializeJSON({"exists": exists})#</cfoutput>
</cfif>
