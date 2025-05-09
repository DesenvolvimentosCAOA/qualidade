<script>
    self.location  = '/SGQ/index.cfm'
</script><!----  

<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

<!--- valida o usuário para SMALL --->
<cfoutput>
    <cfinvoke method="inicializando" component="cf.ini.index">
        <cfif isDefined("form.small_login")>
            <cfquery name="validausuario" datasource="#BANCOSINC#">
                select USER_ID, USER_NAME, USER_PASSWORD, USER_LEVEL, USER_SIGN 
                from reparo_fa_users 
                where UPPER(USER_NAME)= UPPER('#form.small_login#')
                and USER_PASSWORD = UPPER('#form.small_senha#')
                AND (SHOP IN ('SMALL', 'PAINT') OR USER_LEVEL = 'G')

            </cfquery>
            <cfif validausuario.recordcount GT 0>
                <cfcookie name="user_apontamento_small" value="#FORM.small_login#">
                <meta http-equiv="refresh" content="0; URL=/qualidade/SMALL/small.cfm"/>
            <cfelse>
                <div id="login-erro" class="alert alert-danger" role="alert">USUÁRIO OU SENHA INCORRETA</div>
            </cfif>
        </cfif>
</cfoutput>

<!--- valida o usuário para final assembly --->
<cfif isDefined("form.final_assembly_login")>
    <cfquery name="validausuario" datasource="#BANCOSINC#">
        SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
        WHERE upper(USER_NAME) = UPPER('#form.final_assembly_login#')
        AND USER_PASSWORD = UPPER('#form.final_assembly_senha#')
        AND (SHOP = 'FA' OR USER_LEVEL = 'G' OR USER_LEVEL = 'P')
    </cfquery>
   
    <!---    <CFDUMP VAR="#validausuario#"> --->
    <cfif validausuario.recordcount GT 0>
        <cfcookie name="user_apontamento_fa" value="#FORM.final_assembly_login#">
        <cfcookie name="user_level_final_assembly" value="#validausuario.USER_LEVEL#">
        <cfif validausuario.user_level eq "R">
            <meta http-equiv="refresh" content="0; URL=/qualidade/buy_off_T/fa_reparo_c13.cfm"/>
        <cfelseif validausuario.user_level eq "P">
            <meta http-equiv="refresh" content="0; URL=/qualidade/buy_off_T/fa_indicadores_1.cfm"/>
        <cfelse>
            <meta http-equiv="refresh" content="0; URL=/qualidade/buy_off_T/fa_selecionar_buy_off.cfm"/>
        </cfif>
    <cfelse>
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
           </cfif>
</cfif>

<!--- valida o usuário para paint --->
<cfoutput>
    <cfif isDefined("form.PAINT_SHOP_LOGIN")>
        <cfquery name="validausuario" datasource="#BANCOSINC#">
            SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
            WHERE upper(USER_NAME) = UPPER('#form.PAINT_SHOP_LOGIN#')
            AND USER_PASSWORD = UPPER('#form.PAINT_SHOP_SENHA#')
            AND (SHOP = 'PAINT' OR USER_LEVEL = 'G' OR USER_LEVEL = 'P')
        </cfquery>
    
        <!---    <CFDUMP VAR="#validausuario#"> --->
        <cfif validausuario.recordcount GT 0>
            <cfcookie name="user_apontamento_paint" value="#FORM.PAINT_SHOP_LOGIN#">
            <cfcookie name="user_level_paint" value="#validausuario.USER_LEVEL#">
            <cfif validausuario.user_level eq "R">
                <meta http-equiv="refresh" content="0; URL=/qualidade/buyoff_linhat/Reparo.cfm"/>
            <cfelseif validausuario.user_level eq "P">
                <meta http-equiv="refresh" content="0; URL=/qualidade/buyoff_linhat/indicadores_paint.cfm"/>
            <cfelse>
                <meta http-equiv="refresh" content="0; URL=/qualidade/buyoff_linhat/paint_selecionar_buy_off.cfm"/>
            </cfif>
        <cfelse>
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
            </cfif>
    </cfif>
