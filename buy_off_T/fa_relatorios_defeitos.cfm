<cfinvoke method="inicializando" component="cf.ini.index">

    <cfset filtroDataStart = (isDefined("url.filtroDataStart") and url.filtroDataStart neq "") ? url.filtroDataStart : DateFormat(Now(), "yyyy-mm-dd")>
    <cfset filtroDataEnd = (isDefined("url.filtroDataEnd") and url.filtroDataEnd neq "") ? url.filtroDataEnd : DateFormat(Now(), "yyyy-mm-dd")>

    <cfquery name="consulta_adicionais" datasource="#BANCOSINC#">
        SELECT *
        FROM INTCOLDFUSION.REPARO_FA_DEFEITOS
        WHERE 1 = 1 
        ORDER BY ID asc
    </cfquery>

    <html lang="pt-BR">
    <head>
        <!-- Meta tags necessárias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>FA CP7 Summary</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="assets/css/style.css?v1"> 
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v9">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
        </style>
        
    </head>
    <body>
        <div class="container">
            <h2>FA CP7 Summary</h2>
            <form method="get">
                <div class="form-row">
                <div class="form-row">
                    <div class="col-md-12">
                        <div class="form-buttons">
                            <button type="button" id="report" class="btn btn-secondary">Download</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <!-- Header com as imagens e o menu -->
            <h2 class="titulo2">Relatórios</h2><br>
            <div class="container col-12 bg-white rounded metas">
                <table id="tblStocks" class="table">
                    <thead>
                        <tr class="text-nowrap">
                            <th scope="col">ID</th>
                            <th scope="col">DEFEITO</th>
                            <th scope="col">Data Criação</th>
                            <th scope="col">Shop</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <cfoutput>
                            <cfloop query="consulta_adicionais">
                                <tr class="align-middle">
                                    <td>#ID#</td>
                                    <td>#DEFEITO#</td>
                                    <td>#lsdatetimeformat(DATA_CRIACAO, 'dd/mm/yyyy')#</td>
                                    <td>#SHOP#</td>
                                </tr>
                            </cfloop>
                        </cfoutput>
                    </tbody>
                </table>
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="/cf/assets/js/home/js/table2excel.js?v=2"></script>

<script>
    // Gerando Excel da tabela
    var table2excel = new Table2Excel();
    document.getElementById('report').addEventListener('click', function() {
        table2excel.export(document.querySelectorAll('#tblStocks'));
    });
</script>
        </div>
    </body>
</html>
  