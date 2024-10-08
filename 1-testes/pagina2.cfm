<cfquery name="contaVINporColaborador" datasource="#BANCOSINC#">
    SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE BARREIRA = 'ROAD TEST'
    AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
    AND (
        -- Segunda a Quinta-feira: turno inicia às 06:00 e termina às 15:48 do dia seguinte
        ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
        -- Sexta-feira: turno inicia às 06:00 e termina às 14:48
        OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '14:48:00'))
        -- Sábado: turno inicia às 06:00 e termina às 15:48
        OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:00:00' AND '15:48:00'))
    )
    GROUP BY USER_COLABORADOR, INTERVALO
    ORDER BY INTERVALO
</cfquery>
<!--- Definindo um valor padrão para url.filtroData caso não esteja definido --->
<cfparam name="url.filtroData" default="#DateFormat(Now(), 'yyyy-mm-dd')# 15:00:00">

<cfquery name="contaVINporColaborador2" datasource="#BANCOSINC#">
    SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE BARREIRA = 'ROAD TEST'
    AND (
        CASE 
            WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:00' AND TO_CHAR(USER_DATA, 'HH24:MI') < '15:50' THEN '15:00' 
            WHEN TO_CHAR(USER_DATA, 'HH24:MI') >= '15:50' AND TO_CHAR(USER_DATA, 'HH24:MI') < '16:00' THEN '15:50' 
            ELSE TO_CHAR(USER_DATA, 'HH24') || ':00' 
        END IN ('15:50', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '00:00')
    )
    AND (
        CASE 
            WHEN TO_CHAR(USER_DATA, 'HH24:MI') <= '01:02' THEN TRUNC(USER_DATA - 1) 
            ELSE TRUNC(USER_DATA) 
        END = TRUNC(SYSDATE)
    )
    GROUP BY USER_COLABORADOR, INTERVALO
    ORDER BY USER_COLABORADOR, INTERVALO
</cfquery>


<cfquery name="contaVINporColaborador3" datasource="#BANCOSINC#">
    SELECT USER_COLABORADOR, INTERVALO, COUNT(DISTINCT VIN) AS total_vin_distintos
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE BARREIRA = 'ROAD TEST'
    AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
    AND (
                -- Segunda a Quinta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sexta-feira: turno inicia às 01:02 e termina às 06:10 do mesmo dia
                OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '01:02:00' AND '06:10:00'))
                -- Sábado: turno inicia na sexta-feira às 23:00 e termina no sábado às 04:25
                OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '23:00:00' AND '23:59:59') OR
                    (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '00:00:00' AND '04:25:00')
                ))
            )
    GROUP BY USER_COLABORADOR, INTERVALO
    ORDER BY INTERVALO
</cfquery>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acompanhamento</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Estilos personalizados para a tabela */
        .small-table {
            width: 50%; /* Ajuste o valor conforme necessário para diminuir a tabela */
            margin: 0 auto; /* Centraliza a tabela */
            font-size: 14px; /* Tamanho da fonte menor */
        }
        .small-table th, .small-table td {
            padding: 8px; /* Reduz o preenchimento das células para economizar espaço */
            text-align: left;
        }
    </style>
</head>
<body>
    
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-4 table-container">
                <h2 class="mb-4 text-center">Road Test - 1º Turno</h2>
                <table class="table table-striped table-bordered small-table">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <th>Intervalo</th>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <td>#INTERVALO#</td>
                                <td>#total_vin_distintos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col-md-4 table-container">
                <h2 class="mb-4 text-center">Road Test - 2º Turno</h2>
                <table class="table table-striped table-bordered small-table">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <th>Intervalo</th>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador2">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <td>#INTERVALO#</td>
                                <td>#total_vin_distintos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>

            <div class="col-md-4 table-container">
                <h2 class="mb-4 text-center">Road Test - 3º Turno</h2>
                <table class="table table-striped table-bordered small-table">
                    <thead class="thead-dark">
                        <tr>
                            <th>Colaborador</th>
                            <th>Intervalo</th>
                            <th>TTL veíc. inspecionados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="contaVINporColaborador3">
                            <tr>
                                <td>#USER_COLABORADOR#</td>
                                <td>#INTERVALO#</td>
                                <td>#total_vin_distintos#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
