<cfmail from="Jefferson Alves <jefferson.teixeira@caoamontadora.com.br>"  
    subject="Teste de envio de email #DateFormat(now(), 'dd/mm/yyyy')#"  
    to="Jefferson Alves <jefferson.teixeira@caoamontadora.com.br>"
    cc="Jefferson Alves <jefferson.teixeira@caoamontadora.com.br>"
    type="html">

<cfif isDefined("url.id_editar")>
    <cfquery name="consulta_editar" datasource="#BANCOSINC#">
        SELECT * 
        FROM INTCOLDFUSION.VEREAGIR2
        WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        ORDER BY ID DESC
    </cfquery>
    <cfdump var="#consulta_editar#">
</cfif>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <meta name="Generator" content="Microsoft Word 12 (filtered medium)">
    </head>
    <body>
        Bom Dia, <br><br>
        Testando envio de email<br><br>
        <cfif consulta_editar.recordCount gt 0>
            VIN: #consulta_editar.vin#<br><br>
        <cfelse>
            Nenhum resultado encontrado.<br><br>
        </cfif>
        #DateFormat(now(), 'dd/mm/yyyy')# - #TimeFormat(now(), 'HH:mm:ss')#<br><br>
    </body>
</html>
</cfmail>

<script>
alert("Email enviado com sucesso!! Aguarde alguns instantes e estará em sua caixa de entrada.");
self.location = '../cadastro_paradas.cfm';
</script>