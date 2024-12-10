<nav>
  <input type="checkbox" id="check">
  <label for="check" class="checkbtn"><i class="icon icon-bars"></i></label>
  <div class="logo">Final Assembly</div>
  
  <ul>
    <li class="dropdown">
        <a href="fa_selecionar_buy_off.cfm">Barreiras</a>
        <ul class="dropdown-menu">
            <li class="dropdown-submenu">
                <a href="#">Barreira CP7</a>
                <ul class="submenu">
                    <li><a href="fa_barreira_cp7.cfm">CP7 SUV - ESTEIRA</a></li>
                    <li><a href="fa_barreira_cp7_hr.cfm">CP7 TRUCK</a></li>
                    <li><a href="fa_barreira_cp7_liberacao.cfm">LIBERAÇÃO REPAROS</a></li>
                </ul>
            </li>
            <li class="dropdown-submenu">
                <a href="#">Buy Off's</a>
                <ul class="submenu">
                    <li><a href="fa_barreira_T19.cfm">T19 SUV</a></li>
                    <li><a href="fa_barreira_T30.cfm">T30 SUV</a></li>
                    <li><a href="fa_barreira_T33.cfm">T33 SUV</a></li>
                    <li><a href="fa_barreira_C13.cfm">C13 SUV</a></li>
                    <li><a href="fa_barreira_F05.cfm">F05 SUV</a></li>
                    <li><a href="fa_barreira_F10.cfm">F10 SUV</a></li>
                    <li><a href="fa_barreira_hr.cfm">BUY OFF HR</a></li>
                </ul>
            </li>
        </ul>
    </li>
    
          <li><a href="fa_reparo.cfm">Reparo</a></li>
          <li class="dropdown">
            <a href="#">Liberação</a>
            <ul class="dropdown-menu">
              <li><a href="fa_liberacao_cp7.cfm">Liberação CP7</a></li>
                <li><a href="fa_liberacao_oka.cfm">Liberação OK A-</a></li>
            </ul>
        </li>
    <li class="dropdown">
        <a href="#">Relatórios</a>
        <ul class="dropdown-menu">
          <li><a href="fa_relatorios.cfm">Relatórios</a></li>
        <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
            <li><a href="fa_relatorios_1.cfm">Relatórios CP7</a></li>
<!---             <li><a href="fa_relatorios_summary.cfm">Relatórios BUY OFF's Summary</a></li> --->
        </cfif>
        </ul>
    </li>

    <li class="dropdown">
        <a href="#">Indicadores</a>
        <ul class="dropdown-menu">
            <li class="dropdown-submenu">
                <a href="#">Indicador CP7 SUV</a>
                <ul class="submenu">
                    <li><a href="./fa_indicadores_1_esteira.cfm">CP7 SUV 1º Turno</a></li>
                    <li><a href="./fa_indicadores_2_esteira.cfm">CP7 SUV 2º Turno</a></li>
                    <li><a href="./fa_indicadores_3_esteira.cfm">CP7 SUV 3º Turno</a></li>
                </ul>
            </li>
            <li class="dropdown-submenu">
                <a href="#">Indicador CP7 TRUCK</a>
                <ul class="submenu">
                    <li><a href="./fa_indicadores_1_hr.cfm">CP7 TRUCK 1º Turno</a></li>
                </ul>
            </li>
            <li class="dropdown-submenu">
                <a href="#">Indicador Buy Off's</a>
                <ul class="submenu">
                    <li><a href="./fa_indicadores_1.cfm">Buy Off 1º Turno</a></li>
                    <li><a href="./fa_indicadores_2.cfm">Buy Off 2º Turno</a></li>
                    <li><a href="./fa_indicadores_3.cfm">Buy Off 3º Turno</a></li>
                </ul>
            </li>
        </ul>
    </li>
    
        <li class="dropdown">
        <a href="#">Outros</a>
        <ul class="dropdown-menu">
        <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
            <li><a href="/qualidade/buyoff_linhat/adicionar_defeito.cfm">Adicionar Defeitos</a></li>
            <li><a href="./fa_editar.cfm">Editar Lançamento</a></li>
            <li><a href="/qualidade/relatorios/ver_agir.cfm">Ver & Agir</a></li>
        </cfif>
        <li><a href="./acompanhamento_massiva.cfm">Acompanhamento Massiva</a></li>
        <li><a href="./cadastro_defeitos.cfm">Adicionar Massiva</a></li>
        </ul>
        </li>
    <li><a href="logout.cfm">Sair</a></li>
  </ul>
</nav>


<style>

.dropdown-submenu {
  position: relative;
}

.submenu {
  display: none;
  position: absolute;
  left: 100%; /* Coloca o submenu fora do menu principal */
  top: 0;
  background-color: #4c8bf5; /* Azul claro */
  min-width: 150px; /* Ajuste conforme necessário */
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Sombra para destacá-lo */
  z-index: 1000; /* Garante que o submenu fique acima de outros elementos */
  border-radius: 8px; /* Bordas arredondadas */
}

.dropdown-submenu:hover .submenu {
  display: block;
}

.submenu li a {
  color: white; /* Texto branco para contraste */
  padding: 8px 16px;
  text-decoration: none;
  display: block;
  border-radius: 8px; /* Bordas arredondadas nos itens de link também */
}

