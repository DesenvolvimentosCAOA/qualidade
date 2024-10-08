<cfinvoke  method="inicializando" component="cf.ini.index">

<cfdump  var="#form#">
<cfquery name="inserir" datasource = "#BANCOSINC#">
    insert into intcoldfusion.reparo_fa_users 
    select max (user_id)+1, '#LCase(CADASTRO_USUARIO)#', '#cadastro_SENHA#', '#cadastro_NIVEL_ACESSO#', '#UCase(cadastro_NOME)#', SYSDATE-1 ,'#cadastro_SETOR#' from intcoldfusion.reparo_fa_users
</cfquery>

<!-- Redireciona o usuário para a página de confirmação -->
<cflocation url="/qualidade/buyoff_linhat/index.cfm" addtoken="no">

<!-- Redireciona o usuário de volta para a página anterior após alguns segundos -->
<script>
    setTimeout(function() {
        window.history.back();
    }, 3000); // Redireciona após 3 segundos, você pode ajustar o tempo conforme necessário
</script>
