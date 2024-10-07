<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<html lang="pt-BR">

<!--- Verificando se está logado --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = 'cf/auth/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>
    
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Selecionar Reparo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS-->
    <link rel="stylesheet" href="assets/StyleBuyOFF.css?v7">

    <!-- Material Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <header>
        <cfinclude template="auxi/nav_links.cfm">
    </header>
    <div class="container mt-4">
        <h2 class="titulo2">Selecione a Reparo</h2><br><br>
    </div>
    <div class="navbar-nav">
        <li class="nav-item">
            <a href="fa_Reparo_T19.cfm"><button class="button">Reparo T19</button></a>
            <a href="fa_Reparo_T30.cfm"><button class="button">Reparo T30</button></a>
            <a href="fa_Reparo_T33.cfm"><button class="button">Reparo T33</button></a>
        </li><br>
        <li class="nav-item">
            <a href="fa_Reparo_C13.cfm"><button class="button">Reparo C13</button></a>
            <a href="fa_Reparo_F05.cfm"><button class="button">Reparo F05</button></a>
            <a href="fa_Reparo_F10.cfm"><button class="button">Reparo F10</button></a>
            <a href="fa_Reparo_submotor.cfm"><button class="button">Reparo Sub Motor</button></a>
        </li>
    </div><br><br><br><br><br><br><br><br>

    <footer class="text-center py-4">
        <p>&copy; 2024 Sistema de gestão da qualidade.</p>
    </footer>
</body>
</html>
