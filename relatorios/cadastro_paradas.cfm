<cfinvoke  method="inicializando" component="cf.ini.index">

<!---  Consultar paradas do dia  --->
<cfquery name="consulta_paradas" datasource="#BANCOSINC#">
  SELECT P.*,
  CASE WHEN STATUS = 'PENDENTE' THEN 'danger' ELSE 'success' END COR,
  --Converter segundos para HH:MM:SS
    TO_CHAR(TRUNC(TEMPO / 3600), 'FM00') || ':' ||
    TO_CHAR(TRUNC(MOD(TEMPO, 3600) / 60), 'FM00') || ':' ||
    TO_CHAR(MOD(TEMPO, 60), 'FM00') AS TEMPO2
  FROM INTCOLDFUSION.PCP_PARADAS P 
  WHERE 1 = 1 
  <cfif isDefined("url.filtroData") and url.filtroData neq "">
    AND TO_CHAR(DATA, 'dd/mm/yy') = '#lsdateformat(filtroData, 'dd/mm/yy')#'
  <cfelse>
    AND TRUNC(DATA) =  TRUNC(SYSDATE)
  </cfif>
  <cfif isDefined("url.filtroResponsavel") and url.filtroResponsavel neq "">
    AND RESPONSAVEL LIKE UPPER('%#url.filtroResponsavel#%')
  </cfif>
  <cfif isDefined("url.filtroStatus") and url.filtroStatus neq "">
    AND STATUS ='#url.filtroStatus#'
  </cfif>
  ORDER BY TIPO, --TURNO DESC, 
    CASE WHEN HORARIO = '00-01' THEN '24' 
       ELSE HORARIO
    END DESC, 
  ID DESC
</cfquery>

<!--- Atualizar Status --->
<cfif structKeyExists(url, 'novoStatus') and url.novoStatus neq "">
  <cfquery name="update" datasource="#BANCOSINC#">
    UPDATE INTCOLDFUSION.PCP_PARADAS SET STATUS = '#url.novoStatus#' WHERE ID = '#url.idStatus#'
  </cfquery>
  <script>
    self.location = 'cadastro_paradas.cfm';
  </script>
</cfif>

<!--- Deletar Item --->
<cfif structKeyExists(url, 'id') and url.id neq "">
  <cfquery name="delete" datasource="#BANCOSINC#">
    DELETE FROM INTCOLDFUSION.PCP_PARADAS WHERE ID = '#url.id#'
  </cfquery>
  <script>
    self.location = 'cadastro_paradas.cfm';
  </script>
</cfif>

