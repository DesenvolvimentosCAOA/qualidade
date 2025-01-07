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
            Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, NOTA
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
            <cfqueryparam value="#score#" cfsqltype="cf_sql_integer"/>
        )
    </cfquery>

    <cfoutput>
        Prova salva com sucesso para o aluno #form.studentName#!
    </cfoutput>
    <script>
        setTimeout(function() {
            window.location.href = "../buyoff_linhat/index.cfm";
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
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        header {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-align: center;
            border-radius: 10px 10px 0 0;
        }
        header h1 {
            margin: 0;
        }
        nav {
            margin: 20px 0;
            text-align: center;
        }
        nav a {
            margin: 0 10px;
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
        nav a:hover {
            text-decoration: underline;
        }
        h2 {
            font-size: 18px;
            margin-bottom: 10px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            cursor: pointer;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        input[type="radio"] {
            margin-right: 10px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            font-size: 16px;
            color: white;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .result {
            margin-top: 20px;
            text-align: center;
            font-size: 18px;
            color: green;
            display: none;
        }
        .timer {
            text-align: right;
            font-size: 18px;
            color: red;
            margin-bottom: 20px;
        }
        .input-container {
        display: flex;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 20px;
        }

        .input-group {
            flex: 1;
        }

        .input-group label {
            display: block;
            margin-bottom: 5px;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        h2 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .question {
            margin-bottom: 20px;
        }

        .options label {
            display: block;
            margin-bottom: 5px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            font-size: 16px;
            color: white;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
    <body>
        <div class="container">
            <header>
                <h2>Prova Online - Indicadores/ Check List</h2>
            </header>
            <nav>
                <a href="#">Início</a>
                <a href="#prova">Prova</a>
                <a href="#resultados">Resultados</a>
            </nav>
            <div class="timer" id="timer">Tempo restante: 30:00</div>
            <h6>*Você terá exatos 30 minutos para o término da prova</h6>
            <h6>*Ao término do tempo, a prova será enviada automaticamente, se estiver sem resposta será considerado como ERRADA</h6>
            <h6>A prova vale 10,0 pontos</h6>
            <h4>BOA PROVA!!</h4>

            <form id="quizForm" method="post">
                <div class="input-container">
                    <div class="input-group">
                        <label for="studentName">Nome Completo:</label>
                        <input type="text" id="studentName" name="studentName" placeholder="Digite seu nome" required>
                    </div>
                    <div class="input-group">
                        <label for="setor">Setor:</label>
                        <select id="setor" name="setor" required>
                            <option value="" disabled selected>Selecione</option>
                            <option value="PAINT">PAINT</option>
                            <option value="SMALL">SMALL</option>
                            <option value="BODY">BODY</option>
                            <option value="FA">FA</option>
                            <option value="FAI">FAI</option>
                            <option value="PDI">PDI</option>
                        </select>
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
            <div class="result" id="result"></div>
        </div>
        <script src="./script.js"></script>
    </body>
</html>
