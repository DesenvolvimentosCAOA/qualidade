<cfinvoke method="inicializando" component="cf.ini.index">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0">
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "R">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_reparo.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_indicadores_1.cfm'
    </script>
</cfif>

<!---  Consulta  --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
    WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
    AND BARREIRA = 'LIBERACAO'
    <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
        AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')</cfif>
    ORDER BY ID DESC
</cfquery>


<!--- Verifica se o formulário foi enviado --->
<cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>

    <!--- Passo 1: Consulta para verificar se o VIN existe na tabela sistema_qualidade --->
<cfquery name="consultaVIN" datasource="#BANCOSINC#">
    SELECT STATUS_BLOQUEIO 
    FROM sistema_qualidade 
    WHERE VIN = <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">
</cfquery>

<!--- Passo 2: Verificar o STATUS_BLOQUEIO em todas as linhas retornadas --->
<cfset bloqueado = false>
<cfloop query="consultaVIN">
    <cfif consultaVIN.STATUS_BLOQUEIO EQ "BLOQUEADO">
        <cfset bloqueado = true>
        <cfbreak> <!--- Para de verificar após encontrar um bloqueio --->
    </cfif>
</cfloop>

<!--- Se bloqueado for true, exibir uma mensagem em JavaScript e impedir o envio do formulário --->
<cfif bloqueado>
    <script>
        // Cria e exibe o modal
        document.addEventListener("DOMContentLoaded", function() {
            var modalHtml = `
                <div id="blockModal" style="display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5);">
                    <div style="background: white; padding: 20px; border-radius: 5px; text-align: center;">
                        <p>O veículo está bloqueado, separe o veículo e acione o responsável!</p>
                        <button onclick="window.location.href='./4fai_selecionar_desbloqueio.cfm'">Me leve a Página</button>
                        <button onclick="window.history.back()">Cancelar</button>
                    </div>
                </div>
            `;
            document.body.insertAdjacentHTML('beforeend', modalHtml);
        });
    </script>
    <cfabort>
</cfif>
<!--- Se o código chegou até aqui, significa que o VIN não está bloqueado. O formulário pode ser enviado. --->

    
    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
    </cfquery>

</cfif>

<!--- Deletar Item --->
<cfif structKeyExists(url, "id") and url.id neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
    <script>
        self.location = 'fa_barreira_cp7_liberacao.cfm';
    </script>
</cfif>

