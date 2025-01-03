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
    <cfif not isDefined("cookie.user_level_body") or (cookie.user_level_body eq "R" or cookie.user_level_body eq "P")>
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
                AND BARREIRA = 'HR'
                ORDER BY ID DESC
    </cfquery>

            <!--- Pesquisa MES --->
    <cfquery name='buscaMES' datasource="#BANCOMES#">
            select l.code, l.IDProduct, p.name, l.IDLot, g.IDLot, g.VIN,
            rtrim(ltrim(replace(
                replace(
                replace(
                replace(
                replace(
                replace(
                replace(
                replace(
                replace(
                replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
                ' FL',''),
                'COMPLETO ',''),
                'COMPLETA ',''),
                'TXS','PL7'),
                'SOLDADO',''),
                'SOLDADA',''),
                'ESCURO',''),
                'NOVO MOTOR',''),
                'CINZA',''))) modelo
            from TBLLot l
            left join CTBLGravacao g on l.IDLot = g.IDLot
        left join TBLProduct p on p.IDProduct = l.IDProduct
            where l.code = VIN
        and p.name like '%CABINE%'
    </cfquery>
 
    <!--- Verifica se o formulário foi enviado --->
 <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
 
 <!--- Passo 1: Consulta para verificar se o VIN existe na tabela sistema_qualidade_body --->
 <cfquery name="consultaVIN" datasource="#BANCOSINC#">
    SELECT STATUS_BLOQUEIO, BARREIRA_BLOQUEIO 
    FROM sistema_qualidade_body 
    WHERE BARCODE = <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">
 </cfquery>
 
 <!--- Passo 2: Verificar o STATUS_BLOQUEIO em todas as linhas retornadas --->
 <cfset bloqueado = false>
 <cfloop query="consultaVIN">
    <cfif consultaVIN.STATUS_BLOQUEIO EQ "BLOQUEADO" AND consultaVIN.BARREIRA_BLOQUEIO EQ "ECOAT">
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
                        <p>O veículo está bloqueado, separe o veículo e acione a Liderança!</p>
                        <button onclick="window.history.back()">Voltar</button>
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
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade_body
    </cfquery>
    
    <cfquery name='buscaMES2' datasource="#BANCOMES#">
        select l.code, l.IDProduct, p.name, l.IDLot, g.IDLot, g.VIN,
        rtrim(ltrim(replace(
            replace(
            replace(
            replace(
            replace(
            replace(
            replace(
            replace(
            replace(
            replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
            ' FL',''),
            'COMPLETO ',''),
            'COMPLETA ',''),
            'TXS','PL7'),
            'SOLDADO',''),
            'SOLDADA',''),
            'ESCURO',''),
            'NOVO MOTOR',''),
            'CINZA',''))) modelo
        from TBLLot l
        left join CTBLGravacao g on l.IDLot = g.IDLot
        left join TBLProduct p on p.IDProduct = l.IDProduct
        where l.code = '#form.VIN#'
        and p.name like '%CABINE%'
    </cfquery>
 
    <!--- Inserir item --->
    <cfset intervaloInserir = "" />
    <cfset userDataInserir = Now() />
    
    <!-- Verifica se o VIN existe na BARREIRA 'HR' -->
    <cfquery name="verificaIntervalo" datasource="#BANCOSINC#">
       SELECT INTERVALO
       FROM INTCOLDFUSION.sistema_qualidade_body
       WHERE BARCODE = <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
       AND BARREIRA = 'HR'
    </cfquery>
    
    <!-- Verifica se a consulta retornou resultados -->
    <cfif verificaIntervalo.recordCount gt 0>
       <!-- Se o VIN existe na BARREIRA 'HR', usa o intervalo existente -->
       <cfset intervaloInserir = verificaIntervalo.INTERVALO>
    
       <!-- Obtém a USER_DATA se o VIN existir -->
       <cfquery name="verificaUserData" datasource="#BANCOSINC#">
          SELECT USER_DATA
          FROM INTCOLDFUSION.sistema_qualidade_body
          WHERE BARCODE = <cfqueryparam value="#UCase(form.vin)#" cfsqltype="CF_SQL_VARCHAR">
          AND BARREIRA = 'HR'
       </cfquery>
    
       <!-- Verifica se a consulta retornou resultados -->
       <cfif verificaUserData.recordCount gt 0>
          <cfset userDataInserir = verificaUserData.USER_DATA>
       </cfif>
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
    
    <!-- Realiza a inserção na tabela -->
    <cfquery name="insere" datasource="#BANCOSINC#">
       INSERT INTO INTCOLDFUSION.sistema_qualidade_body (ID, USER_DATA, USER_COLABORADOR, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, ULTIMO_REGISTRO)
           VALUES (
           <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
           <cfqueryparam value="#userDataInserir#" cfsqltype="CF_SQL_TIMESTAMP">,
           <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#buscaMES2.modelo#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#form.criticidade#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#intervaloInserir#" cfsqltype="CF_SQL_VARCHAR">,
           <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
       )
    </cfquery>
    
 
    <cfoutput><script>window.location.href = 'body_barreira_hr.cfm';</script></cfoutput>
    
 </cfif>
 
    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.sistema_qualidade_body WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'body_barreira_hr.cfm';
        </script>
    </cfif>
    
    <html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>HR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/FAI/assets/style_barreiras.css?v1">
        <script>
            function validarFormulario(event) {
                // Obtenha os valores dos campos
                var peca = document.getElementById('formNConformidade').value.trim();
                var posicao = document.getElementById('formPosicao').value.trim();
                var problema = document.getElementById('formProblema').value.trim();
                var responsavel = document.getElementById('formEstacao').value.trim();
                var criticidade = document.getElementById('formCriticidade').value.trim();
        
                // Verifica se qualquer um dos campos está preenchido
                if (peca || posicao || problema || responsavel || criticidade) {
                    // Verifica se todos os campos estão preenchidos
                    if (!peca || !posicao || !problema || !responsavel || !criticidade) {
                        alert('Por favor, preencha todos os campos obrigatórios: Peça, Posição, Problema, Responsável e Criticidade.');
                        event.preventDefault(); // Impede o envio do formulário
                        return; // Sai da função
                    }
                }
        
                // Validação adicional do campo "Problema"
                if (problema) {
                    var problemaInput = document.getElementById('formProblema');
                    var datalist = document.getElementById('defeitos-list');
                    var options = datalist.options;
                    var isValid = false;
        
                    for (var i = 0; i < options.length; i++) {
                        if (options[i].value === problema) {
                            isValid = true;
                            break;
                        }
                    }
        
                    if (!isValid) {
                        alert('Por favor, selecione um problema válido da lista.');
                        event.preventDefault();
                        return; // Sai da função para não executar o restante da validação
                    }
                }
        
                // Validação do BARCODE com requisição AJAX
                var barcode = document.getElementById('formVIN').value.trim();
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
                        } else {
                            document.getElementById('form_envio').submit();
                        }
                    }
                };
                xhr.send('barcode=' + encodeURIComponent(barcode) + '&problema=' + encodeURIComponent(problema) + '&barreira=CP5');
        
                // Impede o envio até a resposta da requisição AJAX
                event.preventDefault();
            }
        </script>
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
    
        <div class="container mt-4">
            <h2 class="titulo2">Barreira HR</h2>
            
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
            SELECT ID, VIN,MODELO,BARREIRA  FROM sistema_qualidade_body ORDER BY ID DESC)
            WHERE ROWNUM = 1 
                    </cfquery>
 <!---                     <cfdump  var="#consulta1#"> --->
                <div class="form-group col-md-2">
                    <label for="formVIN">BARCODE</label>
                    <input type="text" class="form-control form-control-sm" maxlength="17" name="vin" id="formVIN" required oninput="this.value = this.value.replace(/\s/g, '');">
                </div>
                                        <!--- Pesquisa MES --->
                    <cfquery name='buscaMES' datasource="#BANCOMES#">
                        select l.code, l.IDProduct, p.name, l.IDLot, g.IDLot, g.VIN,
                        rtrim(ltrim(replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
                            ' FL',''),
                            'COMPLETO ',''),
                            'COMPLETA ',''),
                            'TXS','PL7'),
                            'SOLDADO',''),
                            'SOLDADA',''),
                            'ESCURO',''),
                            'NOVO MOTOR',''),
                            'CINZA',''))) modelo
                        from TBLLot l
                        left join CTBLGravacao g on l.IDLot = g.IDLot
                        left join TBLProduct p on p.IDProduct = l.IDProduct
                        where l.code = '#consulta1.VIN#'
                        and p.name  like '%CABINE%'
                    </cfquery>
 
 <cfset modelo = buscaMES.modelo>
 
 <!--- Verifica se o modelo é null e substitui por "HR" se necessário --->
 <cfif isNull(modelo) or len(trim(modelo)) EQ 0>
    <cfset modelo = "HR">
 </cfif>
 <!--- <cfdump var="#buscaMES#"> --->
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="modelo" id="formModelo" readonly value="#buscaMES.name#">
                        <input id="modelo" name="modelo" type="hidden" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formLocal">Local</label>
                        <select class="form-control form-control-sm" name="local" id="formLocal" readonly required>
                            <option value="HR">HR</option>
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
                        <select class="form-control form-control-sm" name="estacao" id="formEstacao" >
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
                            <option value="AVARIA">AVARIA</option>
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
                <tr class="text-nowrap">
                   <th scope="col">Del</th>
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
                      <td>
                         <span class="delete-icon-wrapper" onclick="deletar(#ID#);"><i class="material-icons delete-icon" style="color: red;">X</i></span>
                      </td>
                      <td>#ID#</td>
                      <td>#LSDateTimeFormat(USER_DATA, 'dd/mm/yyyy HH:nn:ss')#</td>
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
                    window.location.href = "body_barreira_hr.cfm?id=" + id;
                }
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
    
        