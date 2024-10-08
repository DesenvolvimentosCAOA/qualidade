<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    
    <!--- Verificando se está logado --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_BODY") or cookie.USER_APONTAMENTO_BODY eq "">
            <script>
                alert("É necessario autenticação!!");
                self.location = 'index.cfm'
            </script>
    </cfif>
    <cfif not isDefined("cookie.USER_LEVEL_BODY") or (cookie.USER_LEVEL_BODY eq "R" or cookie.USER_LEVEL_BODY eq "P")>
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>
    <!---  Consulta  --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_body
        WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        AND BARREIRA = 'CHASSI'
        ORDER BY ID DESC
    </cfquery>

    <!--- Verifica se o formulário foi enviado --->
<cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>

    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
    </cfquery>

    <!--- Inserir item --->
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_BODY (
            ID, USER_DATA, USER_COLABORADOR, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO
        ) VALUES (
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                ELSE SYSDATE 
            END,
            <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.modelo#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
            END
        )
    </cfquery>
    <cfoutput><script>window.location.href = 'body_barreira_chassi.cfm';</script></cfoutput>
    
</cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'body_barreira_chassi.cfm';
        </script>
    </cfif>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>CHASSI</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/FAI/assets/style_barreiras.css?v1">
        <!--- deixar as letras do campo problema em maiúsculo --->
        <script>
            function transformToUpperCase(input) {
                input.value = input.value.toUpperCase();
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
    
        // Nova validação: se problema for preenchido e peça for vazio
        if (problema && !peça) {
            alert('Por favor, selecione uma peça se um problema for selecionado.');
            event.preventDefault(); // Impede o envio do formulário
            return false;
        }
    
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
    
        // Validação do BARCODE com requisição AJAX
        var barcode = vin; // Obtém o valor do input formVIN
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'verificar_barcode.cfm', true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var response = xhr.responseText.trim();
                if (response === 'EXISTE_COM_CONDICAO') {
                    alert('O BARCODE já existe na tabela com PROBLEMA vazio. Não é possível prosseguir com PROBLEMA preenchido.');
                    event.preventDefault(); // Impede o envio do formulário
                } else if (response === 'PROBLEMA_EXISTE_FORM_NULO') {
                    alert('O BARCODE já existe na tabela com um problema registrado. O campo PROBLEMA no formulário não pode estar vazio.');
                    event.preventDefault(); // Impede o envio do formulário
                } else if (response === 'EXISTE') {
                    alert('O BARCODE já existe na tabela. Por favor, verifique os dados.');
                    event.preventDefault(); // Impede o envio do formulário
                } else if (response === 'PERMITIR_ENVIO') {
                    // Permite o envio do formulário
                    document.getElementById('form_envio').submit();
                } else {
                    document.getElementById('form_envio').submit();
                }
            }
        };
    
        xhr.send('barcode=' + encodeURIComponent(barcode) + '&problema=' + encodeURIComponent(problema) + '&barreira=CHASSI');
    
        // Impede o envio até a resposta da requisição AJAX
        event.preventDefault();
    }
    </script>
    

    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br>
    
        <div class="container mt-4">
            <h2 class="titulo2">Barreira CHASSI</h2><br>

            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'BODY-PROBLEMA'
                ORDER BY DEFEITO
            </cfquery>

            <cfquery name="pecas" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'BODY-PEÇA'
                ORDER BY DEFEITO
            </cfquery>
            
            <form method="post" id="form_envio" onsubmit="validarFormulario(event);">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly>
                    </div>
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_BODY#'
                    </cfquery>
                    <cfoutput>
                    <div class="form-group col-md-2">
                        <label for="formNome">Inspetor</label>
                        <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required value="#login.USER_SIGN#" readonly>
                    </div>
                    
                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                    SELECT * FROM (
            SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_BODY ORDER BY ID DESC)
            WHERE ROWNUM = 1 
                    </cfquery>
<!---                     <cfdump  var="#consulta1#"> --->
                <div class="form-group col-md-2">
                    <label for="formVIN">BARCODE</label>
                    <input type="text" class="form-control form-control-sm" maxlength="17" name="vin" id="formVIN" required
                        oninput="this.value = this.value.replace(/\s/g, '');">
                </div>
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="modelo" id="formModelo" readonly>
                        <input id="modelo" name="modelo" type="hidden" value="CHASSI HR">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formLocal">Local</label>
                        <select class="form-control form-control-sm" name="local" id="formLocal" readonly required>
                            <option value="CHASSI">CHASSI</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formNConformidade">Peça</label>
                        <select class="form-control form-control-sm" name="N_Conformidade" id="formNConformidade">
                            <option value="">Selecione a Peça</option>
                            <cfloop query="pecas">
                                <cfoutput>
                                    <option value="#defeito#">#defeito#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formPosicao">Posição</label>
                        <select class="form-control form-control-sm" name="posicao" id="formPosicao">
                            <cfinclude template="auxi/batalha_option.cfm">
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formProblema">Problema</label>
                        <input type="text" list="defeitos-list" class="form-control form-control-sm" name="problema" id="formProblema" oninput="transformToUpperCase(this)">
                        <datalist id="defeitos-list">
                            <cfloop query="defeitos">
                                <cfoutput>
                                    <option value="#defeito#">#defeito#</option>
                                </cfoutput>
                            </cfloop>
                        </datalist>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formEstacao">Responsável</label>
                        <select class="form-control form-control-sm" name="estacao" id="formEstacao" style="width: 200px;">
                            <option value="">Selecione o Responsável:</option>
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
                        </select>
                    </div>      
                </div>
                <div class="form-row"></div>
                <button type="submit" class="btn btn-primary" >Enviar</button>
                <button type="reset" class="btn btn-danger">Cancelar</button>
            </form>
            
        </div>
    
        <div class="container col-12 bg-white rounded metas">
            <table class="table">
                <thead>
                    <tr class="text-nowrap" >
                        <!-- Coluna de ação -->
                        <th scope="col">Ação</th>
                        <th scope="col">ID</th>
                        <th scope="col">Data</th>
                        <th scope="col">Colaborador</th>
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
                                    <i style="color:red" class="material-icons delete-icon">X</i>
                                </span>
                            </td>
                            <td>#ID#</td>
                            <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                            <td>#USER_COLABORADOR#</td>
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
    
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.0/js/bootstrap.bundle.min.js"></script>
        <!-- Script para deletar -->
        <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "body_barreira_chassi.cfm?id=" + id;
                }
            }
        </script>    

        <div class="floating-arrow" onclick="scrollToTop();">
            <i class="material-icons">arrow_upward</i>
        </div>

        <!-- Script para voltar ao topo suavemente -->
        <script>
            function scrollToTop() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }
        </script>        

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const vinInput = document.getElementById('formVIN');

                vinInput.addEventListener('keydown', (event) => {
                    if (event.key === 'Enter') {
                        event.preventDefault(); // Impede a ação padrão do Enter
                        vinInput.focus(); // Mantém o foco no mesmo campo de entrada
                    }
                });
            });
        </script>

        <!---- impede de enviar o form ao final da leitura do barcode ---->
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const vinInput = document.getElementById('formVIN');

                vinInput.addEventListener('keydown', (event) => {
                    if (event.key === 'Enter') {
                        event.preventDefault(); // Impede a ação padrão do Enter
                        vinInput.focus(); // Mantém o foco no mesmo campo de entrada
                    }
                });
            });
        </script>
    </body>
</html>
    
        