<html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
            <meta
                name="viewport"
                content="width=device-width, initial-scale=1, shrink-to-fit=no">

                <title>Liberação</title>
                <link rel="icon" href="./assets/chery.png" type="image/x-icon">
                    <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
                        <!--- deixar as letras do campo problema em maiúsculo --->
                        <script>
                            function transformToUpperCase(input) {
                                input.value = input
                                    .value
                                    .toUpperCase();
                            }
                        </script>
                        <script>
                            function validarFormulario(event) {
                                // Validação geral dos campos
                                var peça = document.getElementById('formNConformidade').value;
                                var criticidade = document.getElementById('formCriticidade').value;
                                var posição = document.getElementById('formPosicao').value;
                                var responsável = document.getElementById('formEstacao').value;
                                var problema = document.getElementById('formProblema').value;
                                var vin = document.getElementById('formVIN').value;
                            
                                if (peça) {
                                    if (!posição) {
                                        alert('Por favor, selecione uma posição.');
                                        event.preventDefault(); // Impede o envio do formulário
                                        return false;
                                    }
                            
                                    if (!problema) {
                                        alert('Por favor, selecione um problema.');
                                        event.preventDefault(); // Impede o envio do formulário
                                        return false;
                                    }
                            
                                    if (!responsável) {
                                        alert('Por favor, selecione um responsável.');
                                        event.preventDefault(); // Impede o envio do formulário
                                        return false;
                                    }
                            
                                    if (!criticidade) {
                                        alert('Por favor, selecione uma criticidade.');
                                        event.preventDefault(); // Impede o envio do formulário
                                        return false;
                                    }
                                }
                            
                                // Validação do VIN com requisição AJAX
                                var xhr = new XMLHttpRequest();
                                xhr.open('POST', 'verificar_vin.cfm', true);
                                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                                xhr.onreadystatechange = function () {
                                    if (xhr.readyState === 4 && xhr.status === 200) {
                                        var response = xhr.responseText.trim();
                                        if (response === 'EXISTE_COM_CONDICAO') {
                                            alert('O VIN já existe na tabela com PROBLEMA vazio. Não é possível prosseguir com PROBLEMA preenchido.');
                                            event.preventDefault(); // Impede o envio do formulário
                                        } else if (response === 'PROBLEMA_EXISTE_FORM_NULO') {
                                            alert('O VIN já existe na tabela com um problema registrado. O campo PROBLEMA no formulário não pode estar vazio.');
                                            event.preventDefault(); // Impede o envio do formulário
                                        } else if (response === 'EXISTE') {
                                            alert('O VIN já existe na tabela. Por favor, verifique os dados.');
                                            event.preventDefault(); // Impede o envio do formulário
                                        } else if (response === 'PERMITIR_ENVIO') {
                                            // Permite o envio do formulário
                                            document.getElementById('form_envio').submit();
                                        } else {
                                            document.getElementById('form_envio').submit();
                                        }
                                    }
                                };
                                xhr.send('vin=' + vin + '&problema=' + problema + '&barreira=LIBERACAO');
                            
                                // Impede o envio até a resposta da requisição AJAX
                                event.preventDefault();
                            }
                            </script>
                            
                    </head>
                    <body>
                        <!-- Header com as imagens e o menu -->
                        <header class="titulo">
                            <cfinclude template="auxi/nav_links.cfm">
                        </header>

                        <div class="container mt-4">
                            <h2 class="titulo2">LIBERAÇÃO</h2><br>

                                <cfquery name="pecas" datasource="#BANCOSINC#">
                                    SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                                    WHERE SHOP = 'FA'
                                    ORDER BY DEFEITO
                                </cfquery>

                                <form onsubmit="return validarFormulario(event);" method="post" id="form_envio">
                                    <div class="form-row">
                                        <div class="form-group col-md-2">
                                            <label for="formData">Data</label>
                                            <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>"readonly="readonly"></div>
                                            <cfquery name="login" datasource="#BANCOSINC#">
                                                SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                                                WHERE USER_NAME = '#cookie.user_apontamento_fa#'
                                            </cfquery>
                                            <cfoutput>
                                                <div class="form-group col-md-2">
                                                    <label for="formNome">Inspetor</label>
                                                    <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required="required" value="#login.USER_SIGN#" readonly="readonly"></div>
                                                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                                                        SELECT * FROM (
                                                        SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_FA ORDER BY ID DESC)
                                                        WHERE ROWNUM = 1
                                                    </cfquery>
                                                    <!---                     <cfdump  var="#consulta1#"> --->
                                                    <div class="form-group col-md-2">
                                                        <label for="formVIN">VIN</label>
                                                        <input type="text" class="form-control form-control-sm" minlength="17" name="vin" id="formVIN" title="Insira o VIN Completo" required="required">
                                                    </div>

                                                        <!--- <cfdump var="#buscaMES#"> --->
                                                        <div class="form-group col-md-2">
                                                            <label for="formModelo">Modelo</label>
                                                            <input type="text" class="form-control form-control-sm" maxlength="17" name="modelo" id="formModelo" readonly="readonly">
                                                                <input id="modelo" name="modelo" type="hidden"
                                                                    value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>"></div>
                                                                <div class="form-group col-md-2">
                                                                    <label for="formLocal">Local</label>
                                                                    <select
                                                                        class="form-control form-control-sm"
                                                                        name="local"
                                                                        id="formLocal"
                                                                        required="required"
                                                                        readonly="readonly">
                                                                        <option value="LIBERACAO">LIBERACAO</option>
                                                                    </select>
                                                                </cfoutput>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="form-group col-md-2">
                                                                <label for="formNConformidade">Peça</label>
                                                                <input class="form-control form-control-sm" list="pecasList" name="N_Conformidade" id="formNConformidade" placeholder="Selecione a Peça">
                                                                <datalist id="pecasList">
                                                                    <option value="">Selecione a Peça</option>
                                                                    <cfloop query="pecas">
                                                                        <cfoutput>
                                                                            <option value="#defeito#">#defeito#</option>
                                                                        </cfoutput>
                                                                    </cfloop>
                                                                </datalist>
                                                            </div>
                                                            
                                                            <div class="form-group col-md-2">
                                                                <label for="formPosicao">
                                                                    Posição</label>
                                                                <select class="form-control form-control-sm" name="posicao" id="formPosicao">
                                                                    <cfinclude template="auxi/batalha_option.cfm">
                                                                </select>
                                                            </div>
                                                            <div class="form-group col-md-2">
                                                                <label for="formProblema">Problema</label>
                                                                <input class="form-control form-control-sm" list="problemasList" name="problema" id="formProblema" oninput="transformToUpperCase(this)">
                                                                <datalist id="problemasList">
                                                                    <cfinclude template="auxi/problemas_option.cfm">
                                                                </datalist>
                                                            </div>
                                                            
                                                            <div class="form-group col-md-2">
                                                                <label for="formEstacao">Responsável</label>
                                                                <select class="form-control form-control-sm" name="estacao" id="formEstacao" style="width: 200px;">
                                                                    <option value="">
                                                                        Selecione o Responsável:</option>
                                                                    <cfinclude template="auxi/estacao.cfm">
                                                                </select>
                                                            </div>
                                                            <div class="form-group col-md-2">
                                                                <label for="formCriticidade">Criticidade</label>
                                                                <select class="form-control form-control-sm" name="criticidade" id="formCriticidade">
                                                                    <option value="">Selecione</option>
                                                                    <option value="N0">N0</option>
                                                                    <option value="N1">N1</option>
                                                                    <option value="N2">N2</option>
                                                                    <option value="N3">N3</option>
                                                                    <option value="N4">N4</option>
                                                                    <option value="OK A-">OK A-</option>
                                                                    <option value="AVARIA">AVARIA</option>
                                                                </select>
                                                            </div>
                                                            <div class="form-group col-md-3">
                                                                <input type="hidden" name="barcode" id="barcode" value="<cfif isDefined('buscaBarcode.BARCODE')>#buscaBarcode.BARCODE#<cfelse></cfif>">
                                                            </div>
                                                        </div>
                                                        <div class="form-row"></div>
                                                        <button type="submit" class="btn btn-primary">Enviar</button>

                                                            <!----acrescenta o modelo no banco de dados ---->
                                                        <cfif isDefined("form.VIN") and form.VIN neq "">
                                                            <cfquery name="buscaMES" datasource="#BANCOMES#">
                                                                select
                                                                rtrim(ltrim(replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(replace(p.name,'CONJUNTO',''),'TRIM',''),
                                                                ' FL',''),
                                                                'BRANCO',''),
                                                                'PEROLA',''),
                                                                'PRATA',''),
                                                                'AZUL',''),
                                                                'PRETO',''),
                                                                'CINZA',''),
                                                                'TXS','PL7'),
                                                                'ESCURO',''),
                                                                'NOVO MOTOR',''),
                                                                'CINZA',''))) modelo,
                                                                p.name, g.vin, g.IDProduct, g.*
                                                                from CTBLGravacao g
                                                                left join TBLProduct p on g.IDProduct = p.IDProduct
                                                                where vin = UPPER('#form.VIN#')
                                                                order by g.DtCreation desc
                                                            </cfquery>

                                                            <!----acrescenta o barcode no banco de dados ---->
                                                            <cfif isDefined("form.VIN") and form.VIN neq "">
                                                                <cfquery name="buscaBarcode" datasource="#BANCOMES#">
                                                                    select 
                                                                        l.code as BARCODE,
                                                                        g.VIN,
                                                                        p.name,
                                                                        g.IDProduct,
                                                                        l.IDLot,
                                                                        g.IDLot
                                                                    from CTBLGravacao g
                                                                    left join TBLLot l on g.IDLot = l.IDLot
                                                                    left join TBLProduct p on g.IDProduct = p.IDProduct
                                                                    where g.VIN = UPPER('#form.VIN#')
                                                                    order by g.DtCreation desc
                                                                </cfquery>
                                                            </cfif>

                                                            <!--- Inserir item --->
                                                            <!-- Verifica se o VIN existe na BARREIRA 'LIBERACAO' -->
