<cfif not isDefined("cookie.USER_APONTAMENTO_PROVA") or cookie.USER_APONTAMENTO_PROVA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/prova/index.cfm'
    </script>
</cfif>

<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN 
    FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PROVA#'
</cfquery>

<cfif structKeyExists(form, "realizarProva")>
    <!--- Verifica se o USER_SIGN já existe na tabela treinamentos --->
    <cfquery name="verificaExistente" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS total
        FROM INTCOLDFUSION.treinamentos
        WHERE NOME = <cfqueryparam value="#UCase(login.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">
        AND TREINAMENTO = 'ABERTURA DE ALERTAS'
    </cfquery>

    <!--- Se não existir, insere o novo registro --->
    <cfif verificaExistente.total EQ 0>
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.treinamentos
        </cfquery>
        <cfquery name="insere" datasource="#BANCOSINC#">
            INSERT INTO INTCOLDFUSION.treinamentos (ID, DATA, NOME, TREINAMENTO)
            VALUES(
                <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                <cfqueryparam value="#UCase(login.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="ABERTURA DE ALERTAS" cfsqltype="CF_SQL_VARCHAR">
            )
        </cfquery>
    </cfif>

    <!--- Redireciona para a página inicial --->
    <cflocation url="/qualidade/prova/inicio.cfm">
</cfif>

