<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<!-- Verifica se há dados enviados via formulário -->
<cfif structKeyExists(form, "USER_ID")>
    <!-- Atualiza o registro no banco de dados -->
    <cfquery name="updateUser" datasource="#BANCOSINC#">
        UPDATE INTCOLDFUSION.reparo_fa_users
        SET USER_SIGN = <cfqueryparam value="#form.USER_SIGN#" cfsqltype="CF_SQL_VARCHAR">,
            USER_NAME = <cfqueryparam value="#form.USER_NAME#" cfsqltype="CF_SQL_VARCHAR">,
            USER_PASSWORD = <cfqueryparam value="#form.USER_PASSWORD#" cfsqltype="CF_SQL_VARCHAR">,
            USER_LEVEL = <cfqueryparam value="#form.USER_LEVEL#" cfsqltype="CF_SQL_VARCHAR">,
            SHOP = <cfqueryparam value="#form.SHOP#" cfsqltype="CF_SQL_VARCHAR">
        WHERE USER_ID = <cfqueryparam value="#form.USER_ID#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
</cfif>

<!-- Define a ordem padrão (crescente) se não estiver definida -->
<cfparam name="url.order" default="ASC">

<!-- Consulta para exibir os dados com ordenação e filtros -->
<cfquery name="consulta" datasource="#BANCOSINC#">
    SELECT *
    FROM INTCOLDFUSION.reparo_fa_users
    WHERE 1 = 1
    <cfif isDefined("url.filtroNivel") AND url.filtroNivel NEQ "">
        AND UPPER(USER_LEVEL) LIKE UPPER('%#url.filtroNivel#%')
    </cfif>
    <cfif isDefined("url.filtroNome") AND url.filtroNome NEQ "">
        AND UPPER(USER_NAME) LIKE UPPER('%#url.filtroNome#%')
    </cfif>
    ORDER BY USER_NAME <cfif url.order EQ "ASC">ASC<cfelse>DESC</cfif>
</cfquery>

<!--- Deletar Item --->
<cfif structKeyExists(url, "id") AND url.id NEQ "">
    <cfquery name="delete" datasource="#BANCOSINC#">
        DELETE FROM INTCOLDFUSION.REPARO_FA_USERS WHERE USER_ID = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>
    <script>
        self.location = 'user_edit.cfm';
    </script>
</cfif>

<!DOCTYPE html>
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

<body class="bg-gray-100">
    <header class="titulo">
        <cfinclude template="auxi/style_edit_login.cfm">
    </header>
    <div class="container mx-auto p-4">
        <!-- Título com estilo clean e profissional -->
        <h2 class="text-3xl font-semibold mb-8 text-gray-800 text-center border-b-2 border-blue-500 pb-3">
            Editar Usuários
        </h2>

        <cfoutput>
            <form class="filterTable bg-white p-6 rounded-lg shadow-md" name="fitro" method="GET">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="filtroNivel">Nível de Acesso:</label>
                        <input type="text" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" name="filtroNivel" id="filtroNivel" value="<cfif isDefined('url.filtroNivel')>#url.filtroNivel#</cfif>"/>
                    </div>
                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="filtroNome">Nome:</label>
                        <input type="text" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" name="filtroNome" id="filtroNome" value="<cfif isDefined('url.filtroNome')>#url.filtroNome#</cfif>"/>
                    </div>
                    <div class="flex items-end space-x-2">
                        <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" type="submit">Filtrar</button>
                        <button class="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-500" type="reset" onclick="self.location='user_edit.cfm'">Limpar</button>
                        <button class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500" type="button" id="report">Download</button>
                    </div>
                </div>
                <!-- Botões de ordenação -->
                <div class="mt-4 flex space-x-2">
                    <button type="button" onclick="setOrder('ASC')" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        A a Z
                    </button>
                    <button type="button" onclick="setOrder('DESC')" class="bg-purple-500 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                        Z a A
                    </button>
                </div>
                <!-- Campo oculto para enviar a ordem -->
                <input type="hidden" name="order" id="order" value="<cfif isDefined('url.order')>#url.order#<cfelse>ASC</cfif>">
            </form>
        </cfoutput>
        <div class="overflow-x-auto mt-6">
            <table class="min-w-full bg-white rounded-lg shadow-md" id="tblStocks">
                <thead class="bg-gray-800 text-white">
                    <tr>
                        <th class="py-3 px-4 text-left text-sm font-semibold uppercase">Nome Completo</th>
                        <th class="py-3 px-4 text-left text-sm font-semibold uppercase">Login</th>
                        <th class="py-3 px-4 text-left text-sm font-semibold uppercase">Senha</th>
                        <th class="py-3 px-4 text-left text-sm font-semibold uppercase">Nível</th>
                        <th class="py-3 px-4 text-left text-sm font-semibold uppercase" style="width: 250px;">SHOP</th>
                        <th class="py-3 px-2 text-center text-sm font-semibold uppercase" style="width: 60px;">Salvar</th>
                        <th class="py-3 px-2 text-center text-sm font-semibold uppercase">Deletar</th>
                    </tr>
                </thead>
                <tbody class="text-gray-700">
                    <cfoutput query="consulta">
                        <tr id="row-#USER_ID#" class="hover:bg-gray-50">
                            <form method="POST" action="user_edit.cfm">
                                <input type="hidden" name="USER_ID" value="#USER_ID#">
                                <td class="py-3 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_SIGN" value="#USER_SIGN#" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm" style="min-width: 300px;">
                                </td>
                                <td class="py-3 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_NAME" value="#USER_NAME#" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm" style="min-width: 200px;">
                                </td>
                                <td class="py-3 px-4 border-b border-gray-200">
                                    <input type="text" name="USER_PASSWORD" value="#USER_PASSWORD#" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm" style="min-width: 150px;">
                                </td>
                                <td class="py-3 px-4 border-b border-gray-200 min-w-24">
                                    <input type="text" name="USER_LEVEL" value="#USER_LEVEL#" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </td>
                                <td class="py-3 px-4 border-b border-gray-200">
                                    <input type="text" name="SHOP" value="#SHOP#" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm" style="min-width: 150px;">
                                </td>
                                <td class="py-3 px-2 border-b border-gray-200 text-center">
                                    <button type="submit" class="text-green-500 hover:text-green-700">
                                        <i class="material-icons">save</i>
                                    </button>
                                </td>
                                <td class="py-3 px-2 border-b border-gray-200 text-center">
                                    <span class="cursor-pointer text-red-500 hover:text-red-700" onclick="deletar(#USER_ID#);">
                                        <i class="material-icons">delete_outline</i>
                                    </span>
                                </td>
                            </form>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </div>
        
        <script>
            function deletar(id) {
                if (confirm("Tem certeza que deseja deletar este item?")) {
                    window.location.href = "user_edit.cfm?id=" + id;
                }
            }

            // Função para definir a ordem e submeter o formulário
            function setOrder(order) {
                document.getElementById('order').value = order;
                document.forms['fitro'].submit();
            }
        </script>  
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
        <script>
            // Gerando Excel da tabela
            var table2excel = new Table2Excel();
            document.getElementById('report').addEventListener('click', function() {
                table2excel.export(document.querySelectorAll('#tblStocks'));
            });
        </script>
    </body>
</html>