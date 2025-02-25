<cfinvoke  method="inicializando" component="cf.ini.index">

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
  
  <!--- Consulta de registros --->
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
  
          <button type="button" onclick="window.location.href='relatorio_gerar.cfm'" class="btn btn-primary m-2">Exportar Relatório</button>
          <cfif valida.permissao eq 2>
            <button type="button" onclick="window.location.href='cadastro.cfm'" class="btn btn-success m-2">Usuários</button>
          </cfif>
          <button id="expireCookieBtn" type="button" onclick="redirect()" class="btn btn-danger m-2">Sair</button>
  
          <h4 class="text-center mt-2">Filtros</h4>
  
          <div class="container col-10 mt-5">
              <form id="form_meta" method="POST"><cfoutput>
                  <div class="row mb-4">
                    <div class="col col-4">
                      <div class="form-group">
                        <label class="form-label">VIN</label>
                        <input type="text" class="form-control" name="VIN" placeholder="Informe o VIN"/>
                      </div>
                    </div>
                    <div class="col col-4">
                      <div class="form-group">
                        <label class="form-label">Modelo</label>
                        <input type="text" class="form-control" name="MODELO" placeholder="Informe o Modelo"/>
                      </div>
                    </div>
                    <div class="col col-4">
                      <div class="form-group">
                        <label class="form-label">Usuário</label>
                        <input type="text" class="form-control" name="USUARIO" placeholder="Informe o Usuário"/>
                      </div>
                    </div>
                  </div>
                  <div class="row mb-4">
                    <button type="submit" class="btn btn-primary">Filtrar</button>
                  </div>
              </form></cfoutput>
  
          <div class="container-scroller m-3">
              <div class="main-panel">
                  <div class="card col-12 mt-2">
                      <div class="card-body">
                        <button type="button" class="btn btn-danger m-2" onclick="deletarSelecionados()">Deletar Selecionados</button>
                        <table class="table table-striped table-hover">
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
                                            <td>#consulta.Data_save#</td>
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
  