<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página de Login</title>
    <link rel="stylesheet" href="styles.css"> <!-- Arquivo de estilos CSS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- Importando SweetAlert para mensagens -->
</head>
<body>
    <div class="login-container">
        <h2>Faça seu login</h2>
        <form id="loginForm">
            <label for="username">Usuário:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Senha:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit">Login</button>
        </form>
    </div>

    <div class="destino-container" style="display: none;">
        <h2>Bem-vindo à página de destino!</h2>
        <!-- Conteúdo da página de destino -->
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(event) {
            event.preventDefault(); // Evita o envio padrão do formulário

            // Aqui você pode adicionar lógica de validação do login
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;

            // Exemplo de lógica de login simples (substitua com sua lógica real)
            if (username === 'admin' && password === 'password') {
                // Login bem-sucedido
                showLoggedInPage();
            } else {
                // Login inválido
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Usuário ou senha incorretos!'
                });
            }
        });

        function showLoggedInPage() {
            // Adiciona classe para aplicar transição
            document.body.classList.add('logged-in');

            // Espera a animação de fadeOut completar antes de redirecionar
            setTimeout(function() {
                window.location.href = 'pagina2.cfm'; // Redireciona para a página de destino
            }, 500); // Tempo deve corresponder à duração da animação CSS
        }
    </script>
</body>
</html>
