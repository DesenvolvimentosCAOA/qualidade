<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <!-- Verificar se o parâmetro 'mes' existe na URL, caso contrário, usar o mês atual -->
    <cfif NOT isDefined("url.mes") OR trim(url.mes) EQ "">
        <cfset mesSelecionado = dateFormat(now(), "yyyy-mm")> <!-- Mês atual -->
    <cfelse>
        <cfset mesSelecionado = url.mes> <!-- Mês selecionado da URL -->
    </cfif>

    <!--TRIM SHOP-->
    <cfquery name="consulta_semanal" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_PROCESSO IS NOT NULL
        AND BARREIRA = 'FINAL ASSEMBLY'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <cfquery name="consulta_semanal_definitivo" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_DEFINITIVO_PROCESSO IS NOT NULL
        AND BARREIRA = 'FINAL ASSEMBLY'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <!--PAINT SHOP-->
    <cfquery name="consulta_semanal_paint" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_PROCESSO IS NOT NULL
        AND BARREIRA = 'PAINT'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <cfquery name="consulta_semanal_definitivo_paint" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_DEFINITIVO_PROCESSO IS NOT NULL
        AND BARREIRA = 'PAINT'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <!--BODY SHOP-->
    <cfquery name="consulta_semanal_body" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_PROCESSO IS NOT NULL
        AND BARREIRA = 'BODY'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <cfquery name="consulta_semanal_definitivo_body" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_DEFINITIVO_PROCESSO IS NOT NULL
        AND BARREIRA = 'BODY'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <!--FAI SHOP-->
    <cfquery name="consulta_semanal_fai" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_PROCESSO IS NOT NULL
        AND BARREIRA = 'FAI'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <cfquery name="consulta_semanal_definitivo_fai" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_DEFINITIVO_PROCESSO IS NOT NULL
        AND BARREIRA = 'FAI'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <!--PDI SHOP-->
    <cfquery name="consulta_semanal_pdi" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_PROCESSO IS NOT NULL
        AND BARREIRA = 'PDI'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>
    
    <cfquery name="consulta_semanal_definitivo_pdi" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW') AS Semana,
            ROUND(AVG(DATA_BP_DEFINITIVO_PROCESSO - DATA_REGISTRO), 2) AS Media_Dias
        FROM VEREAGIR2
        WHERE DATA_BP_DEFINITIVO_PROCESSO IS NOT NULL
        AND BARREIRA = 'PDI'
        AND TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
        GROUP BY TO_CHAR(DATA_BP_DEFINITIVO_PROCESSO, 'IW')
        ORDER BY Semana
    </cfquery>

    <cfquery name="contagemStatus_Body" datasource="#BANCOSINC#">
        SELECT STATUS, COUNT(*) AS total_status
        FROM VEREAGIR2
        WHERE  BARREIRA = 'BODY'
        AND STATUS NOT IN 'CONCLUÍDO'
        GROUP BY STATUS
    </cfquery>

    <cfquery name="contagemStatus_paint" datasource="#BANCOSINC#">
        SELECT STATUS, COUNT(*) AS total_status
        FROM VEREAGIR2
        WHERE BARREIRA = 'PAINT'
        AND STATUS NOT IN 'CONCLUÍDO'
        GROUP BY STATUS
    </cfquery>

    <cfquery name="contagemStatus_fa" datasource="#BANCOSINC#">
        SELECT STATUS, COUNT(*) AS total_status
        FROM VEREAGIR2
        WHERE BARREIRA = 'FINAL ASSEMBLY'
        AND STATUS NOT IN 'CONCLUÍDO'
        GROUP BY STATUS
    </cfquery>

    <cfquery name="contagemStatus_fai" datasource="#BANCOSINC#">
        SELECT STATUS, COUNT(*) AS total_status
        FROM VEREAGIR2
        WHERE BARREIRA = 'FAI'
        AND STATUS NOT IN 'CONCLUÍDO'
        GROUP BY STATUS
    </cfquery>

    <cfquery name="contagemStatus_pdi" datasource="#BANCOSINC#">
        SELECT STATUS, COUNT(*) AS total_status
        FROM VEREAGIR2
        WHERE BARREIRA = 'PDI'
        AND STATUS NOT IN 'CONCLUÍDO'
        GROUP BY STATUS
    </cfquery>

