<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <cfoutput>
        <cfif isDefined("form.prova_login")>
            <cfif not isDefined("form.ver_login") or not isDefined("form.ver_senha")>
                <cfset errorMessage = "Por favor, preencha todos os campos.">
            <cfelse>
                <cfquery name="validausuario" datasource="#BANCOSINC#">
                    SELECT USER_ID, USER_NAME, USER_PASSWORD, trim(USER_LEVEL) as USER_LEVEL, USER_SIGN 
                    FROM reparo_fa_users 
                    WHERE upper(USER_NAME) = UPPER(<cfqueryparam value="#form.ver_login#" cfsqltype="cf_sql_varchar">)
                    AND USER_PASSWORD = UPPER(<cfqueryparam value="#form.ver_senha#" cfsqltype="cf_sql_varchar">)
                    AND (USER_LEVEL = 'G' OR USER_LEVEL = 'I' OR USER_LEVEL = 'P')
                </cfquery>
                
                <cfif validausuario.recordcount GT 0>
                    <cfcookie name="user_apontamento_prova" value="#form.ver_login#">
                    <cfcookie name="user_level_prova" value="#validausuario.USER_LEVEL#">
                    <cfif validausuario.user_level eq "G" OR validausuario.user_level eq "I" OR validausuario.user_level eq "P">
                        <cflocation url="/qualidade/prova/inicio.cfm" addtoken="no">
                    </cfif>
                <cfelse>
                    <cfset errorMessage = "Usuario ou senha incorretos.">
                </cfif>
            </cfif>
        </cfif>
    </cfoutput>


<html lang="pt-br">
    <head>
        <meta charset="UTF-8"> 
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Portal de Treinamentos da Qualidade</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Montserrat', sans-serif;
            }

            body, html {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
                background: url('/qualidade/prova/assets/fundo.jpg') center center/cover no-repeat;
                color: #333;
            }

            .login-container {
                background-color: rgba(255, 255, 255, 0.95);
                width: 100%;
                max-width: 450px;
                padding: 2.5rem;
                border-radius: 20px;
                box-shadow: 0px 12px 24px rgba(0, 0, 0, 0.2);
                text-align: center;
                animation: slideIn 0.5s ease-in-out;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-header {
                margin-bottom: 2rem;
            }

            .login-header img {
                width: 80px;
                margin-bottom: 1rem;
            }

            .login-title {
                font-size: 2.2em;
                color: #2c3e50;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .login-subtitle {
                font-size: 1em;
                color: #7f8c8d;
                font-weight: 400;
            }

            .input-group {
                position: relative;
                margin-bottom: 1.5rem;
            }

            .input-group input {
                width: 100%;
                padding: 15px 15px 15px 50px;
                border-radius: 10px;
                background-color: #f9f9f9;
                color: #2c3e50;
                border: 2px solid #ddd;
                outline: none;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .input-group input:focus {
                border-color: #6c63ff;
                box-shadow: 0px 0px 12px rgba(108, 99, 255, 0.3);
            }

            .input-group i {
                position: absolute;
                top: 50%;
                left: 20px;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 1.2em;
            }

            .input-group input:focus + i {
                color: #6c63ff;
            }

            .login-button {
                width: 100%;
                padding: 15px;
                font-size: 1.1em;
                font-weight: 600;
                color: white;
                background: linear-gradient(135deg, #6c63ff, #4a45d6);
                border: none;
                border-radius: 10px;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .login-button:hover {
                transform: translateY(-3px);
                box-shadow: 0px 6px 12px rgba(108, 99, 255, 0.3);
            }

            .mensagem-erro {
                background-color: #ffebee;
                color: #c62828;
                padding: 15px;
                border-radius: 10px;
                text-align: center;
                font-size: 1em;
                margin-top: 1.5rem;
                border: 1px solid #c62828;
                animation: fadeIn 0.5s ease-in-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .login-footer {
                margin-top: 2rem;
                font-size: 0.9em;
                color: #7f8c8d;
            }

            .login-footer a {
                color: #6c63ff;
                text-decoration: none;
                font-weight: 500;
                cursor: pointer;
            }

            .login-footer a:hover {
                text-decoration: underline;
            }

            /* Estilo do Modal */
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
                padding: 2rem;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
                animation: slideIn 0.3s ease-in-out;
            }

            .modal-content h2 {
                margin-bottom: 1rem;
                font-size: 1.5em;
                color: #2c3e50;
            }

            .modal-content ul {
                list-style-type: none;
                padding: 0;
            }

            .modal-content ul li {
                margin: 0.5rem 0;
                font-size: 1.1em;
                color: #333;
            }

            .modal-content button {
                margin-top: 1rem;
                padding: 10px 20px;
                font-size: 1em;
                color: white;
                background: #6c63ff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .modal-content button:hover {
                background: #4a45d6;
            }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <form method="post" onsubmit="return validarVerLogin()">
            <input type="hidden" name="prova_login" value="1">
            <div class="login-container">
                <div class="login-header">
                    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Logo">
                    <h1 class="login-title">Portal da Qualidade</h1>
                    <p class="login-subtitle">Acesse sua conta para continuar</p>
                </div>
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" id="ver_login" name="ver_login" required autocomplete="off" placeholder="Usuario">
                </div>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="ver_senha" name="ver_senha" required autocomplete="off" placeholder="Senha">
                </div>
                <button class="login-button" type="submit">Entrar</button>
                <cfif isDefined("errorMessage")>
                    <div class="mensagem-erro"><cfoutput>#errorMessage#</cfoutput></div>
                </cfif>
                <div class="login-footer">
                    <p>Nao tem uma conta? <a id="contateAnalista" href="#">Contate um Analista da Qualidade</a></p>
                </div>
            </div>
        </form>

        <!-- Modal para exibir os nomes dos analistas -->
        <div id="analistaModal" class="modal">
            <div class="modal-content">
                <h2>Analistas da Qualidade</h2>
                <ul>
                    <li>Joao Cleber (FA)</li>
                    <li>Lincon Trentin (FAI)</li>
                    <li>Rafaga De Oliveira (PAINT)</li>
                    <li>Lucas Correa (BODY)</li>
                    <li>Daniel Teixeira (FIELD)</li>
                    <a href="https://web.whatsapp.com/send?phone=5562993636153&text=Ola,%20gostaria%20de%20falar%20sobre%20a%20criacao%20de%20USUARIO." target="_blank" rel="noopener noreferrer">
                        Jefferson Teixeira (SISTEMAS)
                    </a>
                </ul>
                <button id="fecharModal">Fechar</button>
            </div>
        </div>

        <script>
            // Função para validar o login
            function validarVerLogin() {
                var login = document.getElementById('ver_login').value;
                var senha = document.getElementById('ver_senha').value;

                if (!/^\d+$/.test(senha)) {
                    alert("A senha deve conter apenas números.");
                    return false;
                }

                if (login === "" || senha === "") {
                    alert("Por favor, preencha todos os campos.");
                    return false;
                }

                return true;
            }

            // Função para exibir o modal com os nomes dos analistas
            document.getElementById('contateAnalista').addEventListener('click', function(event) {
                event.preventDefault(); // Impede o comportamento padrão do link
                document.getElementById('analistaModal').style.display = 'flex';
            });

            // Função para fechar o modal
            document.getElementById('fecharModal').addEventListener('click', function() {
                document.getElementById('analistaModal').style.display = 'none';
            });

            // Fechar o modal ao clicar fora dele
            window.addEventListener('click', function(event) {
                var modal = document.getElementById('analistaModal');
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        </script>
    </body>
</html>