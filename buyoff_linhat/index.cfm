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
                SELECT USER_ID, USER_NAME, USER_PASSWORD, trim (USER_LEVEL) USER_LEVEL, USER_SIGN FROM reparo_fa_users 
                WHERE upper(USER_NAME) = UPPER('#form.FAI_LOGIN#')
                AND USER_PASSWORD = UPPER('#form.FAI_SENHA#')
                AND (SHOP = 'FAI' OR USER_LEVEL = 'G'OR USER_LEVEL = 'P')
            </cfquery>
        
        <!---    <CFDUMP VAR="#validausuario#"> --->
            <cfif validausuario.recordcount GT 0>
                <cfcookie name="user_apontamento_fai" value="#FORM.FAI_LOGIN#">
                <cfcookie name="user_level_fai" value="#validausuario.USER_LEVEL#">
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
                <meta http-equiv="refresh" content="0; URL=/qualidade/body/body_reparo.cfm"/>
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
                <cfif validausuario.user_level eq "R">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_selecionar_reparo.cfm"/>
                <cfelseif validausuario.user_level eq "P">
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_indicadores_1turno.cfm"/>
                <cfelse>
                    <meta http-equiv="refresh" content="0; URL=/qualidade/PDI/pdi_entrada.cfm"/>
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
        background: url('./assets/94215104.cms') no-repeat center center fixed; /* URL da imagem de fundo */
        background-size: cover; /* Cobrir toda a área da tela */
    }
    #cadastro_usuario {
  text-transform: lowercase; /* Transforma o texto em minúsculas */
}

    #cadastro_nome{
        text-transform: uppercase;
    }
    </style>

</head>
<body>
    <header>
        <cfinclude template="./auxi/menu.cfm">
    </header>

    <h1 class="titulo-texto" id="typed-text"></h1>
    <script src="https://cdn.jsdelivr.net/npm/typed.js@2.0.12"></script>
    <script>
        var typed = new Typed('#typed-text', {
            strings: ["SISTEMA DE GESTAO DA QUALIDADE"],
            typeSpeed: 50,
            backSpeed: 25,
            loop: false,
            showCursor: false
        });
    </script>

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
                <option value="I">I</option>
                <option value="R">R</option>
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
            if (usuario === "" && senha === "") {
                mostrarForm('cadastro');
            } else {
                alert("Usuário ou senha incorretos. Tente novamente.");
            }
        }

        function validarAcessoEditar(event) {
            var usuario = prompt("Digite o nome de usuário:");
            var senha = prompt("Digite a senha:");
            if (usuario === "admin" && senha === "3781") {
                // Credenciais corretas, redireciona para a página de edição
            } else {
                event.preventDefault();
                alert("Usuário ou senha incorretos. Tente novamente.");
            }
        }
    </script>
</body>
</html>
