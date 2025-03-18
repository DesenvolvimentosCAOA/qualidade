<!--- Verifica se o cookie de autenticação existe --->
<cfif structKeyExists(cookie, "user_apontamento_prova")>
    <!--- Remove o cookie de autenticação --->
    <cfcookie name="user_apontamento_prova" expires="now">
    
    <!--- Exibe uma mensagem de confirmação --->
    <div class="mensagem-logout">
        <div class="icone">
            <i class="fas fa-door-open"></i> <!-- Ícone de porta aberta -->
        </div>
        <h2>Você saiu da sua conta</h2>
        <p>Você foi desconectado com segurança. Redirecionando para a página inicial...</p>
        <div class="progress-bar">
            <div class="progress"></div> <!-- Barra de progresso animada -->
        </div>
    </div>

    <!--- Redireciona após 3 segundos usando JavaScript --->
    <script>
        setTimeout(function() {
            window.location.href = "/qualidade/prova/index.cfm";
        }, 3000); // 3000 milissegundos = 3 segundos
    </script>
<cfelse>
    <!--- Se o cookie não existir, redireciona imediatamente --->
    <cflocation url="/qualidade/prova/index.cfm" addtoken="false">
</cfif>

<!--- Estilos CSS para a mensagem de logout --->
<style>
    .mensagem-logout {
        background-color: #ffffff; /* Fundo branco */
        color: #333333; /* Texto escuro */
        padding: 40px;
        border-radius: 15px; /* Bordas arredondadas */
        text-align: center;
        font-family: 'Poppins', sans-serif;
        max-width: 500px;
        margin: 100px auto;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Sombra mais forte */
        border: 1px solid #e0e0e0; /* Borda sutil */
        animation: fadeIn 0.5s ease-in-out; /* Animação de entrada */
    }

    .mensagem-logout .icone {
        font-size: 80px;
        color: #ff6600; /* Laranja */
        margin-bottom: 20px;
        animation: bounce 1s ease-in-out; /* Animação do ícone */
    }

    .mensagem-logout h2 {
        font-size: 28px;
        margin: 0 0 10px 0;
        color: #ff6600; /* Laranja */
    }

    .mensagem-logout p {
        font-size: 18px;
        color: #666666; /* Cinza escuro */
        margin: 0 0 20px 0;
    }

    .progress-bar {
        background-color: #f0f0f0; /* Fundo da barra de progresso */
        border-radius: 10px;
        overflow: hidden;
        height: 10px;
        margin: 20px auto;
        width: 80%;
    }

    .progress-bar .progress {
        background-color: #ff6600; /* Cor da barra de progresso */
        height: 100%;
        width: 0;
        animation: progress 3s linear forwards; /* Animação da barra de progresso */
    }

    /* Animação de entrada */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Animação do ícone */
    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-20px); }
        60% { transform: translateY(-10px); }
    }

    /* Animação da barra de progresso */
    @keyframes progress {
        from { width: 0; }
        to { width: 100%; }
    }
</style>

<!--- Inclui FontAwesome para ícones --->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">