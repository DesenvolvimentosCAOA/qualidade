<cfinvoke  method="inicializando" component="cf.ini.index">
 
    <!--Validar se o usuário existe-->
    <cfif isDefined("url.user")>
 
       <cfquery name="val" datasource="#BANCOSINC#">

         select * from intcoldfusion.usuarios_ferramenta_rastreio
         where lower(usuario) like lower('%#url.user#%')
         and lower(senha) like lower('%#url.password#%')

       </cfquery>
  
        <cfif val.recordCount gt 0 and val.permissao eq 0>
            <cfcookie name="userCall" value="#url.user#">
            <meta http-equiv="refresh" content="0; URL=../index.cfm"/>
        <cfelseif val.recordcount gt 0 and val.permissao eq 1 or val.permissao eq 2>
            <cfcookie name="userCall" value="#url.user#">
            <meta http-equiv="refresh" content="0; URL=../relatorio.cfm"/>
        <cfelse>
            
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
        
       </cfif>
    </cfif>

    <html lang="pt">
       <head><cfoutput>  
          <!-- Required meta tags -->
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>CAOATEC - Ferramenta Rastreio</title>
          <!-- plugins:css -->
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/iconfonts/ionicons/css/ionicons.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/iconfonts/typicons/src/font/typicons.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/iconfonts/flag-icon-css/css/flag-icon.min.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/css/vendor.bundle.base.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/vendors/css/vendor.bundle.addons.css">
          <link rel="stylesheet" href="#raizWeb#/cf/assets/css/chamada_ativa/arquivo.css?v=2">
          <!-- endinject -->
          <!-- plugin css for this page -->
          <!-- End plugin css for this page -->
          <!-- inject:css -->
          <link rel="stylesheet" href="#raizWeb#/cf/assets/css/shared/style.css?v=3">
          <!-- endinject -->
          <!-- Layout styles -->
          <link rel="stylesheet" href="#raizWeb#/cf/assets/css/demo_1/style.css?v=3">
          <!-- End Layout styles -->
          <link rel="shortcut icon" href="#raizWeb#/cf/assets/images/favicon.png"/>
 
 
       </head></cfoutput>
       
       <body>
         <cfset setLocale("Portuguese (Brazilian)")>
          <div class="container-scroller">
   
             <!-- partial -->
             <div class="main-panel">
                <div class="content-wrapper" style="height:100vh">
                   <!-- Page Title Header Starts-->
                   <div class="row page-title-header">
                      <div class="col-12">
                        <img src="/cf/assets/images/CAOATEC.png" alt="logo" style="height:10%;"/>
                        <h2>Autenticação para Ferramente de Rastreio</h2>
                        
                        <div class="container" style="margin-left:38%; padding-top: 2cm"><br>
                         
                            <form id="form1" name="form1" class="form-horizontal" action="index.cfm" method="GET">
                               
                               <div class="form-group">
                                 <label class="control-label col-sm-2"><h3>Usuário:</h4></label>
                                 <div class="col-sm-10">
                                   <input class="ele" type="text" min="0" placeholder="Informe seu usuário" name="user" value="<cfif isDefined("url.user")><cfoutput>#url.user#</cfoutput></cfif>" required>
                                  </div><br>  
                                 <div class="form-group">
                                 <label class="control-label col-sm-2"><h3>Senha:</h4></label>
                                 <div class="col-sm-10">
                                   <input class="ele" type="text" min="0" placeholder="Informe sua senha" name="password" value="<cfif isDefined("url.password")><cfoutput>#url.password#</cfoutput></cfif>" required>
                                   
                               </div>  
                                 </div>
                               </div><br> 
                               <div class="form-group">        
                                 <div class="col-sm-offset-2 col-sm-10">
                                     <button class="butt" type="submit" style="background-color: green; width: 6cm"> ENTRAR</button>
                                     
                                     <button class="butt" type="reset" style="background-color: RED; margin-left: 8px; width: 3.6cm"> CANCELAR</button>
                   
                            </form>
 
                           </div>
   
                        </body>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </body>
   </html> 
 <!---<cfcatch type="any">
   <br><br><br><br>
   <label  style="font-size:18; color: black; background-color: red; width: 14cm; border-radius: 5px">
   <h4> - ERROR!!! CONTATE O ADM DO SISTEMA /luiz.barreira</h3></label>
 </cfcatch>
 </cftry>--->