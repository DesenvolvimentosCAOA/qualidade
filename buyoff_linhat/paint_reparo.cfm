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
    
    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade
        WHERE 1 = 1 
        <cfif isDefined("url.filtroDefeito") and url.filtroDefeito neq "">
            AND UPPER(PROBLEMA) LIKE UPPER('%#url.filtroDefeito#%')
        </cfif>
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroModelo") and url.filtroModelo neq "">
            AND UPPER(MODELO) LIKE UPPER('%#url.filtroModelo#%')
        </cfif>
        <cfif isDefined("url.filtroPeca") and url.filtroPeca neq "">
            AND UPPER(BARCODE) LIKE UPPER('%#url.filtroPeca#%')
        </cfif>
        <cfif isDefined("url.filtroestacao") and url.filtroestacao neq "">
            AND UPPER(ESTACAO) LIKE UPPER('%#url.filtroestacao#%')
        </cfif>
        <cfif isDefined("url.filtroBarreira") and url.filtroBarreira neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBarreira#%')
        </cfif>
        and  ROWNUM <= 40
        AND PROBLEMA_REPARO IS NULL
        AND (CRITICIDADE IS NULL OR CRITICIDADE NOT IN ('N0', 'OK A-'))
        ORDER BY ID DESC
    </cfquery>

    <!--- Atualizar Item--->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.sistema_qualidade
            SET TIPO_REPARO = <cfqueryparam value="#UCase(form.Tipo)#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#UCase(form.Reparador)#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'paint_reparo.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade
        </cfquery>
        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "paint_reparo.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>PAINT - REPARO</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo.css?v1">
        </head>

        <body>
            <header class="titulo">
                <cfinclude template="auxi/nav_links1.cfm">
            </header><br><br><br><br><br><br>
            <h2 style="font-size:2vw" class="titulo2">REPARO - PAINT </h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="row">
                            <div class="col-md-2 offset-md-1">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroModelo">Barreira:</label>
                                <input type="text" class="form-control" name="filtroModelo" id="filtroModelo" value="<cfif isDefined('url.filtroModelo')>#url.filtroModelo#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroPeca">BARCODE:</label>
                                <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined('url.filtroPeca')>#url.filtroPeca#</cfif>"/>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='paint_reparo.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </cfoutput>
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FAI#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">Data</th>
                                    <th scope="col">Inspetor</th>
                                    <th scope="col">Reparador</th>
                                    <th scope="col">BARCODE</th>
                                    <th scope="col">Barreira</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Posição</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Estação</th>
                                    <th scope="col">Reparo</th>
<!---                                     <th scope="col">Salvar</th> --->
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="paint_reparo.cfm">
                                            <cfif PROBLEMA NEQ "">
                                                <tr class="align-middle">
                                                    <td class="text-center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td class="text-center" style="font-size:15px">#USER_COLABORADOR#</td>
                                                    <td>
                                                        <input type="text" class="form-control" name="REPARADOR" id="formReparador" style="font-size:10px" value="#login.USER_SIGN#" readonly>
                                                    </td>
                                                    <td class="text-center">#BARCODE#</td>
                                                    <td class="text-center">#BARREIRA#</td>
                                                    <td class="text-center">#PECA#</td>
                                                    <td class="text-center">#POSICAO#</td>
                                                    <td class="text-center">#PROBLEMA#</td>
                                                    <td class="text-center">#ESTACAO#</td>
                                                    <td>
                                                        <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                    </td>
<!---                                                     <td><button type="submit" class="btn-save" name="btSalvarID" value="#ID#">Salvar</button></td> --->
                                                    <td class="text-nowrap">
                                                        <button class="btn btn-primary" onclick="self.location='reparo_editar.cfm?id_editar=#id#'">
                                                            <i class="mdi mdi-pencil-outline"></i> Editar
                                                        </button>
                                                    </td>
                                                </tr>
                                            </cfif>
                                        </form>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="12" class="text-center">Nenhum registro encontrado.</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Footer com uma imagem e o copyright -->
            <footer class="text-center py-4">
                <p>&copy; 2024 Sistema de gestão da qualidade.</p>
            </footer>
            <!-- Bootstrap JS e dependências -->
            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        </body>
    </html>