<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Industrial Automotivo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        /* Imagem do banner */
        .banner {
            width: 100%;
            height: 300px;
            background-image: url('/qualidade/buyoff_linhat/imgs/teste1.jpg'); /* Coloque o link da imagem aqui */
            background-size: cover;
            background-position: center;
        }

        /* Estilos para o menu */
        nav {
            background-color: #333;
            color: white;
            padding: 15px 0;
            margin-top: -30px; /* Ajusta para ficar logo abaixo da imagem */
            width: 80%; /* Diminui a largura do menu */
            border-radius: 10px; /* Bordas arredondadas */
            margin-left: auto;
            margin-right: auto;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        nav ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        nav ul li {
            margin: 0 20px;
            position: relative; /* Necessário para o submenu aparecer */
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        nav ul li a:hover,
        nav ul li a:focus {
            background-color: #f1c40f;
            color: #333;
        }

        nav ul li a.active {
            background-color: #e67e22;
            color: white;
        }

        /* Submenu */
        nav ul li ul {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background-color: #333;
            border-radius: 5px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            width: 200px;
        }

        nav ul li:hover ul {
            display: block;
        }

        nav ul li ul li {
            margin: 0;
            padding: 10px;
            text-align: left;
        }

        nav ul li ul li a {
            padding: 10px 20px;
            border-radius: 0;
        }

        nav ul li ul li a:hover {
            background-color: #f1c40f;
            color: #333;
        }

        /* Estilo do logo */
        .logo {
            position: absolute;
            left: 30px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 24px;
            font-weight: bold;
            color: #fff;
            text-transform: uppercase;
        }

        /* Mobile */
        @media (max-width: 768px) {
            nav ul {
                flex-direction: column;
            }

            nav ul li {
                margin: 10px 0;
            }

            nav ul li ul {
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Banner -->
    <div class="banner">
        <!-- Logo posicionado sobre a imagem -->
        <div class="logo" style="color:blue">
        </div>
    </div>

    <!-- Menu -->
    <nav>
        <ul>
            <li>
                <a href="#" class="active">Início</a>
                <ul>
                    <li><a href="#">Opção 1</a></li>
                    <li><a href="#">Opção 2</a></li>
                    <li><a href="#">Opção 3</a></li>
                </ul>
            </li>
            <li><a href="#">Soluções</a></li>
            <li><a href="#">Produtos</a></li>
            <li><a href="#">Serviços</a></li>
            <li><a href="#">Sobre nós</a></li>
            <li><a href="#">Contato</a></li>
        </ul>
    </nav>

</body>
</html>
