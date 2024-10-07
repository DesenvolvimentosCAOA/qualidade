<img src="assets/banner_bg.jpg" alt="Título" class="titulo-img">
    <img src="assets/favicon.png" alt="Ícone" class="titulo-icon">
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand">PDI</a>
            <h1 class="titulo-texto">Sistema de Gestão da Qualidade</h1>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" name="logout" href="logout.cfm" style="color: red; font-size: 1.1rem;">Logout</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="fa_selecionar_buy_off.cfm" style="color: white; font-size: 1.1rem;">Buy Off's</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="fa_selecionar_reparo.cfm" style="color: white; font-size: 1.1rem;">Reparo</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="liberacao_fa.cfm" style="color: white; font-size: 1.1rem;">Liberação</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="fa_relatorios.cfm" style="color: white; font-size: 1.1rem;">Relatórios</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color: white; font-size: 1.1rem;">
                            Indicadores
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="indicadores_fa.cfm">Indicadores 1º turno</a>
                            <a class="dropdown-item" href="indicadores_fa2.cfm">Indicadores 2º turno</a>
                            <a class="dropdown-item" href="#">Indicadores 3º turno</a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

<style>/* código do header e imagens */

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
  flex-direction: column;
  align-items: center;
}

.titulo-img {
  width: 100%;
  height: 60px;
  object-fit: cover;
  position: relative;
}

.titulo-icon {
  position:absolute;
  left: 10px;
  z-index: 2;
  width: 50px;
  height: 50px;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.navbar .navbar-brand{
  color: yellow !important;
  font-size: 25px;
}



.navbar {
  width: 100%;
  position: absolute;
  top: 0;
  z-index: 1000;
  background-color: transparent;
}

.titulo-texto {
  margin-top: center;
  position: absolute;
  top: 50%;
  right: -10%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 24px;
  text-align: center;
  z-index: 1;
  
}

.titulo-icon {
  position: absolute;
  left: 10px;
  top: 10px;
  z-index: 2;
  width: 50px;
  height: 50px;
}

h2 {
  font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
  margin-top: 10px;
  position: relative;
  text-align: center;
}

.botao {
  max-width: 200px;
  min-width: fit-content;
  width: fit-content;
  position: absolute; 
  top: 5px; 
  left: 350px;
  padding: 10px 20px;
  border: none;
  color: black;
  cursor: pointer;
  background-color: transparent;
  white-space: nowrap;
}

.botao:hover {
  color: blue;
}

/* css de não conformidade */
.defeito_paint {
  width: 700px;
  margin: auto;
  display: flex;
  flex-direction: column;
  background: #ffffff; 
  box-shadow: 1px 0px 1.2px 0px #e3e3e3; 
  border-radius: 3px; 
  padding: 1em;
}

    .delete-icon-wrapper {
      display:inline-block; /* Para garantir que o span ocupe apenas o espaço necessário */
      width: 10px; /* Largura desejada */
      height: 24px; /* Altura desejada */
      cursor: pointer; /* Cursor do mouse ao passar sobre o ícone */
  }
  
  .table-custom-width {
    width: 300px; /* Defina a largura desejada aqui */
}

</style>