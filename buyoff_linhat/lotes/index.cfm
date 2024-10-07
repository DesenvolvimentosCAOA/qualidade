<cfinvoke  method="inicializando" component="cf.ini.index">

<!--- Buscando dados da consulta de entrada Hora a Hora e metas PCP --->
<cfinvoke  component="cf.dashboard-novo.horaAhora._consultaEntrada" method="horaAhora" returnvariable="horaAhora">

<cfinvoke component="cf.dashboard-novo.horaAhora._consultaEntrada" method="buscaMetas" returnvariable="buscaMetas">

<!--- Buscando dados da consulta de entrada Hora a Hora e metas PCP --->
<cfinvoke  component="cf.dashboard-novo.horaAhora._consultaEntrada2" method="horaAhora" returnvariable="horaAhora2">

<cfinvoke component="cf.dashboard-novo.horaAhora._consultaEntrada2" method="buscaMetas" returnvariable="buscaMetas2">

<!---   <cfdump  var="#horaAhora#">
  <cfdump  var="#horaAhora2#">
  
  Busca Meta
  <cfdump  var="#buscaMetas#">
  <cfdump  var="#buscaMetas2#"> --->

<cfquery dbtype="query" name="horaAhoraComMeta1">
  select horaAhora.*, buscaMetas.valor as meta
  from horaAhora, buscaMetas
  where buscaMetas.predio = horaAhora.predio
  and buscaMetas.PI = horaAhora.PRODU
</cfquery>

<cfquery dbtype="query" name="horaAhoraComMeta2">
  select horaAhora2.*, buscaMetas2.valor as meta
  from horaAhora2, buscaMetas2
  where buscaMetas2.predio = horaAhora2.predio
  and buscaMetas2.PI = horaAhora2.PRODU
</cfquery>

<!--- Soma das metas e produção 1º e 2º Turno --->
<cfquery dbtype="query" name="horaAhoraComMeta">
  select horaAhoraComMeta1.predio, horaAhoraComMeta1.PRODU, horaAhoraComMeta2.predio, horaAhoraComMeta2.PRODU,
  (horaAhoraComMeta1.TOTAL+horaAhoraComMeta2.TOTAL)  TOTAL, (horaAhoraComMeta1.meta+horaAhoraComMeta2.meta) meta
  from horaAhoraComMeta1, horaAhoraComMeta2
  where horaAhoraComMeta1.predio = horaAhoraComMeta2.predio
  and horaAhoraComMeta1.PRODU = horaAhoraComMeta2.PRODU
</cfquery>


<!---  Consulta --->
<cfquery name="consulta_kits" datasource="#BANCOSINC#">
  SELECT L.*, KDISPONIVEIS - KRESTRICAO KSEMRESTRICAO,
  CASE WHEN MODELO LIKE 'T1%' THEN 'CHERY' ELSE 'HYUNDAI' END MARCA,
  CASE WHEN MODELO LIKE 'C%' THEN 1 WHEN MODELO LIKE 'TL%' THEN 2 ELSE 3 END ORDEM
  FROM INTCOLDFUSION.KANBAN_LOTES L 
  ORDER BY PREDIO, MODELO, ID DESC
</cfquery>

<cfquery dbtype="query" name="consulta_final">
  SELECT * FROM horaAhoraComMeta, consulta_kits
  where horaAhoraComMeta.predio = consulta_kits.predio
  and horaAhoraComMeta.PRODU = consulta_kits.modelo
  ORDER BY PREDIO, ORDEM, MODELO, ID DESC
</cfquery>


<!--- Totais --->
<cfquery name="total_body_marca" dbtype="query">
  select predio, marca, 
  sum(TOTAL) TOTAL, sum(META) META, sum(KDISPONIVEIS) KDISPONIVEIS, sum(KRESTRICAO) KRESTRICAO, sum(KSEMRESTRICAO) KSEMRESTRICAO from consulta_final 
  where predio = 'Body Shop' and marca = 'CHERY'
  group by predio, marca
  union all
  select predio, marca, 
  max(TOTAL) TOTAL, max(META) META, max(KDISPONIVEIS) KDISPONIVEIS, max(KRESTRICAO) KRESTRICAO, max(KSEMRESTRICAO) KSEMRESTRICAO from consulta_final 
  where predio = 'Body Shop' and marca = 'HYUNDAI'
  group by predio, marca
