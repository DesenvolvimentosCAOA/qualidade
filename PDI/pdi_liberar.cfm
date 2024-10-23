<cftry>
    <cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

   <!--- Verificando se está logado --->
   <cfif not isDefined("cookie.USER_APONTAMENTO_PDI") or cookie.USER_APONTAMENTO_PDI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_PDI") or (cookie.user_level_PDI eq "R" or cookie.user_level_PDI eq "P" or cookie.user_level_PDI eq "I" or cookie.user_level_pdi eq "E")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>

    <!--- Consulta --->
    <cfquery name="consulta" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.sistema_qualidade_pdi_saida
        WHERE 1 = 1 
        <cfif isDefined("url.filtroID") and url.filtroID neq "">
            AND ID = <cfqueryparam value="#url.filtroID#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif isDefined("url.filtroVIN") and url.filtroVIN neq "">
            AND UPPER(VIN) LIKE UPPER('%#url.filtroVIN#%')
        </cfif>
        AND STATUS NOT IN 'LIBERADO'
        ORDER BY ID asc
    </cfquery>
     

    <!--- Verifica se o formulário foi enviado --->
    <cfif structKeyExists(form, "nome") and structKeyExists(form, "vin") and structKeyExists(form, "local") and structKeyExists(form, "N_Conformidade") and structKeyExists(form, "posicao") and structKeyExists(form, "problema")>
        <!--- Obter próximo maxId --->
        <cfquery name="obterMaxId" datasource="#BANCOSINC#">
            SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM INTCOLDFUSION.sistema_qualidade_pdi_saida
        </cfquery>
        <!--- Verifica se a inserção foi bem-sucedida --->
        <cfif insere.recordCount>
            <script> self.location = "pdi_liberar.cfm"; </script>
        <cfelse>
            <cfoutput>Erro ao inserir dados no banco de dados.</cfoutput>
        </cfif>
    </cfif>
    

    <cfif structKeyExists(url, "id") and url.id neq "">
        <!-- Consulta para obter o USER_SIGN e salvar no campo RESPONSAVEL_LIBERACAO -->
        <cfquery name="login" datasource="#BANCOSINC#">
            SELECT USER_NAME, USER_SIGN 
            FROM INTCOLDFUSION.REPARO_FA_USERS
            WHERE USER_NAME = <cfqueryparam value="#cookie.USER_APONTAMENTO_PDI#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
    
        <!-- Verifica a condição que decide qual update será feito -->
        <cfif url.status eq "LIBERADO">
            <!-- Atualizando status para 'LIBERADO' -->
            <cfquery name="update" datasource="#BANCOSINC#">
                UPDATE INTCOLDFUSION.sistema_qualidade_pdi_saida
                SET 
                    DATA_ENVIO = (
                CASE 
                    WHEN TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '00:00' AND '01:02' THEN SYSDATE - 1
                    ELSE SYSDATE 
                END
            ),
                    STATUS = 'LIBERADO',
                    RESPONSAVEL_LIBERACAO = <cfqueryparam value="#login.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">
                WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>

        
        </cfif>
    
        <!-- Redireciona após a atualização -->
        <script>
            self.location = 'pdi_liberar.cfm';
        </script>
    </cfif>
<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>PDI - Liberação</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/buyoff_linhat/assets/stylereparo.css?v2">
        <style>
                /* Estilo normal do botão */
            .btn-apagar {
                background-color: #dc3545; /* Vermelho (Bootstrap danger) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }

            /* Estilo ao passar o mouse (hover) */
            .btn-apagar:hover {
                background-color: #c82333; /* Vermelho mais escuro */
                box-shadow: 0 0 8px rgba(220, 53, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }

            /* Estilo normal do botão */
            .btn-pdi {
                background-color: #0000CD; /* Vermelho (Bootstrap danger) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }

            /* Estilo ao passar o mouse (hover) */
            .btn-pdi:hover {
                background-color: #0000CD; /* Vermelho mais escuro */
                box-shadow: 0 0 8px rgba(0,255,127, 1); /* Sombra leve */
                cursor: pointer;
            }
        </style>
    </head>
    
    <body>
        <!-- Header com as imagens e o menu -->
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header><br><br><br><br><br><br>

        <div class="container-fluid mt-4">
            <h2 style="font-size:2vw" class="titulo2">LIBERAÇÃO</h2><br>
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
                            <label class="form-label" for="filtroVIN">VIN:</label>
                            <input type="text" class="form-control" name="filtroVIN" id="filtroVIN" value="<cfif isDefined('url.filtroVIN')>#url.filtroVIN#</cfif>"/>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                            <button class="btn btn-warning" type="reset" onclick="self.location='pdi_liberar.cfm'">Limpar</button>
                        </div>
                    </div>
                </form>
            </cfoutput>
        
            <div class="overflow-x-auto">
                <cfquery name="login" datasource="#BANCOSINC#">
                    SELECT USER_NAME, USER_SIGN FROM INTCOLDFUSION.REPARO_FA_USERS
                    WHERE USER_NAME = '#cookie.USER_APONTAMENTO_PDI#'
                </cfquery>
                <div class="container-fluid p-0">
                    <table class="table table-striped table-bordered w-100">
                        <thead>
                            <tr class="text-nowrap">
                                <th scope="col">ID</th>
                                <th scope="col">Inspetor</th>
                                <th scope="col">VIN</th>
                                <th scope="col">Peça</th>
                                <th scope="col">Posição</th>
                                <th scope="col">Problema</th>
                                <th scope="col">Reparo Realizado</th>
                                <th scope="col">Status</th>
                                <th scope="col">LIBERAR</i></th>
                            </tr>
                        </thead>
                        <tbody class="table-group-divider">
                            <cfif consulta.recordCount gt 0>
                                <cfoutput query="consulta">
                                    <form method="post" action="fai_reparo.cfm">
                                            <tr class="align-middle">
                                                <td class="text-center">#ID#</td>
                                                <td class="text-center" style="font-size:15px">#USER_COLABORADOR#</td>
                                                <td class="text-center">#VIN#</td>
                                                <td class="text-center">#PECA#</td>
                                                <td class="text-center">#POSICAO#</td>
                                                <td class="text-center">#PROBLEMA#</td>
                                                <td class="text-center">#TIPO_REPARO#</td>
                                                <td class="text-center">#STATUS#</td>
                                                <td style="display:none;">
                                                    <input type="text" class="form-control" name="Tipo" id="formTipo" required>
                                                </td>
                                                <td class="text-nowrap">
                                                    <button class="btn btn-pdi" onclick="self.location='pdi_liberar.cfm?id=#id#&status=LIBERADO'">LIBERAR</button>
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