</cfoutput>

<!--- valida o usuário para FAI --->
<cfoutput>
    <cfif isDefined("form.FAI_LOGIN")>
        <cfquery name="validausuario" datasource="#BANCOSINC#">
            SELECT USER_ID, USER_NAME, USER_PASSWORD, trim(USER_LEVEL) USER_LEVEL, USER_SIGN 
            FROM reparo_fa_users 
            WHERE upper(USER_NAME) = UPPER('#form.FAI_LOGIN#')
            AND USER_PASSWORD = UPPER('#form.FAI_SENHA#')
            AND (SHOP = 'FAI' OR USER_LEVEL = 'G' OR USER_LEVEL = 'P')
        </cfquery>
    
        <cfif validausuario.recordcount GT 0>
            <cfcookie name="user_apontamento_fai" value="#form.FAI_LOGIN#">
            <cfcookie name="user_level_fai" value="#validausuario.USER_LEVEL#">
            <cfcookie name="user_sign" value="#validausuario.USER_SIGN#"> <!-- Adiciona o cookie para USER_SIGN -->
            
            <cfif validausuario.user_level eq "R">
                <meta http-equiv="refresh" content="0; URL=/qualidade/FAI/fai_selecionar_reparo.cfm"/>
            <cfelseif validausuario.user_level eq "P">
                <meta http-equiv="refresh" content="0; URL=/qualidade/FAI/fai_indicadores_1turno.cfm"/>
            <cfelse>
                <meta http-equiv="refresh" content="0; URL=/qualidade/FAI/fai_selecionar_buy_off.cfm"/>
            </cfif>
        <cfelse>
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
        </cfif>
    </cfif>
</cfoutput>

    <!--- valida o usuário para BODY --->
<cfoutput>
    <cfif isDefined("form.body_shop_login")>
        <cfquery name="validausuario" datasource="#BANCOSINC#">
            SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
            WHERE upper(USER_NAME) = UPPER('#form.body_shop_login#')
            AND USER_PASSWORD = UPPER('#form.body_shop_senha#')
            AND (SHOP = 'BODY' OR USER_LEVEL = 'G' OR USER_LEVEL = 'P')
        </cfquery>
       
    <!---    <CFDUMP VAR="#validausuario#"> --->
        <cfif validausuario.recordcount GT 0>
            <cfcookie name="user_apontamento_body" value="#FORM.body_shop_login#">
            <cfcookie name="user_level_body" value="#validausuario.USER_LEVEL#">
            <cfif validausuario.user_level eq "R">
                <meta http-equiv="refresh" content="0; URL=/qualidade/body/body_reparo_novo.cfm"/>
            <cfelseif validausuario.user_level eq "P">
                <meta http-equiv="refresh" content="0; URL=/qualidade/body/body_indicadores_1turno.cfm"/>
            <cfelse>
                <meta http-equiv="refresh" content="0; URL=/qualidade/body/body_selecionar_buy_off.cfm"/>
            </cfif>
        <cfelse>
            <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
               </cfif>
    </cfif>