<cfquery name="verificaIntervalo" datasource="#BANCOSINC#">
    SELECT INTERVALO
    FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
    WHERE VIN = <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
      AND BARREIRA = 'LIBERACAO'
</cfquery>

<!-- Define o valor do intervalo antes da inserção -->
<cfset intervaloInserir = "" />

<cfif verificaIntervalo.recordCount gt 0>
    <!-- Se o VIN existe na BARREIRA 'LIBERACAO', usa o intervalo existente -->
    <cfset intervaloInserir = verificaIntervalo.INTERVALO>
<cfelse>
    <!-- Caso contrário, define um novo INTERVALO -->
    <cfset currentTime = TimeFormat(Now(), "HH:mm")> <!-- Formata a hora atual -->

    <cfif currentTime gte '15:00' AND currentTime lt '15:50'>
        <cfset intervaloInserir = '15:00'>
    <cfelseif currentTime gte '15:50' AND currentTime lt '16:00'>
        <cfset intervaloInserir = '15:50'>
    <cfelse>
        <cfset intervaloInserir = DateFormat(Now(), "HH") & ':00'>
    </cfif>
</cfif>

<!-- Inserção com o intervalo correto -->
<cfquery name="insere" datasource="#BANCOSINC#">
    INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_FA (
        ID, USER_DATA, USER_COLABORADOR, VIN, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, STATUS
    ) VALUES (
        <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
        SYSDATE,
        <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#buscaBarcode.barcode#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#buscaMES.modelo#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">,
        <cfqueryparam value="#intervaloInserir#" cfsqltype="CF_SQL_VARCHAR">,
        CASE
            WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'N0' THEN 'LIBERADO'
            WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> = 'AVARIA' THEN 'LIBERADO'
            WHEN <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR"> IN ('N1', 'N2', 'N3', 'N4', 'OK A-') THEN 'EM REPARO'
            ELSE 'LIBERADO'
        END
    )
