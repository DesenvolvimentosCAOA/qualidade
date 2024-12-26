<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Imprimir Etiqueta</title>
    <script>
        function printLabel() {
            fetch('./auxi/printLabel.cfm', { // Certifique-se de que o caminho está correto
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then(response => response.text())
            .then(data => {
                alert(data); // Exibe a resposta do ColdFusion
            })
            .catch(error => {
                console.error('Erro ao enviar etiqueta:', error);
                alert('Erro ao enviar etiqueta. Veja o console para mais detalhes.');
            });
        }
    </script>
</head>
<body>
    <h1>Imprimir Etiqueta</h1>
    <button onclick="printLabel()">Imprimir Etiqueta</button>
</body>
</html>
