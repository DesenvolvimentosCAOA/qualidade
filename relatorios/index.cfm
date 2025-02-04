<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Valida o usuário para Ver & Agir --->
<cfif isDefined("form.ver_login")>
    <cfquery name="validausuario" datasource="#BANCOSINC#">
        SELECT USER_ID, USER_NAME, USER_PASSWORD, TRIM(USER_LEVEL) AS USER_LEVEL, USER_SIGN 
        FROM reparo_fa_users 
        WHERE UPPER(USER_NAME) = UPPER('#form.ver_login#')
        AND USER_PASSWORD = UPPER('#form.ver_senha#')
    </cfquery>
    
    <!--- Se usuário válido, cria cookies e redireciona --->
    <cfif validausuario.recordcount GT 0>
        <cfcookie name="user_apontamento_fa" value="#form.ver_login#">
        <cfcookie name="user_level_final_assembly" value="#validausuario.USER_LEVEL#">
        
        <cfif validausuario.USER_LEVEL EQ "R">
            <meta http-equiv="refresh" content="0; URL=/qualidade/relatorios/indicador.cfm"/>
        <cfelseif validausuario.USER_LEVEL EQ "P">
            <meta http-equiv="refresh" content="0; URL=/qualidade/relatorios/indicador.cfm"/>
        <cfelse>
            <meta http-equiv="refresh" content="0; URL=/qualidade/relatorios/alertas/d_principal.cfm"/>
        </cfif>
    <cfelse>
        <!--- Mensagem de erro --->
        <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
    </cfif>
</cfif>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - VER & AGIR</title>
    <style>
        /* Reset e estilo geral */
        * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
        }

        body, html {
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        color: #eee;
        }

        /* Imagem de fundo cobrindo a tela inteira */
        body::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('/qualidade/buyoff_linhat/assets/novo.jpg') center center/cover no-repeat;
        filter: brightness(0.3);
        z-index: -1;
        }

        /* Estilo do container de login */
        .login-container {
        background-color: rgba(37, 37, 57, 0.9); /* fundo semi-transparente */
        width: 100%;
        max-width: 400px;
        padding: 2rem;
        border-radius: 10px;
        box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.3);
        text-align: center;
        }

        /* Animação do título */
        .login-title {
        font-size: 2em;
        color: #f1f1f1;
        margin-bottom: 20px;
        overflow: hidden;
        white-space: nowrap;
        border-right: 4px solid #6c63ff;
        width: 0;
        animation: typing 3s steps(20, end) forwards, blink 0.6s step-end infinite alternate;
        }

        /* Animações */
        @keyframes typing {
        from { width: 0; }
        to { width: 100%; }
        }

        @keyframes blink {
        from { border-color: transparent; }
        to { border-color: #6c63ff; }
        }

        .input-group {
        position: relative;
        margin-bottom: 20px;
        }

        /* Estilo dos inputs */
        .input-group input {
        width: 100%;
        padding: 15px;
        border-radius: 5px;
        background-color: #3b3b4f;
        color: #eee;
        border: 2px solid #444;
        outline: none;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .input-group input:focus {
        border-color: #6c63ff;
        box-shadow: 0px 0px 8px rgba(108, 99, 255, 0.5);
        }

        .input-group label {
        position: absolute;
        top: 50%;
        left: 15px;
        transform: translateY(-50%);
        color: #888;
        pointer-events: none;
        transition: top 0.3s ease, font-size 0.3s ease, color 0.3s ease;
        }

        .input-group input:focus + label,
        .input-group input:not(:placeholder-shown) + label {
        top: -10px;
        font-size: 0.8em;
        color: #6c63ff;
        }

        /* Botão de login */
        .login-button {
        width: 100%;
        padding: 15px;
        font-size: 1em;
        font-weight: bold;
        color: white;
        background: #6c63ff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background 0.3s ease;
        }

        .login-button:hover {
        background: #4a45d6;
        }

        .error-message {
        color: #ff6b6b;
        font-size: 0.9em;
        margin-top: 10px;
        display: none;
        }
    </style>

    </head>
    <body>
        <form method="post" onsubmit="return validarVerLogin()">
            <div class="login-container">
                <h2 class="login-title">Relatórios</h2>
                <div class="input-group">
                    <input type="text" id="ver_login" name="ver_login" required autocomplete="off" placeholder=" ">
                    <label for="ver_login">Usuário</label>
                </div>
                <div class="input-group">
                    <input type="password" id="ver_senha" name="ver_senha" required autocomplete="off" placeholder=" ">
                    <label for="ver_senha">Senha</label>
                </div>
                <button class="login-button" type="submit">Entrar</button>
                <div class="error-message" id="error-message">Usuário ou senha incorretos</div>
            </div>
        </form>
        <script>
            function validarVerLogin() {
                var login = document.getElementById('ver_login').value;
                var senha = document.getElementById('ver_senha').value;

                // Validar se a senha contém apenas números
                if (!(/^\d+$/.test(senha))) {
                    document.getElementById('ver_erro_numerico').style.display = 'block';
                    return false; // Impede o envio do formulário
                }

                // Exemplo simples de validação
                if (login === "" || senha === "") {
                    document.getElementById('ver_erro').style.display = 'block';
                    return false; // Impede o envio do formulário
                }

                return true; // Permite o envio do formulário
            }
        </script>
    </body>
</html>
