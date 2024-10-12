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

<cfquery name="consulta_editar" datasource="#BANCOSINC#">
    SELECT * FROM INTCOLDFUSION.sistema_qualidade
    WHERE ID = '#url.id_editar#'
    ORDER BY ID DESC
</cfquery>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>EDITAR ESTAÇÃO</title>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    <link rel="stylesheet" href="assets/style_editar.css?v1">
</head>

<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br>

        <cfquery name="problema" datasource="#BANCOSINC#">
            SELECT DEFEITO FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
            WHERE SHOP = 'FAI-SHOWER-PROBLEMA'
            ORDER BY DEFEITO
    </cfquery>

    <h1 class="text-center mt-2">Editar</h1>
    <div class="container col-10">
        <form id="for-edit" method="POST">
            <cfoutput> 
                <div class="row mb-4">
                    <div class="col col-4">
                        <div class="form-group">
                            <label class="form-label" for="formData">Data:</label>
                            <input type="date" name="data" class="form-control" id="formData" value="#dateFormat(consulta_editar.user_data, 'yyyy-mm-dd')#"/>
                        </div>
                        
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formVIN">VIN</label>
                            <input type="text" class="form-control" name="VIN" id="formVIN" value="#consulta_editar.barcode#" required/>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formModelo">Modelo</label>
                            <input type="text" class="form-control" name="modelo" id="formModelo" value="#consulta_editar.modelo#"/>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formCriticidade">Criticidade</label>
                            <input type="text" class="form-control" name="criticidade" id="formCriticidade" value="#consulta_editar.CRITICIDADE#"/>
                        </div>
                    </div>
                </div>

                <!-- Peça, Posição e Problema na mesma linha -->
                <div class="row mb-4">
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formPeca">Peça</label>
                            <input type="text" maxlength="200" class="form-control" name="peca" id="formPeca" value="#consulta_editar.peca#"/>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formlocal">Posição</label>
                            <input type="text" name="local" id="formlocal" value="#consulta_editar.posicao#"  />
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formNConformidade">Problema</label>
                            <input type="text" name="NConformidade" id="formNConformidade" value="#consulta_editar.problema#"  />
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formEstacao">Estação</label>
                            <select class="form-control" name="estacao" id="formEstacao">
                                <option value="#consulta_editar.estacao#">#consulta_editar.estacao#</option>
                                <cfinclude template="auxi/estacao.cfm">
                            </select>
                        </div>
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label class="form-label" for="formIntervalo">Intervalo</label>
                            <input type="text" name="Intervalo" id="formIntervalo" value="#consulta_editar.intervalo#"  />
                        </div>
                    </div>
                </div>
                <div class="bt_ms mb-5">
                    <button type="submit" form="for-edit" class="btn btn-primary">Salvar</button>
                    <cfif isDefined("form.vin") and form.vin neq "">
                        <cfquery name="atualiza" datasource="#BANCOSINC#">
                            UPDATE INTCOLDFUSION.sistema_qualidade
                            SET 
                                USER_DATA = CASE 
                                                WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                                                ELSE SYSDATE
                                            END,
                                BARCODE = <cfqueryparam value="#UCase(form.vin)#" cfsqltype="cf_sql_varchar">,
                                PECA = <cfqueryparam value="#UCase(form.peca)#" cfsqltype="cf_sql_varchar">, 
                                POSICAO = <cfqueryparam value="#UCase(form.local)#" cfsqltype="cf_sql_varchar">, 
                                PROBLEMA = <cfqueryparam value="#UCase(form.NConformidade)#" cfsqltype="cf_sql_varchar">, 
                                CRITICIDADE = <cfqueryparam value="#UCase(form.criticidade)#" cfsqltype="cf_sql_varchar">,
                                ESTACAO = <cfqueryparam value="#UCase(form.estacao)#" cfsqltype="cf_sql_varchar">,
                                INTERVALO = <cfqueryparam value="#UCase(form.intervalo)#" cfsqltype="cf_sql_varchar">,
                                MODELO = <cfqueryparam value="#UCase(form.modelo)#" cfsqltype="cf_sql_varchar">,
                                VIN = <cfqueryparam value="#UCase(form.vin)#" cfsqltype="cf_sql_varchar">
                            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        
                        <div class="alert alert-success" role="alert">
                            Atualizado com Sucesso
                        </div>
                        <meta http-equiv="refresh" content="1.5; url=paint_editar.cfm">
                    </cfif>
                    <div class="col col-3">
                        <button type="reset" id="bt_reset" onclick="self.location = 'paint_editar.cfm'" class="btn btn-warning">Voltar</button>
                      </div>
                </div>
            </cfoutput>
        </form>
    </div>
    <footer class="text-center py-4">
        <p>&copy; 2024 Sistema de gestão da qualidade.</p>
    </footer>

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
