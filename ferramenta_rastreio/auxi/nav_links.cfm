<style>
  .navbar {
    background-color: #007fff;
    padding: 10px 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .navbar-brand, .nav-link {
    color: white !important;
    font-weight: bold;
    transition: all 0.3s ease;
  }

  .navbar-brand:hover, .nav-link:hover {
    color: #ff5100b6 !important;
    text-decoration: none;
    transform: translateY(-2px);
  }

  .navbar-title {
    margin-right: 20px;
    color: white;
    font-size: 1.25rem;
    font-weight: bold;
  }

  .btn-success, .btn-danger {
    font-weight: bold;
    padding: 8px 16px;
    border-radius: 5px;
    transition: all 0.3s ease;
  }

  .btn-success {
    background-color: #28a745;
    border-color: #28a745;
  }

  .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
  }

  .btn-success:hover, .btn-danger:hover {
    opacity: 0.9;
    transform: translateY(-2px);
  }

  .a-destaque {
    color: #ff5100b6 !important;
    text-decoration: underline;
  }

  .color-white {
    color: white !important;
    text-decoration: underline;
  }

  @media (max-width: 768px) {
    .navbar-title {
      font-size: 1rem;
    }

    .btn-success, .btn-danger {
      margin: 5px 0;
    }
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container-fluid">
    <!-- Título -->
    <h5 class="navbar-title">Sistema de Gestão da Qualidade</h5>

    <!-- Botão de toggle para mobile -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Itens do menu -->
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" href="index.cfm">Cadastrar Check List</a>
        </li>
      </ul>

      <!-- Botões de ação -->
      <div class="d-flex">
        <cfif valida.permissao eq 2>
          <button type="button" onclick="window.location.href='cadastro.cfm'" class="btn btn-success m-2">Usuários</button>
        </cfif>
        <button id="expireCookieBtn" type="button" onclick="redirect()" class="btn btn-danger m-2">Sair</button>
      </div>
    </div>
  </div>
</nav>

<script>
  const highlightActiveLink = () => {
    const url = new URL(window.location.href);
    const path = url.pathname;

    // Remove a classe de destaque de todos os links
    document.querySelectorAll(".nav-link, .dropdown-item").forEach(link => {
      link.classList.remove("color-white", "a-destaque");
    });

    // Destaca o link ativo com base no caminho da URL
    if (path.includes("cadastro")) {
      document.getElementById("navbarDropdown2").classList.add("color-white");

      if (path.includes("cadastrar_terceirizada")) {
        document.querySelectorAll(".dropdown-item")[0].classList.add("a-destaque");
      } else if (path.includes("exportar")) {
        document.querySelectorAll(".dropdown-item")[1].classList.add("a-destaque");
      } else if (path.includes("producao")) {
        document.querySelectorAll(".dropdown-item")[2].classList.add("a-destaque");
      } else if (path.includes("adicionais")) {
        document.querySelectorAll(".dropdown-item")[3].classList.add("a-destaque");
      }
    } else if (path.includes("cadastrar.cfm")) {
      document.querySelectorAll(".nav-link")[0].classList.add("color-white");
    } else if (path.includes("cadastrar_terceirizada")) {
      document.querySelectorAll(".nav-link")[1].classList.add("color-white");
    } else if (path.includes("exportar")) {
      document.querySelectorAll(".nav-link")[2].classList.add("color-white");
    }
  };

  // Executa a função ao carregar a página
  document.addEventListener("DOMContentLoaded", highlightActiveLink);
</script>