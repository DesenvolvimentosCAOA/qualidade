<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<!--- Verificando se está logado --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = 'index.cfm'
        </script>
    </cfif>
    <cfif not isDefined("cookie.user_level_paint") or (cookie.user_level_paint eq "R" or cookie.user_level_paint eq "P")>
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Seleciona a Barreira</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <style>
            html, body {
                overflow: hidden;
                background-color: black;
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
            }
            /* Estilos para o vídeo */
            .video-background {
                position: fixed;
                top: 210px;
                left: 250;
                width: 60%;
                height: 60%;
                object-fit: cover;
                opacity: 0.5; /* Transparência do vídeo */
                z-index: -1;
            }
            .content {
                position: relative;
                z-index: 1;
                color: white; /* Para garantir que o texto seja visível sobre o vídeo */
            }
            /*Estilo para o menu paint_selecionar_buy_off.cfm */
            button {
                padding: 1.3em 3em;
                font-size: 18px;
                text-transform: uppercase;
                letter-spacing: 2.5px;
                font-weight: 500;
                color: #000;
                background-color: #fff;
                border: none;
                border-radius: 45px;
                box-shadow: 0px 8px 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease 0s;
                cursor: pointer;
                outline: none;
            }
            button:hover {
                background-color: #23c483;
                box-shadow: 0px 15px 20px rgba(46, 229, 157, 0.4);
                color: #fff;
                transform: translateY(-7px);
            }
            button:active {
                transform: translateY(-1px);
            }
            .navbar-nav {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                list-style: none;
                padding: 0;
                margin: 0;
            }
        </style>
    </head>
    <body>

        <div class="content">
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header>
            
            <div class="container mt-4">
                <h2 class="titulo2">Selecione a Barreira</h2><br><br>
            </div><br>
            
            <div class="navbar-nav">
                <video autoplay muted class="video-background">
                    <source src="/qualidade/buy_off_T/img/lv_0_20240912141226.mp4" type="video/mp4">
                    Seu navegador não suporta o elemento de vídeo.
                </video>
                <li class="nav-item">
                    <a href="/qualidade/buyoff_linhat/selecao_paint_ecoat.cfm"><button class="button">ECOAT</button></a>
                    <a href="/qualidade/buyoff_linhat/selecao_paint.cfm"><button class="button">Primer</button></a>
                    <a href="/qualidade/buyoff_linhat/selecao_paint_topcoat.cfm"><button class="button">Top Coat</button></a>
                </li><br><br><br><br>
                <li class="nav-item">
                    <a href="/qualidade/buyoff_linhat/selecao_paint_validacao.cfm"><button class="button">Validação de Qualidade</button></a>
                    <a href="/qualidade/buyoff_linhat/selecao_paint_liberacao.cfm"><button class="button">CP6</button></a>
                </li>
            </div>
        </div>
    </body>
    </html>