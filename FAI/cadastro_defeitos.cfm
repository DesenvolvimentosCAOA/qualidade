<cfinvoke method="inicializando" component="cf.ini.index">
  <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
  <cfheader name="Pragma" value="no-cache">
  <cfheader name="Expires" value="0">

<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
  <script>
      alert("É necessario autenticação!!");
      self.location = '/qualidade/buyoff_linhat/index.cfm'
  </script>
</cfif>
<!---  Consulta  --->
<cfquery name="consulta_cripple" datasource="#BANCOSINC#">
  SELECT *
  FROM INTCOLDFUSION.MASSIVA_FAI
  WHERE 1 = 1 
  AND STATUS IS NULL
  <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
    AND UPPER(VIN) LIKE UPPER('%#url.filtroDefeito#%')
  </cfif>
  ORDER BY ID desc
</cfquery>


<script>
  function atualizarRegistro(id) {
      if (confirm("Tem certeza que deseja liberar vin?")) {
          // Redireciona para a página de edição passando o ID como parâmetro
          window.location.href = 'cadastro_defeitos.cfm?id=' + id;
      }
  }
</script>
<cfif structKeyExists(url, "delete_id") and url.delete_id neq "">
  <!-- Executa o DELETE no banco de dados -->
  <cfquery name="delete" datasource="#BANCOSINC#">
      DELETE FROM INTCOLDFUSION.massiva_fai
      WHERE ID = <cfqueryparam value="#url.delete_id#" cfsqltype="CF_SQL_INTEGER">
  </cfquery>

  <!-- Após a exclusão, recarrega a página para atualizar a tabela -->
  <script>
      alert("Registro excluído com sucesso!");
      window.location.href = 'cadastro_defeitos.cfm';
  </script>
</cfif>

<script>
  function deletarRegistro(id) {
      if (confirm("Tem certeza que deseja excluir este registro?")) {
          // Redireciona para a página de deleção passando o ID como parâmetro
          window.location.href = 'cadastro_defeitos.cfm?delete_id=' + id;
      }
  }
</script>

  <!-- Verifica se o parâmetro ID foi passado na URL e executa o UPDATE -->
<cfif structKeyExists(url, "id") and url.id neq "">
  <!-- Atualizando as colunas específicas e setando o STATUS como OK -->
  <cfquery name="update" datasource="#BANCOSINC#">
      UPDATE INTCOLDFUSION.massiva_fai
      SET 
          STATUS = 'OK'
      WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
  </cfquery>

  <!-- Após a atualização, recarrega a página para atualizar a tabela -->
  <script>
      alert("VIN liberado com sucesso!");
      window.location.href = 'cadastro_defeitos.cfm';
  </script>
</cfif>

<cfif structKeyExists(form, "confirmDelete") and form.confirmDelete EQ "yes">
  <cfquery datasource="#BANCOSINC#">
      DELETE FROM MASSIVA_FAI
  </cfquery>
  <script>
      alert("Todos os registros foram deletados com sucesso.");
      self.location = 'cadastro_defeitos.cfm';
  </script>
