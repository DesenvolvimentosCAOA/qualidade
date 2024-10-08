<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">
<html lang="pt-BR">

<!--- Verificando se está logado  --->
<cfif not isDefined("cookie.USER_APONTAMENTO_FA") or cookie.USER_APONTAMENTO_FA eq "">
    <script>
        alert("É necessario autenticação!!");
        self.location = '/qualidade/buyoff_linhat/index.cfm'
    </script>
</cfif>


<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "R">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_reparo.cfm'
    </script>
</cfif>

<cfif not isDefined("cookie.user_level_final_assembly") or cookie.user_level_final_assembly eq "P">
    <script>
        alert("É necessário autorização!!");
        self.location= 'fa_indicadores_1.cfm'
    </script>
</cfif>

<html lang="pt-BR">
  <head>
      <!-- Required meta tags-->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>Seleciona a Barreira</title>
      <link rel="stylesheet" href="assets/StyleBuyOFF.css?v2">
      <link rel="icon" href="./assets/chery.png" type="image/x-icon">
      <style>
          html, body {
            margin: 0;
            padding: 0;
            overflow: hidden; /* Remove barras de rolagem */
            background: black; /* Fundo preto */
            text-align: center;
            font-family: sans-serif;
            color: #fefefe; /* Texto em cor clara para contraste */
        }
  
          /* Estilos para o vídeo */
          .video-container {
              margin: 10px auto;
              text-align: center;
          }
          .video-container video {
              width: 60%; /* Ajuste para definir a largura do vídeo */
              height: auto;
              max-width: 600px; /* Ajuste para definir a largura máxima do vídeo */
          }
      </style>
  </head>
  <body>
      <header class="titulo">
          <cfinclude template="auxi/nav_links.cfm">
      </header>
      <br><br><br><br><br><br>
  
      <!-- Adicionando o vídeo centralizado com loop eterno -->
      <div class="video-container">
        <video autoplay muted playsinline>
              <source src="./img/lv_0_20240912141226.mp4" type="video/mp4">
              Seu navegador não suporta o elemento de vídeo.
          </video>
      </div>
  </body>
  </html>
  