</cfquery>

<cfquery name="total_body" dbtype="query">
  select predio, 'TOTAL' marca,
  sum(TOTAL) TOTAL, sum(META) META, sum(KDISPONIVEIS) KDISPONIVEIS, sum(KRESTRICAO) KRESTRICAO, sum(KSEMRESTRICAO) KSEMRESTRICAO from total_body_marca 
  group by predio
</cfquery>


<cfquery name="total_trim_marca" dbtype="query">
  select predio, marca, 
  sum(TOTAL) TOTAL, sum(META) META, sum(KDISPONIVEIS) KDISPONIVEIS, sum(KRESTRICAO) KRESTRICAO, sum(KSEMRESTRICAO) KSEMRESTRICAO from consulta_final 
  where predio = 'Trim Shop' and marca = 'CHERY'
  group by predio, marca
  union all
  select predio, marca, 
  max(TOTAL) TOTAL, max(META) META, max(KDISPONIVEIS) KDISPONIVEIS, max(KRESTRICAO) KRESTRICAO, max(KSEMRESTRICAO) KSEMRESTRICAO from consulta_final 
  where predio = 'Trim Shop' and marca = 'HYUNDAI'
  group by predio, marca
</cfquery>

<cfquery name="total_trim" dbtype="query">
  select predio, 'TOTAL' marca,
  sum(TOTAL) TOTAL, sum(META) META, sum(KDISPONIVEIS) KDISPONIVEIS, sum(KRESTRICAO) KRESTRICAO, sum(KSEMRESTRICAO) KSEMRESTRICAO from total_trim_marca 
  group by predio
</cfquery>

<!--- Consulta Restrições --->
<cfquery dbtype="query" name="consulta_restricoes">
  SELECT * FROM consulta_kits
  WHERE RESTRICOES IS NOT NULL
</cfquery>

<html>
<head>
  <title>Kanban Lotes</title> 
  <link rel="icon" type="image/png" href="auxi/kanban.png">
  <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
  <link rel="stylesheet" href="auxi/style.css?v=6">
  <!---  Boostrap  --->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">

  <style>
   
  </style>
