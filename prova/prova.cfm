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

<cfif structKeyExists(form, "studentName")>
    <!--- Define valores padrão para questões não respondidas --->
    <cfloop from="1" to="10" index="i">
        <cfif NOT structKeyExists(form, "q#i#")>
            <cfset form["q#i#"] = "">
        </cfif>
    </cfloop>

    <!--- Calcula a nota com base nas respostas --->
    <cfset correctAnswers = {q1="B", q2="A", q3="C", q4="A", q5="A", q6="B", q7="A", q8="D", q9="D", q10="A"}>
    <cfset score = 0>

    <cfloop from="1" to="10" index="i">
        <cfif structKeyExists(correctAnswers, "q#i#") AND form["q#i#"] EQ correctAnswers["q#i#"]>
            <cfset score = score + 1>
        </cfif>
    </cfloop>

    <cfquery datasource="#BANCOSINC#">
        INSERT INTO provas_qualidade (
            NOME, DATA, SETOR, TURNO,
            Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, NOTA, MATERIA
        ) VALUES (
            <cfqueryparam value="#UCase(form.studentName)#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP"/>,
            <cfqueryparam value="#form.setor#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.turno#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q1#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q2#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q3#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q4#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q5#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q6#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q7#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q8#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q9#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#form.q10#" cfsqltype="cf_sql_varchar"/>,
            <cfqueryparam value="#score#" cfsqltype="cf_sql_integer"/>,
            'CHECK LIST'
        )
    </cfquery>

    <cfoutput>
        Prova salva com sucesso para o aluno #form.studentName#!
    </cfoutput>
    <script>
        setTimeout(function() {
            window.location.href = "../prova/inicio.cfm";
        }, 2000); // 2000 ms = 2 segundos
    </script>
