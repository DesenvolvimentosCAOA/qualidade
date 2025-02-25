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
                SYSDATE,
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

<cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.pecas_defeitos
    WHERE SHOP = 'BODY'
    ORDER BY ID DESC
</cfquery>

<!--- Deletar Item --->
<cfif structKeyExists(url, "id") and url.id neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.pecas_defeitos WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
    <script>
        self.location = 'cadastro_defeito_peca.cfm';
    </script>
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
        .img-box {
            background-color: rgba(255, 255, 255, 0.5);
            width: 50%;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            padding: 20px;
            border-radius: 20px 0 0 20px;
        }

        #searchInput {
            align-self: stretch;
        }

        #dataTable {
            max-width: 100%; 
            max-height: 550px; /* Ajuste conforme necessário */
            overflow-y: auto;
            display: block; /* Evita que a tabela force o tamanho da div */
            border-collapse: separate; /* Permite o uso de border-spacing */
            border-spacing: 5px; /* Define o espaçamento entre as células */
        }
            /* Esconde a barra de rolagem, mas mantém o rolar da tabela */
        #dataTable::-webkit-scrollbar {
            display: none; /* Esconde a barra de rolagem */
        }

        #dataTable th, #dataTable td {
            border: 2px solid #000;
            padding: 8px;
            font-size:12px;
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
        /* Estilo do botão de exclusão */
        .delete-button {
            background-color: #e74c3c; /* Cor de fundo vermelha */
            color: white; /* Cor do texto */
            font-weight: bold;
            border: none;
            padding: 8px 16px;
            border-radius: 5px; /* Bordas arredondadas */
            cursor: pointer;
            text-decoration: none; /* Remove o sublinhado */
            display: inline-block;
            text-align: center;
            transition: background-color 0.3s, transform 0.2s; /* Efeito de transição */
        }

        /* Efeito quando o mouse passa por cima */
        .delete-button:hover {
            background-color: #c0392b; /* Cor de fundo mais escura ao passar o mouse */
            transform: scale(1.05); /* Aumenta o botão um pouco */
        }

        /* Efeito quando o botão é pressionado */
        .delete-button:active {
            background-color: #e74c3c; /* Cor de fundo original ao pressionar */
            transform: scale(0.95); /* Diminui um pouco o botão */
        }
            /* Estilo do campo de input */
        #searchInput {
            width: 100%; /* Largura 100% */
            padding: 12px 20px; /* Aumenta o preenchimento para mais espaço interno */
            margin-bottom: 20px; /* Adiciona uma margem embaixo */
            border: 2px solid #ccc; /* Borda cinza suave */
            border-radius: 25px; /* Bordas arredondadas */
            font-size: 16px; /* Tamanho da fonte */
            background-color: #f9f9f9; /* Cor de fundo leve */
            transition: border-color 0.3s, box-shadow 0.3s; /* Transição suave para foco */
        }

        /* Efeito de foco no input */
        #searchInput:focus {
            border-color: #3498db; /* Borda azul ao focar */
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.6); /* Sombra azul suave */
            outline: none; /* Remove o contorno padrão */
        }

        /* Adicionando um ícone de lupa dentro do input */
        #searchInput::placeholder {
            color: #888; /* Cor do placeholder */
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="box">
        <div class="img-box">
            <input type="text" id="searchInput" placeholder="Filtrar..." onkeyup="filterTable()" style="margin-bottom: 10px; width: 100%; padding: 5px;">
            <table border="1" id="dataTable" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Descricao</th>
                        <th>Shop</th>
                        <th>Estação</th>
                        <th>Definição</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                        <cfloop query="consulta_adicionais">
                            <tr>
                                <td>
                                    <a href="cadastro_defeito_peca.cfm?id=#consulta_adicionais.ID#" class="delete-button" onclick="return confirm('Tem certeza que deseja excluir este item?');">
                                        #consulta_adicionais.ID#
                                    </a>
                                </td>
                                <td>#consulta_adicionais.Descricao#</td>
                                <td>#consulta_adicionais.Shop#</td>
                                <td>#consulta_adicionais.Estacao#</td>
                                <td>#consulta_adicionais.Definicao#</td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
            
        </div>
        <script>
            function filterTable() {
                var input, filter, table, tr, td, i, j, txtValue;
                input = document.getElementById("searchInput");
                filter = input.value.toLowerCase();
                table = document.getElementById("dataTable");
                tr = table.getElementsByTagName("tr");
                
                for (i = 1; i < tr.length; i++) {
                    tr[i].style.display = "none";
                    td = tr[i].getElementsByTagName("td");
                    for (j = 0; j < td.length; j++) {
                        if (td[j]) {
                            txtValue = td[j].textContent || td[j].innerText;
                            if (txtValue.toLowerCase().indexOf(filter) > -1) {
                                tr[i].style.display = "";
                                break;
                            }
                        }
                    }
                }
            }
        </script>
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
                    <cfset nomesPermitidos = "JEFFERSON ALVES TEIXEIRA,RAFAGA DE OLIVEIRA LIMA CORREA,LINCON AFONSO TRENTIN,KENNEDY DOS REIS ROSARIO,LUCAS CORREA LEAL,DANIEL ALVES TEIXEIRA,JOAO CLEBER RODRIGUES,VICTOR BARBOSA BRITO,EDUARDO SILVA ALVES">
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
            window.location.href = "body_selecionar_buy_off.cfm";
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
    <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "cadastro_defeito_peca.cfm?id=" + id;
                }
            }
        </script> 
    </body>
</html>