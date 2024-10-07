<cfinvoke method="inicializando" component="cf.ini.index">
  <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
  <cfheader name="Pragma" value="no-cache">
  <cfheader name="Expires" value="0">

    <cfquery name="consulta_editar" datasource="#BANCOSINC#">
      SELECT * FROM INTCOLDFUSION.sistema_qualidade_body
      WHERE ID = '#url.id_editar#'
      ORDER BY ID DESC
  </cfquery>


  <cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
  </cfif>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>EDITAR ESTAÇÃO</title>
  <link rel="icon" href="./assets/chery.png" type="image/x-icon">
  <link rel="stylesheet" href="assets/style_editar.css?v2">
</head>

<body>
  <header class="titulo">
      <cfinclude template="auxi/nav_links1.cfm">
  </header><br><br><br><br>

  <h1 class="text-center mt-2">Editar</h1>
  <div class="container col-10">
      <form id="for-edit" method="POST">
          <cfoutput>
            <div class="row mb-4">
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formData">Data:</label>
                  <input style="background-color:gray" type="text" name="data" class="form-control" id="formData" value="#dateFormat(consulta_editar.user_data, 'dd/mm/yyyy')#" readonly/>
                </div>
              </div>
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formBARCODE">Barcode</label>
                  <input style="background-color:gray" type="text" class="form-control" name="BARCODE" id="formBARCODE" value="#consulta_editar.barcode#" required readonly/>
                </div>
              </div>
              <div class="col col-3">
                <div class="form-group">
                    <label class="form-label" for="formModelo">Modelo</label>
                    <input style="background-color:gray" type="text" class="form-control" name="modelo" id="formModelo" value="#consulta_editar.modelo#" required readonly/>
                </div>
            </div>
            <div class="col col-3">
              <div class="form-group">
                  <label class="form-label" for="formVIN">VIN</label>
                  <input type="text" class="form-control" name="vin" id="formVIN" value="#consulta_editar.VIN#"readonly/>
              </div>
          </div>
            <div class="col col-3">
            </div>
          </div>
            <!-- Novos campos -->
            <div class="row mb-4">
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formDataDesbloqueio">Data de Bloqueio</label>
                  <input style="background-color:gray" type="text" class="form-control" name="data_desbloqueio" id="formDataDesbloqueio" value="<cfoutput>#dateFormat(now(), 'dd/mm/yyyy')#</cfoutput>" readonly/>
                </div>
              </div>
              

              <cfquery name="login" datasource="#BANCOSINC#">
                SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
              </cfquery>
            
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formResponsavelDesbloqueio">Responsável pelo Desbloqueio</label>
                  <input style="background-color:gray" type="text" class="form-control" name="responsavel_desbloqueio" id="formResponsavelDesbloqueio" value="#login.USER_SIGN#" readonly/>
                </div>
              </div>
              <div class="col col-3">
                <div class="form-group">
                    <label class="form-label" for="formStatusbloqueio">Status de Desbloqueio</label>
                    <select class="form-control" name="status_bloqueio" id="formStatusBloqueio">
                        <option value="Desbloqueado">Desbloqueado</option>
                    </select>
                </div>
            </div>
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formMotivoDesbloqueio">Motivo do Desbloqueio</label>
                  <input type="text" class="form-control" name="motivo_desbloqueio" id="formMotivoDesbloqueio" value="#consulta_editar.motivo_desbloqueio#" required/>
                </div>
              </div>
              
            </div>
          
            <div class="bt_ms mb-5">
                <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>

                <cfif isDefined("form.barcode") and form.barcode neq "">
                  <cfquery name="atualiza" datasource="#BANCOSINC#">
                      UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
                      SET 
                          STATUS_BLOQUEIO = '#UCase(form.status_bloqueio)#',
                          RESPONSAVEL_DESBLOQUEIO = '#UCase(form.responsavel_desbloqueio)#',
                          DATA_DESBLOQUEIO = <cfqueryparam value="#parseDateTime(form.data_desbloqueio, 'dd/mm/yyyy')#" cfsqltype="cf_sql_date"/>,
                          MOTIVO_DESBLOQUEIO = '#UCase(form.motivo_desbloqueio)#',
                          MODELO = '#UCase(form.modelo)#'
                      WHERE ID = '#url.id_editar#'
                  </cfquery>
                  <div class="alert alert-success" role="alert">
                      Atualizado com Sucesso
                  </div>
                  <meta http-equiv="refresh" content="1.5; url=4fai_selecionar_desbloqueio.cfm">
              </cfif>
              
                <button type="reset" id="bt_reset" onclick="self.location = '4fai_selecionar_desbloqueio.cfm'" class="btn btn-warning">Voltar</button>
            </div>
          </cfoutput>
      </form>
  </div>
  <footer class="text-center py-4">
      <p>&copy; 2024 Sistema de gestão da qualidade.</p>
  </footer>
</body>
</html>
