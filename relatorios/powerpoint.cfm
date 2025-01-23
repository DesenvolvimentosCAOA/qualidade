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
            background-color: #dc3545; /* Cor vermelha */
        }
        .red-button:hover {
            background-color: #c82333; /* Tom mais escuro de vermelho */
        }
    </style>
</head>
<body style="padding-top: 60px;">
    <header class="titulo">
        <cfinclude template="auxi/nav_links.cfm">
    </header>

    <div class="slide-container">
        <img id="slide" src="/qualidade/prova/ver/Slide1.JPG" alt="Slide 1">
    </div>
    <div class="progress-bar-container">
        <div id="progressBar" class="progress-bar"></div>
        <div id="progressText" class="progress-text">0%</div>
    </div>
    <div class="controls" style="margin-bottom:4vw;">
        <button id="prevBtn" onclick="changeSlide(-1)" disabled>Anterior</button>
        <button id="nextBtn" onclick="changeSlide(1)">Próximo</button>
    </div>
    <script>
        const slides = [];
        for (let i = 1; i <= 12; i++) {
            slides.push(`/qualidade/prova/ver/Slide${i}.JPG`);
        }

        let currentSlide = 0;

        const slideImage = document.getElementById('slide');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');

        function changeSlide(direction) {
            currentSlide += direction;

            slideImage.src = slides[currentSlide];

            prevBtn.disabled = currentSlide === 0;

            if (currentSlide === slides.length - 1) {
                nextBtn.textContent = "FINALIZAR TREINAMENTO";
                nextBtn.classList.add('red-button');
                nextBtn.onclick = () => {
                    window.location.href = "/qualidade/relatorios/insere_treinamento.cfm?data_registro=1";
                };
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

        updateProgressBar();
    </script>
</body>
</html>
