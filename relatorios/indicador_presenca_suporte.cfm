<cfinvoke method="inicializando" component="cf.ini.index">
    <cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">
    <cfcontent type="text/html; charset=UTF-8">
    <cfprocessingdirective pageEncoding="utf-8">

    <cfquery name="qPresenca_body1" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '1%'
            AND AREA = 'BODY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData4 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_body1" group="DIA">
        <cfset chartData4 = chartData4 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_body2" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '2%'
            AND AREA = 'BODY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData5 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_body2" group="DIA">
        <cfset chartData5 = chartData5 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_body3" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '3%'
            AND AREA = 'BODY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData6 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_body3" group="DIA">
        <cfset chartData6 = chartData6 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_paint1" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '1%'
            AND AREA = 'PAINT'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData1 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_paint1" group="DIA">
        <cfset chartData1 = chartData1 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_paint2" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '2%'
            AND AREA = 'PAINT'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData2 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_paint2" group="DIA">
        <cfset chartData2 = chartData2 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_paint3" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '3%'
            AND AREA = 'PAINT'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData3 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_paint3" group="DIA">
        <cfset chartData3 = chartData3 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fa1" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '1%'
            AND AREA = 'FINAL ASSEMBLY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData7 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fa1" group="DIA">
        <cfset chartData7 = chartData7 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fa2" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '2%'
            AND AREA = 'FINAL ASSEMBLY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData8 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fa2" group="DIA">
        <cfset chartData8 = chartData8 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fa3" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '3%'
            AND AREA = 'FINAL ASSEMBLY'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData9 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fa3" group="DIA">
        <cfset chartData9 = chartData9 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fai1" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '1%'
            AND AREA = 'FAI'
            AND DATA >= TRUNC(SYSDATE) -1
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData10 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fai1" group="DIA">
        <cfset chartData10 = chartData10 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fai2" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '2%'
            AND AREA = 'FAI'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData11 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fai2" group="DIA">
        <cfset chartData11 = chartData11 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_fai3" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '3%'
            AND AREA = 'FAI'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData12 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_fai3" group="DIA">
        <cfset chartData12 = chartData12 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_small1" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '1%'
            AND AREA = 'SMALL'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData13 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_small1" group="DIA">
        <cfset chartData13 = chartData13 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_small2" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '2%'
            AND AREA = 'SMALL'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData14 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_small2" group="DIA">
        <cfset chartData14 = chartData14 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

    <cfquery name="qPresenca_small3" datasource="#BANCOSINC#">
        SELECT 
            TO_CHAR(DATA, 'DD/MM/YYYY') AS DIA,
            TURNO, AREA,
            SUM(CASE WHEN SUPORTE_BODY = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_BODY,
            SUM(CASE WHEN SUPORTE_PAINT = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_PAINT,
            SUM(CASE WHEN SUPORTE_SMALL = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SMALL,
            SUM(CASE WHEN SUPORTE_FA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FA,
            SUM(CASE WHEN SUPORTE_FAI = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_FAI,
            SUM(CASE WHEN SUPORTE_SQE = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_SQE,
            SUM(CASE WHEN SUPORTE_LOGISTICA = 'SIM' THEN 1 ELSE 0 END) AS TOTAL_LOGISTICA
        FROM 
            PRESENCA_VER_E_AGIR
            WHERE TURNO LIKE '3%'
            AND AREA = 'SMALL'
            AND DATA >= TRUNC(SYSDATE) -10
        GROUP BY 
            TO_CHAR(DATA, 'DD/MM/YYYY'), TURNO, AREA
        ORDER BY 
            DIA, TURNO, AREA
    </cfquery>

    <cfset chartData15 = "['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística']">
    <cfoutput query="qPresenca_small3" group="DIA">
        <cfset chartData15 = chartData15 & ",['#DIA#', #TOTAL_BODY#, #TOTAL_PAINT#, #TOTAL_SMALL#, #TOTAL_FA#, #TOTAL_FAI#, #TOTAL_SQE#, #TOTAL_LOGISTICA#]">
    </cfoutput>

<html lang="pt-BR">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Indicador - Presença Suporte</title>
        <link rel="icon" href="/qualidade/FAI/assets/chery.png" type="image/x-icon">
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <link rel="stylesheet" href="/qualidade/relatorios/assets/style_shop.css?v1">
        <script type="text/javascript">
            google.charts.load('current', {'packages': ['corechart']});
            google.charts.setOnLoadCallback(drawCharts);
        
            function drawCharts() {
            // Função genérica para configurar os gráficos
            function drawChart(chartData, elementId, title, colors) {
                // Verifica se há dados
                if (chartData.length <= 1) {
                    chartData = [['Dia', 'Suporte Body', 'Suporte Paint', 'Suporte Small', 'Suporte Final Assembly', 'Suporte FAI', 'Suporte SQE', 'Suporte Logística'], ['Sem dados', 0, 0, 0, 0, 0, 0, 0]];
                }

                var data = google.visualization.arrayToDataTable(chartData);

                var options = {
                    title: title,
                    isStacked: true,
                    hAxis: {
                        title: 'Dia',
                        slantedText: true,
                        slantedTextAngle: 10, // Inclinação ajustada para melhor visibilidade
                        textStyle: {
                            fontSize: 12, // Tamanho da fonte ajustado para maior legibilidade
                        }
                    },
                    vAxis: {
                        title: 'Total de Presenças',
                        textStyle: {
                            fontSize: 12 // Tamanho da fonte ajustado no eixo vertical
                        }
                    },
                    legend: { position: 'top' },
                    colors: colors,
                    chartArea: {
                        left: 50,
                        right: 30,
                        top: 50,
                        bottom: 100 // Espaço adicional na parte inferior para exibir as datas corretamente
                    }
                };
                    var chart = new google.visualization.ColumnChart(document.getElementById(elementId));
                    chart.draw(data, options);
                }
        
                // Dados para o gráfico do 1º turno
                var chartData1 = [
                    <cfoutput>#chartData1#</cfoutput>
                ];
                drawChart(chartData1, 'chart_div', 'Indicador de Presença Paint 1ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
        
                // Dados para o gráfico do 2º turno
                var chartData2 = [
                    <cfoutput>#chartData2#</cfoutput>
                ];
                drawChart(chartData2, 'chart_div2', 'Indicador de Presença Paint 2ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
        
                // Dados para o gráfico do 3º turno
                var chartData3 = [
                    <cfoutput>#chartData3#</cfoutput>
                ];
                drawChart(chartData3, 'chart_div3', 'Indicador de Presença Paint 3ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do body 1º turno
                var chartData4 = [
                    <cfoutput>#chartData4#</cfoutput>
                ];
                drawChart(chartData4, 'chart_div4', 'Indicador de Presença Body 1ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do body 2º turno
                var chartData5 = [
                    <cfoutput>#chartData5#</cfoutput>
                ];
                drawChart(chartData5, 'chart_div5', 'Indicador de Presença Body 2ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
                
                // Dados para o gráfico do body 3º turno
                var chartData6 = [
                    <cfoutput>#chartData6#</cfoutput>
                ];
                drawChart(chartData6, 'chart_div6', 'Indicador de Presença Body 3ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
                
                // Dados para o gráfico do fa 1º turno
                var chartData7 = [
                    <cfoutput>#chartData7#</cfoutput>
                ];
                drawChart(chartData7, 'chart_div7', 'Indicador de Presença final assembly 1ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do fa 2º turno
                var chartData8 = [
                    <cfoutput>#chartData8#</cfoutput>
                ];
                drawChart(chartData8, 'chart_div8', 'Indicador de Presença final assembly 2ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
                
                // Dados para o gráfico do fa 3º turno
                var chartData9 = [
                    <cfoutput>#chartData9#</cfoutput>
                ];
                drawChart(chartData9, 'chart_div9', 'Indicador de Presença final assembly 3ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
    
                // Dados para o gráfico do fai 1º turno
                var chartData10 = [
                    <cfoutput>#chartData10#</cfoutput>
                ];
                drawChart(chartData10, 'chart_div10', 'Indicador de Presença FAI 1ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do fai 2º turno
                var chartData11 = [
                    <cfoutput>#chartData11#</cfoutput>
                ];
                drawChart(chartData11, 'chart_div11', 'Indicador de Presença FAI 2ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
                
                // Dados para o gráfico do fai 3º turno
                var chartData12 = [
                    <cfoutput>#chartData12#</cfoutput>
                ];
                drawChart(chartData12, 'chart_div12', 'Indicador de Presença FAI 3ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do small 1º turno
                var chartData13 = [
                    <cfoutput>#chartData13#</cfoutput>
                ];
                drawChart(chartData13, 'chart_div13', 'Indicador de Presença Small 1ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

                // Dados para o gráfico do small 2º turno
                var chartData14 = [
                    <cfoutput>#chartData14#</cfoutput>
                ];
                drawChart(chartData14, 'chart_div14', 'Indicador de Presença Small 2ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);
                
                // Dados para o gráfico do small 3º turno
                var chartData15 = [
                    <cfoutput>#chartData15#</cfoutput>
                ];
                drawChart(chartData15, 'chart_div15', 'Indicador de Presença Small 3ºTurno', ['#E57373', '#81C784', '#64B5F6', '#FFB74D', '#FF8A65']);

            }
        </script>
        <style>
            .carousel-container {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .carousel {
                display: flex;
                width: 100%;
                overflow: hidden;
                position: relative;
                margin-bottom: 20px; /* Espaçamento entre os carrosséis */
            }

            .carousel > div {
                flex: 0 0 100%;
                transition: transform 0.5s ease;
            }

            .carousel .prev, .carousel .next {
                cursor: pointer;
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background-color: rgba(0, 0, 0, 0.5);
                color: white;
                padding: 10px;
                border: none;
                outline: none;
                z-index: 1;
            }

            .carousel .prev {
                left: 10px;
            }

            .carousel .next {
                right: 10px;
            }
            .button-container {
            display: flex;
            gap: 10px;
            }

            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: bold;
                color: white;
                text-decoration: none;
                padding: 5px 10px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: auto;
            }

            .button.arrow-right:hover {
                background-color: #45a049;
            }

            .button.arrow-left {
                background-color: #2196f3;
                position: relative;
            }

            .button.arrow-left::before {
                content: '';
                display: block;
                width: 0;
                height: 0;
                border-top: 7px solid transparent;
                border-bottom: 7px solid transparent;
                border-right: 7px solid white;
                margin-right: 5px;
            }

            .button.arrow-left:hover {
                background-color: #1e88e5;
            }

        </style>
    </head>
    <body>
        <header class="titulo">
            <cfinclude template="auxi/nav_links.cfm">
        </header>
        <div id="loading-screen">
            <div class="spinner"></div>
        </div>
        <h2 style="margin-top:100px;">INDICADOR DE PRESENÇA SUPORTE VER & AGIR</h2>
        <h6 style="margin-top:-10px;margin-left:47%;">(ÚLTIMOS 10 DIAS)</h6>
        <div class="button-container">
            <a href="indicador_presenca_area.cfm" class="button arrow-left">ÁREA</a>
        </div>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div" style="width: 100%; height: 400px; margin-top: 50px;"></div>
                <div id="chart_div2" style="width: 100%; height: 400px; margin-top: 50px;"></div>
                <div id="chart_div3" style="width: 100%; height: 400px; margin-top: 50px;"></div>
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div4" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div5" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div6" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div7" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div8" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div9" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div10" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div11" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div12" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <div class="carousel-container">
            <div class="carousel">
                <div id="chart_div13" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div14" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <div id="chart_div15" style="width: 100%; height: 400px; margin-top: 30px;"></div>
                <button class="prev">&lt;</button>
                <button class="next">&gt;</button>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                function createCarousel(carousel) {
                    let index = 0;
                    const slides = carousel.querySelectorAll('div[id^="chart_div"]');
                    const totalSlides = slides.length;
                    const prevButton = carousel.querySelector('.prev');
                    const nextButton = carousel.querySelector('.next');
                    
                    function showSlide(n) {
                        index = (n + totalSlides) % totalSlides;
                        slides.forEach((slide, i) => {
                            slide.style.transform = `translateX(${-index * 100}%)`;
                        });
                    }
                    
                    prevButton.addEventListener('click', () => showSlide(index - 1));
                    nextButton.addEventListener('click', () => showSlide(index + 1));
                    
                    showSlide(index);
                }
                
                // Seleciona todos os carrosséis e aplica a função
                const carousels = document.querySelectorAll('.carousel');
                carousels.forEach(carousel => createCarousel(carousel));
            });
        </script>

        <script src="/qualidade/relatorios/assets/script.js"></script>
        
    </body>
</html>