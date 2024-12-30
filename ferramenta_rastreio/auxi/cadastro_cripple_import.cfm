<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">

    <cfif isDefined("form.file")>

        <cffile action="upload" 
                destination="#raizpasta#/ArquivosExcel/pcp_paradas" 
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
    <cfelse>

        <font> Erro!, nenhum arquivo foi importado! </font>
    
    </cfif>
    
<cfset file_imp = import.serverfile>


<cfspreadsheet 
    action="read"
    src="#raizpasta#/ArquivosExcel/pcp_paradas/#file_imp#"
    query="importado">
    
<cfset max=importado.RecordCount>   

<cfoutput> 

    <cfloop query="importado" startRow="2" endRow="#max#">


                    <cfquery name="Insere" datasource="#BANCOSINC#">
                     INSERT INTO INTCOLDFUSION.PCP_PARADAS_CRIPPLE (ID,TIPO,DATA,TURNO,HORARIO,MODELO,COR,VIN,ORIGEM,C1,C2,C3,C4,C5)  
                     SELECT NVL(MAX(ID),0) + 1, '#importado.COL_1#', TO_DATE('#lsdateformat('#importado.COL_2#', 'dd/mm/yyyy')#', 'dd/mm/yyyy'), '#importado.COL_3#', '#importado.COL_4#', '#importado.COL_5#', '#importado.COL_6#', '#importado.COL_7#', '#importado.COL_8#', '#importado.COL_9#', '#importado.COL_10#', '#importado.COL_11#', '#importado.COL_13#', '#importado.COL_13#'
                     FROM INTCOLDFUSION.PCP_PARADAS_CRIPPLE
                    </cfquery>

                <br><font style="font-size:18"> Inserida cripple do VIN #importado.COL_7# para #importado.COL_5# no dia #lsdateformat('#importado.COL_2#', 'dd/mm/yyyy')# </font>  <br>
           
    </cfloop>

</cfoutput> 


<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>
<script>
    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "../cadastro_cripple.cfm";
    }
</script>





