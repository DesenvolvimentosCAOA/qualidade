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
        <link rel="stylesheet" href="assets/registro.css?v2">
        <title>Registro de Campanha</title>

    </head>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br><br>
    <body>
        <table>
            <tr>
                <th colspan="5" class="header">&lt;QA&gt; Registro de Campanha</th>
            </tr>
            <tr> 
                <th>Solicitante</th>
                <th>Departamento</th>
                <th>shop</th>
                <th>Data</th>
                <th>Nº Campanha</th>
            </tr>
            <tr>
                <td><input type="text" class="selecao" placeholder="Solicitante"></td>
                <td>
                    <select class="selecao">
                        <option value="" disabled selected>Selecione</option>
                        <option value="PAINT">PAINT</option>
                        <option value="BODY">BODY</option>
                        <option value="SMALL">SMALL</option>
                        <option value="TRIM">TRIM</option>
                        <option value="FAI">FAI</option>
                        <option value="PDI">PDI</option>
                        <option value="SQE">SQE</option>
                        <option value="QUALIDADE">QUALIDADE</option>
                    </select>
                </td>
                <td>
                    <select class="selecao">
                        <option value="" disabled selected>Selecione</option>
                        <option value="PAINT">PAINT</option>
                        <option value="BODY">BODY</option>
                        <option value="SMALL">SMALL</option>
                        <option value="TRIM">TRIM</option>
                        <option value="FAI">FAI</option>
                        <option value="PDI">PDI</option>
                    </select>
                </td>
                <td><input type="date" class="selecao" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly> </td>
                <td><input type="text" class="selecao"></td>
            </tr>
            <tr>
                <th>Modelo</th>
                <th>Sistema</th>
                <th>Nº Peça (s)</th>
                <th>Barcode/VIN Início</th>
                <th>Barcode/VIN Fim</th>
            </tr>
            <tr>
                <td>
                    <select class="selecao">
                        <option value="" disabled selected>Selecione</option>
                        <option value="T1A">T1A</option>
                        <option value="T1E">T1E</option>
                        <option value="T19">T19</option>
                        <option value="T18">T18</option>
                        <option value="HR">HR</option>
                        <option value="TL">TL</option>
                    </select>
                </td>
                <td><input type="text" class="selecao"></td>
                <td><input type="text" class="selecao"></td>
                <td><input type="text" class="selecao"></td>
                <td><input type="text" class="selecao"></td>
            </tr>
        </table>
    </body>
</html>