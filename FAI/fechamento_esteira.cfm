<cfinvoke  method="inicializando" component="cf.ini.index">

<cfif isDefined("url.filtroData")>
     <cfset url.filtroData = replace(url.filtroData, 'T', ' ')>
<cfelse>
     <cfset url.filtroData = lsdatetimeformat(dateAdd("h", 0, now()),'yyyy-mm-dd')>
</cfif>

<!---  Consultar paradas do dia  --->
<cfquery name="consulta" datasource="#BANCOSINC#">
    
  WITH HORARIO_0 AS 
  (   
      --Sequencia até 50 para gerar ligação na mesma linha nas outras tabelas de horario
      SELECT LEVEL AS SEQ, NULL VIN, NULL INTERVALO, NULL MODELO, NULL RESULT
      FROM DUAL
      CONNECT BY LEVEL <= 50
  ),
  REPARO_FA_VIN_2 AS (
    SELECT * 
    FROM INTCOLDFUSION.REPARO_FA_VIN
    WHERE DATA
        BETWEEN  
            TO_DATE('#url.filtroData# 06:10:00', 'YYYY-MM-DD HH24:MI:SS')
        AND 
            CASE --Trativa para fim do 1 turno
                WHEN TO_CHAR(TO_DATE('#url.filtroData#', 'YYYY-MM-DD'), 'D') BETWEEN 2 AND 5 THEN TO_DATE('#url.filtroData# 15:48:00', 'YYYY-MM-DD HH24:MI:SS')
                WHEN TO_CHAR(TO_DATE('#url.filtroData#', 'YYYY-MM-DD'), 'D') = 6 THEN TO_DATE('#url.filtroData# 14:48:00', 'YYYY-MM-DD HH24:MI:SS')
            END
  ),
  HORARIO_1 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_1, VIN VIN_1, INTERVALO INTERVALO_1,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_1,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_1
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '06:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_2 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_2, VIN VIN_2, INTERVALO INTERVALO_2,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_2,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_2 
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '07:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_3 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_3, VIN VIN_3, INTERVALO INTERVALO_3,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_3,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_3
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '08:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_4 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_4, VIN VIN_4, INTERVALO INTERVALO_4,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_4,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_4
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '09:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_5 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_5, VIN VIN_5, INTERVALO INTERVALO_5,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_5,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
         ELSE 'OK'
      END RESULT_5
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '10:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_6 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_6, VIN VIN_6, INTERVALO INTERVALO_6,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_6,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_6
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '11:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_7 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_7, VIN VIN_7, INTERVALO INTERVALO_7,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_7,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_7
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '12:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_8 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_8, VIN VIN_8, INTERVALO INTERVALO_8,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_8,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_8
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '13:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_9 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_9, VIN VIN_9, INTERVALO INTERVALO_9,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_9,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
           ELSE 'OK'
      END RESULT_9
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE INTERVALO = '14:00'
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  ),
  HORARIO_10 AS 
  ( 
      SELECT ROW_NUMBER() OVER (ORDER BY ID) as SEQ_10, VIN VIN_10, INTERVALO INTERVALO_10,
      CASE WHEN VIN LIKE '95PJ%' THEN 'TL'
           WHEN VIN LIKE '95PZ%' THEN 'HR'
           WHEN VIN LIKE '95PB%' THEN 'T19'
           WHEN VIN LIKE '95PE%' THEN 'T1E'
           WHEN VIN LIKE '95PD%' THEN 'T1A'
      ELSE '' END MODELO_10,
      --Busca situação do VIN no lançamento de reparo
      CASE WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE  NOT in ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'NG'
           WHEN ( SELECT VIN FROM INTCOLDFUSION.REPARO_FA RP WHERE UPPER(TRIM(RP.VIN)) =  UPPER(TRIM(RV.VIN)) AND CRITICIDADE IN ('AV', 'N0') AND ROWNUM = 1 ) IS NOT NULL THEN 'OK!' 
          ELSE 'OK'
      END RESULT_10
      FROM INTCOLDFUSION.REPARO_FA_VIN_2 RV  
      WHERE (INTERVALO = '15:00')
      AND VIN NOT LIKE '95PZ%'
      --AND TRUNC(DATA) = TRUNC(TO_DATE('#url.filtroData#', 'YYYY-MM-DD HH24:MI:SS'))
  )
  SELECT *
  FROM HORARIO_0 H0
  FULL JOIN HORARIO_1 H1 ON H0.SEQ = H1.SEQ_1
  FULL JOIN HORARIO_2 H2 ON H0.SEQ = H2.SEQ_2
  FULL JOIN HORARIO_3 H3 ON H0.SEQ = H3.SEQ_3
  FULL JOIN HORARIO_4 H4 ON H0.SEQ = H4.SEQ_4
  FULL JOIN HORARIO_5 H5 ON H0.SEQ = H5.SEQ_5
  FULL JOIN HORARIO_6 H6 ON H0.SEQ = H6.SEQ_6
  FULL JOIN HORARIO_7 H7 ON H0.SEQ = H7.SEQ_7
  FULL JOIN HORARIO_8 H8 ON H0.SEQ = H8.SEQ_8
  FULL JOIN HORARIO_9 H9 ON H0.SEQ = H9.SEQ_9
  FULL JOIN HORARIO_10 H10 ON H0.SEQ = H10.SEQ_10
  ORDER BY H0.SEQ
