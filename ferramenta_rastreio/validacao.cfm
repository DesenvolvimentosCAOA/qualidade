﻿<cfinvoke method="inicializando" component="cf.ini.index">

    <!--- Se for informado o barcode da cabine  --->
    <cfif isDefined("url.cabine")>
        <cfquery datasource="#BANCOMES#" name="lotCab">
            select l.IDLot, l.code, l.IDProduct, p.name
            from TBLLot l
            left join TBLProduct p 
            on p.IDProduct = l.IDProduct
            where p.name like '%CONJUNTO%'
            and l.code = '#url.cabine#'
        </cfquery>
    </cfif>
    
    <!--- Se for informado o barcode do CHASSI ao invés do VIN --->
    <cfif isDefined("url.chassi") and len(url.chassi) lt 7>
        <cfquery name="buscaVIN" datasource="#BANCOMES#">
            select l.code, l.IDProduct, l.IDLot, g.IDLot, g.VIN 
            from TBLLot l
            inner join CTBLGravacao g
                on l.IDLot = g.IDLot
            where l.code = '#url.chassi#'
            order by l.DtCreation desc
        </cfquery>
    
        <cfset chassiV = buscaVIN.VIN>
    <!--- Se for informado o VIN --->
    <cfelseif isDefined("url.chassi") and len(url.chassi) gt 7>
        <cfset chassiV = url.chassi>
    <cfelse>
        <cfset chassiV = "">
    </cfif>
    
    <!--- Busca por informações atraves do VIN do CHASSI --->
    
    <cfquery name="busca" datasource="#BANCOSINC#">
    
    select id, seq, barcode, replace(modelo, 'CABINE', '') as modelo, data_ALT, "CHECK", ESTACAO_3 from intcoldfusion.seq_truck_hr
    WHERE data_alt > TO_DATE(sysdate, 'DD/MM/YYYY')-1
    order by estacao_3, seq
    
    </cfquery>
    
    <!--- Busca sequenciamento atual --->
    <cfquery name="sequenciamento" datasource="#BANCOSINC#" maxrows="1">
    
    select * from intcoldfusion.seq_truck_hr
    --where "CHECK" = 0
    WHERE ESTACAO_3 = 0
    and data_alt > TO_DATE(sysdate, 'DD/MM/YYYY')-1
    order by seq asc
    
    </cfquery>
    
    <!--- Filtra sequência para validação --->
    <cfquery name="sequenciamento_filtrado" datasource="#BANCOSINC#" maxrows="1">
    
    select * from intcoldfusion.seq_truck_hr
    where "CHECK" = 0
    AND ESTACAO_3 = 0
    AND data_alt > TO_DATE(sysdate, 'DD/MM/YYYY')-1
    <cfif isDefined("url.barcode")>
    and barcode like '%#URL.barcode#%'
    </cfif>
    order by seq asc
    
    </cfquery>
    
    <!--- <cfdump var="#lotCab#">  
    <cfdump var="#busca#">
    --->
    
    <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
            <title>Sequenciamento - HR</title>
            <link rel="shortcut icon" href="/cf/assets/images/favicon.png" />
            <link rel="stylesheet" href="style.css?v=10">
            <link rel="stylesheet" href="/cf/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css?v=2">
        </head>
        
    
        <body class="flex row">
            
            <!--- Sesão de cabeçalho de informções na lateral esquerda  --->
            <section class="header flex column">
                    <a href="http://mes.caoa.com.br:1234/pcfui#/page/Mosaic" target="_blank">
                        <img src="/cf/assets/images/CAOATEC-MES.png" alt="logo" id="logo">
                    </a>
                        <label>
                        
                        <div class="card col-12 mt-3">
                        <div class="card-body">
                        <table class="table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>Sequência</th>
                                <th>⠀Barcode⠀</th>
                                <th>⠀Modelo⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                                <cfloop query="busca">
                            <cfoutput>
                                <tr class="text-right">
                                    <td class="text-center">#busca.seq#</td>
                                    <td class="text-center">#busca.barcode#</td>
                                    <td class="text-center">#busca.modelo#</td>
                                    <td style="color:<cfif busca.ESTACAO_3 eq 0>red;<cfelse>green;</cfif>" class="text-center"><cfif busca.ESTACAO_3 eq 0>Aguardando<cfelse>OK</cfif></td>
                                </tr>
                            </cfoutput>
                            </cfloop>
                            </tbody>
                        </table>
                        </div>
                    </div>
                        
                        </label>
                    </a>
                        <i class="mdi mdi-truck-fast" id="square"></i>
                    </div>
            </section>
    
            <!--- Container do corpo principal da pagina - Preto --->
            <div class="flex column">
    
                <cfoutput>
                <!--- Sessão de Retorno de info Cabine e Chassi --->
                <div class="comp flex">
                    <div class="info-cab flex column g-1">
                        <label class="ch">Sequenciamento</label>
    
                        <label>Barcode/VIN</label>
                        <form  name="form1" method="GET">
                            <input name="chassi" type="text" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.barcode#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                            <cfif isDefined("url.chassi") and url.chassi neq "" and busca.recordCount eq 0>
                                Barcode/VIN inválido!
                            </cfif>
                        </label>
    
                        <label>Sequência</label>
                        <form  name="form1" method="GET">
                            <input name="chassi" type="text" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.seq#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                            <cfif isDefined("url.chassi") and url.chassi neq "" and busca.recordCount eq 0>
                                Sequência inválido!
                            </cfif>
                        </label>
    
                        <label>Modelo</label>
                        <form  name="form1" method="GET">
                            <input name="chassi" type="text" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.modelo#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                            <cfif isDefined("url.chassi") and url.chassi neq "" and busca.recordCount eq 0>
                                Modelo inválido!
                            </cfif>
                        </label>
    
                        <label>DataTime</label>
                        <form  name="form1" method="GET">
                            <input name="chassi" type="text" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.data_alt#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                            <cfif isDefined("url.chassi") and url.chassi neq "" and busca.recordCount eq 0>
                                DateTime inválido!
                            </cfif>
                        </label>
    
                        <label>Kit 1</label>
                        <form  name="form1" method="GET">
                            <input onfocus="mudarCor(this)" onclick="copiarConteudo(this)" name="datatime" type="dates" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.kit_1#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                        </label>
    
                        <label>Kit 2</label>
                        <form  name="form1" method="GET">
                            <input onfocus="mudarCor(this)" onclick="copiarConteudo(this)" name="datatime" type="dates" value="<cfif sequenciamento.recordcount GT 0>#sequenciamento.kit_2#<cfelse>Aguardando...</cfif>" disabled>
                        </form>
    
                        <cfif sequenciamento.recordcount GT 0>
                            <label id="invalido">
                            </label>
                        <cfelse>
                        <label>Fila vazia</label>
                            <label id="aguardando">
                                Aguardando novos sequenciamentos
                            </label>
                        </cfif>
    
                    </div>
    
                    <div class="info-cab flex column g-1">
                        <label style="background-color: transparent;" class="ch">Confirmação</label>
    
                        <label>Barcode/VIN</label>
                        <form id="form1" name="form1" method="GET">
                            <input onfocus="myFunction(this)" id="barcode" name="barcode" type="text" value="<cfif isDefined("url.barcode")>#sequenciamento_filtrado.barcode#<cfelse></cfif>" autofocus>
                        </form>
    
                        <label id="invalido">
                        </label>
    
                        <!--- Se não encontrar informações para o paramentro informado--->
                        <label id="invalido">
                        </label>
    
                        <label>Status</label>
                        <!--- Se não encontrar informações para o paramentro informado--->
                                            <!--- Se não encontrar informações para o paramentro informado--->
                        <cfif isDefined("url.barcode") AND sequenciamento.barcode NEQ url.barcode AND sequenciamento.recordcount GT 0>
                            <label id="invalido">
                                Sequência Inválida!
                            </label>
                        <cfelseif isDefined("url.barcode") AND sequenciamento.barcode EQ url.barcode>
                            <label id="valido">
                                Sequência Confirmada!
                            </label>
    
                            <cfquery name="updateSequenciamento" datasource="#BANCOSINC#" maxrows="1">
    
                                update intcoldfusion.seq_truck_hr
                                set "CHECK" = 1, ESTACAO_3 = 2
                                where barcode = #URL.barcode#
    
                            </cfquery>
    
                            <meta http-equiv="refresh" content="3;url=validacao.cfm">
    
                        <cfelse>
                            <label id="aguardando">
                                Aguardando validação
                            </label>
                        </cfif>
    
                    <button onclick="confirmar(<cfif sequenciamento.seq eq ""><cfelse>#sequenciamento.id#, '#sequenciamento.seq#'</cfif>);" value="Confirmar" class="btn" type="submit" id="btn" name="button">Confirmar</button>
    
                    <!--- Se não encontrar informações para o paramentro informado--->
                    <label id="invalido">
                    </label>
    
                    </div>
                </div>
    
                </cfoutput>
            </div>
    
    <script>
    
    // Enviar informações  
    const confirmar = (id, seq) => {
        conf = confirm('Deseja confirmar a sequência '+ '('+ seq + ')');
        if(conf == true){
        form.submit();
        }
    }
    
    function myFunction(x) {
      x.style.background = "yellow";
    }
    
      const input = document.getElementById("barcode");
      const form = document.getElementById("form1");
    
      // Adicione um ouvinte de evento ao input para detectar a mudança
      input.addEventListener("change", function() {
        // Submeta o formulário quando houver uma mudança
        //form.submit();
      });
    
    var camposClicados = 0;
    
            function mudarCor(input) {
                input.classList.add('green-bg'); // Adicionar classe para cor verde
                camposClicados++;
    
                if (camposClicados === 2) {
                    // Ambos os campos foram clicados, todos os campos recebem a cor verde
                    var campos = document.querySelectorAll('input[type="text"]');
                    campos.forEach(function(campo) {
                        campo.classList.add('green-bg');
                    });
                }
            }
    
            function copiarConteudo(input) {
                input.select();
                document.execCommand('copy');
                window.getSelection().removeAllRanges();
            }
    
    
    </script>
    
        </body>
    
    </html>
    
    <meta http-equiv="refresh" content="30;url=validacao.cfm">