<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicador - VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

        <style>
            .chart-container {
                display: flex;
                justify-content: space-around;
            }
            .btn-container {
                margin-top: 10vw;
            }
            /* Estilo para o select */
            .select-rounded {
                border-radius: 20px;
                padding: 10px 20px;
                background-color: #132a32; /* Cor de fundo similar ao seu botão */
                color: white;  /* Cor do texto */
                border: 1px solid #5a5a5a;  /* Borda sutil */
                font-weight: bold;
                font-size: 1vw; /* Tamanho da fonte */
                cursor: pointer;
                margin: 5px;
                position: relative;
                appearance: none; /* Para remover o estilo nativo de certos navegadores */
                -webkit-appearance: none; /* Para garantir que o estilo seja removido no Safari */
                -moz-appearance: none; /* Para garantir que o estilo seja removido no Firefox */
            }
        
            /* Estilo para a seta do select */
            .select-rounded::-ms-expand {
                display: none; /* Remove a seta do select no IE */
            }
        
            .select-rounded option {
                background-color: #132a32;
                color: white;
            }
        
            .label-rounded {
                font-size: 1.2vw;
                font-weight: bold;
                color: white; /* Cor do texto */
                margin-right: 10px; /* Espaço entre o label e o select */
                font-family: Arial, sans-serif;
            }
        
            .select-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 20px; /* Espaço acima */
                position: fixed; /* Fixa o container na tela */
                top: 70px; /* Distância do topo da página */
                right: 20px; /* Distância da direita da página */
                z-index: 1000; /* Garante que o container fique acima de outros elementos */
                background-color: rgba(0, 0, 0, 0.7); /* Fundo escuro com transparência */
                border-radius: 15px; /* Bordas arredondadas */
                padding: 10px; /* Espaçamento interno */
            }
            /* Tela de Loading */
            #loading-screen {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.8);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                visibility: hidden;
                opacity: 0;
                transition: opacity 0.3s ease-in-out;
            }

            #loading-screen.show {
                visibility: visible;
                opacity: 1;
            }

            .spinner {
                width: 50px;
                height: 50px;
                border: 5px solid rgba(255, 255, 255, 0.3);
                border-top-color: #f6722c;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
        </style>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawFirstChart);
            google.charts.setOnLoadCallback(drawSecondChart);
      
            // Primeiro gráfico
            function drawFirstChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 1) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP de Contenção',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_1'));
                chart.draw(data, options);
            }

            // Segundo gráfico
            function drawSecondChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_definitivo">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 5) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP Definitivo',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_2'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(draw3Chart);
            google.charts.setOnLoadCallback(draw4Chart);

            // Primeiro gráfico
            function draw3Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_paint">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 1) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP de Contenção',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_3'));
                chart.draw(data, options);
            }

            // Segundo gráfico
            function draw4Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_definitivo_paint">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 5) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP Definitivo',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_4'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(draw5Chart);
            google.charts.setOnLoadCallback(draw6Chart);

            // Primeiro gráfico
            function draw5Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_body">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 1) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP de Contenção',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_5'));
                chart.draw(data, options);
            }

            // Segundo gráfico
            function draw6Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_definitivo_body">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 5) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP Definitivo',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_6'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(draw7Chart);
            google.charts.setOnLoadCallback(draw8Chart);

            // Primeiro gráfico
            function draw7Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_fai">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 1) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP de Contenção',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_7'));
                chart.draw(data, options);
            }

            // Segundo gráfico
            function draw8Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_definitivo_fai">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 5) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP Definitivo',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_8'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(draw9Chart);
            google.charts.setOnLoadCallback(draw10Chart);

            // Primeiro gráfico
            function draw9Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_pdi">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 1) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP de Contenção',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_9'));
                chart.draw(data, options);
            }

            // Segundo gráfico
            function draw10Chart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Semana');
                data.addColumn('number', 'Média Tempo de Resposta');
                data.addColumn({type: 'string', role: 'style'});
                data.addColumn({type: 'string', role: 'annotation'});

                <cfoutput query="consulta_semanal_definitivo_pdi">
                var mediaDias = #Media_Dias#;
                var corBarra = (mediaDias > 7) ? 'color: red' : 'color: green';
                data.addRow(['Semana #Semana#', mediaDias, corBarra, mediaDias.toString()]);
                </cfoutput>

                var options = {
                title: 'Média Tempo de Resposta de BP Definitivo',
                hAxis: {
                    title: 'Semana',
                },
                vAxis: {
                    title: 'Média de Dias',
                    minValue: 0
                },
                legend: { position: "none" },
                annotations: {
                    alwaysOutside: false, // Coloca o rótulo sempre fora da barra
                    textStyle: {
                    color: 'black',  // Cor do texto
                    fontSize: 15,     // Tamanho da fonte
                    bold: true        // Negrito
                    }
                }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_10'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawStatusChart);

            function drawStatusChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Status');
                data.addColumn('number', 'Total');
                data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

                <cfoutput query="contagemStatus_Paint">
                    var color = '';
                    switch ('#STATUS#') {
                        case 'CONCLUÍDO':
                            color = 'color: green';
                            break;
                        case 'AG. BP DEFINITIVO':
                            color = 'color: orange';
                            break;
                        case 'EM ANDAMENTO':
                            color = 'color: gold';
                            break;
                        default:
                            color = 'color: gray';
                    }
                    data.addRow(['#STATUS#', #total_status#, color]);
                </cfoutput>

                var options = {
                    title: 'Status Paint',
                    hAxis: { title: 'Total', minValue: 0 },
                    vAxis: { title: '' },
                    legend: { position: "none" }
                };

                var chart = new google.visualization.BarChart(document.getElementById('status_chart_paint'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawStatusChart);

            function drawStatusChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Status');
                data.addColumn('number', 'Total');
                data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

                <cfoutput query="contagemStatus_body">
                    var color = '';
                    switch ('#STATUS#') {
                        case 'CONCLUÍDO':
                            color = 'color: green';
                            break;
                        case 'AG. BP DEFINITIVO':
                            color = 'color: orange';
                            break;
                        case 'EM ANDAMENTO':
                            color = 'color: gold';
                            break;
                        default:
                            color = 'color: gray';
                    }
                    data.addRow(['#STATUS#', #total_status#, color]);
                </cfoutput>

                var options = {
                    title: 'Status Body',
                    hAxis: { title: 'Total', minValue: 0 },
                    vAxis: { title: '' },
                    legend: { position: "none" }
                };

                var chart = new google.visualization.BarChart(document.getElementById('status_chart_div'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawStatusChart);

            function drawStatusChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Status');
                data.addColumn('number', 'Total');
                data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

                <cfoutput query="contagemStatus_fa">
                    var color = '';
                    switch ('#STATUS#') {
                        case 'CONCLUÍDO':
                            color = 'color: green';
                            break;
                        case 'AG. BP DEFINITIVO':
                            color = 'color: orange';
                            break;
                        case 'EM ANDAMENTO':
                            color = 'color: gold';
                            break;
                        default:
                            color = 'color: gray';
                    }
                    data.addRow(['#STATUS#', #total_status#, color]);
                </cfoutput>

                var options = {
                    title: 'Status Assembly',
                    hAxis: { title: 'Total', minValue: 0 },
                    vAxis: { title: '' },
                    legend: { position: "none" }
                };

                var chart = new google.visualization.BarChart(document.getElementById('status_chart_fa'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawStatusChart);

            function drawStatusChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Status');
                data.addColumn('number', 'Total');
                data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

                <cfoutput query="contagemStatus_fai">
                    var color = '';
                    switch ('#STATUS#') {
                        case 'CONCLUÍDO':
                            color = 'color: green';
                            break;
                        case 'AG. BP DEFINITIVO':
                            color = 'color: orange';
                            break;
                        case 'EM ANDAMENTO':
                            color = 'color: gold';
                            break;
                        default:
                            color = 'color: gray';
                    }
                    data.addRow(['#STATUS#', #total_status#, color]);
                </cfoutput>

                var options = {
                    title: 'Status FAI',
                    hAxis: { title: 'Total', minValue: 0 },
                    vAxis: { title: '' },
                    legend: { position: "none" }
                };

                var chart = new google.visualization.BarChart(document.getElementById('status_chart_fai'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawStatusChart);

            function drawStatusChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Status');
                data.addColumn('number', 'Total');
                data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

                <cfoutput query="contagemStatus_pdi">
                    var color = '';
                    switch ('#STATUS#') {
                        case 'CONCLUÍDO':
                            color = 'color: green';
                            break;
                        case 'AG. BP DEFINITIVO':
                            color = 'color: orange';
                            break;
                        case 'EM ANDAMENTO':
                            color = 'color: gold';
                            break;
                        default:
                            color = 'color: gray';
                    }
                    data.addRow(['#STATUS#', #total_status#, color]);
                </cfoutput>

                var options = {
                    title: 'Status PDI',
                    hAxis: { title: 'Total', minValue: 0 },
                    vAxis: { title: '' },
                    legend: { position: "none" }
                };

                var chart = new google.visualization.BarChart(document.getElementById('status_chart_pdi'));
                chart.draw(data, options);
            }
        </script>

    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        
        <div id="loading-screen">
            <div class="spinner"></div>
        </div>

        <div class="btn-container">
            <h2>Indicador de Status VER & AGIR</h2>
            <div class="select-container">
                <label for="meses" class="label-rounded">Escolha o mês:</label>
                <select id="meses" name="mes" class="select-rounded" onchange="updateCharts()">
                    <option value="2025-01" <cfif mesSelecionado == "2025-01">selected</cfif>>Janeiro</option>
                    <option value="2025-02" <cfif mesSelecionado == "2025-02">selected</cfif>>Fevereiro</option>
                    <option value="2025-03" <cfif mesSelecionado == "2025-03">selected</cfif>>Março</option>
                    <option value="2025-04" <cfif mesSelecionado == "2025-04">selected</cfif>>Abril</option>
                    <option value="2025-05" <cfif mesSelecionado == "2025-05">selected</cfif>>Maio</option>
                    <option value="2025-06" <cfif mesSelecionado == "2025-06">selected</cfif>>Junho</option>
                    <option value="2025-07" <cfif mesSelecionado == "2025-07">selected</cfif>>Julho</option>
                    <option value="2025-08" <cfif mesSelecionado == "2025-08">selected</cfif>>Agosto</option>
                    <option value="2025-09" <cfif mesSelecionado == "2025-09">selected</cfif>>Setembro</option>
                    <option value="2025-10" <cfif mesSelecionado == "2025-10">selected</cfif>>Outubro</option>
                    <option value="2025-11" <cfif mesSelecionado == "2025-11">selected</cfif>>Novembro</option>
                    <option value="2025-12" <cfif mesSelecionado == "2025-12">selected</cfif>>Dezembro</option>
                </select>
            </div>

            <script type="text/javascript">
                function updateCharts() {
                    var mesSelecionado = document.getElementById("meses").value;
                    window.location.href = window.location.pathname + "?mes=" + mesSelecionado;
                }
            </script>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <h2 style="text-align: center; margin-bottom: 20px;color:blue;">Body</h2>
                <div style="display: flex; justify-content: center; width: 100%;">
                    <div id="chart_div_5" style="width: 45%; height: 300px;"></div>
                    <div id="chart_div_6" style="width: 45%; height: 300px; margin-left: 10px;"></div>
                </div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <div id="status_chart_div" style="width: 900px; height: 200px;"></div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <h2 style="text-align: center; margin-bottom: 20px;color:Orange;">Paint</h2>
                <div style="display: flex; justify-content: center; width: 100%;">
                    <div id="chart_div_3" style="width: 45%; height: 300px;"></div>
                    <div id="chart_div_4" style="width: 45%; height: 300px; margin-left: 10px;"></div>
                </div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <div id="status_chart_paint" style="width: 900px; height: 200px;"></div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <h2 style="text-align: center; margin-bottom: 20px;color:gold;">Final Assembly</h2>
                <div style="display: flex; justify-content: center; width: 100%;">
                    <div id="chart_div_1" style="width: 45%; height: 300px;"></div>
                    <div id="chart_div_2" style="width: 45%; height: 300px; margin-left: 10px;"></div>
                </div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <div id="status_chart_fa" style="width: 900px; height: 200px;"></div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <h2 style="text-align: center; margin-bottom: 20px;color:grey;">FAI</h2>
                <div style="display: flex; justify-content: center; width: 100%;">
                    <div id="chart_div_7" style="width: 45%; height: 300px;"></div>
                    <div id="chart_div_8" style="width: 45%; height: 300px; margin-left: 10px;"></div>
                </div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <div id="status_chart_fai" style="width: 900px; height: 200px;"></div>
            </div>

            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <h2 style="text-align: center; margin-bottom: 20px;color:purple;">PDI</h2>
                <div style="display: flex; justify-content: center; width: 100%;">
                    <div id="chart_div_9" style="width: 45%; height: 300px;"></div>
                    <div id="chart_div_10" style="width: 45%; height: 300px; margin-left: 10px;"></div>
                </div>
            </div>
            <div class="chart-container" style="display: flex; flex-direction: column; align-items: center; margin-top:5vw;">
                <div id="status_chart_pdi" style="width: 900px; height: 200px;"></div>
            </div>
        </div>
        <script src="/qualidade/relatorios/assets/script.js"></script>
    </body>
    <meta http-equiv="refresh" content="40,URL=indicador.cfm">
</html>