.submenu li a:hover {
  background-color: #3a72c9; /* Azul mais escuro no hover */
}

/* Ajustes no menu dropdown principal para evitar sobreposição */
.dropdown-menu {
  z-index: 500; /* Garante que o menu dropdown principal não sobreponha o submenu */
}


  .container {
      margin-top: 100px;
      /* Ajuste esse valor conforme necessário */
  }

  .hidden {
      display: none;
  }

  body {
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      position: relative;
  }

  .titulo {
      width: 100%;
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
  }

  .titulo-img {
      width: 100%;
      height: 60px;
      object-fit: cover;
      position: relative;
  }

  .titulo-icon {
      position: absolute;
      left: 10px;
      z-index: 2;
      width: 50px;
      height: 50px;
  }

  .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
  }

  .navbar .navbar-brand {
      color: yellow !important;
      font-size: 25px;
  }

  .navbar {
      width: 100%;
      position: absolute;
      top: 0;
      z-index: 1000;
      /* Mantenha o z-index alto */
      background-color: transparent;
  }

  .titulo-texto {
      margin-top: center;
      position: absolute;
      top: 50%;
      right: -10%;
      transform: translate(-50%, -50%);
      color: white;
      font-size: 24px;
      text-align: center;
      z-index: 1;
  }

  .titulo-icon {
      position: absolute;
      left: 10px;
      top: 10px;
      z-index: 2;
      width: 50px;
      height: 50px;
  }

  h2 {
      font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
      margin-top: 10px;
      position: relative;
      text-align: center;
  }

  nav {
      background: #5434af;
      width: 100%;
      height: 80px;
      margin-bottom: 80px;
      position: fixed;
      /* Mantenha a posição fixa */
      top: 0;
      z-index: 10000;
      /* Defina um z-index mais alto para garantir que fique na frente */
      display: flex;
      justify-content: flex-start;
      align-items: center;
  }

  .logo {
      color: white;
      font-size: 35px;
      line-height: 80px;
      padding: 0 20px;
      /* Ajuste o padding conforme necessário */
      font-weight: bold;
  }

  nav ul {
      display: flex;
      list-style-type: none;
      margin: 0;
      padding: 0;
  }

  nav ul li {
      display: inline-block;
      line-height: 80px;
      margin: 0 5px;
  }

  nav ul li a {
      font-family: 'open_sansregular';
      color: #ffffff;
      font-size: 1em;
      padding: 8px 15px;
      border-radius: 4px;
      text-transform: uppercase;
      text-decoration: none;
  }

  a.active,
  a:hover {
      background-color: #ffef00;
      color: #393939;
      transition: 0.6s;
  }

  .checkbtn {
      font-size: 22px;
      color: #fff;
      line-height: 80px;
      margin-right: 20px;
      cursor: pointer;
      display: none;
  }

  #check {
      display: none;
  }

  @media (max-width: 952px) {
      .logo {
          font-size: 22px;
          padding-left: 20px;
      }

      nav ul li a {
          font-size: 16px;
      }
  }

  @media (max-width: 858px) {
      .checkbtn {
          display: block;
      }

      ul {
          position: fixed;
          width: 100%;
          height: 100vh;
          background: #1d075f;
          top: 80px;
          right: -100%;
          text-align: center;
          transition: all 0.5s;
      }

      nav ul li {
          display: block;
          margin: 50px 0;
          line-height: 30px;
      }

      nav ul li a {
          font-size: 20px;
      }

      a.active,
      a:hover {
          background: none;
          color: #5434af;
      }

      #check:checked ~ ul {
          right: 0;
      }
  }

  /* Estilos para o menu dropdown */
  .dropdown {
      position: relative;
      display: inline-block;
  }

  .dropdown-menu {
    display: none;
    position: absolute;
    background-color: #1d075f; /* Fundo do menu principal */
    min-width: 200px; /* Ajusta o tamanho do campo */
    box-shadow: 0 30px 16px 0 rgba(0,0,0,0.2); /* Sombra para o menu */
    z-index: 10000;
    top: 70px;
    left: 0;
    border-radius: 8px; /* Bordas arredondadas para o menu principal */
}

.dropdown:hover .dropdown-menu {
    display: block;
}

  .dropdown-menu li {
      list-style: none;
  } 

  .dropdown-menu li a {
      color: white;
      padding: 8px 16px;
      /* Ajuste o padding se necessário */
      text-decoration: none;
      display: block;
      text-align: left;
      font-size: 12px;
      /* Ajuste o tamanho da fonte aqui */
      line-height: 1.2;
      /* Ajuste o espaçamento entre linhas */
      letter-spacing: normal;
      /* Ajuste o espaçamento entre letras se necessário */
  }

  .dropdown-menu li a:hover {
      background-color: #5434af;
  }

  .dropdown:hover .dropdown-menu {
      display: block;
  }

  /* Adiciona um pequeno espaçamento para o dropdown quando o menu está visível */
  @media (max-width: 858px) {
      .dropdown-menu {
          position: static;
          width: 100%;
          box-shadow: none;
          top: 0;
          /* Ajuste conforme necessário */
      }
  }
</style>