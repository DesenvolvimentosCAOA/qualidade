<cfif structKeyExists(cookie, "USER_APONTAMENTO_PDI")>
    <cfcookie name="USER_APONTAMENTO_PDI" expires="now">
</cfif>
<cflocation url="/qualidade/buyoff_linhat/index.cfm" addtoken="false">