</cfoutput>


    <!--- valida o usuário para PDI --->
    <cfoutput>
        <cfif isDefined("form.PDI_LOGIN")>
            <cfquery name="validausuario" datasource="#BANCOSINC#">
                SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
                WHERE upper(USER_NAME) = UPPER('#form.PDI_LOGIN#')
                AND USER_PASSWORD = UPPER('#form.PDI_SENHA#')
                AND (SHOP = 'PDI' OR USER_LEVEL = 'G'OR USER_LEVEL = 'P')
            </cfquery>
        
            <!---    <CFDUMP VAR="#validausuario#"> --->
            <cfif validausuario.recordcount GT 0>
                <cfcookie name="user_apontamento_pdi" value="#FORM.PDI_LOGIN#">
                <cfcookie name="user_level_pdi" value="#validausuario.USER_LEVEL#">
                <cfif validausuario.user_level eq "R" OR validausuario.user_level eq "E">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_entrada.cfm"/>
                <cfelseif validausuario.user_level eq "P">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_indicadores_1.cfm"/>
                <cfelse>
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_saida.cfm"/>
                </cfif>
            <cfelse>
                <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
            </cfif>
        </cfif>
    </cfoutput>


    <!--- valida o usuário para PDI --->
    <cfoutput>
        <cfif isDefined("form.CL_LOGIN")>
            <cfquery name="validausuario" datasource="#BANCOSINC#">
                SELECT ID, USUARIO, SENHA, trim (PERMISSAO) PERMISSAO, USUARIO FROM usuarios_ferramenta_rastreio 
                WHERE upper(USUARIO) = UPPER('#form.CL_LOGIN#')
                AND SENHA = UPPER('#form.CL_SENHA#')
                AND (PERMISSAO = '2'OR PERMISSAO = '0')
            </cfquery>
        
            <!---    <CFDUMP VAR="#validausuario#"> --->
            <cfif validausuario.recordcount GT 0>
                <cfcookie name="user_apontamento_cl" value="#FORM.CL_LOGIN#">
                <cfcookie name="user_level_cl" value="#validausuario.permissao#">
                <cfif validausuario.permissao eq "1" OR validausuario.permissao eq "0">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/ferramenta_rastreio/index.cfm"/>
                <cfelseif validausuario.permissao eq "P">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/ferramenta_rastreio/index.cfm"/>
                <cfelse>
                    <meta http-equiv="refresh" content="0; URL=/qualidade/ferramenta_rastreio/index.cfm"/>
                </cfif>
            <cfelse>
                <u class="btn btn-danger" style="width: 100%">USUÁRIO OU SENHA INCORRETA</u>
            </cfif>
        </cfif>
    </cfoutput>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sistema de Gestão da Qualidade</title>
    <link rel="stylesheet" href="./assets/style.css"/>
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">

    <style>
        body{
            background: url('./assets/novo.jpg') no-repeat center center fixed; /* URL da imagem de fundo */
            background-size: cover; /* Cobrir toda a área da tela */
            overflow: hidden;
        }
        #cadastro_usuario {
            text-transform: lowercase; /* Transforma o texto em minúsculas */
            }

        #cadastro_nome{
            text-transform: uppercase;
        }
        .titulo-texto {
        font-size: 36px;
        font-family: Arial, sans-serif;
        color: #333;
        overflow: hidden; /* Oculta o texto que ainda não apareceu */
        white-space: nowrap; /* Impede a quebra de linha */
        display: inline-block; /* Para o texto não quebrar */
        }

        .titulo-texto span {
        opacity: 0;
        position: relative;
        display: inline-block;
        animation: fadeInLeft 1s forwards;
        }

        /* Adicionando delay incremental para cada letra */
        .titulo-texto span:nth-child(1) {
        animation-delay: 0s;
        }

        .titulo-texto span:nth-child(2) {
        animation-delay: 0.2s;
        }

        .titulo-texto span:nth-child(3) {
        animation-delay: 0.3s;
        }

        .titulo-texto span:nth-child(4) {
        animation-delay: 0.4s;
        }

        .titulo-texto span:nth-child(5) {
        animation-delay: 0.5s;
        }

        .titulo-texto span:nth-child(6) {
        animation-delay: 0.6s;
        }

        .titulo-texto span:nth-child(7) {
        animation-delay: 0.7s;
        }

        .titulo-texto span:nth-child(8) {
        animation-delay: 0.8s;
        }

        .titulo-texto span:nth-child(9) {
        animation-delay: 0.9s;
        }

        .titulo-texto span:nth-child(10) {
        animation-delay: 1s;
        }

        .titulo-texto span:nth-child(11) {
        animation-delay: 1.1s;
        }

        .titulo-texto span:nth-child(12) {
        animation-delay: 1.2s;
        }

        .titulo-texto span:nth-child(13) {
        animation-delay: 1.3s;
        }

        .titulo-texto span:nth-child(14) {
        animation-delay: 1.4s;
        }

        .titulo-texto span:nth-child(15) {
        animation-delay: 1.5s;
        }

        .titulo-texto span:nth-child(16) {
        animation-delay: 1.6s;
        }

        .titulo-texto span:nth-child(17) {
        animation-delay: 1.7s;
        }

        .titulo-texto span:nth-child(18) {
        animation-delay: 1.8s;
        }

        .titulo-texto span:nth-child(19) {
        animation-delay: 1.9s;
        }

        .titulo-texto span:nth-child(20) {
        animation-delay: 2s;
        }

        .titulo-texto span:nth-child(21) {
        animation-delay: 2.1s;
        }

        .titulo-texto span:nth-child(22) {
        animation-delay: 2.2s;
        }

        .titulo-texto span:nth-child(23) {
        animation-delay: 2.3s;
        }

        .titulo-texto span:nth-child(24) {
        animation-delay: 2.4s;
        }

        .titulo-texto span:nth-child(25) {
        animation-delay: 2.5s;
        }

        .titulo-texto span:nth-child(26) {
        animation-delay: 2.6s;
        }

        .titulo-texto span:nth-child(27) {
        animation-delay: 2.7s;
        }

        .titulo-texto span:nth-child(28) {
        animation-delay: 2.8s;
        }

        .titulo-texto span:nth-child(29) {
        animation-delay: 2.9s;
        }

        .titulo-texto span:nth-child(30) {
        animation-delay: 3s;
        }

        .titulo-texto span:nth-child(31) {
        animation-delay: 3.1s;
        }

        @keyframes fadeInLeft {
        0% {
            opacity: 0;
            transform: translateX(-100vw); /* Começa da esquerda da tela */
        }
        100% {
            opacity: 1;
            transform: translateX(0); /* Vai para sua posição normal */
        }
        }
        #adminBtn {
            position: fixed;
            top: 10px;
            right: 10px;
            padding: 10px 15px;
            background-color: #ff4500;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: none; /* Inicialmente oculto */
        }

        #adminBtn:hover {
            background-color: #d13a00;
        }

        #submenu {
            position: fixed;
            top: 50px;
            right: 10px;
            background: white;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            display: none;
            width: 150px;
        }

        #submenu ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        #submenu ul li {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }

        #submenu ul li:last-child {
            border-bottom: none;
        }

        #submenu ul li:hover {
            background: #f4f4f4;
        }
    </style>

