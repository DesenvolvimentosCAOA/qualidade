<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Sistema de Gestão da Qualidade</title>
        <link rel="stylesheet" href="./assets/style.css"/>
        <link rel="icon" href="./assets/chery.png" type="image/x-icon">
        <style>
            /* Estilos para o vídeo de fundo */
            html, body {
                height: 100%;
                margin: 0;
                font-family: Arial, sans-serif;
                overflow: auto; /* Alterado para permitir rolagem se necessário */
            }
    
            /* Estilo do vídeo para cobrir toda a tela */
            .background-video {
                position: fixed; /* Alterado para fixed para evitar problemas de rolagem */
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                z-index: -1;
            }
            
            /* Container principal */
            .main-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 20px;
                gap: 30px;
            }
            
            /* Estilos para as seções de botões */
            .section {
                width: 100%;
                max-width: 1200px;
                background-color: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(5px);
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            }
            
            .section-title {
                color: white;
                text-align: center;
                margin-bottom: 20px;
                font-size: 24px;
                text-transform: uppercase;
                letter-spacing: 2px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }
    
            .button-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }
    
            .button {
                min-width: 150px;
                min-height: 40px;
                display: inline-flex;
                font-family: 'Nunito', sans-serif;
                font-size: 14px;
                align-items: center;
                justify-content: center;
                text-transform: uppercase;
                text-align: center;
                letter-spacing: 1.3px;
                font-weight: 700;
                color: #313133;
                background: #4FD1C5;
                background: linear-gradient(90deg, rgba(129,230,217,1) 0%, rgba(79,209,197,1) 100%);
                border: none;
                border-radius: 1000px;
                box-shadow: 12px 12px 24px rgba(79,209,197,.64);
                transition: all 0.3s ease-in-out 0s;
                cursor: pointer;
                outline: none;
                position: relative;
                padding: 10px;
                opacity: 0;
                animation: fadeIn 1s forwards;
            }
    
            /* Cores diferentes para QA */
            .button.qa {
                background: #9d4fd1;
                background: linear-gradient(90deg, rgba(157,79,209,1) 0%, rgba(123,44,191,1) 100%);
                box-shadow: 12px 12px 24px rgba(123,44,191,.64);
            }
    
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
    
            /* Ajuste os delays de animação conforme necessário */
            .button:nth-child(1) { animation-delay: 0s; }
            .button:nth-child(2) { animation-delay: 0.2s; }
            .button:nth-child(3) { animation-delay: 0.4s; }
            .button:nth-child(4) { animation-delay: 0.6s; }
            .button:nth-child(5) { animation-delay: 0.8s; }
            .button:nth-child(6) { animation-delay: 1s; }
            .button:nth-child(7) { animation-delay: 1.2s; }
            .button:nth-child(8) { animation-delay: 1.4s; }
            .button:nth-child(9) { animation-delay: 1.6s; }
            .button:nth-child(10) { animation-delay: 1.8s; }
            .button:nth-child(11) { animation-delay: 2s; }
    
            /* Mantenha os estilos existentes para o botão de logout e dicas */
            .Btn {
                display: flex;
                align-items: center;
                justify-content: flex-start;
                width: 45px;
                height: 45px;
                border: none;
                border-radius: 50%;
                cursor: pointer;
                position: fixed;
                top: 20px;
                right: 20px;
                overflow: hidden;
                transition-duration: .3s;
                box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.199);
                background-color: rgb(255, 65, 65);
                z-index: 9999;
            }
    
            .hint {
                text-decoration: none;
                position: relative;
                display: inline-block;
            }
    
            .hint-dot {
                background-color: #000;
                color: #fff;
                padding: 15px 30px;
                border-radius: 50px;
                font-weight: bold;
                font-size: 30px;
                transition: background-color 0.3s;
                text-align: center;
            }
    
            .hint-dot:hover {
                background-color: #333;
            }
    
            .hint-content {
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                background-color: #333;
                color: white;
                padding: 10px;
                border-radius: 5px;
                font-size: 25px;
                text-align: center;
                visibility: hidden;
                opacity: 0;
                transition: opacity 0.3s, visibility 0.3s;
                white-space: nowrap;
            }
    
            .hint:hover .hint-content {
                visibility: visible;
                opacity: 1;
            }
    
            /* Estilos responsivos */
            @media (max-width: 768px) {
                .button {
                    min-width: 120px;
                    padding: 10px 15px;
                    font-size: 12px;
                }
                
                .section {
                    padding: 15px;
                }
                
                .section-title {
                    font-size: 20px;
                }
                
                .hint-dot {
                    padding: 10px 20px;
                    font-size: 20px;
                }
                
                .hint-content {
                    font-size: 16px;
                }
            }
        </style>
    </head>
    
    <body>
        <!-- Vídeo de fundo -->
        <video class="background-video" autoplay muted loop>
            <source src="./imgs/dash.mp4" type="video/mp4">
            Seu navegador não suporta vídeos.
        </video>
        
        <!-- Botão de Logout -->
        <a href="./index.cfm" class="Btn">
            <div class="sign">
                <svg viewBox="0 0 512 512">
                    <path d="M377.9 105.9L500.7 228.7c7.2 7.2 11.3 17.1 11.3 27.3s-4.1 20.1-11.3 27.3L377.9 406.1c-6.4 6.4-15 9.9-24 9.9c-18.7 0-33.9-15.2-33.9-33.9l0-62.1-128 0c-17.7 0-32-14.3-32-32l0-64c0-17.7 14.3-32 32-32l128 0 0-62.1c0-18.7 15.2-33.9 33.9-33.9c9 0 17.6 3.6 24 9.9zM160 96L96 96c-17.7 0-32 14.3-32 32l0 256c0 17.7 14.3 32 32 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32l-64 0c-53 0-96-43-96-96L0 128C0 75 43 32 96 32l64 0c17.7 0 32 14.3 32 32s14.3 32 32 32c53 0 96 43 96 96l0 256c0 53-43 96-96 96z"></path>
                </svg>
            </div>
            <div class="text">Sair</div>
        </a>
        
        <!-- Container principal -->
        <div class="main-container">
            <!-- Seção QC -->
            <div class="section">
                <h2 class="section-title">Controle de Qualidade (QC)</h2>
                <div class="button-container">
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/EbWR2nq_gFpFtRiNm4I7newBgHKdcLYnwIitnPa0XqmEQA?e=vmHFS2" class="button hint">
                        <div class="hint-dot">BODY</div>
                        <div class="hint-content">Dashboard-Body</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/EbyxK29bB5hJsR3nx4NElvUBwgOCbjykRxVPgv2UwqL0oA?e=6FtaB2" class="button hint">
                        <div class="hint-dot">PAINT</div>
                        <div class="hint-content">Dashboard-Paint</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/EeH_L_Nbq3pOqmU-kdLstlkB7MJ9DiPrqtdr4CI7dOfFdg?e=YbgFSw" class="button hint">
                        <div class="hint-dot">FA</div>
                        <div class="hint-content">Dashboard-FA</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/EYBYQIXIOmNFr17WlDf73IkBpm8oRzcSir3VuHhypPs5xA?e=BjWC7F" class="button hint">
                        <div class="hint-dot">FAI</div>
                        <div class="hint-content">Dashboard-FAI</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/sites/CockpitBI2/SitePages/PLANO-DE-CONTROLE-QC-QA---PDI.aspx?csf=1&web=1&e=ss9cuz&CID=57f53d21-f490-4e10-93d0-dd2202f50679" class="button hint">
                        <div class="hint-dot">PDI</div>
                        <div class="hint-content">Dashboard-PDI</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/ERyhiNp8CBVGuFj4okt0--cBCLq2uhRe19zQ_b9Tyjkx0Q?e=VoiT8O" class="button hint">
                        <div class="hint-dot">Field Issues</div>
                        <div class="hint-content">KPI-Field Issues</div>
                    </a>
                    <a href="https://caoamontadora.sharepoint.com/:u:/s/CockpitBI2/EeT6_22uSlNNkxY22Qpuen0BeMSipObwC8YitYC6cehbTg?e=oMtZGr" class="button hint">
                        <div class="hint-dot">RNC's</div>
                        <div class="hint-content">KPI RNC</div>
                    </a>
                </div>
            </div>
            
            <!-- Seção QA -->
            <div class="section">
                <h2 class="section-title">Garantia de Qualidade (QA)</h2>
                <div class="button-container">
                    <!-- Adicione aqui os 11 botões da categoria QA -->
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiOTRmMzhmOTItNTNkNS00ZDUyLWI0MjUtMzBlNDMxODZmZWEzIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Controle global de Falhas</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiMzQwODYzZTAtYjJlZS00ODk0LWE4MzEtZDM5YTg3NWU2NTRkIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">IPTV CPV FQE</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiM2RlMjlhOTQtZGFkOS00MGYwLTgxNTAtYjQxNDM3ODJkODkzIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Inspeção e Retrabalho</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiZDhlMDFkMzctZTM3MC00YzFhLWFlMDUtZGU0NDA0NzBiYjE2IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Atendimento a Linha OPerações</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiNTY2MjRlMTQtYzdmNy00ZDFkLWI2MGEtMWMwMGNiOWUwOTc5IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Custo Por Refugo Manufatura</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiYzcwMjkwMDQtZTY4Ny00NTIwLTg3MzgtNjE1ZmUwYmMwMWJjIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Salvage</div>
                        <div class="hint-content">Dashboard QA 6</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiM2RlMjlhOTQtZGFkOS00MGYwLTgxNTAtYjQxNDM3ODJkODkzIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Impacto Manufatura</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiODM0YjM2MmUtMTk0OC00ZTc1LWJmNjUtMTUxMzc3ODM5MjYyIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Controle de Desvio de ID's CKD</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiODNhYWY2YzktNjg5OC00OWE3LTliNjMtOTE5YTAyMzM1NjdkIiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Gestão de Relatórios</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiMWMwNzFiZTEtYWZhMS00ZDNmLWIwYzgtOTRhMDUyYWJlMDk5IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Status de Reposição</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                    <a href="https://app.powerbi.com/view?r=eyJrIjoiMDJhOTY0MGUtYWU5NC00NTE4LTk5ZmQtN2Y5NzI3YzAxYWU2IiwidCI6IjE2OTE1YmY1LTg2YmUtNDM1YS04NDhmLWNlMDJjNjA4NzliMyJ9" class="button hint qa">
                        <div class="hint-dot">Desempenho de Fornecedores Nacionais</div>
                        <div class="hint-content">Dashboard</div>
                    </a>
                </div>
            </div>
        </div>
    </body>
</html>