<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<!--- Verificando se está logado --->
    <cfif not isDefined("cookie.USER_APONTAMENTO_PAINT") or cookie.USER_APONTAMENTO_PAINT eq "">
        <script>
            alert("É necessario autenticação!!");
            self.location = 'index.cfm'
        </script>
    </cfif>
    <cfif not isDefined("cookie.user_level_paint") or (cookie.user_level_paint eq "R" or cookie.user_level_paint eq "P")>
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
    <link rel="stylesheet" href="assets/StyleBuyOFF1.css?v1">
    <link rel="icon" href="./assets/chery.png" type="image/x-icon">
    <style>
        html body{
            overflow: hidden;
        }
    </style>
</head>
    <body> 
        <header class="titulo">
            <cfinclude template="auxi/nav_links1.cfm">
        </header>
        
        <div class="container mt-4">
            <h2 class="titulo2">Selecione a Barreira</h2><br><br>
        </div><br>
        
        <div class="navbar-nav">
            <li class="nav-item">
                <a href="/qualidade/buyoff_linhat/selecao_paint_ecoat.cfm"><button class="button">ECOAT</button></a>
                <a href="/qualidade/buyoff_linhat/selecao_paint.cfm"><button class="button">Primer</button></a>
                <a href="/qualidade/buyoff_linhat/selecao_paint_topcoat.cfm"><button class="button">Top Coat</button></a>
            </li><br><br>
            <li class="nav-item">
                <a href="/qualidade/buyoff_linhat/selecao_paint_validacao.cfm"><button class="button">Validação de Qualidade</button></a>
                <a href="/qualidade/buyoff_linhat/selecao_paint_liberacao.cfm"><button class="button">CP6</button></a>
                
            </li>
        </div>
    </body>
</html>
