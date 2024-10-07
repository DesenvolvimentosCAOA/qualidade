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
        self.location= 'fa_selecionar_c13.cfm'
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
    AND BARREIRA = 'T33'
    <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
        AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
    </cfif>
    ORDER BY ID DESC
</cfquery>
 <!--- Verifica se o formulário foi enviado --->
 <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "modelo") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>

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
        self.location = 'fa_barreira_T33.cfm';
    </script>
</cfif>

<html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Barreira - T33</title>
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v2">
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <style>
            #formNConformidade, #formVIN, #formPosicao, #formProblema{
        text-transform: uppercase;
    }
        </style>
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
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
    <div class="container mt-4">
        <h2 class="titulo2">Barreira T33</h2><br><br>

        <cfquery name="defeitos" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FA-SUBMOTOR-PROBLEMA'
            ORDER BY DEFEITO
        </cfquery>

        <cfquery name="peca" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FA-T33-PEÇA'
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
                        SELECT * FROM(
                            SELECT ID, VIN, MODELO, BARREIRA FROM SISTEMA_QUALIDADE_FA ORDER BY ID DESC
                        )
                        WHERE ROWNUM = 1
                    </cfquery>
                    <div class="form-group col-md-2">
                        <label for="formVIN">VIN</label>
                        <input type="text" class="form-control form-control-sm" minlength="16" maxlength="17" name="vin" id="formVIN" required >
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formModelo">Modelo</label>
                        <input type="text" class="form-control form-control-sm" maxlength="17" name="modelo" id="formModelo" readonly>
                        <input id="modelo" name="modelo" type="hidden" >
                    </div>
                    <div class="form-group col-md-2">
                        <label for="formLocal">Local</label>
                        <select class="form-control form-control-sm" name="local" id="formLocal" required readonly>
                            <option value="T33">T33</option>
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
                    
                    <div class="form-group col-md-33">
                        <label for="formEstacao">Responsável</label>
                        <select class="form-control form-control-sm" name="estacao" id="formEstacao" style="width: 270px;">
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
                                replace(
                                replace(replace(p.name,'CONJUNTO',''),'TRIM',''),
                                ' FL',''),
                                'BRANCO',''),
                                'GRB',''),
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
                    <cfset vin = trim(removeAcentos(form.vin))>
                    <cfset local = trim(removeAcentos(form.local))>
                    <cfset nConformidade = trim(removeAcentos(form.N_Conformidade))>
                    <cfset posicao = trim(removeAcentos(form.posicao))>
                    <cfset problema = trim(removeAcentos(form.problema))>
                    <cfset estacao = trim(removeAcentos(form.estacao))>

            <cfquery name="insere" datasource="#BANCOSINC#">
                INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_FA (
                    ID, USER_DATA, USER_COLABORADOR, VIN, BARCODE, MODELO, BARREIRA, PECA, POSICAO, PROBLEMA, ESTACAO,CRITICIDADE, INTERVALO
                ) VALUES (
                    <cfqueryparam value="#obterMaxId.id#" cfsqltype="CF_SQL_INTEGER">,
                    CASE 
                        WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                        ELSE SYSDATE 
                    END,
                    <cfqueryparam value="#UCase(form.nome)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(vin)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#buscaBarcode.barcode#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(buscaMES.modelo)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(local)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(nConformidade)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(posicao)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(problema)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(estacao)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#UCase(criticidade)#" cfsqltype="CF_SQL_VARCHAR">,
                    CASE 
                        WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                        WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                        ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
                    END
                )
            </cfquery>
    <cfoutput><script>window.location.href = 'fa_barreira_T33.cfm';</script></cfoutput>
                </cfif>
                <button type="reset" class="btn btn-danger">Cancelar</button>
                <h3 style="color:red">Após o envio verifique se o VIN foi inserido corretamente e o modelo do veículo apareceu no lançamento</h3>
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
                                    <i class="material-icons delete-icon">X</i>
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
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.0/js/bootstrap.bundle.min.js"></script>
        <!-- Script para deletar -->
        <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "fa_barreira_T33.cfm?id=" + id;
                }
            }
        </script>
        <script>
            function checkProblema() {
            var problemaInput = document.getElementById('formProblema').value;
            var responsavelSelect = document.getElementById('formEstacao');
                
            if (problemaInput.trim() !== "") {
                        responsavelSelect.style.border = "2px solid red";
            } else {
                responsavelSelect.style.border = "";
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
                