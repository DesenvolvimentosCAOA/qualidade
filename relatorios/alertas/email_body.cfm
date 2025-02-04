<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfif isDefined("url.id_editar")>
        <cfquery name="consulta_editar" datasource="#BANCOSINC#">
            SELECT * 
            FROM INTCOLDFUSION.ALERTAS_8D
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
            ORDER BY ID DESC
        </cfquery>
    </cfif>
    <cfquery name="atualiza" datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.ALERTAS_8D
        SET              
            STATUS = 'EMAIL'
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>

<cfmail  from="Kennedy Dos Reis Rosario <kennedy.rosario@caoamontadora.com.br>"  subject="Alerta de Qualidade aberto no dia #DateFormat(now(), "dd/mm/yyyy")#"  
	to="Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>"
    cc="Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>"
    type="html">
	<html>
		<head>
		<meta http-equiv=Content-Type content="text/html; charset=iso-8859-1">
		<meta name=Generator content="Microsoft Word 12 (filtered medium)">
		<link rel="stylesheet" type="text/css" href="/qualidade/relatorios/alertas/assets/style_email.css">
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
            <div id="tableBody" class="table-container" style="margin-top:100px;">                
                <div class="form-container">
                    <h1 style="color: red;">Alerta de Qualidade - BODY SHOP</h1>
        <p>Olá,</p>
        <p style="font-size: 16px;">Identificamos uma <strong style="color:red;">FALHA GRAVE</strong> em que pode impactar diretamente a qualidade e/ou a segurança do produto final. Esta não conformidade exige <strong> AÇÃO IMEDIATA</strong> para contenção, análise e correção.</p>
        <p style="font-size:16px;">Solicitamos que todos os envolvidos estejam atentos às orientações que serão divulgadas e sigam rigorosamente os procedimentos estabelecidos para mitigar os impactos. Contamos com a colaboração de todos para garantir a qualidade e a confiabilidade do nosso processo produtivo.</p>
                    <table>
                        <tr style="text-align:center;color:red; font-size:36px;">
                            <td class="header" colspan="9">
                                8D - ALERTA DA QUALIDADE
                            </td>
                        </tr>
                        <tr>
                            <td rowspan="2" style="text-align:center; font-size:30px;">D1</td>
                            <td class="label-bold" colspan="1" style="text-align:center;color:red;">Nº DE CONTROLE:</td>
                            <td class="label-bold" colspan="1" style="text-align:center;color:red;">SETOR RESPONSÁVEL:</td>
                            <td class="label-bold" colspan="7" style="text-align:center;color:red;">RESPONSÁVEL PELA ABERTURA DO ALERTA:</td>

                        </tr>
                        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
                            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.ALERTAS_8D
                        </cfquery>
                        <th colspan="1" style="">
                            <input type="text" name="n_controle" style=" text-align:center;border:none;outline:none;" value="#consulta_editar.n_controle#" readonly>
                        </th>
                        <th colspan="1" style=" text-align:center;">
                            <input type="text" name="setor" id="setor" list="setores" style=" text-align:center;border:none;outline:none;" value="#consulta_editar.setor_responsavel#">
                        </th>
                        <th colspan="7" style="text-align:center;">
                            <input type="text" name="responsavel_abertura" style="text-align:center;border:none;outline:none;" value="#consulta_editar.resp_abertura#" readonly required>
                        </th>
                        
                        <tr>
                            <td colspan="7" style="border-top: 2px solid black;"></td>
                        </tr>


                        
                        <tr>
                            <td rowspan="7" style="text-align:center; font-size:30px;">D2</td>
                            <td class="label-bold" colspan="1" style="text-align:left;color:red;">BARREIRA:</td>
                            <td class="label-bold" colspan="1" style="text-align:center;color:red;">DATA DA OCORRÊNCIA:</td>
                            <td class="label-bold" colspan="1" style="text-align:center;color:red;">MODELO:</td>
                            <td class="label-bold" colspan="1" style="text-align:center;color:red;">VIN/BARCODE:</td>
                        </tr>
                        
                        <th colspan="1" style="text-align:left;">
                            <input type="text" name="barreira" id="barreira" list="barreiras" style="text-align:left;border:none;outline:none;" value="#consulta_editar.barreira#">
                        </th>
                        
                        <th colspan="1">
                            <input type="text" name="data_ocorrencia" style="border:none;outline:none;" value="#DateFormat(consulta_editar.data_ocorrencia, 'dd/mm/yyyy')#">
                        </th>

                        <th colspan="1" style="text-align:center;">
                            <input type="text" name="modelo" id="modelo" style="text-align:center;border:none;outline:none;" value="#consulta_editar.modelo#" readonly>
                        </th>
                        <th colspan="1" style="text-align:center;">
                            <input type="text" name="vin" placeholder="Vin/Barcode" style="text-align:center;border:none;outline:none;" value="#consulta_editar.vin#" readonly>
                        </th>
                        <tr>
                            <td class="label-bold" colspan="1" style="text-align:left;color:red;">PEÇA:</td>
                            <td class="label-bold" colspan="1" style="text-align:left;color:red;">POSIÇÃO:</td>
                            <td class="label-bold" colspan="1" style="text-align:left;color:red;">PROBLEMA:</td>
                        </tr>
                        <tr>
                            <td colspan="1" style="text-align:left;">
                                <input type="text" name="peca" placeholder="Peça" style="border:none;outline:none;text-align:left;" value="#consulta_editar.peca#" readonly>
                            </td>
                            <td colspan="1" style="text-align:left;">
                                <input type="text" name="posicao" placeholder="Posição" style="border:none;outline:none;text-align:left;" value="#consulta_editar.posicao#" readonly>
                            </td>
                            <td colspan="5" style="text-align:left;">
                                <input type="text" name="problema" placeholder="Problema" style="text-align:left;border:none;outline:none;" value="#consulta_editar.problema#" readonly>
                            </td>
                        </tr>
                        
                        <tr>
                        </tr>                               
                        <tr>
                            <td class="label-bold" colspan="1" style="text-align:left;color:red;">DESCRIÇÃO DA <br>NÃO CONFORMIDADE:</td>
                            <td colspan="8">
                                <input type="text" name="descricao" placeholder="DESCREVA DETALHADAMENTE A NÃO CONFORMIDADE" style="border:none;outline:none;" value="#consulta_editar.descricao_nc#" readonly>
                            </td>
                        </tr>
                    </table>
                    <tr>
                        <p style="font-size: 15px;">A equipe responsável deve preencher as demais etapas do 8D para a conclusão do alerta de qualidade. O prazo final para encerramento é de 7 dias corridos a partir da data de abertura.
                            Para acessar as evidências e realizar o preenchimento, utilize o sistema de gestão da qualidade pelo link:
                            <a href="http://cf3.caoamontadora.com.br:8503/qualidade/relatorios/index.cfm">Sistema de Gestão da Qualidade</a>!</p>
                    </tr>
                </div>
            </div>

            <p>Atenciosamente,</p>
            <p>Sistema de Gestão da Qualidade</p>
            <img src="cid:minhaImagem">
            <cfmailparam file="/qualidade/relatorios/img/assinatura.png" contentid="minhaImagem">
        </cfoutput>
		</body>
	</html>
</cfmail>

<script>
    alert("Email enviado com sucesso!!")
    self.location = '../alertas/d_principal.cfm'
</script>
