<cfif isDefined("url.id_editar")>
    <cfquery name="consulta_editar" datasource="#BANCOSINC#">
        SELECT * 
        FROM INTCOLDFUSION.ALERTAS_8D
        WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        ORDER BY ID DESC
    </cfquery>
</cfif>

<cfoutput>
    <!-- Tabela com o botão -->
    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Data</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>#consulta_editar.ID#</td>
                <td>#consulta_editar.Nome#</td>
                <td>#consulta_editar.Data#</td>
                <td>
                    <!-- Botão para enviar e-mail -->
                    <button type="button" onclick="self.location='auxi/email.cfm?id_editar=#url.id_editar#'" class="btn btn-success m-2">Enviar e-mail</button>
                </td>
            </tr>
        </tbody>
    </table>
</cfoutput>
