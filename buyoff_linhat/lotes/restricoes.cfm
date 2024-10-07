<cfinvoke  method="inicializando" component="cf.ini.index">


<!--- Consulta Restrições --->
<cfquery datasource="#BANCOSINC#" name="consulta_restricoes">
  SELECT * FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES 
  WHERE 1 = 1
  <cfif isDefined("url.filtroPredio") and url.filtroPredio neq "">
    AND UPPER(PREDIO) LIKE UPPER('%#url.filtroPredio#%')
  </cfif>
  <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
    AND UPPER(MODELO) LIKE UPPER('%#url.filtroModelo#%')
  </cfif>
  <cfif isDefined("url.filtroPartNumber") and url.filtroPartNumber neq "">
    AND UPPER(PARTNUMBER) LIKE UPPER('%#url.filtroPartNumber#%')
  </cfif>
  <cfif isDefined("url.filtroQuantidade") and url.filtroQuantidade neq "">
    AND QUANTIDADE ='#url.filtroQuantidade#'
  </cfif>
  <cfif isDefined("url.filtroAcompanhamento") and url.filtroAcompanhamento neq "">
    AND UPPER(ACOMPANHAMENTO) LIKE UPPER('%#url.filtroAcompanhamento#%')
  </cfif>
  ORDER BY QUANTIDADE DESC
</cfquery>

<html>
<head>
  <title>Kanban Lotes</title> 
  <link rel="icon" type="image/png" href="auxi/kanban.png">
  <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
  <link rel="stylesheet" href="auxi/style.css?v=7">
  <!---  Boostrap  --->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">

  <style>
   
  </style>
</head>
<body>
<cfoutput>

   <header>
       <cfinclude template="auxi/nav_links.cfm">
   </header>

   <div class="d-flex row mt-4 m-1">
      <!--- Filtro para tabela --->
      <cfoutput>
      <form class="filterTable mt-1" name="fitro" method="GET">
        <div class="col row">
          <div class="col-2 w-25">
            <label class="form-label" for="filtroPredio">Prédio:</label>
            <input type="text" class="form-control" name="filtroPredio" id="filtroPredio" value="<cfif isDefined("url.filtroPredio")>#url.filtroPredio#</cfif>"/>    
          </div>
          <div class="col-2 w-25">
            <label class="form-label" for="filtroModelo">Modelo:</label>
            <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined("url.filtroModelo")>#url.filtroModelo#</cfif>"/>    
          </div>
          <div class="col-2 w-25">
            <label class="form-label text-nowrap" for="filtroPartNumber">Part Number:</label>
            <input type="text" class="form-control" name="filtroPartNumber" id="filtroPartNumber" value="<cfif isDefined("url.filtroPartNumber")>#url.filtroPartNumber#</cfif>"/>    
          </div>
          <div class="col-2 w-25">
            <label class="form-label" for="filtroQuantidade">Quantidade:</label>
            <input type="number" class="form-control" name="filtroQuantidade" id="filtroQuantidade" value="<cfif isDefined("url.filtroQuantidade")>#url.filtroQuantidade#</cfif>"/>    
          </div>
          <div class="col-2 w-50 mt-3">
            <label class="form-label" for="filtroAcompanhamento">Acompanhamento:</label>
            <input type="text" class="form-control" name="filtroAcompanhamento" id="filtroAcompanhamento" value="<cfif isDefined("url.filtroAcompanhamento")>#url.filtroAcompanhamento#</cfif>"/>    
          </div>
          <div class="col-filtro mt-3">
            <button class="btn btn-primary" type="submit">Filtrar</button>
          </div>
          <div class="col mt-3">
            <button class="btn btn-warning" type="reset" onclick="self.location='restricoes.cfm'">Limpar</button>
          </div>
        </div>
      </form>
      </cfoutput>

    <!--- Produção do dia D+0 --->
      <div class="table-responsive col mt-3">
          <p>
              <b>Body Shop</b> - #lsdateformat(now(),'dd/mm/yyyy')#
          </p>
          <table class="table table-bordered text-center">
            <thead>
              <tr class="bg-primary text-white align-middle">
                <th scope="col">Prédio</th>
                <th scope="col">Modelo</th>
                <th scope="col">Part Number</th>
                <th scope="col">Descrição</th>
                <th scope="col">Quantidade</th>
                <th scope="col">Acompanhamento</th> 
              </tr>
            </thead>

            <tbody>

              <cfloop query="#consulta_restricoes#">
                <cfif PREDIO eq 'Body Shop'>
                  <tr class="align-middle" style="font-weight: bold;">
                    <cfquery datasource="#BANCOPROTPROD#" name="descricoes">
                      SELECT B1_COD, B1_DESC FROM ABDHDU_PROT.SB1010 
                      WHERE D_E_L_E_T_ = ' ' AND B1_COD = '#PARTNUMBER#'
                    </cfquery>
                    <td>#PREDIO#</td>
                    <td>#MODELO#</td>
                    <td onclick="window.open('#raizweb#/cf/auth/monitor/mdg/consulta.cfm?FiltroAnalista=&limite=10&FiltroAdiantamento=vazio&PartNo3=#PARTNUMBER#&FiltroModelo=', '_blank')" style="cursor: pointer">#PARTNUMBER#</td>
                    <td><cfif isDefined("descricoes.B1_DESC")>#descricoes.B1_DESC#</cfif></td>
                    <td>#QUANTIDADE#</td>
                    <td>#ACOMPANHAMENTO#</td>
                  </tr>
                </cfif>
              </cfloop>

            </tbody>
        </table>
      </div>

      <div class="table-responsive col mt-3">
          <p>
            <b>Trim Shop</b> - #lsdateformat(now(),'dd/mm/yyyy')#
          </p>
          <table class="table table-bordered text-center">
            <thead>
              <tr class="bg-primary text-white align-middle">
                <th scope="col">Prédio</th>
                <th scope="col">Modelo</th>
                <th scope="col">Part Number</th>
                <th scope="col">Descrição</th>
                <th scope="col">Quantidade</th>
                <th scope="col">Acompanhamento</th> 
              </tr>
            </thead>

            <tbody>

              <cfloop query="#consulta_restricoes#">
                <cfif PREDIO eq 'Trim Shop'>
                  <tr class="align-middle" style="font-weight: bold;">
                    <cfquery datasource="#BANCOPROTPROD#" name="descricoes">
                        SELECT B1_COD, B1_DESC FROM ABDHDU_PROT.SB1010 
                        WHERE D_E_L_E_T_ = ' ' AND B1_COD = '#PARTNUMBER#'
                    </cfquery>
                      <td>#PREDIO#</td>
                      <td>#MODELO#</td>
                      <td onclick="window.open('#raizweb#/cf/auth/monitor/mdg/consulta.cfm?FiltroAnalista=&limite=10&FiltroAdiantamento=vazio&PartNo3=#PARTNUMBER#&FiltroModelo=', '_blank')" style="cursor: pointer">#PARTNUMBER#</td>
                      <td><cfif isDefined("descricoes.B1_DESC")>#descricoes.B1_DESC#</cfif></td>
                      <td>#QUANTIDADE#</td>
                      <td>#ACOMPANHAMENTO#</td>
                  </tr>
                </cfif>
              </cfloop>

            </tbody>
        </table>
    </div>
  </div>
  
</div>

</cfoutput>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</body>
</html>
