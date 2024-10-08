<html>
    <head>
        <title>Copiar Dados para temp_barcode_vin</title>
    </head>
    <body>
        <form method="post">
            <input type="submit" name="executarCopia" value="Copiar Dados">
        </form>
    
        <cfif structKeyExists(form, "executarCopia")>
            <!-- Passo 1: Recuperar os dados de BANCOMES com filtro para DTCreation -->
            <cfquery name="dados" datasource="#BANCOMES#">
                SELECT g.VIN, l.code AS BARCODE, g.IDProduct
                FROM CTBLGravacao g
                LEFT JOIN TBLLot l ON g.IDLot = l.IDLot
                LEFT JOIN TBLProduct p ON g.IDProduct = p.IDProduct
                WHERE p.name LIKE 'CONJUNTO%'
                  AND g.DTCreation = <cfqueryparam value="2024-08-19" cfsqltype="cf_sql_date">
            </cfquery>
    
            <!-- Passo 2: Inserir os dados na tabela temp_barcode_vin no BANCOSINC -->
            <cfloop query="dados">
                <cfquery datasource="#BANCOSINC#">
                    INSERT INTO temp_barcode_vin (IDProduct, BARCODE, VIN)
                    VALUES (
                        <cfqueryparam value="#dados.IDProduct#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#dados.BARCODE#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#dados.VIN#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
            </cfloop>
    
            <!-- Mensagem de confirmação -->
            <cfoutput>Dados copiados com sucesso para a tabela temp_barcode_vin.</cfoutput>
        </cfif>
    </body>
    </html>
    