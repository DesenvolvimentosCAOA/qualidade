<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

 <!--- Verificando se está logado --->
 <cfif not isDefined("cookie.USER_APONTAMENTO_SMALL") or cookie.USER_APONTAMENTO_SMALL eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = 'index.cfm'
    </script>
</cfif>
<!---  Consulta --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.sistema_qualidade_small
    WHERE USER_DATA >= TRUNC(SYSDATE) AND USER_DATA < TRUNC(SYSDATE) + 1
    <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
        AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
    </cfif>
    ORDER BY ID DESC
</cfquery>

<!--- Obter próximo maxId --->
<cfquery name="obterMaxId" datasource="#BANCOSINC#">
    SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_SMALL
</cfquery>

<!--- Deletar Item --->
<cfif structKeyExists(url, "id") and url.id neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_SMALL WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
    <script>
        self.location = 'small.cfm';
    </script>
</cfif>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Small</title>
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    </head>
    <body>
        <header>
            <cfinclude  template="auxi/nav_links1.cfm">
        </header>
        <div class="container mt-4">
            <h2 class="titulo2">SMALL</h2><br><br>

            <form method="post" id="form_envio">
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formData">Data</label>
                        <input type="date" class="form-control form-control-sm" name="data" id="formData" value="<cfoutput>#dateFormat(now(), 'yyyy-mm-dd')#</cfoutput>" readonly>
                    </div>
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_SMALL#'
                    </cfquery>
            
                    <cfoutput>
                        <div class="form-group col-md-2">
                            <label for="formNome">Inspetor</label>
                            <input type="text" class="form-control form-control-sm" name="nome" id="formNome" required value="#login.USER_SIGN#" readonly>
                        </div>
                    </cfoutput>
            
                    <cfquery name="consulta1" datasource="#BANCOSINC#">
                        SELECT * FROM(
                            SELECT ID, PECA, MODELO, COR, DEFEITO, QUANTIDADE_OK, QUANTIDADE_NG FROM SISTEMA_QUALIDADE_SMALL ORDER BY ID DESC
                        )
                        WHERE ROWNUM = 1
                    </cfquery>
            
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <select class="form-control form-control-sm" name="modelo" id="formModelo" required>
                            <option value="" disabled selected>Selecione um modelo</option>
                            <option value="HR">HR</option>
                            <option value="T1A">T1A</option>
                            <option value="T1E">T1E</option>
                            <option value="T19">T19</option>
                            <option value="TL">TL</option>
                            <option value="T18">T18</option>
                            <option value="CHE">CHE</option>
                        </select>
                    </div>
            
                    <div class="form-group col-md-2">
                        <label for="formPeca">Peça</label>
                        <select class="form-control form-control-sm" name="peca" id="formPeca" required>
                            <option value="" disabled selected>Selecione uma peça</option>
                            <option value="ACAB INF LD SPOILER TRAS">ACAB INF LD SPOILER TRAS</option>
                            <option value="ACAB INF LE SPOILER TRAS">ACAB INF LE SPOILER TRAS</option>
                            <option value="ACABAMENTO DO PARAFUSO TRAS">ACABAMENTO DO PARAFUSO TRAS</option>
                            <option value="ANTENA TUBARAO">ANTENA TUBARAO</option>
                            <option value="CAPA COMB MACANETA C FURO">CAPA COMB MACANETA C FURO</option>
                            <option value="CAPA COMB MACANETA S FURO">CAPA COMB MACANETA S FURO</option>
                            <option value="CAPA RETROVISOR LD">CAPA RETROVISOR LD</option>
                            <option value="COBERT MACANETA DIANT">COBERT MACANETA DIANT</option>
                            <option value="COBERT MACANETA TRAS">COBERT MACANETA TRAS</option>
                            <option value="COMB MACANETA C FURO">COMB MACANETA C FURO</option>
                            <option value="MOLD DA PLACA TRAS">MOLD DA PLACA TRAS</option>
                            <option value="MOLD FAROL DRL LD">MOLD FAROL DRL LD</option>
                            <option value="MOLD FAROL DRL LE">MOLD FAROL DRL LE</option>
                            <option value="MOLD INF DO PARA CHOQUE TRAS">MOLD INF DO PARA CHOQUE TRAS</option>
                            <option value="MOLD LUZ DE LICENCA">MOLD LUZ DE LICENCA</option>
                            <option value="MOLD PORTA DIANT LD">MOLD PORTA DIANT LD</option>
                            <option value="MOLD PORTA DIANT LE">MOLD PORTA DIANT LE</option>
                            <option value="MOLD PORTA TRAS LD">MOLD PORTA TRAS LD</option>
                            <option value="MOLD PORTA TRAS LE">MOLD PORTA TRAS LE</option>
                            <option value="MOLD TAMPA TRASEIRA">MOLD TAMPA TRASEIRA</option>
                            <option value="MOLDURA DO PAINEL TRASEIRO">MOLDURA DO PAINEL TRASEIRO</option>
                            <option value="PARA CHOQUE DIANT BRANCO S">PARA CHOQUE DIANT BRANCO S</option>
                            <option value="SENSOR ULTRASSONICO">SENSOR ULTRASSONICO</option>
                            <option value="SPOILER TRAS">SPOILER TRAS</option>
                            <option value="TAMPAO DO REBOQUE TRAS">TAMPAO DO REBOQUE TRAS</option>
                            <option value="TAMPAO GANCHO">TAMPAO GANCHO</option>
                        </select>
                    </div>
            
                    <div class="form-group col-md-2">
                        <label for="formCor">Cor</label>
                        <select class="form-control form-control-sm" name="cor" id="formCor" required>
                            <option value="" disabled selected>Selecione uma cor</option>
                            <option value="WAS">WAS</option>
                            <option value="WAP">WAP</option>
                            <option value="GRB">GRB</option>
                            <option value="BLP">BLP</option>
                            <option value="PRATA">PRATA</option>
                        </select>
                    </div>
                </div>
            
                <div class="form-row">
                    <div class="form-group col-md-2">
                        <label for="formDefeito">Defeito</label>
                        <select class="form-control form-control-sm" name="defeito" id="formDefeito" required>
                            <option value="" disabled selected>Selecione um defeito</option>
                            <option value="CL">CL - CASCA DE LARANJA</option>
                            <option value="CO.A">CO.A - CONTAMINAÇÃO POR ÁGUA</option>
                            <option value="CP">CP - CAIU NO PROCESSO</option>
                            <option value="CR">CR - CRATERA</option>
                            <option value="DF">DF - DEFORMAÇÃO</option>
                            <option value="ESP">ESP - ESCORRIDO PRIMER</option>
                            <option value="ESR">ESR - ESCORRIDO RESINA</option>
                            <option value="ESV">ESV - ESCORRIDO VERNIZ</option>
                            <option value="FALTA PEÇA">FALTA PEÇA</option>
                            <option value="FCV">FCV - FALTA DE COBERTURA VERNIZ</option>
                            <option value="FERVURA">FERVURA</option>
                            <option value="FIAPO">FIAPO</option>
                            <option value="FP">FP - FALHA NO PROCESSO</option>
                            <option value="GRUMO">GRUMO</option>
                            <option value="MT">MT - MARCA DE TOQUE</option>
                            <option value="OV">OV - OVERSPRAY</option>
                            <option value="QP">QP - QUEDA DE PEÇA</option>
                            <option value="RI">RI - RISCO</option>
                            <option value="RP">RP - REPINTURA</option>
                            <option value="SJ">SJ - SUJEIRA</option>
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formQuantidadeOK">Quantidade OK</label>
                        <input type="text" class="form-control form-control-sm" name="quantidadeOK" id="formQuantidadeOK" required>
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formQuantidadeNG">Quantidade NG</label>
                        <input type="text" class="form-control form-control-sm" name="quantidadeNG" id="formQuantidadeNG" required>
                    </div>
                </div>
                <div class="form-row"></div>
                <button type="submit" class="btn btn-primary">Enviar</button>
                <cfif isDefined("form.nome") and form.nome neq "">
                    <cfquery name="obterMaxID" datasource="#BANCOSINC#">
                        SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_SMALL
                    </cfquery>
                    <cfquery name="insere" datasource="#BANCOSINC#">
                        INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_SMALL (
                            ID, USER_DATA, USER_COLABORADOR, MODELO, PECA, COR, DEFEITO, QUANTIDADE_OK, QUANTIDADE_NG, INTERVALO
                        ) 
                        VALUES (
                            <cfqueryparam value="#obterMaxID.id#" cfsqltype="CF_SQL_INTEGER">,
                            CASE
                                WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:00' THEN SYSDATE -1
                                ELSE SYSDATE
                            END,
                            <cfqueryparam value="#form.nome#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.modelo#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.peca#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.cor#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.defeito#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.quantidadeOK#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value="#form.quantidadeNG#" cfsqltype="CF_SQL_VARCHAR">,
                            CASE 
                                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                                WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                                ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
                            END

                        )
                    </cfquery>
                    
                    <cfoutput><script>window.location.href = 'small.cfm';</script></cfoutput>
                </cfif>
                <button type="reset" class="btn btn-danger">Cancelar</button>
            </form>
            
            </div>
            <div class="container col-12 bg-white rounded metas">
                <table class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <!-- Coluna de ação -->
                            <cfif isDefined("cookie.user_level_paint") and cookie.user_level_paint eq "G">
                                <th scope="col">Ação</th>
                            </cfif>
                            <th scope="col">ID</th>
                            <th scope="col">Data</th>
                            <th scope="col">Colaborador</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Peça</th>
                            <th scope="col">Cor</th>
                            <th scope="col">Defeito</th>
                            <th scope="col">Quantidade OK</th>
                            <th scope="col">Quantidade NG</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput query="consulta">
                            <tr class="align-middle">
                                <!-- Botão de exclusão -->
                                <cfif isDefined("cookie.user_level_paint") and cookie.user_level_paint eq "G">
                                    <td>
                                        <span class="delete-icon-wrapper" onclick="deletar(#ID#);">
                                            <i style="color:red" class="material-icons delete-icon">X</i>
                                        </span>
                                    </td>
                                </cfif>
                                <td>#ID#</td>
                                <td>#lsdatetimeformat(USER_DATA, 'dd/mm/yyyy')#</td>
                                <td>#USER_COLABORADOR#</td>
                                <td>#MODELO#</td>
                                <td>#PECA#</td>
                                <td>#COR#</td>
                                <td>#DEFEITO#</td>
                                <td>#QUANTIDADE_OK#</td>
                                <td>#QUANTIDADE_NG#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
        </div>
            <!-- Script para deletar -->
            <script>
                function deletar(id) {
                    if (confirm("Tem certeza que deseja deletar este item?")) {
                        window.location.href = "small.cfm?id=" + id;
                    }
                }
            </script>
            <cfscript>
                function removeAcentos(str) {
                    var acentos = "ÁÀÂÃÄÅÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇáàâãäåéèêëíìîïóòôõöúùûüç";
                    var semAcentos = "AAAAAAEEEEIIIIOOOOOUUUUCaaaaaaeeeeiiiiooooouuuuc";
                    
                    for (var i = 1; i <= len(acentos); i++) {
                        str = replace(str, mid(acentos, i, 1), mid(semAcentos, i, 1), "all");
                    }
                    return str;
                }
            </cfscript>
    </body>
</html>