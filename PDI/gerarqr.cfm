<cfscript>
    // Pega o valor do VIN passado via query string
    vin = URL.vin;
    
    // Configuração da impressora (IP e Porta)
    printer_ip = "172.16.43.57";
    printer_port = 9100;
    
    // Ajuste da escuridão (densidade), velocidade e área de impressão
    zpl_code = '^XA' & Chr(13) & Chr(10) &  // Início da etiqueta
               '^PW1624' & Chr(13) & Chr(10) &  // Define a largura máxima da etiqueta para 8 polegadas (1624 dots)
               '^MD17' & Chr(13) & Chr(10) &  // Ajusta a densidade para 17 (mais escura)
               '^PR2' & Chr(13) & Chr(10) &   // Ajusta a velocidade para 2 (mais lenta)
               
               // Gera a caixa de borda, mantendo largura e altura
               '^FO20,20^GB750,170,4^FS' & Chr(13) & Chr(10) &  // Largura de 800 e altura de 300
               
               // Gera o QR Code, ajustando sua posição
               '^FO100,50^BQN,2,5^FDLA,' & vin & '^FS' & Chr(13) & Chr(10) &  
               
               // Adiciona o VIN como texto ao lado do QR Code
               '^FO350,100^A0N,30,35^FB600,1,0,L^FD' & vin & '^FS' & Chr(13) & Chr(10) &  // Posição ajustada à frente do QR Code

               '^XZ';  // Fim da etiqueta
    
    // Envia o comando ZPL para a impressora
    socket = createObject("java", "java.net.Socket");
    outputStream = createObject("java", "java.io.OutputStreamWriter");
    
    printer = socket.init(printer_ip, printer_port);
    output = outputStream.init(printer.getOutputStream(), "UTF-8");
    output.write(zpl_code);
    output.flush();
    
    // Fecha a conexão com a impressora
    output.close();
    printer.close();
</cfscript>

<!-- Redireciona para a página anterior -->
<cflocation url="javascript:history.back();" addToken="false" />