<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>Monitoramento de Paradas</title>
        <!-- plugins:css -->
        <link rel="icon" type="image/png" href="assets/img/relatorio.png">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <!---  Boostrap  --->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">

        <link rel="stylesheet" href="assets/css/style.css?v=6">
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header><br><br><br>

        <button type="button" onclick="self.location='auxi/email_qa.cfm'" form="form_meta" class="btn btn-success m-2">Enviar e-mail</button>

        <h4 class="text-center mt-2">Cadastro de Paradas</h4>

        <div class="container col-10 mt-5">
            <form id="form_meta"method="POST"><cfoutput>

                <!-- Tipo, data e turno -->
                <div class="row mb-4">
                  
                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formTipo">Tipo</label>
                      <select class="form-control" name="tipo" id="formTipo" required>
                        <option value="SUV">SUV</option>
                        <option value="TRUCK">TRUCK</option>
                      </select>
                    </div>
                  </div>

                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formData">Data</label>
                      <input type="date" name="data" class="form-control" id="formData" value="<cfif isDefined("url.data")>#url.data#<cfelse>#lsdateformat(now(),'yyyy-mm-dd')#</cfif>" required/>
                    </div>
                  </div>

                  
                  <div class="col col-4">
                    <label class="form-check-label">Turno</label>
                    <div class="form-group form-turno">
                      <input type="radio" name="turno" class="form-check-input" id="formTurno1" value="1" checked/>
                      <label class="form-check-label" for="formTurno1">1º Turno</label>
                      <input type="radio" name="turno" class="form-check-input" id="formTurno2" value="2"/>
                      <label class="form-check-label" for="formTurno2">2º Turno</label>
                      <input type="radio" name="turno" class="form-check-input" id="formTurno3" value="3"/>
                      <label class="form-check-label" for="formTurno3">3º Turno</label>
                    </div>
                  </div>

                </div>

                <!-- Horario, Estação, Linha -->
                <div class="row mb-4">

                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formHorario">Horário</label>
                      <select class="form-control" name="horario" id="formHorario"  value="<cfif isDefined("url.horario")>#url.horario#</cfif>" required>
                        <option value="">Selecione o horário:</option>
                        <option value="06-07">06:00-07:00</option>
                        <option value="07-08">07:00-08:00</option>
                        <option value="08-09">08:00-09:00</option>
                        <option value="09-10">09:00-10:00</option>
                        <option value="10-11">10:00-11:00</option>
                        <option value="11-12">11:00-12:00</option>
                        <option value="12-13">12:00-13:00</option>
                        <option value="13-14">13:00-14:00</option>
                        <option value="14-15">14:00-15:00</option>
                        <option value="15-16">15:00-16:00</option>
                        <option value="16-17">16:00-17:00</option>
                        <option value="17-18">17:00-18:00</option>
                        <option value="18-19">18:00-19:00</option>
                        <option value="19-20">19:00-20:00</option>
                        <option value="20-21">20:00-21:00</option>
                        <option value="21-22">21:00-22:00</option>
                        <option value="22-23">22:00-23:00</option>
                        <option value="23-00">23:00-00:00</option>
                        <option value="00-01">00:00-01:00</option>
                        <option value="01-02">01:00-02:00</option>
                        <option value="02-03">02:00-03:00</option>
                        <option value="03-04">03:00-04:00</option>
                        <option value="04-05">04:00-05:00</option>
                        <option value="05-06">05:00-06:00</option>

                      </select>
                    </div>
                  </div>

                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formEstacao">Estação</label>
                      <input type="text" class="form-control" name="estacao" id="formEstacao" placeholder="Informe a estação" required/>
                    </div>
                  </div>

                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formLinha">Linha</label>
                      <input type="text" class="form-control" name="linha" id="formLinha" placeholder="Informe a linha" required/>
                    </div>
                  </div>
                </div>
              
                <!-- Tempo, Responsável e Lider Responsável-->
                <div class="row mb-4">
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formTempo">Tempo</label>
                      <input type="time" step="1" class="form-control" name="tempo" id="formTempo" value="<cfif isDefined('form.tempo')>#form.tempo#</cfif>" required/>
                    </div>
                  </div>
                    
                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formResponsavel">Responsável</label>
                      <input type="text" class="form-control" name="responsavel" id="formResponsavel" placeholder="Informe a Responsável"/>
                    </div>
                  </div>

                  <div class="col">
                    <div class="form-group">
                      <label class="form-label" for="formLider">Líder Responsável</label>
                      <input type="text" class="form-control" name="lider" id="formLider" placeholder="Informe a Líder Responsável"/>
                    </div>
                  </div>
                </div>

                <!-- Tempo, Responsável e Lider Responsável-->
                <div class="row mb-4">
                  <div class="col-8">
                    <div class="form-group">
                      <label class="form-label" for="formDescricao">Descrição</label>
                      <input type="text" class="form-control" name="descricao" id="formDescricao" placeholder="Descreva a parada" required/>
                    </div>
                  </div>
                  <div class="col col-4">
                    <div class="form-group">
                      <label class="form-label" for="formStatus">Status</label>
                      <select class="form-control" name="status" id="formStatus" required>
                        <option value="OK">OK</option>
                        <option value="PENDENTE">PENDENTE</option>
                      </select>
                    </div>
                  </div>
                </div>

            </form></cfoutput>

            <!--- Transformar tudo em segundos --->
            <cfif isDefined("form.tempo")>
              <cfset partesTempo = ListToArray(form.tempo, ":")>

              <cfset horas = Val(partesTempo[1])>
              <cfset minutos = Val(partesTempo[2])>
              <cfset segundos = Val(partesTempo[3])>

              <cfset totalSegundos = (horas * 3600) + (minutos * 60) + segundos>
            </cfif>

            <div class="bt_ms">
              <button type="submit" form="form_meta" class="btn btn-primary">Adicionar</button>

              <cfif isDefined("form.descricao") and form.descricao neq "">
                
                <cfquery name="insert" datasource="#BANCOSINC#">
                  INSERT INTO INTCOLDFUSION.PCP_PARADAS (ID,TIPO,DATA,TURNO,HORARIO,ESTACAO,LINHA,TEMPO,RESPONSAVEL,LIDER,DESCRICAO,STATUS)  
                  SELECT NVL(MAX(ID),0) + 1, '#form.tipo#', TO_DATE('#lsdateformat(form.data, 'dd/mm/yyyy')#', 'dd/mm/yyyy'), '#form.turno#', '#form.horario#', '#form.estacao#', '#form.linha#', '#totalSegundos#',  '#form.responsavel#', '#form.lider#', '#form.descricao#', '#form.status#'
                  FROM INTCOLDFUSION.PCP_PARADAS
                </cfquery>

                <div class="alert alert-success" role="alert">
                  Cadastrado com sucesso
                </div>
                <meta http-equiv="refresh" content="1.5, url=cadastro_paradas.cfm">
              </cfif>


              <!--- Importar Meta via Arquivo excell --->
              <form action="auxi/cadastro_paradas_import.cfm" method="post" enctype="multipart/form-data" name="form2" class="import">
                <div class="mb-3 input-group">
                  <input class="form-control" type="file" id="formFile" name="file">
                  <button class="btn btn-primary m-0" type="submit">Enviar</button>
                </div>
                <label for="formFile" class="form-label">Importar Peças Via Excel (Colunas devem estar em ordem conforme tabela abaixo)</label>
              </form>

            </div>

            <!--- Filtro para tabela --->
            <cfoutput>
            <form class="filterTable mt-5" name="fitro" method="GET">
              <div class="col row">
                <div class="col-2 col-data">
                  <label class="form-label" for="filtroData">Data:</label>
                  <input type="date" class="form-control" name="filtroData" id="filtroData" value="<cfif isDefined("url.filtroData")>#url.filtroData#<cfelse>#lsdateformat(now(),'YYYY-MM-DD')#</cfif>"/>    
                </div>
                <div class="col-2">
                  <label class="form-label" for="filtroStatus">Status:</label>   
                  <select class="form-control" name="filtroStatus" id="filtroStatus">
                    <cfif isDefined("url.filtroStatus")>
                      <option value="#url.filtroStatus#">#url.filtroStatus#</option>
                    <cfelse>
                      <option value=""></option>
                    </cfif>
                    <option value="OK">OK</option>
                    <option value="PENDENTE">PENDENTE</option>
                  </select>
                </div>
                <div class="col-2 peca_filtro">
                  <label class="form-label" for="filtroResponsavel">Responsável:</label>
                  <input type="text" class="form-control" name="filtroResponsavel" id="filtroResponsavel" value="<cfif isDefined("url.filtroResponsavel")>#url.filtroResponsavel#</cfif>"/>    
                </div>
                <div class="col-filtro">
                  <button class="btn btn-primary" type="submit">Filtrar</button>
                </div>
                <div class="col">
                  <button class="btn btn-warning" type="reset" onclick="self.location='cadastro_paradas.cfm'">Limpar</button>
                </div>
              </div>
            </form>
            </cfoutput>


            <!--- Tabelas com as paradas do dia--->
            <div class="container col-12 bg-white rounded metas">
              <table class="table">
                <thead>
                  <tr class="text-nowrap">
                    <th scope="col">Tipo</th>
                    <th scope="col">Data</th>
                    <th scope="col">Turno</th>
                    <th scope="col">Horário</th>
                    <th scope="col">Estação</th>
                    <th scope="col">Linha</th>
                    <th scope="col">Tempo</th>
                    <th scope="col">Responsável</th>
                    <th scope="col">Líder</th>
                    <th scope="col">Descrição</th>
                    <th scope="col">Status</th>
                    <th scope="col"><i style="font-size: 20px;" class="mdi mdi-pencil"></i></th>
                    <th scope="col"><i class="mdi mdi-delete"></i></th>
                  </tr>
                </thead>
                <tbody class="table-group-divider"><cfoutput>
                  <cfloop query="consulta_paradas">
                    <tr class="align-middle">
                      <td>#tipo#</td>
                      <td>#lsdateformat(data, 'dd/mm/yyyy')#</td>
                      <td>#turno#º</td>
                      <td>#horario#</td>
                      <td>#estacao#</td>
                      <td>#linha#</td>
                      <td>#tempo2#</td>
                      <td>#responsavel#</td>
                      <td>#lider#</td>
                      <th>#descricao#</th>

                      <!--- Editar Status --->
                      <th class="bg-#cor#"> 
                        <select class="form-control" name="status" oninput="alterarStatus(this,#id#)" required>
                          <option value="#status#" selected>#status#</option>
                          <option value="OK">OK</option>
                          <option value="PENDENTE">PENDENTE</option>
                        </select>
                      </th>

                      <th scope="row"><i onclick="self.location='editar_paradas.cfm?id_editar=#id#';" class="mdi mdi-pencil-outline" style="font-size: 25px; cursor: pointer"></i></th>
                      <th scope="row"><i onclick="deletar(#id#);" class="mdi mdi-delete-outline"></i></th>
                    </tr>
                  </cfloop>
                </tbody></cfoutput>
              </table>
            </div>

        </div>
    </body>

    <script>
      const deletar = (id, peca, data) => {
        conf = confirm('Deseja realmente apagar esse item?');
        if(conf == true){
          self.location = 'cadastro_paradas.cfm?id='+id
        }
      }

      // Selecionar horario automaticamento de acordo com hora atual

      horarios = document.getElementById("formHorario");
          for (i = 0; i < horarios.children.length; i++) {
            horaAtual  = new Date();

            horario = horarios[i].value.substr(0,2)
            horaAtual = horaAtual.toString().substr(16,2)

            if(horario.includes(horaAtual)){
              horarios[i].selected = "selected"
              // console.log('Ok' + horario)
            }
      }

      // Alterar status da parada
      function alterarStatus(el, idStatus) {
        var novoStatus = el.value;
        self.location = 'cadastro_paradas.cfm?idStatus='+idStatus +'&novoStatus='+novoStatus;
        // console.log(el, snovoStatus);
      }

      // Remover cookie de login
      function expire_cookie() {
                var data = new Date(2010,0,01);
                  // Converte a data para GMT
                  data = data.toGMTString();
               document.cookie = 'USER_PCP_PARADAS_ADM=; expires=' + data + '; path=/';
               self.location = 'cadastro_paradas.cfm';
      }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>