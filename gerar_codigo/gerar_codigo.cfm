<cfinvoke method="inicializando" component="cf.ini.index">
   <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
   <cfheader name="Pragma" value="no-cache">
   <cfheader name="Expires" value="0">
   <cfcontent type="text/html; charset=UTF-8">
   <cfprocessingdirective pageEncoding="utf-8">
   
       <!---  Consulta  --->
       <cfquery name="consulta" datasource="#BANCOSINC#">
          SELECT *
          FROM INTCOLDFUSION.gerar_codigo
          ORDER BY ID DESC
       </cfquery>
   
       <!--- Verifica se o formulário foi enviado --->
       <cfif structKeyExists(form, "vin")>
         <!--- Obter próximo maxId --->
         <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.gerar_codigo
         </cfquery>
         
         <!--- Inserir novo registro --->
         <cfquery name="insere" datasource="#BANCOSINC#">
            INSERT INTO INTCOLDFUSION.gerar_codigo (ID, CODIGO) 
            VALUES (
               <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
               <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
            )
         </cfquery>
         <cfoutput>
            <script>
               window.location.href = 'gerar_codigo.cfm';
            </script>
         </cfoutput>
       </cfif>
   
       <!--- Deletar Item --->
       <cfif structKeyExists(url, "id") and url.id neq "">
         <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.gerar_codigo WHERE ID = 
            <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
         </cfquery>
         <script>
            self.location = 'gerar_codigo.cfm';
         </script>
       </cfif>
   
   <html lang="pt-BR">
      <head>
         <meta charset="utf-8">
         <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
         <title>Imprimir Etiquetas</title>
         <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
         <link rel="stylesheet" href="/qualidade/buyoff_linhat/assets/StyleBuyOFF.css?v1">
         <script src="./assets/script.js" defer></script>
         <style>
            .delete-btn {
               background-color: #ff4d4d;
               color: white;
               border: none;
               padding: 5px 10px;
               border-radius: 5px;
               cursor: pointer;
               transition: background-color 0.3s ease, transform 0.3s ease;
            }
         
            .delete-btn:hover {
               background-color: #ff1a1a;
               transform: scale(1.1);
            }
         
            .delete-btn:active {
               background-color: #e60000;
            }
         </style>
      </head>
   
      <body>
         <div class="container mt-4">
            <h2 class="titulo2">Imprimir Etiquetas</h2><br>
            <form method="post" id="form_envio">
               <div class="form-row">
                  <cfoutput>
                     <div class="form-group col-md-2">
                        <label for="formVIN">Código</label>
                        <input type="text" class="form-control form-control-sm" name="vin" id="formVIN" title="o VIN deve conter 17 caracteres" required="required" oninput="this.value = this.value.replace(/\s+/g, '')">
                     </div>
                  </cfoutput>
               </div>
               <div class="form-row">
                  <button style="display:none" type="submit" class="btn btn-primary">Enviar</button>
               </div>
            </form>
         </div>
         <div class="container col-12 bg-white rounded metas">
            <table class="table">
               <thead>
                  <tr class="text-nowrap">
                     <th scope="col">Código</th>
                     <th scope="col">Imprimir</th>
                     <th scope="col">Deletar</th>
                  </tr>
               </thead>
               <tbody class="table-group-divider">
                  <cfoutput query="consulta">
                     <tr class="align-middle">
                        <td style="text-align: center">#CODIGO#</td>
                        <td style="text-align: center">
                           <button onclick="self.location='gerarqr.cfm?vin=#CODIGO#'" type="button" class="btn btn-info" name="btSalvarID" minlength="12" maxlength="12" pattern=".{12}" value="#CODIGO#">Imprimir</button>
                        </td>
                        <td style="text-align: center">
                           <button class="delete-btn" onclick="deleteRecord(#ID#)">Deletar</button>
                        </td>            
                     </tr>
                  </cfoutput>
               </tbody>
            </table>
         </div>
         <script>
            function deleteRecord(id) {
               if (confirm('Tem certeza que deseja deletar este registro?')) {
                  window.location.href = 'gerar_codigo.cfm?id=' + id;
               }
            }
         </script>
      </body>
   </html>
