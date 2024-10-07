<cfoutput>
<!--- <cfquery name="consulta" datasource="#BANCOSINC#"> --->
  WITH CONSULTA AS (   
    SELECT PCS.MODELO, PCS.CODIGO, PCS.DESCRICAO, 
            NVL(PCS.CONSUMO,1) CONSUMO,
            
            NVL((SELECT SAIU FROM (
                SELECT  MODELO, PECA, NVL(SUM(APROVADA),0) SAIU  FROM(
                            SELECT DATA, MODELO, PECA1 PECA, APROVADA1 APROVADA, REPINTURA1 REPINTURA FROM INTCOLDFUSION.PCP_SMALL_SAIDAS
                            UNION ALL 
                            SELECT DATA, MODELO, PECA2, APROVADA2, REPINTURA2 FROM INTCOLDFUSION.PCP_SMALL_SAIDAS
                            UNION ALL 
                            SELECT DATA, MODELO, PECA3, APROVADA3, REPINTURA3 FROM INTCOLDFUSION.PCP_SMALL_SAIDAS
                            UNION ALL 
                            SELECT DATA, MODELO, PECA4, APROVADA4, REPINTURA4 FROM INTCOLDFUSION.PCP_SMALL_SAIDAS
                            ) 
                          WHERE PECA IS NOT NULL
                          AND TO_CHAR(DATA, 'yyyy-mm-dd') >= '2023-08-01' -- PONTO DE CORTE INVENTARIO
                          AND TO_CHAR(DATA, 'yyyy-mm-dd') <= '#dataf#' --ACUMULATIVA ATÉ A DATA ANALISADA
                          --AND TRUNC(DATA) = TRUNC(SYSDATE)
                         -- AND TO_CHAR(DATA, 'MM/YY') = '07/23'
                          GROUP BY PECA, MODELO
            )SAIDAS WHERE SUBSTR(PCS.MODELO,1,3) = SAIDAS.MODELO  AND PCS.DESCRICAO = SAIDAS.PECA),0) QTD_SAIDA,
            
            NVL((SELECT QUANTIDADE 
              FROM (
                  SELECT * FROM INTCOLDFUSION.KANBAN_PCP_SMALL_INV 
                  WHERE STATUS <> '*'
                  ORDER BY DATA DESC ) INV
              WHERE PCS.CODIGO = INV.CODIGO AND SUBSTR(PCS.MODELO,1,3) = SUBSTR(INV.MODELO,1,3) AND ROWNUM = 1),0) QTD_INV,
              
            NVL((SELECT D_0 FROM 
                (
                    SELECT MODELO, CODIGO, SUM(D_0)D_0
                      FROM INTCOLDFUSION.KANBAN_PCP_SMALL_PROG 
                      WHERE STATUS <> '*' AND TO_CHAR(DATA, 'yyyy-mm-dd') <= '#dataf#'
                    GROUP BY MODELO, CODIGO
                )PROG
              WHERE PCS.CODIGO = PROG.CODIGO AND SUBSTR(PCS.MODELO,1,3) = SUBSTR(PROG.MODELO,1,3)),0) PROG_D_0,
              
            NVL((SELECT D_1 FROM 
                (
                    SELECT MODELO, CODIGO, SUM(D_1)D_1
                      FROM INTCOLDFUSION.KANBAN_PCP_SMALL_PROG 
                      WHERE STATUS <> '*' AND TO_CHAR(DATA, 'yyyy-mm-dd') <= '#dataf#'
                    GROUP BY MODELO, CODIGO
                )PROG
              WHERE PCS.CODIGO = PROG.CODIGO AND SUBSTR(PCS.MODELO,1,3) = SUBSTR(PROG.MODELO,1,3)),0) PROG_D_1
              
    FROM INTCOLDFUSION.PCP_SMALL_PECAS PCS
  ), 
  CONSULTA2 AS (
      SELECT CONSULTA.*,
            --QTD_INV + QTD_SAIDA - (PROG_D_0 * CONSUMO) PECAS_OK
            QTD_INV - (PROG_D_0 * CONSUMO) PECAS_OK
      FROM CONSULTA
  ),
  CONSULTA3 AS (
      SELECT CONSULTA2.*,
        CASE WHEN QTD_INV + QTD_SAIDA - (PROG_D_0 * CONSUMO) > 0 THEN 0 ELSE QTD_INV + QTD_SAIDA - (PROG_D_0 * CONSUMO) END AS NECESSIDADE_D_0, -- PECAS DISPONIVEIS - QUANTIDADE CONSUMIDA NO DIA
        CASE WHEN (PECAS_OK - (PROG_D_1 * CONSUMO)) > 0 THEN 0 ELSE (PECAS_OK - (PROG_D_1 * CONSUMO)) END AS NECESSIDADE_D_1
      FROM CONSULTA2
  )
  SELECT CONSULTA3.*,
        CASE WHEN NECESSIDADE_D_0 >= 0 THEN 'OK' ELSE 'NOK' END STATUS,
        CASE 
              WHEN PROG_D_0 = 0 THEN 'VERDE'
              WHEN NECESSIDADE_D_0 < 0 THEN 
                  CASE 
                      WHEN (NECESSIDADE_D_0 * -1) / PROG_D_0 > 0.3 THEN 'VERMELHO' --CASO A NECESSIDADE REPRESENTAR MAIS DE 30% DA PROGRAMÇÃO RETORNA VERMELHO
                      ELSE 'AMARELO'
                  END
              ELSE 'VERDE'
        END KANBAN_D_0,
        CASE 
              WHEN PROG_D_1 = 0 THEN 'VERDE'
              WHEN NECESSIDADE_D_1 < 0 THEN 
                  CASE 
                      WHEN (NECESSIDADE_D_1 * -1) / PROG_D_1 > 0.3 THEN 'VERMELHO' --CASO A NECESSIDADE REPRESENTAR MAIS DE 30% DA PROGRAMÇÃO RETORNA VERMELHO
                      ELSE 'AMARELO'
                  END
              ELSE 'VERDE'
        END KANBAN_D_1
  FROM CONSULTA3
</cfoutput>