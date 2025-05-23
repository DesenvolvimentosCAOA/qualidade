<cfinvoke method="inicializando" component="cf.ini.index">
   <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
   <cfheader name="Pragma" value="no-cache">
   <cfheader name="Expires" value="0">
   <cfcontent type="text/html; charset=UTF-8">
   <cfprocessingdirective pageEncoding="utf-8">

   <!--- Verificando se está logado --->
   <cfif not isDefined("cookie.USER_APONTAMENTO_PDI") or cookie.USER_APONTAMENTO_PDI eq "">
      <script>
         alert("É necessario autenticação!!");
         self.location = '/qualidade/buyoff_linhat/index.cfm'
      </script>
   </cfif>
   <cfif not isDefined("cookie.user_level_pdi") or (cookie.user_level_pdi eq "R" or cookie.user_level_pdi eq "P" or cookie.user_level_pdi eq "E")>
   <script>
      alert("Você não tem autorização para acessar essa área!!");
      history.back(); // Voltar para a página anterior
   </script>
   </cfif>
   <!---  Consulta  --->
   <cfquery name="consulta" datasource="#BANCOSINC#">
      SELECT *
      FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
      WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
      AND BARREIRA = 'PDI'
      <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
      AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')</cfif>
      ORDER BY ID DESC
   </cfquery>
   <!--- Verifica se o formulário foi enviado --->
   <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
      <!--- Obter próximo maxId --->
      <cfquery name="obterMaxId" datasource="#BANCOSINC#">
         SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
      </cfquery>
   </cfif>
   <!--- Deletar Item --->
   <cfif structKeyExists(url, "id") and url.id neq "">
      <cfquery name="delete" datasource="#BANCOSINC#">
         DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA WHERE ID = 
         <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
      </cfquery>
      <script>
         self.location = 'pdi_saida.cfm';
      </script>
   </cfif>

   <html lang="pt-BR">
      <head>
         <!-- Required meta tags -->
         <meta charset="utf-8">
         <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no">
         <title>PDI - SAÍDA</title>
         <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
         <link rel="stylesheet" href="/qualidade/buyoff_linhat/assets/StyleBuyOFF.css?v1">
         <script>
            function validarFormulario(event) {
                // Obtenha os valores dos campos
                var peçaInput = document.getElementById('formNConformidade');
                var peça = peçaInput.value;
                var problemaInput = document.getElementById('formProblema');
                var problema = problemaInput.value;
                var criticidade = document.getElementById('formCriticidade').value;
                var posição = document.getElementById('formPosicao').value;
                var responsável = document.getElementById('formEstacao').value;
                var vin = document.getElementById('formVIN').value;
        
                // Validação do VIN (comprimento)
                if (vin.length !== 17) {
                    alert('O VIN deve ter exatamente 17 caracteres.');
                    event.preventDefault(); // Impede o envio do formulário
                    return false;
                }
        
                // Validação do campo "Peça"
                var peçaDatalist = document.getElementById('pecasList');
                var peçaOptions = peçaDatalist.options;
                var peçaIsValid = false;
                for (var i = 0; i < peçaOptions.length; i++) {
                    if (peçaOptions[i].value === peça) {
                        peçaIsValid = true;
                        break;
                    }
                }
        
                if (!peçaIsValid) {
                    alert('Por favor, selecione uma peça válida da lista. Caso não tenha acione a liderança para adicionar');
                    event.preventDefault();
                    return false;
                }
        
                // Validação do campo "Problema" (do novo datalist)
                var problemasDatalist = document.getElementById('problemasList');
                var problemasOptions = problemasDatalist.options;
                var problemaIsValid = false;
                for (var i = 0; i < problemasOptions.length; i++) {
                    if (problemasOptions[i].value === problema) {
                        problemaIsValid = true;
                        break;
                    }
                }
        
                if (!problemaIsValid) {
                    alert('Por favor, selecione um problema válido da lista. Caso não tenha acione a liderança para adicionar');
                    event.preventDefault();
                    return false;
                }
        
                // Validações adicionais
                if (peça) {
                    if (!posição) {
                        alert('Por favor, selecione uma posição.');
                        event.preventDefault();
                        return false;
                    }
        
                    if (!responsável) {
                        alert('Por favor, selecione um responsável.');
                        event.preventDefault();
                        return false;
                    }
        
                    if (!criticidade) {
                        alert('Por favor, selecione uma criticidade.');
                        event.preventDefault();
                        return false;
                    }
                }
        
                // AJAX para validação do VIN
                event.preventDefault(); // Impede o envio do formulário até a resposta da requisição AJAX
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'verificar_vin.cfm', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        var response = xhr.responseText.trim();
                        if (response === 'EXISTE_COM_CONDICAO') {
                            alert('O VIN já foi inserido como OK. Não é possível adicionar PROBLEMA.');
                        } else if (response === 'PROBLEMA_EXISTE_FORM_NULO') {
                            alert('O VIN já foi registrado com um problema.');
                        } else if (response === 'EXISTE') {
                            alert('VIN já registrado como OK. Impossível adicionar Defeitos');
                        } else if (response === 'PERMITIR_ENVIO') {
                            // Permite o envio do formulário
                            document.getElementById('form_envio').submit();
                        } else {
                            // Submete o formulário em caso de resposta inesperada
                            document.getElementById('form_envio').submit();
                        }
                    }
                };
        
                // Envia a requisição AJAX
                xhr.send('vin=' + vin + '&problema=' + problema + '&barreira=PDI');
            }
        
            // Associa a função de validação ao evento de envio do formulário
            document.getElementById('form_envio').addEventListener('submit', validarFormulario);
        </script>
      </head>
      <body>
         <!-- Header com as imagens e o menu -->
         <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
         </header>
         <div class="container mt-4">
            <h2 class="titulo2">PDI - SAÍDA</h2>
            <br>
            <cfquery name="pecas" datasource="#BANCOSINC#">
               SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
               WHERE SHOP = 'FA'
               ORDER BY DEFEITO
            </cfquery>
            <form onsubmit="return validarFormulario(event);" method="post" id="form_envio">
               <div class="form-row">
                  <div class="form-group col-md-2">
                     <label for="formData">Data</label>
                     <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>"readonly="readonly">
                  </div>
                  <cfquery name="login" datasource="#BANCOSINC#">
                     SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                     WHERE USER_NAME = '#cookie.user_apontamento_pdi#'
                  </cfquery>
                  <cfoutput>
                     <div class="form-group col-md-2">
                        <label for="formNome">Inspetor</label>
                        <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required="required" value="#login.USER_SIGN#" readonly="readonly">
                     </div>
                     <cfquery name="consulta1" datasource="#BANCOSINC#">
                        SELECT * FROM (
                        SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_PDI_SAIDA ORDER BY ID DESC)
                        WHERE ROWNUM = 1
                     </cfquery>
                     <div class="form-group col-md-2" style="position: relative;">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" minlength="17" name="vin" id="formVIN" title="Insira o VIN Completo" required="required" oninput="this.value = this.value.replace(/\s+/g, ''); saveVIN();" style="padding-right: 30px;">
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formNConformidade">Peça</label>
                        <input class="form-control form-control-sm" list="pecasList" name="N_Conformidade" id="formNConformidade" placeholder="Selecione a Peça">
                        <datalist id="pecasList">
                           <option value="">Selecione a Peça</option>
                           <cfloop query="pecas">
                              <cfoutput>
                                 <option value="#defeito#">#defeito#</option>
                              </cfoutput>
                           </cfloop>
                        </datalist>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formPosicao">Posição</label>
                        <select class="form-control form-control-sm" name="posicao" id="formPosicao">
                           <cfinclude template="auxi/batalha_option.cfm">
                        </select>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <select class="form-control form-control-sm" name="modelo" id="formModelo">
                            <option value="" selected disabled>Selecione um modelo</option>
                            <option value="AZERA">AZERA</option>
                            <option value="Tucson GLS/LTD">Tucson GLS/LTD</option>
                            <option value="KONA EV">KONA EV</option>
                            <option value="KONA HEV LTD">KONA HEV LTD</option>
                            <option value="IONIQ">IONIQ</option>
                            <option value="IX35 GLS">IX35 GLS</option>
                            <option value="SUBARU XV">SUBARU XV</option>
                            <option value="FORESTER">FORESTER</option>
                            <option value="SUBARU WRX">SUBARU WRX</option>
                            <option value="OUTBACK">OUTBACK</option>
                            <option value="SANTA FÉ">SANTA FÉ</option>
                            <option value="HR DA10/12">HR DA10/12</option>
                            <option value="HD80">HD80</option>
                            <option value="Tiggo 7 48v">Tiggo 7 48v</option>
                            <option value="Tiggo 7 48v ADAS">Tiggo 7 48v ADAS</option>
                            <option value="Tiggo 7 ADAS">Tiggo 7 ADAS</option>
                            <option value="Tiggo 7 TXS">Tiggo 7 TXS</option>
                            <option value="Tiggo 7 T">Tiggo 7 T</option>
                            <option value="Tiggo 7 ICE LOW">Tiggo 7 ICE LOW</option>
                            <option value="Tiggo 7 PRO">Tiggo 7 PRO</option>
                            <option value="Tiggo 5x PRO">Tiggo 5x PRO</option>
                            <option value="Tiggo 5x PRO ICE LOW">Tiggo 5x PRO ICE LOW</option>
                            <option value="Tiggo 5x PRO ADAS HIGH">Tiggo 5x PRO ADAS HIGH</option>
                            <option value="Tiggo 5x PRO ICE HIGH">Tiggo 5x PRO ICE HIGH</option>
                            <option value="Tiggo 5x 48v">Tiggo 5x 48v</option>
                            <option value="TIGGO 5x 48v ADAS LOW">TIGGO 5x 48v ADAS LOW</option>
                            <option value="Tiggo 5 T">Tiggo 5 T</option>
                            <option value="Tiggo 5 TXS">Tiggo 5 TXS</option>
                            <option value="TIGGO 8 FL3">TIGGO 8 FL3</option>
                            <option value="Tiggo 8 ADAS">Tiggo 8 ADAS</option>
                            <option value="Tiggo 8 TXS">Tiggo 8 TXS</option>
                            <option value="Tiggo 8 PHEV">Tiggo 8 PHEV</option>
                            <option value="Tiggo 7 PHEV">Tiggo 7 PHEV</option>
                            <option value="Arrizo 6">Arrizo 6</option>
                        </select>
                    </div>
                     <div style="display:none" class="form-group col-md-2">
                        <label style="display:none" for="formLocal">Local</label>
                        <select style="display:none" class="form-control form-control-sm" name="local" id="formLocal" required="required" readonly="readonly">
                           <option value="PDI">PDI</option>
                        </select>
                  </cfoutput>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formProblema">Problema</label>
                        <input class="form-control form-control-sm" list="problemasList" name="problema" id="formProblema" oninput="transformToUpperCase(this)">
                        <datalist id="problemasList">
                           <cfinclude template="auxi/problemas_option.cfm">
                        </datalist>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formEstacao">Responsável</label>
                        <select class="form-control form-control-sm" name="estacao" id="formEstacao" style="width: 200px;">
                           <option value="">Selecione o Responsável:</option>
                           <cfinclude template="auxi/estacao.cfm">
                        </select>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formCriticidade">Criticidade</label>
                        <select class="form-control form-control-sm" name="criticidade" id="formCriticidade">
                           <option value="">Selecione</option>
                           <option value="N0">N0</option>
                           <option value="N1">N1</option>
                           <option value="N2">N2</option>
                           <option value="N3">N3</option>
                           <option value="N4">N4</option>
                        </select>
                     </div>
                     <div class="form-group col-md-2">
                        <label for="formBateria">Bateria</label>
                        <input type="text" class="form-control form-control-sm" name="bateria" id="formBateria" placeholder="Digite a voltagem da bateria" required>
                    </div>
               </div>
               <div class="form-row">
                  
                  <div class="form-group col-md-3">
                     <input type="hidden" name="barcode" id="barcode" value="<cfif isDefined('buscaBarcode.BARCODE')>#buscaBarcode.BARCODE#<cfelse></cfif>">
                  </div>
               </div>
               <div class="form-row"></div>
               <button style="margin-left:10%" type="submit" class="btn btn-primary">Enviar</button>
               <!----acrescenta o modelo no banco de dados ---->
               <cfif isDefined("form.VIN") and form.VIN neq "">
               <!-- Verifica se o VIN já existe e obtém a USER_DATA se existir -->
               <cfquery name="verificaIntervalo" datasource="#BANCOSINC#">
                  SELECT INTERVALO
                  FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
                  WHERE VIN = 
                  <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
                  AND BARREIRA = 'PDI'
               </cfquery>
               <!-- Verifica se a consulta retornou resultados -->
               <cfset intervaloInserir = "" />
               <cfset userDataInserir = Now() />
               <!-- Define um valor padrão para USER_DATA -->
               <cfif not IsNull(verificaIntervalo) AND verificaIntervalo.recordCount gt 0>
                  <!-- Se o VIN existe na BARREIRA 'PDI', usa o intervalo existente -->
                  <cfset intervaloInserir = verificaIntervalo.INTERVALO>
                  <!-- Obtém a USER_DATA se o VIN existir -->
                  <cfquery name="verificaUserData" datasource="#BANCOSINC#">
                     SELECT USER_DATA
                     FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA
                     WHERE VIN = 
                     <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
                     AND BARREIRA = 'PDI'
                  </cfquery>
                  <cfset userDataInserir = verificaUserData.USER_DATA>
                  <!-- Copia a USER_DATA -->
                  <cfelse>
                  <!-- Caso contrário, define um novo INTERVALO -->
                  <cfset currentTime = TimeFormat(Now(), "HH:mm")> <!-- Formata a hora atual -->
                  <cfif currentTime gte '15:00' AND currentTime lt '15:50'>
                     <cfset intervaloInserir = '15:00'>
                     <cfelseif currentTime gte '15:50' AND currentTime lt '16:00'>
                     <cfset intervaloInserir = '15:50'>
                     <cfelse>
                     <cfset intervaloInserir = DateFormat(Now(), "HH") & ':00'>
                  </cfif>
               </cfif>
               <!-- Inserção com o intervalo e USER_DATA corretos -->
               <cfquery name="insere" datasource="#BANCOSINC#">
                  INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_PDI_SAIDA (
                      ID, USER_DATA, USER_COLABORADOR, VIN, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, STATUS, ULTIMO_REGISTRO, BATERIA
                  ) VALUES (
                      <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                      <cfqueryparam value="#userDataInserir#" cfsqltype="CF_SQL_TIMESTAMP">,
                      <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.modelo)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.local)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.N_Conformidade)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.posicao)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.problema)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#UCase(form.estacao)#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">,
                      <cfqueryparam value="#intervaloInserir#" cfsqltype="CF_SQL_VARCHAR">,
                      CASE
                          WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N0' THEN 'LIBERADO'
                          WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'AVARIA' THEN 'REPARO CAOA'
                          WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'OK A-' THEN 'LIBERADO'
                          WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N1' THEN 'REPARO PDI'
                          WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N2' OR 
                               <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N3' OR 
                               <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N4' THEN 'REPARO CAOA'
                          ELSE 'LIBERADO'
                      END,
                      <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                      <cfqueryparam value="#form.bateria#" cfsqltype="CF_SQL_VARCHAR">
                  )
              </cfquery>
               <cfoutput>
                  <script>
                     window.location.href = 'pdi_saida.cfm';
                  </script>
               </cfoutput>
               </cfif>
               <script>
                  const vinModelMap = {
                     "KMHF341EB": "AZERA",
                     "95PJ33ALX": "Tucson GLS/LTD",
                     "95PJ3812G": "Tucson GLS/LTD",
                     "KMHK281HF": "KONA EV",
                     "KMHK281EG": "KONA HEV LTD",
                     "KMHC851CG": "IONIQ",
                     "95PJV81DB": "IX35 GLS",
                     "JF1GT7LL5": "SUBARU XV",
                     "JF1GTELL5": "SUBARU XV",
                     "JF1SK7LL5": "FORESTER",
                     "JF1SKELL5": "FORESTER",
                     "JF1VAGL85": "FORESTER",
                     "JF1VAFLH3": "SUBARU WRX",
                     "JF1BSFLC2": "OUTBACK",
                     "KMHSU81ED": "SANTA FÉ",
                     "95PZBN7KP": "HR DA10/12",
                     "95PGA18FP": "HD80",
                     "95PEJL31D": "Tiggo 7 48v",
                     "95PEKL31D": "Tiggo 7 48v ADAS",
                     "95PEEL61D": "Tiggo 7 ADAS",
                     "95PACL51D": "Tiggo 7 TXS",
                     "95PAAL51B": "Tiggo 7 T",
                     "95PEFL31D": "Tiggo 7 ICE LOW",
                     "95PEDL61D": "Tiggo 7 PRO",
                     "95PBDK51D": "Tiggo 5x PRO",
                     "95PBFK31D": "Tiggo 5x PRO ICE LOW",
                     "95PBKK31D": "Tiggo 5x PRO ADAS HIGH",
                     "95PBDK31D": "Tiggo 5x PRO ICE HIGH",
                     "95PBJK31D": "Tiggo 5x 48v",
                     "95PBLK31D": "TIGGO 5x 48v ADAS LOW",
                     "95PBAK51B": "Tiggo 5 T",
                     "95PBCK51D": "Tiggo 5 TXS",
                     "95PFEM61D": "TIGGO 8 FL3",
                     "95PDEM61D": "Tiggo 8 ADAS",
                     "95PDCM61D": "Tiggo 8 TXS",
                     "LVTDB21B2": "Tiggo 8 TXS",
                     "LVTDB21B1": "Tiggo 8 TXS",
                     "LVVDB21B5": "Tiggo 8 TXS",
                     "LVTDB21BX": "Tiggo 8 TXS",
                     "LNNBBDAT0": "Tiggo 8 PHEV",
                     "LNNBBDAT1": "Tiggo 8 PHEV",
                     "LNNBBDAT2": "Tiggo 8 PHEV",
                     "LNNBBDAT3": "Tiggo 8 PHEV",
                     "LNNBBDAT4": "Tiggo 8 PHEV",
                     "LNNBBDAT5": "Tiggo 8 PHEV",
                     "LNNBBDAT6": "Tiggo 8 PHEV",
                     "LNNBBDAT7": "Tiggo 8 PHEV",
                     "LNNBBDAT8": "Tiggo 8 PHEV",
                     "LNNBBDAT9": "Tiggo 8 PHEV",
                     "LNNBBDATX": "Tiggo 8 PHEV" ,
                     "LVVDC21B0": "Arrizo 6",
                     "LVVDC21B1": "Arrizo 6",
                     "LVVDC21B2": "Arrizo 6",
                     "LVVDC21B3": "Arrizo 6",
                     "LVVDC21B4": "Arrizo 6",
                     "LVVDC21B5": "Arrizo 6",
                     "LVVDC21B6": "Arrizo 6",
                     "LVVDC21B7": "Arrizo 6",
                     "LVVDC21B8": "Arrizo 6",
                     "LVVDC21B9": "Arrizo 6",
                     "LVVDC21BX": "Arrizo 6"
                  };
              
                  const vinInput = document.getElementById("formVIN");
                  const modeloSelect = document.getElementById("formModelo");
              
                  vinInput.addEventListener("input", function() {
                      const vinValue = vinInput.value.trim();
                      if (vinValue.length >= 9) {
                          const vinPrefix = vinValue.substring(0, 9);
                          if (vinModelMap[vinPrefix]) {
                              modeloSelect.value = vinModelMap[vinPrefix]; // Preenche o select com o modelo correto
                          } else {
                              modeloSelect.value = ""; // Limpa se não houver correspondência
                          }
                      } else {
                          modeloSelect.value = "";
                      }
                  });
              
                  modeloSelect.addEventListener("change", function() {
                      // Aqui você pode adicionar qualquer ação caso o usuário selecione um modelo manualmente
                  });
              </script>
            </form>
         </div>
         <div class="container col-12 bg-white rounded metas">
            <table class="table">
               <thead>
                  <tr class="text-nowrap">
                     <!-- Coluna de ação -->
                     <th scope="col">Del</th>
                     <th scope="col">ID</th>
                     <th scope="col">Data</th>
                     <th scope="col">Colaborador</th>
                     <th scope="col">VIN</th>
                     <th scope="col">Modelo</th>
                     <th scope="col">Barreira</th>
                     <th scope="col">Peça</th>
                     <th scope="col">Posição</th>
                     <th scope="col">Problema</th>
                     <th scope="col">Responsável</th>
                     <th scope="col">Criticidade</th>
                     <th scope="col">Bateria</th>
                  </tr>
               </thead>
               <tbody class="table-group-divider">
                  <cfoutput query="consulta">
                     <tr class="align-middle">
                        <!-- Botão de exclusão -->
                        <td>
                           <span class="delete-icon-wrapper" onclick="deletar(#ID#);">
                              <i class="material-icons delete-icon" style="color: red;">X</i>
                           </span>
                        </td>
                        <td>#ID#</td>
                        <td>#LSDateTimeFormat(USER_DATA, 'dd/mm/yyyy HH:nn:ss')#</td>
                        <td>#USER_COLABORADOR#</td>
                        <td>#VIN#</td>
                        <td>#MODELO#</td>
                        <td>#BARREIRA#</td>
                        <td>#PECA#</td>
                        <td>#POSICAO#</td>
                        <td>#PROBLEMA#</td>
                        <td>#ESTACAO#</td>
                        <td>#CRITICIDADE#</td>
                        <td>#BATERIA#</td>
                     </tr>
                  </cfoutput>
               </tbody>
            </table>
         </div>
         <!-- Script para deletar -->
         <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "pdi_saida.cfm?id=" + id;
                }
            }
         </script>
         <script>
            document
                .getElementById('formVIN')
                .addEventListener('keypress', function (event) {
                    if (event.key === 'Enter') {
                        event.preventDefault(); // Evita o comportamento padrão do Enter
            
                        // Se você deseja mover para o próximo campo, descomente a linha abaixo
                        // document.getElementById('proximoCampoID').focus(); Se você deseja permanecer
                        // no mesmo campo, apenas deixe sem ações adicionais
                    }
                });
         </script>
      </body>
   </html>