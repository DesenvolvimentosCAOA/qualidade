<!---Importação de metas mensais via arquivo excel--->
<button type="button" onclick="window.location.href='../cadastrar.cfm'" class="btn btn-primary m-2">Retornar</button>
				<style type="text/css">
					table.tableizer-table {
						font-size: 12px;
						border: 1px solid #CCC; 
						font-family: Arial, Helvetica, sans-serif;
						width: 100%;
						text-align:center;
					} 
					.tableizer-table td {
						padding: 4px;
						margin: 3px;
						border: 1px solid #CCC;
					}
					.tableizer-table th {
						background-color: #104E8B; 
						color: #FFF;
						font-weight: bold;
					}
				</style>
				<div class="card-body">
					<h4 class="page-title">Importação de URLs - Layout Padrão</h4><br>
					<form id="form3" name="form3" action="query.cfm" method="post" enctype="multipart/form-data">
						<input type="file" name="file" id="arquvivo2">
						<button class="btn btn-primary" type="submit" value="salvar" id="dropdownsorting">
							<i class="mdi mdi-content-save text-success"></i>Enviar
						</button>
					</form>

					Instruções de uso:<br>
					 - Carregar uma planilha em excel (.XLS, .XLSX ou .CSV) <br> <br>na disposição do exemplo abaixo:<br><br>

					<table class="tableizer-table">
						<thead>
							<tr>
							<th>Seq</th> 
							<th>Data De Revisão IT</th>
							<th>Área Produtiva</th>
							<th>IT</th>
							<th>Título de Operação</th> 
							<th>Part Number</th>
							<th>Part Name</th>
							<th>Versão</th>
							<th>Estação</th> 
							<th>Lado</th>
							<th>Grupo de Envio</th>
							<th>Range</th>
							<th>T1E 1.6 + ADAS</th> 
							<th>T1E 1.5 + 48V + ADAS</th>
							<th>XXXX</th>
							<th>XXXX</th>
							<th>Status/Observação</th>
							</tr>
						</thead>
						<tbody>
							<tr>
							<td>1</td>	
							<td>10/10/2024</td>	
							<td>BODY SHOP</td>	
							<td>CAOA0132T1E</td> 
							<td>PRÉ PARALAMA</td>
							<td>501004738AA</td>
							<td>CAIXA DE RODA DIANTEIRA LH</td>
							<td>COMUM</td>
							<td>OP10A</td> 
							<td>-</td>
							<td>ABASTECIMENTO BODY SHOP</td>
							<td></td>
							<td>1</td> 
							<td>2</td>
							<td>15</td>
							<td>16</td>
							<td>Alteração de engenharia de acordo com o lote 1201</td>
							</tr>
						</tbody>
					</table>
						
					</table>

				</div>
			 </div>
		  </div>
	   </div>