</cfquery>

                                                            
                                                            <cfoutput>
                                                                <script>
                                                                    window.location.href = 'fa_barreira_cp7_liberacao.cfm';
                                                                </script>
                                                            </cfoutput>
                                                        </cfif>
                                                        <button type="reset" class="btn btn-danger">
                                                            Cancelar</button>
                                                    </form>

                                                </div>

                                                <div class="container col-12 bg-white rounded metas">
                                                    <table class="table">
                                                        <thead>
                                                            <tr class="text-nowrap">
                                                                <!-- Coluna de ação -->
                                                                <th scope="col">Del</th>
                                                                <th scope="col">ID</th>
                                                                <th scope="col">Data</th>
                                                                <th scope="col">Colaborador</th>
                                                                <th scope="col">VIN</th>
                                                                <th scope="col">BARCODE</th>
                                                                <th scope="col">Modelo</th>
                                                                <th scope="col">Barreira</th>
                                                                <th scope="col">Peça</th>
                                                                <th scope="col">Posição</th>
                                                                <th scope="col">Problema</th>
                                                                <th scope="col">Responsável</th>
                                                                <th scope="col">Criticidade</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="table-group-divider">
                                                            <cfoutput query="consulta">
                                                                <tr class="align-middle">
                                                                    <!-- Botão de exclusão -->
                                                                    <td>
                                                                        <span class="delete-icon-wrapper" onclick="deletar(#ID#);">
                                                                            <i class="material-icons delete-icon" style="color: red;">
                                                                                X</i>
                                                                        </span>
                                                                    </td>
                                                                    <td>#ID#</td>
                                                                    <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                                    <td>#USER_COLABORADOR#</td>
                                                                    <td>#VIN#</td>
                                                                    <td>#BARCODE#</td>
                                                                    <td>#MODELO#</td>
                                                                    <td>#BARREIRA#</td>
                                                                    <td>#PECA#</td>
                                                                    <td>#POSICAO#</td>
                                                                    <td>#PROBLEMA#</td>
                                                                    <td>#ESTACAO#</td>
                                                                    <td>#CRITICIDADE#</td>
                                                                </tr>
                                                            </cfoutput>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <!-- Script para deletar -->
                                                <script>
                                                    function deletar(id) {
                                                        if (confirm("Tem certeza que deseja deletar este item?")) {
                                                            window.location.href = "fa_barreira_cp7_liberacao.cfm?id=" + id;
                                                        }
                                                    }
                                                </script>
                                                <script>
                                                    document
                                                        .getElementById('formVIN')
                                                        .addEventListener('keypress', function (event) {
                                                            if (event.key === 'Enter') {
                                                                event.preventDefault(); // Evita o comportamento padrão do Enter

                                                                // Se você deseja mover para o próximo campo, descomente a linha abaixo
                                                                // document.getElementById('proximoCampoID').focus(); Se você deseja permanecer
                                                                // no mesmo campo, apenas deixe sem ações adicionais
                                                            }
                                                        });
                                                </script>
                                            </body>
                                        </html>