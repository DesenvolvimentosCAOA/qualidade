<cfquery name="consulta_nconformidades_cp7" datasource="#BANCOSINC#">
    WITH CONSULTA AS (
        SELECT POSICAO, COUNT(*) AS TOTAL_POR_DEFEITO
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
        WHERE TRUNC(USER_DATA) BETWEEN
            <cfif isDefined("url.filtroDataInicio") AND NOT isNull(url.filtroDataInicio) AND len(trim(url.filtroDataInicio)) gt 0>
                #CreateODBCDate(url.filtroDataInicio)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
            AND
            <cfif isDefined("url.filtroDataFim") AND NOT isNull(url.filtroDataFim) AND len(trim(url.filtroDataFim)) gt 0>
                #CreateODBCDate(url.filtroDataFim)#
            <cfelse>
                TRUNC(SYSDATE)
            </cfif>
        AND BARREIRA = 'SIGN OFF'
        AND (
            ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '15:48:00'))
            OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
            OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
        )
        GROUP BY POSICAO
    )
    SELECT POSICAO, SUM(TOTAL_POR_DEFEITO) AS TOTAL_POR_POSICAO
    FROM CONSULTA
    GROUP BY POSICAO
</cfquery>

<cfquery name="consulta_vins" datasource="#BANCOSINC#">
    SELECT POSICAO, RTRIM(XMLAGG(XMLELEMENT(e, VIN || ', ').EXTRACT('//text()') ORDER BY VIN).GETCLOBVAL(), ', ') AS VIN_LIST
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    WHERE TRUNC(USER_DATA) BETWEEN
        <cfif isDefined("url.filtroDataInicio") AND NOT isNull(url.filtroDataInicio) AND len(trim(url.filtroDataInicio)) gt 0>
            #CreateODBCDate(url.filtroDataInicio)#
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
        AND
        <cfif isDefined("url.filtroDataFim") AND NOT isNull(url.filtroDataFim) AND len(trim(url.filtroDataFim)) gt 0>
            #CreateODBCDate(url.filtroDataFim)#
        <cfelse>
            TRUNC(SYSDATE)
        </cfif>
    AND BARREIRA = 'SIGN OFF'
    AND (
        ((TO_CHAR(USER_DATA, 'D') BETWEEN '2' AND '5') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '15:48:00'))
        OR ((TO_CHAR(USER_DATA, 'D') = '6') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
        OR ((TO_CHAR(USER_DATA, 'D') = '7') AND (TO_CHAR(USER_DATA, 'HH24:MI:SS') BETWEEN '06:10:00' AND '14:48:00'))
    )
    GROUP BY POSICAO
