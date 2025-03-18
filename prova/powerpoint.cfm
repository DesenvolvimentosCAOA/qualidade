<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN 
    FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PROVA#'
</cfquery>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <!--- Verifica se o USER_SIGN já tem um registro em PROVAS_QUALIDADE com MATERIA = 'CHECK LIST' --->
    <cfquery name="verificaProva" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.PROVAS_QUALIDADE
        WHERE NOME = '#userSign#'
        AND MATERIA = 'CHECK LIST'
    </cfquery>

    <!--- Se existir, define alerta como "true" --->
    <cfif verificaProva.recordCount GT 0>
        <cfset alerta = "true">
    <cfelse>
        <cfset alerta = "false">
    </cfif>
<cfelse>
    <cfset alerta = "false">
</cfif>

<cfif structKeyExists(form, "realizarProva")>
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.treinamentos
    </cfquery>

    <!--- Inserir dados na tabela --->
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.treinamentos (ID, DATA, NOME, TREINAMENTO)
        VALUES(
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
            <cfqueryparam value="#UCase(login.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="Indicadores e Check List" cfsqltype="CF_SQL_VARCHAR">
        )
    </cfquery>

    <!--- Redirecionar para a página de prova --->
    <cflocation url="/qualidade/prova/prova.cfm">
</cfif>

<!DOCTYPE html>
<html lang="PT-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treinamento de PowerPoint</title>
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
        .arrow-red {
            color: #ff4d4d; /* Vermelho para a seta de "Realizar Prova" */
        }
        .arrow-red:hover {
            background-color: rgba(255, 77, 77, 0.8); /* Fundo mais escuro ao passar o mouse */
        }
        .prova-container {
            display: flex;
            align-items: center;
            background-color: rgba(255, 77, 77, 0.5); /* Fundo semi-transparente vermelho */
            border-radius: 50%;
            padding: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .prova-container:hover {
            background-color: rgba(255, 77, 77, 0.8); /* Fundo mais escuro ao passar o mouse */
            transform: scale(1.1); /* Efeito de escala ao passar o mouse */
        }
        .prova-text {
            font-size: 1rem;
            margin-right: 5px;
            color: #fff;
        }
    </style>
</head>
<body>
    <h1>Treinamento: Check List & Indicadores</h1>
    <div class="slide-container">
        <img id="slide" src="/qualidade/prova/slides/Slide1.JPG" alt="Slide 1">
        <div class="controls">
            <div class="arrow arrow-left" onclick="changeSlide(-1)">&#10094;</div> <!-- Seta esquerda -->
            <div class="arrow arrow-right" onclick="changeSlide(1)">&#10095;</div> <!-- Seta direita -->
        </div>
    </div>
    <div class="progress-bar-container">
        <div id="progressBar" class="progress-bar"></div>
        <div id="progressText" class="progress-text">0%</div>
    </div>
    <form id="provaForm" method="post" style="display: inline;">
        <input type="hidden" name="realizarProva" value="1">
        <button id="provaBtn" type="button" onclick="verificarProva()" style="display: none;">Realizar Prova</button>
    </form>

    <script>
        const slides = [];
        for (let i = 1; i <= 30; i++) {
            slides.push(`/qualidade/prova/slides/Slide${i}.JPG`);
        }

        let currentSlide = 0;
        const slideImage = document.getElementById('slide');
        const provaBtn = document.getElementById('provaBtn');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');
        const arrowRight = document.querySelector('.arrow-right');
        const controls = document.querySelector('.controls');

        // Variáveis para controle do zoom e movimento
        let isZoomed = false;
        let translateX = 0, translateY = 0;

        function changeSlide(direction) {
            currentSlide += direction;
            slideImage.src = slides[currentSlide];

            // Desabilita a seta esquerda no primeiro slide e a direita no último
            document.querySelector('.arrow-left').style.display = currentSlide === 0 ? 'none' : 'block';

            // Altera a seta direita para o container de "Realizar Prova" no último slide
            if (currentSlide === slides.length - 1) {
                arrowRight.style.display = 'none'; // Oculta a seta direita
                const provaContainer = document.createElement('div');
                provaContainer.className = 'prova-container';
                provaContainer.setAttribute('onclick', 'verificarProva()');
                provaContainer.innerHTML = `
                    <span class="prova-text">Realizar Prova</span>
                    <span class="arrow arrow-red">></span>
                `;
                controls.appendChild(provaContainer);
            } else {
                arrowRight.style.display = 'block'; // Mostra a seta direita
                const provaContainer = document.querySelector('.prova-container');
                if (provaContainer) {
                    provaContainer.remove(); // Remove o container de "Realizar Prova"
                }
            }

            updateProgressBar();
        }

        function updateProgressBar() {
            const progress = ((currentSlide + 1) / slides.length) * 100;
            progressBar.style.width = `${progress}%`;
            progressText.textContent = `${Math.round(progress)}%`;
        }

        function verificarProva() {
            var alerta = "<cfoutput>#alerta#</cfoutput>";

            if (currentSlide === slides.length - 1) {
                if (alerta === "true") {
                    alert("Você já realizou esta prova");
                    window.location.href = "inicio.cfm";
                } else {
                    document.getElementById("provaForm").submit();
                }
            }
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
                slideImage.style.transform = 'scale(1) translate(0, 0)'; // Reseta o zoom e a posição
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

                // Limita o deslocamento para que a imagem não saia dos limites
                const maxTranslateX = (rect.width * 0.25); // 25% da largura da imagem
                const maxTranslateY = (rect.height * 0.25); // 25% da altura da imagem

                // Calcula o deslocamento com base na posição do mouse
                translateX = Math.min(Math.max((rect.width / 2 - mouseX) * 0.2, -maxTranslateX), maxTranslateX);
                translateY = Math.min(Math.max((rect.height / 2 - mouseY) * 0.2, -maxTranslateY), maxTranslateY);

                // Aplica o deslocamento à imagem
                slideImage.style.transform = `scale(2) translate(${translateX}px, ${translateY}px)`;
            }
        });

        updateProgressBar();
    </script>
</body>
</html>