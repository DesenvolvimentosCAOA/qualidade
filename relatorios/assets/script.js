function filterTable() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchID").value.toUpperCase();
    var inputVIN = document.getElementById("searchVIN").value.toUpperCase();
    var inputPeca = document.getElementById("searchPeca").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicao").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblema").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("bodyTable");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[2];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;

            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}

function filterTablePaint() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchIDP").value.toUpperCase();
    var inputVIN = document.getElementById("searchVINP").value.toUpperCase();
    var inputPeca = document.getElementById("searchPecaP").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicaoP").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblemaP").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("tablePaint");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[2];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;

            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}


function filterTableFA() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchIDFA").value.toUpperCase();
    var inputVIN = document.getElementById("searchVINFA").value.toUpperCase();
    var inputPeca = document.getElementById("searchPecaFA").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicaoFA").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblemaFA").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("tableFA");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[2];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;

            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}

function filterTableFAI() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchIDFAI").value.toUpperCase();
    var inputVIN = document.getElementById("searchVINFAI").value.toUpperCase();
    var inputPeca = document.getElementById("searchPecaFAI").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicaoFAI").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblemaFAI").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("tableFAI");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[2];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;

            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}

function filterTablePDI() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchIDPDI").value.toUpperCase();
    var inputVIN = document.getElementById("searchVINPDI").value.toUpperCase();
    var inputPeca = document.getElementById("searchPecaPDI").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicaoPDI").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblemaPDI").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("tablePDI");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[2];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;

            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}

// Variáveis globais para armazenar os filtros de status e barreira ativos
var activeFilter = ''; // Nenhum filtro de status ativo inicialmente
var activeBarreira = ''; // Nenhum filtro de barreira ativo inicialmente

// Função de filtro principal
function filterTableACOMP() {
    // Obtendo os valores dos inputs
    var inputID = document.getElementById("searchIDACOMP").value.toUpperCase();
    var inputVIN = document.getElementById("searchVINACOMP").value.toUpperCase();
    var inputPeca = document.getElementById("searchPecaACOMP").value.toUpperCase();
    var inputPosicao = document.getElementById("searchPosicaoACOMP").value.toUpperCase();
    var inputProblema = document.getElementById("searchProblemaACOMP").value.toUpperCase();
    
    // Pegando a tabela e suas linhas
    var table = document.getElementById("ACOMPTable");
    var tr = table.getElementsByTagName("tr");

    // Loop para filtrar os dados
    for (var i = 1; i < tr.length; i++) { // Inicia em 1 para pular o cabeçalho
        var tdID = tr[i].getElementsByTagName("td")[0];
        var tdVIN = tr[i].getElementsByTagName("td")[3];
        var tdPeca = tr[i].getElementsByTagName("td")[4];
        var tdPosicao = tr[i].getElementsByTagName("td")[5];
        var tdProblema = tr[i].getElementsByTagName("td")[6];
        var tdBarreira = tr[i].getElementsByTagName("td")[7]; // Coluna BARREIRA
        var tdStatus = tr[i].getElementsByTagName("td")[8]; // Coluna STATUS

        if (tdID && tdVIN && tdPeca && tdPosicao && tdProblema && tdBarreira && tdStatus) {
            // Verificando se os dados correspondem aos filtros
            var matchID = tdID.innerHTML.toUpperCase().indexOf(inputID) > -1;
            var matchVIN = tdVIN.innerHTML.toUpperCase().indexOf(inputVIN) > -1;
            var matchPeca = tdPeca.innerHTML.toUpperCase().indexOf(inputPeca) > -1;
            var matchPosicao = tdPosicao.innerHTML.toUpperCase().indexOf(inputPosicao) > -1;
            var matchProblema = tdProblema.innerHTML.toUpperCase().indexOf(inputProblema) > -1;
            var matchStatus = true; // Default to true if no status filter is applied
            var matchBarreira = true; // Default to true if no barreira filter is applied

            // Aplicando o filtro de status se estiver ativo
            if (activeFilter === 'FALTA CONTENÇÃO') {
                matchStatus = tdStatus.innerHTML.indexOf("FALTA CONTENÇÃO") > -1;
            }
            if (activeFilter === 'CONCLUÍDO') {
                matchStatus = tdStatus.innerHTML.indexOf("CONCLUÍDO") > -1;
            }
            if (activeFilter === 'AG. BP DEFINITIVO') {
                matchStatus = tdStatus.innerHTML.indexOf("AG. BP DEFINITIVO") > -1;
            }

            // Aplicando o filtro de barreira se estiver ativo
            if (activeBarreira) {
                console.log(`Comparando BARREIRA: ${tdBarreira.innerHTML.trim()} com ${activeBarreira}`); // Debugging
                matchBarreira = tdBarreira.innerHTML.trim().indexOf(activeBarreira) > -1; // Usando trim() para remover espaços
            }

            // Exibindo ou ocultando a linha dependendo dos filtros
            if (matchID && matchVIN && matchPeca && matchPosicao && matchProblema && matchStatus && matchBarreira) {
                tr[i].style.display = ""; // Mostra a linha
            } else {
                tr[i].style.display = "none"; // Esconde a linha
            }
        }
    }
}

