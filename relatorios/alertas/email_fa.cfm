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

    <cfquery name="login" datasource="#BANCOSINC#">
        SELECT USER_NAME, USER_SIGN, USER_EMAIL FROM INTCOLDFUSION.REPARO_FA_USERS
        WHERE USER_NAME = '#cookie.user_apontamento_fa#'
    </cfquery>

<cfmail  from="#login.USER_SIGN# <#login.USER_EMAIL#"  subject="Alerta de Qualidade - Nº #consulta_editar.n_controle# aberto no dia #DateFormat(now(), "dd/mm/yyyy")#"  
	to="Michael Jonathan Camargo De Oliveira <michael.oliveira@caoamontadora.com.br>,Ricardo Fernandes Silva <ricardo.fernandes@caoamontadora.com.br>,Vinicius Gomes Silva <vinicius.gsilva@caoamontadora.com.br>,Reginaldo Pires Dos Santos <reginaldo.santos@caoamontadora.com.br>,Sinomar Rodrigues Da Silva Junior <sinomar.junior@caoamontadora.com.br>,Jonathan Saint Clair Costa Santos <jonathan.costa@caoamontadora.com.br>,Matheus Ferreira Rodrigues <matheus.frodrigues@caoamontadora.com.br>,Matheus Pereira Araujo <matheus.araujo@caoamontadora.com.br>,Davidson Gomes Ribeiro Roquete <davidson.roquete@caoamontadora.com.br>,Rian Guilherme Silva Cardoso <rian.cardoso@caoamontadora.com.br>,Camila Pereira De Assuncao <camila.assuncao@caoamontadora.com.br>"
    cc="Lucas Martins Borges Silva <lucas.silva@caoamontadora.com.br>,Luciano Ferreira De Almeida <luciano.ferreira@caoamontadora.com.br>,Sidclay Rodrigues Mota Junior <sidclay.junior@caoamontadora.com.br>,Francisco Fabricio Alves De Jesus <francisco.jesus@caoamontadora.com.br>,Cristiano Rodrigues Da Silva <cristiano.silva@caoamontadora.com.br>,Anderson Abadio Soares De Brito <anderson.brito@caoamontadora.com.br>,Jefferson Alves Teixeira <jefferson.teixeira@caoamontadora.com.br>,Kennedy Dos Reis Rosario <kennedy.rosario@caoamontadora.com.br>,Joao Cleber Rodrigues Da Costa <joao.ccosta@caoamontadora.com.br>,Lincon Afonso Trentin <lincon.trentin@caoamontadora.com.br>,Lucas Correa Leal <lucas.leal@caoamontadora.com.br>,Rafaga De Oliveira Lima Correa <rafaga.correa@caoamontadora.com.br>,Sullivan Moreira Da Costa <sullivan.costa@caoamontadora.com.br>"
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
                    <h1 style="color: red;">Alerta de Qualidade - FINAL ASSEMBLY</h1>
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
                            <td class="label-bold" colspan="1">DESCRIÇÃO DA NÃO CONFORMIDADE:</td>
                            <td colspan="8">
                                <textarea name="descricao" readonly style="width: 100%; height: 100px; resize: vertical;">#consulta_editar.descricao_nc#</textarea>
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