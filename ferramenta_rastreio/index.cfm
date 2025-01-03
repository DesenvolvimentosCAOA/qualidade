<cfinvoke method="inicializando" component="cf.ini.index">

    <cfquery name="buscaHistorico" datasource="#BANCOSINC#" maxRows="10">
        SELECT * 
        FROM intcoldfusion.ferramenta_rastreio
        ORDER BY data_save DESC
    </cfquery>

<cfif not isDefined("cookie.userCall")>
    <script>
        alert("Você precisa estar logado para acessar essa página");
        window.location.href="login_rastreio/index.cfm";
    </script>
</cfif>

<cfif isDefined("form.cod")>
    <cfquery name="buscaMES" datasource="#BANCOMES#">
        SELECT PRO.IDPRODUCT, pro.code, 
               REPLACE(pro.name, 'CONJUNTO TRIM ', '') AS name 
        FROM pcf4..tblproduct PRO
        WHERE IDPRODUCT = (SELECT GRAV.IDPRODUCT 
                           FROM PCF4..CTBLGRAVACAO GRAV
                           WHERE VIN = '#FORM.COD#') 
    </cfquery>

    <cfif buscaMES.recordcount EQ 0>
        <script>
            alert("Vin inválido ou campo vazio");
            window.location.href="index.cfm";
        </script>
    </cfif>
</cfif>

<cfif isDefined("form.cod") AND isDefined("form.etiqv") AND form.etiqv NEQ ''>
    <!-- Valida se já existe o código presente dentro do banco -->
    <cfquery name="buscaExistente" datasource="#BANCOSINC#">
        SELECT vin, modelo
        FROM intcoldfusion.ferramenta_rastreio
        WHERE VIN = <cfqueryparam value="#trim(form.cod)#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>

    <cfif buscaExistente.recordcount GT 0>
        <script>
            alert("Esse código <cfoutput>#form.cod#</cfoutput> já existe dentro da base de dados!");
            window.location.href="index.cfm";
        </script>
    <cfelse>
        <cfquery name="maxId" datasource="#BANCOSINC#">
            SELECT NVL(MAX(id),0)+1 AS ID
            FROM intcoldfusion.ferramenta_rastreio
        </cfquery>

        <cfquery name="insere" datasource="#BANCOSINC#">
            INSERT INTO intcoldfusion.ferramenta_rastreio (id, vin, modelo, usuario, data_save, caixa) 
            VALUES (
                #maxId.id#,
                <cfqueryparam value="#form.cod#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#form.modelo#" cfsqltype="CF_SQL_VARCHAR">,
                '#userCall#',
                sysdate,
                <cfqueryparam value="#form.etiqv#" cfsqltype="CF_SQL_VARCHAR">
            )            
        </cfquery>
    </cfif>