</cfif>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prova Online</title>
    <style>
        /* Reset básico */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color:rgb(255, 255, 255);
            color: #ffffff;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        /* Container principal */
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background: #2a2a3f;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
            border-radius: 12px;
        }

        /* Cabeçalho */
        header {
            background-color: #2a2a3f;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 12px 12px 0 0;
            margin-bottom: 20px;
        }

        header h2 {
            margin: 0;
            font-size: 26px;
            font-weight: 600;
        }

        /* Timer */
        .timer {
            text-align: right;
            font-size: 18px;
            color: #ff4d4d;
            margin-bottom: 20px;
            font-weight: 500;
        }

        /* Textos secundários */
        h6 {
            font-size: 14px;
            color: #ccc;
            margin: 5px 0;
            font-weight: 400;
        }

        /* Mensagem de destaque */
        h4 {
            font-size: 20px;
            color: #00cc88;
            text-align: center;
            margin: 20px 0;
            font-weight: 600;
        }

        /* Container de inputs */
        .input-container {
            margin-bottom: 30px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #ffffff;
            font-weight: 500;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #444;
            border-radius: 8px;
            font-size: 16px;
            background-color: #3a3a4f;
            color: #ffffff;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .input-group input:focus,
        .input-group select:focus {
            border-color: #00cc88;
            box-shadow: 0 0 8px rgba(0, 204, 136, 0.3);
            outline: none;
        }

        .input-group input:read-only {
            background-color: #444;
            cursor: not-allowed;
        }

        /* Layout para Setor e Turno na mesma linha */
        .row {
            display: flex;
            gap: 20px; /* Espaçamento entre Setor e Turno */
        }

        .row .input-group {
            flex: 1;
        }

        /* Reduzir o tamanho do campo Setor */
        .row .input-group#setor-group {
            flex: 0.5; /* Define a largura do Setor como 50% do espaço disponível */
        }

        /* Aumentar o espaçamento entre Setor e Turno */
        .row .input-group#setor-group {
            margin-right: 30px; /* Espaçamento maior entre Setor e Turno */
        }

        /* Questões */
        .question {
            margin-bottom: 25px;
            padding: 20px;
            background-color: #3a3a4f;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .question:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        .question h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #ffffff;
            font-weight: 500;
        }

        /* Opções de resposta */
        .options label {
            display: block;
            margin-bottom: 10px;
            padding: 12px;
            background-color: #4a4a5f;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .options label:hover {
            background-color: #5a5a6f;
            transform: translateX(5px);
        }

        .options input[type="radio"] {
            margin-right: 10px;
        }

        /* Botão de enviar */
        .btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin-top: 30px;
            font-size: 16px;
            color: white;
            background-color: #00cc88;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            font-weight: 500;
        }

        .btn:hover {
            background-color: #00b377;
            transform: translateY(-2px);
        }

        /* Resultado */
        .result {
            margin-top: 20px;
            text-align: center;
            font-size: 18px;
            color: #00cc88;
            display: none;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h2>Prova Online - Indicadores/ Check List</h2>
        </header>

        <div class="timer" id="timer">Tempo restante: 30:00</div>
        <h6>*Você terá exatos 30 minutos para o término da prova</h6>
        <h6>*Ao término do tempo, a prova será enviada automaticamente, se estiver sem resposta será considerado como ERRADA</h6>
        <h6>A prova vale 10,0 pontos</h6>
        <h4>BOA PROVA!!</h4>
        <cfoutput>
            <form id="quizForm" method="post">
                <cfquery name="login" datasource="#BANCOSINC#">
                    SELECT USER_NAME, USER_SIGN, SHOP FROM INTCOLDFUSION.REPARO_FA_USERS
                    WHERE USER_NAME = '#cookie.user_apontamento_prova#'
                </cfquery>
                <div class="input-container">
                    <!-- Nome Completo na linha de cima -->
                    <div class="input-group">
                        <label for="studentName">Nome Completo:</label>
                        <input type="text" id="studentName" name="studentName" value="#login.USER_SIGN#" readonly required>
                    </div>
                    <!-- Setor e Turno na linha de baixo -->
                    <div class="row">
                        <div class="input-group" id="setor-group">
                            <label for="setor">Setor:</label>
                            <input type="text" id="setor" name="setor" value="#login.shop#" readonly required>
                        </div>
                        <div class="input-group">
                            <label for="turno">Turno:</label>
                            <select id="turno" name="turno" required>
                                <option value="" disabled selected>Selecione</option>
                                <option value="1º TURNO">1º TURNO</option>
                                <option value="2º TURNO">2º TURNO</option>
                                <option value="3º TURNO">3º TURNO</option>
                            </select>
                        </div>
                    </div>
                </div>
                <!-- Questões -->
            <div id="questions-container">
                <div class="question" id="q1">
                    <h2>Qual é a principal função dos indicadores?</h2>
                    <div class="options" id="options-q1">
                        <label><input type="radio" name="q1" value="A">Aumentar os custos operacionais</label>
                        <label><input type="radio" name="q1" value="B">Medir e monitorar o desempenho em relação a objetivos ou metas estabelecidas</label>
                        <label><input type="radio" name="q1" value="C">Melhorar a estética dos produtos</label>
                        <label><input type="radio" name="q1" value="D">Reduzir a necessidade de manutenção</label>
                    </div>
                </div>
                <div class="question" id="q2">
                    <h2>O que compõe um indicador de qualidade?</h2>
                    <div class="options" id="options-q1">
                        <label><input type="radio" name="q2" value="A">Medida específica, critérios de avaliação, periodicidade e objetivo claro</label>
                        <label><input type="radio" name="q2" value="B">Apenas uma medida específica e critérios de avaliação</label>
                        <label><input type="radio" name="q2" value="C">Critérios de avaliação, periodicidade e redução de custos</label>
                        <label><input type="radio" name="q2" value="D">Objetivo claro e aumento da eficiência</label>
                    </div>
                </div>
                <div class="question" id="q3">
                    <h2>Qual das seguintes opções NÃO é uma categoria de indicadores de qualidade?</h2>
                    <div class="options">
                        <label><input type="radio" name="q3" value="A">Indicadores de desempenho (KPIs)</label>
                        <label><input type="radio" name="q3" value="B">Indicadores de qualidade</label>
                        <label><input type="radio" name="q3" value="C">Indicadores de estética</label>
                        <label><input type="radio" name="q3" value="D">Indicadores de conformidade</label>
                    </div>
                </div>
                <div class="question" id="q4">
                    <h2>O que significa a sigla FTQ?</h2>
                    <div class="options">
                        <label><input type="radio" name="q4" value="A">First Time Quality, que mede a porcentagem de veículos fabricados corretamente na primeira tentativa</label>
                        <label><input type="radio" name="q4" value="B">Final Test Quality, que avalia a qualidade dos veículos após todos os testes finais</label>
                        <label><input type="radio" name="q4" value="C">First Time Quality, que mede a quantidade de veículos que necessitam de retrabalho</label>
                        <label><input type="radio" name="q4" value="D">Final Test Quality, que verifica a conformidade dos veículos com os padrões de segurança</label>
                    </div>
                </div>
                <div class="question" id="q5">
                    <h2>No FAI, qual é a meta de DRR (Direct Run Rate) que a empresa deseja alcançar?</h2>
                    <div class="options">
                        <label><input type="radio" name="q5" value="A">98%</label>
                        <label><input type="radio" name="q5" value="B">85%</label>
                        <label><input type="radio" name="q5" value="C">94%</label>
                        <label><input type="radio" name="q5" value="D">86%</label>
                    </div>
                </div>
                <div class="question" id="q6">
                    <h2>Qual das seguintes afirmações sobre a utilização de checklists é verdadeira?</h2>
                    <div class="options">
                        <label><input type="radio" name="q6" value="A">Checklists são usados principalmente para reduzir os custos de produção.</label>
                        <label><input type="radio" name="q6" value="B">Checklists garantem que todos os processos estejam em conformidade com normas e procedimentos internos</label>
                        <label><input type="radio" name="q6" value="C">Checklists são ferramentas que substituem a necessidade de treinamento dos colaboradores.</label>
                        <label><input type="radio" name="q6" value="D">Checklists são utilizados apenas para melhorar a estética dos produtos finais.</label>
                    </div>
                </div>
                <div class="question" id="q7">
                    <h2>Qual das seguintes afirmações sobre a utilização de checklists é verdadeira?</h2>
                    <div class="options">
                        <label><input type="radio" name="q7" value="A">Garantir que todos os colaboradores sigam as mesmas etapas e critérios</label>
                        <label><input type="radio" name="q7" value="B">Auxiliar na flexibilização das tarefas para cada colaborador</label>
                        <label><input type="radio" name="q7" value="C">Promover a substituição de procedimentos padronizados por abordagens criativas</label>
                        <label><input type="radio" name="q7" value="D">Reduzir a necessidade de organização durante a execução das atividades</label>
                    </div>
                </div>
                <div class="question" id="q8">
                    <h2>Como os checklists contribuem para a eficiência operacional?</h2>
                    <div class="options">
                        <label><input type="radio" name="q8" value="A">Aumentando a chance de erros humanos</label>
                        <label><input type="radio" name="q8" value="B">Reduzindo a necessidade de treinamento dos colaboradores</label>
                        <label><input type="radio" name="q8" value="C">Diminuindo a produtividade dos colaboradores</label>
                        <label><input type="radio" name="q8" value="D">Reduzindo erros e aumentando a produtividade</label>
                    </div>
                </div>
                <div class="question" id="q9">
                    <h2>Qual dos seguintes erros ao usar checklists na fábrica pode levar a interpretações erradas e execução inadequada das tarefas?</h2>
                    <div class="options">
                        <label><input type="radio" name="q9" value="A">Descrição vaga</label>
                        <label><input type="radio" name="q9" value="B">Omissão de informações</label>
                        <label><input type="radio" name="q9" value="C">Erros de digitação</label>
                        <label><input type="radio" name="q9" value="D">Todas as alternativas</label>
                    </div>
                </div>
                <div class="question" id="q10">
                    <h2>Qual dos seguintes erros ao usar checklists pode resultar em falta de dados importantes para a análise e rastreamento?</h2>
                    <div class="options">
                        <label><input type="radio" name="q10" value="A">Descrição vaga, Omissão de informações, Inconsistência nas respostas e Desconhecimento do processo, são alguns dos erros comuns.</label>
                        <label><input type="radio" name="q10" value="B">Utilizar termos técnicos muito específicos sem explicação</label>
                        <label><input type="radio" name="q10" value="C">Revisar constantemente os checklists para garantir sua relevância</label>
                        <label><input type="radio" name="q10" value="D">Alterar a sequência das etapas com base em preferências individuais</label>
                    </div>
                </div>
            </div>
                <input type="hidden" id="nota" name="nota" value="0">
                <button type="submit" class="btn" onclick="calculateScore()">Enviar Prova</button>
            </form>
        </cfoutput>
            <div class="result" id="result"></div>
        </div>
        <script src="./script.js"></script>
    </body>
</html>
