<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0"> 
<cfcontent type="text/html; charset=UTF-8">
<cfprocessingdirective pageEncoding="utf-8">

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Check List PDI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/StyleBuyOFF.css?v7">
        <link rel="stylesheet" href="assets/custom.css">
        <link rel="stylesheet" href="assets/css/style.css?v=11">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            body {
                display: flex;
            }
            .container {
                flex: 1; /* Para ocupar todo o espaço restante */
                margin: 20px; /* Ajuste conforme necessário */
            }
            .print-table {
                width: calc(100% - 20px); /* Ajusta para o tamanho da tabela */
                max-width: 600px; /* Definindo uma largura máxima para a tabela */
                margin-right: 20px; /* Espaçamento entre a tabela e o restante do conteúdo */
            }
            table {
                width: 100%; /* Ocupa toda a largura da tabela */
                border-collapse: collapse;
                margin: 10px 0; /* Reduzindo a margem superior e inferior da tabela */
            }
            td, th {
                border: 1px solid black;
                padding: 3px; /* Reduzindo o padding para diminuir a altura das células */
                text-align: left;
                line-height: 1.2; /* Reduzindo o espaçamento entre as linhas */
                font-size: 12px; /* Reduzindo o tamanho da fonte */
            }
            .checkbox-container {
                display: flex;
                align-items: center;
            }
            .checkbox-container label {
                margin-right: 20px;
            }
            select, input[type="date"], textarea {
                width: 100%;
                padding: 2px; /* Reduzindo o padding */
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 12px; /* Reduzindo o tamanho da fonte para compactar mais */
            }
            textarea {
                height: 30px; /* Definindo a altura desejada para o textarea */
                resize: none;
            }
            button {
                margin: 10px 0;
                padding: 6px 12px; /* Ajustando o padding do botão */
                font-size: 12px; /* Reduzindo o tamanho da fonte do botão */
                cursor: pointer;
            }
            @media print {
                body * {
                    visibility: hidden; /* Oculta todos os elementos */
                }
                .print-table, .print-table * {
                    visibility: visible; /* Torna visíveis os elementos dentro da classe 'print-table' */
                }
                .print-table {
                    position: absolute;
                    left: 0;
                    top: 0;
                }
                .print-table td, .print-table th, .print-table select, .print-table input, .print-table textarea {
                    font-size: 10px; /* Reduzindo ainda mais o tamanho da fonte */
                    padding: 2px; /* Reduzindo o padding */
                }
            }
        </style>
    </head>
    <body>
        <header>
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div class="container"> <!-- Reduzindo a margem superior do container -->
            <h2 class="titulo2">Check List PDI</h2><br><br>
            
            <button onclick="window.print()">Imprimir</button>
            <div class="print-table"> <!-- Div que será impressa -->
                <table>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th colspan="3">PROBLEMA</th>
                        <th rowspan="2">RESPONSÁVEL</th>
                        <th colspan="2">INSPEÇÃO</th>
                        <th rowspan="2">LIBERAÇÃO</th>
                    </tr>
                    <tr>
                        <th colspan="3">DESCRIÇÃO DO REPARO</th>
                        <th>INSPETOR</th>
                        <th>DATA</th>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="responsavel1">Responsável 1</option>
                                <option value="responsavel2">Responsável 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="inspetor1">Inspetor 1</option>
                                <option value="inspetor2">Inspetor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="date">
                        </td>
                        <td rowspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="liberacao1">Liberação 1</option>
                                <option value="liberacao2">Liberação 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="7">
                            Houve Desmonte?
                            <div class="checkbox-container">
                                <label><input type="radio" name="desmonte" value="sim"> SIM</label>
                                <label><input type="radio" name="desmonte" value="nao"> NÃO</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2">
                            <textarea></textarea>
                        </td>
                        <td>SHOP EXECUTOR</td>
                        <td colspan="2">
                            <select>
                                <option value="">Selecione</option>
                                <option value="executor1">Executor 1</option>
                                <option value="executor2">Executor 2</option>
                                <!-- Adicione mais opções conforme necessário -->
                            </select>
                        </td>
                        <td>
                            <input type="date">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"></td>
                        <td></td>
                    </tr>
                </table>
            </div>
        </div>
    </body>
    </html>