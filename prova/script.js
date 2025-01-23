// Respostas corretas para comparação
const answers = {
    q1: 'B',
    q2: 'A',
    q3: 'C',
    q4: 'A',
    q5: 'A',
    q6: 'B',
    q7: 'C',
    q8: 'D',
    q9: 'D',
    q10: 'A'
};

// Função para calcular a pontuação e enviar o formulário
function calculateScoreAndSubmit(autoSubmit = false) {
    const form = document.getElementById('quizForm');
    let score = 0;
    const name = form['studentName'].value.trim();

    // Verifica se o nome foi preenchido apenas no envio manual
    if (!name && !autoSubmit) {
        alert('Por favor, preencha o nome antes de enviar a prova.');
        return;
    }

    // Calcula a pontuação
    Object.keys(answers).forEach(question => {
        const userAnswer = form[question]?.value;
        if (userAnswer === answers[question]) {
            score++;
        }
    });

    // Exibe a pontuação
    const resultDiv = document.getElementById('result');
    resultDiv.textContent = `${name || "Aluno"}, você acertou ${score} de 10 questões. `;
    resultDiv.style.display = 'block';

    // Alerta no envio automático
    if (autoSubmit) {
        alert('O tempo acabou! A prova será enviada.');
    }

    // Envia o formulário
    form.submit();
}

// Timer
let timeLeft = 30 * 60; // 30 minutos
const timerElement = document.getElementById('timer');

function updateTimer() {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;
    timerElement.textContent = `Tempo restante: ${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

    if (timeLeft > 0) {
        timeLeft--;
    } else {
        clearInterval(timerInterval);
        calculateScoreAndSubmit(true);
    }
}

const timerInterval = setInterval(updateTimer, 1000);

// Previne o envio padrão e calcula a nota no envio manual
document.getElementById('quizForm').addEventListener('submit', function (event) {
    event.preventDefault(); // Previne o envio padrão
    calculateScoreAndSubmit(false); // Chama a função para envio manual
});

// Função para embaralhar elementos filhos de um contêiner
function shuffleElements(containerId) {
    const container = document.getElementById(containerId);
    const elements = Array.from(container.children);
    elements.sort(() => Math.random() - 0.5);
    elements.forEach(element => container.appendChild(element));
}

// Embaralha as opções de todas as perguntas
function shuffleAllOptions() {
    const questionContainers = document.querySelectorAll(".question .options");
    questionContainers.forEach(container => {
        const options = Array.from(container.children);
        options.sort(() => Math.random() - 0.5);
        options.forEach(option => container.appendChild(option));
    });
}

// Embaralha as perguntas dentro do contêiner principal
function shuffleQuestions() {
    shuffleElements("questions-container");
}

// Função principal para embaralhar tudo ao carregar a página
function shuffleQuiz() {
    shuffleAllOptions();
    shuffleQuestions();
}

// Chamar a função ao carregar a página
document.addEventListener("DOMContentLoaded", shuffleQuiz);