<!DOCTYPE html>
<html lang="PT-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Abertura de Alertas</title>
        <style>
            body {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #1e1e2f; /* Fundo escuro para um visual moderno */
                color: #ffffff; /* Texto branco para contraste */
            }
            h1 {
                margin-bottom: 20px;
                font-size: 2.5rem;
                color: #00cc88; /* Verde para o título */
            }
            .slide-container {
                width: 80%;
                max-width: 800px;
                position: relative;
                overflow: hidden;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3); /* Sombra para destaque */
            }
            .slide-container img {
                width: 100%;
                height: auto;
                border: 2px solid #444;
                border-radius: 8px;
                transition: transform 0.2s ease-out;
                cursor: pointer; /* Cursor de clique */
            }
            .slide-container img.zoomed {
                transform: scale(2); /* Zoom aplicado */
                cursor: grab; /* Cursor de arrastar quando o zoom está ativo */
            }
            .slide-container img.zoomed:active {
                cursor: grabbing; /* Cursor de arrastando quando clicado */
            }
            .progress-bar-container {
                width: 80%;
                max-width: 800px;
                margin: 20px 0;
                background-color: #333;
                border-radius: 5px;
                overflow: hidden;
                position: relative;
            }
            .progress-bar {
                height: 20px;
                background-color: #00cc88; /* Verde para progresso */
                width: 0;
                transition: width 0.3s ease;
            }
            .progress-text {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                font-size: 14px;
                font-weight: bold;
                color: #fff;
            }
            .controls {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                width: 100%;
                display: flex;
                justify-content: space-between;
                pointer-events: none; /* Permite clicar através das setas */
            }
            .arrow {
                font-size: 2rem;
                color: #00cc88; /* Verde para as setas */
                cursor: pointer;
                background-color: rgba(0, 0, 0, 0.5); /* Fundo semi-transparente */
                border-radius: 50%;
                padding: 10px;
                pointer-events: all; /* Permite clicar nas setas */
                transition: background-color 0.3s ease, transform 0.3s ease;
            }
            .arrow:hover {
                background-color: rgba(0, 0, 0, 0.8); /* Fundo mais escuro ao passar o mouse */
                transform: scale(1.1); /* Efeito de escala ao passar o mouse */
            }
            .arrow-left {
                margin-left: 10px;
            }
            .arrow-right {
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <h1>Treinamento: Alertas</h1>
        <div class="slide-container">
            <img id="slide" src="/qualidade/prova/alerta_abertura/Slide1.jpg" alt="Slide 1">
            <div class="controls">
                <div class="arrow arrow-left" onclick="changeSlide(-1)">&#10094;</div> <!-- Seta esquerda -->
                <div class="arrow arrow-right" onclick="changeSlide(1)">&#10095;</div> <!-- Seta direita -->
            </div>
        </div>
        <div class="progress-bar-container">
            <div id="progressBar" class="progress-bar"></div>
            <div id="progressText" class="progress-text">0%</div>
        </div>

        <script>
            const slides = [];
            for (let i = 1; i <= 8; i++) {
                slides.push(`/qualidade/prova/alerta_abertura/Slide${i}.jpg`);
            }
        
            let currentSlide = 0;
            const slideImage = document.getElementById('slide');
            const progressBar = document.getElementById('progressBar');
            const progressText = document.getElementById('progressText');
            const arrowRight = document.querySelector('.arrow-right');
        
            // Variáveis para controle do zoom e movimento
            let isZoomed = false;
            let translateX = 0, translateY = 0;
        
            // Verifica se a imagem do primeiro slide existe
            const checkFirstImage = new Image();
            checkFirstImage.onload = function() {
                slideImage.src = slides[0];
                updateProgressBar();
            };
            checkFirstImage.onerror = function() {
                console.error('Imagem do primeiro slide não encontrada!');
                slideImage.alt = 'Imagem não disponível';
            };
            checkFirstImage.src = slides[0];
        
            function changeSlide(direction) {
                currentSlide += direction;
                
                // Verifica se a imagem existe antes de carregar
                const checkImage = new Image();
                checkImage.onload = function() {
                    slideImage.src = slides[currentSlide];
                    slideImage.style.display = 'block';
                };
                checkImage.onerror = function() {
                    console.error(`Imagem não encontrada: ${slides[currentSlide]}`);
                    slideImage.style.display = 'none';
                };
                checkImage.src = slides[currentSlide];
        
                // Desabilita a seta esquerda no primeiro slide
                document.querySelector('.arrow-left').style.display = currentSlide === 0 ? 'none' : 'block';
        
                // No último slide, a seta direita redireciona para inicio.cfm
                if (currentSlide === slides.length - 1) {
                    arrowRight.setAttribute('onclick', "saveAndRedirect()");
                } else {
                    arrowRight.setAttribute('onclick', 'changeSlide(1)');
                }
        
                updateProgressBar();
            }
        
            function updateProgressBar() {
                const progress = ((currentSlide) / (slides.length - 1)) * 100;
                progressBar.style.width = `${progress}%`;
                progressText.textContent = `${Math.round(progress)}%`;
            }
        
            // Função para aplicar/remover o zoom ao clicar na imagem
            slideImage.addEventListener('click', (event) => {
                if (!isZoomed) {
                    const rect = slideImage.getBoundingClientRect();
                    const offsetX = ((event.clientX - rect.left) / rect.width) * 100;
                    const offsetY = ((event.clientY - rect.top) / rect.height) * 100;
        
                    slideImage.classList.add('zoomed');
                    slideImage.style.transformOrigin = `${offsetX}% ${offsetY}%`;
                    isZoomed = true;
                } else {
                    slideImage.classList.remove('zoomed');
                    slideImage.style.transform = 'scale(1) translate(0, 0)';
                    isZoomed = false;
                    translateX = 0;
                    translateY = 0;
                }
            });
        
            // Função para mover a imagem com o zoom aplicado
            slideImage.addEventListener('mousemove', (event) => {
                if (isZoomed) {
                    const rect = slideImage.getBoundingClientRect();
                    const mouseX = event.clientX - rect.left;
                    const mouseY = event.clientY - rect.top;
        
                    const maxTranslateX = (rect.width * 0.25);
                    const maxTranslateY = (rect.height * 0.25);
        
                    translateX = Math.min(Math.max((rect.width / 2 - mouseX) * 0.2, -maxTranslateX), maxTranslateX);
                    translateY = Math.min(Math.max((rect.height / 2 - mouseY) * 0.2, -maxTranslateY), maxTranslateY);
        
                    slideImage.style.transform = `scale(2) translate(${translateX}px, ${translateY}px)`;
                }
            });
        
            function saveAndRedirect() {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = window.location.href;
        
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'realizarProva';
                input.value = '1';
        
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        
            // Inicializa corretamente
            window.addEventListener('DOMContentLoaded', (event) => {
                document.querySelector('.arrow-left').style.display = 'none';
                updateProgressBar();
            });
        </script>
    </body>
</html>