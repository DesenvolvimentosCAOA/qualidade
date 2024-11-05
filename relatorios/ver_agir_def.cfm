<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">
    <cfif isDefined("url.id_editar")>
        <cfquery name="consulta_editar" datasource="#BANCOSINC#">
            SELECT * 
            FROM INTCOLDFUSION.VEREAGIR2
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
            ORDER BY ID DESC
        </cfquery>
    </cfif>
    
    <cfif isDefined("form.ver_bp") and form.ver_bp neq "">
        <cfquery name="atualiza" datasource="#BANCOSINC#">
            UPDATE INTCOLDFUSION.VEREAGIR2
            SET
                DATA_BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                BP_DEFINITIVO_PROCESSO = <cfqueryparam value="#UCase(form.ver_bp)#" cfsqltype="CF_SQL_VARCHAR">,
                RESPONSAVEL_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_responsavel)#" cfsqltype="CF_SQL_VARCHAR">,
                DESCRICAO_DEFINITIVO = <cfqueryparam value="#UCase(form.ver_descricao)#" cfsqltype="CF_SQL_VARCHAR">,
                STATUS = <cfqueryparam value="#form.ver_status#" cfsqltype="CF_SQL_VARCHAR" >
            WHERE ID = <cfqueryparam value="#url.id_editar#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
    
        <cflocation url="ver_agir.cfm">
    </cfif>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VER & AGIR</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_add.css?v4">        
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div id="tableProcess" class="table-container Process">
            <h2 style="color: green; font-size:30px;">AÇÃO DEFINITIVA</h2>
            <form id="for-edit" method="POST">
                <cfoutput>
                    <div class="search-container">
                        <div hidden class="input-group">
                            <label for="searchData">Data da Validação</label>
                            <input readonly type="date" id="searchValidacao" name="data_validacao" placeholder="Data da validação" value="#dateFormat(now(), 'yyyy-mm-dd')#">
                        </div>
                        <div class="input-group">
                            <label for="searchStatus">STATUS</label>
                            <input readonly type="text" id="searchSTATUS" name="ver_status" placeholder="Status de Conclusão" value="">
                        </div>
                        <div class="input-group">
                            <label for="searchBP">Ponto de Corte</label>
                            <input required type="text" id="searchBP" name="ver_bp" placeholder="BP - VIN/BARCODE" value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchResponsavel">Responsável</label>
                            <input required type="text" id="searchResponsavel" name="ver_responsavel" placeholder="Responsável" value="" oninput="verificaCamposPreenchidos()">
                        </div>
                        <div class="input-group">
                            <label for="searchDescricao">Descrição</label>
                            <input required type="text" id="searchDescricao" name="ver_descricao" placeholder="Max 250 caracteres" value="" oninput="verificaCamposPreenchidos()">
                        </div>      
                    </div>
                    <div class="search-container">
                        <!-- Primeiro input que controla a visibilidade -->
                        <div hidden class="input-group">
                            <label for="searchqc">BP Definitivo Q.A.1</label> 
                            <input required type="text" id="searchqc" name="ver_qc" value="#consulta_editar.necessita_qualidade#">
                        </div>
                        <!-- Segundo input que será visível ou invisível conforme o valor do primeiro input -->
                        <div class="input-group" id="inputBPDefinitivo" style="display: none;">
                            <label for="searchBPdefinitivo">BP Definitivo Q.A.</label>
                            <input type="text" id="searchBPdefinitivo" name="ver_br_qa">
                        </div>
                    </div>
                    <div class="search-container">
                        <button type="submit" class="btn-rounded save-btn" id="btnSalvarEdicao">Salvar</button>
                        <button type="button" class="btn-rounded back-btn" id="btnVoltar" onclick="voltar()">Voltar</button>
                    </div>
                </cfoutput>
            </form>
        </div>
    </body>
</html>