<cfinvoke  method="inicializando" component="cf.ini.index">

    <cfif not isDefined("cookie.userCall")>
       <script>
        alert("É necessario autorização!!");
        self.location = 'login_rastreio/index.cfm'
       </script>
    </cfif>

    <!--- Deletar user --->
    <cfif structKeyExists(url, 'id') and url.id neq "">
      <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.usuarios_ferramenta_rastreio WHERE ID = '#url.id#'
      </cfquery>
      <script>
        self.location = 'cadastro.cfm';
      </script>
    </cfif>
 
     <html lang="pt">
         <head>
         <cfoutput>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Ferramenta - Rastreio</title>
             <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
             <link rel="stylesheet" href="/cf/assets/css/shared/style.css?v=6">
             <link rel="stylesheet" href="/cf/assets/css/demo_1/style.css?v=6">
             <link rel="stylesheet" href="/cf/assets/css/chamada_reposicao/reposicao.css?v=6">
             <link rel="stylesheet" href="auxi/style.css?v=2">
             <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
             <style>
               .bt_olho {
                   cursor: pointer;
                   margin-left: 5px;
               }
           </style>
         </cfoutput>
         </head>
         <body>
              <div class="container-scroller">
                 <!-- partial -->
                 <div class="main-panel">
                    <div class="content-wrapper" style="height:auto" >
                       <!-- Page Title Header Starts-->
                       <div class="row page-title-header">
                          <div class="col-12">
                             <cfoutput>
                            <session>
                               <img src="/cf/assets/images/CAOATEC.png" alt="logo" style="height:40%;"/>
                               </cfoutput>
                               <h3 class="page-title">Cadastro - Usuários</h4>
                                  <cfinclude  template="auxi/nav_links.cfm">
                            </session>
                            <div class="aut flex">
                               <cfif isDefined("cookie.user_chamada_001")>
                                  <label class="user_chamada_001"><strong>Usuário: </strong><cfoutput>#cookie.user_chamada_001#</cfoutput></label>
                                  <button id="logoff" onclick="expire_cookie();">Log Out</button>
                               </cfif>
                            </div>
                          </div>
                       </div>
     
                       <div class="col-md-13 ">
                          <div class="row justify-content-center">
                                
                            <cfoutput>
                                <div class="card" style="width: 45vw">
                                   <div class="card-body">
                                     <!--- Form cadastro --->
                                     <session class="flex column">
                                        <form class="infocall flex column" method="POST">
                                           
                                           
                                           <label class="lab"> Nome</label>
                                           <input type="text" name="usuario" class="pesq" <cfif isDefined("form.usuario")>value="#form.usuario#"</cfif>/> 

                                           <label class="lab"> Cracha</label>
                                           <input type="text" name="cracha" class="pesq" <cfif isDefined("form.cracha")>value="#form.cracha#"</cfif>/> 

                                           <label class="lab"> Nível</label>
                                           <select name="permissao" class="pesq" required>
                                             <option value=""></option>
                                             <option value="0"> 0 - Somente a Ferramenta</option>
                                             <option value="1"> 1 - Relatório + Ferramenta</option>
                                             <option value="2"> 2 - Acesso a tudo</option>
                                           </select>

                                           <label class="lab"> Senha <i>(Deve ser numérica de 4 dígitos)</i></label>
                                           <input type="password" name="senha" pattern="\d*" maxlength="4" class="pesq" <cfif isDefined("form.senha")>value="#form.senha#"</cfif>/> 

                                           <label class="lab"> Confirmar Senha</label>
                                           <input type="password" min="0" pattern="\d*" maxlength="4" name="csenha" class="pesq" <cfif isDefined("form.csenha")>value="#form.csenha#"</cfif>/> 
 
                                           <div class="bt flex row">
                                             <button type="reset" id="voltar" class="bott cancelar">Cancelar</button>
                                              <input type="submit" value="Cadastrar" id="enviar" class="bott">
                                           </div>
 
                                        </form>
 
                                        <!--- Armazenando informações na base de dados --->
                                        <cfif isDefined("form.cracha") and form.cracha neq "" and isDefined("form.usuario") and form.usuario neq ""  >

                                          <cfif form.senha neq form.csenha>
                                             <script>
                                                alert("Senhas distintas!!");
                                             </script>
                                          <cfelse>
                                             <cfquery name="validaLogin" datasource="#BANCOSINC#">
                                                SELECT cracha from INTCOLDFUSION.usuarios_ferramenta_rastreio
                                                WHERE cracha = '#form.cracha#'
                                             </cfquery>
                                             
                                             <!---      Valida se tem usuário com esse login          --->    
                                             <cfif validaLogin.RecordCount gt 0>
                                                <script>
                                                   alert("Já existe usuário com esse cracha!!")
                                                </script>
                                             <cfelse>
                                                <cfquery name="insert" datasource="#BANCOSINC#">
                                                   INSERT INTO INTCOLDFUSION.usuarios_ferramenta_rastreio (ID, CRACHA, USUARIO, PERMISSAO, SENHA, DATA_SAVE)
                                                   SELECT nvl(max(id),0)+1, '#form.cracha#', '#form.usuario#', '#form.permissao#', '#form.senha#', sysdate
                                                   FROM INTCOLDFUSION.usuarios_ferramenta_rastreio
                                                </cfquery>

                                                <script>
                                                   // Retirar botões no momento do envio
                                                   var bt = document.getElementsByClassName("bt");
                                                   bt[0].style.display = "none";
                                                </script>
      
                                                <label class="sucess">Usuário criado com sucesso !!!</label>
                                                <meta http-equiv="refresh" content="1.6, url=cadastro.cfm">
                                             </cfif>
                                          </cfif>
                                        </cfif>
                                     </session> 
                                 </div>
                              </div>

                              <div class="card-body">
                                 <!---         Usuários cadastrados          --->
                                    <h4 class="text-center"> Usuários cadastrados </h4>
                                    <cfquery name="usuarios" datasource="#BANCOSINC#">
                                       select * from INTCOLDFUSION.usuarios_ferramenta_rastreio
                                       where usuario not in ('teixeira', 'kennedy.rosario')
                                       order by usuario
                                    </cfquery>

                                    <table class="table table-striped mt-3">
                                       <thead>
                                          <tr>
                                             <th scope="col">Crachá</th>
                                             <th scope="col">Usuário</th>
                                             <th scope="col">Permissão</th>
                                             <th scope="col">Senha</th>
                                             <th scope="col"><i class="mdi mdi-delete bt_deletar"></i></th>
                                          </tr>
                                       </thead>

                                       <tbody class="table-group-divider">
                                          <cfloop query="usuarios">
                                             <tr>
                                                <td>#cracha#</td>
                                                <td>#usuario#</td>
                                                <td>#permissao#</td>
                                                <td>
                                                   <span id="senhaContainer">
                                                       <span id="senhaTexto">******</span>
                                                       <i onclick="toggleSenha(this, '#senha#')" class="mdi mdi-eye-outline bt_olho"></i>
                                                   </span>
                                               </td>
                                               <th scope="row">
                                                   <i onclick="deletar(#id#, '#usuario#');" class="mdi mdi-delete-outline bt_deletar"></i>
                                               </th>
                                           </tr>
                                          </cfloop>
                                       </tbody>
                                    </table>


                              </div>
                              </cfoutput>
                            </div>
                             
                          </div>
                       </div>
                    </div>
                 </div>
              </div>
 
          <script type="text/javascript">
            //Deletar Entrada 
            function deletar (id, usuario) {
               conf = confirm('Deseja realmente apagar esse login: ' + usuario + '?');
               if(conf == true){
               self.location = 'cadastro.cfm?id='+id
               }
            }
 
             // Remover cookie de login
             function expire_cookie() {
                 var data = new Date(2010,0,01);
                   // Converte a data para GMT
                   data = data.toGMTString();
                document.cookie = 'userCall=; expires=' + data + '; path=/';
                self.location = 'login_rastreio/index.cfm';
             }
          </script>
          <script>
            function toggleSenha(element, senhaReal) {
                const senhaContainer = element.parentNode;
                const senhaTexto = senhaContainer.querySelector('#senhaTexto');
                const isHidden = senhaTexto.textContent === '******';
                
                if (isHidden) {
                    senhaTexto.textContent = senhaReal; // Mostra a senha real
                    element.classList.remove('mdi-eye-outline');
                    element.classList.add('mdi-eye-off-outline');
                } else {
                    senhaTexto.textContent = '******'; // Oculta a senha
                    element.classList.remove('mdi-eye-off-outline');
                    element.classList.add('mdi-eye-outline');
                }
            }
        </script>
          <!---  Necessario para link com dropdown    --->
          <script src="/cf/assets/vendors/js/vendor.bundle.base.js"></script>
 
         </body>
      </html>