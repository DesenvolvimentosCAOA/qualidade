<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<!-- Verifica se há dados enviados via formulário -->
<cfif structKeyExists(url, "USER_ID")>
    <!-- Atualiza o registro no banco de dados -->
    <cfquery name="updateUser" datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.reparo_fa_users
        SET USER_SIGN = <cfqueryparam value="#url.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">,
            USER_NAME = <cfqueryparam value="#url.USER_NAME#" cfsqltype="CF_SQL_VARCHAR">,
            USER_PASSWORD = <cfqueryparam value="#url.USER_PASSWORD#" cfsqltype="CF_SQL_VARCHAR">,
            USER_LEVEL = <cfqueryparam value="#url.USER_LEVEL#" cfsqltype="CF_SQL_VARCHAR">,
            SHOP = <cfqueryparam value="#url.SHOP#" cfsqltype="CF_SQL_VARCHAR">
        WHERE USER_ID = <cfqueryparam value="#url.USER_ID#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
</cfif>

<!-- Consulta inicial para exibir os dados -->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.reparo_fa_users
    WHERE 1 = 1
    <cfif isDefined("url.filtroUsuario") AND url.filtroUsuario NEQ "">
        AND UPPER(USER_SIGN) LIKE UPPER('%#url.filtroUsuario#%')
    </cfif>
    ORDER BY USER_NAME ASC
</cfquery>

<!--- Consulta --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.reparo_fa_users
    WHERE 1 = 1 
    <cfif isDefined("url.filtroNivel") and url.filtroNivel neq "">
        AND UPPER(USER_LEVEL) LIKE UPPER('%#url.filtroNivel#%')
    </cfif>
    <cfif isDefined("url.filtroNome") and url.filtroNome neq "">
            AND UPPER(USER_NAME) LIKE UPPER('%#url.filtroNome#%')
        </cfif>
    ORDER BY USER_NAME asc
</cfquery>    



<!--- Deletar Item --->
<cfif structKeyExists(url, "id") and url.id neq "">
    <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.REPARO_FA_USERS WHERE USER_ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
    <script>
        self.location = 'user_edit.cfm';
    </script>
</cfif>



<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Editar Usuário</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
</head>

<body>
    
    <header class="titulo">
        <cfinclude template="auxi/style_edit_login.cfm">
    </header>
    <div class="container mx-auto p-4">
        <h2 class="text-2xl font-bold mb-4">Editar Usuários</h2>
        <cfoutput>
            <form class="filterTable" name="fitro" method="GET">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label" for="filtroNivel">Nível de Acesso:</label>
                        <input type="text" class="form-control" name="filtroNivel" id="filtroNivel" value="<cfif isDefined('url.filtroNivel')>#url.filtroNivel#</cfif>"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="filtroNome">Nome:</label>
                        <input type="text" class="form-control" name="filtroNome" id="filtroNome" value="<cfif isDefined('url.filtroNome')>#url.filtroNome#</cfif>"/>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button class="btn btn-primary mr-2" type="submit">Filtrar</button>
                        <button class="btn btn-warning" type="reset" onclick="self.location='user_edit.cfm'">Limpar</button>
                    </div>
                </div>
            </form>
        </cfoutput>
        <div class="overflow-x-auto">
            <table class="min-w-full bg-white">
                <thead>
                    <tr>
                        <th class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">ID</th>
                        <th style="width: 280px;" class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Nome Completo</th>
                        <th style="width: 180px;" class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Login</th>
                        <th class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Senha</th>
                        <th style="width: 30px;" class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Nível</th>
                        <th class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">SHOP</th>
                        <th class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Salvar</th>
                        <th class="py-2 px-4 bg-gray-200 text-left text-gray-600 font-bold uppercase text-sm">Deletar</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="consulta">
                        <tr id="row-#USER_ID#">
                            <form method="Get" action="user_edit.cfm">
                                <input type="hidden" name="USER_ID" value="#USER_ID#">
                                <td class="py-2 px-4 border-b border-gray-200">#USER_ID#</td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_SIGN" value="#USER_SIGN#" class="border rounded px-2 py-1 w-full">
                                </td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_NAME" value="#USER_NAME#" class="border rounded px-2 py-1 w-full">
                                </td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_PASSWORD" value="#USER_PASSWORD#" class="border rounded px-2 py-1 w-full">
                                </td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_LEVEL" value="#USER_LEVEL#" class="border rounded px-2 py-1 w-full">
                                </td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <input type="text" name="SHOP" value="#SHOP#" class="border rounded px-2 py-1 w-full">
                                </td>
                                <td class="py-2 px-4 border-b border-gray-200">
                                    <button type="submit" class="text-green-500 hover:text-green-700">
                                        <i class="material-icons">save</i>
                                    </button>
                                </td>
                                <td>
                                    <span class="delete-icon-wrapper" onclick="deletar(#USER_ID#);">
                                        <i class="material-icons delete-icon">delete_outline</i>
                                    </span>
                                </td>
                            </form>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        function deletar(id) {
            if (confirm("Tem certeza que deseja deletar este item?")) {
                window.location.href = "user_edit.cfm?id=" + id;
            }
        }
    </script>  
</body>
</html>
