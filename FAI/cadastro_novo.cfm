<cfinvoke  method="inicializando" component="cf.ini.index">

<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
</cfquery>

<cfif not isDefined("cookie.user_level_fai") or (cookie.user_level_fai eq "R" or cookie.user_level_fai eq "P")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>

<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Usuário</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap');
        *{
            padding: 0;
            margin: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body{
            background-image: url(/qualidade/buyoff_linhat/imgs/teste1.jpg);
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            min-height: 100vh;
            overflow: hidden;
        }
        .w50{
            width: 50%;
            float: left;
            padding-right: 15px;
        }
        .box{
            display: flex;
            width: 930px;
        }
        .img-box{
            background-color: rgba(255, 255, 255, 0.5);
            width: 50%;
            display: flex;
            align-items: center;
            padding: 20px;
            border-radius: 20px  0 0 20px;
        }
        .img-box img{
            width: 100%;
        }
        .form-box{
            background-color: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(40px);
            padding: 30px 40px;
            width: 50%;
            border-radius: 0 20px 20px 0;
        }
        .form-box h2{
            font-size: 30px;
        }
        .form-box p{
            font-weight: bold;
            color: #3D3D3D;
        }
        .form-box p a{
            color: orange;
            text-decoration: none;
        }
        .form-box form{
            margin: 20px 0;
        }
        form .input-group{
            margin-bottom: 15px;
        }
        form .input-group label{
            color: #3D3D3D;
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        form .input-group input{
            width: 100%;
            height: 55px;
            background-color: rgba(255, 255, 255, 0.32);
            border-radius: 20px;
            outline: none;
            border: 2px solid transparent;
            padding: 15px;
            font-size: 15px;
            color: #616161;
            transition: all 0.4s ease;
        }
        form .input-group input:focus{
            border-color: orange;
        }
        form .input-group select{
            width: 100%;
            height: 55px;
            background-color: rgba(255, 255, 255, 0.32);
            border-radius: 20px;
            outline: none;
            border: 2px solid transparent;
            padding: 15px;
            font-size: 15px;
            color: #616161;
            transition: all 0.4s ease;
        }
        form .input-group select:focus{
            border-color: orange;
        }
        form .input-group button{
            width: 100%;
            height: 47px;
            background: orange;
            border-radius: 20px;
            outline: none;
            border: none;
            margin-top: 15px;
            color: white;
            cursor: pointer;
            font-size: 16px;
        }
        @media (max-width:930px) {
            .img-box{
                display: none;
            }
            .box{
                width: 700px;
            }
            .form-box{
                width: 100%;
                border-radius: 20px;
            }
        }
        @media (max-width:500px) {
            .w50{
                width: 100%;
                padding: 0;
            }
        }
        .alerta {
            font-size: 24px; /* Aumenta o tamanho da letra */
            text-align: center; /* Centraliza o texto */
        }

        .alerta strong {
            animation: piscar 1s infinite; /* Faz o "ATENÇÃO" piscar */
        }

        @keyframes piscar {
            0% { color: red; }
            50% { color: white; }
            100% { color: red; }
        }
    </style>
</head>

<body>
    <div class="box">
        <div class="img-box">
            <p class="alerta"><span style="color:red;"><strong>ATENÇÃO!!!!</strong></span> Cadastro deve ser realizado exclusivamente pelos Analistas responsáveis de cada setor!</p>
        </div>
        <div class="form-box">
            <h2>Criar Usuário</h2>
            <form id="cadastroForm" method="post" action="cadastro.cfm">
                <div class="input-group">
                    <label for="nome"> Nome Completo</label>
                    <input type="text" id="nome" name="cadastro_nome" required oninput="atualizarCredenciais()">
                </div>

                <div class="input-group w50">
                    <label for="email">Matricula</label>
                    <input type="text" id="matricula" name="cadastro_matricula" required oninput="atualizarCredenciais()">
                </div>
                <div class="input-group w50">
                    <label for="email">setor</label>
                    <select id="setor" name="cadastro_setor" required>
                        <option value="">Selecione</option>
                        <option value="BODY">BODY</option>
                        <option value="PAINT">PAINT</option>
                        <option value="SMALL">SMALL</option>
                        <option value="FA">FA</option>
                        <option value="FAI">FAI</option>
                        <option value="PDI">PDI</option>
                    </select>
                </div>

                <div class="input-group">
                    <label for="telefone">Nível de Acesso</label>
                    <select id="nivel" name="cadastro_nivel_acesso" required>
                        <option value="">Selecione</option>
                        <option value="I">I - Usuário de Inspetor</option>
                        <option value="R">R - Usuário de Reparador</option>
                        <option value="G">G - Usuário Gerenciador (Apenas Qualidade)</option>
                        <option value="P">P - Usuário de Consulta de Indicadores</option>
                        <option value="E">E - Usuário Apenas de acesso PDI</option>
                    </select>
                </div>

                <div class="input-group w50">
                    <label for="usuario">usuário</label>
                    <input type="text" id="usuario" name="cadastro_usuario" readonly>
                </div>

                <div class="input-group w50">
                    <label for="senha">Senha</label>
                    <input type="text" id="senha" name="cadastro_senha" readonly>
                </div>
                <cfoutput>
                    <div hidden class="input-group w50">
                        <label for="usuario">usuário</label>
                        <input type="text" id="cadastro_resp" name="cadastro_resp" value="#login.USER_SIGN#">
                    </div>
                </cfoutput>
                <div class="input-group">

                    <cfset nomesPermitidos = "JEFFERSON ALVES TEIXEIRA,RAFAGA DE OLIVEIRA LIMA CORREA,LINCON AFONSO TRENTIN,KENNEDY DOS REIS ROSARIO,LUCAS CORREA LEAL,DANIEL ALVES TEIXEIRA,JOAO CLEBER RODRIGUES">

                    <cfif login.recordcount gt 0 AND ListFind(nomesPermitidos, login.USER_SIGN)>
                        <button type="submit">Cadastrar</button>
                    </cfif>                   
                    <button type="button" onclick="voltarParaIndex()">Voltar</button>
                </div>

            </form>
        </div>
    </div>
    <script>
        function voltarParaIndex() {
            window.history.back();
        }
    
        function atualizarCredenciais() {
            const nomeCompleto = document.getElementById("nome").value.trim();
            const matricula = document.getElementById("matricula").value.trim();
            
            if (!nomeCompleto || !matricula) {
                document.getElementById("usuario").value = "";
                document.getElementById("senha").value = "";
                return;
            }
    
            const nomes = nomeCompleto.split(" ");
            const primeiroNome = nomes[0]?.toLowerCase() || "";
            const ultimoNome = nomes.length > 1 ? nomes[nomes.length - 1].toLowerCase() : "";
            const usuario = `${primeiroNome}.${ultimoNome}`;
    
            const senha = gerarSenhaAleatoria();
    
            document.getElementById("usuario").value = usuario;
            document.getElementById("senha").value = senha;
        }
    
        function gerarSenhaAleatoria() {
            let primeiroDigito = Math.floor(Math.random() * 9) + 1; // Garante que não seja 0
            let outrosDigitos = Math.floor(Math.random() * 1000).toString().padStart(3, '0'); // Garante 3 dígitos
            return `${primeiroDigito}${outrosDigitos}`;
        }
    </script>
    
    </body>
</html>