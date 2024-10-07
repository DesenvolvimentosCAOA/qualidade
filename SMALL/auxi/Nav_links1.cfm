<nav>
    <input type="checkbox" id="check">
        <label for="check" class="checkbtn">
            <i class="icon icon-bars"></i>
        </label>
        <div class="logo">SMALL</div>

        <ul>
            <li>
                <a href="small.cfm">Buy Off's</a>
            </li>
            <li>
                <a href="small_relatorio.cfm">Relatórios</a>
            </li>
            <li>
                <a style="color:red;" href="logout.cfm">Sair</a>
            </li>
        </ul>
    </nav>
    <style>
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
            background-color: #1d075f;
            min-width: 160px;
            box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
            z-index: 10000;
            top: 70px;
            /* Ajuste conforme necessário */
            left: 0;
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
            font-size: 14px;
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