<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    
    <!--- Verificando se está logado --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = '/qualidade/buyoff_linhat/index.cfm'
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
    FROM INTCOLDFUSION.sistema_qualidade_fa
    WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
    AND BARREIRA = 'T19'
    <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
        AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
    </cfif>
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
                         replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
                         ' FL',''),
                         'COMPLETO ',''),
                         'TXS',''),
                         'ESCURO',''),
                         'NOVO MOTOR',''))) modelo
        from TBLLot l
        left join CTBLGravacao g on l.IDLot = g.IDLot
		left join TBLProduct p on p.IDProduct = l.IDProduct
        where l.code = VIN
		and p.name like 'CARROCERIA PINTADA%'
</cfquery>

    <!--- Verifica se o formulário foi enviado --->
<cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>

    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade_fa
    </cfquery>
    
    <cfquery name='buscaMES2' datasource="#BANCOMES#">
        select l.code, l.IDProduct, p.name, l.IDLot, g.IDLot, g.VIN,
                            rtrim(ltrim(replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
                            ' FL',''),
                            'COMPLETO ',''),
                            'TXS',''),
                            'ESCURO',''),
                            'NOVO MOTOR',''))) modelo
        from TBLLot l
        left join CTBLGravacao g on l.IDLot = g.IDLot
        left join TBLProduct p on p.IDProduct = l.IDProduct
        where l.code = '#form.VIN#'
        and p.name like 'CARROCERIA PINTADA%'
    </cfquery>

    <!--- Inserir item --->
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO INTCOLDFUSION.sistema_qualidade_fa (
            ID, USER_DATA, USER_COLABORADOR, VIN, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, CRITICIDADE, INTERVALO, ULTIMO_REGISTRO
        ) VALUES (
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                ELSE SYSDATE 
            END,
            <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#buscaMES2.modelo#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#UCase(criticidade)#" cfsqltype="CF_SQL_VARCHAR">,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
            END,
            <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
        )
    </cfquery>
    <cfoutput><script>window.location.href = 'fa_barreira_t19.cfm';</script></cfoutput>
    
</cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.sistema_qualidade_fa WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'fa_barreira_t19.cfm';
        </script>
    </cfif>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
        <title>T19</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v2">
        <!--- deixar as letras do campo problema em maiúsculo --->
        <script>
            function transformToUpperCase(input) {
                input.value = input.value.toUpperCase();
            }
        </script>
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
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    
        <div class="container mt-4">
            <h2 class="titulo2">T19</h2><br>

            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'FA-T19-PROBLEMA'
                ORDER BY DEFEITO
            </cfquery>

            <cfquery name="peca" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'FA-T19-PEÇA'
                ORDER BY DEFEITO
            </cfquery>
            
            <form onsubmit="return validarFormulario(event);" method="post" id="form_envio">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly>
                    </div>
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
                    </cfquery>
                    <cfoutput>
                    <div class="form-group col-md-2">
                        <label for="formNome">Inspetor</label>
                        <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required value="#login.USER_SIGN#" readonly>
                    </div>
                    
                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                    SELECT * FROM (
            SELECT ID, VIN,MODELO,BARREIRA  FROM sistema_qualidade_fa ORDER BY ID DESC)
            WHERE ROWNUM = 1 
                    </cfquery>
<!---                     <cfdump  var="#consulta1#"> --->
                    <div class="form-group col-md-2">
                        <label for="formVIN">BARCODE</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="vin" id="formVIN" required>
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
                                            replace(replace(p.name,'CARROCERIA',''),'PINTADA',''),
                                            ' FL',''),
                                            'COMPLETO ',''),
                                            'TXS','PL7'),
                                            'ESCURO',''),
                                            'NOVO MOTOR',''),
                                            'CINZA',''))) modelo
                        from TBLLot l
                        left join CTBLGravacao g on l.IDLot = g.IDLot
                        left join TBLProduct p on p.IDProduct = l.IDProduct
                        where l.code = '#consulta1.VIN#'
                        and p.name  like 'CARROCERIA PINTADA%'
                    </cfquery>
<!--- <cfdump var="#buscaMES#"> --->
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="modelo" id="formModelo" readonly value="#buscaMES.name#">
                        <input id="modelo" name="modelo" type="hidden" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formLocal">Local</label>
                        <select class="form-control form-control-sm" name="local" id="formLocal" readonly required>
                            <option value="T19">T19</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formNConformidade">Peça</label>
                        <select class="form-control form-control-sm" name="N_Conformidade" id="formNConformidade" onchange="transformToUpperCase(this)">
                            <option value="">Selecione</option>
                            <cfloop query="peca">
                                <cfoutput>
                                    <option value="#defeito#">#defeito#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formPosicao">Posição</label>
                        <select class="form-control form-control-sm" name="posicao" id="formPosicao">
                            <cfinclude template="auxi/posicao_T19.cfm">
                        </select>
                    </div>

                    <div class="form-group col-md-2">
                        <label for="formProblema">Problema</label>
                        <select class="form-control form-control-sm" name="problema" id="formProblema" onchange="checkProblema()">
                            <option value="">Selecione</option>
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
                    <tr class="text-nowrap" >
                        <!-- Coluna de ação -->
                        <th scope="col">Del</th>
                        <th scope="col">ID</th>
                        <th scope="col">Data</th>
                        <th scope="col">Colaborador</th>
                        <th scope="col">VIN/BARCODE</th>
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
                                    <i class="material-icons delete-icon">X</i>
                                </span>
                            </td>
                            <td>#ID#</td>
                            <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                            <td>#USER_COLABORADOR#</td>
                            <td>#VIN#</td>
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
                    window.location.href = "fa_barreira_t19.cfm?id=" + id;
                }
            }
        </script>      
    </body>
</html>
    
        