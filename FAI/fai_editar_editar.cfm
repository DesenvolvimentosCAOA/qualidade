    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade_fai
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
    <link rel="stylesheet" href="assets/style_editar.css?v2">
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

        <cfquery name="peca" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP LIKE '%PEÇA%'
            ORDER BY DEFEITO
        </cfquery>

        <cfquery name="problema" datasource="#BANCOSINC#">
          SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
          WHERE SHOP LIKE '%PROBLEMA%'
          ORDER BY DEFEITO
        </cfquery>

    <h1 class="text-center mt-2">Editar</h1>
    <div class="container col-10">
        <form id="for-edit" method="POST">
            <cfoutput>
              <div class="row mb-4">
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formData">Data:</label>
                    <input type="text" name="data" class="form-control" id="formData" value="#dateFormat(consulta_editar.user_data, 'dd/mm/yyyy')#" readonly/>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formVIN">VIN</label>
                    <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.vin#" readonly required/>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formModelo">Modelo</label>
                    <input type="text" class="form-control" name="modelo" id="formModelo" value="#consulta_editar.modelo#" readonly required/>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formEstacao">Estação</label>
                    <select class="form-control" name="estacao" id="formEstacao" required>
                      <option value="#consulta_editar.estacao#">#consulta_editar.estacao#</option>
                      <cfinclude template="auxi/estacao.cfm">
                    </select>
                  </div>
                </div>
              </div>
              <div class="row mb-4">
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formPeca">Peça</label>
                    <select class="form-control" name="peca" id="formPeca" required>
                      <option value="#consulta_editar.peca#" selected>#consulta_editar.peca#</option>
                      <option value="">Selecione a Peça</option>
                      <cfloop query="peca">
                        <cfoutput>
                          <option value="#defeito#">#defeito#</option>
                        </cfoutput>
                      </cfloop>
                    </select>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formlocal">Posição</label>
                    <select class="form-control" name="local" id="formlocal" required>
                      <option value="#consulta_editar.posicao#" selected>#consulta_editar.posicao#</option>
                      <cfinclude template="auxi/batalha_option.cfm">
                    </select>
                  </div>
                </div>
                <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formNConformidade">Problema</label>
                  <select class="form-control" name="NConformidade" id="formNConformidade" required>
                    <option value="#consulta_editar.problema#" selected>#consulta_editar.problema#</option>
                    <option value="">Selecione o Problema</option>
                    <cfloop query="problema">
                      <cfoutput>
                        <option value="#problema.defeito#">#problema.defeito#</option>
                      </cfoutput>
                    </cfloop>
                  </select>
                </div>
              </div>
              <div class="col col-3">
                <div class="form-group">
                  <label class="form-label" for="formCRITICIDADE">Criticidade</label>
                  <select class="form-control" name="criticidade" id="formCRITICIDADE" required>
                    <option value="#consulta_editar.CRITICIDADE#" selected>#consulta_editar.CRITICIDADE#</option>
                    <option value="N0">N0</option>
                    <option value="N1">N1</option>
                    <option value="N2">N2</option>
                    <option value="N3">N3</option>
                    <option value="N4">N4</option>
                    <option value="OK A-">OK A-</option>
                    <option value="AVARIA">AVARIA</option>
                  </select>
                </div>
              </div>
              </div>
                <div class="bt_ms mb-4">
                  <div class="col col-3">
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                      <cfif isDefined("form.vin") and form.vin neq "">
                          <cfquery name="atualiza" datasource="#BANCOSINC#">
                              UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
                              SET 
                                  PECA ='#UCase(form.peca)#', 
                                  POSICAO = '#UCase(form.local)#', 
                                  PROBLEMA = '#Ucase(form.NConformidade)#', 
                                  ESTACAO = '#UCase(form.estacao)#',
                                  CRITICIDADE = '#UCase(form.CRITICIDADE)#'
                              WHERE ID = '#url.id_editar#'
                          </cfquery>
                          <div class="alert alert-success" role="alert">
                              Atualizado com Sucesso
                          </div>
                          <meta http-equiv="refresh" content="1.5; url=fai_editar.cfm">
                      </cfif>
                  </div>
                  <div class="col col-3">
                    <button type="reset" id="bt_reset" onclick="self.location = 'fai_editar.cfm'" class="btn btn-warning">Voltar</button>
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
