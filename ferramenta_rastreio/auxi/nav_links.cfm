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
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #007fff;" id="headerr">
    <img src="/cf/assets/images/CAOATEC.png" height="55" style="margin: 0px 20px 0px 10px" class="d-inline-block align-top" alt="Logo">
    <a class="navbar-brand" href="">Ferramenta de Rastreio</a>

    <div class="collapse navbar-collapse">
      <ul class="navbar-nav">
        <li class="nav-item active">
          <a class="nav-link" href="index.cfm">Ferramenta</a>
        </li>
      </ul>
    </div>

    <a href="https://www.flaticon.com/br/icones-gratis/pintura" title="pintura ícones" target="_blank"><img src="assets/img/montagem.png" alt="" id="icone_small"></a>
  </nav>


  <script>
    // Alterar style do link atual
    const url = new URL(window.location.href);
    console.log(url.pathname)

    if(url.pathname.includes("cadastro") == true){
      document.getElementById("navbarDropdown2").classList.add("color-white");

      if(url.pathname.includes("cadastrar_terceirizada") == true){
      document.getElementsByClassName("dropdown-item")[0].classList.add("a-destaque");
      }
      else if(url.pathname.includes("exportar")== true){
      document.getElementsByClassName("dropdown-item")[1].classList.add("a-destaque");
      }
      else if(url.pathname.includes("producao")== true){
      document.getElementsByClassName("dropdown-item")[2].classList.add("a-destaque");
      }
      else if(url.pathname.includes("adicionais")== true){
      document.getElementsByClassName("dropdown-item")[3].classList.add("a-destaque");
      }
    }

    else if(url.pathname.includes("cadastrar.cfm")== true){
      document.getElementsByClassName("nav-link")[0].classList.add("color-white");
    }

    else if(url.pathname.includes("cadastrar_terceirizada")== true){
      document.getElementsByClassName("nav-link")[1].classList.add("color-white");
    }

    else if(url.pathname.includes("exportar")== true){
      document.getElementsByClassName("nav-link")[2].classList.add("color-white");
    }

  </script>