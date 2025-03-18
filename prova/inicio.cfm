<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_PROVA") or cookie.USER_APONTAMENTO_PROVA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/prova/index.cfm'
    </script>
</cfif>

<cfquery name="login" datasource="#BANCOSINC#">
    SELECT USER_NAME, USER_SIGN, SHOP 
    FROM INTCOLDFUSION.REPARO_FA_USERS
    WHERE USER_NAME = '#cookie.user_apontamento_prova#'
</cfquery>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <!--- Verifica se o USER_SIGN existe na tabela PROVAS_QUALIDADE com MATERIA = 'ALERTA' --->
    <cfquery name="verificaProvaAlerta" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.PROVAS_QUALIDADE
        WHERE NOME = '#userSign#'
        AND MATERIA = 'ALERTA'
    </cfquery>

    <!--- Se o USER_SIGN com MATERIA = 'ALERTA' existir, exibir alerta, senão redirecionar --->
    <cfif verificaProvaAlerta.recordCount GT 0>
        <cfset alerta = "true">
    <cfelse>
        <cfset alerta = "false">
    </cfif>
<cfelse>
    <cfset alerta = "false">
</cfif>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <!--- Verifica se o USER_SIGN existe na tabela PROVAS_QUALIDADE com MATERIA = 'CHECK LIST' --->
    <cfquery name="verificaProvaCheck" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.PROVAS_QUALIDADE
        WHERE NOME = '#userSign#'
        AND MATERIA = 'CHECK LIST'
    </cfquery>

    <!--- Se o USER_SIGN com MATERIA = 'CHECK LIST' existir, exibir alerta, senão redirecionar --->
    <cfif verificaProvaCheck.recordCount GT 0>
        <cfset check = "true">
    <cfelse>
        <cfset check = "false">
    </cfif>
<cfelse>
    <cfset check = "false">
</cfif>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <cfquery name="verificaTreinamentoAlerta" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.TREINAMENTOS
        WHERE NOME = '#userSign#'
        AND TREINAMENTO = 'ABERTURA DE ALERTAS'
    </cfquery>

    <cfif verificaTreinamentoAlerta.recordCount GT 0>
        <cfset treinamentoalerta = "true">
    <cfelse>
        <cfset treinamentoalerta = "false">
    </cfif>
<cfelse>
    <cfset treinamentoalerta = "false">
</cfif>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <cfquery name="verificaTreinamentoAlertaF" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.TREINAMENTOS
        WHERE NOME = '#userSign#'
        AND TREINAMENTO = 'RESPOSTA DE ALERTAS'
    </cfquery>

    <cfif verificaTreinamentoAlertaF.recordCount GT 0>
        <cfset treinamentoalertaf = "true">
    <cfelse>
        <cfset treinamentoalertaf = "false">
    </cfif>
<cfelse>
    <cfset treinamentoalertaf = "false">
</cfif>

<cfif login.recordCount GT 0>
    <cfset userSign = login.USER_SIGN>

    <cfquery name="verificaTreinamentover" datasource="#BANCOSINC#">
        SELECT NOME 
        FROM INTCOLDFUSION.TREINAMENTOS
        WHERE NOME = '#userSign#'
        AND TREINAMENTO = 'VER & AGIR'
    </cfquery>

    <cfif verificaTreinamentover.recordCount GT 0>
        <cfset treinamentover = "true">
    <cfelse>
        <cfset treinamentover = "false">
    </cfif>
<cfelse>
    <cfset treinamentover = "false">
</cfif>

