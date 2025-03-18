<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfquery name="qPresenca" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN GERENCIA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_GERENCIA,
            SUM(CASE WHEN SUPERVISOR = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SUPERVISAO,
            SUM(CASE WHEN LIDERANCA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LIDERANCA,
            SUM(CASE WHEN TECNICO = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_TECNICO,
            SUM(CASE WHEN ENGENHEIRO = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_ENGENHEIRO
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO ='1º TURNO'
            AND AREA = 'PAINT'
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

<cfset chartData = "['Dia', 'Gerência', 'Supervisão', 'Liderança', 'Técnico', 'Engenheiro']">
<cfoutput query="qPresenca" group="DIA">
    <cfset chartData = chartData & ",['#DIA#', #TOTAL_GERENCIA#, #TOTAL_SUPERVISAO#, #TOTAL_LIDERANCA#, #TOTAL_TECNICO#, #TOTAL_ENGENHEIRO#]">
</cfoutput>

<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Indicador - Presença</title>
    <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart']});
        google.charts.setOnLoadCallback(drawChart);
    
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                <cfoutput>#chartData#</cfoutput>
            ]);
    
            var options = {
                title: 'Indicador de Presença Paint 1ºTurno',
                isStacked: true,
                hAxis: {
                    title: 'Dia/Turno',
                    slantedText: true, // Inclina os textos para melhor leitura
                    slantedTextAngle: 45 // Ângulo de inclinação
                },
                vAxis: {
                    title: 'Total de Presenças'
                },
                legend: { position: 'top' },
                colors: ['#77B6EA', '#97E3D5', '#F9D47E', '#F4A3C0', '#C7E59F', 
                         '#B9C0DA', '#F1A788', '#D1BBD7', '#AAD5F7', '#FFD1A6',
                         '#FFE4B2', '#B4D6AD', '#D4A5C4'] // Paleta de cores suaves
            };
    
            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
    
    
</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links.cfm">
    </header>

    <div class="container">
        <h1>Indicador de Presença Paint 1ºTurno</h1>
        <div id="chart_div" style="width: 100%; height: 500px;"></div>
    </div>
</body>
</html>
