<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Personalizado</title>
    <style>
        /* Reseta o estilo padrão do navegador */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Estilo do corpo */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
        }

        /* Estilo do menu de navegação */
        .navbar {
            background-color: #333;
            padding: 10px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .nav-list {
            list-style-type: none;
            display: flex;
            justify-content: center;
            margin: 0;
        }

        .nav-item {
            position: relative;
            margin: 0 10px;
        }

        .nav-item a {
            color: #fff;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
            font-size: 16px;
            border-radius: 4px;
            transition: background-color 0.3s, transform 0.3s;
        }

        .nav-item a:hover {
            background-color: #575757;
            transform: scale(1.05);
        }

        .nav-item a.active {
            background-color: #ff9900;
            color: #fff;
        }

        /* Estilo do conteúdo para mostrar o efeito fixo do menu */
        .content {
            padding-top: 60px;
            text-align: center;
        }

        .section {
            padding: 60px 20px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <ul class="nav-list">
            <li class="nav-item"><a href="#home" class="active">Home</a></li>
            <li class="nav-item"><a href="#services">Serviços</a></li>
            <li class="nav-item"><a href="#about">Sobre</a></li>
            <li class="nav-item"><a href="#contact">Contato</a></li>
        </ul>
    </nav>
    <div class="content">
        <div id="home" class="section">Home Section</div>
        <div id="services" class="section">Serviços Section</div>
        <div id="about" class="section">Sobre Section</div>
        <div id="contact" class="section">Contato Section</div>
    </div>
</body>
</html>
