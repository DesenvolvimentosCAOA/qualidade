<cfinvoke method="inicializando" component="cf.ini.index">

    <cfquery name="buscaHistorico" datasource="#BANCOSINC#" maxRows="10">
        SELECT * 
        FROM intcoldfusion.ferramenta_rastreio
        ORDER BY data_save DESC
    </cfquery>

<cfif not isDefined("cookie.USER_APONTAMENTO_CL")>
    <script>
        alert("É necessario autenticação!!");
        self.location = 'index.cfm'
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
            window.location.href="lancamento.cfm";
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
            window.location.href="lancamento.cfm";
        </script>
    <cfelse>
        <cfquery name="maxId" datasource="#BANCOSINC#">
            SELECT NVL(MAX(id),0)+1 AS ID
            FROM intcoldfusion.ferramenta_rastreio
        </cfquery>

<cfif buscaMES.recordcount GT 0>
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO intcoldfusion.ferramenta_rastreio (id, vin, modelo, usuario, data_save, caixa) 
        VALUES (
            #maxId.id#,
            <cfqueryparam value="#form.cod#" cfsqltype="CF_SQL_VARCHAR">,
            <cfqueryparam value="#buscaMES.name#" cfsqltype="CF_SQL_VARCHAR">,
            '#USER_APONTAMENTO_CL#',
            sysdate,
            <cfqueryparam value="#form.etiqv#" cfsqltype="CF_SQL_VARCHAR">
        )            
    </cfquery>
    <cflocation url="lancamento.cfm">
</cfif>
    </cfif>
</cfif>

<cfquery name="getMaxCaixa" datasource="#BANCOSINC#">
    SELECT MAX(caixa) AS maxCaixa
    FROM intcoldfusion.ferramenta_rastreio
</cfquery>

<cfset maxCaixa = getMaxCaixa.maxCaixa>

<cfquery name="countMaxCaixa" datasource="#BANCOSINC#">
    SELECT COUNT(*) AS countCaixa
    FROM intcoldfusion.ferramenta_rastreio
    WHERE caixa = <cfqueryparam value="#maxCaixa#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfset countCaixa = countMaxCaixa.countCaixa>

<cfif countCaixa GTE 100>
    <cfset newCaixa = maxCaixa + 1>
<cfelse>
    <cfset newCaixa = maxCaixa>
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

            <div class="flex column">
                <cfoutput>
                <div class="comp flex">
                    <div class="info-cab flex column g-1">
                        <label class="ch">Adicionar Check List</label>
                        <label>Leia o VIN</label>
                        <form id="form1" name="form1" method="POST">
                            <input id="cod" name="cod" type="text" value="<cfif isDefined('form.cod')>#form.cod#<cfelse></cfif>" <cfif isDefined('buscaMES.name') and buscaMES.name NEQ ''><cfelse>autofocus</cfif>>
                            </br></br>
                            <label>Leia a Caixa</label></br>
                            <input id="etiqv" name="etiqv" type="text" value="#newCaixa#"><br><br>
                            <button class="btn" type="submit" id="btn" name="button">Confirmar</button>
                        </form>
    
                    </div>
                    <div class="info-cab flex column g-1">
                    <label class="ch">Usuário Logado - #USER_APONTAMENTO_CL#</label>
                    <button id="expireCookieBtn" type="button" onclick="redirect()" form="form_meta" class="btn btn-danger m-2">Sair</button>
                    <button id="expireCookieBtn" type="button" onclick="redirect2()" form="form_meta" class="btn btn-danger m-2">Retornar</button>

                        </div>
                    </div>
                </div>
    
                </cfoutput>
            </div>
    
    <script>
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