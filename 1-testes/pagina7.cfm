<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SELECIONE</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f4;
            font-family: Arial, sans-serif;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .btn {
            padding: 15px 25px;
            font-size: 18px;
            color: #fff;
            background-color: #333;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .vehicle-btn {
            background-color: #3c8dbc;
        }

        .vehicle-btn:hover {
            background-color: #2a6c91;
        }

        .btn span {
            font-size: 20px;
        }

        @media (min-width: 768px) {
            .button-container {
                flex-direction: row;
            }
        }
    </style>
</head>
<body>
    <div class="button-container">
        <button class="btn vehicle-btn">
            <span>🖌️</span> Primer
        </button>
        <button class="btn vehicle-btn">
            <span>🖍️</span> Top Coat
        </button>
        <button class="btn vehicle-btn">
            <span>🔍</span> Validação de qualidade
        </button>
        <button class="btn vehicle-btn">
            <span>✅</span> Liberação Final
        </button>
    </div>
</body>
</html>
