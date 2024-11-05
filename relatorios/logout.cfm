<cfif structKeyExists(cookie, "USER_APONTAMENTO_FA")>
    <cfcookie name="USER_APONTAMENTO_FA" expires="now">
</cfif>

<cfif structKeyExists(cookie, "USER_APONTAMENTO_FAI")>
    <cfcookie name="USER_APONTAMENTO_FAI" expires="now">
</cfif>

<cfif structKeyExists(cookie, "USER_APONTAMENTO_PAINT")>
    <cfcookie name="USER_APONTAMENTO_PAINT" expires="now">
</cfif>

<cfif structKeyExists(cookie, "USER_APONTAMENTO_BODY")>
    <cfcookie name="USER_APONTAMENTO_BODY" expires="now">
</cfif>

<cfif structKeyExists(cookie, "USER_APONTAMENTO_PDI")>
    <cfcookie name="USER_APONTAMENTO_PDI" expires="now">
</cfif>

<cfif structKeyExists(cookie, "USER_APONTAMENTO_VER")>
    <cfcookie name="USER_APONTAMENTO_VER" expires="now">
</cfif>

<cflocation url="/qualidade/buyoff_linhat/index.cfm" addtoken="false">
