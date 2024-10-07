<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">

    <cfif isDefined("form.file")>

        <cffile action="upload" 
                destination="#raizpasta#/ArquivosExcel/"
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
    <cfelse>

        <font> Erro!, nenhum arquivo foi importado! </font>
    
    </cfif>
    
<cfset file_imp = import.serverfile>


<cfspreadsheet 
    action="read"
    src="#raizpasta#/ArquivosExcel/#file_imp#"
    query="importado">
<cfdump var = "#importado#" >
    
<cfset max=importado.RecordCount>

<cfoutput> 

    <cfloop query="importado" startRow="2" endRow="#max#">

        <cfquery name="consulta" datasource="#BANCOSINC#">
           insert into INTCOLDFUSION.KANBAN_LOTES_RESTRICOES ( ID, predio,modelo,partnumber,quantidade,acompanhamento)
           SELECT NVL(MAX(ID),0) + 1, '#importado.COL_1#', '#importado.COL_2#', '#importado.COL_3#', '#importado.COL_4#', '#importado.COL_5#'
                    FROM INTCOLDFUSION.KANBAN_LOTES_RESTRICOES 
          </cfquery>
    </cfloop>

</cfoutput> 


<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>
<script>
    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "../cadastroRestricoes.cfm"
    }
</script>





