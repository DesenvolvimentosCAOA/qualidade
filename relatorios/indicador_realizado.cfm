<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

<cfquery name="1turnobody" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '1%'
        AND AREA = 'BODY'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="2turnobody" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '2%'
        AND AREA = 'BODY'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="3turnobody" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '3%'
        AND AREA = 'BODY'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="1turnopaint" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '1%'
        AND AREA = 'PAINT'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="2turnopaint" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '2%'
        AND AREA = 'PAINT'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="3turnopaint" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '3%'
        AND AREA = 'PAINT'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="1turnofa" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '1%'
        AND AREA = 'FA'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="2turnofa" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '2%'
        AND AREA = 'FA'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="3turnofa" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '3%'
        AND AREA = 'FA'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="1turnofai" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '1%'
        AND AREA = 'FAI'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="2turnofai" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '2%'
        AND AREA = 'FAI'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="3turnofai" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '3%'
        AND AREA = 'FAI'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="1turnosmall" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '1%'
        AND AREA = 'SMALL'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="2turnosmall" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '2%'
        AND AREA = 'SMALL'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>

<cfquery name="3turnosmall" datasource="#BANCOSINC#">
    SELECT 
        TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
        AREA,
        COUNT(*) AS TOTAL_AREA
    FROM 
        PRESENCA_VER_E_AGIR
    WHERE 
        TURNO LIKE '3%'
        AND AREA = 'SMALL'
        AND DATA >= TRUNC(SYSDATE) -10
    GROUP BY 
        TO_CHAR(DATA, 'DD/MM/YYYY'), AREA
    ORDER BY 
        DIA, AREA
</cfquery>


