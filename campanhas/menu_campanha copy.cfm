<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">


<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <title>Registro de Campanha</title>
    <style>
        /* Estilo básico para o corpo da página */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Estilo da tabela */
        table {
            width: 100%;
            max-width: 1200px;
            border-collapse: collapse;
            margin-top: 20px;
        }

        /* Estilo das células da tabela */
        th, td {
            border: 1px solid #000;
            padding: 8px;
            text-align: center;
            background-color: #D3D3D3;
        }

        /* Estilo do título */
        th {
            font-weight: bold;
            background-color: #D3D3D3;
        }

        /* Estilo do cabeçalho central */
        .header {
            text-align: center;
            font-size: 1.5em;
            font-weight: bold;
        }

        /* Estilo das células de texto e links */
        td input[type="text"], td input[type="date"] {
            width: 100%;
            padding: 5px;
            box-sizing: border-box;
            border: none;
            background-color: #fff;
        }

        /* Responsividade */
        @media (max-width: 768px) {
            .header {
                font-size: 1.2em;
            }
        }
    </style>
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br>
        <h1>Registro de Campanha</h1>
        <table>
            <tr>
                <th colspan="7" class="header">&lt;QA&gt; Registro de Campanha</th>
            </tr>
            <tr>
                <th>Solicitante</th>
                <th>Departamento</th>
                <th>Shop</th>
                <th>Data dd/mm/aa</th>
                <th>N° Campanha</th>
            </tr>
            <tr>
                <td><input type="text" placeholder="Solicitante"></td>
                <td><input type="text" placeholder="Departamento"></td>
                <td><input type="text" placeholder="Shop"></td>
                <td><input type="date"></td>
                <td><input type="text" placeholder="N° Campanha"></td>
            </tr>
            <tr>
                <th>Modelo</th>
                <th>Sistema</th>
                <th>N° Peça (s)</th>
                <th>Barcode/VIN Início</th>
                <th>Barcode/VIN Fim</th>
            </tr>
            <tr>
                <td><input type="text" placeholder="Modelo"></td>
                <td><input type="text" placeholder="Sistema"></td>
                <td><input type="text" placeholder="N° Peça (s)"></td>
                <td><input type="text" placeholder="Barcode/VIN Início"></td>
                <td><input type="text" placeholder="Barcode/VIN Fim"></td>
            </tr>
            <tr>
                <th colspan="3">Problema</th>
                <th colspan="2">Anexos</th>
            </tr>
            <tr>
                <td colspan="3"><input type="text" placeholder="Descrição do Problema"></td>
                <td colspan="2"><input type="text" placeholder="Verificação/Evidência"></td>
            </tr>
            <tr>
                <th colspan="3">Participantes</th>
                <th colspan="2">Detalhamento</th>
            </tr>
            <tr>
                <td>Data</td>
                <td>Nome</td>
                <td>Função</td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
            <tr>
                <td colspan="1"><input type="date" placeholder="Data"></td>
                <td colspan="1"><input type="text" placeholder="Nome"></td>
                <td colspan="1"><input type="text" placeholder="Função"></td>
            </tr>
        </table>
    </body>
    </html>