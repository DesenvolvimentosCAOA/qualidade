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
  FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES 
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
    DELETE FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES WHERE ID = '#url.id#'
  </cfquery>
  <script>
    self.location = 'cadastroRestricoes.cfm';
  </script>
</cfif>

<!--- Deletar Tudo --->
<cfif structKeyExists(url, 'ApagarTudo') and url.ApagarTudo eq "true">
  <cfquery name="delete" datasource="#BANCOSINC#">
    DELETE FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES
  </cfquery>

  <script>
    self.location = 'cadastroRestricoes.cfm';
  </script>
</cfif>

<!--- Atualizar Item --->
<cfif structKeyExists(url, 'btSalvarID') and url.btSalvarID neq "">
  <cfquery name="atualizar" datasource="#BANCOSINC#">
    UPDATE INTCOLDFUSION.KANBAN_LOTES_RESTRICOES SET PARTNUMBER = '#url.PartNumber#', QUANTIDADE = '#url.Quantidade#', ACOMPANHAMENTO = '#url.Acompanhamento#'
    WHERE ID = '#url.btSalvarID#'
  </cfquery>
  <script>
    alert("Salvo com sucesso!")
    self.location = 'cadastroRestricoes.cfm';
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

        <h4 class="text-center mt-2">Cadastro de Restrições</h4>

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
                      <input type="text" class="form-control" name="Modelo" id="formModelo" placeholder="Informe o modelo" required/>
                    </div>
                  </div>

                </div>
                
                <div class="row mb-4">
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formPartNumber">Part Number</label>
                      <input type="text" class="form-control" name="PartNumber" id="formPartNumber" required/>
                    </div>
                  </div>
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formQuantidade">Quantidade</label>
                      <input type="number" class="form-control" name="Quantidade" id="formQuantidade" required/>
                    </div>
                  </div>
                </div>

                <div class="row mb-4">
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formAcompanhamento">Acompanhamento</label>
                      <input type="text" class="form-control" name="Acompanhamento" id="formAcompanhamento" required/>
                    </div>
                  </div>
                </div>
            </form></cfoutput>


 
            <div class="bt_ms">
              <button type="submit" form="form_meta" class="btn btn-primary">Adicionar</button>

             <!--- Importar Meta via Arquivo excell --->
             <form action="auxi/restricoes_import.cfm" method="post" enctype="multipart/form-data" name="form2" class="import">
              <div class="mb-3 input-group">
                <input class="form-control" type="file" id="formFile" name="file">
                <button class="btn btn-primary m-0" type="submit">Enviar</button>
              </div>
              <!--- <label for="formFile" class="form-label">Importar Programação Via Excel (Colunas devem estar na mesma ordem dos campos)</label> --->
            </form>


              <cfif isDefined("form.Acompanhamento") and form.Acompanhamento neq "">
                
                <cfquery name="insert" datasource="#BANCOSINC#">
                  INSERT INTO INTCOLDFUSION.KANBAN_LOTES_RESTRICOES (ID, PREDIO, MODELO, PARTNUMBER, QUANTIDADE, ACOMPANHAMENTO)  
                  SELECT NVL(MAX(ID),0) + 1, '#form.predio#',  '#form.modelo#',  '#form.partnumber#', '#form.quantidade#', '#form.acompanhamento#'
                  FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES
                </cfquery>

                <div class="alert alert-success" role="alert">
                  Cadastrado com sucesso
                </div>
                <meta http-equiv="refresh" content="1.5, url=cadastroRestricoes.cfm">
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
                  <button class="btn btn-warning" type="reset" onclick="self.location='cadastroRestricoes.cfm'">Limpar</button>
                </div>

                <div class="col">
                  <button class="btn btn-danger" type="reset" onclick="apagarTudo()" style="margin-left: 50px">Apagar tudo?</button>
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
                    <th scope="col">Part Number</th>
                    <th scope="col">Quantidade</th>
                    <th scope="col">Acompanhamento</th>
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
                        <td class="w-25"><input type="text" class="form-control text-center" name="PartNumber" value="#consulta.PartNumber#" required/></td>
                        <td class="w-25"><input type="number" class="form-control text-center" name="Quantidade" value="#consulta.Quantidade#" required/></td>
                        <td class="w-50"><input type="text" class="form-control text-center" name="Acompanhamento" value="#consulta.Acompanhamento#" required/></td>
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
          self.location = 'cadastroRestricoes.cfm?id='+id
        }
      }

      // Remover cookie de login
      function expire_cookie() {
                var data = new Date(2010,0,01);
                  // Converte a data para GMT
                  data = data.toGMTString();
               document.cookie = 'USER_PCP_PARADAS_ADM=; expires=' + data + '; path=/';
               self.location = 'cadastroRestricoes.cfm';
      }

      const apagarTudo = ()=>{
        conf = confirm("Tem certeza que deseja excluir todas as restrições?");
        if(conf==true){
          self.location='cadastroRestricoes.cfm?ApagarTudo=true';
        }
        else {
          return false;
        }
      }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>