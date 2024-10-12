<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0">
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

    <!---  Consulta  --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
       SELECT *
       FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI
       WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
       AND BARREIRA = 'PDI'
       <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
       AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')</cfif>
       ORDER BY ID DESC
    </cfquery>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local")>
      <!--- Obter próximo maxId --->
      <cfquery name="obterMaxId" datasource="#BANCOSINC#">
         SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI
      </cfquery>
      </cfif>
      <!--- Deletar Item --->
      <cfif structKeyExists(url, "id") and url.id neq "">
      <cfquery name="delete" datasource="#BANCOSINC#">
         DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI WHERE ID = 
         <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
      </cfquery>
      <script>
         self.location = 'pdi_entrada.cfm';
      </script>
    </cfif>

<html lang="pt-BR">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>PDI - ENTRADA</title>
      <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
      <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
      <script src="./assets/script.js" defer></script>
      
   </head>

   <body>
      <!-- Header com as imagens e o menu -->
      <header class="titulo">
         <cfinclude template="auxi/nav_links.cfm">
      </header>
      <div class="container mt-4">
         <h2 class="titulo2">PDI - ENTRADA</h2><br>
         <form method="post" id="form_envio">
            <div class="form-row">
               <div class="form-group col-md-2">
                  <label for="formData">Data</label>
                  <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>"readonly="readonly">
               </div>
               <cfquery name="login" datasource="#BANCOSINC#">
                  SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                  WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PDI#'
               </cfquery>
               <cfoutput>
                  <div class="form-group col-md-2">
                     <label for="formNome">Colaborador</label>
                     <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required="required" value="#login.USER_SIGN#" readonly="readonly">
                  </div>
                  <cfquery name="consulta1" datasource="#BANCOSINC#">
                     SELECT * FROM (
                     SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_PDI ORDER BY ID DESC)
                     WHERE ROWNUM = 1
                  </cfquery>

                  <div class="form-group col-md-2">
                     <label for="formVIN">VIN</label>
                     <input type="text" class="form-control form-control-sm" name="vin" id="formVIN" title="o VIN deve conter 17 caracteres" required="required" minlength="17" maxlength="17" pattern=".{17}" oninput="this.value = this.value.replace(/\s+/g, '')">
                  </div>

                  <div style="display:none" class="form-group col-md-2">
                     <label style="display:none" for="formModelo">Modelo</label>
                     <input style="display:none" type="text" class="form-control form-control-sm" name="modelo" id="formModelo" readonly="readonly">
                     <input id="modelo" name="modelo" type="hidden" value="">
                 </div>

                  <div style="display:none" class="form-group col-md-2">
                     <label style="display:none" for="formLocal">Local</label>
                     <select style="display:none" class="form-control form-control-sm" name="local" id="formLocal" required readonly>
                        <option value="PDI">PDI</option>
                     </select>
               </cfoutput>
               </div>
               <div style="display:none" class="form-group col-md-2">
                  <label style="display:none" for="formPosicao">Localização</label>
                     <input style="display:none" type="text" class="form-control form-control-sm" name="posicao" id="formPosicao"value="ENTRADA" readonly>
                  </select>
               </div>
            </div>
            <div class="form-row">
            <button style="display:none" type="submit" class="btn btn-primary">Enviar</button>
            <!----acrescenta o modelo no banco de dados ---->
            <cfif isDefined("form.VIN") and form.VIN neq "">
            <!-- Verifica se o VIN já existe e obtém a USER_DATA se existir -->
            <cfquery name="verificaIntervalo" datasource="#BANCOSINC#">
               SELECT INTERVALO
               FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI
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
               FROM INTCOLDFUSION.SISTEMA_QUALIDADE_PDI
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
               INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_PDI (ID, USER_DATA, USER_COLABORADOR, VIN, MODELO, BARREIRA, INTERVALO, LOCALIZACAO) 
               VALUES (
               <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
               <cfqueryparam value="#userDataInserir#" cfsqltype="CF_SQL_TIMESTAMP">,
               <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#UCase(form.modelo)#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#intervaloInserir#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">
               )
            </cfquery>
            <cfoutput>
               <script>
                  window.location.href = 'pdi_entrada.cfm';
               </script>
            </cfoutput>
            </cfif>
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
                  <th scope="col">Localização</th>

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
                     <td>#LOCALIZACAO#</td>
                     <td>
                        <button onclick="self.location='gerarqr.cfm?vin=#VIN#'" type="button" class="btn btn-info" name="btSalvarID" value="#ID#">Imprimir</button>
                    </td>                    
                  </tr>
               </cfoutput>
            </tbody>
         </table>
      </div>
   </body>
</html>