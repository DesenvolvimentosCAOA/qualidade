<cfinvoke method="inicializando" component="cf.ini.index">

  <!--- Verificando se está logado --->
  <cfif not isDefined("cookie.USER_APONTAMENTO_CL") or cookie.USER_APONTAMENTO_CL eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = 'login_rastreio/index.cfm'
    </script>
  </cfif>
  
  <!--- Exclusão múltipla --->
  <cfif structKeyExists(url, 'vinMultiplo') and url.vinMultiplo neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
      DELETE FROM INTCOLDFUSION.ferramenta_rastreio WHERE vin IN ('#replace(url.vinMultiplo, ",", "','", "all")#')
    </cfquery>
    <script>
          self.location = 'relatorio.cfm';
    </script>
  </cfif>

  <!--- Consulta de permissões --->
  <cfquery name="valida" datasource="sincprod">
    select usuario, permissao from intcoldfusion.usuarios_ferramenta_rastreio
    where lower(usuario) like lower('%#cookie.USER_APONTAMENTO_CL#%') 
  </cfquery>
  
  <!--- Definindo valores padrão para as datas --->
  <cfset filtroDataStart = (isDefined("form.filtroDataStart") and form.filtroDataStart neq "") ? form.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
  <cfset filtroDataEnd = (isDefined("form.filtroDataEnd") and form.filtroDataEnd neq "") ? form.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

  <!--- Consulta de registros --->
  <cfquery name="consulta" datasource="SINCPROD">
    SELECT * FROM intcoldfusion.ferramenta_rastreio
    WHERE 1=1
    <cfif isDefined("form.VIN") AND form.VIN NEQ "">
      AND UPPER(VIN) LIKE UPPER(<cfqueryparam value="%#form.VIN#%" cfsqltype="CF_SQL_VARCHAR">)
    </cfif>
    <cfif isDefined("form.MODELO") AND form.MODELO NEQ "">
      AND UPPER(MODELO) LIKE UPPER(<cfqueryparam value="%#form.MODELO#%" cfsqltype="CF_SQL_VARCHAR">)
    </cfif>
    <cfif isDefined("form.USUARIO") AND form.USUARIO NEQ "">
      AND UPPER(CAIXA) LIKE UPPER(<cfqueryparam value="%#form.USUARIO#%" cfsqltype="CF_SQL_VARCHAR">)
    </cfif>
    AND DATA_SAVE >= <cfqueryparam value="#filtroDataStart#" cfsqltype="CF_SQL_DATE">
    AND DATA_SAVE < <cfqueryparam value="#DateAdd('d', 1, filtroDataEnd)#" cfsqltype="CF_SQL_DATE">
    ORDER BY DATA_SAVE DESC
  </cfquery>
  
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Monitor Rastreio</title>
        <link rel="icon" type="image/png" href="assets/img/relatorio.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/style.css?v=5">
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div class="container mt-4">
          <!-- Seção de filtros -->
          <div class="card">
              <div class="card-body">
                  <h4 class="text-center mb-4">Filtros</h4>
                  <form id="form_meta" method="POST">
                      <cfoutput>
                          <div class="row mb-3">
                              <div class="col-md-4">
                                  <div class="form-group">
                                      <label class="form-label">VIN</label>
                                      <input type="text" class="form-control" name="VIN" placeholder="Informe o VIN" value="#isDefined('form.VIN') ? form.VIN : ''#">
                                  </div>
                              </div>
                              <div class="col-md-4">
                                  <div class="form-group">
                                      <label class="form-label">Modelo</label>
                                      <input type="text" class="form-control" name="MODELO" placeholder="Informe o Modelo" value="#isDefined('form.MODELO') ? form.MODELO : ''#">
                                  </div>
                              </div>
                              <div class="col-md-4">
                                  <div class="form-group">
                                      <label class="form-label">Usuário</label>
                                      <input type="text" class="form-control" name="USUARIO" placeholder="Informe o Usuário" value="#isDefined('form.USUARIO') ? form.USUARIO : ''#">
                                  </div>
                              </div>
                          </div>
                          <div class="row mb-3">
                              <div class="col-md-4">
                                  <div class="form-group">
                                      <label class="form-label">Data Inicial</label>
                                      <input type="date" class="form-control" name="filtroDataStart" value="#filtroDataStart#">
                                  </div>
                              </div>
                              <div class="col-md-4">
                                  <div class="form-group">
                                      <label class="form-label">Data Final</label>
                                      <input type="date" class="form-control" name="filtroDataEnd" value="#filtroDataEnd#">
                                  </div>
                              </div>
                          </div>
                          <div class="text-center">
                              <button type="submit" class="btn btn-primary">Filtrar</button>
                              <button type="button" id="exportButton" class="btn btn-primary m-2">Exportar Relatório</button>
                          </div>
                      </cfoutput>
                  </form>
              </div>
          </div>
      </div>

        <div class="container-scroller m-3">
            <div class="main-panel">
                <div class="card col-12 mt-2">
                    <div class="card-body">
                      <button type="button" class="btn btn-danger m-2" onclick="deletarSelecionados()">Deletar Selecionados</button>
                      <table id="tblStocks" class="table table-striped table-hover">
                          <thead class="align-middle">
                              <tr>
                                  <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                                  <th>Vin</th> 
                                  <th>Modelo</th>
                                  <th>Caixa</th>
                                  <th>Prateleira</th>
                                  <th>Usuário</th>
                                  <th>Data Realizada</th>
                              </tr>
                          </thead>
                          <tbody>
                              <cfloop query="consulta">
                                  <tr class="" style="background-color: #c1e2fc;font-weight: bold;">
                                      <cfoutput>
                                          <td><input type="checkbox" class="deleteCheckbox" value="#consulta.VIN#"></td>
                                          <td>#consulta.VIN#</td>
                                          <td>#consulta.MODELO#</td>
                                          <td>#consulta.Caixa#</td>
                                          <td>#consulta.Prateleira#</td>
                                          <td>#consulta.Usuario#</td>
                                          <td>#DateFormat(consulta.Data_save, "dd/mm/yyyy")#</td>
                                      </cfoutput>
                                  </tr>
                              </cfloop>
                          </tbody>
                      </table>
                    </div>
                </div>
            </div>
        </div>
            
     <!-- jQuery first, then Popper.js, then Bootstrap JS -->
     <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
     <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
     <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
     <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
     <script>
         // Gerando Excel da tabela
         document.getElementById('exportButton').addEventListener('click', function() {
             var table2excel = new Table2Excel();
             table2excel.export(document.querySelectorAll('#tblStocks'));
         });
     </script>
    </body>
    <script>
      function toggleAll(source) {
          let checkboxes = document.querySelectorAll('.deleteCheckbox');
          checkboxes.forEach(cb => cb.checked = source.checked);
      }

      function deletarSelecionados() {
          let checkboxes = document.querySelectorAll('.deleteCheckbox:checked');
          if (checkboxes.length === 0) {
              alert('Selecione pelo menos um item para excluir.');
              return;
          }

          let vinSelecionados = Array.from(checkboxes).map(cb => cb.value).join(',');

          let conf = confirm('Deseja realmente apagar os rastreios selecionados?');
          if (conf) {
              window.location.href = 'relatorio.cfm?vinMultiplo=' + vinSelecionados;
          }
      }

      function redirect() {
          window.location.href = 'cookie.cfm';
      }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</html>