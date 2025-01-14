document.getElementById('goToPage2').addEventListener('click', () => {
    const page1 = document.getElementById('page1');
    const loading = document.getElementById('loading');
    const page2 = document.getElementById('page2');
  
    // Esconde a Página 1 e exibe o loading
    page1.classList.add('hidden');
    loading.classList.remove('hidden');
  
    // Após 3 segundos, esconde o loading e exibe a Página 2
    setTimeout(() => {
      loading.classList.add('hidden');
      page2.classList.remove('hidden');
    }, 3000);
  });
  