<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Realizado QC</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart']});
            google.charts.setOnLoadCallback(drawCharts);

            function drawCharts() {
                // Gráfico 1: Área BODY - 3º Turno
                var data1 = new google.visualization.DataTable();
                data1.addColumn('string', 'Data');
                data1.addColumn('number', 'Total de Registros');
                data1.addColumn({type: 'string', role: 'style'});

                <cfoutput query="3turnobody">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data1.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options1 = {
                    title: 'Realizado BODY (3º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart1 = new google.visualization.ColumnChart(document.getElementById('chart_div1'));
                chart1.draw(data1, options1);

                // Gráfico 2: Área PAINT - 1º Turno
                var data2 = new google.visualization.DataTable();
                data2.addColumn('string', 'Data');
                data2.addColumn('number', 'Total de Registros');
                data2.addColumn({type: 'string', role: 'style'});

                <cfoutput query="1turnopaint">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data2.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options2 = {
                    title: 'Realizado PAINT (1º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart2 = new google.visualization.ColumnChart(document.getElementById('chart_div2'));
                chart2.draw(data2, options2);

                // Gráfico 3: Área PAINT - 2º Turno
                var data3 = new google.visualization.DataTable();
                data3.addColumn('string', 'Data');
                data3.addColumn('number', 'Total de Registros');
                data3.addColumn({type: 'string', role: 'style'});

                <cfoutput query="2turnopaint">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data3.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options3 = {
                    title: 'Realizado PAINT (2º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart3 = new google.visualization.ColumnChart(document.getElementById('chart_div3'));
                chart3.draw(data3, options3);

                // Gráfico 4: Área PAINT - 3º Turno
                var data4 = new google.visualization.DataTable();
                data4.addColumn('string', 'Data');
                data4.addColumn('number', 'Total de Registros');
                data4.addColumn({type: 'string', role: 'style'});

                <cfoutput query="3turnopaint">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data4.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options4 = {
                    title: 'Realizado PAINT (3º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart4 = new google.visualization.ColumnChart(document.getElementById('chart_div4'));
                chart4.draw(data4, options4);

                // Gráfico 5: Área FA - 1º Turno
                var data5 = new google.visualization.DataTable();
                data5.addColumn('string', 'Data');
                data5.addColumn('number', 'Total de Registros');
                data5.addColumn({type: 'string', role: 'style'});

                <cfoutput query="1turnofa">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data5.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options5 = {
                    title: 'Realizado FA (1º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart5 = new google.visualization.ColumnChart(document.getElementById('chart_div5'));
                chart5.draw(data5, options5);

                // Gráfico 6: Área FA - 2º Turno
                var data6 = new google.visualization.DataTable();
                data6.addColumn('string', 'Data');
                data6.addColumn('number', 'Total de Registros');
                data6.addColumn({type: 'string', role: 'style'});

                <cfoutput query="2turnofa">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data6.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options6 = {
                    title: 'Realizado FA (2º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart6 = new google.visualization.ColumnChart(document.getElementById('chart_div6'));
                chart6.draw(data6, options6);

                // Gráfico 7: Área FA - 3º Turno
                var data7 = new google.visualization.DataTable();
                data7.addColumn('string', 'Data');
                data7.addColumn('number', 'Total de Registros');
                data7.addColumn({type: 'string', role: 'style'});

                <cfoutput query="3turnofa">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data7.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options7 = {
                    title: 'Realizado FA (3º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart7 = new google.visualization.ColumnChart(document.getElementById('chart_div7'));
                chart7.draw(data7, options7);

                // Gráfico 8: Área FAI - 1º Turno
                var data8 = new google.visualization.DataTable();
                data8.addColumn('string', 'Data');
                data8.addColumn('number', 'Total de Registros');
                data8.addColumn({type: 'string', role: 'style'});

                <cfoutput query="1turnofai">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data8.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options8 = {
                    title: 'Realizado FAI (1º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart8 = new google.visualization.ColumnChart(document.getElementById('chart_div8'));
                chart8.draw(data8, options8);

                // Gráfico 9: Área FAI - 2º Turno
                var data9 = new google.visualization.DataTable();
                data9.addColumn('string', 'Data');
                data9.addColumn('number', 'Total de Registros');
                data9.addColumn({type: 'string', role: 'style'});

                <cfoutput query="2turnofai">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data9.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options9 = {
                    title: 'Realizado FAI (2º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart9 = new google.visualization.ColumnChart(document.getElementById('chart_div9'));
                chart9.draw(data9, options9);

                // Gráfico 10: Área FAI - 3º Turno
                var data10 = new google.visualization.DataTable();
                data10.addColumn('string', 'Data');
                data10.addColumn('number', 'Total de Registros');
                data10.addColumn({type: 'string', role: 'style'});

                <cfoutput query="3turnofai">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data10.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options10 = {
                    title: 'Realizado FAI (3º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart10 = new google.visualization.ColumnChart(document.getElementById('chart_div10'));
                chart10.draw(data10, options10);

                // Gráfico 11: Área SMALL - 1º Turno
                var data11 = new google.visualization.DataTable();
                data11.addColumn('string', 'Data');
                data11.addColumn('number', 'Total de Registros');
                data11.addColumn({type: 'string', role: 'style'});

                <cfoutput query="1turnosmall">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data11.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options11 = {
                    title: 'Realizado SMALL (1º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart11 = new google.visualization.ColumnChart(document.getElementById('chart_div11'));
                chart11.draw(data11, options11);

                // Gráfico 12: Área SMALL - 2º Turno
                var data12 = new google.visualization.DataTable();
                data12.addColumn('string', 'Data');
                data12.addColumn('number', 'Total de Registros');
                data12.addColumn({type: 'string', role: 'style'});

                <cfoutput query="2turnosmall">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data12.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options12 = {
                    title: 'Realizado SMALL (2º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart12 = new google.visualization.ColumnChart(document.getElementById('chart_div12'));
                chart12.draw(data12, options12);

                // Gráfico 13: Área SMALL - 3º Turno
                var data13 = new google.visualization.DataTable();
                data13.addColumn('string', 'Data');
                data13.addColumn('number', 'Total de Registros');
                data13.addColumn({type: 'string', role: 'style'});

                <cfoutput query="3turnosmall">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data13.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options13 = {
                    title: 'Realizado SMALL (3º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart14 = new google.visualization.ColumnChart(document.getElementById('chart_div14'));
                chart14.draw(data14, options14);
                // Gráfico 14: Área BODY - 1º Turno
                var data14 = new google.visualization.DataTable();
                data14.addColumn('string', 'Data');
                data14.addColumn('number', 'Total de Registros');
                data14.addColumn({type: 'string', role: 'style'});

                <cfoutput query="1turnobody">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data14.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options14 = {
                    title: 'Realizado BODY (1º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart14 = new google.visualization.ColumnChart(document.getElementById('chart_div14'));
                chart14.draw(data14, options14);



                
                var chart15 = new google.visualization.ColumnChart(document.getElementById('chart_div15'));
                chart15.draw(data15, options15);
                // Gráfico 15: Área BODY - 1º Turno
                var data15 = new google.visualization.DataTable();
                data15.addColumn('string', 'Data');
                data15.addColumn('number', 'Total de Registros');
                data15.addColumn({type: 'string', role: 'style'});

                <cfoutput query="2turnobody">
                    var color = #TOTAL_AREA# == 2 ? 'color: green;' : 'color: red;';
                    data15.addRow([ '#DIA#', #TOTAL_AREA#, color ]);
                </cfoutput>

                var options15 = {
                    title: 'Realizado BODY (2º Turno)',
                    hAxis: {title: 'Data', titleTextStyle: {color: '#333'}},
                    vAxis: {minValue: 0, title: 'Total de Registros'},
                    chartArea: {width: '70%', height: '75%'},
                    legend: {position: 'none'}
                };

                var chart15 = new google.visualization.ColumnChart(document.getElementById('chart_div15'));
                chart15.draw(data15, options15);
            }
        </script>
        <style>
            .carousel-container {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .carousel {
                display: flex;
                width: 100%;
                overflow: hidden;
                position: relative;
                margin-bottom: 20px; /* Espaçamento entre os carrosséis */
            }

            .carousel > div {
                flex: 0 0 100%;
                transition: transform 0.5s ease;
            }

            .carousel .prev, .carousel .next {
                cursor: pointer;
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background-color: rgba(0, 0, 0, 0.5);
                color: white;
                padding: 10px;
                border: none;
                outline: none;
                z-index: 1;
            }

            .carousel .prev {
                left: 10px;
            }

            .carousel .next {
                right: 10px;
            }

        </style>
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div14" style="width: 100%; height: 300px; margin-top: 100px;"></div>
                <div id="chart_div15" style="width: 100%; height: 300px; margin-top: 100px;"></div>
                <div id="chart_div1" style="width: 100%; height: 300px; margin-top: 100px;"></div>
            
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        
            <div class="carousel">
                <div id="chart_div2" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                <div id="chart_div3" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                <div id="chart_div4" style="width: 100%; height: 300px; margin-top: 60px;"></div>
            
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
    
            <div class="carousel">
                <div id="chart_div5" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                <div id="chart_div6" style="width: 100%; height: 300px; margin-top: 20px;"></div>
                <div id="chart_div7" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
            <div class="carousel">
                <div id="chart_div8" style="width: 100%; height: 300px; margin-top: 20px;"></div>
                <div id="chart_div9" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                <div id="chart_div10" style="width: 100%; height: 300px; margin-top: 20px;"></div>
                
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
            <div class="carousel">
                <div id="chart_div11" style="width: 100%; height: 300px; margin-top: 60px;"></div>
                <div id="chart_div12" style="width: 100%; height: 300px; margin-top: 20px;"></div>
                <div id="chart_div13" style="width: 100%; height: 300px; margin-top: 60px;"></div>

                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                function createCarousel(selector) {
                    let index = 0;
                    const slides = document.querySelectorAll(selector + ' > div');
                    const totalSlides = slides.length;
                    
                    function showSlide(n) {
                        index = (n + totalSlides) % totalSlides;
                        slides.forEach((slide, i) => {
                            slide.style.transform = `translateX(${-index * 100}%)`;
                        });
                    }
                    
                    document.querySelector(selector + ' .prev').addEventListener('click', () => showSlide(index - 1));
                    document.querySelector(selector + ' .next').addEventListener('click', () => showSlide(index + 1));
                    
                    showSlide(index);
                }
                
                createCarousel('.carousel:nth-of-type(1)');
                createCarousel('.carousel:nth-of-type(2)');
                createCarousel('.carousel:nth-of-type(3)');
                createCarousel('.carousel:nth-of-type(4)');
                createCarousel('.carousel:nth-of-type(5)');
            });
        </script>
    </body>
</html>
