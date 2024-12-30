<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">

    <cfif isDefined("form.file")>

        <cffile action="upload" 
                destination="C:\ColdFusion2018\cfusion\wwwroot\cf\auth\monitor\joballotment\assets\docs\" 
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
    <cfelse>

        <font> Desculpe 😓, ocorreu um erro! Não conseguimos localizar o arquivo. Por favor, fique tranquilo, isso significa que o arquivo não foi importado. 😅 </font>
    
    </cfif>
    
<cfset file_imp = import.serverfile>


<cfspreadsheet 
    action="read"
    src="C:\ColdFusion2018\cfusion\wwwroot\cf\auth\monitor\joballotment\assets\docs\#file_imp#"
    query="importado">
    
<cfset max=importado.RecordCount>   

<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>

<script>

    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "cadastrar.cfm";
    }

</script>

<cfoutput> 

         <cfloop query="importado" startRow="4">

            <cfquery name="buscaMaxID" datasource="SINCPROD">

            select nvl(max(ID), 0) as ID from intcoldfusion.joballotment

            </cfquery>

            <cfquery name="bancoURLs" datasource="SINCPROD">

            select * from intcoldfusion.joballotment where part_number = '#importado.COL_6#'

            </cfquery>

            <cfif bancoURLs.RecordCount EQ 0>

                    <cfquery name="Insere" datasource="SINCPROD">
                     INSERT INTO INTCOLDFUSION.joballotment 
                     (
                       ID,
                       SEQ,
                       DATA_REVISAO_IT,
                       AREA_PRODUTIVA,
                       IT,
                       TITULO_OPERACAO,
                       PART_NUMBER,
                       PART_NAME,
                       VERSAO,
                       ESTACAO,
                       LADO,
                       GRUPO_DE_ENVIO,
                       RANGE,
                       T1E_1_6_ADAS,
                       T1E_1_5_48v_ADAS,
                       XXX,
                       XXXX,
                       XXXXX,
                       STATUS_OBSERVACAO
                    )  
                        
                    VALUES
                    
                    (
                         #buscaMaxID.ID+1#,
                        '#importado.COL_1#',
                        '#importado.COL_2#',
                        '#importado.COL_3#',
                        '#importado.COL_4#',
                        '#importado.COL_5#',
                        '#importado.COL_6#',
                        '#importado.COL_7#',
                        '#importado.COL_8#',
                        '#importado.COL_9#',
                        '#importado.COL_10#',
                        '#importado.COL_11#',
                        '#importado.COL_12#',
                        '#importado.COL_13#',
                        '#importado.COL_14#',
                        '#importado.COL_15#',
                        '#importado.COL_16#',
                        '#importado.COL_17#',
                        '#importado.COL_18#'
                    )

                    </cfquery>

            <br><font style="font-size:18"> O Part Number #importado.COL_1# foi inserido com sucesso ✅</font><br>

            <cfelse>

            <br><font style="font-size:18"> A rotina #importado.COL_1# já existe. Portando não foi inserido novamente. 😉</font><br>

        </cfif>

    </cfloop>

</cfoutput> 





