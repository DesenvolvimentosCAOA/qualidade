<cfquery name='BUSCAQTD' datasource="#BANCOMES#">
    SELECT COUNT(DISTINCT ap.VIN) AS "Qtd VINs Distintos"
    FROM (
        -- Subconsulta para Entradas
        SELECT ap.*
        FROM   (
               SELECT wohd.Code,
                      Substring(wohd.Code, 0, 7)                                            "OP",
                      Substring(wohd.Code, 7, 2)                                            "Seq OP",
                      Substring(wohd.Code, 9, 3)                                            "Qtd OP",
                      Isnull((SELECT Max(A.VIN)
                              FROM   CTBLGravacao A
                              WHERE  A.IDLot IN (SELECT B.IDLot
                                                 FROM   TBLLot B
                                                 WHERE  B.Code = lot.Code)), 'Não Gravado') "VIN",
                      lot.Code                                                              "Barcode",
                      pro.Code                                                              "Codigo",
                      pro.Name                                                              "Produto",
                      mov.DtTimeStamp													 "DataApRaw",
                      CONVERT(DATE, mov.DtTimeStamp, 103)                                "Data Ap",
                      CONVERT(VARCHAR, mov.DtTimeStamp, 108)                                "Hora",
                      'ENTRADA'                                                             AS "Tipo",
                      ( CASE
                          -- Entradas Body
                          WHEN adr.IDAddress IN ( 347, 438 ) THEN 'BODY'
                          -- Entradas Paint
                          WHEN adr.IDAddress IN ( 334, 342, 341 ) THEN 'PAINT'
                          -- Entradas FA
                          WHEN adr.IDAddress IN ( 428, 412, 414 ) THEN 'FA'
                          -- Entradas FAI
                          WHEN adr.IDAddress IN ( 364 ) THEN 'FAI'
                          ELSE 'Endereço não encontrado'
                        END )                                                               AS "Predio",
                      adr.Code                                                              "Cod. Endereço",
                      adr.Name                                                              "Endereço",
                      mvt.Code                                                              "Codigo Mov",
                      mvt.Name                                                              "Tipo Movimento",
                      us.Name                                                               "Usuario"
               FROM   TBLMOVEv mov
                      -- Obter o código de barras
                      INNER JOIN TBLLOT lot
                              ON lot.IDLot = mov.IDLot
                      -- Vínculo entre código de barras e detalhes da OP
                      INNER JOIN TBLWODet wodet
                              ON lot.IDWODet = wodet.IDWODet
                      -- Vínculo entre detalhes da OP e cabeçalho da OP
                      INNER JOIN TBLWOHD wohd
                              ON wohd.IDWOHD = wodet.IDWOHD
                      -- Obter código do VIN
                      LEFT JOIN CTBLGRAVACAO vin
                             ON vin.IDLot = mov.IDLot
                                AND vin.vin <> ' '
                      -- Vínculo do código do Produto
                      INNER JOIN TBLProduct pro
                              ON PRO.IDProduct = MOV.IDProduct
                      -- Vínculo para obter dados do usuário
                      INNER JOIN TBLUser us
                              ON US.IDUser = MOV.IDUser
                      -- Vínculo para obter dados do endereço
                      INNER JOIN TBLAddress adr
                              ON adr.IDAddress = mov.IDAddress
                      -- Vínculo do tipo de movimento
                      INNER JOIN TBLMovType mvt
                              ON mvt.IDMovType = mov.IDMovType
               -- Body
               WHERE  ( ( adr.IDAddress IN ( 347, 438 )
                          AND mvt.Code LIKE 'E[_]%' )
                          -- Paint
                          OR ( adr.IDAddress IN ( 334, 342 )
                               AND mvt.Code = 'E_PNT' )
                          OR (adr.IDAddress = 341
                               AND mvt.Code = 'E_PNT'
                               and pro.name like '%CHASSI%')
                          -- Trim/FA
                          OR ( adr.IDAddress IN (428)
                               AND mvt.Code = 'ETVIN' 
                          )
                          OR ( adr.IDAddress IN (412)
                               AND mvt.Code = 'E_593' )
                          OR ( adr.IDAddress IN (414)
                               AND mvt.Code = 'E_593' )

                          -- FAI
                          OR ( adr.IDAddress IN ( 364 )
                            AND mvt.Code = 'E_FAI' ) )
               AND wohd.Code IS NOT NULL) ap
        WHERE  ap.[DataApRaw] BETWEEN dateadd(DAY, datediff(day, 0, @DATA_INICIAL), 0) 
              AND DATEADD(ms, -2, DATEADD(dd, 1, DATEDIFF(dd, 0, @DATA_FINAL)))
        AND ap.Hora >= '06:00:00' 
        AND ap.Hora <= '15:48:00'
        AND ( @PREDIO IS NULL OR ap.Predio = @PREDIO )
        AND ( @TIPO_MOV IS NULL OR ap.Tipo = @TIPO_MOV )
        AND ( @VIN IS NULL OR ap.VIN LIKE ('%' + @VIN + '%') )
        AND ( @BARCODE IS NULL OR ap.Barcode = @BARCODE )
        AND ( @PRODUTO IS NULL OR ap.Produto LIKE ('%' + @PRODUTO + '%') )
    
    UNION ALL
    
    -- Subconsulta para Saídas
    SELECT ap.*
    FROM   (
           SELECT wohd.Code,
                  Substring(wohd.Code, 0, 7)                                            "OP",
                  Substring(wohd.Code, 7, 2)                                            "Seq OP",
                  Substring(wohd.Code, 9, 3)                                            "Qtd OP",
                  Isnull((SELECT Max(A.VIN)
                          FROM   CTBLGravacao A
                          WHERE  A.IDLot IN (SELECT B.IDLot
                                             FROM   TBLLot B
                                             WHERE  B.Code = lot.Code)), 'Não Gravado') "VIN",
                  lot.Code                                                              "Barcode",
                  pro.Code                                                              "Codigo",
                  pro.Name                                                              "Produto",
                  mov.DtTimeStamp													 "DataApRaw",
                  CONVERT(DATE, mov.DtTimeStamp, 103)                                "Data Ap",
                  CONVERT(VARCHAR, mov.DtTimeStamp, 108)                                "Hora",
                  'SAIDA'                                                               AS "Tipo",
                  ( CASE
                      -- Saídas Body
                      WHEN adr.IDAddress IN (351, 9690) THEN 'BODY'
                      -- Saídas Paint
                      WHEN mvt.Code LIKE 'E[_]TRM' THEN 'PAINT'
                      -- Saídas FA
                      WHEN adr.IDAddress IN ( 409, 420, 413 ) THEN 'FA'
                      -- Saídas FAI
                      WHEN adr.IDAddress IN ( 371 ) THEN 'FAI'
                      ELSE 'Endereço não encontrado'
                    END )                                                               AS "Predio",
                  adr.Code                                                              "Cod. Endereço",
                  adr.Name                                                              "Endereço",
                  mvt.Code                                                              "Codigo Mov",
                  mvt.Name                                                              "Tipo Movimento",
                  us.Name                                                               "Usuario"
           FROM   TBLMOVEv mov
                  -- Obter o código de barras
                  INNER JOIN TBLLOT lot
                          ON lot.IDLot = mov.IDLot
                  -- Vínculo entre código de barras e detalhes da OP
                  INNER JOIN TBLWODet wodet
                          ON lot.IDWODet = wodet.IDWODet
                  -- Vínculo entre detalhes da OP e cabeçalho da OP
                  INNER JOIN TBLWOHD wohd
                          ON wohd.IDWOHD = wodet.IDWOHD
                  -- Obter código do VIN
                  LEFT JOIN CTBLGRAVACAO vin
                         ON vin.IDLot = mov.IDLot
                            AND vin.vin <> ' '
                  -- Vínculo do código do Produto
                  INNER JOIN TBLProduct pro
                          ON PRO.IDProduct = MOV.IDProduct
                  -- Vínculo para obter dados do usuário
                  INNER JOIN TBLUser us
                          ON US.IDUser = MOV.IDUser
                  -- Vínculo para obter dados do endereço
                  INNER JOIN TBLAddress adr
                          ON adr.IDAddress = mov.IDAddress
                  -- Vínculo do tipo de movimento
                  INNER JOIN TBLMovType mvt
                          ON mvt.IDMovType = mov.IDMovType
           -- Body
           WHERE  ( ( adr.IDAddress IN (case when mov.DtTimeStamp <= '2024-01-08 14:00:00.000' then 351 else 9690 end)
                      AND mvt.Code LIKE 'E[_]%'
                      and mvt.Code not like 'E_C_B' )
                      -- Paint
                      OR (mvt.Code LIKE 'E[_]TRM' )
                      -- Trim/FA
                      OR ( adr.IDAddress IN ( 409 )
                           AND mvt.Code LIKE 'E[_]%' 
                           and pro.name not like '%CHASSI%')
                      OR ( adr.IDAddress IN ( 420 )
                          AND mvt.Code in ('E_593', 'E_391', 'E_628')
                           and pro.name not like '%CHASSI%')
                      -- FAI
                      OR ( adr.IDAddress IN ( 371 )
                           AND mvt.Code in ('E_628', 'E_391', 'E_593') ) )
           AND wohd.Code IS NOT NULL) ap
    WHERE  ap.[DataApRaw] BETWEEN dateadd(DAY, datediff(day, 0, @DATA_INICIAL), 0) 
          AND DATEADD(ms, -2, DATEADD(dd, 1, DATEDIFF(dd, 0, @DATA_FINAL)))
    AND ap.Hora >= '06:00:00' 
    AND ap.Hora <= '15:48:00'
    AND ( @PREDIO IS NULL OR ap.Predio = @PREDIO )
    AND ( @TIPO_MOV IS NULL OR ap.Tipo = @TIPO_MOV )
    AND ( @VIN IS NULL OR ap.VIN LIKE ('%' + @VIN + '%') )
    AND ( @BARCODE IS NULL OR ap.Barcode = @BARCODE )
    AND ( @PRODUTO IS NULL OR ap.Produto LIKE ('%' + @PRODUTO + '%') )

    -- Finalizar contagem de VINs distintos
) ap
</cfquery>

<!-- Exibição da quantidade de VINs distintos -->
<p>Total de VINs distintos: #BUSCAQTD["Qtd VINs Distintos"]#</p>
