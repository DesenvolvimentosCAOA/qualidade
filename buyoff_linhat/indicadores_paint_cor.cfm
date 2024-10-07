<cfif structKeyExists(form, "vin")>
    <cfset consulta1.VIN = form.vin>
</cfif>

<cfquery name="buscaMES" datasource="#BANCOMES#">
    SELECT l.code, l.IDProduct, p.name, l.IDLot, g.IDLot, g.VIN,
           RTRIM(LTRIM(REPLACE(
               REPLACE(
               REPLACE(
               REPLACE(
               REPLACE(
               REPLACE(
               REPLACE(REPLACE(p.name, 'CARROCERIA', ''), 'PINTADA', ''),
               ' FL', ''),
               'COMPLETO ', ''),
               'TXS', 'PL7'),
               'ESCURO', ''),
               'NOVO MOTOR', ''),
               'CINZA', ''))) AS modelo
    FROM TBLLot l
    LEFT JOIN CTBLGravacao g ON l.IDLot = g.IDLot
    LEFT JOIN TBLProduct p ON p.IDProduct = l.IDProduct
    WHERE l.code = <cfqueryparam value="#consulta1.VIN#" cfsqltype="cf_sql_varchar">
    AND p.name LIKE 'CARROCERIA PINTADA%'
</cfquery>

<cfoutput>
    <h1>Resultados da Busca</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Code</th>
                <th>ID Product</th>
                <th>Product Name</th>
                <th>ID Lot (Lot Table)</th>
                <th>ID Lot (Gravacao Table)</th>
                <th>VIN</th>
                <th>Modelo</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="buscaMES">
                <tr>
                    <td>#buscaMES.code#</td>
                    <td>#buscaMES.IDProduct#</td>
                    <td>#buscaMES.name#</td>
                    <td>#buscaMES.IDLot#</td>
                    <td>#buscaMES.IDLot#</td>
                    <td>#buscaMES.VIN#</td>
                    <td>#buscaMES.modelo#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
</cfoutput>
