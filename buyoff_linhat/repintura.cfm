<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
    
    <!--- Verificando se está logado --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
            <script>
                alert("É necessario autenticação!!");
                self.location = 'index.cfm'
            </script>
    </cfif>
    <cfif not isDefined("cookie.user_level_paint") or (cookie.user_level_paint eq "R" or cookie.user_level_paint eq "P")>
        <script>
            alert("É necessário autorização!!");
            history.back(); // Voltar para a página anterior
        </script>
    </cfif>
    
    <!---  Consulta  --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        AND (UPPER(BARREIRA) = 'TROCA DE PEÇA' OR UPPER(BARREIRA) = 'REPINTURA')
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

    <!--- Consulta se o VIN já existe e verificar a barreira e problema --->
    <cfquery name="verificaVin" datasource="#BANCOSINC#">
        SELECT VIN, BARREIRA, PROBLEMA
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE
        WHERE VIN = <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>

    <!--- Verifica se o VIN existe e se a barreira é "Primer" e o campo "Problema" está preenchido --->
    <cfif verificaVin.recordCount GT 0 AND verificaVin.BARREIRA EQ "Primer" AND len(trim(verificaVin.PROBLEMA)) GT 0>
        <!--- Exibe popup para validação do reparo e redireciona após a confirmação --->
        <script>
            alert("Há um problema no veículo encontrado na estação Primer! Por favor, valide o reparo.");
            // window.location.href = 'selecao_paint.cfm';
        </script>
    </cfif>

    <!--- Obter próximo maxId --->
    <cfquery name="obterMaxId" datasource="#BANCOSINC#">
        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE
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
        INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE (
            ID, USER_DATA, USER_COLABORADOR, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO, INTERVALO
        ) VALUES (
            <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
            SYSDATE,
            <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.vin#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#buscaMES2.modelo#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.local#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.N_Conformidade#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.posicao#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.problema#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#form.estacao#" cfsqltype="CF_SQL_VARCHAR">,
            CASE 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
            END
        )
    </cfquery>
    <cfoutput><script>window.location.href = 'repintura.cfm';</script></cfoutput>
</cfif>

    
    
    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'repintura.cfm';
        </script>
    </cfif>
    
    <html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Início</title>
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
    </head>
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br>
    
        <div class="container mt-4">
            <h2 class="titulo2" style="color:red">Troca de Peças e Repinturas</h2><br>
            <cfquery name="defeitos" datasource="#BANCOSINC#">
                SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
                WHERE SHOP = 'PAINT'
                ORDER BY DEFEITO
            </cfquery>
            
            <form method="post" id="form_envio">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly>
                    </div>
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PAINT#'
                    </cfquery>
                    <cfoutput>
                    <div class="form-group col-md-2">
                        <label for="formNome">Inspetor</label>
                        <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required value="#login.USER_SIGN#" readonly>
                    </div>
                    
                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                    SELECT * FROM (
            SELECT ID, BARCODE,MODELO,BARREIRA  FROM SISTEMA_QUALIDADE ORDER BY ID DESC)
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
    where l.code = '#consulta1.BARCODE#'
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
                        <select class="form-control form-control-sm" name="local" id="formLocal" required>
                            <option value="">Selecione a estação</option>
                            <option value="TROCA DE PEÇA">Troca de Peça</option>
                            <option value="REPINTURA">Repintura</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formNConformidade">Peça</label>
                        <select class="form-control form-control-sm" name="N_Conformidade" id="formNConformidade">
                            <option value="">Selecione</option>
                            <option value="PARALAMAS">Paralamas</option>
                            <option value="CAPÔ">Capô</option>
                            <option value="PORTA">Porta</option>
                            <option value="TAMPA TRASEIRA">Tampa Traseira</option>
                            <option value="COLUNA A">Coluna A</option>
                            <option value="COLUNA B">Coluna B</option>
                            <option value="COLUNA C">Coluna C</option>
                            <option value="TETO">Teto</option>
                            <option value="ASSOALHO">Assoalho</option>
                            <option value="COFRE DO MOTOR">Cofre do Motor</option>
                            <option value="PORTINHOLA">Portinhola</option>
                            <option value="SOLEIRA">Soleira</option>
                            <option value="CAIXA DE RODAS">Caixa de Rodas</option>
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
                        <select class="form-control form-control-sm" name="estacao" id="formEstacao" style="width: 270px;">
                            <option value="">Selecione o Responsável:</option>
                            <cfinclude template="auxi/estacao.cfm">
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
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </div>
        <!-- Script para deletar -->
        <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "repintura.cfm?id=" + id;
                }
            }
        </script>    
    </body>
</html>
        