<cfmail  from="Jefferson Alves <jefferson.teixeira@caoamontadora.com.br>"  subject="Teste de envio de email #DateFormat(now(), "dd/mm/yyyy")#"  
	to="Kennedy <kennedy.rosario@caoamontadora.com.br>"
    cc="Jefferson Alves <jefferson.teixeira@caoamontadora.com.br>"
    type="html">

	<html>
		<head>
		<meta http-equiv=Content-Type content="text/html; charset=iso-8859-1">
		<meta name=Generator content="Microsoft Word 12 (filtered medium)">
		
		</head>
             
            Bom Dia, <br><br>

            Testando envio de email<br><br>
            
            <br><br>


        <br>
		  	#DateFormat(now(), "dd/mm/yyyy")# - #TimeFormat(now(), "HH:mm:ss")#
		<br>
		<br>
		</body>
	</html>
</cfmail>

<script>
    alert("Email enviado com sucesso!! Aguarde alguns instantes e estará em sua caixa de entrada.")
    self.location = '../cadastro_paradas.cfm'
</script>