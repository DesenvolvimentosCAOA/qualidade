<cfinvoke  method="inicializando" component="cf.ini.index">

<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_BODY#'
</cfquery>

<cfquery name="obterMaxId" datasource="#BANCOSINC#">
    SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.pecas_defeitos
</cfquery>

<cfif structKeyExists(form, "cadastro_descricao")>
    <!-- Verificar se os valores já existem -->
    <cfquery name="verificarExistencia" datasource="#BANCOSINC#">
        SELECT COUNT(*) AS contagem
        FROM INTCOLDFUSION.pecas_defeitos
        WHERE descricao = <cfqueryparam value="#form.cadastro_descricao#" cfsqltype="CF_SQL_VARCHAR">
        AND definicao = <cfqueryparam value="#form.cadastro_definicao#" cfsqltype="CF_SQL_VARCHAR">
        AND shop = <cfqueryparam value="#form.cadastro_setor#" cfsqltype="CF_SQL_VARCHAR">
        AND estacao = <cfqueryparam value="#form.cadastro_estacao#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>

    <cfif verificarExistencia.contagem GT 0>
        <cfset session.mensagemErro = "Registro já existe!" />
    <cfelse>
        <!-- Inserir novo registro -->
        <cfquery name="inserir" datasource="#BANCOSINC#">
            INSERT INTO intcoldfusion.pecas_defeitos 
                (id, descricao, definicao, data_criacao, shop, estacao, responsavel)
            VALUES(
                <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#UCase(form.cadastro_descricao)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#UCase(form.cadastro_definicao)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#form.cadastro_data#" cfsqltype="CF_SQL_TIMESTAMP">,
                <cfqueryparam value="#UCase(form.cadastro_setor)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#UCase(form.cadastro_estacao)#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#UCase(form.cadastro_resp)#" cfsqltype="CF_SQL_VARCHAR">
            )
        </cfquery>    
        <cfset session.mensagemSucesso = "Cadastro realizado com sucesso!" />
    </cfif>

    <!-- Mensagem de Sucesso ou Erro com JavaScript para ocultar após 3 segundos -->
    <cfif structKeyExists(session, "mensagemSucesso") OR structKeyExists(session, "mensagemErro")>
        <div id="mensagem" class="alerta" style="text-align: center; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 9999; background-color: green; padding: 15px; border-radius: 5px; border: 1px solid #ccc;">
            <cfif structKeyExists(session, "mensagemSucesso")>
                <cfoutput>#session.mensagemSucesso#</cfoutput>
            <cfelse>
                <cfoutput>#session.mensagemErro#</cfoutput>
            </cfif>
        </div>

        <script>
            // Exibir a mensagem por 3 segundos
            setTimeout(function() {
                document.getElementById("mensagem").style.display = 'none';
            }, 3000); // 3000ms = 3 segundos
        </script>
        <cfset structDelete(session, "mensagemSucesso") />
        <cfset structDelete(session, "mensagemErro") />
    </cfif>
</cfif>

<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap');
        *{
            padding: 0;
            margin: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body{
            background-image: url(/qualidade/buyoff_linhat/imgs/teste3.jpg);
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
            50% { color: yellow; }
            100% { color: green; }
        }
    </style>
</head>
<body>
    <div class="box">
        <div class="img-box">
            <p class="alerta"><span style="color:red;"><strong>ATENÇÃO!!!!</strong></span> Cadastro deve ser realizado exclusivamente pelos Analistas e técnicos responsáveis de cada setor!</p>
        </div>
        <div class="form-box">
            <h2>Cadastro Defeito/Peça</h2>
            <form id="cadastroForm" method="post">
                <div class="input-group">
                    <label for="descricao">Descrição</label>
                    <input type="text" id="descricao" name="cadastro_descricao" required>
                </div>
                <div class="input-group w50">
                    <label for="email">Definição</label>
                    <select id="definicao" name="cadastro_definicao" required>
                        <option value="">Selecione</option>
                        <option value="PECA">PEÇA</option>
                        <option value="PROBLEMA">PROBLEMA</option>
                    </select>
                </div>
                <div class="input-group w50">
                    <label for="email">setor</label>
                    <select id="setor" name="cadastro_setor" onchange="updateEstacaoOptions()" required>
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
                    <label for="telefone">Estação</label>
                    <select id="estacao" name="cadastro_estacao" required>
                        <option value="">Selecione</option>
                    </select>
                </div>
                <cfoutput>
                <div class="input-group w50">
                    <label for="usuario">Data:</label>
                    <input type="text" id="data" name="cadastro_data" readonly value="#DateFormat(now(), "dd/mm/yyyy")#">
                </div>
                    <div class="input-group w50">
                        <label for="usuario">Responsável</label>
                        <input type="text" id="nome_resp" name="cadastro_resp" value="#login.USER_SIGN#">
                    </div>
                </cfoutput>
                <div class="input-group">
                    <cfset nomesPermitidos = "JEFFERSON ALVES TEIXEIRA,RAFAGA DE OLIVEIRA LIMA CORREA,LINCON AFONSO TRENTIN,KENNEDY DOS REIS ROSARIO,LUCAS CORREA LEAL,DANIEL ALVES TEIXEIRA,JOAO CLEBER RODRIGUES">
                    <cfif login.recordcount gt 0 AND ListFind(nomesPermitidos, login.USER_SIGN)>
                        <button type="submit">Cadastrar</button>
                    </cfif>                   
                    <button type="reset" onclick="voltar()">Voltar</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        function voltar() {
            window.location.href = "paint_selecionar_buy_off.cfm";
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
    <script>
        function updateEstacaoOptions() {
            var setor = document.getElementById("setor").value;
            var estacao = document.getElementById("estacao");
            estacao.innerHTML = ""; // Limpa as opções atuais

            var options = {
                "PAINT": ["PAINT"],
                "BODY": ["BODY"],
                "FA": ["CP7", "CP7 TRUCK", "T19", "T30", "T33", "C13", "F05", "F10", "HR", "SUB MOTOR"],
                "FAI": ["TUNEL", "UNDER BODY", "ROAD TEST", "SHOWER", "SIGNOFF"],
                "PDI": ["PDI"],
                "SMALL": ["SMALL"]
            };

            if (options[setor]) {
                options[setor].forEach(function(estacaoOption) {
                    var option = document.createElement("option");
                    option.value = estacaoOption;
                    option.text = estacaoOption;
                    estacao.appendChild(option);
                });
            } else {
                var defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.text = "Selecione";
                estacao.appendChild(defaultOption);
            }
        }
    </script>
    </body>
</html>