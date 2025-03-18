    <nav>
        <ul class="menu">
            <li><a href="inicio.cfm"><i class="fas fa-home"></i>Início</a></li>
            <li>
                <a href="#"><i class="fas fa-book"></i>Treinamentos<span class="desc">Cursos e Certificações</span></a>
                <ul class="submenu">
                    <cfif isDefined("cookie.user_level_prova") and ListFind("G,I", cookie.user_level_prova)>
                        <li><a href="alertas_abertura.cfm">Abertura de Alertas</a></li>
                        <li><a href="powerpoint.cfm">Indicadores e Check List</a></li>
                    </cfif>
                        <li><a href="alertas.cfm">Responder Alertas</a></li>
                        <li><a href="#">Em Breve</a></li>
                </ul>
            </li>
            <cfif isDefined("cookie.user_level_prova") and ListFind("G,I", cookie.user_level_prova)>
                <li>
                    <a href="#"><i class="fas fa-clipboard-check"></i>Provas<span class="desc"></span></a>
                    <ul class="submenu">
                        <li>
                            <a href="alertas.cfm" id="alertaQualidade">Check List/ Indicador</a>
                        </li>
                        
                        <!-- Container para a mensagem -->
                        <div id="mensagemProva" class="mensagem-container">
                            <div class="mensagem-box">
                                <p>Olá! Parece que você já realizou a prova. 😊</p>
                                <p>Se precisar revisar o conteúdo, acesse a seção de treinamentos.</p>
                            </div>
                        </div>
                        
                        <script>
                            document.getElementById("alertaQualidade").addEventListener("click", function(event) {
                                event.preventDefault(); // Impede o link de seguir o href
                                
                                var check = "<cfoutput>#check#</cfoutput>"; // Obtém o valor do CFML
                        
                                if (check === "true") {
                                    // Exibe a mensagem com fade-in
                                    var mensagem = document.getElementById("mensagemProva");
                                    mensagem.style.display = "flex"; // Exibe o container
                                    mensagem.style.opacity = 1; // Torna a mensagem visível
                        
                                    // Faz a mensagem desaparecer após 3 segundos
                                    setTimeout(function() {
                                        mensagem.style.opacity = 0; // Inicia o fade-out
                                        setTimeout(function() {
                                            mensagem.style.display = "none"; // Oculta a mensagem após o fade-out
                                        }, 500); // Tempo do fade-out (0.5s)
                                    }, 4000); // Tempo que a mensagem fica visível (3s)
                                } else {
                                    window.location.href = "prova.cfm"; // Redireciona para prova.cfm
                                }
                            });
                        </script>
    <!---                         <li><a href="#">Prova 2</a></li> --->
    <!---                         <li><a href="#">Prova 3</a></li> --->
                    </ul>
                </li>
            </cfif>
            <li>
                <a href="#"><i class="fas fa-file-alt"></i>Materiais</a>
                <ul class="submenu">
                    <li><a href="downloads/Lançamentos alertas.pptx" download>Alertas (baixar)</a></li>
                    <li><a href="downloads/Lançamentos  no Sistema de Gestão da Qualidade.pptx" download>Lançamento SGQ (baixar)</a></li>
                    <li><a href="downloads/chek_list.zip" download>Check List e Indicadores (baixar)</a></li>
                </ul>
            </li>
            <li>
                <a href="#"><i class="fas fa-file-alt"></i>Sobre</a>
                <ul class="submenu">
                    <li><a href="politicas.cfm">Missão, Visão, Valores</a></li>
                    <li><a href="sobre.cfm">Sobre</a></li>
                </ul>
            </li>
        </ul>
        <a href="logout.cfm">
            <button class="login-button">Logout</button>
        </a>
    </nav>

