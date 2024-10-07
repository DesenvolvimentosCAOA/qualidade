    
    <img src="assets/banner_bg.jpg" alt="Título" class="titulo-img">
    <img src="assets/favicon.png" alt="Ícone" class="titulo-icon">
    <div class="overlay">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container">
                <a class="navbar-brand">Paint Shop</a>
                <h1 class="titulo-texto">Sistema de Gestão da Qualidade</h1>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item dropdown">
                          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                              data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color: white; font-size: 1.1rem;">
                              Barreiras</a>
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                              <a class="dropdown-item"
                                  href="/cf/auth/qualidade/buyoff_linhat/selecao_paint.cfm">Buy Off's</a>
                              <a class="dropdown-item"
                                  href="/cf/auth/qualidade/buyoff_linhat/repintura.cfm">Troca de Peças e Repinturas</a>
                          </div>
                        <li class="nav-item dropdown">
                          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                              data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color: white; font-size: 1.1rem;">
                              Reparos</a>
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                              <a class="dropdown-item"
                                  href="Reparo.cfm">Reparos Buy Off</a>
                              <a class="dropdown-item"
                                  href="reparo_repintura.cfm">Reparo Repintura e Troca de Peça</a>
                          </div>
                        <li class="nav-item dropdown">
                          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                              data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color: white; font-size: 1.1rem;">
                              Liberação</a>
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                              <a class="dropdown-item"
                                  href="liberacao.cfm">Liberação Buy Off</a>
                              <a class="dropdown-item"
                                  href="liberacao_repintura.cfm">Liberação Repintura e Troca de Peça</a>
                          </div>
                        <li class="nav-item">
                            <a class="nav-link"
                                href="/cf/auth/qualidade/buyoff_linhat/relatorios_paint.cfm" style="color: white; font-size: 1.1rem;">Relatórios</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color: white; font-size: 1.1rem;">
                                Indicadores
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item"
                                    href="/cf/auth/qualidade/buyoff_linhat/indicadores_paint.cfm">Indicadores 1º turno</a>
                                <a class="dropdown-item"
                                    href="/cf/auth/qualidade/buyoff_linhat/indicadores_paint2.cfm">Indicadores 2º turno</a>
                                <a class="dropdown-item"
                                    href="/cf/auth/qualidade/buyoff_linhat/indicadores_paint3.cfm">Indicadores 3º turno</a>
                                <a class="dropdown-item"
                                    href="/cf/auth/qualidade/buyoff_linhat/indicadores_paint_geral.cfm">Indicador Geral</a>
                            </div>
                            <li class="nav-item">
                              <a class="nav-link" href="logout.cfm" style="color: red; font-size: 1.1rem;">Logout</a>
                          </li>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
<style>       /* código do header e imagens */

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
  height: 60px; /* Ajuste a altura conforme necessário */
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
  color: rgb(236, 86, 32) !important;
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
  top: 50%; /* Ajuste a posição conforme necessário */
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
