<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
</cfquery>

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
    <title>Apresentação PowerPoint</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .slide-container {
            width: 80%;
            max-width: 800px;
            position: relative;
            overflow: hidden;
        }
        .slide-container img {
            width: 100%;
            height: auto;
            border: 2px solid #ccc;
            border-radius: 8px;
            transition: transform 0.2s ease-out;
        }
        .slide-container:hover img {
            transform: scale(2); /* Ampliação da imagem ao passar o mouse */
            cursor: zoom-in;
        }
        .slide-container img {
            transform-origin: center; /* Ponto de origem do zoom */
        }
        .slide-container:hover img {
            transform-origin: var(--mouse-x) var(--mouse-y); /* Define a origem do zoom com base no cursor */
        }
        .progress-bar-container {
            width: 80%;
            max-width: 800px;
            margin: 20px 0;
            background-color: #ddd;
            border-radius: 5px;
            overflow: hidden;
            position: relative;
        }
        .progress-bar {
            height: 20px;
            background-color: #007bff;
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
            margin-top: 20px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            margin: 0 10px;
            cursor: pointer;
            border: none;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
        }
        button:hover {
            background-color: #0056b3;
        }
        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .red-button {
            background-color: #dc3545; /* Cor vermelha */
        }
        .red-button:hover {
            background-color: #c82333; /* Tom mais escuro de vermelho */
        }
    </style>
</head>
    <body>
        <div class="slide-container">
            <img id="slide" src="/qualidade/prova/slides/Slide1.JPG" alt="Slide 1">
        </div>
        <div class="progress-bar-container">
            <div id="progressBar" class="progress-bar"></div>
            <div id="progressText" class="progress-text">0%</div>
        </div>
        <div class="controls">
            <button id="prevBtn" onclick="changeSlide(-1)" disabled>Anterior</button>
            <form id="provaForm" method="post" style="display: inline;">
                <input type="hidden" name="realizarProva" value="1">
                <button id="nextBtn" type="button" onclick="changeSlide(1)">Próximo</button>
            </form>
        </div>

        <script>
            const slides = [];
            for (let i = 1; i <= 30; i++) {
                slides.push(`/qualidade/prova/slides/Slide${i}.JPG`);
            }

            let currentSlide = 0;

            const slideImage = document.getElementById('slide');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const provaForm = document.getElementById('provaForm');
            const progressBar = document.getElementById('progressBar');
            const progressText = document.getElementById('progressText');

            function changeSlide(direction) {
                currentSlide += direction;

                // Atualiza a imagem
                slideImage.src = slides[currentSlide];

                // Atualiza os botões
                prevBtn.disabled = currentSlide === 0;

                if (currentSlide === slides.length - 1) {
                    nextBtn.textContent = "Realizar Prova";
                    nextBtn.classList.add('red-button');
                    nextBtn.onclick = () => provaForm.submit(); // Submete o formulário no último slide
                } else {
                    nextBtn.textContent = "Próximo";
                    nextBtn.classList.remove('red-button');
                    nextBtn.onclick = () => changeSlide(1); // Garante que o botão continue funcionando
                }

                // Atualiza a barra de progresso
                updateProgressBar();
            }

            function updateProgressBar() {
                const progress = ((currentSlide + 1) / slides.length) * 100;
                progressBar.style.width = `${progress}%`;
                progressText.textContent = `${Math.round(progress)}%`;
            }

            // Inicializa a barra de progresso
            updateProgressBar();
            // Adiciona evento de zoom dinâmico
                slideImage.addEventListener('mousemove', (event) => {
                    const rect = slideImage.getBoundingClientRect();
                    const offsetX = ((event.clientX - rect.left) / rect.width) * 100;
                    const offsetY = ((event.clientY - rect.top) / rect.height) * 100;

                    slideImage.style.transformOrigin = `${offsetX}% ${offsetY}%`;
                });
        </script>
    </body>
</html>