// Função para ativar o filtro de status
function toggleStatusFilter(status) {
    if (activeFilter === status) {
        activeFilter = ''; // Desativa o filtro
    } else {
        activeFilter = status; // Ativa o filtro correspondente
    }
    filterTableACOMP(); // Reaplica o filtro
}

// Função para ativar o filtro de barreira
function toggleBarreiraFilter(barreira) {
    if (activeBarreira === barreira) {
        activeBarreira = ''; // Desativa o filtro
    } else {
        activeBarreira = barreira; // Ativa o filtro correspondente
    }
    filterTableACOMP(); // Reaplica o filtro
}

// Função para limpar todos os filtros
function clearFilters() {
    activeFilter = ''; // Limpa o filtro de status
    activeBarreira = ''; // Limpa o filtro de barreira
    document.getElementById("searchIDACOMP").value = ''; // Limpa o campo ID
    document.getElementById("searchVINACOMP").value = ''; // Limpa o campo VIN
    document.getElementById("searchPecaACOMP").value = ''; // Limpa o campo PECA
    document.getElementById("searchPosicaoACOMP").value = ''; // Limpa o campo POSICAO
    document.getElementById("searchProblemaACOMP").value = ''; // Limpa o campo PROBLEMA
    filterTableACOMP(); // Reaplica o filtro para mostrar todos os dados
}


function showTable(tableId) {
    // Esconde todas as tabelas
    var tables = document.querySelectorAll('.table-container');
    tables.forEach(function(table) {
        table.style.display = 'none';
    });

    // Exibe a tabela selecionada
    var selectedTable = document.getElementById(tableId);
    if (selectedTable) {
        selectedTable.style.display = 'block';
    }
}

function calcularRPN() {
    // Obtendo os valores selecionados
    var severidade = parseInt(document.getElementById('searchSeveridade').value) || 0;
    var ocorrencia = parseInt(document.getElementById('searchOcorrência').value) || 0;
    var deteccao = parseInt(document.getElementById('searchDetecção').value) || 0;

    // Calculando o RPN
    var rpn = severidade * ocorrencia * deteccao;

    // Exibindo o resultado no campo RPN
    document.getElementById('searchRPN').value = rpn;
}

function calcularPrazo() {
    // Obter a data atual do campo readonly
    var dataAtual = new Date(document.getElementById('searchData').value);
    
    // Obter a data de prazo inserida pelo usuário
    var dataPrazo = new Date(document.getElementById('searchPrazo').value);
    
    // Verificar se a data de prazo foi inserida
    if (!dataPrazo) {
        document.getElementById('tooltipPrazo').style.visibility = 'hidden';
        return;
    }

    // Calcular a diferença de tempo entre as datas
    var diferencaTempo = dataPrazo.getTime() - dataAtual.getTime();
    
    // Converter a diferença de tempo em dias
    var diferencaDias = Math.ceil(diferencaTempo / (1000 * 3600 * 24));

    // Atualizar o conteúdo do tooltip com a diferença de dias
    var mensagem = diferencaDias + " dias restantes";
    var tooltipPrazo = document.getElementById('tooltipPrazo');
    tooltipPrazo.textContent = mensagem;
    
    // Tornar o tooltip visível
    tooltipPrazo.style.visibility = 'visible';
}

function habilitarEdicao() {
    // Ocultar o botão "Editar"
    document.getElementById('btnEditar').style.display = 'none';

    // Habilitar os campos para edição
    document.getElementById('searchSeveridade').disabled = false;
    document.getElementById('searchOcorrência').disabled = false;
    document.getElementById('searchDetecção').disabled = false;
    document.getElementById('searchGrupo').disabled = false; // Habilita o campo de grupo
    document.getElementById('searchTurno').disabled = false; // Habilita o campo de turno

    // Exibir os botões "Salvar Edição" e "Cancelar"
    document.getElementById('btnSalvarEdicao').style.display = 'inline-block';
    document.getElementById('btnCancelarEdicao').style.display = 'inline-block';
}

