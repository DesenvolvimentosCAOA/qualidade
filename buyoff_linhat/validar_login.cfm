<!--- <cfdump  var="#form#"> ESSA É A VERSÃO PARA ACESSAR O SITE DO SMALL PCP
<cfinvoke method="inicializando" component="cf.ini.index">
<cfif isDefined("form.small_login")>
    <cfquery name="validausuario" datasource="#BANCOSINC#">
        select USER_ID, USER_NAME, USER_PASSWORD, USER_LEVEL, USER_SIGN from reparo_fa_users 
        where UPPER(USER_NAME)= UPPER('#form.small_login#')
        and USER_PASSWORD = UPPER('#form.small_senha#')
        and (SHOP  = 'SMALL' OR USER_LEVEL = 'G')
    </cfquery>
<!---     <cfdump  var="#validausuario#"> --->
   
    <cfif validausuario.recordcount GT 0>
             <cfcookie  name="user_apontamento_small" value="#FORM.small_login#">
<!---              <script>window.location = "/cf/auth/home/login/pcp_small_hom/saidas.cfm"</script> --->
        <meta http-equiv="refresh" content="0; URL=/cf/auth/home/login/pcp_small/saidas.cfm"/>
            <cfelse>
                <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
    </cfif>
           
</cfif> --->


<!----ESSA VERSÃO ACESSA O SITE DE GESTÃO DA QUALIDADE ---->
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfif isDefined("form.small_login")>
        <cfquery name="validausuario" datasource="#BANCOSINC#">
            select USER_ID, USER_NAME, USER_PASSWORD, USER_LEVEL, USER_SIGN from reparo_fa_users 
            where UPPER(USER_NAME)= UPPER('#form.small_login#')
            and USER_PASSWORD = UPPER('#form.small_senha#')
            and (SHOP  = 'SMALL' OR USER_LEVEL = 'G')
    </cfquery>
    <!---     <cfdump  var="#validausuario#"> --->
       
        <cfif validausuario.recordcount GT 0>
                 <cfcookie  name="user_apontamento_small" value="#FORM.small_login#">
                <meta http-equiv="refresh" content="0; URL=/cf/auth/qualidade/SMALL/small.cfm"/>
                <cfelse>
                    <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
        </cfif>


<!--- <cfdump  var="#form#" > --->
<cfif isDefined("form.PAINT_SHOP_LOGIN")>
    <cfquery name="validausuario" datasource="#BANCOSINC#">
        SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
        WHERE upper(USER_NAME) = UPPER('#form.PAINT_SHOP_LOGIN#')
        AND USER_PASSWORD = UPPER('#form.PAINT_SHOP_SENHA#')
        AND (SHOP = 'PAINT' OR USER_LEVEL = 'G')
    </cfquery>
   
<!---    <CFDUMP VAR="#validausuario#"> --->
    <cfif validausuario.recordcount GT 0>
        <cfcookie name="user_apontamento_paint" value="#FORM.PAINT_SHOP_LOGIN#">
        <cfcookie name="user_level_paint" value="#validausuario.USER_LEVEL#">
        <cfif validausuario.user_level eq "R">
            <meta http-equiv="refresh" content="0; URL=Reparo.cfm"/>
        <cfelse>
            <meta http-equiv="refresh" content="0; URL=SELECAO_PAINT.cfm"/>
        </cfif>
    <cfelse>
        <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
           </cfif>
</cfif>





<!--adaptar para FA --> 


<!--- <cfdump  var="#form#" > --->
<cfif isDefined("form.final_assembly_login")>
    <cfquery name="validausuario" datasource="#BANCOSINC#">
        SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
        WHERE upper(USER_NAME) = UPPER('#form.final_assembly_login#')
        AND USER_PASSWORD = UPPER('#form.final_assembly_senha#')
        AND (SHOP = 'FA' OR USER_LEVEL = 'G')
    </cfquery>
   
<!---    <CFDUMP VAR="#validausuario#"> --->
    <cfif validausuario.recordcount GT 0>
        <cfcookie name="user_apontamento_fa" value="#FORM.final_assembly_login#">
            <meta http-equiv="refresh" content="0; URL=/cf/auth/qualidade/buy_off_T/fa_selecionar_buy_off.cfm"/>
        <cfelse>
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
           </cfif>
</cfif>
