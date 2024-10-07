<cfif structKeyExists(cookie, "USER_APONTAMENTO_FA")>
    <cfcookie name="USER_APONTAMENTO_FA" expires="now">
</cfif>
<cflocation url="/cf/auth/qualidade/buyoff_linhat/index.cfm" addtoken="false"> 
