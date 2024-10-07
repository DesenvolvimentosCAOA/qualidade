<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sistema de Gestão da Qualidade</title>
    <link rel="stylesheet" href="./assets/style.css"/>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">

    <style>
        /* Estilos para centralizar o container dos botões */
        html, body {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            background: url('./assets/foto.jpg') no-repeat center center fixed; /* URL da imagem de fundo */
            background-size: cover; /* Cobrir toda a área da tela */
        }

        .wrap {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .button-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            max-width: 800px;
        }

        .button {
            min-width: 300px;
            min-height: 60px;
            display: inline-flex;
            font-family: 'Nunito', sans-serif;
            font-size: 22px;
            align-items: center;
            justify-content: center;
            text-transform: uppercase;
            text-align: center;
            letter-spacing: 1.3px;
            font-weight: 700;
            color: #313133;
            background: #4FD1C5;
            background: linear-gradient(90deg, rgba(129,230,217,1) 0%, rgba(79,209,197,1) 100%);
            border: none;
            border-radius: 1000px;
            box-shadow: 12px 12px 24px rgba(79,209,197,.64);
            transition: all 0.3s ease-in-out 0s;
            cursor: pointer;
            outline: none;
            position: relative;
            padding: 10px;
        }

        .button::before {
            content: '';
            border-radius: 1000px;
            min-width: calc(300px + 12px);
            min-height: calc(60px + 12px);
            border: 6px solid #00FFCB;
            box-shadow: 0 0 60px rgba(0,255,203,.64);
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0;
            transition: all .3s ease-in-out 0s;
        }

        .button:hover, 
        .button:focus {
            color: #313133;
            transform: translateY(-6px);
        }

        .button:hover::before, 
        .button:focus::before {
            opacity: 1;
        }

        .button::after {
            content: '';
            width: 30px; 
            height: 30px;
            border-radius: 100%;
            border: 6px solid #00FFCB;
            position: absolute;
            z-index: -1;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: ring 1.5s infinite;
        }

        .button:hover::after, 
        .button:focus::after {
            animation: none;
            display: none;
        }

        @keyframes ring {
            0% {
                width: 30px;
                height: 30px;
                opacity: 1;
            }
            100% {
                width: 300px;
                height: 300px;
                opacity: 0;
            }
        }

        /* Botão de sair */
        .logout-button {
            background: linear-gradient(45deg, #ff416c 0%, #ff4b2b 100%);
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.4s ease;
            z-index: 2;
        }

        .logout-button:hover {
            animation: pulse 1s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

        .logout-button:active {
            transform: scale(0.95);
        }

        /* Estilos responsivos */
        @media (max-width: 768px) {
            .button {
                padding: 12px 24px;
                font-size: 14px;
            }

            .logout-button {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>

    <a href="./index.cfm" class="logout-button">Sair</a>

    <h1 class="titulo-texto" id="typed-text"></h1>
    <script src="https://cdn.jsdelivr.net/npm/typed.js@2.0.12"></script>
        <script>
            var typed = new Typed('#typed-text', {
                strings: ["SISTEMA DE GESTAO DA QUALIDADE"],
                typeSpeed: 50,
                backSpeed: 25,
                loop: false,
                showCursor: false
            });
        </script>

        <!-- Container dos botões -->
        <div class="wrap">
            <div class="button-container">
              <!---  <a href="https://app.powerbi.com/view?r=eyJrIjoiN2I2MDQwYmYtNTg3Ny00ZGZhLThjZWQtODE1ZGUwMjJjODlmIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">DashBoard</a> --->
                <a href="https://app.powerbi.com/view?r=eyJrIjoiNjE3NGM3ZDItYzY3Ni00NWE1LTk2ZDItODBhMDVjOTc5MzA2IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">QC - Body</a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiYjhkNDFjMWYtZWMyNS00OWJkLThjODQtYmE5NGI1ZmIzZmIxIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">QC - Paint</a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiY2M2NjQ3NjYtZTZlYi00Yjc5LWE1ODItMjNmOGI3YzY3N2VmIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">QC - FA</a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiODk0ZDNmODgtMTc5MC00OTk4LTlmYTUtMzA2NmM0YTJhNjE3IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">QC - FAI</a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiMzQ2OWMxMDctZTNmYS00YjI2LTlhZDEtZTJjNTk2NWMwODMwIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button">QC - PDI</a>
            </div>
        </div>
    </body>
</html>
