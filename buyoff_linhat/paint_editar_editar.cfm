<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
      <script>
          alert("É necessario autenticação!!");
          self.location = 'index.cfm'
      </script>
  </cfif>
  <cfif not isDefined("cookie.USER_LEVEL_PAINT") or (cookie.USER_LEVEL_PAINT eq "R" or cookie.USER_LEVEL_PAINT eq "P" or cookie.USER_LEVEL_PAINT eq "I")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade
    WHERE ID = '#url.id_editar#'
    ORDER BY ID DESC
</cfquery>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>EDITAR ESTAÇÃO</title>
    <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
    <link rel="stylesheet" href="/qualidade/FAI/assets/style_editar.css?v2">
    <style>
      /* Global styles */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f8f9fa;
    color: #333;
    margin: 0;
    padding: 0;
}

.container {
    max-width: 1000px;
    margin: 40px auto;
    background-color: #fff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

h1.text-center {
    font-size: 2rem;
    font-weight: 600;
    color: #495057;
    margin-bottom: 20px;
    text-align: center;
    border-bottom: 2px solid #dee2e6;
    padding-bottom: 10px;
}

/* Form styles */
.form-group {
    margin-bottom: 20px;
}

.form-label {
    font-weight: 600;
    font-size: 1rem;
    color: #495057;
}

.form-control {
    width: 100%;
    padding: 0.5rem;
    font-size: 1rem;
    border: 1px solid #ced4da;
    border-radius: 5px;
    transition: all 0.3s ease;
    background-color: #f5f5f5;
}

.form-control:focus {
    border-color: #80bdff;
    outline: none;
    background-color: #fff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

.form-control-sm {
    padding: 0.25rem 0.5rem;
    font-size: 0.9rem;
}

select.form-control {
    background-color: #fff;
    cursor: pointer;
}

button.btn {
    padding: 10px 20px;
    font-size: 1rem;
    border-radius: 5px;
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.btn-primary {
    background-color: #007bff;
    border-color: #007bff;
    color: #fff;
}

.btn-primary:hover {
    background-color: #0056b3;
    border-color: #004085;
    box-shadow: 0 2px 8px rgba(0, 123, 255, 0.5);
}

.btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
    color: #fff;
}

.btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
    box-shadow: 0 2px 8px rgba(255, 193, 7, 0.5);
}

/* Layout adjustments */
.row {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
}

.col-3 {
    flex: 0 0 25%;
    max-width: 25%;
    padding: 0 15px;
}

.bt_ms {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
}

.alert-success {
    background-color: #d4edda;
    border-color: #c3e6cb;
    color: #155724;
    font-size: 1rem;
    margin-top: 20px;
    padding: 10px;
    border-radius: 5px;
}

    </style>
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

        <cfquery name="problema" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'PAINT'
            ORDER BY DEFEITO
        </cfquery>

    <h1 class="text-center mt-2">Editar</h1>
    <div class="container col-10">
        <form id="for-edit" method="POST">
            <cfoutput>
              <div class="row mb-4">
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formVIN">BARCODE</label>
                    <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.barcode#" readonly/>
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
                    <select class="form-control form-control-sm" name="peca" id="formPeca">
                      <option value="#consulta_editar.peca#">#consulta_editar.peca#</option>
                            <option value="PARALAMAS">PARALAMAS</option>
                            <option value="CAPÔ">CAPÔ</option>
                            <option value="PORTA RR RH">PORTA RR RH</option>
                            <option value="PORTA RR LH">PORTA RR LH</option>
                            <option value="PORTA FR RH">PORTA FR RH</option>
                            <option value="PORTA FR LH">PORTA FR LH</option>
                            <option value="TAMPA TRASEIRA">TAMPA TRASEIRA</option>
                            <option value="COLUNA A">COLUNA A</option>
                            <option value="COLUNA B">COLUNA B</option>
                            <option value="COLUNA C">COLUNA C</option>
                            <option value="TETO">TETO</option>
                            <option value="ASSOALHO">ASSOALHO</option>
                            <option value="COFRE DO MOTOR">COFRE DO MOTOR</option>
                            <option value="PORTINHOLA">PORTINHOLA</option>
                            <option value="SOLEIRA">SOLEIRA</option>
                            <option value="CAIXA DE RODAS">CAIXA DE RODAS</option>
                            <option value="CARROCERIA">CARROCERIA</option>
                    </select>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label class="form-label" for="formLocal">Posição</label>
                    <select class="form-control form-control-sm" name="local" id="formLocal">
                      <option value="#consulta_editar.posicao#">#consulta_editar.posicao#</option>
                        <cfoutput>
                          <cfinclude template="auxi/batalha_option.cfm">
                        </cfoutput>
                    </select>
                  </div>
                </div>
                <div class="col col-3">
                  <div class="form-group">
                    <label for="formNConformidade">Problema</label>
                        <select class="form-control form-control-sm" name="N_Conformidade" id="formNConformidade">
                            <option value="#consulta_editar.problema#">#consulta_editar.problema#</option>
                            <cfloop query="problema">
                                <cfoutput>
                                    <option value="#defeito#">#defeito#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
                  </div>
                </div>
                <div class="form-group col-md-3">
                  <label for="formCRITICIDADE">Criticidade</label>
                  <select class="form-control form-control-sm" name="criticidade" id="formCRITICIDADE">
                    <option value="#consulta_editar.criticidade#">#consulta_editar.criticidade#</option>
                      <option value="N0">N0</option>
                      <option value="N1">N1</option>
                      <option value="N2">N2</option>
                      <option value="N3">N3</option>
                      <option value="N4">N4</option>
                      <option value="OK A-">OK A-</option>
                  </select>
              </div>  
                </div>
              </div>
              <div class="row mb-4">
                <div class="bt_ms mb-4">
                  <div class="col col-3">
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                      <cfif isDefined("form.vin") and form.vin neq "">
                          <cfquery name="atualiza" datasource="#BANCOSINC#">
                              UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE
                              SET
                                  PECA ='#UCase(form.peca)#', 
                                  POSICAO = '#UCase(form.local)#',
                                  ESTACAO = '#UCase(form.estacao)#',
                                  MODELO = '#UCase(form.modelo)#',
                                  BARCODE = '#UCase(form.vin)#',
                                  CRITICIDADE = '#UCase(form.CRITICIDADE)#'
                              WHERE ID = '#url.id_editar#'
                          </cfquery>
                          <div class="alert alert-success" role="alert">
                              Atualizado com Sucesso
                          </div>
                          <meta http-equiv="refresh" content="1.5; url=paint_editar.cfm">
                      </cfif>
                  </div>
                  <div class="col col-3">
                    <button type="reset" id="bt_reset" onclick="self.location = 'paint_editar.cfm'" class="btn btn-warning">Voltar</button>
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
