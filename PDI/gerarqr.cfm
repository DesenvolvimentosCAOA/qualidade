<cfdocument format="PDF" marginBottom="0" saveAsName="#url.ID#.pdf" marginLeft="0" marginRight="0" marginTop="0" backgroundvisible="yes" scale="80">

		<html>
			<head>
			</head>
			<body>
				<style type="text/css">
                    .tg  {border-collapse:collapse;border-spacing:0;border:none;}
                    .tg td{font-family:Arial, sans-serif;font-size:20px;padding:7px 4px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
                    .tg th{font-family:Arial, sans-serif;font-size:20px;font-weight:normal;padding:7px 4px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
                    .tg .tg-bceo{border-color:#000000;text-align:right;vertical-align:top}
                    .tg .tg-mcqj{font-size:20px;border-color:#000000;text-align:left;vertical-align:top}
                    .tg .tg-absd{font-weight:bold;font-size:20px;border-color:#000000;text-align:left;
                        .tg .tg-absd2{font-weight:normal;font-size:16px;border-color:#000000;text-align:left;
                    vertical-align:top}				.tg .tg-3jsp{font-size:14px;border-color:#000000;
                        .tg .tg-3jsp2{font-size:20px;border-color:#000000;text-align:center;width:400px}
                    .tg .tg-4n8x{font-size:20px;border-color:#000000;text-align:center;vertical-align:top}
                </style>
				<cfoutput>
					<table class="tg">
						<!---  <tr>
						  <td>
							 <a class="tg-absd">#url.ID#</a> <br/><a class="tg-absd">DATA: #url.DATA#</a><br><a class="tg-3jsp">PECA: #url.PECA#</a> <br/><a class="tg-absd2">STATUS:#url.STATUS#</a>
						  </td>
						  <td> --->				
							<cfinvoke component="cf.recursos.QRCode.qrcode" method="GerarQRCode" returnVariable="image">
								<cfinvokeargument  name="info"  value="ID: #url.ID# DATA:#url.USER_DATA# PECA: #url.PECA# STATUS:#url.STATUS#">
							</cfinvoke>

                                <cfimage action="writeToBrowser" source="#image#" format="png" overwrite="true" quality="1">
						  </td>
						  </tr>
					</table>
				</cfoutput>	
			</body>
		</html>			
</cfdocument>