</head>
<body>
<cfoutput>

   <header>
       <cfinclude template="auxi/nav_links.cfm">
   </header>

  <div class="container m-2" style="max-width:fit-content">

    <div class="legenda mt-4">

        <div class="legenda-item">
          <div class="verde" style="border-radius: 50%"></div>
          <span>Atende</span>
        </div>

        <div class="legenda-item">
          <div class="amarelo" style="border-radius: 50%"></div>
          <span>Atende Parcialmente</span>
        </div>
        
        <div class="legenda-item">
          <div class="vermelho" style="border-radius: 50%"></div>
          <span>Não Atende</span>
        </div>
    </div>

    <div class="d-flex row mt-5">

      <!--- Produção do dia D+0 --->
        <div class="table-responsive col">
            <p>
                <b>Body Shop</b> - #lsdateformat(now(),'dd/mm/yyyy')#
            </p>
            <table class="table table-bordered text-center">
                <thead>
                  <tr class="bg-primary text-white align-middle">
                    <th scope="col">Modelo</th>
                    <th scope="col">Programa do Dia</th>
                    <th scope="col">Entradas Produção</th>
                    <th scope="col">Kits Disponíveis</th>
                    <th scope="col">Kits com Restrição</th>
                    <th scope="col">Kits sem Restrição</th>
                    <th scope="col">KANBAN</th>
                  </tr>
                </thead>

                <tbody>

                  <cfloop query="#consulta_final#">

                    <cfif PREDIO eq 'Body Shop'>
                      <!--- Valores de kits disponiveis e sem restrição descontando os produzidos em tempo real --->
                      <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                      <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                      <cfset METAREAL = META - TOTAL>
                      <tr class="text-nowrap">
                          <td>#PRODU#</td>
                          <td>#META#</td>
                          <td>#TOTAL#</td>
                          <td>#KDISPONIVEISREAL#</td>
                          <td class="text-danger"  onclick="self.location='restricoes.cfm?filtroModelo=#PRODU#'" style="cursor: pointer">#KRESTRICAO#</td>
                          <td class="text-primary">#KSEMRESTRICAOREAL#</td>
                          <!--- Se não tiver kits disponiveis em tempo real, vermelho, se tiver algum kit mais não atender o programa do dia, amarelo --->
                          <td class="d-flex justify-content-center">
                            <div style="border-radius: 60%; width: 30px; height: 30px" class="<cfif KDISPONIVEISREAL LTE 0>bg-danger<cfelseif KDISPONIVEISREAL GT 0 and KDISPONIVEISREAL LT METAREAL>bg-warning<cfelse>bg-success</cfif>"></div>
                          </td>
                      </tr>
                    </cfif>

                  </cfloop>

                  <!--- Linha de Totais, por marca e geral--->
                    <cfloop query="#total_body_marca#">

                        <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                        <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                        <cfset METAREAL = META - TOTAL>
                        <tr class="text-nowrap" style="font-weight: bold">
                            <td>#MARCA#</td>
                            <td>#META#</td>
                            <td>#TOTAL#</td>
                            <td>#KDISPONIVEISREAL#</td>
                            <td>#KRESTRICAO#</td>
                            <td>#KSEMRESTRICAOREAL#</td>
                            <cfif MARCA EQ "CHERY">
                              <td rowspan="3"></td>
                            </cfif>
                        </tr>
                    </cfloop>

                    <cfloop query="#total_body#">
                      <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                      <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                      <cfset METAREAL = META - TOTAL>
                      <tr class="text-nowrap bg-primary text-white" style="font-weight: bold">
                          <td>#MARCA#</td>
                          <td>#META#</td>
                          <td>#TOTAL#</td>
                          <td>#KDISPONIVEISREAL#</td>
                          <td>#KRESTRICAO#</td>
                          <td>#KSEMRESTRICAOREAL#</td>
                          <cfif MARCA EQ "CHERY">
                            <td rowspan="3"></td>
                          </cfif>
                      </tr>
                    </cfloop>

                </tbody>
            </table>

            <!---     Restrições BODY      
            <p class="mt-4">
              <b>Restrições</b>
            </p>
            <table class="table table-bordered">
                <thead>
                  <tr class="bg-primary text-white align-middle">
                    <th scope="col">Modelo</th>
                    <th scope="col">Restrição</th>
                  </tr>
                </thead>

                <tbody>

                  <cfloop query="#consulta_restricoes#">
                    <cfif PREDIO eq 'Body Shop'>
                      <tr class="align-middle" style="font-weight: bold;">
                          <td class="text-center">#MODELO#</td>
                          <!--- <td><span class="hovertext" data-hover="#RESTRICOES#">#RESTRICOES#</span></td> --->
                          <td>#RESTRICOES#</td>
                      </tr>
                    </cfif>
                  </cfloop>

                </tbody>
            </table>   --->
        </div>

        <div class="table-responsive col">
            <p>
              <b>Trim Shop</b> - #lsdateformat(now(),'dd/mm/yyyy')#
            </p>
            <table class="table table-bordered text-center">
              <thead>
                <tr class="bg-primary text-white align-middle">
                    <th scope="col">Modelo</th>
                    <th scope="col">Programa do Dia</th>
                    <th scope="col">Entradas Produção</th>
                    <th scope="col">Kits Disponíveis</th>
                    <th scope="col">Kits com Restrição</th>
                    <th scope="col">Kits sem Restrição</th>
                    <th scope="col">KANBAN</th>
                </tr>
              </thead>

              <tbody>

                <cfloop query="#consulta_final#">

                  <cfif PREDIO eq 'Trim Shop'>
                    <!--- Valores de kits disponiveis e sem restrição descontando os produzidos em tempo real --->
                    <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                    <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                    <cfset METAREAL = META - TOTAL>
                    <tr class="text-nowrap">
                        <td>#PRODU#</td>
                        <td>#META#</td>
                        <td>#TOTAL#</td>
                        <td>#KDISPONIVEISREAL#</td>
                        <td class="text-danger"  onclick="self.location='restricoes.cfm?filtroModelo=#PRODU#'" style="cursor: pointer">#KRESTRICAO#</td>
                        <td class="text-primary">#KSEMRESTRICAOREAL#</td>
                        <!--- Se não tiver kits disponiveis em tempo real, vermelho, se tiver algum kit mais não atender o programa do dia, amarelo --->
                        <td class="d-flex justify-content-center">
                          <div style="border-radius: 60%; width: 30px; height: 30px" class="<cfif KDISPONIVEISREAL LTE 0>bg-danger<cfelseif KDISPONIVEISREAL GT 0 and KDISPONIVEISREAL LT METAREAL>bg-warning<cfelse>bg-success</cfif>"></div>
                        </td>
                    </tr>
                  </cfif>

                </cfloop>

                <!--- Linha de Totais, por marca e geral--->
                <cfloop query="#total_trim_marca#">

                  <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                  <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                  <cfset METAREAL = META - TOTAL>
                  <tr class="text-nowrap <cfif marca contains 'TOTAL'>bg-primary text-white</cfif>" style="font-weight: bold">
                      <td>#MARCA#</td>
                      <td>#META#</td>
                      <td>#TOTAL#</td>
                      <td>#KDISPONIVEISREAL#</td>
                      <td>#KRESTRICAO#</td>
                      <td>#KSEMRESTRICAOREAL#</td>
                      <cfif MARCA EQ "CHERY">
                        <td rowspan="3"></td>
                      </cfif>
                      <!--- Se não tiver kits disponiveis em tempo real, vermelho, se tiver algum kit mais não atender o programa do dia, amarelo --->
                      <!--- <td class="<cfif KDISPONIVEISREAL LTE 0>bg-danger<cfelseif KDISPONIVEISREAL GT 0 and KDISPONIVEISREAL LT METAREAL>bg-warning<cfelse>bg-success</cfif>"></td> --->
                  </tr>

                </cfloop>

                <cfloop query="#total_trim#">
                  <cfset KDISPONIVEISREAL = KDISPONIVEIS - TOTAL>
                  <cfset KSEMRESTRICAOREAL = KDISPONIVEISREAL - KRESTRICAO>
                  <cfset METAREAL = META - TOTAL>
                  <tr class="text-nowrap bg-primary text-white" style="font-weight: bold">
                      <td>#MARCA#</td>
                      <td>#META#</td>
                      <td>#TOTAL#</td>
                      <td>#KDISPONIVEISREAL#</td>
                      <td>#KRESTRICAO#</td>
                      <td>#KSEMRESTRICAOREAL#</td>
                      <cfif MARCA EQ "CHERY">
                        <td rowspan="3"></td>
                      </cfif>
                  </tr>
                </cfloop>


              </tbody>
          </table>

           <!---     Restrições TRIM      
           <p class="mt-4">
            <b>Restrições</b>
          </p>
          <table class="table table-bordered">
              <thead>
                <tr class="bg-primary text-white align-middle">
                  <th scope="col">Modelo</th>
                  <th scope="col">Restrição</th>
                </tr>
              </thead>

              <tbody>

                <cfloop query="#consulta_restricoes#">
                  <cfif PREDIO eq 'Trim Shop'>
                    <tr class="align-middle" style="font-weight: bold">
                        <td class="text-center">#MODELO#</td>
                        <td>#RESTRICOES#</td>
                    </tr>
                  </cfif>
                </cfloop>

              </tbody>
          </table>   --->
      </div>
    </div>
    
  </div>

</cfoutput>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</body>
</html>
