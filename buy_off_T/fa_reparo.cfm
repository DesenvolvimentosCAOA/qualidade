<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

   <!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>


    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        WHERE 1 = 1
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroPeca") and url.filtroPeca neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroPeca#%')
        </cfif>
        <cfif isDefined("url.filtroBarreira") and url.filtroBarreira neq "">
            AND UPPER(BARREIRA) LIKE UPPER('%#url.filtroBarreira#%')
        </cfif>
        and  ROWNUM <= 30
        AND PROBLEMA IS NOT NULL
        AND (CRITICIDADE IS NULL OR CRITICIDADE NOT IN ('N0', 'OK A-', 'AVARIA'))
        AND RESPONSAVEL_REPARO IS NULL
        ORDER BY ID asc
    </cfquery>
    
    
    <!--- Atualizar Item--->
    <cfif structKeyExists(form, "btSalvarID") and structKeyExists(form, "Tipo") and form.btSalvarID neq "" and form.Tipo neq "">
        <cfquery name="atualizar" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            SET TIPO_REPARO = <cfqueryparam value="#UCase(form.Tipo)#" cfsqltype="CF_SQL_VARCHAR">,
            REPARADOR = <cfqueryparam value="#UCase(form.Reparador)#" cfsqltype="CF_SQL_VARCHAR">
            WHERE ID = <cfqueryparam value="#form.btSalvarID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            alert("Salvo com sucesso!");
            self.location = 'fa_reparo.cfm';
        </script>
    </cfif>

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
        </cfquery>


        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "fa_reparo.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>

    <!--- Deletar Item --->
    <cfif structKeyExists(url, "id") and url.id neq "">
        <cfquery name="delete" datasource="#BANCOSINC#">
            DELETE FROM INTCOLDFUSION.SISTEMA_QUALIDADE_FA
            WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <script>
            self.location = 'fa_reparo.cfm';
        </script>
    </cfif>

    <html lang="pt-BR">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>REPARO - CP7</title>
            <link rel="icon" href="./assets/chery.png" type="image/x-icon">
            <link rel="stylesheet" href="assets/stylereparo1.css?v1">
        </head>
        
        <body>
            <!-- Header com as imagens e o menu -->
            <header class="titulo">
                <cfinclude template="auxi/nav_links.cfm">
            </header><br><br><br><br><br><br>

            <div class="container-fluid mt-4">
                <h2 style="font-size:2vw" class="titulo2">REPARO</h2><br>
                <cfoutput>
                    <form class="filterTable" name="fitro" method="GET">
                        <div class="row">
                            <div class="col-md-2 offset-md-1">
                                <label class="form-label" for="filtroID">ID:</label>
                                <input type="number" class="form-control" name="filtroID" id="filtroID" value="<cfif isDefined('url.filtroID')>#url.filtroID#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroPeca">VIN:</label>
                                <input type="text" class="form-control" name="filtroPeca" id="filtroPeca" value="<cfif isDefined('url.filtroPeca')>#url.filtroPeca#</cfif>"/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" for="filtroBarreira">BARREIRA:</label>
                                <select class="form-control" name="filtroBarreira" id="filtroBarreira" onchange="this.form.submit()">
                                    <option value="" disabled selected>Selecione</option>
                                    <option value="T19" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'T19'>selected</cfif>>T19</option>
                                    <option value="T30" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'T30'>selected</cfif>>T30</option>
                                    <option value="T33" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'T33'>selected</cfif>>T33</option>
                                    <option value="C13" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'C13'>selected</cfif>>C13</option>
                                    <option value="F05" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'F05'>selected</cfif>>F05</option>
                                    <option value="F10" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'F10'>selected</cfif>>F10</option>
                                    <option value="SUBMOTOR" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'SUBMOTOR'>selected</cfif>>SUBMOTOR</option>
                                    <option value="CP7" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'CP7'>selected</cfif>>CP7</option>
                                    <option value="HR" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'HR'>selected</cfif>>HR</option>
                                    <option value="LIBERACAO" <cfif isDefined('url.filtroBarreira') and url.filtroBarreira eq 'LIBERACAO'>selected</cfif>>LIBERACAO</option>
                                </select>
                            </div>
                            
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                                <button class="btn btn-warning" type="reset" onclick="self.location='fa_reparo.cfm'">Limpar</button>
                            </div>
                        </div>
                    </form>
                </cfoutput>
            
                <div class="overflow-x-auto">
                    <cfquery name="login" datasource="#BANCOSINC#">
                        SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                        WHERE USER_NAME = '#cookie.USER_APONTAMENTO_FA#'
                    </cfquery>
                    <div class="container-fluid p-0">
                        <table class="table table-striped table-bordered w-100">
                            <thead>
                                <tr class="text-nowrap">
                                    <th scope="col">ID</th>
                                    <th scope="col">Data</th>
                                    <th scope="col">VIN</th>
                                    <th scope="col">Barreira</th>
                                    <th scope="col">Peça</th>
                                    <th scope="col">Posição</th>
                                    <th scope="col">Problema</th>
                                    <th scope="col">Estação</th>
                                    <th scope="col">Criticidade</th>
                                    <th scope="col">Reparo</th>
<!---                                     <th scope="col">Salvar</th> --->
                                    <th scope="col">Editar</i></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <cfif consulta.recordCount gt 0>
                                    <cfoutput query="consulta">
                                        <form method="post" action="fa_reparo.cfm">
                                                <tr class="align-middle">
                                                    <td class="text-center">#ID#</td>
                                                    <td>#dateFormat(USER_DATA, 'dd/mm/yyyy')#</td>
                                                    <td class="text-center">#VIN#</td>
                                                    <td class="text-center">#BARREIRA#</td>
                                                    <td class="text-center">#PECA#</td>
                                                    <td class="text-center">#POSICAO#</td>
                                                    <td class="text-center">#PROBLEMA#</td>
                                                    <td class="text-center">#ESTACAO#</td>
                                                    <td class="text-center">#CRITICIDADE#</td>
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

    <cfcatch type="any">
        <cfoutput>
            Ocorreu um erro ao inserir os dados no banco de dados.<br>
            Detalhes do erro: #cfcatch.message#<br>
            Stack Trace: #cfcatch.stacktrace#
        </cfoutput>
    </cfcatch>
</cftry>