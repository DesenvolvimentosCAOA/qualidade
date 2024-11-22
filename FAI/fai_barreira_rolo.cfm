<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "R">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fai_selecionar_reparo.cfm'
    </script>
</cfif>

    <!---  Consulta  --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_fai
        WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
        AND BARREIRA = 'TESTE DE ROLO'
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        ORDER BY ID DESC
    </cfquery>

    <!--- Verifica se o formulário foi enviado --->
<cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema") and structKeyExists(form, "criticidade")>

    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
    </cfquery>
    
</cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FAI WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'fai_barreira_rolo.cfm';
        </script>
    </cfif>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
        <title>Teste de Rolo</title>
        <script>
            function validarFormulario(event) {
                var peça = document.getElementById('formNConformidade').value;
                var criticidade = document.getElementById('formCriticidade').value;
                var posição = document.getElementById('formPosicao').value;
                var responsável = document.getElementById('formEstacao').value;
                var problema = document.getElementById('formProblema').value;
    
                if (peça) {
                    if (!posição) {
                        alert('Por favor, selecione uma posição.');
                        event.preventDefault(); // Impede o envio do formulário
                        return false;
                    }
    
                    if (!problema) {
                        alert('Por favor, selecione uma problema.');
                        event.preventDefault(); // Impede o envio do formulário
                        return false;
                    }
    
                    if (!responsável) {
                        alert('Por favor, selecione um responsável.');
                        event.preventDefault(); // Impede o envio do formulário
                        return false;
                    }
    
                    if (!criticidade) {
                        alert('Por favor, selecione um criticidade.');
                        event.preventDefault(); // Impede o envio do formulário
                        return false;
                    }
                }
                return true;
            }
        </script>
        <script>
            function validarFormularioTesteDeRolo(event) {
                event.preventDefault();
            
                var vin = document.getElementById('formVIN').value;
                var problemaForm = document.getElementById('formProblema').value;
            
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'verificar_vin.cfm', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        var response = xhr.responseText.trim();
                        if (response === 'EXISTE_COM_CONDICAO') {
                            alert('O VIN já existe na tabela com PROBLEMA vazio. Não é possível prosseguir com PROBLEMA preenchido.');
                        } else if (response === 'PROBLEMA_EXISTE_FORM_NULO') {
                            alert('O VIN já existe na tabela com um problema registrado. O campo PROBLEMA no formulário não pode estar vazio.');
                        } else if (response === 'EXISTE') {
                            alert('O VIN já existe na tabela. Por favor, verifique os dados.');
                        } else if (response === 'PERMITIR_ENVIO') {
                            document.getElementById('form_envio').submit();
                        } else {
                            document.getElementById('form_envio').submit();
                        }
                    }
                };
                xhr.send('vin=' + vin + '&problema=' + problemaForm + '&barreira=TESTE DE ROLO');
            }
            </script>
            
            
            
            
        <!-- Bootstrap CSS -->
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/style_barreiras.css?v1">
        <!--- deixar as letras do campo problema em maiúsculo --->
        <script>
            function transformToUpperCase(input) {
                input.value = input.value.toUpperCase();
            }
        </script>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
    
        <div class="container mt-4">
            <h2 class="titulo2">Teste de Rolo</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'FAI-ROLO-PROBLEMA'
                ORDER BY DEFEITO
        </cfquery>

        <cfquery name="pecas" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FAI-ROLO-PEÇA'
            ORDER BY DEFEITO
        </cfquery>
            
            <form onsubmit="return validarFormularioTesteDeRolo(event)" method="post" id="form_envio">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly>
                    </div>
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                    </cfquery>
                    <cfoutput>
                    <div class="form-group col-md-2">
                        <label for="formNome">Inspetor</label>
                        <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required value="#login.USER_SIGN#" readonly>
                    </div>
                    
                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                    SELECT * FROM (
                        SELECT ID, VIN,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE_FAI ORDER BY ID DESC)
                        WHERE ROWNUM = 1 
                    </cfquery>
<!---                     <cfdump  var="#consulta1#"> --->
                    <div class="form-group col-md-2">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" name="vin" id="formVIN" minlength="16" maxlength="17"  required >
                    </div>
                   
<!--- <cfdump var="#buscaMES#"> --->
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <input type="text" class="form-control form-control-sm" name="modelo" id="formModelo" readonly>
                        <input id="modelo" name="modelo" type="hidden" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>">
                        
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formLocal">Local</label>
                        <select class="form-control form-control-sm" name="local" id="formLocal" required readonly>
                            <option value="TESTE DE ROLO">Teste de Rolo</option>
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
                        <select class="form-control form-control-sm" name="problema" id="formProblema" oninput="transformToUpperCase(this)">
                            <option id="form-control form-control-sm" value="">Selecione o Problema</option>
                            <cfloop query="defeitos">
                                <cfoutput>
                                    <option value="#defeito#">#defeito#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
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

                    <div class="form-group col-md-3">
                        <input type="hidden" name="barcode" id="barcode" value="<cfif isDefined('buscaBarcode.BARCODE')>#buscaBarcode.BARCODE#<cfelse></cfif>">
                    </div>
                </div>
                <div class="form-row"></div>
                <button type="submit" class="btn btn-primary" >Enviar</button>

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
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_FAI (
            ID, USER_DATA, USER_COLABORADOR, VIN, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, ULTIMO_REGISTRO
        ) VALUES (
            seq_id.NEXTVAL,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                ELSE SYSDATE
            END,
            <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#buscaBarcode.barcode#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#buscaMES.modelo#" cfsqltype="CF_SQL_VARCHAR">,
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
            END,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
        )
    </cfquery>
    <cfoutput><script>window.location.href = 'fai_barreira_rolo.cfm';</script></cfoutput>
                </cfif>
                <button type="reset" class="btn btn-danger">Cancelar</button>
            </form>
            
        </div>
    
        <div class="container col-12 bg-white rounded metas">
            <table class="table">
                <thead>
                    <tr class="text-nowrap" >
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
                                    <i class="material-icons delete-icon" style="color: red;">X</i>
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
                    window.location.href = "fai_barreira_rolo.cfm?id=" + id;
                }
            }
        </script>    
        <script>
            document.getElementById('formVIN').addEventListener('keypress', function(event) {
                if (event.key === 'Enter') {
                    event.preventDefault(); // Evita o comportamento padrão do Enter
        
                    // Se você deseja mover para o próximo campo, descomente a linha abaixo
                    // document.getElementById('proximoCampoID').focus();
        
                    // Se você deseja permanecer no mesmo campo, apenas deixe sem ações adicionais
                }
            });
        </script>
    </body>
</html>
    
        