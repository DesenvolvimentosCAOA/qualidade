<cfif structKeyExists(cookie, "USER_APONTAMENTO_PAINT")>
    <cfcookie name="USER_APONTAMENTO_PAINT" expires="now">
</cfif>
<cflocation url="/qualidade/buyoff_linhat/index.cfm" addtoken="false">

