<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">
    
        <cfif isDefined("form.file")>
    
            <cffile action="upload" 
                destination="#raizpasta#/qualidade/" 
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
        <cfelse>
    
            <font> Erro!, nenhum arquivo foi importado! </font>
    
        </cfif>
        
    <cfset file_imp = import.serverfile>
    <cfspreadsheet 
        action="read"
        src="#raizpasta#/qualidade/#file_imp#"
        query="importado">
        
    <cfset max=importado.RecordCount>

<!--- essa linha é pra teste salvar o arquivo no meu pc--->

<!---<cfsetting requestTimeOut = "0">

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
    
<cfset max=importado.RecordCount> --->

<cfoutput>
    <cfloop query="importado" startRow="2" endRow="#max#">
            <cfquery name="Insere" datasource="#BANCOSINC#">
                INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_BODY (ID, USER_DATA, USER_COLABORADOR, BARCODE, PECA, POSICAO, PROBLEMA, ESTACAO, MODELO, INTERVALO, CRITICIDADE, ULTIMO_REGISTRO, BARREIRA)
                SELECT NVL(MAX(ID),0) + 1,
                SYSDATE, '#importado.COL_1#', '#importado.COL_2#', '#importado.COL_3#', '#importado.COL_4#', '#importado.COL_5#','#importado.COL_6#','#importado.COL_7#', '#importado.COL_8#','N0', SYSDATE, 'SUPERFICIE'
                FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
            </cfquery>
            <br><font style="font-size:18"> Inserido: #importado.COL_3#</font>  <br>
    </cfloop>
</cfoutput> 


<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>
<script>
    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "../cadastro_defeitos.cfm"
    }
</script>





