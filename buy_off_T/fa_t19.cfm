<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">
    <!--- Verificando se está logado  --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
       alert("É necessario autenticação!!");
       self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
    </cfif>
    <cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "R">
    <script>
       alert("É necessário autorização!!");
       self.location= 'fa_reparo.cfm'
    </script>
    </cfif>
    <cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "P">
    <script>
       alert("É necessário autorização!!");
       self.location= 'fa_indicadores_1.cfm'
    </script>
    </cfif>
    <!---  Consulta  --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
       SELECT *
       FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
       WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
       AND BARREIRA = 'T19'
       <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
       AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')</cfif>
       ORDER BY ID DESC
    </cfquery>
    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
    <!--- Passo 1: Consulta para verificar se o VIN existe na tabela sistema_qualidade --->
    <cfquery name="consultaVIN" datasource="#BANCOSINC#">
       SELECT STATUS_BLOQUEIO, BARREIRA_BLOQUEIO 
       FROM sistema_qualidade_body 
       WHERE VIN = 
       <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>
    <!--- Passo 2: Verificar o STATUS_BLOQUEIO em todas as linhas retornadas --->
    <cfset bloqueado = false>
    <cfloop query="consultaVIN">
       <cfif consultaVIN.STATUS_BLOQUEIO EQ "BLOQUEADO" AND consultaVIN.BARREIRA_BLOQUEIO EQ "T19">
       <cfset bloqueado = true>
       <cfbreak>
       <!--- Para de verificar após encontrar um bloqueio --->
       </cfif>
    </cfloop>
    <!--- Se bloqueado for true, exibir uma mensagem em JavaScript e impedir o envio do formulário --->
    <cfif bloqueado>
       <script>
          // Cria e exibe o modal
          document.addEventListener("DOMContentLoaded", function() {
              var modalHtml = `
                  <div id="blockModal" style="display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5);">
                      <div style="background: white; padding: 20px; border-radius: 5px; text-align: center;">
                          <p>O veículo está bloqueado, separe o veículo e acione a Liderança!</p>
                          <button onclick="window.history.back()">Voltar</button>
                      </div>
                  </div>
              `;
              document.body.insertAdjacentHTML('beforeend', modalHtml);
          });
       </script>
       <cfabort>
    </cfif>
    <!--- Se o código chegou até aqui, significa que o VIN não está bloqueado. O formulário pode ser enviado. --->
    <!--- Passo 1: Consulta para verificar se o VIN existe na tabela sistema_qualidade --->
    <cfquery name="consultaVIN" datasource="#BANCOSINC#">
       SELECT STATUS_BLOQUEIO 
       FROM sistema_qualidade 
       WHERE VIN = 
       <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>
    <!--- Passo 2: Verificar o STATUS_BLOQUEIO em todas as linhas retornadas --->
    <cfset bloqueado = false>
    <cfloop query="consultaVIN">
       <cfif consultaVIN.STATUS_BLOQUEIO EQ "BLOQUEADO">
          <cfset bloqueado = true>
          <cfbreak>
          <!--- Para de verificar após encontrar um bloqueio --->
       </cfif>
    </cfloop>
    <!--- Se bloqueado for true, exibir uma mensagem em JavaScript e impedir o envio do formulário --->
    <cfif bloqueado>
       <script>
          // Cria e exibe o modal
          document.addEventListener("DOMContentLoaded", function() {
              var modalHtml = `
                  <div id="blockModal" style="display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5);">
                      <div style="background: white; padding: 20px; border-radius: 5px; text-align: center;">
                          <p>O veículo está bloqueado, separe o veículo e acione o responsável!</p>
                          <button onclick="window.location.href='./4fai_selecionar_desbloqueio.cfm'">Me leve a Página</button>
                          <button onclick="window.history.back()">Cancelar</button>
                      </div>
                  </div>
              `;
              document.body.insertAdjacentHTML('beforeend', modalHtml);
          });
       </script>
       <cfabort>
    </cfif>
    <!--- Se o código chegou até aqui, significa que o VIN não está bloqueado. O formulário pode ser enviado. --->
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
       SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
    </cfquery>
    </cfif>
    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
      <cfquery name="delete" datasource="#BANCOSINC#">
         DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA WHERE ID = 
         <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
      </cfquery>
      <script>
         self.location = 'fa_t19.cfm';
      </script>
    </cfif>