</cfif>

    <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
            <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
            <title>Ferramenta - Rastreio</title>
            <link rel="stylesheet" href="style.css?v=9">
            <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=2">
        </head>
        
    
        <body class="flex row">
            <!--- Sesão de cabeçalho de informações na lateral esquerda  --->
            <section class="header flex column">
                <h2>Sistema de Gestão da Qualidade</h2>
                    <label>
                        <div class="card col-12 mt-3">
                            <div class="card-body">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <tr><th>Historico:</th></tr>
                                            <th>⠀⠀VIN⠀⠀</th>
                                            <th>⠀⠀⠀⠀⠀⠀Modelo⠀⠀⠀⠀⠀⠀⠀</th>
                                            <th>⠀⠀Usuário⠀⠀⠀⠀</th>
                                            <!--- <th>Data⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</th> --->
                                        </tr>
                                    </thead>
                                    <tbody>
                                <cfloop query="buscaHistorico">
                                    <cfoutput>
                                        <tr class="text-right">
                                            <td class="text-center">#buscaHistorico.vin#</td>
                                            <td class="text-center">#buscaHistorico.modelo#</td>
                                            <td class="text-center">#buscaHistorico.usuario#</td>
                                            <!--- <td class="text-center">#buscaHistorico.data_save#</td> --->
                                            <!---<td style="color:<cfif busca.CHECK eq 0>red;<cfelse>green;</cfif>" class="text-center"><cfif busca.CHECK eq 0>Aguardando<cfelse>OK</cfif></td>--->
                                        </tr>
                                    </cfoutput>
                                </cfloop>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </label>
                    </a>
                        <i class="mdi mdi-truck-fast" id="square"></i>
                    </div>
            </section>
            <!--- Container do corpo principal da pagina - Preto --->
            <div class="flex column">
                <cfoutput>
                <!--- Sessão de Retorno de info Cabine e Chassi --->
                <div class="comp flex">
                    <div class="info-cab flex column g-1">
                        <label class="ch">Adicionar Check List</label>
                        <label>Leia o VIN</label>
                        <form id="form1" name="form1" method="POST" onsubmit="mudarFoco(atual, 'etiq')">
                            <input onfocus="myFunction(this)" id="cod" name="cod" type="text" value="<cfif isDefined("form.cod")>#form.cod#<cfelse></cfif>" onblur="mudarFoco(this, 'etiq')" <cfif isDefined("buscaMES.name") and buscaMES.name NEQ ''><cfelse>autofocus</cfif>>
                            <input id="barcode" name="valida" type="hidden" value="confirmar">
                        </br></br>
                        <label>Modelo</label></br>
                        <input onfocus="myFunction(this)" id="modeloFake" name="modeloFake" type="text" value="<cfif isDefined("buscaMES.code")>#buscaMES.code#<cfelse></cfif>" disabled>
                        <input id="modelo" name="modelo" type="hidden" value="<cfif isDefined("buscaMES.code")>#buscaMES.code#<cfelse></cfif>">
                        </br></br>
                        <label>Nome</label></br>
                        <input onfocus="myFunction(this)" id="nomeFake" name="nomeFake" type="text" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>" disabled>
                        <input id="nome" name="nome" type="hidden" value="<cfif isDefined("buscaMES.name")>#buscaMES.name#<cfelse></cfif>">
                        </br> </br>
                        <label>Leia a Caixa</label></br>
                        <input onchange="submitForm()" onfocus="myFunction(this)" id="etiqv" name="etiqv" type="text" value="" onblur="mudarFoco(this, 'submit')">
                        <!--- Se não encontrar informações para o paramentro informado--->
                        </form>
                        <label id="invalido">
                        </label>
                        <!--- Se não encontrar informações para o paramentro informado--->
                                            <!--- Se não encontrar informações para o paramentro informado--->
                        <cfif isDefined("form.valida") and isDefined("form.etiqv") and form.etiqv NEQ ''>
                            <label id="valido">
                                Rastreio realizado, Aguarde um momento!
                            </label>
    
                            <meta http-equiv="refresh" content="3;url=index.cfm">
                            
                        <cfelse>
                        <label>Status</label>
                            
                            <label id="aguardando">
                                Aguardando...
                            </label>
    
                        </cfif>

                    <button onclick="confirmar();" value="Confirmar" class="btn" type="submit" id="btn" name="button">Confirmar</button>
    
                    <!--- Se não encontrar informações para o paramentro informado--->
                    <label id="invalido">
                    </label>
    
                    </div>
                    <div class="info-cab flex column g-1">
                    <label class="ch">Usuário Logado - #userCall#</label>
                    <button id="expireCookieBtn" type="button" onclick="redirect()" form="form_meta" class="btn btn-danger m-2">Sair</button>
                    <button id="expireCookieBtn" type="button" onclick="redirect2()" form="form_meta" class="btn btn-danger m-2">Retornar</button>

                        </div>
                    </div>
                </div>
    
                </cfoutput>
            </div>
    
    <script>
    
    function mudarFoco(atual, proximo) {
      if (atual.id === 'cod' && atual.value.trim() !== '') {
        // Se o input1 estiver preenchido, envie o formulário
        document.getElementById('form1').submit();
      } else {
        var proximoInput = document.getElementById(proximo);

        if (proximoInput) {
          proximoInput.focus();
        } else if (proximo === 'submit') {
          // Se o próximo for 'submit', envie o formulário
          document.getElementById('form1').submit();
        }
      }
    }

    function myFunction(x) {
      x.style.background = "yellow";
    }
    
      const input = document.getElementById("barcode");
      const form = document.getElementById("form1");
    
      // Adicione um ouvinte de evento ao input para detectar a mudança
      input.addEventListener("change", function() {
        // Submeta o formulário quando houver uma mudança
        
        // Enviar informações  
        const confirmar = () => {
        conf = confirm('Deseja confirmar esse sequenciamento?');
        if(conf == true){
        form.submit();
        }
    }

      });
    
    function redirect() {
            // Redirecionar para outra página
            window.location.href = 'cookie.cfm';
        }
    function redirect2() {
            // Redirecionar para outra página
            window.location.href = 'relatorio.cfm';
        }
    </script>
    
        </body>
    
    </html>