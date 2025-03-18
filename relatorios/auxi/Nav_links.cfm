<nav>
    <input type="checkbox" id="check">
    <label for="check" class="checkbtn"><i class="icon icon-bars"></i></label>
    <div class="logo">Ferramentas Da Qualidade</div>
    
    <cfif isDefined("cookie.user_level_final_assembly") and cookie.user_level_final_assembly eq "G">
    </cfif>

    <ul>
        <li class="dropdown">
            <a href="#">Ver & Agir</a>
                <ul class="dropdown-menu">
                    <li><a href="/qualidade/relatorios/ver_agir_body.cfm">Lançamento</a></li>
                    <li><a href="/qualidade/relatorios/ver_agir.cfm">Acompanhamento</a></li>
                    <li class="dropdown-submenu">
                        <a href="#">Indicadores</a>
                        <ul class="submenu">
                            <li><a href="/qualidade/relatorios/indicador.cfm">STATUS</a></li>
                            <li><a href="/qualidade/relatorios/indicador_presenca_area.cfm">Presença</a></li>
                        </ul>
                    </li>
                    <li><a href="/qualidade/relatorios/ver_agir_apagar.cfm">Editar</a></li>
                </ul>
        </li>

        <li class="dropdown">
            <a href="#">Alertas</a>
                <ul class="dropdown-menu">
                    <li><a href="/qualidade/relatorios/alertas/d_principal.cfm">Lançamento</a></li>
                    <li><a href="/qualidade/relatorios/alertas/d_principal.cfm">Acompanhamento</a></li>
                    <li class="dropdown-submenu">
                        <a href="#">Indicadores</a>
                        <ul class="submenu">
                            <li><a href="">Em Desenvolvimento</a></li>
                        </ul>
                    </li>
                </ul>
        </li>
        <li class="dropdown">
            <a href="/qualidade/prova/index.cfm">Treinamento</a>
        </li>
        <li class="dropdown">
            <a href="#">Controle de Presença</a>
            <ul class="dropdown-menu">
                <li><a href="/qualidade/relatorios/presenca.cfm">Ver & Agir</a></li>
                <li><a href="#">Auditorias</a></li>
            </ul>
        </li>
      <li><a href="/qualidade/relatorios/logout.cfm">Sair</a></li>
    </ul>
  </nav>
<style>
    .dropdown-submenu {
            position: relative;
        }

        .submenu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            background-color: #001f36;
            min-width: 150px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            border-radius: 8px;
        }

        .dropdown-submenu:hover .submenu {
            display: block;
        }

        .submenu li a {
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            display: block;
            border-radius: 8px;
        }

        .submenu li a:hover {
            background-color: #FF0000;
        }
        .dropdown-submenu {
        position: relative;
        }
        .submenu {
        display: none;
        position: absolute;
        left: 100%; /* Coloca o submenu fora do menu principal */
        top: 0;
        background-color:rgb(4, 98, 170);
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
        background-color: #001f36; /* Azul mais escuro no hover */
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
            background: #000;
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
            background-color: #001f36;
            color: #FF0000;
            transition: 0.6s;
        }

        .checkbtn {
            font-size: 22px;
            color: #001f36;
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
                background: #001f36;
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
                color: #001f36;
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
            background-color: #001f36; /* Fundo do menu principal */
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
        display: flex;
        justify-content: space-between;
        padding: 5px 14px;
        } 

        .dropdown-menu li a {
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
            font-size: 12px;
            line-height: 1.2;
            letter-spacing: normal;
        }

        /* Hover do sub menu */
        .dropdown-menu li a:hover {
            background-color: #FF0000;
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