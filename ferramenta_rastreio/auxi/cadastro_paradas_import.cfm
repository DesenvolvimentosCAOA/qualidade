<cfinvoke  method="inicializando" component="cf.ini.index">
<cfsetting requestTimeOut = "0">

    <cfif isDefined("form.file")>

        <cffile action="upload" 
                destination="C:\ColdFusion2018\cfusion\wwwroot\cf\auth\monitor\MSGT\assets" 
                attributes="normal" 
                
                result="import" nameconflict="makeunique">
    <cfelse>

        <font> Desculpe 😓, ocorreu um erro! Não conseguimos localizar o arquivo. Por favor, fique tranquilo, isso significa que o arquivo não foi importado com sucesso. 😅 </font>
    
    </cfif>
    
<cfset file_imp = import.serverfile>


<cfspreadsheet 
    action="read"
    src="C:\ColdFusion2018\cfusion\wwwroot\cf\auth\monitor\MSGT\assets\#file_imp#"
    query="importado">
    
<cfset max=importado.RecordCount>   

<cfoutput> 

    <cfif isDefined("form.terceiro")>

         <cfloop query="importado" startRow="2">

            <cfquery name="bancoTreinamentosTercerizado" datasource="#BANCOSINC#">

            select * from intcoldfusion.treinamentos_normativos where CPF = '#importado.COL_3#'

            </cfquery>

            <cfif bancoTreinamentosTercerizado.RecordCount EQ 0>

                    <cfquery name="Insere" datasource="#BANCOSINC#">
                     INSERT INTO INTCOLDFUSION.treinamentos_normativos (
                        ID,
                        CPF,
                        NOME,
                        SETOR,
                        CARGO,
                        VENCIMENTO_ASO_ESPECIAL,
                        T_ALTURA,
                        APTO_ALTURA,
                        STATUS_ALTURA,
                        E_CONFINADO,
                        APTO_CONFINADO,
                        STATUS_CONFINADO,
                        NR38_LIM_URB_M_E_R_TREINAMENTO)  
                        
                    VALUES
                    
                    (seq_treinamentos_normativos.NEXTVAL,
                    '#importado.COL_2#',
                    <cfif isDefined("importado.COL_3")>'#importado.COL_3#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_1")>'#importado.COL_1#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_4")>'#importado.COL_4#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_5")>'#importado.COL_5#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_6")>'#importado.COL_6#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_7")>'#importado.COL_7#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_8")>'#importado.COL_8#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_9")>'#importado.COL_9#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_10")>'#importado.COL_10#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_11")>'#importado.COL_11#'<cfelse>NULL</cfif>,
                    'Terceiro')
                    </cfquery>

            <br><font style="font-size:18"> Registro de CPF #importado.COL_3# foi inserido com sucesso ✅</font><br>

            <cfelse>
            <cfquery name="update" datasource="SINCPROD">
                UPDATE intcoldfusion.treinamentos_normativos
                    SET 
                        NOME = '#importado.COL_3#',
                        SETOR = '#importado.COL_1#',
                        CARGO = '#importado.COL_4#',
                        VENCIMENTO_ASO_ESPECIAL = '#importado.COL_5#',
                        T_ALTURA = '#importado.COL_6#',
                        APTO_ALTURA = <cfif isDefined("importado.COL_7")>'#importado.COL_7#'<cfelse>NULL</cfif>,
                        STATUS_ALTURA = <cfif isDefined("importado.COL_8")>'#importado.COL_8#'<cfelse>NULL</cfif>,
                        E_CONFINADO = <cfif isDefined("importado.COL_9")>'#importado.COL_9#'<cfelse>NULL</cfif>,
                        APTO_CONFINADO = <cfif isDefined("importado.COL_10")>'#importado.COL_10#'<cfelse>NULL</cfif>,
                        STATUS_CONFINADO = <cfif isDefined("importado.COL_11")>'#importado.COL_11#'<cfelse>NULL</cfif>

                    WHERE CPF = '#importado.COL_1#'

                    </cfquery>

            <br><font style="font-size:18"> Registro de CPF #importado.COL_1# já existe. Portanto realizarei a atualização para o registro do CPF #importado.COL_1# em todas as suas colunas referentes com os novos registros do arquivo importado 😉</font><br>

        </cfif>
           
            <cfquery name="buscaNulosTercerizados" datasource="#BANCOSINC#">

                select * from intcoldfusion.treinamentos_normativos where CPF IS NULL
            </cfquery>

        <cfif buscaNulosTercerizados.recordcount EQ 0>
            
            <cfelse>

                <cfquery name="removerNulosTercerizados" datasource="#BANCOSINC#">

                    delete intcoldfusion.treinamentos_normativos 
                    where CPF IS NULL

                </cfquery>

                <br><font style="font-size:18">🔧🛠️ Corrigindo erro de importação 🛠️🔧</font><br>

            </cfif>

    </cfloop>

    <cfelse>

    <cfloop query="importado" startRow="3">

            <cfquery name="bancoTreinamentos" datasource="#BANCOSINC#">

            select * from intcoldfusion.treinamentos_normativos where CPF = '#importado.COL_1#'

            </cfquery>

            <cfif bancoTreinamentos.RecordCount EQ 0>

                    <cfquery name="Insere" datasource="#BANCOSINC#">
                     INSERT INTO INTCOLDFUSION.treinamentos_normativos (
                        ID,
                        CPF,
                        NOME,
                        SETOR,
                        CARGO,
                        VENCIMENTO_ASO_ESPECIAL,
                        T_ALTURA,
                        APTO_ALTURA,
                        STATUS_ALTURA,
                        E_CONFINADO,
                        APTO_CONFINADO,
                        STATUS_CONFINADO,
                        CONDUCAO_DE_VEICULOS,
                        APTO_CONDUCAO,
                        STATUS_CONDUCAO,
                        NR05_CIPA_TREINAMENTO,
                        NR05_CIPA_VENCIMENTO,
                        NR05_CIPA_STATUS,
                        NR06_EPI_TREINAMENTO,
                        NR06_EPI_VENCIMENTO,
                        NR06_EPI_STATUS,
                        NR10_ELETRIC_TREINAMENTO,
                        NR10_ELETRIC_VENCIMENTO,
                        NR10_ELETRIC_STATUS,
                        NR10_ELETRIC_TREINAMENTO_SEP,
                        NR10_ELETRIC_VENCIMENTO_2,
                        NR10_ELETRIC_STATUS_2,
                        NR11_TALHA_PON_ROL_TREINAMENTO,
                        NR11_TALHA_PON_ROL_VENCIMENTO,
                        NR11_TALHA_PON_ROL_STATUS,
                        NR12_CORT_D_GRAMAS_TREINAMENTO,
                        NR12_CORT_D_GRAMAS_VENCIMENTO,
                        NR12_CORT_D_GRAMAS_STATUS,
                        NR12_RETRO_TRATOR_TREINAMENTO,
                        NR12_RETRO_TRATOR_VENCIMENTO,
                        NR12_RETRO_TRATOR_STATUS,
                        NR12_EMPILHADEIRA_TREINAMENTO,
                        NR12_EMPILHADEIRA_VENCIMENTO,
                        NR12_EMPILHADEIRA_STATUS,
                        NR12_EMPILHADEIRA_PERMISSAO,
                        NR12_TRANSPALE_TREINAMENTO,
                        NR12_TRANSPALE_VENCIMENTO,
                        NR12_TRANSPALE_STATUS,
                        NR12_TRANSPALE_PERMISSAO,
                        NR12_REBOCADOR_TREINAMENTO,
                        NR12_REBOCADOR_VENCIMENTO,
                        NR12_REBOCADOR_STATUS,
                        NR12_REBOCADOR_PERMISSAO,
                        NR12_PLATAFORM_ELE_TREINAMENTO,
                        NR12_PLATAFORM_ELE_VENCIMENTO,
                        NR12_PLATAFORM_ELE_STATUS,
                        NR12_PLATAFORM_ELE_PERMISSAO,
                        NR13_VASOS_DE_PRES_TREINAMENTO,
                        NR13_VASOS_DE_PRES_VENCIMENTO,
                        NR13_VASOS_DE_PRES_STATUS,
                        NR17_LEV_PESO_TREINAMENTO,
                        NR18_ANDAIME_TREINAMENTO,
                        NR20_INFLAMAVEIS_TREINAMENTO,
                        NR20_INFLAMAVEIS_VENCIMENTO,
                        NR20_INFLAMAVEIS_STATUS,
                        NR23_BRIGA_DE_INC_TREINAMENTO,
                        NR23_BRIGA_DE_INC_VENCIMENTO,
                        NR23_BRIGA_DE_INC_STATUS,
                        NR25_RESIDUOS_TREINAMENTO,
                        NR26_ROT_QUI_TREINAMENTO,
                        NR33_ESPC_CONFIN_CATEGORIA,
                        NR33_ESPC_CONFIN_TREINAMENTO,
                        NR33_ESPC_CONFIN_VENCIMENTO,
                        NR33_ESPC_CONFIN_STATUS,
                        NR33_ESPC_CONFIN_PERMISSAO,
                        NR34_TRAB_QUENTE_TREINAMENTO,
                        NR35_TRAB_ALTURA_TREINAMENTO,
                        NR35_TRAB_ALTURA_VENCIMENTO,
                        NR35_TRAB_ALTURA_STATUS,
                        NR35_TRAB_ALTURA_PERMISSAO,
                        NR38_LIM_URB_M_E_R_TREINAMENTO)  
                        
                    VALUES
                    
                    (seq_treinamentos_normativos.NEXTVAL,
                    '#importado.COL_1#',
                    <cfif isDefined("importado.COL_2")>'#importado.COL_2#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_3")>'#importado.COL_3#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_4")>'#importado.COL_4#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_5")>'#importado.COL_5#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_6")>'#importado.COL_6#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_7")>'#importado.COL_7#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_8")>'#importado.COL_8#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_9")>'#importado.COL_9#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_10")>'#importado.COL_10#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_11")>'#importado.COL_11#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_12")>'#importado.COL_12#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_13")>'#importado.COL_13#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_14")>'#importado.COL_14#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_15")>'#importado.COL_15#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_16")>'#importado.COL_16#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_17")>'#importado.COL_17#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_18")>'#importado.COL_18#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_19")>'#importado.COL_19#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_20")>'#importado.COL_20#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_21")>'#importado.COL_21#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_22")>'#importado.COL_22#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_23")>'#importado.COL_23#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_24")>'#importado.COL_24#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_25")>'#importado.COL_25#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_26")>'#importado.COL_26#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_27")>'#importado.COL_27#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_28")>'#importado.COL_28#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_29")>'#importado.COL_29#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_30")>'#importado.COL_30#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_31")>'#importado.COL_31#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_32")>'#importado.COL_32#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_33")>'#importado.COL_33#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_34")>'#importado.COL_34#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_35")>'#importado.COL_35#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_36")>'#importado.COL_36#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_37")>'#importado.COL_37#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_38")>'#importado.COL_38#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_39")>'#importado.COL_39#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_40")>'#importado.COL_40#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_41")>'#importado.COL_41#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_42")>'#importado.COL_42#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_43")>'#importado.COL_43#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_44")>'#importado.COL_44#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_45")>'#importado.COL_45#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_46")>'#importado.COL_46#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_47")>'#importado.COL_47#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_48")>'#importado.COL_48#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_49")>'#importado.COL_49#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_50")>'#importado.COL_50#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_51")>'#importado.COL_51#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_52")>'#importado.COL_52#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_53")>'#importado.COL_53#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_54")>'#importado.COL_54#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_55")>'#importado.COL_55#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_56")>'#importado.COL_56#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_57")>'#importado.COL_57#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_58")>'#importado.COL_58#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_59")>'#importado.COL_59#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_60")>'#importado.COL_60#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_61")>'#importado.COL_61#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_62")>'#importado.COL_62#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_63")>'#importado.COL_63#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_64")>'#importado.COL_64#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_65")>'#importado.COL_65#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_66")>'#importado.COL_66#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_67")>'#importado.COL_67#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_68")>'#importado.COL_68#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_69")>'#importado.COL_69#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_70")>'#importado.COL_70#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_71")>'#importado.COL_71#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_72")>'#importado.COL_72#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_73")>'#importado.COL_73#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_74")>'#importado.COL_74#'<cfelse>NULL</cfif>,
                    <cfif isDefined("importado.COL_75")>'#importado.COL_75#'<cfelse>NULL</cfif>)
                    </cfquery>

            <br><font style="font-size:18"> Registro de CPF #importado.COL_1# foi inserido com sucesso ✅</font><br>

            <cfelse>
            <cfquery name="update" datasource="SINCPROD">
                UPDATE intcoldfusion.treinamentos_normativos
                    SET 
                        NOME = '#importado.COL_2#',
                        SETOR = '#importado.COL_3#',
                        CARGO = '#importado.COL_4#',
                        VENCIMENTO_ASO_ESPECIAL = '#importado.COL_5#',
                        T_ALTURA = '#importado.COL_6#',
                        APTO_ALTURA = <cfif isDefined("importado.COL_7")>'#importado.COL_7#'<cfelse>NULL</cfif>,
                        STATUS_ALTURA = <cfif isDefined("importado.COL_8")>'#importado.COL_8#'<cfelse>NULL</cfif>,
                        E_CONFINADO = <cfif isDefined("importado.COL_9")>'#importado.COL_9#'<cfelse>NULL</cfif>,
                        APTO_CONFINADO = <cfif isDefined("importado.COL_10")>'#importado.COL_10#'<cfelse>NULL</cfif>,
                        STATUS_CONFINADO = <cfif isDefined("importado.COL_11")>'#importado.COL_11#'<cfelse>NULL</cfif>,
                        CONDUCAO_DE_VEICULOS = <cfif isDefined("importado.COL_12")>'#importado.COL_12#'<cfelse>NULL</cfif>,
                        APTO_CONDUCAO = <cfif isDefined("importado.COL_13")>'#importado.COL_13#'<cfelse>NULL</cfif>,
                        STATUS_CONDUCAO = <cfif isDefined("importado.COL_14")>'#importado.COL_14#'<cfelse>NULL</cfif>,
                        NR05_CIPA_TREINAMENTO = <cfif isDefined("importado.COL_15")>'#importado.COL_15#'<cfelse>NULL</cfif>,
                        NR05_CIPA_VENCIMENTO = <cfif isDefined("importado.COL_16")>'#importado.COL_16#'<cfelse>NULL</cfif>,
                        NR05_CIPA_STATUS = <cfif isDefined("importado.COL_17")>'#importado.COL_17#'<cfelse>NULL</cfif>,
                        NR06_EPI_TREINAMENTO = <cfif isDefined("importado.COL_18")>'#importado.COL_18#'<cfelse>NULL</cfif>,
                        NR06_EPI_VENCIMENTO = <cfif isDefined("importado.COL_19")>'#importado.COL_19#'<cfelse>NULL</cfif>,
                        NR06_EPI_STATUS = <cfif isDefined("importado.COL_20")>'#importado.COL_20#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_TREINAMENTO = <cfif isDefined("importado.COL_21")>'#importado.COL_21#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_VENCIMENTO = <cfif isDefined("importado.COL_22")>'#importado.COL_22#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_STATUS = <cfif isDefined("importado.COL_23")>'#importado.COL_23#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_TREINAMENTO_SEP = <cfif isDefined("importado.COL_24")>'#importado.COL_24#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_VENCIMENTO_2 = <cfif isDefined("importado.COL_25")>'#importado.COL_25#'<cfelse>NULL</cfif>,
                        NR10_ELETRIC_STATUS_2 = <cfif isDefined("importado.COL_26")>'#importado.COL_26#'<cfelse>NULL</cfif>,
                        NR11_TALHA_PON_ROL_TREINAMENTO = <cfif isDefined("importado.COL_27")>'#importado.COL_27#'<cfelse>NULL</cfif>,
                        NR11_TALHA_PON_ROL_VENCIMENTO = <cfif isDefined("importado.COL_28")>'#importado.COL_28#'<cfelse>NULL</cfif>,
                        NR11_TALHA_PON_ROL_STATUS = <cfif isDefined("importado.COL_29")>'#importado.COL_29#'<cfelse>NULL</cfif>,
                        NR12_CORT_D_GRAMAS_TREINAMENTO = <cfif isDefined("importado.COL_30")>'#importado.COL_30#'<cfelse>NULL</cfif>,
                        NR12_CORT_D_GRAMAS_VENCIMENTO = <cfif isDefined("importado.COL_31")>'#importado.COL_31#'<cfelse>NULL</cfif>,
                        NR12_CORT_D_GRAMAS_STATUS = <cfif isDefined("importado.COL_32")>'#importado.COL_32#'<cfelse>NULL</cfif>,
                        NR12_RETRO_TRATOR_TREINAMENTO = <cfif isDefined("importado.COL_33")>'#importado.COL_33#'<cfelse>NULL</cfif>,
                        NR12_RETRO_TRATOR_VENCIMENTO = <cfif isDefined("importado.COL_34")>'#importado.COL_34#'<cfelse>NULL</cfif>,
                        NR12_RETRO_TRATOR_STATUS = <cfif isDefined("importado.COL_35")>'#importado.COL_35#'<cfelse>NULL</cfif>,
                        NR12_EMPILHADEIRA_TREINAMENTO = <cfif isDefined("importado.COL_36")>'#importado.COL_36#'<cfelse>NULL</cfif>,
                        NR12_EMPILHADEIRA_VENCIMENTO = <cfif isDefined("importado.COL_37")>'#importado.COL_37#'<cfelse>NULL</cfif>,
                        NR12_EMPILHADEIRA_STATUS = <cfif isDefined("importado.COL_38")>'#importado.COL_38#'<cfelse>NULL</cfif>,
                        NR12_EMPILHADEIRA_PERMISSAO = <cfif isDefined("importado.COL_39")>'#importado.COL_39#'<cfelse>NULL</cfif>,
                        NR12_TRANSPALE_TREINAMENTO = <cfif isDefined("importado.COL_40")>'#importado.COL_40#'<cfelse>NULL</cfif>,
                        NR12_TRANSPALE_VENCIMENTO = <cfif isDefined("importado.COL_41")>'#importado.COL_41#'<cfelse>NULL</cfif>,
                        NR12_TRANSPALE_STATUS = <cfif isDefined("importado.COL_42")>'#importado.COL_42#'<cfelse>NULL</cfif>,
                        NR12_TRANSPALE_PERMISSAO = <cfif isDefined("importado.COL_43")>'#importado.COL_43#'<cfelse>NULL</cfif>,
                        NR12_REBOCADOR_TREINAMENTO = <cfif isDefined("importado.COL_44")>'#importado.COL_44#'<cfelse>NULL</cfif>,
                        NR12_REBOCADOR_VENCIMENTO = <cfif isDefined("importado.COL_45")>'#importado.COL_45#'<cfelse>NULL</cfif>,
                        NR12_REBOCADOR_STATUS = <cfif isDefined("importado.COL_46")>'#importado.COL_46#'<cfelse>NULL</cfif>,
                        NR12_REBOCADOR_PERMISSAO = <cfif isDefined("importado.COL_47")>'#importado.COL_47#'<cfelse>NULL</cfif>,
                        NR12_PLATAFORM_ELE_TREINAMENTO = <cfif isDefined("importado.COL_48")>'#importado.COL_48#'<cfelse>NULL</cfif>,
                        NR12_PLATAFORM_ELE_VENCIMENTO = <cfif isDefined("importado.COL_49")>'#importado.COL_49#'<cfelse>NULL</cfif>,
                        NR12_PLATAFORM_ELE_STATUS = <cfif isDefined("importado.COL_50")>'#importado.COL_50#'<cfelse>NULL</cfif>,
                        NR12_PLATAFORM_ELE_PERMISSAO = <cfif isDefined("importado.COL_51")>'#importado.COL_51#'<cfelse>NULL</cfif>,
                        NR13_VASOS_DE_PRES_TREINAMENTO = <cfif isDefined("importado.COL_52")>'#importado.COL_52#'<cfelse>NULL</cfif>,
                        NR13_VASOS_DE_PRES_VENCIMENTO = <cfif isDefined("importado.COL_53")>'#importado.COL_53#'<cfelse>NULL</cfif>,
                        NR13_VASOS_DE_PRES_STATUS = <cfif isDefined("importado.COL_54")>'#importado.COL_54#'<cfelse>NULL</cfif>,
                        NR17_LEV_PESO_TREINAMENTO = <cfif isDefined("importado.COL_55")>'#importado.COL_55#'<cfelse>NULL</cfif>,
                        NR18_ANDAIME_TREINAMENTO = <cfif isDefined("importado.COL_56")>'#importado.COL_56#'<cfelse>NULL</cfif>,
                        NR20_INFLAMAVEIS_TREINAMENTO = <cfif isDefined("importado.COL_57")>'#importado.COL_57#'<cfelse>NULL</cfif>,
                        NR20_INFLAMAVEIS_VENCIMENTO = <cfif isDefined("importado.COL_58")>'#importado.COL_58#'<cfelse>NULL</cfif>,
                        NR20_INFLAMAVEIS_STATUS = <cfif isDefined("importado.COL_59")>'#importado.COL_59#'<cfelse>NULL</cfif>,
                        NR23_BRIGA_DE_INC_TREINAMENTO = <cfif isDefined("importado.COL_60")>'#importado.COL_60#'<cfelse>NULL</cfif>,
                        NR23_BRIGA_DE_INC_VENCIMENTO = <cfif isDefined("importado.COL_61")>'#importado.COL_61#'<cfelse>NULL</cfif>,
                        NR23_BRIGA_DE_INC_STATUS = <cfif isDefined("importado.COL_62")>'#importado.COL_62#'<cfelse>NULL</cfif>,
                        NR25_RESIDUOS_TREINAMENTO = <cfif isDefined("importado.COL_63")>'#importado.COL_63#'<cfelse>NULL</cfif>,
                        NR26_ROT_QUI_TREINAMENTO = <cfif isDefined("importado.COL_64")>'#importado.COL_64#'<cfelse>NULL</cfif>,
                        NR33_ESPC_CONFIN_CATEGORIA = <cfif isDefined("importado.COL_65")>'#importado.COL_65#'<cfelse>NULL</cfif>,
                        NR33_ESPC_CONFIN_TREINAMENTO = <cfif isDefined("importado.COL_66")>'#importado.COL_66#'<cfelse>NULL</cfif>,
                        NR33_ESPC_CONFIN_VENCIMENTO = <cfif isDefined("importado.COL_67")>'#importado.COL_67#'<cfelse>NULL</cfif>,
                        NR33_ESPC_CONFIN_STATUS = <cfif isDefined("importado.COL_68")>'#importado.COL_68#'<cfelse>NULL</cfif>,
                        NR33_ESPC_CONFIN_PERMISSAO = <cfif isDefined("importado.COL_69")>'#importado.COL_69#'<cfelse>NULL</cfif>,
                        NR34_TRAB_QUENTE_TREINAMENTO = <cfif isDefined("importado.COL_70")>'#importado.COL_70#'<cfelse>NULL</cfif>,
                        NR35_TRAB_ALTURA_TREINAMENTO = <cfif isDefined("importado.COL_71")>'#importado.COL_71#'<cfelse>NULL</cfif>,
                        NR35_TRAB_ALTURA_VENCIMENTO = <cfif isDefined("importado.COL_72")>'#importado.COL_72#'<cfelse>NULL</cfif>,
                        NR35_TRAB_ALTURA_STATUS = <cfif isDefined("importado.COL_73")>'#importado.COL_73#'<cfelse>NULL</cfif>,
                        NR35_TRAB_ALTURA_PERMISSAO = <cfif isDefined("importado.COL_74")>'#importado.COL_74#'<cfelse>NULL</cfif>,
                        NR38_LIM_URB_M_E_R_TREINAMENTO = <cfif isDefined("importado.COL_75")>'#importado.COL_75#'<cfelse>NULL</cfif>


                    WHERE CPF = '#importado.COL_1#'

                    </cfquery>

            <br><font style="font-size:18"> Registro de CPF #importado.COL_1# já existe. Portanto realizarei a atualização para o registro do CPF #importado.COL_1# em todas as suas colunas referentes com os novos registros do arquivo importado 😉</font><br>

        </cfif>
           
            <cfquery name="buscaNulos" datasource="#BANCOSINC#">

                select * from intcoldfusion.treinamentos_normativos where CPF IS NULL
            </cfquery>

        <cfif buscaNulos.recordcount EQ 0>
            
            <cfelse>

                <cfquery name="removerNulos" datasource="#BANCOSINC#">

                    delete intcoldfusion.treinamentos_normativos 
                    where CPF IS NULL

                </cfquery>

                <br><font style="font-size:18">🔧🛠️ Corrigindo erro de importação 🛠️🔧</font><br>

            </cfif>

    </cfloop>
</cfif>

</cfoutput> 

<br><br><button id="voltar" style="width:5cm; height: 1cm; font-size: 20; background-color: blue; color: white"> Voltar</button>
<script>
    document.getElementById("voltar").onclick = function voltar(params) {
        self.location = "../cadastrar.cfm";
    }
</script>