</head>
<body>
    <header>
        <cfinclude template="./auxi/menu.cfm">
    </header>

    <h1 class="titulo-texto">
        <span>S</span>
        <span>I</span>
        <span>S</span>
        <span>T</span>
        <span>E</span>
        <span>M</span>
        <span>A</span>
        <span> </span>
        <span>D</span>
        <span>E</span>
        <span> </span>
        <span>G</span>
        <span>E</span>
        <span>S</span>
        <span>T</span>
        <span>Ã</span>
        <span>O</span>
        <span> </span>
        <span>D</span>
        <span>A</span>
        <span> </span>
        <span>Q</span>
        <span>U</span>
        <span>A</span>
        <span>L</span>
        <span>I</span>
        <span>D</span>
        <span>A</span>
        <span>D</span>
        <span>E</span>
    </h1>
    <button id="adminBtn">Admin</button>

    <div id="submenu">
        <ul>
            <li>
                <a href="/qualidade/buyoff_linhat/user_edit.cfm" title="Login CL"><p>Gerenciar Usuários</p></a></li>
            <li>Gerenciar Usuários</li>
            <li>Logs do Sistema</li>
        </ul>
    </div>
    <!-- Formulário de Small -->
<div id="form-small" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarSmallLogin()">
        <h2>Small</h2>
        <div class="form-group">
            <label for="small_login">Login:</label>
            <input type="text" class="form-control" id="small_login" name="small_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="small_senha">Senha:</label>
            <input type="password" class="form-control" id="small_senha" name="small_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('small')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="small_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="small_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>
