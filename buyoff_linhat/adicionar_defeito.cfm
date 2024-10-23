<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<!---  Consulta  --->
<cfquery name="consulta_cripple" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
    WHERE 1 = 1
    <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
      AND UPPER(DEFEITO) LIKE UPPER('%#url.filtroDefeito#%')
    </cfif>
    ORDER BY SHOP ASC
  </cfquery>
  
  <!--- Deletar Item --->
  <cfif structKeyExists(url, 'id') and url.id neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
      DELETE FROM INTCOLDFUSION.REPARO_FA_DEFEITOS WHERE ID = '#url.id#'
    </cfquery>
    <script>
      self.location = 'adicionar_defeito.cfm';
    </script>
  </cfif>


  <html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
       <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
       <title>Adicionar Defeito</title>
       <link rel="icon" href="./assets/chery.png" type="image/x-icon">
       <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
       <link rel="stylesheet" href="../assets/css/style.css?v=8">
       <style>
            .bt_ms {
            margin-top: 20px;
        }
        .container {
            position: relative;
            z-index: 1;
        }
        .filter-buttons {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 10px;
        }
        .logout-btn {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        #formDefeito {
            text-transform: uppercase;
        }
       </style>
    </head>
    <body>
        <header>
            <button class="btn btn-danger logout-btn" onclick="location.href='./index.cfm'">Sair</button>
        </header>
        <h4 class="text-center mt-2">Adicionar Defeito</h4>
        <div class="container col-10 mt-5">
            <form id="form_meta" method="POST">
                <cfoutput>
                    <!-- Data, VIN, Modelo -->
                    <div class="row mb-4">
                        <div class="col">
                            <div class="form-group">
                                <label class="form-label" for="formDefeito">Novo defeito:</label>
                                <input type="text" class="form-control" name="Defeito" id="formDefeito" placeholder="" required oninput="removeSpecialChars(this)"/>
                            </div>
                        </div>
                        
                        <script>
                        function removeSpecialChars(input) {
                            // Permite apenas letras, números e espaços
                            input.value = input.value.replace(/[^a-zA-Z0-9 ]/g, '');
                        }
                        </script>
                        
                        <div class="col">
                            <div class="form-group">
                                <label class="form-label" for="formShop">Shop:</label>
                                <select class="form-control" name="Shop" id="formShop" required>
                                    <option value="FA">FA</option>
                                    <option value="FAI-ROLO-PROBLEMA">FAI-UB2-PROBLEMA</option>
                                    <option value="FAI-ROLO-PEÇA">FAI-UB2-PEÇA</option>
                                    <option value="FAI-SHOWER-PROBLEMA">FAI-SHOWER-PROBLEMA</option>
                                    <option value="FAI-SHOWER-PEÇA">FAI-SHOWER-PEÇA</option>
                                    <option value="BODY-PROBLEMA">BODY-PROBLEMA</option>
                                    <option value="BODY-PEÇA">BODY-PEÇA</option>
                                    <option value="FAI-EXOK-PROBLEMA">FAI-EXOK-PROBLEMA</option>
                                    <option value="FAI-EXOK-PEÇA">FAI-EXOK-PEÇA</option>
                                    <option value="FAI-ROAD-PROBLEMA">FAI-ROAD-PROBLEMA</option>
                                    <option value="FAI-ROAD-PEÇA">FAI-ROAD-PEÇA</option>
                                    <option value="FA-F10-PEÇA">FA-F10-PEÇA</option>
                                    <option value="FA-F10-PROBLEMA">FA-F10-PROBLEMA</option>
                                    <option value="FA-F05-PEÇA">FA-F05-PEÇA</option>
                                    <option value="FA-F05-PROBLEMA">FA-F05-PROBLEMA</option>
                                    <option value="FA-C13-PEÇA">FA-C13-PEÇA</option>
                                    <option value="FA-C13-PROBLEMA">FA-C13-PROBLEMA</option>
                                    <option value="FA-T33-PEÇA">FA-T33-PEÇA</option>
                                    <option value="FA-T33-PROBLEMA">FA-T33-PROBLEMA</option>
                                    <option value="FA-T30-PEÇA">FA-T30-PEÇA</option>
                                    <option value="FA-T30-PROBLEMA">FA-T30-PROBLEMA</option>
                                    <option value="FA-T19-PEÇA">FA-T19-PEÇA</option>
                                    <option value="FA-T19-PROBLEMA">FA-T19-PROBLEMA</option>
                                    <option value="FA-SUBMOTOR-PEÇA">FA-SUBMOTOR-PEÇA</option>
                                    <option value="PAINT">PAINT</option>
                                </select>
                            </div>
                    </div>
                </cfoutput>
            </form>
            <div class="bt_ms">
                <button type="submit" form="form_meta" class="btn btn-primary">Adicionar</button>
                <cfif isDefined("form.Defeito") and form.Defeito neq "" and isDefined("form.Shop") and form.Shop neq "">
                    <cfquery name="insert" datasource="#BANCOSINC#">
                        INSERT INTO INTCOLDFUSION.REPARO_FA_DEFEITOS (ID, DEFEITO, SHOP, DATA_CRIACAO)
                        SELECT NVL(MAX(ID),0) + 1, 
                               '#UCase(form.Defeito)#',
                               '#form.Shop#',
                               SYSDATE
                        FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                    </cfquery>
    
                    <div class="alert alert-success" role="alert">
                        Cadastrado com sucesso
                    </div>
                    <meta http-equiv="refresh" content="1.5, url=adicionar_defeito.cfm">
                </cfif>
            </div>            
            <!--- Filtro para tabela --->
            <cfoutput>
            <form class="filterTable mt-5" name="filtro" method="GET">
                <div class="row mb-4">
                    <div class="col-2">
                        <label class="form-label" for="filtroDefeito">Defeito:</label>
                        <input type="text" class="form-control" name="filtroDefeito" id="filtroDefeito" value="<cfif isDefined("url.filtroDefeito")>#url.filtroDefeito#</cfif>"/>    
                    </div>
                    <div class="col filter-buttons">
                        <button class="btn btn-primary" type="submit">Filtrar</button>
                        <button class="btn btn-warning" type="reset" onclick="self.location='adicionar_defeito.cfm'">Limpar</button>
                    </div>
                </div>
            </form>
            </cfoutput>
    
            <!--- Tabelas com últimas reparos --->
            <div class="container col-12 bg-white rounded metas">
                <table class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">Data de Criação</th>
                            <th scope="col">Defeito</th>
                            <th scope="col">Shop</th>
                            <th scope="col"><i class="mdi mdi-delete"></i></th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                        <cfloop query="consulta_cripple">
                            <tr class="align-middle">
                                <td>#lsdatetimeformat(data_criacao, 'dd/mm/yyyy')#</td>
                                <td>#DEFEITO#</td>
                                <td>#SHOP#</td>
                                <th scope="row"><i onclick="deletar(#id#);" class="mdi mdi-delete-outline"></i></th>
                            </tr>
                        </cfloop>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
    
        </div>
    </body>
    
    <script>

        const deletar = (id) => {
            conf = confirm('Deseja realmente apagar esse item?');
            if(conf == true){
                self.location = 'adicionar_defeito.cfm?id='+id
            }
        }
    
        // Remover cookie de login
        function expire_cookie() {
            var data = new Date(2010,0,01);
            // Converte a data para GMT
            data = data.toGMTString();
            document.cookie = 'USER_REPARO_FA=; expires=' + data + '; path=/';
            self.location = 'adicionar_defeito.cfm';
        }
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Foca no campo de entrada após o envio do formulário
            var defeitoInput = document.getElementById("formDefeito");
            defeitoInput.focus();
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    </html>
    