<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Inspeção de Conteúdos FAI</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="assets/StyleBuyOFF.css?v10">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Estilo para a imagem que pode ser expandida */
        #foto-padrao img {
            max-width: 50%;
            height: auto;
            cursor: pointer;
            transition: transform 0.3s ease; /* Efeito de transição suave */
            position: relative;
        }

        /* Estilo para a imagem expandida */
        #foto-padrao.expandida img {
            max-width: none;
            width: auto;
            height: auto;
            transform: scale(3); /* Ajuste o valor de escala conforme necessário */
            position: fixed; /* Alterado para posição fixa */
            top: 50%; /* Centraliza verticalmente */
            left: 50%; /* Centraliza horizontalmente */
            transform: translate(-50%, -50%); /* Move a imagem para o centro */
            z-index: 999; /* Sobrepor todas as outras imagens */
        }
    </style>
</head>
<body>
<header class="titulo">
    <cfinclude template="auxi/nav_links.cfm">
</header><br>
<h2>Inspeção de Conteúdos</h2>
<div class="container">
    <div class="row">
        <form id="inspetorForm" class="mt-3">
            <div class="form-row">
                <div class="form-group col-md-3">
                    <label for="data">Data</label>
                    <input type="text" class="form-control form-control-sm" id="data" name="data" readonly>
                </div>
                <div class="form-group col-md-3">
                    <label for="inspetor">Inspetor</label>
                    <input type="text" class="form-control form-control-sm" id="inspetor" name="inspetor" readonly>
                </div>
                <div class="form-group col-md-3">
                    <label for="modelo">Modelo</label>
                    <input type="text" class="form-control form-control-sm" id="modelo" name="modelo">
                </div>
                <div class="form-group col-md-3">
                    <label for="vin">VIN</label>
                    <input type="text" class="form-control form-control-sm" id="vin" name="vin">
                </div>
            </div>
        </form>
        <div class="col-md-6">
            <div class="col-md-6">
                <h5 style="margin-left:-3em; color:red">Etiqueta do Vidro</h5>
                <div id="foto-padrao" class="imagem-padrao1" onclick="toggleExpandirImagem(this)">
                    <img src="assets/imagem_padrao_1.png" alt="Ícone" style="margin-top:0em;margin-left:-3em;width:100%; height:auto;" class="titulo-icon">
                </div>
                <h6 style="margin-top:1em; margin-left:-2em">Foto Padrão 1</h6>
            </div>
                <div class="col-md-6" style="margin-top:-8em; margin-left:12em">
                    <h5 style="margin-left:-3em; color:red">Etiqueta do Vidro</h5>
                    <div id="foto-padrao" class="imagem-padrao1" onclick="toggleExpandirImagem2(this)">
                        <img src="assets/imagem_padrao_2.jpg" alt="Ícone" style="margin-top:0em;margin-left:-3em;width:100%; height:auto;" class="titulo-icon">
                    </div>
                    <h6 style="margin-top:1em; margin-left:-2em">Foto Padrão 2</h6>
                </div>
        </div>
    </div>
</div>

<script>
    function toggleExpandirImagem(element) {
        var img = element.querySelector('img');
        if (element.classList.contains('expandida')) {
            element.classList.remove('expandida');
            img.style.transform = 'scale(1)';
            // Remover event listener quando a imagem é reduzida
            document.removeEventListener('click', fecharImagemExpandida);
        } else {
            element.classList.add('expandida');
            img.style.transform = 'scale(0.7) translate(-70%, -70%)'; // Aumenta o tamanho da imagem e centraliza
            // Adicionar event listener para fechar a imagem expandida ao clicar fora
            document.addEventListener('click', fecharImagemExpandida);
        }
    }
    function fecharImagemExpandida(event) {
        var fotoPadrao = document.getElementById('foto-padrao');
        if (!fotoPadrao.contains(event.target)) { // Verifica se o clique foi fora da imagem expandida
            fotoPadrao.classList.remove('expandida');
            fotoPadrao.querySelector('img').style.transform = 'scale(1)';
            document.removeEventListener('click', fecharImagemExpandida);
        }
    }


    function toggleExpandirImagem2(element) {
        var img = element.querySelector('img');
        if (element.classList.contains('expandida')) {
            element.classList.remove('expandida');
            img.style.transform = 'scale(1)';
            // Remover event listener quando a imagem é reduzida
            document.removeEventListener('click', fecharImagemExpandida);
        } else {
            element.classList.add('expandida');
            img.style.transform = 'scale(0.3) translate(-160%, -160%)'; // Aumenta o tamanho da imagem e centraliza
            // Adicionar event listener para fechar a imagem expandida ao clicar fora
            document.addEventListener('click', fecharImagemExpandida);
        }
    }
    
</script>

</body>
</html>

