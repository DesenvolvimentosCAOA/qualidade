
<header class="titulo text-center" style="position: relative;">
    <a name="SAIR" href="index.cfm" class="absolute top-4 right-4 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition duration-200">Sair</a>
</header>
 
<style>

.delete-icon-wrapper {
    display: inline-block; /* Para que o hover funcione corretamente */
    cursor: pointer; /* Mostra que é clicável */
    transition: transform 0.2s ease, color 0.2s ease; /* Transição suave para o hover */
}

.delete-icon {
    font-size: 24px; /* Tamanho do ícone */
    color: #737c99; /* Cor padrão do ícone */
}

/* Efeito de hover */
.delete-icon-wrapper:hover .delete-icon {
    transform: scale(1.1); /* Aumenta o ícone levemente */
    color: #d32f2f; /* Cor do ícone quando passa o mouse (vermelho) */
}


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