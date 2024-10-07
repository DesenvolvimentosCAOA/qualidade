<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">

    <cfif isDefined("form.file")>

        <cffile action="upload" 
                destination="C:/Users/jefferson.teixeira/Downloads/ArquivosExcel/" 
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
    <cfelse>

        <font> Erro!, nenhum arquivo foi importado! </font>
    
    </cfif>
    
<cfset file_imp = import.serverfile>

<cfspreadsheet 
    action="read"
    src="C:/Users/jefferson.teixeira/Downloads/ArquivosExcel/#file_imp#"
    query="importado">
    
<cfset max=importado.RecordCount>

<cfoutput> 
    <cfloop query="importado" startRow="2" endRow="#max#">
        <!--- Verifica se o VIN já existe na tabela --->
        <cfquery name="valida" datasource="#BANCOSINC#">
            SELECT * FROM INTCOLDFUSION.MASSIVA_FAI WHERE VIN = <cfqueryparam value="#importado.COL_1#" cfsqltype="cf_sql_varchar">
        </cfquery>
    
        <!--- Se o VIN não existe, insere um novo registro --->
        <cfif valida.recordCount eq 0>
    
            <cfquery name="Insere" datasource="#BANCOSINC#">
                INSERT INTO INTCOLDFUSION.MASSIVA_FAI (ID, VIN, USER_DATA)
                SELECT NVL(MAX(ID),0) + 1, 
                       <cfqueryparam value="#importado.COL_1#" cfsqltype="cf_sql_varchar">, 
                       SYSDATE
                FROM INTCOLDFUSION.MASSIVA_FAI
            </cfquery>
    
            <br><font style="font-size:18"> Inserido: #importado.COL_1# </font>  <br>
    
        <!--- Caso o VIN já exista, exibe uma mensagem --->
        <cfelse>
            <br><font style="font-size:18; color: red"> Já existe: #importado.COL_1# no banco de dados</font>  <br>
        </cfif>
    
    </cfloop>
    
</cfoutput> 


<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>
<script>
    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "../cadastro_defeitos.cfm"
    }
</script>