</cfquery>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batalha Naval</title>
    
    <style>
        table {
            border-collapse: collapse;
            margin: 20px auto;
            position: relative;
            background-image: url('imagem2.png');
            background-size: 101% 101%;
            background-position: center;
            background-repeat: no-repeat;
            width: 510px;
            height: 660px;
        }

        th, td {
            width: 30px;
            height: 30px;
            text-align: center;
            border: 1px solid black;
            padding: 0;
        }

        /* Inputs agora aceitam 3 caracteres e ficam transparentes inicialmente */
        td input {
            width: 100%;
            height: 100%;
            text-align: center;
            border: none;
            box-sizing: border-box;
            padding: 0;
            margin: 0;
            background-color: rgba(255, 255, 255, 0);
            font-size: 14px;
            color: black;
        }

        /* Estilo para quando houver valor no input */
        td input.preenchido {
            background-color: rgba(28, 14, 233, 0.7); /* Vermelho transparente */
        }

        #tabela-container {
            text-align: center;
        }

        button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
        .tooltip {
        position: absolute;
        background: rgba(0, 0, 0, 0.8);
        color: #fff;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        white-space: pre-line; /* Mantém as quebras de linha */
        z-index: 1000;
        pointer-events: none; /* Garante que o mouse não interaja com o tooltip */
        white-space: pre-wrap; /* Mantém as quebras de linha */
        }
        /* Estilos para o container */
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* Estilos para o título */
        .container h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Estilos para o formulário */
        .form-inline {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Estilos para o grupo de formulário */
        .form-group {
            margin-right: 10px;
        }

        /* Estilos para o input de data */
        .form-control {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        /* Estilos para o botão */
        .btn {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .btn-warning {
            background-color: #f0ad4e;
            color: #fff;
        }

        .btn-warning:hover {
            background-color: #ec971f;
        }
    </style>

</head>
<body>
    <header class="titulo">
        <cfinclude template="/qualidade/FAI/auxi/nav_links1.cfm">
    </header><br><br><br>
    <cfoutput>
        <div class="container">
            <h2>FAI - Controle de Avarias 1º Turno</h2>
            <form method="get" action="batalha.cfm" class="form-inline">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroDataInicio" class="sr-only">Data Início:</label>
                    <input type="date" class="form-control" name="filtroDataInicio" id="filtroDataInicio" value="<cfif isDefined('url.filtroDataInicio')>#url.filtroDataInicio#</cfif>" onchange="this.form.submit();"/>
                </div>
                <div class="form-group mx-sm-3 mb-2">
                    <label for="filtroDataFim" class="sr-only">Data Fim:</label>
                    <input type="date" class="form-control" name="filtroDataFim" id="filtroDataFim" value="<cfif isDefined('url.filtroDataFim')>#url.filtroDataFim#</cfif>" onchange="this.form.submit();"/>
                </div>
                <button class="btn btn-warning mb-2 ml-2" type="reset" onclick="self.location='batalha.cfm'">Limpar</button>
            </form>
        </div>
    </cfoutput>

    <div id="tabela-container" <!---style="display: none;"---> >
        <table>
            <thead>
                <tr>
                    <th></th> <!-- Célula vazia no canto superior esquerdo -->
                    <th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th><th>H</th><th>I</th><th>J</th><th>K</th><th>L</th><th>M</th><th>N</th><th>O</th><th>P</th><th>Q</th>
                    <th></th> <!-- Coluna extra à direita -->
                </tr>
            </thead>
            <tbody>
                <!-- Adicionando as linhas com numeração à esquerda e à direita -->
                <tr>
                    <th>1</th>
                    <td><input readonly type="text" maxlength="3" id="A1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q1" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q1'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q1'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>1</th>
                  </tr>

                  <tr>
                    <th>2</th>
                    <td><input readonly type="text" maxlength="3" id="A2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q2" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q2'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q2'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>2</th>
                </tr>
                <tr>
                    <th>3</th>
                    <td><input readonly type="text" maxlength="3" id="A3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q3" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q3'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q3'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>3</th>
                </tr>
                <tr>
                    <th>4</th>
                    <td><input readonly type="text" maxlength="3" id="A4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q4" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q4'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q4'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>4</th>
                </tr>
                <tr>
                    <th>5</th>
                    <td><input readonly type="text" maxlength="3" id="A5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q5" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q5'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q5'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>5</th>
                </tr>
                <tr>
                    <th>6</th>
                    <td><input readonly type="text" maxlength="3" id="A6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q6" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q6'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q6'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>6</th>
                </tr>
                <tr>
                    <th>7</th>
                    <td><input readonly type="text" maxlength="3" id="A7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q7" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q7'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q7'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>7</th>
                </tr>
                <tr>
                    <th>8</th>
                    <td><input readonly type="text" maxlength="3" id="A8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q8" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q8'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q8'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>8</th>
                </tr>
                <tr>
                    <th>9</th>
                    <td><input readonly type="text" maxlength="3" id="A9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q9" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q9'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q9'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>9</th>
                </tr>
                <tr>
                    <th>10</th>
                    <td><input readonly type="text" maxlength="3" id="A10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q10" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q10'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q10'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>10</th>
                </tr>
                <tr>
                    <th>11</th>
                    <td><input readonly type="text" maxlength="3" id="A11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q11" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q11'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q11'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>11</th>
                </tr>
                <tr>
                    <th>12</th>
                    <td><input readonly type="text" maxlength="3" id="A12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q12" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q12'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q12'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>12</th>
                </tr>
                <tr>
                    <th>13</th>
                    <td><input readonly type="text" maxlength="3" id="A13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q13" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q13'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q13'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>13</th>
                </tr>
                <tr>
                    <th>14</th>
                    <td><input readonly type="text" maxlength="3" id="A14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q14" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q14'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q14'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>14</th>
                </tr>
                <tr>
                    <th>15</th>
                    <td><input readonly type="text" maxlength="3" id="A15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q15" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q15'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q15'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>15</th>
                </tr>
                <tr>
                    <th>16</th>
                    <td><input readonly type="text" maxlength="3" id="A16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q16" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q16'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q16'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>16</th>
                </tr>
                <tr>
                    <th>17</th>
                    <td><input readonly type="text" maxlength="3" id="A17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q17" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q17'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q17'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>17</th>
                </tr>
                <tr>
                    <th>18</th>
                    <td><input readonly type="text" maxlength="3" id="A18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q18" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q18'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q18'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>18</th>
                </tr>
                <tr>
                    <th>19</th>
                    <td><input readonly type="text" maxlength="3" id="A19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q19" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q19'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q19'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>19</th>
                </tr>
                <tr>
                    <th>20</th>
                    <td><input readonly type="text" maxlength="3" id="A20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q20" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q20'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q20'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>20</th>
                </tr>
                <tr>
                    <th>21</th>
                    <td><input readonly type="text" maxlength="3" id="A21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q21" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q21'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q21'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>21</th>
                </tr>
                <tr>
                    <th>22</th>
                    <td><input readonly type="text" maxlength="3" id="A22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'A22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'A22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="B22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'B22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'B22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="C22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'C22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'C22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="D22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'D22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'D22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="E22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'E22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'E22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="F22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'F22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'F22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="G22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'G22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'G22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="H22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'H22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'H22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="I22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'I22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'I22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="J22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'J22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'J22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="K22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'K22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'K22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="L22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'L22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'L22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="M22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'M22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'M22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="N22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'N22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'N22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="O22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'O22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'O22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="P22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'P22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'P22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <td><input readonly type="text" maxlength="3" id="Q22" value="<cfoutput query='consulta_nconformidades_cp7'><cfif POSICAO EQ 'Q22'>#TOTAL_POR_POSICAO#</cfif></cfoutput>" data-vins="<cfoutput query='consulta_vins'><cfif POSICAO EQ 'Q22'>#VIN_LIST#</cfif></cfoutput>"></td>
                    <th>22</th>
                </tr>
            </tbody>
            <thead>
                <tr>
                    <th></th> <!-- Célula vazia no canto superior esquerdo -->
                    <th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th><th>H</th><th>I</th><th>J</th><th>K</th><th>L</th><th>M</th><th>N</th><th>O</th><th>P</th><th>Q</th>
                    <th></th> <!-- Coluna extra à direita -->
                </tr>
            </thead>
        </table>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
          function checkInput(input) {
            if (input.value.trim() !== '') {
              input.style.backgroundColor = 'rgba(25, 0, 255, 0.5)'; // Vermelho transparente
            } else {
              input.style.backgroundColor = ''; // Remove o estilo se estiver vazio
            }
          }
      
          for (let row = 1; row <= 22; row++) {
            for (let col = 0; col < 17; col++) { // 17 letras de A a Q
              let colLetter = String.fromCharCode(65 + col); // Converte número para letra
              let inputId = colLetter + row;
              let input = document.getElementById(inputId);
              if (input) {
                checkInput(input); // Verifica inicialmente
                input.addEventListener('input', function() {
                  checkInput(input); // Verifica quando o valor muda
                });
              }
            }
          }
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            function createTooltip(input) {
                var vins = input.getAttribute('data-vins');
                if (vins) {
                    var vinArray = vins.split(', ');
                    var formattedVins = '';
                    for (var i = 0; i < vinArray.length; i++) {
                        if (i > 0 && i % 3 === 0) {
                            formattedVins += '\n';
                        }
                        formattedVins += vinArray[i] + (i % 3 === 2 ? '' : ', ');
                    }

                    var tooltip = document.createElement('div');
                    tooltip.className = 'tooltip';
                    tooltip.innerText = formattedVins;
                    document.body.appendChild(tooltip);

                    // Ajusta a posição correta do tooltip com deslocamento de scroll
                    var rect = input.getBoundingClientRect();
                    tooltip.style.left = rect.left + window.scrollX + 'px';
                    tooltip.style.top = rect.bottom + window.scrollY + 'px';
                }
            }

            function removeTooltip() {
                var tooltip = document.querySelector('.tooltip');
                if (tooltip) {
                    tooltip.remove();
                }
            }

            // Adiciona eventos aos inputs
            for (let row = 1; row <= 22; row++) {
                for (let col = 0; col < 17; col++) { 
                    let colLetter = String.fromCharCode(65 + col); 
                    let inputId = colLetter + row;
                    let input = document.getElementById(inputId);
                    if (input) {
                        input.addEventListener('mouseenter', function() {
                            createTooltip(input);
                        });
                        input.addEventListener('mouseleave', removeTooltip);
                    }
                }
            }
        });
    </script>

    <script>
            document.addEventListener('DOMContentLoaded', function() {
            function copyToClipboard(text) {
                var textarea = document.createElement('textarea');
                textarea.value = text;
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
            }

            // Adiciona eventos aos inputs
            for (let row = 1; row <= 22; row++) {
                for (let col = 0; col < 17; col++) { 
                    let colLetter = String.fromCharCode(65 + col); 
                    let inputId = colLetter + row;
                    let input = document.getElementById(inputId);
                    if (input) {
                        input.addEventListener('click', function() {
                            var vins = input.getAttribute('data-vins');
                            if (vins) {
                                copyToClipboard(vins);
                                alert('VINs copiados para a área de transferência!');
                            }
                        });
                    }
                }
            }
        });
    </script>

</body>
</html>
