    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_BODY") or cookie.USER_APONTAMENTO_BODY eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade_body
    WHERE ID = '#url.id_editar#'
    ORDER BY ID DESC
</cfquery>

<!--- Consulta --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.sistema_qualidade_body
    WHERE 1 = 1 
    <cfif cgi.QUERY_STRING does not contain "filtro">
        AND TRUNC(USER_DATA) = TRUNC(SYSDATE)
    </cfif>
    and TIPO_REPARO is null
    ORDER BY ID DESC
</cfquery>    


<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>EDITAR REPARO</title>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    <style>
        /* Estilo geral da página */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            padding: 20px;
        }

        /* Cabeçalho */
        h1 {
            color: #004085;
            font-weight: bold;
            text-transform: uppercase;
            border-bottom: 3px solid #004085;
            padding-bottom: 10px;
            text-align: center;
        }

        /* Container principal */
        .container {
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Organização dos inputs na mesma linha */
        .row {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }

        .col {
            flex: 1;
            min-width: 200px; /* Garante que os inputs não fiquem muito pequenos */
        }

        /* Estilização dos formulários */
        .form-group {
            margin-bottom: 10px;
        }

        label {
            font-weight: bold;
            color: #333;
            display: block;
            margin-bottom: 5px;
        }

        input, select {
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 8px;
            width: 100%;
            transition: 0.3s;
        }

        input:focus, select:focus {
            border-color: #004085;
            box-shadow: 0 0 5px rgba(0, 64, 133, 0.5);
        }

        /* Botões */
        .bt_ms {
            text-align: center;
            margin-top: 20px;
        }

        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-warning {
            background-color: #ffc107;
            color: #fff;
        }

        .btn-primary {
            background-color: #007bff;
            color: #fff;
        }

        button:hover {
            opacity: 0.8;
        }

        /* Rodapé */
        footer {
            margin-top: 20px;
            text-align: center;
            color: #555;
        }
        
    </style>
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

    <cfquery name="problema" datasource="#BANCOSINC#">
        SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE SHOP = 'REPARO-DEFEITO'
        ORDER BY DEFEITO
    </cfquery>

    <cfquery name="pecas" datasource="#BANCOSINC#">
        SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE SHOP = 'BODY-PEÇA'
        ORDER BY DEFEITO
    </cfquery>

    <cfquery name="realizado" datasource="#BANCOSINC#">
        SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE SHOP = 'REPARO-REALIZADO'
        ORDER BY DEFEITO
    </cfquery>

    <h1 class="text-center mt-2">Editar</h1>
    <div class="container col-10">
        <form id="for-edit" method="POST">
            <cfoutput>
                <div class="row mb-4">
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formDataReparo">Data</label>
                            <input type="text" class="form-control" name="data_reparo" id="formDataReparo" value="<cfoutput>#dateFormat(now(), 'dd/mm/yyyy HH:mm:ss')#</cfoutput>" readonly/>
                        </div>
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formVIN">Barcode</label>
                            <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.barcode#" required readonly/>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formModelo">Modelo</label>
                            <input type="text" class="form-control" name="modelo" id="formModelo" value="#consulta_editar.modelo#" required readonly/>
                        </div>
                    </div>
                    <div class="col">
                        <cfquery name="login" datasource="#BANCOSINC#">
                            SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_BODY#'
                        </cfquery>
                        <div class="form-group">
                            <label class="form-label" for="formReparador">Reparador</label>
                            <input type="text" class="form-control" name="reparador" id="formReparador" value="#login.USER_SIGN#" readonly/>
                        </div>
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formPecaReparo">Peça</label>
                            <input type="text" class="form-control" name="peca_reparo" id="formPecaReparo" list="pecasDatalist" required>
                            <datalist id="pecasDatalist">
                                <cfloop query="pecas">
                                    <cfoutput>
                                        <option value="#defeito#">#defeito#</option>
                                    </cfoutput>
                                </cfloop>
                            </datalist>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formPosicaoReparo">Posição</label>
                            <input type="text" class="form-control" name="posicao_reparo" id="formPosicaoReparo" list="posicaoDatalist" required>
                            <datalist id="posicaoDatalist">
                                <cfinclude template="auxi/batalha_option.cfm">
                            </datalist>
                        </div>
                    </div>
                    
                    <cfquery name="defeitos" datasource="#BANCOSINC#">
                        SELECT DESCRICAO FROM INTCOLDFUSION.pecas_defeitos
                        WHERE SHOP = 'BODY'
                        AND ESTACAO = 'BODY'
                        AND DEFINICAO = 'PROBLEMA'
                        ORDER BY DESCRICAO ASC
                    </cfquery>
                    <div class="form-group col-md-2">
                        <label for="formProblema">Problema</label>
                        <input type="text" list="defeitos-list" class="form-control form-control-sm" name="problema_reparo" id="formProblema" oninput="transformToUpperCase(this)">
                        <datalist id="defeitos-list">
                            <cfloop query="defeitos">
                                <cfoutput>
                                    <option value="#descricao#">#descricao#</option>
                                </cfoutput>
                            </cfloop>
                        </datalist>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formResponsavelReparo">Estação</label>
                            <select class="form-control" name="responsavel_reparo" id="formResponsavelReparo" required>
                                <option value="">Selecione a Estação</option>
                                <cfinclude template="auxi/estacao.cfm">
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formReparo">Reparo Realizado</label>
                            <input list="reparoList" class="form-control" id="formReparo" name="tipo_reparo" required>
                            <datalist id="reparoList">
                                <option value="">Selecione a Estação</option>
                                <option value="">Selecione</option>
                                <option value="LIXADO">LIXADO</option>
                                <option value="LIMADO E LIXADO">LIMADO E LIXADO</option>
                                <option value="SPOTER E LIXADO">SPOTER E LIXADO</option>
                                <option value="SPOTER, LIXADO E LIMADO">SPOTER, LIXADO E LIMADO</option>
                                <option value="SOLDA MIG E LIXADO">SOLDA MIG E LIXADO</option>
                                <option value="LIMPEZA DA ROSCA MACHO">LIMPEZA DA ROSCA (MACHO)</option>
                                <option value="SOLDA MIG">SOLDA MIG</option>
                                <option value="PREECHIMENTO DE MIG">PREECHIMENTO DE MIG</option>
                                <option value="TROCA DE PECA">TROCA DE PEÇA</option>
                                <option value="REGULADO">REGULADO</option>
                                <option value="TORQUEADO">TORQUEADO</option>
                                <option value="OBLONGADO">OBLONGADO</option>
                            </datalist>
                        </div>
                    </div>
                </div>
                
                <div class="bt_ms mb-5">
                    
                    <button type ="reset" onclick="history.back()" class="btn btn-warning">Voltar</button>
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                    <cfif isDefined("form.vin") and form.vin neq "">
                        <cfquery name="atualiza" datasource="#BANCOSINC#">
                            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
                            SET 
                                TIPO_REPARO = '#form.tipo_reparo#',
                                REPARADOR = '#form.reparador#',
                                REPARO_DATA = SYSDATE,
                                PECA_REPARO = '#form.peca_reparo#',
                                POSICAO_REPARO = '#form.posicao_reparo#',
                                PROBLEMA_REPARO = '#form.problema_reparo#',
                                RESPONSAVEL_REPARO = '#form.responsavel_reparo#',
                                STATUS = 'REPARADO',
                                INTERVALO_REPARO = CASE 
                                    WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                                    WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                                    ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
                                END
                            WHERE ID = '#url.id_editar#'
                        </cfquery>

                        <div class="alert alert-success" role="alert">
                            Atualizado com Sucesso
                        </div>
                        <meta http-equiv="refresh" content="1.5; url=body_reparo_novo.cfm">
                    </cfif>
                </div>
            </cfoutput>
        </form>
    </div>
    <footer class="text-center py-4">
        <p>&copy; 2024 Sistema de gestão da qualidade.</p>
    </footer>
    <script>
        document.getElementById('for-edit').addEventListener('submit', function(event) {
            // Função para validar o input com datalist
            function validateDatalist(inputId, datalistId) {
                const input = document.getElementById(inputId);
                const datalist = document.getElementById(datalistId);
                const options = Array.from(datalist.options).map(option => option.value);
    
                if (!options.includes(input.value)) {
                    alert(`O valor no campo "${input.previousElementSibling.textContent}" deve corresponder a uma das opções.`);
                    input.focus();
                    return false;
                }
                return true;
            }
    
            // Verificar os campos "Problema" e "Reparo Realizado"
            const isValidProblemaReparo = validateDatalist('formProblemaReparo', 'problemasDatalist');
            const isValidReparo = validateDatalist('formReparo', 'reparoList');
    
            // Cancelar envio se alguma validação falhar
            if (!isValidProblemaReparo || !isValidReparo) {
                event.preventDefault();
            }
        });
    </script>
    <script>
        document.getElementById('for-edit').addEventListener('submit', function(event) {
            function validateDatalist(inputId, datalistId) {
                const input = document.getElementById(inputId);
                const datalist = document.getElementById(datalistId);
                const options = Array.from(datalist.options).map(option => option.value);

                if (!options.includes(input.value)) {
                    alert(`O valor no campo "${input.previousElementSibling.textContent}" deve corresponder a uma das opções.`);
                    input.focus();
                    return false;
                }
                return true;
            }

            // Valida os campos "Peça", "Posição" e "Problema"
            const isValidPeca = validateDatalist('formPecaReparo', 'pecasDatalist');
            const isValidPosicao = validateDatalist('formPosicaoReparo', 'posicaoDatalist');
            const isValidProblema = validateDatalist('formProblemaReparo', 'problemasDatalist');

            // Cancelar envio se alguma validação falhar
            if (!isValidPeca || !isValidPosicao || !isValidProblema) {
                event.preventDefault();
            }
        });

    </script>
</body>
</html>
