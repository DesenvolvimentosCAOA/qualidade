<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
</cfquery>

<cfif structKeyExists(url, "data_registro")>
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.treinamentos
    </cfquery>

    <!--- Inserir dados na tabela --->
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.treinamentos (ID, DATA, NOME, TREINAMENTO)
        VALUES(
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
            <cfqueryparam value="#UCase(LOGIN.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase("Lançamento Ver & Agir")#" cfsqltype="CF_SQL_VARCHAR">
        )
    </cfquery>
    <!--- Redirecionar após a inserção --->
    <cflocation url="indicador.cfm">
</cfif>