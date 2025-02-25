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
            window.location.href="index.cfm";
        </script>
    </cfif>
</cfif>

<cfif isDefined("form.cod") AND isDefined("form.etiqv") AND form.etiqv NEQ ''>
    <!-- Valida se já existe o código presente dentro do banco -->
    <cfquery name="buscaExistente" datasource="#BANCOSINC#">
        SELECT vin, modelo
        FROM intcoldfusion.ferramenta_rastreio
        WHERE UPPER(VIN) = UPPER(<cfqueryparam value="#trim(form.cod)#" cfsqltype="CF_SQL_VARCHAR">)
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

<cfif buscaMES.recordcount GT 0>
    <cfquery name="insere" datasource="#BANCOSINC#">
        INSERT INTO intcoldfusion.ferramenta_rastreio (id, vin, modelo, usuario, data_save, caixa)
        SELECT NVL(MAX(id), 0) + 1, 
               <cfqueryparam value="#trim(form.cod)#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#trim(buscaMES.name)#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#trim(USER_APONTAMENTO_CL)#" cfsqltype="CF_SQL_VARCHAR">,
               sysdate,
               <cfqueryparam value="#trim(form.etiqv)#" cfsqltype="CF_SQL_VARCHAR">
        FROM intcoldfusion.ferramenta_rastreio
        WHERE NOT EXISTS (
            SELECT 1 FROM intcoldfusion.ferramenta_rastreio 
            WHERE UPPER(VIN) = UPPER(<cfqueryparam value="#trim(form.cod)#" cfsqltype="CF_SQL_VARCHAR">)
        )
    </cfquery>      
    <cflocation url="index.cfm">
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
<!-- Calcular registros restantes para 100 -->
<cfset registrosRestantes = 100 - countCaixa>

    <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
            <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
            <title>Check List</title>
            <link rel="stylesheet" href="style.css?v=9">
            <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=2">
            <style>
                    body {
                    overflow: hidden;
                }
                @keyframes piscar {
                    0% { color: white; }
                    33% { color: red; }
                    66% { color: red; }
                    100% { color: white; }
                }
        
                .piscando {
                    font-size: 20px;
                    animation: piscar 1s infinite;
                }
            </style>
        </head>
        <body class="flex row">
            <section class="header flex column">
                <h2>Sistema de Gestão da Qualidade</h2>
                <cfif registrosRestantes EQ 0>
                    <script>
                        // Criar um elemento de mensagem
                        const messageDiv = document.createElement('div');
                        messageDiv.style.position = 'fixed';
                        messageDiv.style.top = '50%';
                        messageDiv.style.left = '50%';
                        messageDiv.style.transform = 'translate(-50%, -50%)';
                        messageDiv.style.backgroundColor = 'rgba(255, 0, 0, 0.8)';
                        messageDiv.style.color = 'white';
                        messageDiv.style.padding = '20px';
                        messageDiv.style.borderRadius = '10px';
                        messageDiv.style.fontSize = '18px';
                        messageDiv.style.fontWeight = 'bold';
                        messageDiv.style.zIndex = '1000';
                        messageDiv.style.textAlign = 'center';
                        messageDiv.innerText = 'A caixa está cheia! Por favor, troque para a próxima caixa.';
                        // Adicionar o elemento ao corpo da página
                        document.body.appendChild(messageDiv);
                
                        // Remover a mensagem após 5 segundos
                        setTimeout(() => {
                            document.body.removeChild(messageDiv);
                        }, 5000);
                    </script>
                <cfelse>
                    <div>
                        Restam <cfoutput>#registrosRestantes#</cfoutput> registros para atingir 100, na caixa <cfoutput>#maxCaixa#</cfoutput>.
                    </div>
                </cfif>
                    <label>
                        <div class="card col-12 mt-3">
                            <div class="card-body">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
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
                            <input 
                                id="cod" 
                                name="cod" 
                                type="text" 
                                maxlength="17" 
                                oninput="checkVinLength()" 
                                autofocus 
                                value="<cfif isDefined('form.cod')>#form.cod#<cfelse></cfif>">
                            </br></br>
                            <label>Leia a Caixa</label></br>
                            <input id="etiqv" name="etiqv" type="text" value="#newCaixa#"><br><br>
                            <button class="btn" type="submit" id="btn" name="button" onclick="disableButton()">Confirmar</button>
                        </form>
                    </div>
                    <div class="info-cab flex column g-1">
                    <label class="ch">Usuário Logado - #USER_APONTAMENTO_CL#</label>
                        <button id="expireCookieBtn" type="button" onclick="redirect()" form="form_meta" class="btn btn-danger m-2">Sair</button>
                        <button id="expireCookieBtn" type="button" onclick="redirect2()" form="form_meta" class="btn btn-danger m-2">Pesquisa</button>
                        </div>
                    </div>
                </div>
    
                </cfoutput>
            </div>
    
            <script>
                function checkVinLength() {
                    const vinInput = document.getElementById("cod");
                    if (vinInput.value.length === 17) {
                        document.getElementById("form1").submit();
                    }
                }
                function redirect() {
                // Redirecionar para outra página
                window.location.href = 'cookie.cfm';
            }
        function redirect2() {
                // Redirecionar para outra página
                window.location.href = 'relatorio.cfm';
            }
            </script>
            <script>
                function disableButton() {
                    document.getElementById("btn").disabled = true;
                }
                </script>
    
        </body>
    
    </html>