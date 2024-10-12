<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_PDI") or cookie.USER_APONTAMENTO_PDI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade_pdi_saida
    WHERE ID = '#url.id_editar#'
    ORDER BY ID DESC
</cfquery>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>EDITAR ESTAÇÃO</title>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    <link rel="stylesheet" href="/qualidade/buyoff_linhat/assets/style_editar.css?v2">
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links.cfm">
    </header><br><br><br><br>

    <h1 class="text-center mt-2">Editar</h1>
    <div class="container col-10">
        <form id="for-edit" method="POST">
            <cfoutput>
              <div class="row mb-4">
                <div class="col col-3">
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formVIN">VIN</label>
                    <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.vin#" required readonly/>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formModelo">Modelo</label>
                    <input type="text" class="form-control" name="modelo" id="formModelo" value="#consulta_editar.modelo#" required readonly/>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formEstacao">Estação</label>
                    <select class="form-control" name="estacao" id="formEstacao">
                      <option value="#consulta_editar.estacao#">#consulta_editar.estacao#</option>
                      <cfinclude template="auxi/estacao.cfm">
                    </select>
                  </div>
                </div>
              </div>
          
              <!-- Peça, Posição, Problema e Intervalo na mesma linha -->
              <div class="row mb-4">
                <div class="col col-3">
                  <div class="form-group">
                      <label class="form-label" for="formPeca">Peça</label>
                      <input list="peca-options" type="text" maxlength="200" class="form-control" name="peca" id="formPeca" value="#consulta_editar.peca#"/>
                      <datalist id="peca-options">
                          <cfinclude template="auxi/problemas_option.cfm">
                      </datalist>
                  </div>
              </div>
              
              <div class="col col-3">
                <div class="form-group">
                    <label class="form-label" for="formlocal">Posição</label>
                    <input list="posicao-options" type="text" name="local" id="formlocal" value="#consulta_editar.posicao#"/>
                    
                    <!-- Datalist com cfinclude para carregar opções -->
                    <datalist id="posicao-options">
                        <cfinclude template="auxi/batalha_option.cfm">
                    </datalist>
                </div>
            </div>
            
            <div class="col col-3">
              <div class="form-group">
                  <label class="form-label" for="formNConformidade">Problema</label>
                  <input list="problema-options" type="text" name="NConformidade" id="formNConformidade" value="#consulta_editar.problema#"/>
                  <!-- Datalist com cfinclude para carregar opções -->
                  <datalist id="problema-options">
                      <cfinclude template="auxi/problemas_option.cfm">
                  </datalist>
              </div>
          </div>    
          <div class="col col-3">
            <div class="form-group">
              <label class="form-label" for="formCRITICIDADE">Criticidade</label>
              <select class="form-control" name="criticidade" id="formCRITICIDADE">
                  <option value="">Selecione</option>
                  <option value="N1" <cfif consulta_editar.CRITICIDADE eq "N1">selected</cfif>>N1</option>
                  <option value="N2" <cfif consulta_editar.CRITICIDADE eq "N2">selected</cfif>>N2</option>
                  <option value="N3" <cfif consulta_editar.CRITICIDADE eq "N3">selected</cfif>>N3</option>
                  <option value="N4" <cfif consulta_editar.CRITICIDADE eq "N4">selected</cfif>>N4</option>
                  <option value="OK A-" <cfif consulta_editar.CRITICIDADE eq "OK A-">selected</cfif>>OK A-</option>
                  <option value="N0" <cfif consulta_editar.CRITICIDADE eq "N0">selected</cfif>>N0</option>
                  <option value="AVARIA" <cfif consulta_editar.CRITICIDADE eq "Avaria">selected</cfif>>Avaria</option>
              </select>
            </div> 
          </div>  
              </div>          
                <div class="bt_ms mb-4">
                  <div class="col col-3">
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                      <cfif isDefined("form.vin") and form.vin neq "">
                          <cfquery name="atualiza" datasource="#BANCOSINC#">
                              UPDATE INTCOLDFUSION.sistema_qualidade_pdi_saida
                              SET 
                                  PECA ='#UCase(form.peca)#', 
                                  POSICAO = '#UCase(form.local)#', 
                                  PROBLEMA = '#Ucase(form.NConformidade)#',
                                  ESTACAO = '#UCase(form.estacao)#',
                                  MODELO = '#UCase(form.modelo)#',
                                  VIN = '#UCase(form.vin)#',
                                  CRITICIDADE = '#UCase(form.CRITICIDADE)#'
                              WHERE ID = '#url.id_editar#'
                          </cfquery>
                          <div class="alert alert-success" role="alert">
                              Atualizado com Sucesso
                          </div>
                          <meta http-equiv="refresh" content="1.5; url=pdi_editar.cfm">
                      </cfif>
                  </div>
                  <div class="col col-3">
                    <button type="reset" id="bt_reset" onclick="self.location = 'pdi_editar.cfm'" class="btn btn-warning">Voltar</button>
                  </div>
                </div>
            </cfoutput>
        </form>
    </div>
    <footer class="text-center py-4">
        <p>&copy; 2024 Sistema de gestão da qualidade.</p>
    </footer>
</body>
</html>
