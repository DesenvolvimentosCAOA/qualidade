<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
    <link rel="stylesheet" href="/qualidade/treinamento/assets/style_index.css?v1">
    <title>Carrossel com Menu</title>
</head>
<body>
    <div class="top-menu">
        <div class="menu-left">
            <span class="logo" onclick="toggleSideMenu()">☰</span>
        </div>
        <div class="menu-right">
            <a href="#"><i class="fas fa-home"></i>Início</a>
            <a href="#"><i class="fas fa-graduation-cap"></i>Cursos</a>
            <a href="#"><i class="fas fa-photo-video"></i>Midiatec</a>
            <a href="#"><i class="fas fa-bell"></i>Avisos</a>
            <a href="#"><i class="fas fa-user"></i>Usuário</a>
            <a href="#"><i class="fas fa-question-circle"></i>Fale Conosco</a>
        </div>
    </div>

    <div class="side-menu" id="sideMenu">
        <span class="close-btn" onclick="toggleSideMenu()">&times;</span>
        <a href="#"><i class="fas fa-home"></i>Início</a>
        <a href="#"><i class="fas fa-graduation-cap"></i>Cursos</a>
        <a href="#"><i class="fas fa-photo-video"></i>Midiatec</a>
        <a href="#"><i class="fas fa-bell"></i>Avisos</a>
        <a href="#"><i class="fas fa-user"></i>Usuário</a>
        <a href="#"><i class="fas fa-question-circle"></i>Fale Conosco</a>
    </div>

    <div class="carousel">
        <div class="carousel-images" id="carouselImages">
            <img src="/qualidade/treinamento/assets/img/caoa.jpg" alt="Slide 1">
            <img src="/qualidade/treinamento/assets/img/treinamento.jpeg" alt="Slide 2">
            <img src="/qualidade/treinamento/assets/img/treinamento.jpeg" alt="Slide 3">
            <img src="/qualidade/treinamento/assets/img/treinamento.jpeg" alt="Slide 4">
        </div>
        <div class="carousel-indicators" id="carouselIndicators">
            <span class="active" onclick="goToSlide(0)"></span>
            <span onclick="goToSlide(1)"></span>
            <span onclick="goToSlide(2)"></span>
            <span onclick="goToSlide(3)"></span>
        </div>
    </div>

    <div class="content">
        <p>Bem-vindo ao sistema!</p>
    </div>

    <script>
        const sideMenu = document.getElementById('sideMenu');
const carouselImages = document.getElementById('carouselImages');
const indicators = document.querySelectorAll('.carousel-indicators span');
let currentSlide = 0;

function toggleSideMenu() {
    sideMenu.classList.toggle('open');
}

function goToSlide(index) {
    currentSlide = index;
    updateCarousel();
}

function updateCarousel() {
    const offset = -currentSlide * 100;
    carouselImages.style.transform = `translateX(${offset}%)`; // Muda a imagem visível
    indicators.forEach((indicator, idx) => {
        indicator.classList.toggle('active', idx === currentSlide);
    });
}

// Atualiza o carrossel a cada 3 segundos
setInterval(() => {
    currentSlide = (currentSlide + 1) % indicators.length;
    updateCarousel();
}, 3000);

    </script>
</body>
</html>
