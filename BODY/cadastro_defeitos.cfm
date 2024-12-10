<cfinvoke method="inicializando" component="cf.ini.index">
  <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
  <cfheader name="Pragma" value="no-cache">
  <cfheader name="Expires" value="0">

<!DOCTYPE html>
<html lang="pt-br">
    <head>
       <!-- Required meta tags -->
       <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <title>Upload Body</title>
        <link rel="icon" type="image/png" href="assets/img/relatorio.png">
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
      
      <style>
            /* Estilo para o botão Deletar (btn-apagar) */
            .btn-apagar {
                background-color: yellow; /* Vermelho (Bootstrap danger) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }
        
            /* Estilo ao passar o mouse (hover) para o botão Deletar */
            .btn-apagar:hover {
                background-color: #c82333; /* Vermelho mais escuro */
                box-shadow: 0 0 8px rgba(220, 53, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }
        
            /* Estilo para o botão Liberar */
            .btn-liberar {
                background-color: #28a745; /* Verde (Bootstrap success) */
                color: white;
                border: none;
                padding: 5px 10px;
                font-size: 14px;
                border-radius: 4px;
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }
        
            /* Estilo ao passar o mouse (hover) para o botão Liberar */
            .btn-liberar:hover {
                background-color: #218838; /* Verde mais escuro */
                box-shadow: 0 0 8px rgba(40, 167, 69, 0.5); /* Sombra leve */
                cursor: pointer;
            }
            .container {
              margin-left: 10px; /* Margem à esquerda de 10 pixels */
           }

          .table {
              width: auto; /* Permite que a tabela use apenas a largura necessária */
              margin: 0; /* Remove margens padrão */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona um pouco de espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }

          .btn-liberar {
              background-color: #4CAF50; /* Cor de fundo do botão */
              color: white; /* Cor do texto do botão */
              border: none; /* Remove a borda do botão */
              padding: 5px 10px; /* Espaçamento interno do botão */
              cursor: pointer; /* Muda o cursor ao passar sobre o botão */
          }

          .btn-apagar {
              color: red; /* Cor do ícone de deletar */
              cursor: pointer; /* Muda o cursor ao passar sobre o ícone */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
          .tabela-container {
              display: flex; /* Usar flexbox para alinhar as tabelas horizontalmente */
              gap: 20px; /* Espaço entre as tabelas */
          }

          .table {
              width: 100%; /* Faz com que cada tabela ocupe a largura disponível */
              border-collapse: collapse; /* Colapsa as bordas da tabela */
          }

          .table th, .table td {
              padding: 8px; /* Adiciona espaçamento interno às células */
              border: 1px solid #ddd; /* Define uma borda leve */
          }

          .table th {
              background-color: #f2f2f2; /* Cor de fundo para cabeçalhos da tabela */
          }
          /* From Uiverse.io by omar49511 */ 
            .container-btn-file {
            display: flex;
            position: relative;
            justify-content: center;
            align-items: center;
            background-color: #307750;
            color: #fff;
            border-style: none;
            padding: 1em 2em;
            border-radius: 0.5em;
            overflow: hidden;
            z-index: 1;
            box-shadow: 4px 8px 10px -3px rgba(0, 0, 0, 0.356);
            transition: all 250ms;
            }
            .container-btn-file input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
            }
            .container-btn-file > svg {
            margin-right: 1em;
            }
            .container-btn-file::before {
            content: "";
            position: absolute;
            height: 100%;
            width: 0;
            border-radius: 0.5em;
            background-color: #469b61;
            z-index: -1;
            transition: all 350ms;
            }
            .container-btn-file:hover::before {
            width: 100%;
            }

      </style>

    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links1.cfm">
        </header><br><br><br><br><br>
        <h3 class="text-center mt-2">Upload Body</h3>
    <p style="margin-left:20%; font-size:18px;font-weight: bold;color:red;">Garanta que o arquivo enviado esteja exatamente da mesma maneira do modelo abaixo: </p>
    <div style="width:200px; margin-left:40%">
        <button class="container-btn-file" type="button" id="report">Download do modelo</button>
        <script>
            document.getElementById('report').addEventListener('click', function() {
                // URL do arquivo Excel
                var fileUrl = '/qualidade/BODY/auxi/BODY.xlsx';
                
                // Cria um elemento <a> temporário
                var a = document.createElement('a');
                a.href = fileUrl;
                a.download = 'BODY.xlsx'; // Nome do arquivo para download
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
            });
        </script>
    </div>
    <div class="container col-6 mt-5">
      <cfif isDefined("form.Defeito") and form.Defeito neq "">
          <cfquery name="insert" datasource="#BANCOSINC#">
              INSERT INTO INTCOLDFUSION.SISTEMA_QUALIDADE_BODY (ID, USER_DATA, USER_COLABORADOR)
              SELECT NVL(MAX(ID), 0) + 1, 
              '#form.Defeito#',
              SYSDATE
              FROM INTCOLDFUSION.SISTEMA_QUALIDADE_BODY
          </cfquery>
          <div class="alert alert-success" role="alert">
              Cadastrado com sucesso
          </div>
          <meta http-equiv="refresh" content="1.5, url=cadastro_defeitos.cfm">
      </cfif>
      <!--- Importar Meta via Arquivo excell --->
      <form action="auxi/defeitos_import.cfm" method="post" enctype="multipart/form-data" name="form2" class="import" style="width:500px; margin-left:50%;">
        <div class="mb-3 input-group">
<!---           <input class="form-control" type="file" id="formFile" name="file"> --->
          <button style="margin-left:35%;" class="container-btn-file" >
            <svg fill="#fff" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 50 50">
              <path d="M28.8125 .03125L.8125 5.34375C.339844 5.433594 0 5.863281 0 6.34375L0 43.65625C0 44.136719 .339844 44.566406 .8125 44.65625L28.8125 49.96875C28.875 49.980469 28.9375 50 29 50C29.230469 50 29.445313 49.929688 29.625 49.78125C29.855469 49.589844 30 49.296875 30 49L30 1C30 .703125 29.855469 .410156 29.625 .21875C29.394531 .0273438 29.105469 -.0234375 28.8125 .03125ZM32 6L32 13L34 13L34 15L32 15L32 20L34 20L34 22L32 22L32 27L34 27L34 29L32 29L32 35L34 35L34 37L32 37L32 44L47 44C48.101563 44 49 43.101563 49 42L49 8C49 6.898438 48.101563 6 47 6ZM36 13L44 13L44 15L36 15ZM6.6875 15.6875L11.8125 15.6875L14.5 21.28125C14.710938 21.722656 14.898438 22.265625 15.0625 22.875L15.09375 22.875C15.199219 22.511719 15.402344 21.941406 15.6875 21.21875L18.65625 15.6875L23.34375 15.6875L17.75 24.9375L23.5 34.375L18.53125 34.375L15.28125 28.28125C15.160156 28.054688 15.035156 27.636719 14.90625 27.03125L14.875 27.03125C14.8125 27.316406 14.664063 27.761719 14.4375 28.34375L11.1875 34.375L6.1875 34.375L12.15625 25.03125ZM36 20L44 20L44 22L36 22ZM36 27L44 27L44 29L36 29ZM36 35L44 35L44 37L36 37Z"></path>
            </svg>Upload File<input class="file" id="formFile" name="file" type="file" />
          </button>
          
          <button style="background-color:#bdb76b" class="container-btn-file" type="submit">Enviar</button>
        </div>
        <!--- <label for="formFile" class="form-label">Importar Programação Via Excel (Colunas devem estar na mesma ordem dos campos)</label> --->
      </form>
    </div>
  </body>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>