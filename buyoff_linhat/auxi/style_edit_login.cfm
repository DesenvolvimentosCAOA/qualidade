
<header class="titulo text-center" style="position: relative;">
    <img src="assets/banner_bg.jpg" alt="Título" class="titulo-img">
    <img src="assets/favicon.png" alt="Ícone" class="titulo-icon">
    <h1 class="titulo-texto display-4">Sistema de Gestão da Qualidade</h1>
    <a name="SAIR" href="index.cfm" class="absolute top-4 right-4 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition duration-200">Sair</a></header>
 

    



<style>

body {
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    position: relative;
}

.titulo {
    width: 100%;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center; /* Adicionado para centralizar o título horizontalmente */
}

.titulo-img {
    width: 100%;
    height: 50px;
    object-fit: cover;
}

.titulo-texto {
    margin-top: 10px;
    position: absolute;
    top: 0px;
    left: 50%;
    transform: translateX(-50%);
    color: white;
    font-size: 36px;
    text-align: center;
    z-index: 1;
    margin: 0;
    align-self: center;
}

.titulo-icon {
    position: absolute;
    left: 10px;
    z-index: 2;
    width: 50px;
    height: 50px;
}
</style>