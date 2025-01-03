<cfquery name="qrySetores" datasource="#BANCOSINC#">
    SELECT DISTINCT SETOR
    FROM provas_qualidade
    ORDER BY SETOR
</cfquery>

<cfquery name="qryMediaNotas" datasource="#BANCOSINC#">
    SELECT SETOR, AVG(NOTA) AS MEDIA_NOTA
    FROM provas_qualidade
    WHERE 1=1
    <cfif structKeyExists(form, "setor") AND len(form.setor)>
        AND SETOR = <cfqueryparam value="#form.setor#" cfsqltype="cf_sql_varchar">
    </cfif>
    <cfif structKeyExists(form, "turno") AND len(form.turno)>
        AND TURNO = <cfqueryparam value="#form.turno#" cfsqltype="cf_sql_varchar">
    </cfif>
    GROUP BY SETOR
</cfquery>

<cfquery name="qryResultadosPorPergunta" datasource="#BANCOSINC#">
    SELECT 
        AVG(CASE WHEN Q1 = 'B' THEN 1 ELSE 0 END) AS Q1_ACERTOS,
        AVG(CASE WHEN Q2 = 'A' THEN 1 ELSE 0 END) AS Q2_ACERTOS,
        AVG(CASE WHEN Q3 = 'C' THEN 1 ELSE 0 END) AS Q3_ACERTOS,
        AVG(CASE WHEN Q4 = 'A' THEN 1 ELSE 0 END) AS Q4_ACERTOS,
        AVG(CASE WHEN Q5 = 'A' THEN 1 ELSE 0 END) AS Q5_ACERTOS,
        AVG(CASE WHEN Q6 = 'B' THEN 1 ELSE 0 END) AS Q6_ACERTOS,
        AVG(CASE WHEN Q7 = 'A' THEN 1 ELSE 0 END) AS Q7_ACERTOS,
        AVG(CASE WHEN Q8 = 'D' THEN 1 ELSE 0 END) AS Q8_ACERTOS,
        AVG(CASE WHEN Q9 = 'D' THEN 1 ELSE 0 END) AS Q9_ACERTOS,
        AVG(CASE WHEN Q10 = 'A' THEN 1 ELSE 0 END) AS Q10_ACERTOS
    FROM provas_qualidade
    WHERE 1=1
    <cfif structKeyExists(form, "setor") AND len(form.setor)>
        AND SETOR = <cfqueryparam value="#form.setor#" cfsqltype="cf_sql_varchar">
    </cfif>
    <cfif structKeyExists(form, "turno") AND len(form.turno)>
        AND TURNO = <cfqueryparam value="#form.turno#" cfsqltype="cf_sql_varchar">
    </cfif>
</cfquery>

<cfquery name="qryNotasPorNome" datasource="#BANCOSINC#">
    SELECT NOME, NOTA
    FROM provas_qualidade
    WHERE 1=1
    <cfif structKeyExists(form, "setor") AND len(form.setor)>
        AND SETOR = <cfqueryparam value="#form.setor#" cfsqltype="cf_sql_varchar">
    </cfif>
    <cfif structKeyExists(form, "turno") AND len(form.turno)>
        AND TURNO = <cfqueryparam value="#form.turno#" cfsqltype="cf_sql_varchar">
    </cfif>
    ORDER BY NOME