</cfif>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>Massiva FAI</title>
        <link rel="icon" type="image/png" href="assets/img/relatorio.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <script>
          function verificarMassiva() {
              var vin = document.getElementById('formDefeito').value;
      
              // Verifica se o campo VIN não está vazio
              if (vin.trim() === "") {
                  alert("Por favor, insira um VIN.");
                  return;
              }
      
              // Chama o ColdFusion para verificar a existência do VIN
              fetch('verificar_massiva.cfm?vin=' + encodeURIComponent(vin))
                  .then(response => response.json())
                  .then(data => {
                      if (data.exists) {
                          alert('O VIN já existe na tabela!');
                      } else {
                          document.getElementById('form_meta').submit();
                      }
                  })
                  .catch(error => console.error('Erro:', error));
          }
      </script>
      
      <style>
            /* Estilo para o botão Deletar (btn-apagar) */
            .btn-apagar {
                background-color: yellow; /* Vermelho (Bootstrap danger) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }
        
            /* Estilo ao passar o mouse (hover) para o botão Deletar */
            .btn-apagar:hover {
                background-color: #c82333; /* Vermelho mais escuro */
                box-shadow: 0 0 8px rgba(220, 53, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }
        
            /* Estilo para o botão Liberar */
            .btn-liberar {
                background-color: #28a745; /* Verde (Bootstrap success) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }
        
            /* Estilo ao passar o mouse (hover) para o botão Liberar */
            .btn-liberar:hover {
                background-color: #218838; /* Verde mais escuro */
                box-shadow: 0 0 8px rgba(40, 167, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }
            .container {
              margin-left: 10px; /* Margem à esquerda de 10 pixels */
           }

          .table {
              width: auto; /* Permite que a tabela use apenas a largura necessária */
              margin: 0; /* Remove margens padrão */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona um pouco de espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }

          .btn-liberar {
              background-color: #4CAF50; /* Cor de fundo do botão */
              color: white; /* Cor do texto do botão */
              border: none; /* Remove a borda do botão */
              padding: 5px 10px; /* Espaçamento interno do botão */
              cursor: pointer; /* Muda o cursor ao passar sobre o botão */
          }

          .btn-apagar {
              color: red; /* Cor do ícone de deletar */
              cursor: pointer; /* Muda o cursor ao passar sobre o ícone */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
      </style>
    
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br>
        <h3 class="text-center mt-2">Massiva</h3>
        
          <cfoutput>
            <form class="filterTable mt-5" name="filtro" method="GET">
                <div class="d-flex align-items-end">
                    <div class="me-2">
                        <label class="form-label" for="filtroDefeito">VIN:</label>
                        <input type="text" class="form-control" name="filtroDefeito" id="filtroDefeito" value="<cfif isDefined('url.filtroDefeito')>#url.filtroDefeito#</cfif>"/>
                    </div>
                    <div class="me-2">
                        <button class="btn btn-primary" type="submit" style="height: calc(100% - 5px);">Filtrar</button>
                    </div>
                    <div>
                        <button class="btn btn-warning" type="reset" style="height: calc(100% - 5px);" onclick="self.location='cadastro_defeitos.cfm'">Limpar</button>
                    </div>
                </div>
            </form>
        </cfoutput>
      </div>
      <div class="container col-2 bg-white rounded metas">
        <div class="tabela-container">
            <div class="tabela">
                <h1>T1A</h1>
                <table class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">VIN</th>
                            <th scope="col">Liberar</th>
                            <th scope="col"><i class="mdi mdi-delete"></i></th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_cripple">
                                <cfif left(VIN, 4) EQ "95PD">
                                    <tr class="align-middle">
                                        <td>#VIN#</td>
                                        <td class="text-nowrap">
                                            <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                                <i class="material-icons"></i> Liberar
                                            </button>
                                        </td>
                                        <th scope="row">
                                            <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                        </th>
                                    </tr>
                                </cfif>
                            </cfloop>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
    
            <div class="tabela">
                <h1>T1E</h1>
                <table class="table">
                  <thead>
                      <tr class="text-nowrap">
                          <th scope="col">VIN</th>
                          <th scope="col">Liberar</th>
                          <th scope="col"><i class="mdi mdi-delete"></i></th>
                      </tr>
                  </thead>
                  <tbody class="table-group-divider">
                      <cfoutput>
                          <cfloop query="consulta_cripple">
                              <cfif left(VIN, 4) EQ "95PE">
                                  <tr class="align-middle">
                                      <td>#VIN#</td>
                                      <td class="text-nowrap">
                                          <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                              <i class="material-icons"></i> Liberar
                                          </button>
                                      </td>
                                      <th scope="row">
                                          <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                      </th>
                                  </tr>
                              </cfif>
                          </cfloop>
                      </cfoutput>
                  </tbody>
              </table>
            </div>
    
            <div class="tabela">
                <h1>T19</h1>
                <table class="table">
                  <thead>
                      <tr class="text-nowrap">
                          <th scope="col">VIN</th>
                          <th scope="col">Liberar</th>
                          <th scope="col"><i class="mdi mdi-delete"></i></th>
                      </tr>
                  </thead>
                  <tbody class="table-group-divider">
                      <cfoutput>
                          <cfloop query="consulta_cripple">
                              <cfif left(VIN, 4) EQ "95PB">
                                  <tr class="align-middle">
                                      <td>#VIN#</td>
                                      <td class="text-nowrap">
                                          <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                              <i class="material-icons"></i> Liberar
                                          </button>
                                      </td>
                                      <th scope="row">
                                          <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                      </th>
                                  </tr>
                              </cfif>
                          </cfloop>
                      </cfoutput>
                  </tbody>
              </table>
            </div>
    
            <div class="tabela">
                <h1>T18</h1>
                <table class="table">
                  <thead>
                      <tr class="text-nowrap">
                          <th scope="col">VIN</th>
                          <th scope="col">Liberar</th>
                          <th scope="col"><i class="mdi mdi-delete"></i></th>
                      </tr>
                  </thead>
                  <tbody class="table-group-divider">
                      <cfoutput>
                          <cfloop query="consulta_cripple">
                              <cfif left(VIN, 4) EQ "95PF">
                                  <tr class="align-middle">
                                      <td>#VIN#</td>
                                      <td class="text-nowrap">
                                          <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                              <i class="material-icons"></i> Liberar
                                          </button>
                                      </td>
                                      <th scope="row">
                                          <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                      </th>
                                  </tr>
                              </cfif>
                          </cfloop>
                      </cfoutput>
                  </tbody>
              </table>
            </div>
    
            <div class="tabela">
                <h1>HR</h1>
                <table class="table">
                  <thead>
                      <tr class="text-nowrap">
                          <th scope="col">VIN</th>
                          <th scope="col">Liberar</th>
                          <th scope="col"><i class="mdi mdi-delete"></i></th>
                      </tr>
                  </thead>
                  <tbody class="table-group-divider">
                      <cfoutput>
                          <cfloop query="consulta_cripple">
                              <cfif left(VIN, 4) EQ "95PZ">
                                  <tr class="align-middle">
                                      <td>#VIN#</td>
                                      <td class="text-nowrap">
                                          <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                              <i class="material-icons"></i> Liberar
                                          </button>
                                      </td>
                                      <th scope="row">
                                          <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                      </th>
                                  </tr>
                              </cfif>
                          </cfloop>
                      </cfoutput>
                  </tbody>
              </table>
            </div>
    
            <div class="tabela">
                <h1>TL</h1>
                <table class="table">
                  <thead>
                      <tr class="text-nowrap">
                          <th scope="col">VIN</th>
                          <th scope="col">Liberar</th>
                          <th scope="col"><i class="mdi mdi-delete"></i></th>
                      </tr>
                  </thead>
                  <tbody class="table-group-divider">
                      <cfoutput>
                          <cfloop query="consulta_cripple">
                              <cfif left(VIN, 4) EQ "95PJ">
                                  <tr class="align-middle">
                                      <td>#VIN#</td>
                                      <td class="text-nowrap">
                                          <button class="btn-liberar" onclick="atualizarRegistro(#ID#);">
                                              <i class="material-icons"></i> Liberar
                                          </button>
                                      </td>
                                      <th scope="row">
                                          <i onclick="deletarRegistro(#ID#);" class="mdi mdi-delete-outline btn-apagar"></i>
                                      </th>
                                  </tr>
                              </cfif>
                          </cfloop>
                      </cfoutput>
                  </tbody>
              </table>
            </div>
        </div>
    </div>
    <div class="container col-6 mt-5">
      <form id="form_meta" method="POST">
        <div class="row mb-4">
            <div class="col">
                <div class="form-group">
                    <label class="form-label" for="formDefeito">Inserir Massiva (VIN):</label>
                    <input style="width:300px" type="text" class="form-control d-inline" name="Defeito" id="formDefeito" placeholder="" required />
                    <button type="button" onclick="verificarMassiva()" class="btn btn-primary me-2">Adicionar</button>
                </div>
            </div>
        
    </form>
      <cfif isDefined("form.Defeito") and form.Defeito neq "">
          <cfquery name="insert" datasource="#BANCOSINC#">
              INSERT INTO INTCOLDFUSION.MASSIVA_FAI (ID, VIN, USER_DATA)
              SELECT NVL(MAX(ID), 0) + 1, 
              '#form.Defeito#',
              SYSDATE
              FROM INTCOLDFUSION.MASSIVA_FAI
          </cfquery>
          <div class="alert alert-success" role="alert">
              Cadastrado com sucesso
          </div>
          <meta http-equiv="refresh" content="1.5, url=cadastro_defeitos.cfm">
      </cfif>
      <!--- Importar Meta via Arquivo excell --->
      <form action="auxi/defeitos_import.cfm" method="post" enctype="multipart/form-data" name="form2" class="import" style="width:400px">
        <div class="mb-3 input-group">
          <input class="form-control" type="file" id="formFile" name="file">
          <button class="btn btn-primary m-0" type="submit">Enviar</button>
        </div>
        <!--- <label for="formFile" class="form-label">Importar Programação Via Excel (Colunas devem estar na mesma ordem dos campos)</label> --->
      </form>
      <form method="post">
        <button type="submit" name="confirmDelete" value="yes" class="btn btn-danger">Deletar Todos os Registros</button>
      </form>
    </div>
  </body>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>