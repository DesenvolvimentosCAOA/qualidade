<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sistema de Gestão da Qualidade</title>
    <link rel="stylesheet" href="./assets/style.css"/>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    <style>
        /* Estilos para o vídeo de fundo */
        html, body {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        /* Estilo do vídeo para cobrir toda a tela */
        .background-video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover; /* Faz o vídeo cobrir toda a tela */
            z-index: -1; /* Coloca o vídeo atrás dos elementos */
        }
        /* Estilos para centralizar os botões */
        .wrap {
            display: flex;
            flex-direction: column; /* Empilha as linhas verticalmente */
            align-items: center;    /* Centraliza horizontalmente */
            justify-content: center; /* Centraliza verticalmente */
            gap: 20px;              /* Espaçamento entre as linhas */
            width: 100%;
            height: 100vh;          /* Garante que ocupa a altura total da página */
            overflow: hidden;       /* Certifica-se de evitar transbordo */
            position: relative;
        }

        .button-container {
            display: flex;
            flex-direction: row; /* Coloca os botões em linha */
            justify-content: center; /* Mantém os botões centralizados horizontalmente */
            align-items: center; /* Centraliza os botões verticalmente */
            gap: 20px; /* Espaço entre os botões */
            width: 100%; /* Largura total disponível */
            position: relative; /* Posiciona os botões em relação ao contêiner */
            left: -10%; /* Move os botões um pouco para a esquerda */
        }

        .bottom-buttons {
            margin-top: -50px; /* Remove ajustes de margem para manter controle pelo `gap` */
        }


        .button {
            min-width: 150px;
            min-height: 40px;
            display: inline-flex;
            font-family: 'Nunito', sans-serif;
            font-size: 14px;
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
            opacity: 0; /* Inicialmente invisível */
            animation: fadeIn 1s forwards; /* Animação fade-in */
        }

       /* Animação fade-in */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px); /* Suave movimento de baixo para cima */
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Delays para os botões da primeira linha */
        .button-container:nth-child(1) .button:nth-child(1) {
            animation-delay: 0s;
        }
        .button-container:nth-child(1) .button:nth-child(2) {
            animation-delay: 0.5s;
        }
        .button-container:nth-child(1) .button:nth-child(3) {
            animation-delay: 1s;
        }
        .button-container:nth-child(1) .button:nth-child(4) {
            animation-delay: 1.5s;
        }
        .button-container:nth-child(1) .button:nth-child(5) {
            animation-delay: 2s;
        }

        /* Delays para os botões da segunda linha (após a primeira concluir) */
        .button-container:nth-child(2) .button:nth-child(1) {
            animation-delay: 2.5s;
        }
        .button-container:nth-child(2) .button:nth-child(2) {
            animation-delay: 3s;
        }
        .button-container:nth-child(2) .button:nth-child(3) {
            animation-delay: 3.5s;
        }

        /* Estilos para o botão de logout */
        .Btn {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            width: 45px;
            height: 45px;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            position: absolute;  /* Permanece absoluto */
            top: 20px;
            right: 20px;
            overflow: hidden;
            transition-duration: .3s;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.199);
            background-color: rgb(255, 65, 65);
            z-index: 9999;  /* Garante que o botão "Sair" fique por cima de outros elementos */
        }

        .sign {
            width: 100%;
            transition-duration: .3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sign svg {
            width: 17px;
        }

        .sign svg path {
            fill: white;
        }

        .text {
            position: absolute;
            right: 0%;
            width: 0%;
            opacity: 0;
            color: white;
            font-size: 1.2em;
            font-weight: 600;
            transition-duration: .3s;
        }

        .Btn:hover {
            width: 125px;
            border-radius: 40px;
            transition-duration: .3s;
        }

        .Btn:hover .sign {
            width: 30%;
            transition-duration: .3s;
            padding-left: 20px;
        }

        .Btn:hover .text {
            opacity: 1;
            width: 70%;
            transition-duration: .3s;
            padding-right: 10px;
        }

        .Btn:active {
            transform: translate(2px ,2px);
        }

        /* Estilos responsivos */
        @media (max-width: 768px) {
            .button {
                padding: 12px 24px;
                font-size: 14px;
            }

            .Btn {
                width: 40px;
                height: 40px;
            }

            .Btn .text {
                font-size: 1em;
            }

            .logout-button {
                font-size: 14px;
                padding: 8px 16px;
            }
        }

        .button-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            height: 100vh;
            margin-left:20%;
        }

        .hint {
            text-decoration: none;
            position: relative;
            display: inline-block;
        }

        .hint-dot {
            background-color: #000;
            color: #fff;
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: bold;
            font-size: 30px;
            transition: background-color 0.3s;
            text-align: center;
        }

        .hint-dot:hover {
            background-color: #333;
        }

        .hint-content {
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background-color: #333;
            color: white;
            padding: 10px;
            border-radius: 5px;
            font-size: 25px;
            text-align: center;
            visibility: hidden;
            opacity: 0;
            transition: opacity 0.3s, visibility 0.3s;
            white-space: nowrap;
        }

        .hint:hover .hint-content {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>

    <body>
        <!-- Vídeo de fundo -->
        <video class="background-video" autoplay muted loop>
            <source src="./imgs/dash.mp4" type="video/mp4">
            Seu navegador não suporta vídeos.
        </video>
        <!-- Botão de Logout -->
        <a href="./index.cfm" class="Btn">
            <div class="sign">
                <svg viewBox="0 0 512 512">
                    <path d="M377.9 105.9L500.7 228.7c7.2 7.2 11.3 17.1 11.3 27.3s-4.1 20.1-11.3 27.3L377.9 406.1c-6.4 6.4-15 9.9-24 9.9c-18.7 0-33.9-15.2-33.9-33.9l0-62.1-128 0c-17.7 0-32-14.3-32-32l0-64c0-17.7 14.3-32 32-32l128 0 0-62.1c0-18.7 15.2-33.9 33.9-33.9c9 0 17.6 3.6 24 9.9zM160 96L96 96c-17.7 0-32 14.3-32 32l0 256c0 17.7 14.3 32 32 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32l-64 0c-53 0-96-43-96-96L0 128C0 75 43 32 96 32l64 0c17.7 0 32 14.3 32 32s14.3 32 32 32c53 0 96 43 96 96l0 256c0 53-43 96-96 96z"></path>
                </svg>
            </div>
            <div class="text">Sair</div>
        </a>
        <!-- Texto animado -->
        <script src="https://cdn.jsdelivr.net/npm/typed.js@2.0.12"></script>
        <script>
            var typed = new Typed('.typed-text', {
                strings: ["Sistema de Gestão da Qualidade", "Monitoramento da qualidade"],
                typeSpeed: 100,
                backSpeed: 50,
                loop: true
            });
        </script>
        <div class="wrap">
            <div class="button-container bottom-buttons">
                <a href="https://app.powerbi.com/view?r=eyJrIjoiYTU4Y2JiNGEtNDY5My00ZjQ0LWI1OTMtZDQ3OTg2NTE3MmE3IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">BODY</div>
                    <div class="hint-content">Dashboard-Body</div>
                </a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiZWVlY2I2MDctODAzOC00ZGRhLTkyOTYtYmQzYWQ4M2VhNTIwIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">PAINT</div>
                    <div class="hint-content">Dashboard-Paint</div>
                </a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiNGYxMDIyM2UtMjY0Ni00YTBiLWJiZDItZjZjYmY0MDQxZDQ5IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">FA</div>
                    <div class="hint-content">Dashboard-FA</div>
                </a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiNmM1YzgwODQtZjBlMi00ZmE0LWFkMTEtNDAyMjZkZWRhZTg0IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">FAI</div>
                    <div class="hint-content">Dashboard-FAI</div>
                </a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiOTVjM2Y1ZjMtNjUxZC00Yzk4LWI3NmYtZTMyYWEwZWE4OWI2IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">PDI</div>
                    <div class="hint-content">Dashboard-PDI</div>
                </a>
            </div>
            <div class="button-container bottom-buttons">
                <a href="https://app.powerbi.com/view?r=eyJrIjoiYmZkNzkwZmQtNDZlMy00OGQ0LThlMzQtOTVlMzExOWUwMTBhIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">Field Issues</div>
                    <div class="hint-content">KPI-Field Issues</div>
                </a>
                <a href="https://app.powerbi.com/view?r=eyJrIjoiOTAwNTdlY2ItN2RlMC00MWM5LThlNDItMWEwNzRkZWM2ZmZkIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint">
                    <div class="hint-dot">RNC's</div>
                    <div class="hint-content">KPI RNC</div>
                </a>
            </div>
        </div>
    </body>
</html>