<style>
    body {
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f9;
        color: #333;
    }
    header {
        background-color: #004a99;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .logo img {
        height: 50px;
        width: auto;
    }
    .menu {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
    }
    .menu li {
        position: relative;
        margin: 0 15px;
    }
    .menu li a {
        color: white;
        text-decoration: none;
        padding: 10px 15px;
        display: flex;
        align-items: center;
        transition: background-color 0.3s, color 0.3s;
    }
    .menu li a:hover {
        background-color: #ff6600;
        border-radius: 5px;
    }
    .menu li a i {
        margin-right: 8px;
    }
    .menu li a .desc {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background-color: #004a99;
        padding: 8px 12px;
        border-radius: 5px;
        white-space: nowrap;
    }
    .menu li a:hover .desc {
        display: block;
    }
    .submenu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background-color: #004a99;
        list-style: none;
        padding: 0;
        margin: 0;
        min-width: 200px;
        z-index: 1000;
        border-radius: 5px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    .submenu li a {
        padding: 10px 15px;
        display: block;
        color: white;
        text-decoration: none;
        transition: background-color 0.3s;
    }
    .submenu li a:hover {
        background-color: #ff6600;
        border-radius: 5px;
    }
    .menu li:hover .submenu {
        display: block;
    }
    .login-button {
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .login-button:hover {
        background-color: #e65c00;
    }
    .banner {
        background: url('/qualidade/prova/assets/qualidade.jpg') center/cover no-repeat;
        color: white;
        text-align: center;
        padding: 100px 20px;
    }
    .banner h1 {
        font-size: 3em;
        margin: 0;
    }
    .banner p {
        font-size: 1.2em;
        margin: 10px 0 0;
    }
    .section {
        padding: 50px 20px;
        text-align: center;
    }
    .section h2 {
        font-size: 2em;
        margin-bottom: 20px;
    }
    .card-container {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
    }
    .card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        width: 300px;
        margin: 20px;
        padding: 20px;
        text-align: left;
        transition: transform 0.3s;
    }
    .card:hover {
        transform: translateY(-10px);
    }
    .card h3 {
        font-size: 1.5em;
        margin: 0 0 10px;
    }
    .card p {
        font-size: 1em;
        color: #666;
    }
    .card a {
        display: inline-block;
        margin-top: 15px;
        color: #004a99;
        text-decoration: none;
        font-weight: bold;
    }
    .card a:hover {
        text-decoration: underline;
    }
    .card-alerta {
        background-color:rgb(28, 205, 218); /* Verde claro */
        border-color: #c3e6cb; /* Verde mais escuro */
    }

    .card[title]:hover::after {
        content: attr(title);
        position: absolute;
        bottom: 100%;
        left: 50%;
        transform: translateX(-50%);
        padding: 5px;
        background-color: #333;
        color: #fff;
        border-radius: 4px;
        white-space: nowrap;
        font-size: 12px;
        margin-bottom: 5px;
    }
    footer {
        background-color: #004a99;
        color: white;
        text-align: center;
        padding: 20px;
        margin-top: 50px;
    }
    footer a {
        color: white;
        text-decoration: none;
        margin: 0 10px;
    }
    footer a:hover {
        text-decoration: underline;
    }
    /* Estilos do Modal */
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        width: 80%;
        max-width: 500px;
        text-align: center;
        position: relative;
    }
    .modal-content h2 {
        margin-top: 0;
    }
    .modal-content p {
        font-size: 1em;
        color: #333;
    }
    .close-button {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
    }
    .close-button:hover {
        background-color: #e65c00;
    }
    .mensagem-container {
        display: none; /* Oculta inicialmente */
        justify-content: center; /* Centraliza horizontalmente */
        align-items: center; /* Centraliza verticalmente */
        position: fixed; /* Fixa na tela */
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5); /* Fundo escuro semi-transparente */
        z-index: 1000; /* Garante que fique acima de outros elementos */
        opacity: 0; /* Inicia invisível para o fade-in */
        transition: opacity 0.5s ease; /* Transição suave para o fade-in/fade-out */
    }

    .mensagem-box {
        background-color:rgb(255, 255, 255); /* Fundo vermelho claro */
        color: #721c24; /* Texto vermelho escuro */
        padding: 20px;
        border-radius: 10px;
        border: 1px solid #f5c6cb;
        max-width: 300px;
        text-align: center;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Sombra suave */
    }

    .mensagem-box p {
        margin: 0;
        font-size: 14px;
    }
</style>