</cfquery>

<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>Reparo FA</title>
        <!-- plugins:css -->
        <link rel="icon" type="image/png" href="../assets/img/relatorio.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <!---  Boostrap  --->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        
        <link rel="stylesheet" href="../assets/css/style.css?v=8">
    </head>
    <body>
        <header>
<!---             <cfinclude template="../auxi/nav_links.cfm"> --->
        </header>

        <h4 class="text-center mt-2">Fechamento Esteira - Suv</h4>

        <div class="container col-12 mt-5">

               <!--- Filtro para tabela --->
               <cfoutput>
               <form class="filterTable mt-5" name="fitro" method="GET">
                 <div class="col row">
                   <div class="col-3">
                     <label class="form-label" for="filtroData">Data:</label>
                     <input type="date" class="form-control" name="filtroData" id="filtroData" value="#url.filtroData#"/>    
                   </div>
                   <div class="col-filtro">
                     <button class="btn btn-primary" type="submit">Filtrar</button>
                   </div>
                   <div class="col">
                     <button class="btn btn-warning" type="reset" onclick="self.location='fechamento_esteira.cfm'">Limpar</button>
                   </div>
                 </div>
               </form>
               </cfoutput>
            
            <!--- Tabela--->
            <div class="container col-12 bg-white rounded metas" style="height: 80%; overflow-y: auto;">
              
             <a href="" id="report">Download</a>

              <table border="1" style=""class="table table-hover table-bordered text-center" id="tblStocks" data-excel-name="Veículos" style="border: 1px solid black; border-radius: 10px !important">
                <thead >
                  <tr class="text-nowrap">
                    <th scope="col" colspan="4">1º horário</th>
                    <th scope="col" colspan="4">2º horário</th>
                    <th scope="col" colspan="4">3º horário</th>
                    <th scope="col" colspan="4">4º horário</th>
                    <th scope="col" colspan="4">5º horário</th>
                    <th scope="col" colspan="4">6º horário</th>
                    <th scope="col" colspan="4">7º horário</th>
                    <th scope="col" colspan="4">8º horário</th>
                    <th scope="col" colspan="4">9º horário</th>
                    <th scope="col" colspan="4">10º horário</th>
                  </tr>
                  <tr class="text-nowrap">
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">06:00 - 07:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">07:00 - 08:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">08:00 - 09:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">09:00 - 10:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">10:00 - 11:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">11:00 - 12:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">12:00 - 13:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">13:00 - 14:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">14:00 - 15:00</th>
                    <th scope="col">Result</th>
                    <th scope="col">Seq</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">15:00 - 15:50</th>
                    <th scope="col">Result</th>
                  </tr>
                </thead>
                <tbody class="table-group-divider"><cfoutput>
                  <cfloop query="consulta">

                    <tr class="align-middle">
                      <td>#SEQ_1#</td>
                      <td>#MODELO_1#</td>
                      <td>#VIN_1#</td>
                      <td class="bg-<cfif result_1 eq 'OK'>success<cfelseif result_1 eq 'OK!'>warning<cfelseif result_1 eq 'NG'>danger</cfif>">#RESULT_1#</td>
                    
                      <td>#SEQ_2#</td>
                      <td>#MODELO_2#</td>
                      <td>#VIN_2#</td>
                      <td class="bg-<cfif result_2 eq 'OK'>success<cfelseif result_2 eq 'OK!'>warning<cfelseif result_2 eq 'NG'>danger</cfif>">#RESULT_2#</td>
                    
                      <td>#SEQ_3#</td>
                      <td>#MODELO_3#</td>
                      <td>#VIN_3#</td>
                      <td class="bg-<cfif result_3 eq 'OK'>success<cfelseif result_3 eq 'OK!'>warning<cfelseif result_3 eq 'NG'>danger</cfif>">#RESULT_3#</td>
                    
                      <td>#SEQ_4#</td>
                      <td>#MODELO_4#</td>
                      <td>#VIN_4#</td>
                      <td class="bg-<cfif result_4 eq 'OK'>success<cfelseif result_4 eq 'OK!'>warning<cfelseif result_4 eq 'NG'>danger</cfif>">#RESULT_4#</td>
                    
                      <td>#SEQ_5#</td>
                      <td>#MODELO_5#</td>
                      <td>#VIN_5#</td>
                      <td class="bg-<cfif result_5 eq 'OK'>success<cfelseif result_5 eq 'OK!'>warning<cfelseif result_5 eq 'NG'>danger</cfif>">#RESULT_5#</td>
                    
                      <td>#SEQ_6#</td>
                      <td>#MODELO_6#</td>
                      <td>#VIN_6#</td>
                      <td class="bg-<cfif result_6 eq 'OK'>success<cfelseif result_6 eq 'OK!'>warning<cfelseif result_6 eq 'NG'>danger</cfif>">#RESULT_6#</td>
                    
                      <td>#SEQ_7#</td>
                      <td>#MODELO_7#</td>
                      <td>#VIN_7#</td>
                      <td class="bg-<cfif result_7 eq 'OK'>success<cfelseif result_7 eq 'OK!'>warning<cfelseif result_7 eq 'NG'>danger</cfif>">#RESULT_7#</td>
                    
                      <td>#SEQ_8#</td>
                      <td>#MODELO_8#</td>
                      <td>#VIN_8#</td>
                      <td class="bg-<cfif result_8 eq 'OK'>success<cfelseif result_8 eq 'OK!'>warning<cfelseif result_8 eq 'NG'>danger</cfif>">#RESULT_8#</td>
                      
                      <td>#SEQ_9#</td>
                      <td>#MODELO_9#</td>
                      <td>#VIN_9#</td>
                      <td class="bg-<cfif result_9 eq 'OK'>success<cfelseif result_9 eq 'OK!'>warning<cfelseif result_9 eq 'NG'>danger</cfif>">#RESULT_9#</td>
                      
                      <td>#SEQ_10#</td>
                      <td>#MODELO_10#</td>
                      <td>#VIN_10#</td>
                      <td class="bg-<cfif result_10 eq 'OK'>success<cfelseif result_10 eq 'OK!'>warning<cfelseif result_10 eq 'NG'>danger</cfif>">#RESULT_10#</td>
                    </tr>
                  </cfloop>
                  
                </tbody></cfoutput>
              </table>
            </div>

        </div>
    </body>


    <script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>
  
    <script>
       //Gerando excell da tabela
       var table2excel = new Table2Excel();

       document.getElementById('report').addEventListener('click', function() {
         table2excel.export(document.querySelectorAll('#tblStocks'));
       });

        // Remover cookie de login
      function expire_cookie() {
                var data = new Date(2010,0,01);
                  // Converte a data para GMT
                  data = data.toGMTString();
               document.cookie = 'USER_REPARO_FA=; expires=' + data + '; path=/';
               self.location = 'fechamento_esteira.cfm';
      }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>

    <meta http-equiv="refresh" content="60,URL=fechamento_esteira.cfm">
</html>