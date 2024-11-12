<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Batalha Naval</title>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <style>
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                overflow: hidden; /* Remove barras de rolagem */
                font-family: Arial, sans-serif;
            }
            
            body {
                display: flex;
                margin: 0;
                height: 100vh;
                font-family: Arial, sans-serif;
            }
        
            .sidebar {
                display: flex;
                flex-direction: column;
                padding: 10px;
                background: #f0f0f0;
                width: 150px;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }
        
            .sidebar button {
                margin-bottom: 10px;
                padding: 10px;
                cursor: pointer;
            }
        
            .images {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                background: white;
                position: relative;
            }
        
            .images img {
                max-width: 100%;
                max-height: 80vh;
                display: none;
                position: absolute;
                width: 500px;
                height: auto;
                top: 10%; /* Centraliza a imagem verticalmente */
                left: 50%; /* Centraliza a imagem horizontalmente */
                transform: translate(-50%, -50%); /* Ajusta para garantir o centro exato */
                transition: top 0.7s; /* Transição suave para mover a imagem */
            }
        
            .resizable {
                position: relative;
                border: 1px solid #ccc;
            }
        
            .resizable::after {
                content: "";
                position: absolute;
                width: 20px;
                height: 20px;
                background: #333;
                right: 0;
                bottom: 0;
                cursor: nwse-resize;
            }
        </style>
        
</head>
<body>
    <header class="titulo">
        <cfinclude template="auxi/nav_links1.cfm">
    </header><br><br><br><br><br><br>
    <div class="sidebar">
        <button onclick="showImage('img1')">HR</button>
        <button onclick="showImage('img2')">CHASSI HR</button>
        <button onclick="showImage('img9')">TL</button>
        <button onclick="showImage('img3')">CHERY</button>
    </div>

    <div class="images">
        <img id="img1" class="resizable" src="./imgs/HR.png" alt="Imagem 1">
        <img id="img2" class="resizable" src="./imgs/CHASSI_HR.png" alt="Imagem 2">
        <img id="img9" class="resizable" src="./imgs/TL.png" alt="Imagem 9">
        <img id="img3" class="resizable" src="./imgs/chery.png" alt="Imagem 3">
    </div>

    <script src="https://cdn.jsdelivr.net/npm/interactjs@1.10.11/dist/interact.min.js"></script>
    <script>
        function showImage(id) {
            // Hide all images
            const images = document.querySelectorAll('.images img');
            images.forEach(img => img.style.display = 'none');

            // Show the selected image
            const selectedImage = document.getElementById(id);
            if (selectedImage) {
                selectedImage.style.display = 'block';
            }
        }

        interact('.resizable')
            .resizable({
                edges: { left: true, right: true, bottom: true, top: true },
                listeners: {
                    move(event) {
                        const { target } = event;
                        const x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
                        const y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

                        // Update the element's style
                        target.style.width = `${event.rect.width}px`;
                        target.style.height = `${event.rect.height}px`;

                        // Translate when resizing
                        target.style.transform = `translate(${x}px, ${y}px)`;
                        target.setAttribute('data-x', x);
                        target.setAttribute('data-y', y);
                    }
                }
            })
            .draggable({
                listeners: {
                    move(event) {
                        const { target } = event;
                        const x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
                        const y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

                        target.style.transform = `translate(${x}px, ${y}px)`;
                        target.setAttribute('data-x', x);
                        target.setAttribute('data-y', y);
                    }
                }
            });
    </script>
</body>
</html>
