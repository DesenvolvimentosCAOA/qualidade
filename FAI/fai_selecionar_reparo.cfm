<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<html lang="pt-BR">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FAI") or cookie.USER_APONTAMENTO_FAI eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
<cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fai_indicadores_1turno.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_fai") or cookie.user_level_fai eq "I">
    <script>
        alert("É necessário autorização!!");
        history.back(); // Voltar para a página anterior
    </script>
</cfif>


<html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Seleciona o Reparo</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v1">
        <style>
            .navbar-nav {
                list-style-type: none;
                padding: 0;
                margin: 0;
            }
            
            .nav-item {
                margin-bottom: 10px;
            }
            </style>
            
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
        
        <div class="container mt-4">
            <h2 class="titulo2" style="color:red; font-size:4vw">REPARO</h2><br><br>
        </div>
        
        <div class="navbar-nav">
            <li class="nav-item">
                <a href="fai_reparo_reinspecao.cfm"><button class="button">Reinspeção</button></a>
                <a href="fai_reparo_ub2.cfm"><button class="button">Under Body II</button></a>
                <a href="fai_reparo_pista.cfm"><button class="button">Road Test</button></a>
            </li><br>
            <li class="nav-item">
                <a href="fai_reparo_shower.cfm"><button class="button">Shower Test</button></a>
                <a href="fai_reparo_exok.cfm"><button class="button">SIGN-OFF</button></a>
            </li>
        </div>
    </body>
</html>