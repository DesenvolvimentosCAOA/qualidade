<cfmail  from="Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>"  subject="Monitoramento de Produção do dia #DateFormat(now(), "dd/mm/yyyy")#"  
	to="Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>"
    cc="Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>"
    type="html">


	<html>
		<head>
		<meta http-equiv=Content-Type content="text/html; charset=iso-8859-1">
		<meta name=Generator content="Microsoft Word 12 (filtered medium)">
		
		</head>
            
        <cfif isDefined("url.id_editar")>
            <cfquery name="consulta_editar" datasource="#BANCOSINC#">
                SELECT * 
                FROM INTCOLDFUSION.ALERTAS_8D
                WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
                ORDER BY ID DESC
            </cfquery>
        </cfif>

        <cfoutput>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <td rowspan="1" style="text-align:center; font-size:30px;">D2</td>
                    <td class="label-bold" colspan="1">DESCRIÇÃO DA NÃO CONFORMIDADE:</td>
                    <td colspan="7">
                        #consulta_editar.descricao_nc#
                    </td>
                </tr>
            </table>
        </cfoutput>
            
		</body>
	</html>
</cfmail>

<script>
    alert("Email enviado com sucesso!! Aguarde alguns instantes e estará em sua caixa de entrada.")
    self.location = '../pag.cfm'
</script>