</cfquery>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados - Gráficos</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawCharts);
  
        function drawCharts() {
          // Gráfico de Média por Setor
          var dataSetor = google.visualization.arrayToDataTable([
            ['Setor', 'Média da Nota', { role: 'style' }],
            <cfif qryMediaNotas.recordCount gt 0>
              <cfoutput query="qryMediaNotas">
                ['#SETOR#', #MEDIA_NOTA#, getColor('#SETOR#')],
              </cfoutput>
            <cfelse>
              ['Nenhum dado', 0, 'color: gray']
            </cfif>
          ]);
  
          var optionsSetor = {
            title: 'Média das Notas por Setor',
            chartArea: {width: '50%'},
            hAxis: {title: 'Média da Nota', minValue: 0},
            vAxis: {title: 'Setor'}
          };
  
          var chartSetor = new google.visualization.BarChart(document.getElementById('chart_div_setor'));
          chartSetor.draw(dataSetor, optionsSetor);
  
          // Gráfico de Acertos e Erros por Pergunta
          var dataPergunta = google.visualization.arrayToDataTable([
            ['Pergunta', 'Acertos (%)', 'Erros (%)'],
            <cfif qryResultadosPorPergunta.recordCount gt 0>
              <cfoutput query="qryResultadosPorPergunta">
                <cfif Q1_ACERTOS neq "">
                  ['Q1', #NumberFormat(Q1_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q1_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q2_ACERTOS neq "">
                  ['Q2', #NumberFormat(Q2_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q2_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q3_ACERTOS neq "">
                  ['Q3', #NumberFormat(Q3_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q3_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q4_ACERTOS neq "">
                  ['Q4', #NumberFormat(Q4_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q4_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q5_ACERTOS neq "">
                  ['Q5', #NumberFormat(Q5_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q5_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q6_ACERTOS neq "">
                  ['Q6', #NumberFormat(Q6_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q6_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q7_ACERTOS neq "">
                  ['Q7', #NumberFormat(Q7_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q7_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q8_ACERTOS neq "">
                  ['Q8', #NumberFormat(Q8_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q8_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q9_ACERTOS neq "">
                  ['Q9', #NumberFormat(Q9_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q9_ACERTOS * 100, '0.00')#],
                </cfif>
                <cfif Q10_ACERTOS neq "">
                  ['Q10', #NumberFormat(Q10_ACERTOS * 100, '0.00')#, 100 - #NumberFormat(Q10_ACERTOS * 100, '0.00')#],
                </cfif>
              </cfoutput>
            <cfelse>
              ['Nenhum dado', 0, 0]
            </cfif>
          ]);
  
          var optionsPergunta = {
            title: 'Média por Pergunta - Acertos e Erros',
            chartArea: {width: '50%'},
            hAxis: {title: 'Porcentagem (%)', minValue: 0},
            vAxis: {title: 'Pergunta'},
            isStacked: true
          };
  
          var chartPergunta = new google.visualization.BarChart(document.getElementById('chart_div_pergunta'));
          chartPergunta.draw(dataPergunta, optionsPergunta);
  
          // Gráfico de Notas por Nome
          var dataNome = google.visualization.arrayToDataTable([
            ['Nome', 'Nota'],
            <cfif qryNotasPorNome.recordCount gt 0>
              <cfoutput query="qryNotasPorNome">
                ['#NOME#', #NOTA#],
              </cfoutput>
            <cfelse>
              ['Nenhum dado', 0]
            </cfif>
          ]);
  
          var optionsNome = {
            title: 'Notas por Nome',
            chartArea: {width: '50%'},
            hAxis: {title: 'Nota', minValue: 0},
            vAxis: {title: 'Nome'}
          };
  
          var chartNome = new google.visualization.BarChart(document.getElementById('chart_div_nome'));
          chartNome.draw(dataNome, optionsNome);
        }
  
        function getColor(setor) {
          var colors = {
            'PAINT': 'color: orange',
            'BODY': 'color: blue',
            'SMALL': 'color: Olive',
            'FAI': 'color: gray',
            'FA': 'color: yellow',
            'PDI': 'color: purple'
          };
          return colors[setor] || 'color: gray'; // Cor padrão
        }
      </script>
    <style>
        .chart-container {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <h1>Resultados das Provas</h1>
    <!-- Filtro de Setor -->
    <form method="post">
        <label for="setor">Selecione o Setor:</label>
        <select name="setor" id="setor" onchange="this.form.submit()">
            <option value="">-- Todos os Setores --</option>
            <cfoutput query="qrySetores">
                <option value="#SETOR#" <cfif structKeyExists(form, "setor") AND form.setor eq SETOR>selected</cfif>>#SETOR#</option>
            </cfoutput>
        </select>
        <label for="turno">Selecione o Turno:</label>
        <select name="turno" id="turno" onchange="this.form.submit()">
            <option value="">-- Todos os Turnos --</option>
            <option value="1º TURNO" <cfif structKeyExists(form, "turno") AND form.turno eq "1º TURNO">selected</cfif>>1º TURNO</option>
            <option value="2º TURNO" <cfif structKeyExists(form, "turno") AND form.turno eq "2º TURNO">selected</cfif>>2º TURNO</option>
            <option value="3º TURNO" <cfif structKeyExists(form, "turno") AND form.turno eq "3º TURNO">selected</cfif>>3º TURNO</option>
        </select>
    </form>

    <!-- Gráficos -->
    <div class="chart-container">
        <div id="chart_div_setor" style="width: 45%; height: 500px;"></div>
        <div id="chart_div_pergunta" style="width: 45%; height: 500px;"></div>
    </div>

    <div id="chart_div_nome" style="width: 900px; height: 500px; margin-top: 20px;"></div>
</body>
</html>