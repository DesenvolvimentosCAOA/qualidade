<cfif structKeyExists(cookie, "USER_APONTAMENTO_PAINT")>
    <cfcookie name="USER_APONTAMENTO_PAINT" expires="now">
</cfif>
<cflocation url="index.cfm" addtoken="false">

