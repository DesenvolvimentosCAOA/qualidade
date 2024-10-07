<style>
  .a-destaque{
    color: #ff5100b6;
    text-decoration: underline
  }

  .color-white{
    color: white !important;
    text-decoration: underline;
  }
</style>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark" id="headerr">
    <img src="/cf/assets/images/CAOATEC.png" height="55" style="margin: 0px 20px 0px 10px" class="d-inline-block align-top" alt="Logo">
    <a class="navbar-brand" href="">Kanban Lotes</a>

    <div class="collapse navbar-collapse">
      <ul class="navbar-nav">

        <li class="nav-item active">
          <a class="nav-link" href="index.cfm">Principal</a>
        </li>

        <li class="nav-item">
          <a class="nav-link" href="restricoes.cfm">Restrições</a>
       </li>

        <li class="nav-item">
          <a class="nav-link" href="cadastro.cfm">Cadastro - Kits</a>
        </li>

        <li class="nav-item">
           <a class="nav-link" href="cadastroRestricoes.cfm">Cadastro - Restrições</a>
        </li>
        
      </ul>
    </div>

    <a href="https://www.flaticon.com/br/icones-gratis/pintura" title="pintura ícones" target="_blank"><img src="auxi/kanban.png" alt="Small" id="icone_kanban"></a>
  </nav>
  
  <cfif isDefined("cookie.user_pcp_small_adm") and cookie.user_pcp_small_adm neq "" and cgi.CF_TEMPLATE_PATH contains "cadastro"><cfoutput>
    <div class="input-group mb-3 user">
      <span class="form-control" placeholder="Recipient's username">#cookie.user_pcp_small_adm#</span>
      <div class="input-group-append">
        <button class="input-group-text" onclick="expire_cookie()"><img  src="assets/img/user.png" class="user_i"/><img  src="assets/img/next.png" class="user_i"/></button>
      </div>
    </div></cfoutput>
  </cfif><br>

  <script>
    // Alterar style do link atual
    const url = new URL(window.location.href);
    console.log(url.pathname)


    if(url.pathname.includes("cadastroRestricoes")== true){
      document.getElementsByClassName("nav-link")[3].classList.add("color-white");
    }

    else if(url.pathname.includes("cadastro.cfm")== true){
      document.getElementsByClassName("nav-link")[2].classList.add("color-white");
    }
    
    else if(url.pathname.includes("restricoes.cfm")== true){
      document.getElementsByClassName("nav-link")[1].classList.add("color-white");
    }

    else{
      document.getElementsByClassName("nav-link")[0].classList.add("color-white");
    }

  </script>