<cfinvoke method="inicializando" component="cf.ini.index">
    <html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Inspeção de Conteúdos FAI</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="qualidade/buyoff_linhat/assets/StyleBuyOFF.css?v10">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            #video-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: flex-start;
                margin-right: 20px;
            }
            
            #video {
                max-width: 100%;
                height: auto;
            }

            
            .btn-group-vertical {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 5px 200px;
                margin-left: 20px
            }
            
            .btn-group-vertical button {
                margin-bottom: 20px;
                padding: 4px 50px; /* Ajuste de padding para diminuir o tamanho dos botões */
                font-size: 14px; /* Ajuste opcional para diminuir o tamanho da fonte dos botões */
                margin-left: -450px
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
                <form id="inspetorForm" class="mt-4">
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="data">Data</label>
                            <input type="text" class="form-control form-control-sm" id="data" name="data" readonly>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="inspetor">Inspetor</label>
                            <input type="text" class="form-control form-control-sm" id="inspetor" name="inspetor" readonly>
                        </div>
                        <div class="form-group col-md-3">
                            <label for="modelo">Modelo</label>
                            <input type="text" class="form-control form-control-sm" id="modelo" name="modelo">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="vin">VIN</label>
                            <input type="text" class="form-control form-control-sm" id="vin" name="vin">
                        </div>
                    </div>
                </form>
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-6">
                            <div id="video-container" class="btn-group-vertical">
                                <button class="btn btn-primary btn-sm custom-btn" title="Abrir Câmera" onclick="abrirCamera()"><i class="material-icons">camera_alt</i></button>
                                <button class="btn btn-primary btn-sm custom-btn" title="Capturar imagem" onclick="capturarImagem()"><i class="material-icons">camera</i></button>
                                <button class="btn btn-success btn-sm custom-btn" title="Salvar Foto" onclick="salvarImagem()"><i class="material-icons">save</i></button>
                                <button class="btn btn-warning btn-sm custom-btn" title="Apagar Foto" onclick="limparImagens()"><i class="material-icons">delete</i></button>
                                <button class="btn btn-danger btn-sm custom-btn" title="Desligar Câmera" onclick="desligarCamera()"><i class="material-icons">power_off</i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-6">
                            <div id="video-container">
                                <video id="video" style="max-width: 100%; height: auto; display: none;" autoplay></video>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div id="captura-container">
                                <canvas id="canvas" width="1280" height="720" style="display: none;"></canvas>
                                <div id="imagens-preview" class="d-flex flex-wrap justify-content-start"></div>
                            </div>
                        </div>
                    </div>
                </div>                
            </div>
        </div>
        
        
        <!-- Formulário oculto para envio da imagem -->
        <form id="uploadForm" action="salvar_imagem.cfm" method="post" enctype="multipart/form-data" style="display: none;">
            <input type="hidden" id="imagemBase64" name="imagemBase64">
        </form>
    
        <!-- Container para mensagens de sucesso/erro -->
        <div id="container-mensagens"></div>
    
        <script>
            const video = document.getElementById('video');
            const canvas = document.getElementById('canvas');
            const context = canvas.getContext('2d');
            let stream = null; // Variável para guardar o stream da câmera
    
            document.addEventListener('DOMContentLoaded', (event) => {
                // Preencher data com a data de hoje
                const today = new Date().toLocaleDateString('pt-BR');
                document.getElementById('data').value = today;
    
                // Coletar o nome do inspetor do cookie
                const inspetor = getCookie('inspetor');
                if (inspetor) {
                    document.getElementById('inspetor').value = inspetor;
                }
            });
    
            function abrirCamera() {
                if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                    navigator.mediaDevices.getUserMedia({ video: true })
                    .then(function(strm) {
                        stream = strm; // Guarda o stream da câmera na variável global
                        video.srcObject = stream;
                        video.style.display = 'block';
                        limparImagens(); // Limpa imagens ao abrir a câmera
                    })
                    .catch(function(error) {
                        console.error('Erro ao acessar a câmera: ', error);
                        alert('Erro ao acessar a câmera: ' + error.message);
                    });
                } else {
                    alert('Seu navegador não suporta captura de câmera.');
                }
            }
    
            function desligarCamera() {
                if (stream) {
                    const tracks = stream.getTracks();
                    tracks.forEach(track => track.stop());
                    video.srcObject = null;
                    video.style.display = 'none';
                    limparImagens(); // Limpa também as imagens ao desligar a câmera
                }
            }
    
            function capturarImagem() {
                context.drawImage(video, 0, 0, canvas.width, canvas.height);
                exibirImagemCapturada();
            }let imagensCapturadas = []; // Array para armazenar as imagens capturadas

function exibirImagemCapturada() {
    const dataURL = canvas.toDataURL('image/jpeg', 0.7); // Reduz a qualidade para 70%
    imagensCapturadas.push(dataURL); // Adiciona a imagem ao array

    const imgElement = document.createElement('img');
    imgElement.src = dataURL;
    imgElement.alt = 'Imagem Capturada';
    imgElement.classList.add('captured-image'); // Adiciona uma classe para estilização

    // Redimensiona a imagem para exibição e adiciona à div de pré-visualização
    const imagensPreview = document.getElementById('imagens-preview');
    imgElement.style.maxWidth = '100px'; // Ajuste o tamanho máximo conforme necessário
    imgElement.style.marginRight = '10px'; // Espaçamento entre as imagens
    imagensPreview.appendChild(imgElement);

    // Verifica se já foram capturadas 22 imagens
    if (imagensCapturadas.length >= 22) {
        // Desabilita o botão de captura após 22 imagens
        document.querySelector('button[title="Capturar imagem"]').disabled = true;
    }
}

function salvarImagens() {
    // Itera sobre todas as imagens capturadas e as salva
    imagensCapturadas.forEach((dataURL, index) => {
        const imagemBase64 = dataURL.replace(/^data:image\/jpeg;base64,/, '');

        // Cria um objeto FormData para enviar a imagem via POST
        const formData = new FormData();
        formData.append('imagemBase64', imagemBase64);

        // Realiza a requisição AJAX para salvar_imagem.cfm
        fetch('salvar_imagem.cfm', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Erro HTTP: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            // Verifica se a operação foi bem-sucedida
            if (data.success) {
                // Exibe mensagem de sucesso para cada imagem salva
                const mensagemSucesso = document.createElement('div');
                mensagemSucesso.textContent = `Imagem ${index + 1} salva com sucesso: ${data.fileName}`;
                mensagemSucesso.classList.add('alert', 'alert-success');

                const containerMensagens = document.getElementById('container-mensagens');
                containerMensagens.appendChild(mensagemSucesso);

                // Limpa a visualização da imagem na página
                limparImagens();
            } else {
                // Exibe mensagem de erro
                alert(`Erro ao salvar a imagem ${index + 1}: ${data.error}`);
            }
        })
        .catch(error => {
            console.error(`Erro na requisição da imagem ${index + 1}:`, error);
            alert(`Erro ao salvar a imagem ${index + 1}: ${error.message}`);
        });
    });
}

function limparImagens() {
    // Limpa a visualização das imagens
    const imagensPreview = document.getElementById('imagens-preview');
    imagensPreview.innerHTML = '';

    // Limpa mensagens de sucesso ou erro anteriores
    const containerMensagens = document.getElementById('container-mensagens');
    containerMensagens.innerHTML = '';
}

        </script>
    </body>
    </html>
    
