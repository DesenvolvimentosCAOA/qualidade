<cfif NOT isDefined("url.mes") OR trim(url.mes) EQ "">
    <cfset mesSelecionado = dateFormat(now(), "yyyy-mm")>
<cfelse>
    <cfset mesSelecionado = url.mes>
</cfif>

<cfquery name="contagemStatus" datasource="#BANCOSINC#">
    SELECT STATUS, COUNT(*) AS total_status
    FROM VEREAGIR2
    WHERE TO_CHAR(DATA_REGISTRO, 'YYYY-MM') = <cfqueryparam value="#mesSelecionado#" cfsqltype="cf_sql_varchar">
    GROUP BY STATUS
</cfquery>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gráfico de Status</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {packages: ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawStatusChart);

        function drawStatusChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Status');
            data.addColumn('number', 'Total');
            data.addColumn({type: 'string', role: 'style'}); // Coluna para definir a cor

            <cfoutput query="contagemStatus">
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
                title: 'Contagem de Status para o mês #mesSelecionado#',
                hAxis: { title: 'Total', minValue: 0 },
                vAxis: { title: 'Status' },
                legend: { position: "none" }
            };

            var chart = new google.visualization.BarChart(document.getElementById('status_chart_div'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>
    <h2>Contagem de Status para o mês #mesSelecionado#</h2>
    <div id="status_chart_div" style="width: 900px; height: 500px;"></div>
</body>
</html>