<script>
    function validarSmallLogin() {
        var login = document.getElementById('small_login').value;
        var senha = document.getElementById('small_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('small_erro_numerico').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        // Lógica de validação
        // Aqui você pode fazer outras validações se necessário

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('small_erro').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        return true; // Permite o envio do formulário
    }
</script>

<!-- Formulário de Body Shop -->
<div id="form-body-shop" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarBodyShopLogin()">
        <h2 style="color:blue">Body Shop</h2>
        <div class="form-group">
            <label for="body_shop_login">Login:</label>
            <input type="text" class="form-control" id="body_shop_login" name="body_shop_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="body_shop_senha">Senha:</label>
            <input type="password" class="form-control" id="body_shop_senha" name="body_shop_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('body-shop')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="body_shop_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="body_shop_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>

<!-- JavaScript -->
<script>
    function validarBodyShopLogin() {
        var login = document.getElementById('body_shop_login').value;
        var senha = document.getElementById('body_shop_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('body_shop_erro_numerico').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        // Lógica de validação
        // Aqui você pode fazer outras validações se necessário

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('body_shop_erro').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        return true; // Permite o envio do formulário
    }
</script>


<!-- Formulário de Paint Shop -->
<div id="form-paint-shop" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarPaintShopLogin()">
        <h2 style="color:orange">Paint Shop</h2>
        <div class="form-group">
            <label for="paint_shop_login">Login:</label>
            <input type="text" class="form-control" id="paint_shop_login" name="paint_shop_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="paint_shop_senha">Senha:</label>
            <input type="password" class="form-control" id="paint_shop_senha" name="paint_shop_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('paint-shop')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="paint_shop_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="paint_shop_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>

<!-- JavaScript -->
<script>
    function validarPaintShopLogin() {
        var login = document.getElementById('paint_shop_login').value;
        var senha = document.getElementById('paint_shop_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('paint_shop_erro_numerico').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        // Lógica de validação
        // Aqui você pode fazer outras validações se necessário

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('paint_shop_erro').style.display = 'block';
            return false; // Impede o envio do formulário
        }

        return true; // Permite o envio do formulário
    }
</script>


<!-- Formulário de Final Assembly -->
<div id="form-final-assembly" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarFinalAssemblyLogin()">
        <h2 style="color:Gold">Final Assembly</h2>
        <div class="form-group">
            <label for="final_assembly_login">Login:</label>
            <input type="text" class="form-control" id="final_assembly_login" name="final_assembly_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="final_assembly_senha">Senha:</label>
            <input type="password" class="form-control" id="final_assembly_senha" name="final_assembly_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('final-assembly')">Cancelar</button>
        <!-- Elementos para exibir mensagem de erro -->
        <div id="final_assembly_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;"></div>
    </form>
</div>

<!-- JavaScript para Final Assembly -->
<script>
    function validarFinalAssemblyLogin() {
        var login = document.getElementById('final_assembly_login').value;
        var senha = document.getElementById('final_assembly_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('final_assembly_erro_numerico').style.display = 'block';
            document.getElementById('final_assembly_erro_numerico').textContent = 'A senha deve conter apenas números.';
            return false; // Impede o envio do formulário
        }

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('final_assembly_erro_numerico').style.display = 'block';
            document.getElementById('final_assembly_erro_numerico').textContent = 'Usuário ou senha incorretos.';
            return false; // Impede o envio do formulário
        }

        // Caso não haja erro, limpar mensagem de erro (opcional)
        document.getElementById('final_assembly_erro_numerico').style.display = 'none';
        document.getElementById('final_assembly_erro_numerico').textContent = '';

        return true; // Permite o envio do formulário
    }
</script>

<!-- Formulário de FAI -->
<div id="form-fai" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarFAILogin()">
        <h2 style="color:gray">FAI</h2>
        <div class="form-group">
            <label for="fai_login">Login:</label>
            <input type="text" class="form-control" id="fai_login" name="fai_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="fai_senha">Senha:</label>
            <input type="password" class="form-control" id="fai_senha" name="fai_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('fai')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="fai_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="fai_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>

<!-- JavaScript -->
<script>
    function validarFAILogin() {
        var login = document.getElementById('fai_login').value;
        var senha = document.getElementById('fai_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('fai_erro_numerico').style.display = 'block';
            document.getElementById('fai_erro').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('fai_erro').style.display = 'block';
            document.getElementById('fai_erro_numerico').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Caso não haja erro, limpar mensagens de erro (opcional)
        document.getElementById('fai_erro').style.display = 'none';
        document.getElementById('fai_erro_numerico').style.display = 'none';

        return true; // Permite o envio do formulário
    }
</script>

<!-- Formulário de PDI -->
<div id="form-pdi" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarPDILogin()">
        <h2 style="color:purple">PDI</h2>
        <div class="form-group">
            <label for="pdi_login">Login:</label>
            <input type="text" class="form-control" id="pdi_login" name="pdi_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="pdi_senha">Senha:</label>
            <input type="password" class="form-control" id="pdi_senha" name="pdi_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('pdi')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="pdi_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="pdi_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>
<!-- JavaScript -->
<script>
    function validarPDILogin() {
        var login = document.getElementById('pdi_login').value;
        var senha = document.getElementById('pdi_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('pdi_erro_numerico').style.display = 'block';
            document.getElementById('pdi_erro').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('pdi_erro').style.display = 'block';
            document.getElementById('pdi_erro_numerico').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Caso não haja erro, limpar mensagens de erro (opcional)
        document.getElementById('pdi_erro').style.display = 'none';
        document.getElementById('pdi_erro_numerico').style.display = 'none';

        return true; // Permite o envio do formulário
    }
</script>

<!-- Formulário de PDI -->
<div id="form-cl" class="form-section" style="display: none;">
    <form method="post" onsubmit="return validarCLLogin()">
        <h2 style="color:purple">Check List</h2>
        <div class="form-group">
            <label for="cl_login">Login:</label>
            <input type="text" class="form-control" id="cl_login" name="cl_login" oninput="this.value = this.value.toLowerCase()">
        </div>
        <div class="form-group">
            <label for="cl_senha">Senha:</label>
            <input type="password" class="form-control" id="cl_senha" name="cl_senha">
        </div>
        <button type="submit" class="btn btn-primary">Entrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('cl')">Cancelar</button>
        <!-- Elemento para exibir mensagem de erro -->
        <div id="cl_erro" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">Usuário ou senha incorretos.</div>
        <div id="cl_erro_numerico" class="alert alert-danger" style="display: none; width: 100%; margin-top: 10px;">A senha deve conter apenas números.</div>
    </form>
</div>
<!-- JavaScript -->
<script>
    function validarCLLogin() {
        var login = document.getElementById('cl_login').value;
        var senha = document.getElementById('cl_senha').value;

        // Validar se a senha contém apenas números
        if (!(/^\d+$/.test(senha))) {
            document.getElementById('cl_erro_numerico').style.display = 'block';
            document.getElementById('cl_erro').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Exemplo simples de validação
        if (login === "" || senha === "") {
            document.getElementById('cl_erro').style.display = 'block';
            document.getElementById('cl_erro_numerico').style.display = 'none';
            return false; // Impede o envio do formulário
        }

        // Caso não haja erro, limpar mensagens de erro (opcional)
        document.getElementById('cl_erro').style.display = 'none';
        document.getElementById('cl_erro_numerico').style.display = 'none';

        return true; // Permite o envio do formulário
    }
</script>

<!-- Formulário de Cadastro -->
<div id="form-cadastro" class="form-section" style="display: none;">
    <form method="post" action="cadastro.cfm">
        <h2>Cadastro</h2>
        <div class="form-group">
            <label for="cadastro_usuario">Usuário:</label>
            <input required type="text" class="form-control" id="cadastro_usuario" name="cadastro_usuario">
        </div>
        <div class="form-group">
            <label for="cadastro_senha">Senha:</label>
            <input required type="password" class="form-control" id="cadastro_senha" name="cadastro_senha" inputmode="numeric" maxlength="4" oninput="verificarSenhaNumerica(this); removerBordaVermelha(this);">
        </div>
        <div class="form-group">
            <label for="cadastro_nivel_acesso">Nível de Acesso:</label>
            <select id="cadastro_nivel_acesso" class="form-control" name="cadastro_nivel_acesso" required>
                <option value="E">E</option>
                <option value="R">R</option>
                <option value="I">I</option>
                <option value="G">G</option>
                <option value="P">P</option>
            </select>
        </div>
        <div class="form-group">
            <label for="cadastro_nome">Nome:</label>
            <input required type="text" class="form-control" id="cadastro_nome" name="cadastro_nome" oninput="removerBordaVermelha(this)">
        </div>
        <div class="form-group">
            <label for="cadastro_setor">Setor:</label>
            <select id="cadastro_setor" class="form-control" name="cadastro_setor" oninput="removerBordaVermelha(this)">
                <option value="PDI">PDI</option>
                <option value="BODY">BODY</option>
                <option value="FAI">FAI</option>
                <option value="PAINT">PAINT</option>
                <option value="SMALL">SMALL</option>
                <option value="FA">FA</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Cadastrar</button>
        <button type="reset" class="btn btn-secondary" onclick="ocultarForm('cadastro')">Cancelar</button>
    </form>
</div>

    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        function mostrarForm(formId) {
            var forms = document.querySelectorAll('.form-section');
            forms.forEach(function (form) {
                form.style.display = 'none';
            });
            var form = document.getElementById('form-' + formId);
            if (form) {
                form.style.display = 'block';
            }
        }

        function ocultarForm(formId) {
            var form = document.getElementById('form-' + formId).querySelector('form');
            form.reset();
            document.getElementById('form-' + formId).style.display = 'none';
        }

        function validarAcessoCadastro() {
            var usuario = prompt("Digite o nome de usuário:");
            var senha = prompt("Digite a senha:");
            if (usuario === "admin" && senha === "124") {
                mostrarForm('cadastro');
            } else {
                alert("Usuário ou senha incorretos. Tente novamente.");
            }
        }

        function validarAcessoEditar(event) {
            var usuario = prompt("Digite o nome de usuário:").toLowerCase(); // Converte para minúsculas
            var senha = prompt("Digite a senha:").toLowerCase(); // Converte para minúsculas

            if (usuario === "admin" && senha === "8350") {
                // Credenciais corretas, redireciona para a página de edição
            } else {
                event.preventDefault();
                alert("Usuário ou senha incorretos. Tente novamente.");
            }
        }

    </script>

    <script>
        document.addEventListener("keydown", function(event) {
            if (event.ctrlKey && event.shiftKey && event.key === "A") {
                event.preventDefault();
                let btn = document.getElementById("adminBtn");
                btn.style.display = (btn.style.display === "none" || btn.style.display === "") ? "block" : "none";
            }
        });

        document.getElementById("adminBtn").addEventListener("click", function() {
            let submenu = document.getElementById("submenu");
            submenu.style.display = (submenu.style.display === "none" || submenu.style.display === "") ? "block" : "none";
        });

        // Fechar o submenu ao clicar fora
        document.addEventListener("click", function(event) {
            let btn = document.getElementById("adminBtn");
            let submenu = document.getElementById("submenu");

            if (event.target !== btn && !submenu.contains(event.target)) {
                submenu.style.display = "none";
            }
        });
    </script>

</body>
</html> ---->