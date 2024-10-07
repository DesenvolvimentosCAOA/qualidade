    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade_fai
    WHERE ID = '#url.id_editar#'
    ORDER BY ID DESC
</cfquery>

<!--- Consulta --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.sistema_qualidade_fai
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
    <link rel="stylesheet" href="assets/style_editar.css?v1">
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

    <cfquery name="problema" datasource="#BANCOSINC#">
        SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE SHOP LIKE 'FAI%'
        ORDER BY DEFEITO
    </cfquery>

    <cfquery name="pecas" datasource="#BANCOSINC#">
        SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE SHOP LIKE 'FAI%'
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
                            <input type="text" class="form-control" name="data_reparo" id="formDataReparo" value="<cfoutput>#dateFormat(now(), 'dd/mm/yyyy')#</cfoutput>" readonly/>
                        </div>
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formVIN">VIN</label>
                            <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.vin#" required readonly/>
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
                            WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                        </cfquery>
                        <div class="form-group">
                            <label class="form-label" for="formReparador">Reparador</label>
                            <input type="text" class="form-control" name="reparador" id="formReparador" value="#login.USER_SIGN#" readonly/>
                        </div>
                    </div>

                </div>

                <div class="row mb-4">
                    <div class="col">
                        <div class="form-group col-md-2">
                            <label class="form-label" for="formPecaReparo">Peça</label>
                            <!-- Campo de entrada com datalist -->
                            <input type="text" class="form-control" name="peca_reparo" id="formPecaReparo" list="pecasDatalist" required>
                            <datalist id="pecasDatalist">
                                <!-- Adicione as opções do datalist aqui -->
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
                            <select type="text" class="form-control" name="posicao_reparo" id="formPosicaoReparo" required>
                                <cfinclude  template="auxi/batalha_option.cfm">
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formProblemaReparo">Problema</label>
                            <!-- Campo de entrada com datalist -->
                            <input type="text" class="form-control" name="problema_reparo" id="formProblemaReparo" list="problemasDatalist" required>
                            <datalist id="problemasDatalist">
                                <!-- Adicione as opções do datalist aqui -->
                                <cfloop query="problema">
                                    <cfoutput>
                                        <option value="#defeito#">#defeito#</option>
                                    </cfoutput>
                                </cfloop>
                            </datalist>
                        </div>
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
                                <!-- Inclua o arquivo que gera as opções dinamicamente -->
                                <cfinclude template="auxi/tipo_reparo.cfm">
                            </datalist>
                        </div>
                        
                    </div>
                </div>
                
                <div class="bt_ms mb-5">
                    
                    <button type="submit" id="bt_reset" onclick="history.back()" class="btn btn-warning">Voltar</button>
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                    
                    <cfif isDefined("form.vin") and form.vin neq "">
                        <cfquery name="atualiza" datasource="#BANCOSINC#">
                            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FAI
                            SET 
                                TIPO_REPARO = '#form.tipo_reparo#',
                                REPARADOR = '#form.reparador#',
                                REPARO_DATA = '#form.data_reparo#',
                                PECA_REPARO = '#form.peca_reparo#',
                                POSICAO_REPARO = '#form.posicao_reparo#',
                                PROBLEMA_REPARO = '#form.problema_reparo#',
                                RESPONSAVEL_REPARO = '#form.responsavel_reparo#',
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
                        <meta http-equiv="refresh" content="1.5; url=fai_selecionar_reparo.cfm">
                    </cfif>
                </div>
            </cfoutput>
        </form>
    </div>
    <footer class="text-center py-4">
        <p>&copy; 2024 Sistema de gestão da qualidade.</p>
    </footer>
    
</body>
</html>
