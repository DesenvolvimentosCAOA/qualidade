<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<html lang="pt-BR">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.user_apontamento_body") or cookie.user_apontamento_body eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
<cfif not isDefined("cookie.USER_LEVEL_BODY") or (cookie.USER_LEVEL_BODY eq "R" or cookie.USER_LEVEL_BODY eq "P")>
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>
    <html lang="pt-BR">
<head>
    <!-- Required meta tags-->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Seleciona a Barreira</title>
    <link rel="stylesheet" href="/cf/auth/qualidade/FAI/assets/StyleBuyOFF.css">
    <link rel="icon" href="/cf/auth/qualidade/FAI/assets/chery.png" type="image/x-icon">
    <style>
    body {
        overflow:hidden;
         }
    </style>
</head>
    <body> 
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
        
        <div class="container mt-4">
            <h2 class="titulo2">Selecione a Barreira</h2><br><br>
        </div>
        
        <div class="navbar-nav">
            <li class="nav-item">
                <a href="body_barreira_processo.cfm"><button class="button">Buy Off Processo</button></a>
                <a href="body_barreira_cp5.cfm"><button class="button">CP5</button></a>
                <a href="body_barreira_validacao.cfm"><button class="button">Inspeção Superfície</button></a>
            </li><br>
            <li class="nav-item">
                <a href="body_barreira_chassi.cfm"><button class="button">CHASSI</button></a>
                <a href="body_barreira_hr.cfm"><button class="button">HR</button></a>
            </li>
        </div>
    </body>
</html>
