<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
</cfquery>

<cfif structKeyExists(form, "finalizar_treinamento")>
    <!--- Verificar se o USER_SIGN já existe na tabela de treinamentos --->
    <cfquery name="verificarTreinamento" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS total
        FROM INTCOLDFUSION.treinamentos
        WHERE NOME = '#UCase(LOGIN.USER_SIGN)#'
        AND TREINAMENTO = '#UCase('ALERTAS')#'
    </cfquery>
    

    <!--- Se o nome já existir, exibe uma mensagem e redireciona --->
    <cfif verificarTreinamento.total GT 0>
        <script>
            alert("O usuário já completou este treinamento!");
            window.location.href = "indicador.cfm"; <!--- Redireciona para outra tela --->
        </script>
    <cfelse>
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
                <cfqueryparam value="#UCase(LOGIN.USER_SIGN)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#UCase('ALERTAS')#" cfsqltype="CF_SQL_VARCHAR">
            )
        </cfquery>

        <script>
            alert("Treinamento finalizado com sucesso!");
            window.location.href = "indicador.cfm";
        </script>
    </cfif>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or 
    (cookie.user_level_final_assembly eq "R" or 
     cookie.user_level_final_assembly eq "P" or 
     cookie.user_level_final_assembly eq "E")>
    <script>
        alert("É necessário autorização!!");
        history.back();
    </script>
</cfif>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
            background-color: #dc3545;
        }
        .red-button:hover {
            background-color: #c82333;
        }
        /* Tela de Loading */
        #loading-screen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            visibility: hidden;
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }

        #loading-screen.show {
            visibility: visible;
            opacity: 1;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid rgba(255, 255, 255, 0.3);
            border-top-color: #f6722c;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body style="padding-top: 60px;">
    <header class="titulo">
        <cfinclude template="auxi/nav_links.cfm">
    </header>

    <div id="loading-screen">
        <div class="spinner"></div>
    </div>

    <div class="slide-container">
        <img id="slide" src="/qualidade/prova/alertas/Slide1.png" alt="Slide 1">
    </div>
    <div class="progress-bar-container">
        <div id="progressBar" class="progress-bar"></div>
        <div id="progressText" class="progress-text">0%</div>
    </div>
    <div class="controls" style="margin-bottom:4vw;">
        <button id="prevBtn" onclick="changeSlide(-1)" disabled>Anterior</button>
        <button id="nextBtn" onclick="changeSlide(1)">Próximo</button>
    </div>

    <!-- Formulário para enviar os dados -->
    <form id="finalizarForm" method="post" style="display: none;">
        <input type="hidden" name="finalizar_treinamento" value="1">
    </form>

    <script>
        const slides = [];
        for (let i = 1; i <= 12; i++) {
            slides.push(`/qualidade/prova/alertas/Slide${i}.png`);
        }

        let currentSlide = 0;

        const slideImage = document.getElementById('slide');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');
        const finalizarForm = document.getElementById('finalizarForm');

        function changeSlide(direction) {
            currentSlide += direction;

            slideImage.src = slides[currentSlide];

            prevBtn.disabled = currentSlide === 0;

            if (currentSlide === slides.length - 1) {
                nextBtn.textContent = "FINALIZAR TREINAMENTO";
                nextBtn.classList.add('red-button');
                nextBtn.onclick = () => finalizarTreinamento();
            } else {
                nextBtn.textContent = "Próximo";
                nextBtn.classList.remove('red-button');
                nextBtn.onclick = () => changeSlide(1);
            }

            updateProgressBar();
        }

        function updateProgressBar() {
            const progress = ((currentSlide + 1) / slides.length) * 100;
            progressBar.style.width = `${progress}%`;
            progressText.textContent = `${Math.round(progress)}%`;
        }

        function finalizarTreinamento() {
            finalizarForm.submit();
        }

        updateProgressBar();
    </script>

    <script src="/qualidade/relatorios/assets/script.js"></script>

</body>
</html>
