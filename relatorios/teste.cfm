<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teste de Select</title>
    <style>
        .search-container select {
            padding: 10px; /* Ajuste o padding */
            font-size: 0.8rem;
            border: 1px solid #5a8e99;
            outline: none;
            width: 100%;
            height: auto; /* Ajuste a altura */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
            color: #000; /* Cor da fonte */
            background-color: #fff; /* Cor do fundo */
            z-index: 1; /* Certifique-se de que está acima de outros elementos */
        }
    </style>
</head>
<body>
    <div class="search-container">
        <label for="severidade">Severidade</label>
        <select id="severidade">
            <option value="">selecione</option>
            <option value="10">10</option>
            <option value="9">9</option>
            <option value="8">8</option>
            <option value="7">7</option>
            <option value="6">6</option>
            <option value="5">5</option>
            <option value="4">4</option>
            <option value="3">3</option>
            <option value="2">2</option>
            <option value="1">1</option>
        </select>
    </div>
</body>
</html>