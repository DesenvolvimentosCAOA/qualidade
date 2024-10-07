<cfinvoke  method="inicializando" component="cf.ini.index">

<!--- Verificando se está logado --->
<cfif not isDefined("cookie.user_lotes") or cookie.user_lotes eq "">
  <script>
      alert("É necessario autenticação!!");
      self.location = 'auxi/login.cfm'
  </script>
</cfif>

<!--- Trazer modelos do hora a hora --->
<cfinvoke  component="cf.dashboard-novo.horaAhora._consultaEntrada" method="horaAhora" returnvariable="horaAhora">

  <cfquery dbtype="query" name="modelos">
        
    select distinct produ modelo from horaAhora

  </cfquery>


<!---  Consulta --->
<cfquery name="consulta" datasource="#BANCOSINC#">
  SELECT *
  FROM INTCOLDFUSION.KANBAN_LOTES 
  WHERE 1 = 1 
  <cfif isDefined("url.filtroPredio") and url.filtroPredio neq "">
    AND UPPER(PREDIO) LIKE UPPER('%#url.filtroPredio#%')
  </cfif>
  <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
    AND UPPER(MODELO) LIKE UPPER('%#url.filtroModelo#%')
  </cfif>
  ORDER BY PREDIO, MODELO, ID DESC
</cfquery>

<!--- Deletar Item --->
<cfif structKeyExists(url, 'id') and url.id neq "">
  <cfquery name="delete" datasource="#BANCOSINC#">
    DELETE FROM INTCOLDFUSION.KANBAN_LOTES WHERE ID = '#url.id#'
  </cfquery>
  <script>
    self.location = 'cadastro.cfm';
  </script>
</cfif>

<!--- Atualizar Item --->
<cfif structKeyExists(url, 'btSalvarID') and url.btSalvarID neq "">
  <cfquery name="atualizar" datasource="#BANCOSINC#">
    UPDATE INTCOLDFUSION.KANBAN_LOTES SET KDISPONIVEIS = '#url.Kdisponiveis#', KRESTRICAO = '#url.Krestricao#' 
    WHERE ID = '#url.btSalvarID#'
  </cfquery>
  <script>
    alert("Salvo com sucesso!")
    self.location = 'cadastro.cfm';
  </script>
</cfif>

<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Kanban Lotes</title> 
        <!-- plugins:css -->
        <link rel="icon" type="image/png" href="auxi/kanban.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <!---  Boostrap  --->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        
        <link rel="stylesheet" href="auxi/style.css?v=5">
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>

        <h4 class="text-center mt-2">Cadastro de Kits</h4>

        <div class="container col-10 mt-5">
            <form id="form_meta"method="POST"><cfoutput>

                <div class="row mb-4">
                  
                  <div class="col col">
                    <div class="form-group">
                      <label class="form-label" for="formPredio">Prédio</label>
                      <select class="form-control" name="Predio" id="formPredio" required>
                        <option value="Body Shop">Body Shop</option>
                        <option value="Trim Shop">Trim Shop</option>
                      </select>
                    </div>
                  </div>

                  <div class="col col">
                    <div class="form-group">
                      <label class="form-label" for="formModelo">Modelo</label>
                      <select class="form-control" name="Modelo" id="formModelo" required>
                        <cfloop query="modelos">
                          <option value="#modelos.modelo#">#modelos.modelo#</option>
                        </cfloop>
                      </select>
                    </div>
                  </div>
                </div>
                
                <div class="row mb-4">
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formKdisponiveis">Kits disponiveis</label>
                      <input type="number" class="form-control" name="Kdisponiveis" id="formKdisponiveis" placeholder="Qtde" required/>
                    </div>
                  </div>
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formKrestricao">Kits com restrição</label>
                      <input type="number" class="form-control" name="Krestricao" id="formKrestricao" placeholder="Qtde" required/>
                    </div>
                  </div>
                </div>
            </form></cfoutput>


            <div class="bt_ms">
              <button type="submit" form="form_meta" class="btn btn-primary">Adicionar</button>

              <cfif isDefined("form.kdisponiveis") and form.kdisponiveis neq "">
                
                <cfquery name="insert" datasource="#BANCOSINC#">
                  INSERT INTO INTCOLDFUSION.KANBAN_LOTES (ID, PREDIO, MODELO, KDISPONIVEIS, KRESTRICAO)  
                  SELECT NVL(MAX(ID),0) + 1, '#form.predio#',  '#form.modelo#',  '#form.kdisponiveis#', '#form.krestricao#'
                  FROM INTCOLDFUSION.KANBAN_LOTES
                </cfquery>

                <div class="alert alert-success" role="alert">
                  Cadastrado com sucesso
                </div>
                <meta http-equiv="refresh" content="1.5, url=cadastro.cfm">
              </cfif>

            </div>

            <!--- Filtro para tabela --->
            <cfoutput>
            <form class="filterTable mt-5" name="fitro" method="GET">
              <div class="col row">
                <div class="col-2 w-25">
                  <label class="form-label" for="filtroPredio">Prédio:</label>
                  <input type="text" class="form-control" name="filtroPredio" id="filtroPredio" value="<cfif isDefined("url.filtroPredio")>#url.filtroPredio#</cfif>"/>    
                </div>
                <div class="col-2 w-25">
                  <label class="form-label" for="filtroModelo">Modelo:</label>
                  <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined("url.filtroModelo")>#url.filtroModelo#</cfif>"/>    
                </div>
                <div class="col-filtro">
                  <button class="btn btn-primary" type="submit">Filtrar</button>
                </div>
                <div class="col">
                  <button class="btn btn-warning" type="reset" onclick="self.location='cadastro.cfm'">Limpar</button>
                </div>
              </div>
            </form>
            </cfoutput>


            <!--- Tabelas com ultimas metas --->
            <div class="container col-12 bg-white rounded metas">
              <table class="table text-center">
                <thead>
                  <tr class="text-nowrap">
                    <th scope="col">Prédio</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">Kits disponíveis</th>
                    <th scope="col">Kits com restrição</th>
                    <th scope="col"><i class="mdi mdi-salve"></i></th>
                    <th scope="col"><i class="mdi mdi-delete"></i></th>
                  </tr>
                </thead>
                <tbody class="table-group-divider"><cfoutput>
                  <cfloop query="consulta">
                    <tr class="align-middle">
                      <form name="formUpdate" method="GET">
                        <td>#predio#</td>
                        <td>#modelo#</td>
                        <td class="w-25"><input type="number" class="form-control text-center" name="Kdisponiveis" value="#consulta.kdisponiveis#" required/></td>
                        <td class="w-25"><input type="number" class="form-control text-center" name="Krestricao" value="#consulta.krestricao#" required/></td>
                        <td><button type="submit" class="btn btn-info" name="btSalvarID" value="#consulta.id#">Salvar</button></td>
                      </form>
                      <th scope="row"><i onclick="deletar(#id#);" class="mdi mdi-delete-outline"></i></th>
                    </tr>
                  </cfloop>
                </tbody></cfoutput>
              </table>
            </div>

        </div>
    </body>

    <script>
      const deletar = (id, peca, data) => {
        conf = confirm('Deseja realmente apagar esse item?');
        if(conf == true){
          self.location = 'cadastro.cfm?id='+id
        }
      }

      // Remover cookie de login
      function expire_cookie() {
                var data = new Date(2010,0,01);
                  // Converte a data para GMT
                  data = data.toGMTString();
               document.cookie = 'USER_PCP_PARADAS_ADM=; expires=' + data + '; path=/';
               self.location = 'cadastro.cfm';
      }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>