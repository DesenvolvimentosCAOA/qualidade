<cfif structKeyExists(cookie, "USER_APONTAMENTO_FAI")>
    <cfcookie name="USER_APONTAMENTO_FAI" expires="now">
</cfif>
<cflocation url="/cf/auth/qualidade/buyoff_linhat/index.cfm" addtoken="false">