function cancelarEdicao() {
    // Exibir o botão "Editar"
    document.getElementById('btnEditar').style.display = 'inline-block';

    // Desabilitar os campos de edição
    document.getElementById('searchSeveridade').disabled = true;
    document.getElementById('searchOcorrência').disabled = true;
    document.getElementById('searchDetecção').disabled = true;
    document.getElementById('searchGrupo').disabled = true;
    document.getElementById('searchTurno').disabled = true;

    // Ocultar os botões "Salvar Edição" e "Cancelar"
    document.getElementById('btnSalvarEdicao').style.display = 'none';
    document.getElementById('btnCancelarEdicao').style.display = 'none';
}




// Função para voltar
function voltar() {
    // Redireciona para a página anterior
    window.history.back(); // ou utilize: window.location.href = 'pagina-desejada.cfm'; para redirecionar a uma página específica
}


function verificaCamposPreenchidos() {
    // Obtém os valores dos campos
    var pontoCorte = document.getElementById("searchBP").value;
    var responsavel = document.getElementById("searchResponsavel").value;
    var descricao = document.getElementById("searchDescricaoC").value; // Corrigido para "searchDescricaoC"
    var statusField = document.getElementById("searchSTATUS");

    // Verifica se todos os campos estão preenchidos
    if (pontoCorte.trim() !== "" && responsavel.trim() !== "" && descricao.trim() !== "") {
        statusField.value = "AG. BP DEFINITIVO";
        statusField.classList.add("status-validacao"); // Adiciona a classe de estilo para validação
        statusField.classList.remove("status-andamento"); // Remove a classe de andamento, se existir
    } else {
        statusField.value = "FALTA CONTENÇÃO"; // Define como "FALTA CONTENÇÃO" se não estiver preenchido
        statusField.classList.add("status-andamento"); // Adiciona a classe de estilo para andamento
        statusField.classList.remove("status-validacao"); // Remove a classe de validação, se existir
    }
}


function handleRadioClick(isSim) {
    var containerMotivo = document.getElementById('bpContencaoMotivo');
    var containerQA = document.getElementById('bpContencaoQA');
    
    if (isSim) {
        // Se "Sim" for selecionado
        containerMotivo.style.display = 'none'; // Oculta o contêiner de Motivo
        containerQA.style.display = 'block'; // Mostra o contêiner de "BP de Contenção QA"

        // Torna os inputs obrigatórios
        setRequiredAttributes(true);
    } else {
        // Se "Não" for selecionado
        containerMotivo.style.display = 'block'; // Mostra o contêiner de Motivo
        containerQA.style.display = 'none'; // Oculta o contêiner de "BP de Contenção QA"

        // Torna os inputs obrigatórios
        setRequiredAttributes(false);
    }
}

function setRequiredAttributes(isRequired) {
    // Definir obrigatoriedade dos inputs de "BP de Contenção QA"
    var bpInput = document.getElementById("searchBPcontQA");
    var descricaoInput = document.getElementById("searchDescricaocontQA");

    if (isRequired) {
        bpInput.setAttribute("required", "required"); // Torna o input obrigatório
        descricaoInput.setAttribute("required", "required"); // Torna o input obrigatório
    } else {
        bpInput.removeAttribute("required"); // Remove a obrigatoriedade
        descricaoInput.removeAttribute("required"); // Remove a obrigatoriedade
    }

    // Definir obrigatoriedade do input de "Motivo"
    var motivoInput = document.getElementById("searchMotivo");
    motivoInput.required = !isRequired; // Se não for necessário, torna obrigatória
}




function verificarCampos() {
    var bpContencaoQA = document.getElementById("searchBPQA").value;
    var descricaoContencaoQA = document.getElementById("searchDescricaoQA").value;

    // Exibir apenas se BP de Contenção Q.A tiver valor
    if (bpContencaoQA.trim() !== "") {
        document.getElementById("containerBPContencao").style.display = "block";
    }

    // Exibir apenas se Descrição de Contenção Q.A tiver valor
    if (descricaoContencaoQA.trim() !== "") {
        document.getElementById("containerDescricaoContencao").style.display = "block";
    }
}

// Executa a verificação assim que a página carregar
document.addEventListener('DOMContentLoaded', verificarCampos);