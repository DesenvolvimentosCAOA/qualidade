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

<!---          <cfsetting requestTimeOut = "0">

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
    
<cfset max=importado.RecordCount>  --->

<cfoutput>
    <cfloop query="importado" startRow="2" endRow="#max#">
        <!--- Realiza a consulta buscaMES2 usando o valor de #importado.COL_2# --->
        <cfquery name="buscaMES2" datasource="#BANCOMES#">
            SELECT l.code, 
                   l.IDProduct, 
                   p.name, 
                   l.IDLot, 
                   g.IDLot, 
                   g.VIN,
                   RTRIM(LTRIM(REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(
                       REPLACE(REPLACE(p.name, 'CARROCERIA', ''), 'PINTADA', ''),
                               ' FL', ''),
                               'COMPLETO ', ''),
                               'COMPLETA ', ''),
                               'TXS', 'PL7'),
                               'SOLDADO', ''),
                               'SOLDADA', ''),
                               'ESCURO', ''),
                               'NOVO MOTOR', ''),
                               'CINZA', ''),
                               'VELHO', ''))) AS modelo
            FROM TBLLot l
            LEFT JOIN CTBLGravacao g ON l.IDLot = g.IDLot
            LEFT JOIN TBLProduct p ON p.IDProduct = l.IDProduct
            WHERE l.code = '#importado.COL_2#'
              AND p.name LIKE '%CARROCERIA%'
        </cfquery>
        

        <!--- Pega o modelo retornado da consulta buscaMES2 --->
        <cfset modelo = "">
        <cfif buscaMES2.recordcount gt 0>
            <cfset modelo = buscaMES2.modelo>
        </cfif>

        <!--- Insere os dados na tabela com o valor atualizado de modelo --->
        <cfquery name="Insere" datasource="#BANCOSINC#">
            INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_BODY (
                ID, USER_DATA, USER_COLABORADOR, BARCODE, PECA, POSICAO, PROBLEMA, ESTACAO, MODELO, INTERVALO, CRITICIDADE, ULTIMO_REGISTRO, BARREIRA
            )
            SELECT 
                NVL(MAX(ID), 0) + 1,
                SYSDATE, 
                '#importado.COL_1#',
                '#importado.COL_2#',
                '#importado.COL_3#',
                '#importado.COL_4#',
                '#importado.COL_5#',
                '#importado.COL_6#',
                '#modelo#', <!--- Substitui o valor aqui --->
                CASE 
                    WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:00' AND TO_CHAR(SYSDATE, 'HH24:MI') < '15:50' THEN '15:00' 
                    WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '15:50' AND TO_CHAR(SYSDATE, 'HH24:MI') < '16:00' THEN '15:50' 
                    ELSE TO_CHAR(SYSDATE, 'HH24') || ':00' 
                END,
                'N0', 
                SYSDATE, 
                'SUPERFICIE'
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