<html lang="pt-BR">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>T19</title>
      <link rel="icon" href="./assets/chery.png" type="image/x-icon">
      <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
      <script>
         function validarFormulario(event) {
             // Obtenha os valores dos campos
        var peçaInput = document.getElementById('formNConformidade');
        var peça = peçaInput.value;
        var problemaInput = document.getElementById('formProblema');
        var problema = problemaInput.value;

        // Obtenha as listas de opções dos datalists
        var pecasDatalist = document.getElementById('pecasList');
        var pecasOptions = pecasDatalist.options;

        var problemasDatalist = document.getElementById('problemasList');
        var problemasOptions = problemasDatalist.options;

        // Validação do campo "peça" (se preenchido)
        if (peça) {
            var isPeçaValid = false;
            for (var i = 0; i < pecasOptions.length; i++) {
                if (pecasOptions[i].value === peça) {
                    isPeçaValid = true;
                    break;
                }
            }
            if (!isPeçaValid) {
                alert('Por favor, selecione uma peça válida da lista.');
                event.preventDefault();
                return; // Sai da função para não executar o restante da validação
            }
        }

        // Validação do campo "problema" (se preenchido)
        if (problema) {
            var isProblemaValid = false;
            for (var i = 0; i < problemasOptions.length; i++) {
                if (problemasOptions[i].value === problema) {
                    isProblemaValid = true;
                    break;
                }
            }
            if (!isProblemaValid) {
                alert('Por favor, selecione um problema válido da lista.');
                event.preventDefault();
                return; // Sai da função para não executar o restante da validação
            }
        }
            // Validação geral dos campos
            var peça = document.getElementById('formNConformidade').value;
            var criticidade = document.getElementById('formCriticidade').value;
            var posição = document.getElementById('formPosicao').value;
            var responsável = document.getElementById('formEstacao').value;
            var problema = document.getElementById('formProblema').value;
            var vin = document.getElementById('formVIN').value;
         
            // Verificação do comprimento do VIN
            if (vin.length !== 17) {
               alert('O VIN deve ter exatamente 17 caracteres.');
               event.preventDefault(); // Impede o envio do formulário
               return false;
            }
         
            // Verificação dos primeiros 4 caracteres do VIN
            var vinPrefixo = vin.substring(0, 4);
            var vinPermitidos = ['95PJ', '95PZ', '95PB', '95PE', '95PD', '95PF'];
         
            if (!vinPermitidos.includes(vinPrefixo)) {
               alert('O VIN não existe');
               event.preventDefault(); // Impede o envio do formulário
               return false;
            }
         
            if (peça) {
               if (!posição) {
                     alert('Por favor, selecione uma posição.');
                     event.preventDefault(); // Impede o envio do formulário
                     return false;
               }
         
               if (!problema) {
                     alert('Por favor, selecione um problema.');
                     event.preventDefault(); // Impede o envio do formulário
                     return false;
               }
         
               if (!responsável) {
                     alert('Por favor, selecione um responsável.');
                     event.preventDefault(); // Impede o envio do formulário
                     return false;
               }
         
               if (!criticidade) {
                     alert('Por favor, selecione uma criticidade.');
                     event.preventDefault(); // Impede o envio do formulário
                     return false;
               }
            }
         
            // Validação do VIN com requisição AJAX
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'verificar_vin.cfm', true);
            xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function () {
               if (xhr.readyState === 4 && xhr.status === 200) {
                     var response = xhr.responseText.trim();
                     if (response === 'EXISTE_COM_CONDICAO') {
                        alert('O VIN já foi inserido como OK. Não é possível prosseguir com o VIN NG.');
                        event.preventDefault(); // Impede o envio do formulário
                     } else if (response === 'PROBLEMA_EXISTE_FORM_NULO') {
                        alert('O VIN já existe na tabela com um problema registrado. O campo PROBLEMA no formulário não pode estar vazio.');
                        event.preventDefault(); // Impede o envio do formulário
                     } else if (response === 'EXISTE') {
                        alert('O VIN já existe na tabela. Por favor, verifique os dados.');
                        event.preventDefault(); // Impede o envio do formulário
                     } else if (response === 'PERMITIR_ENVIO') {
                        // Permite o envio do formulário
                        document.getElementById('form_envio').submit();
                     } else {
                        document.getElementById('form_envio').submit();
                     }
               }
            };
            xhr.send('vin=' + vin + '&problema=' + problema + '&barreira=T19');
         
            // Impede o envio até a resposta da requisição AJAX
            event.preventDefault();
            }
      </script>
   </head>
   <body>
      <header class="titulo">
         <cfinclude template="auxi/nav_links.cfm">
      </header>
      <div class="container mt-4">
         <h2 class="titulo2">T19</h2><br>

         <cfquery name="pecas" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FA-T19-PEÇA'
            ORDER BY DEFEITO
         </cfquery>

         <cfquery name="defeitos" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FA-SUBMOTOR-PROBLEMA'
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
               WHERE USER_NAME = '#cookie.user_apontamento_fa#'
            </cfquery>

            <cfoutput>
               <div class="form-group col-md-2">
                  <label for="formNome">Inspetor</label>
                  <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required="required" value="#login.USER_SIGN#" readonly="readonly">
               </div>
            <cfquery name="consulta1" datasource="#BANCOSINC#">
               SELECT * FROM (
               SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_FA ORDER BY ID DESC)
               WHERE ROWNUM = 1
            </cfquery>
               <div class="form-group col-md-2">
                  <label for="formVIN">VIN</label>
                  <input type="text" class="form-control form-control-sm" minlength="17" name="vin" id="formVIN" title="Insira o VIN Completo" required="required" oninput="this.value = this.value.replace(/\s+/g, '')">
               </div>
            <script>
               // Adiciona um evento ao carregar a página para focar no campo
               document.addEventListener('DOMContentLoaded', function () {
                  const vinInput = document.getElementById('formVIN');
                  if (vinInput) {
                     vinInput.focus(); // Foca no campo VIN
                  }
               });
            </script>
               <div class="form-group col-md-2">
                  <label for="formModelo">Modelo</label>
                  <input type="text" class="form-control form-control-sm" name="modelo" id="formModelo" readonly="readonly">
                  <input id="modelo" name="modelo" type="hidden" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>">
               </div>
               <div class="form-group col-md-2">
                  <label for="formLocal">Local</label>
                  <select class="form-control form-control-sm" name="local" id="formLocal" required="required" readonly="readonly">
                     <option value="T19">T19</option>
                  </select>
            </cfoutput>
               </div>
      </div>
      <div class="form-row">
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
            <label for="formPosicao">
            Posição</label>
            <select class="form-control form-control-sm" name="posicao" id="formPosicao">
               <cfinclude template="auxi/batalha_option.cfm">
            </select>
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
               <option value="">
                  Selecione o Responsável:
               </option>
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
               <option value="CRIPPLE">CRIPPLE</option>
               <option value="OK A-">OK A-</option>
               <option value="AVARIA">AVARIA</option>
            </select>
         </div>
         <div class="form-group col-md-3">
            <input type="hidden" name="barcode" id="barcode" value="<cfif isDefined('buscaBarcode.BARCODE')>#buscaBarcode.BARCODE#<cfelse></cfif>">
         </div>
      </div>
      <div class="form-row"></div>
         <button type="submit" class="btn btn-primary">Enviar</button>
            <cfif isDefined("form.VIN") and form.VIN neq "">
               <cfquery name="buscaMES" datasource="#BANCOMES#">
                   select rtrim(ltrim(replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     replace(
                     p.name,'CONJUNTO',''),
                     'TRIM',''),
                     ' FL',''),
                     'BRANCO',''),
                     'GRB',''),
                     'BLP',''),
                     'WAP',''),
                     'PEROLA',''),
                     'PRATA',''),
                     'AZUL',''),
                     'PRETO',''),
                     'CINZA',''),
                     'TXS','PL7'),
                     'ESCURO',''),
                     'NOVO MOTOR',''),
                     'CINZA',''))) modelo,
                   p.name, g.vin, g.IDProduct, g.*
                   from CTBLGravacao g
                   left join TBLProduct p on g.IDProduct = p.IDProduct
                   where vin = UPPER('#form.VIN#')
                   order by g.DtCreation desc
                </cfquery>
                <!----acrescenta o barcode no banco de dados ---->
            <cfif isDefined("form.VIN") and form.VIN neq "">
               <cfquery name="buscaBarcode" datasource="#BANCOMES#">
                  select 
                  l.code as BARCODE,
                  g.VIN,
                  p.name,
                  g.IDProduct,
                  l.IDLot,
                  g.IDLot
                  from CTBLGravacao g
                  left join TBLLot l on g.IDLot = l.IDLot
                  left join TBLProduct p on g.IDProduct = p.IDProduct
                  where g.VIN = UPPER('#form.VIN#')
                  order by g.DtCreation desc
               </cfquery>
            </cfif>
                <!--- Inserir item --->
                <!-- Verifica se o VIN existe na BARREIRA 'T19' -->
                <!-- Verifica se o VIN já existe e obtém a USER_DATA se existir -->
                <cfquery name="verificaIntervalo" datasource="#BANCOSINC#">
                   SELECT INTERVALO
                   FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
                   WHERE VIN = 
                   <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
                   AND BARREIRA = 'T19'
                </cfquery>
                <!-- Verifica se a consulta retornou resultados -->
                <cfset intervaloInserir = "" />
                <cfset userDataInserir = Now() />
                <!-- Define um valor padrão para USER_DATA -->
                <cfif not IsNull(verificaIntervalo) AND verificaIntervalo.recordCount gt 0>
                <!-- Se o VIN existe na BARREIRA 'T19', usa o intervalo existente -->
                <cfset intervaloInserir = verificaIntervalo.INTERVALO>
                <!-- Obtém a USER_DATA se o VIN existir -->
                <cfquery name="verificaUserData" datasource="#BANCOSINC#">
                   SELECT USER_DATA
                   FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
                   WHERE VIN = 
                   <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
                   AND BARREIRA = 'T19'
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
                   INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_FA (ID, USER_DATA, USER_COLABORADOR, VIN, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, STATUS, ULTIMO_REGISTRO) 
                   VALUES (
                    <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#userDataInserir#" cfsqltype="CF_SQL_TIMESTAMP">,
                    <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#buscaBarcode.barcode#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#buscaMES.modelo#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#intervaloInserir#" cfsqltype="CF_SQL_VARCHAR">,
                    CASE
                    WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'N0' THEN 'LIBERADO'
                    WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'AVARIA' THEN 'LIBERADO'
                    WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'OK A-' THEN 'LIBERADO'
                    WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'N1' OR 
                    <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'N2' OR 
                    <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'N3' OR 
                    <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">= 'N4'  THEN 'EM REPARO'
                    ELSE 'LIBERADO'
                   END,
                   <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">)
                </cfquery>
                <cfoutput>
                   <script>
                      window.location.href = 'fa_t19.cfm';
                   </script>
                </cfoutput>
                </cfif>
                <button type="reset" class="btn btn-danger">Cancelar</button>
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
                      <th scope="col">BARCODE</th>
                      <th scope="col">Modelo</th>
                      <th scope="col">Barreira</th>
                      <th scope="col">Peça</th>
                      <th scope="col">Posição</th>
                      <th scope="col">Problema</th>
                      <th scope="col">Responsável</th>
                      <th scope="col">Criticidade</th>
                   </tr>
                </thead>
                <tbody class="table-group-divider">
                   <cfoutput query="consulta">
                      <tr class="align-middle">
                         <!-- Botão de exclusão -->
                         <td>
                            <span class="delete-icon-wrapper" onclick="deletar(#ID#);">
                            <i class="material-icons delete-icon" style="color: red;">
                            X</i>
                            </span>
                         </td>
                         <td>#ID#</td>
                         <td>#LSDateTimeFormat(USER_DATA, 'dd/mm/yyyy HH:nn:ss')#</td>
                         <td>#USER_COLABORADOR#</td>
                         <td>#VIN#</td>
                         <td>#BARCODE#</td>
                         <td>#MODELO#</td>
                         <td>#BARREIRA#</td>
                         <td>#PECA#</td>
                         <td>#POSICAO#</td>
                         <td>#PROBLEMA#</td>
                         <td>#ESTACAO#</td>
                         <td>#CRITICIDADE#</td>
                      </tr>
                   </cfoutput>
                </tbody>
             </table>
          </div>
          <!-- Script para deletar -->
          <script>
             function deletar(id) {
                 if (confirm("Tem certeza que deseja deletar este item?")) {
                     window.location.href = "fa_t19.cfm?id=" + id;
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