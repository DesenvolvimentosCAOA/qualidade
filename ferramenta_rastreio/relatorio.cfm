<cfinvoke  method="inicializando" component="cf.ini.index">

<!--- Verificando se está logado --->
<cfif not isDefined("cookie.USER_APONTAMENTO_CL") or cookie.USER_APONTAMENTO_CL eq "">
  <script>
      alert("É necessario autenticação!!");
      self.location = 'login_rastreio/index.cfm'
  </script>
</cfif>

<cfif structKeyExists(url, 'vin') and url.vin neq "">
  <cfquery name="delete" datasource="#BANCOSINC#">
    DELETE FROM INTCOLDFUSION.ferramenta_rastreio WHERE vin = '#url.vin#'
  </cfquery>
  <script>
        self.location = 'relatorio.cfm';
  </script>
</cfif>

<cfquery name="valida" datasource="sincprod">

select usuario, permissao from intcoldfusion.usuarios_ferramenta_rastreio
where lower(usuario) like lower('%#cookie.USER_APONTAMENTO_CL#%') 

</cfquery>

<!---  Consultar paradas do dia  --->
<cfquery name="consulta" datasource="SINCPROD">
  select * from intcoldfusion.ferramenta_rastreio
  <cfif isDefined("form.VIN") AND form.VIN NEQ "">
  WHERE UPPER(VIN) LIKE UPPER('%#form.VIN#%')
  </cfif>
  <cfif isDefined("form.MODELO") AND form.MODELO NEQ "">
  WHERE UPPER(MODELO) LIKE UPPER('%#form.MODELO#%')
  </cfif>
  <cfif isDefined("form.USUARIO") AND form.USUARIO NEQ "">
  WHERE UPPER(USUARIO) LIKE UPPER('%#form.USUARIO#%')
  </cfif>
  ORDER BY DATA_SAVE DESC
</cfquery>

<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>Monitor Rastreio</title>
        <!-- plugins:css -->
        <link rel="icon" type="image/png" href="assets/img/relatorio.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
	      <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
        <!---  Boostrap  --->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">

        <link rel="stylesheet" href="assets/css/style.css?v=5">
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>

        <button type="button" onclick="window.location.href='relatorio_gerar.cfm'" form="form_meta" class="btn btn-primary m-2">Exportar Relatório</button>
        <cfif valida.permissao eq 2><button type="button" onclick="window.location.href='cadastro.cfm'" form="form_meta" class="btn btn-success m-2">Usuários</button><cfelse></cfif>
        <button id="expireCookieBtn" type="button" onclick="redirect()" form="form_meta" class="btn btn-danger m-2">Sair</button>

        <h4 class="text-center mt-2">Filtros</h4>

        <div class="container col-10 mt-5">
            <form id="form_meta" method="POST"><cfoutput>

                <!-- Tipo, data e turno -->
                <div class="row mb-4">
                  
                  <div class="col col-4">
                    <div class="form-group">

                      <label class="form-label" for="formEstacao">VIN</label>
                      <input type="text" class="form-control" name="VIN" id="formEstacao" placeholder="Informe o VIN"/>
                    </div>
                  </div>

                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formEstacao">Modelo</label>
                      <input type="text" class="form-control" name="MODELO" id="partNumber" placeholder="Informe o Modelo"/>
                    </div>
                  </div>

                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formEstacao">Usuário</label>
                      <input type="text" class="form-control" name="USUARIO" id="partName" placeholder="Informe o Usuário"/>
                    </div>
                  </div>

                </div>

                <!-- Horario, Estação, Linha -->
                <div class="row mb-4">
                  <button type="submit" form="form_meta" class="btn btn-primary">Filtrar</button>
                </div>

            </form></cfoutput>

		<div class="container-scroller m-3">
			<!-- partial -->
			<div class="main-panel">

				  <!-- Page Title Header Starts-->
				  <div class="row page-title-header">
					 <div class="col-12">
						   
					 </div>
				  </div>
				  
				  <div class="card col-12 mt-2">
					<div class="card-body">
					<table class="table table-striped table-hover">
						<thead class="align-middle">
						<tr>
							<th>Vin</th> 
							<th>Modelo</th>
              <th>Caixa</th>
              <th>Prateleira</th>
							<th>Usuário</th>
							<th>Data Realizada</th>
              <th scope="col"><i class="mdi mdi-delete bt_deletar"></i></th>
						</tr>
						</thead>
						<tbody>
            <cfloop query="consulta">
							<tr class="" style="background-color: #c1e2fc;font-weight: bold;">
								<cfoutput>
                  <td>#consulta.VIN#</td>
                  <td>#consulta.MODELO#</td>
                  <td>#consulta.Caixa#</td>
                  <td>#consulta.Prateleira#</td>
                  <td>#consulta.Usuario#</td>
                  <td>#consulta.Data_save#</td>
                  <th scope="row"><i onclick="deletar('#consulta.vin#');" class="mdi mdi-delete-outline bt_deletar"></i></th>
								</cfoutput>
							</tr>
            </cfloop>

						</tbody>
					</table>
					</div>
				</div>
			</div>
		 </div>

    </body>

    <script>

      //Deletar rastreio 
          function deletar (vin) {
            conf = confirm('Deseja realmente apagar esse rastreio: ' + vin + '?');
            if(conf == true){
            self.location = 'relatorio.cfm?vin='+vin
          }
        }

      // Remover cookie de login
      function expire_cookie() {
                var data = new Date(2010,0,01);
                  // Converte a data para GMT
                  data = data.toGMTString();
               document.cookie = 'USER_PCP_PARADAS_ADM=; expires=' + data + '; path=/';
               self.location = 'cadastrar.cfm';
      }
      
      function redirect() {
            // Redirecionar para outra página
            window.location.href = 'cookie.cfm';
        }
      function importLocal() {
            // Redirecionar para outra página
            window.location.href = 'auxi/import.cfm';
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>


