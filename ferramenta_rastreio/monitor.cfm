<cfinvoke  method="inicializando" component="cf.ini.index">

	<cfquery name="busca" datasource="#BANCOSINC#">
	
	select * from intcoldfusion.seq_truck_hr
	WHERE data_alt > TO_DATE(sysdate, 'DD/MM/YYYY')-1
	order by estacao_4, seq 
	
	</cfquery>
	
	
	<cfif isDefined("url.barcode")>
	
	<cfquery name="update" datasource="#BANCOSINC#">
	
	UPDATE intcoldfusion.seq_truck_hr
	SET ESTACAO_4 = 2
	WHERE ESTACAO_4 = 0
	AND BARCODE = #url.barcode#
	AND ID = #url.id#
	
	</cfquery>
	
	<meta http-equiv="refresh" content="1;url=monitor.cfm">
	
	<cfelse>
	</cfif>
	
	<html lang="pt">
		<head>
		   <!-- Required meta tags -->
		   <meta charset="utf-8">
		   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		   <title>CAOATEC - Monitor </title>
	
		   <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
		   <link rel="shortcut icon" width="500" height="600" href="/cf/assets/images/favicon.png" />
		   
			<!---  Boostrap  --->
			<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
	
			<style>
				.total{
					font-weight: bold; 
					background: #d4ffff
				}
	
				.btn {
				border-radius: 5px;
				background-color: green;
				color: white;
				padding: 10px 20px; /* Você pode ajustar o preenchimento (padding) para definir a altura e largura */
				text-align: center;
				text-decoration: none;
				display: inline-block;
				width: 250px;
				font-size: 16px;
				}	
			</style>
		</head>
	
		<body>
		<cfoutput>
			<div class="container-scroller m-3">
				<!-- partial -->
				<div class="main-panel">
	
					  <!-- Page Title Header Starts-->
					  <div class="row page-title-header">
						 <div class="col-12">
							<cfoutput>
							<img id="logo" src="#raizWeb#/cf/assets/images/CAOATEC.png" alt="logo" style="height:10%;"/>
							</cfoutput>
							<h3 class="page-title">Monitor de Sequenciamento</h4>
						 </div>
					  </div>
					  
					  <div class="card col-12 mt-3">
						<div class="card-body">
						<table class="table table-striped table-hover">
							<thead>
							<tr>
								<th>Sequência</th>
								<th>Barcode</th>
								<th>Modelo</th>
								<th>Data Apontada</th>
								<th>Kit 1</th>
								<th>Kit 2</th>
								<th>Status</th>
								<th>Gravação</th>
							</tr>
							</thead>
							<tbody>
							<cfloop query="busca">
								<tr class="text-right">
									<td class="text-center">#busca.seq#</td>
									<td class="text-center">#busca.barcode#</td>
									<td class="text-center">#busca.modelo#</td>
									<td class="text-center">#busca.data_alt#</td>
									<td class="text-center">#busca.kit_1#</td>
									<td class="text-center">#busca.kit_2#</td>
									<td style="color:<cfif busca.ESTACAO_4 eq 2>green;<cfelse>red;</cfif>" class="text-center"><cfif busca.ESTACAO_4 eq 2>OK<cfelse>Aguardando</cfif></td>
									<td style="color:<cfif busca.ESTACAO_4 eq 2>red;<cfelse>green;</cfif>" class="text-center"><cfif busca.ESTACAO_4 eq 2><button value="Confirmar" type="submit" id="btn" name="button" disabled>OK</button><cfelse><button onclick="confirmar(<cfif busca.seq eq ""><cfelse>#busca.id#, '#busca.seq#', #busca.barcode#</cfif>);" value="Confirmar" type="submit" id="btn" name="button">Confirmar</button></cfif></td>
							</cfloop>
							</tbody>
						</table>
						</div>
					</div>
				</div>
			 </div>
			</cfoutput>
	
	<script>
	
	// Enviar informações  
	const confirmar = (id, seq, barcode) => {
		conf = confirm('Deseja confirmar a sequência '+ '('+ seq + ')');
		if(conf == true){
		self.location = 'monitor.cfm?barcode='+barcode+'&id='+id+'&seq='+seq
		}
	}
	
	</script>
	
		</body>
	 </html>
	
	
	<meta http-equiv="refresh" content="30; URL=monitor.cfm"/>
	
	