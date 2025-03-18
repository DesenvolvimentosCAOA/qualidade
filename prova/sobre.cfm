<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

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

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sobre a Empresa</title>
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
            color: #004a99;
        }
        .section p {
            font-size: 1.1em;
            line-height: 1.8;
            max-width: 800px;
            margin: 0 auto;
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
            color: #004a99;
        }
        .card p {
            font-size: 1em;
            color: #666;
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
    </style>
</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/menu.cfm">
    </header>

    <div class="banner">
        <h1>Sobre a Empresa</h1>
        <p>Conheça nossa história, nossos valores e o que nos torna únicos.</p>
    </div>

    <div class="section">
        <h2>Quem Somos</h2>
        <p>
            Um novo marco de desenvolvimento no coração do Brasil. Inaugurada em 2007, a CAOA Montadora está estrategicamente localizada no Distrito Agroindustrial de Anápolis (DAIA), em Goiás, para escoamento da produção para uma emergente cadeia produtiva. É resultado de um investimento inicial de R$1.2 bilhão, com capital 100% próprio. São mais de 174.000m2 de área construída, e 1.500.000m2 de área total, com alta tecnologia, inovação, qualidade e sustentabilidade em todos os setores. Desde 2017, duas gigantes internacionais, a Hyundai e a CAOA CHERY, passaram a dividir a mesma estrutura, trazendo mais produtividade e mais riqueza para o Brasil. E desde então, a produção da nossa fábrica em Anápolis não pára de crescer, com novos investimentos sendo planejados ano a ano.
        </p>
    </div>

    <div class="section">
        <h2>Qualidade</h2>
        <p>
            Excelência, precisão e compromisso com a satisfação do cliente. Nosso sistema de gestão da qualidade é altamente eficiente, garantindo que cada produto atenda aos mais altos padrões de desempenho e segurança. Contamos com processos rigorosos de controle e inspeção, desde a seleção de matérias-primas até a entrega final, assegurando que cada etapa seja realizada com a máxima eficiência e atenção aos detalhes. Investimos continuamente em tecnologia e capacitação de nossos colaboradores, que são treinados para identificar e resolver qualquer desvio que possa impactar a qualidade dos nossos produtos. Além disso, temos certificações que comprovam nosso compromisso com a excelência, como a ISO 9001, e realizamos auditorias internas e externas para garantir a melhoria contínua de nossos processos. A satisfação do cliente é nossa prioridade, e trabalhamos incansavelmente para superar expectativas e entregar soluções que agreguem valor.
        </p>
    </div>
    
    <div class="section">
        <h2>Produção</h2>
        <p>
            Tecnologia, qualidade e respeito ao meio ambiente. Nossa fábrica tem alta complexidade e alta flexibilidade, é amplamente robotizada e conta com colaboradores extremamente cuidadosos e talentosos. O volume total da produção é dividido entre vários modelos diferentes, e o Centro de Pesquisa e Eficiência Energética de Anápolis é a prova de que a qualidade e a tecnologia são levadas a sério pela CAOA. Na parte ambiental, temos controle total de emissões de gases industriais e de tratamento de resíduos. Já reduzimos em 50% o volume de água utilizado na fábrica por meio de investimentos nos processos produtivos, e temos uma estação de tratamento para reutilização da água, com 6 milhões de litros armazenados para reuso. E além de tudo isso, também temos uma reserva ambiental com árvores típicas do cerrado como parte do nosso Sistema de Gestão Ambiental.
        </p>
    </div>

    <div class="section">
        <h2>Nossa Equipe</h2>
        <div class="card-container">
            <div class="card">
                <h3>Profissionais Qualificados</h3>
                <p>Nossa equipe é composta por especialistas altamente capacitados, prontos para oferecer o melhor suporte e soluções.</p>
            </div>
            <div class="card">
                <h3>Diversidade e Inclusão</h3>
                <p>Valorizamos a diversidade e promovemos um ambiente inclusivo, onde todos têm voz e espaço para crescer.</p>
            </div>
            <div class="card">
                <h3>Compromisso com o Cliente</h3>
                <p>Estamos sempre ao lado dos nossos clientes, entendendo suas necessidades e oferecendo soluções sob medida.</p>
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