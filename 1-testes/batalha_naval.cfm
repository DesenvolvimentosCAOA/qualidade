<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Batalha Naval do Veículo</title>
    <style>
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .grid-wrapper {
            display: flex;
        }

        .y-axis {
            display: grid;
            grid-template-rows: repeat(20, 40px);
            margin-right: 5px;
        }

        .x-axis-wrapper {
            display: flex;
            margin-bottom: 5px;
            height: 40px;
        }

        .x-axis {
            display: grid;
            grid-template-columns: repeat(14, 40px);
        }

        .x-axis div, .y-axis div {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            font-weight: bold;
        }

        .grid-container {
            display: grid;
            grid-template-columns: repeat(14, 40px);
            grid-template-rows: repeat(20, 40px);
            width: 560px; /* 14 colunas * 40px */
            height: 800px; /* 20 linhas * 40px */
            background-image: url('assets/batalha2.png'); /* Substitua pelo caminho da sua imagem */
            background-size: cover;
        }

        .grid-item {
            border: 1px solid rgba(0, 0, 0, 0.1);
            cursor: pointer;
            width: 40px;
            height: 40px;
        }

        .grid-item.clicked {
            background-color: rgba(255, 0, 0, 0.5);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="x-axis-wrapper">
            <div style="width: 40px; height: 40px;"></div>
            <div class="x-axis">
                <!-- Cria os rótulos do eixo X (A-N) -->
                <cfset letras = "ABCDEFGHIJKLMN">
                <cfoutput>
                <cfloop from="1" to="14" index="x">
                    <div>#mid(letras, x, 1)#</div>
                </cfloop>
                </cfoutput>
            </div>
        </div>
        <div class="grid-wrapper">
            <div class="y-axis">
                <!-- Cria os rótulos do eixo Y (1-20) -->
                <cfoutput>
                <cfloop from="1" to="20" index="y">
                    <div>#y#</div>
                </cfloop>
                </cfoutput>
            </div>
            <div class="grid-container" id="gridContainer">
                <!-- Cria uma grade 20x14 -->
                <cfoutput>
                <cfloop from="1" to="20" index="y">
                    <cfloop from="1" to="14" index="x">
                        <cfset id = mid(letras, x, 1) & y>
                        <div class="grid-item" data-id="#id#"></div>
                    </cfloop>
                </cfloop>
                </cfoutput>
            </div>
        </div>
    </div>
    <button onclick="saveData()">Salvar</button>

    <script>
        document.addEventListener('DOMContentLoaded', (event) => {
            const gridItems = document.querySelectorAll('.grid-item');

            gridItems.forEach(item => {
                item.addEventListener('click', () => {
                    item.classList.toggle('clicked');
                    const id = item.getAttribute('data-id');
                    document.cookie = `clicked_${id}=true; path=/;`;
                });
            });
        });

        function saveData() {
            // Redireciona para a página de salvamento em ColdFusion
            window.location.href = 'saveData.cfm';
        }
    </script>
</body>
</html>