<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal de Treinamentos</title>
    <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
        .banner {
            background: url('/qualidade/prova/assets/tiggo5.jpg') center/cover no-repeat;
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
    </style>

</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/menu.cfm">
    </header>

    <div class="banner">
        <h1>Bem-vindo ao Portal de Treinamentos da <span style='color:red;'>QUALIDADE</span></h1>
        <p>Desenvolva suas habilidades e aprimore seus conhecimentos na Qualidade.</p>
    </div>

    <div class="section">
        <h2>Treinamentos Disponíveis</h2>
        <div class="card-container">
            <cfif isDefined("cookie.user_level_prova") and ListFind("G,I", cookie.user_level_prova)>
                <div class="card">
                    <h3>Abertura de Alertas</h3>
                    <p>Como Inserir um Alerta no Sistema de Gestão da Qualidade?</p>
                    <a href="alertas_abertura.cfm">Acessar Treinamento</a>
                    
                    <!--- Exibe a mensagem apenas se o treinamento foi realizado --->
                    <cfif treinamentoalerta EQ "true">
                        <p style="color: green; font-weight: bold;">Treinamento realizado</p>
                    </cfif>
                </div>
            </cfif>

            
            <cfif isDefined("cookie.user_level_prova") and ListFind("G,P", cookie.user_level_prova)>
                <div class="card">
                    <h3>Fechamento de Alertas</h3>
                    <p>Como Responder passo a passo um Alerta no Sistema de Gestão da Qualidade?</p>
                    <a href="alertas.cfm">Acessar Treinamento</a>
                    <!--- Exibe a mensagem apenas se o treinamento foi realizado --->
                    <cfif treinamentoalertaF EQ "true">
                        <p style="color: green; font-weight: bold;">Treinamento realizado</p>
                    </cfif>
                </div>
            </cfif>


            <cfif isDefined("cookie.user_level_prova") and ListFind("G,I", cookie.user_level_prova)>
                <div class="card <cfif check EQ 'true'>card-alerta</cfif>" 
                    <cfif check EQ 'true'>title="Você já realizou a prova. Caso queira, revise o treinamento!."</cfif>>
                        <h3>Check List e Indicadores</h3>
                        <p>Aprenda Mais sobre os Indicadores da fábrica e Check Lists do veículo.</p>
                        <a href="powerpoint.cfm">Acessar Treinamento</a>
                    <cfif check EQ 'true'>
                        <p class="prova-realizada">Prova realizada</p>
                    </cfif>
                </div>
            </cfif>

            <cfif isDefined("cookie.user_level_prova") and ListFind("G,I", cookie.user_level_prova)>
                <div class="card">
                    <h3>Ver & Agir</h3>
                    <p>Inserção de Presença e preenchimento do relatório.</p>
                    <a href="ver_agir.cfm">Acessar Treinamento</a>
                    <!--- Exibe a mensagem apenas se o treinamento foi realizado --->
                    <cfif treinamentover EQ "true">
                        <p style="color: green; font-weight: bold;">Treinamento realizado</p>
                    </cfif>
                </div>
            </cfif>
        </div>
    </div>

    <div class="section">
        <h2>Materiais de Apoio</h2>
        <div class="card-container">
            <div class="card">
                <h3>Alertas</h3>
                <p>Procedimentos atualizados.</p>
                <a href="downloads/Lançamentos alertas.pptx" download>Baixar</a>
            </div>
            <div class="card">
                <h3>Lançamento SGQ</h3>
                <p>Como realizar um lançamento no SGQ.</p>
                <a href="downloads/Lançamentos  no Sistema de Gestão da Qualidade.pptx" download>Baixar</a>
            </div>
            <div class="card">
                <h3>Check List e Indicadores</h3>
                <p>Slides de Treinamento Check List e Indicadores</p>
                <a href="downloads/chek_list.zip" download>Baixar</a>
            </div>
        </div>
    </div>

    <footer>
            <cfinclude template="auxi/rodape.cfm">
    </footer>

    <div id="modalPolitica" class="modal">
        <div class="modal-content">
            <button class="close-button">&times;</button>
            <h2>Política de Qualidade</h2>
            <p>
                Satisfação do cliente com veículos de alto nível de tecnologia, qualidade e durabilidade. Por meio de instalações modernas, eficientes
                aplicação de novos conceitos e melhoria contínua, garantindo a harmonia com o meio ambiente, a sociedade e os colaboradores.
            </p>
        </div>
    </div>

    <!-- Modal de Termos de Uso -->
    <div id="modalTermos" class="modal">
        <div class="modal-content">
            <button class="close-button">&times;</button>
            <h2>Termos de Uso</h2>
            <p>
                Ao utilizar este portal, você concorda com os seguintes termos:
            </p>
            <ul>
                <li>Não compartilhar suas credenciais de acesso.</li>
                <li>Utilizar os materiais e treinamentos para fins profissionais.</li>
                <li>Respeitar as normas e regulamentações da CAOA Montadora.</li>
            </ul>
        </div>
    </div>

    <!-- Modal de Contato -->
    <div id="modalContato" class="modal">
        <div class="modal-content">
            <button class="close-button">&times;</button>
            <h2>Valores</h2>
            <ul>
                <li>Ética e Moral</li>
                <li>Trabalho em equipe</li>
                <li>Valorização do ser humano</li>
                <li>Melhoria Contínua</li>
                <li>Defender os interesses do cliente</li>
                <li>Compromentimento</li>
                <li>Saúde, Segurança e Meio Ambiente</li>
            </ul>
        </div>
    </div>

    <script>
        // JavaScript para controlar os modais
        const modals = {
            politica: {
                modal: document.getElementById('modalPolitica'),
                link: document.getElementById('politicaPrivacidade')
            },
            termos: {
                modal: document.getElementById('modalTermos'),
                link: document.getElementById('termosUso')
            },
            contato: {
                modal: document.getElementById('modalContato'),
                link: document.getElementById('contato')
            }
        };

        // Função para abrir modais
        function abrirModal(modal) {
            modal.style.display = 'flex';
        }

        // Função para fechar modais
        function fecharModal(modal) {
            modal.style.display = 'none';
        }

        // Configuração dos eventos
        Object.values(modals).forEach(({ modal, link }) => {
            link.addEventListener('click', () => abrirModal(modal));
            modal.querySelector('.close-button').addEventListener('click', () => fecharModal(modal));
            window.addEventListener('click', (event) => {
                if (event.target === modal) {
                    fecharModal(modal);
                }
            });
        });
    </script>
</body>
</html>