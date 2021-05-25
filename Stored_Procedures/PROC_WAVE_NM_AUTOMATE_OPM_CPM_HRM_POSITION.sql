USE Prod_DataClean
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_HRM_POSITION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_HRM_POSITION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_HRM_POSITION]
	@which_date AS VARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_HRM_POSITION '2021-03-10'
--SELECT * FROM HRM_INFO_LKUP ORDER BY POSITION
--SELECT * FROM HRM_INFO_LKUP WHERE [HRM POSITION] IS NULL
--SELECT * FROM HRM_INFO_LKUP WHERE [HRM POSITION] IS NOT NULL AND [HRM PERSNO] IS NULL
--SELECT * FROM CTE_HRM_NEXT_LEVEL_ORGUNIT ORDER BY ORGUNIT, [LEVEL]

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS HRM_INFO_LKUP;
	                                         DROP TABLE IF EXISTS HRP1001_HRM_ORGUNIT;
											 DROP TABLE IF EXISTS HRP1001_HRM_NEXT_LEVEL_ORGUNIT;
											 DROP TABLE IF EXISTS HRP1001_HRM_POSITION;
											 DROP TABLE IF EXISTS HRP1001_HRM_PERSNO;
											 DROP TABLE IF EXISTS CTE_HRM_NEXT_LEVEL_ORGUNIT;';
	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
	    INTO HRP1001_HRM_ORGUNIT
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'O' AND 
			RELAT = '003' AND
			PLVAR = '01'

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_HRM_NEXT_LEVEL_ORGUNIT
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'O' AND
			RSIGN = 'A' AND
			SCLAS = 'O' AND 
			RELAT = '002' AND 
			PLVAR = '01';

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_HRM_POSITION 
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'O' AND
			RSIGN = 'A' AND
			SCLAS = 'S' AND 
			RELAT = 'Z12' AND
			PLVAR = '01';

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_HRM_PERSNO
		FROM GV_HRP1001 A1
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'P' AND 
			RELAT = '008' AND
			TRY_CONVERT(NUMERIC(20, 3), TRIM(PROZT)) >= 100.00 AND
			PLVAR = '01';

	SELECT * INTO HRM_INFO_LKUP FROM (
		SELECT A1.OBJID POSITION, A1.SOBID ORGUNIT, CAST(NULL AS NVARCHAR(250)) [NEXT LEVEL ORGUNIT], A2.SOBID [HRM POSITION], A3.SOBID [HRM PERSNO] 
		    FROM HRP1001_HRM_ORGUNIT A1 
			  LEFT JOIN	HRP1001_HRM_POSITION A2 ON A1.SOBID=A2.OBJID
		      LEFT JOIN	HRP1001_HRM_PERSNO A3 ON A2.SOBID=A3.OBJID
	) A1;
	UPDATE HRM_INFO_LKUP SET [NEXT LEVEL ORGUNIT]=[ORGUNIT];
		
	WITH CTE AS (
		SELECT DISTINCT ORGUNIT, ORGUNIT [NEXT LEVEL ORGUNIT], 1 [LEVEL], CAST(ORGUNIT AS NVARCHAR(2000)) [BRED GRAM] FROM HRM_INFO_LKUP WHERE [HRM POSITION] IS NULL
		UNION ALL
		SELECT A2.ORGUNIT, A1.SOBID [NEXT LEVEL ORGUNIT], [LEVEL]+1,  CAST([BRED GRAM]+'/'+TRIM(A1.SOBID) AS NVARCHAR(2000))
			 FROM HRP1001_HRM_NEXT_LEVEL_ORGUNIT A1
			   INNER JOIN CTE A2 ON A1.OBJID=A2.[NEXT LEVEL ORGUNIT]
			 WHERE A1.SOBID IS NOT NULL
	)
	SELECT DISTINCT A1.ORGUNIT, A1.[NEXT LEVEL ORGUNIT], A2.SOBID [HRM POSITION], A3.SOBID [HRM PERSNO], [LEVEL], [BRED GRAM],
					ROW_NUMBER() OVER(PARTITION BY A1.ORGUNIT ORDER BY A1.[LEVEL]) RNUM 
	INTO CTE_HRM_NEXT_LEVEL_ORGUNIT
	FROM CTE A1 
		LEFT JOIN HRP1001_HRM_POSITION A2 ON A1.[NEXT LEVEL ORGUNIT]=A2.OBJID
		LEFT JOIN HRP1001_HRM_PERSNO A3 ON A2.SOBID=A3.OBJID
	WHERE A2.SOBID IS NOT NULL

	UPDATE A1 SET 
	   [NEXT LEVEL ORGUNIT]=A2.[NEXT LEVEL ORGUNIT],
	   [HRM POSITION]=A2.[HRM POSITION],
	   [HRM PERSNO]=A2.[HRM PERSNO]
	FROM HRM_INFO_LKUP A1 
	    LEFT JOIN CTE_HRM_NEXT_LEVEL_ORGUNIT A2 ON A1.ORGUNIT=A2.ORGUNIT
	WHERE A2.RNUM=1
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_CPM_POSITION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_CPM_POSITION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_CPM_POSITION]
	@which_date AS VARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_CPM_POSITION '2021-03-10'
--SELECT * FROM CPM_INFO_LKUP ORDER BY PERNR
--SELECT * FROM CPM_INFO_LKUP WHERE [CPM POSITION] IS NULL
--SELECT * FROM CPM_INFO_LKUP WHERE [CPM POSITION] IS NOT NULL AND [CPM PERSNO] IS NULL
--SELECT * FROM CTE_CPM_NEXT_LEVEL_ORGUNIT ORDER BY ORGUNIT, [LEVEL]

--SELECT DISTINCT A1.* FROM CPM_INFO_LKUP A1 LEFT JOIN [AdhocQuery] A2 ON A1.PERNR=A2.Persno WHERE [CPM POSITION] IS NULL AND ISNULL(A2.[CPMName], '')<>''

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS CPM_INFO_LKUP;
	                                         DROP TABLE IF EXISTS PA0001_CPM_ORGUNIT;
											 DROP TABLE IF EXISTS HRP1001_CPM_NEXT_LEVEL_ORGUNIT;
											 DROP TABLE IF EXISTS HRP1001_CPM_POSITION;
											 DROP TABLE IF EXISTS HRP1001_CPM_PERSNO;
											 DROP TABLE IF EXISTS CTE_CPM_NEXT_LEVEL_ORGUNIT;';
	SELECT TRIM(PERNR) OBJID, TRIM(ORGEH) SOBID 
	    INTO PA0001_CPM_ORGUNIT
		FROM P0_PA0001
		WHERE BEGDA <= CAST(@which_date AS DATE) AND
			  ENDDA >= CAST(@which_date AS DATE)

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_CPM_NEXT_LEVEL_ORGUNIT
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'O' AND
			RSIGN = 'A' AND
			SCLAS = 'O' AND 
			RELAT = '002' AND 
			PLVAR = '01';

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_CPM_POSITION 
    FROM (
		SELECT *, ROW_NUMBER() OVER(PARTITION BY OBJID ORDER BY RELAT) RNUM FROM (
			SELECT OBJID, SOBID, RELAT FROM GV_HRP1001 A1
					WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
						CONVERT(date,REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
						OTYPE = 'O' AND
						RSIGN = 'B' AND
						SCLAS = 'S' AND 
						RELAT = '012' AND
						PLVAR = '01' AND
						SOBID IS NOT NULL
			UNION ALL
			SELECT OBJID, SOBID, RELAT FROM GV_HRP1001 A1
					WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
						CONVERT(DATE, REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
						OTYPE = 'O' AND
						RSIGN = 'B' AND
						SCLAS = 'S' AND 
						RELAT = 'Z13' AND
						PLVAR = '01' AND
						SOBID IS NOT NULL
		) A1
	) A2 WHERE RNUM=1
	
    SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_CPM_PERSNO
		FROM GV_HRP1001 A1
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(DATE,REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'P' AND 
			RELAT = '008' AND
			PLVAR = '01'			

	SELECT * INTO CPM_INFO_LKUP FROM (
		SELECT A1.OBJID PERNR, A1.SOBID ORGUNIT, CAST(NULL AS NVARCHAR(250)) [NEXT LEVEL ORGUNIT], A2.SOBID [CPM POSITION], A3.SOBID [CPM PERSNO] 
		    FROM PA0001_CPM_ORGUNIT A1 
			  LEFT JOIN	HRP1001_CPM_POSITION A2 ON A1.SOBID=A2.OBJID
		      LEFT JOIN	HRP1001_CPM_PERSNO A3 ON A2.SOBID=A3.OBJID
	) A1;
	UPDATE CPM_INFO_LKUP SET [NEXT LEVEL ORGUNIT]=[ORGUNIT];
		
	WITH CTE AS (
		SELECT DISTINCT ORGUNIT, ORGUNIT [NEXT LEVEL ORGUNIT], 1 [LEVEL], CAST(ORGUNIT AS NVARCHAR(2000)) [BRED GRAM] FROM CPM_INFO_LKUP WHERE [CPM POSITION] IS NULL
		UNION ALL
		SELECT A2.ORGUNIT, A1.SOBID [NEXT LEVEL ORGUNIT], [LEVEL]+1,  CAST([BRED GRAM]+'/'+TRIM(A1.SOBID) AS NVARCHAR(2000))
			 FROM HRP1001_CPM_NEXT_LEVEL_ORGUNIT A1
			   INNER JOIN CTE A2 ON A1.OBJID=A2.[NEXT LEVEL ORGUNIT]
			 WHERE A1.SOBID IS NOT NULL
	)
	SELECT DISTINCT A1.ORGUNIT, A1.[NEXT LEVEL ORGUNIT], A2.SOBID [CPM POSITION], A3.SOBID [CPM PERSNO], [LEVEL], [BRED GRAM],
					ROW_NUMBER() OVER(PARTITION BY A1.ORGUNIT ORDER BY A1.[LEVEL]) RNUM 
	INTO CTE_CPM_NEXT_LEVEL_ORGUNIT
	FROM CTE A1 
		LEFT JOIN HRP1001_CPM_POSITION A2 ON A1.[NEXT LEVEL ORGUNIT]=A2.OBJID
		LEFT JOIN HRP1001_CPM_PERSNO A3 ON A2.SOBID=A3.OBJID
	WHERE A2.SOBID IS NOT NULL

	UPDATE A1 SET 
	   [NEXT LEVEL ORGUNIT]=A2.[NEXT LEVEL ORGUNIT],
	   [CPM POSITION]=A2.[CPM POSITION],
	   [CPM PERSNO]=A2.[CPM PERSNO]
	FROM CPM_INFO_LKUP A1 
	    LEFT JOIN CTE_CPM_NEXT_LEVEL_ORGUNIT A2 ON A1.ORGUNIT=A2.ORGUNIT
	WHERE A2.RNUM=1

END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OPM_POSITION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OPM_POSITION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OPM_POSITION]
	@which_date AS VARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_OPM_POSITION '2021-03-10'
--SELECT * FROM OPM_INFO_LKUP ORDER BY POSITION

--SELECT * FROM OPM_INFO_LKUP WHERE [OPM_SUPERIOR_ORGUNIT] = [OPM_SUPERIOR_HRCORE_ORGUNIT] ORDER BY POSITION

--SELECT POSITION, ORGUNIT, OLD_ORGUNIT, [OPM POSITION], [OPM ORGUNIT], [SUPERIOR_ORGUNIT], 
--       [OPM_SUPERIOR_POSITION], [OPM_SUPERIOR_HRCORE_ORGUNIT], [OPM_SUPERIOR_ORGUNIT], [SOC], [BRED GRAM ORGUNIT] 
--FROM OPM_INFO_LKUP 
--WHERE [BRED GRAM POSITION] LIKE '%20002609%' AND ([ORGUNIT]=[SUPERIOR_ORGUNIT] OR [OPM_SUPERIOR_ORGUNIT]=[SUPERIOR_ORGUNIT] OR [ORGUNIT]=[OPM_SUPERIOR_ORGUNIT])
--SELECT * FROM OPM_INFO_LKUP WHERE [POSITION]='20635683'
--SELECT * FROM OPM_INFO_LKUP WHERE [POSITION]='20201405'
--SELECT * FROM OPM_INFO_LKUP WHERE [POSITION]='20436582'
--SELECT * FROM OPM_INFO_LKUP WHERE [OPM POSITION]='20635683'
--SELECT * FROM OPM_INFO_LKUP WHERE [OPM_SUPERIOR_POSITION]='20575462'

--SELECT * FROM OPM_INFO_LKUP WHERE [OPM POSITION] IS NULL ORDER BY [POSITION]
--SELECT * FROM OPM_INFO_LKUP WHERE [OPM POSITION] IS NOT NULL AND [OPM PERSNO] IS NULL
--SELECT * FROM OPM_INFO_LKUP WHERE [OPM PERSNO] = [PERNR]
--SELECT * FROM CTE_OPM_NEXT_LEVEL_POSITION ORDER BY POSITION, [LEVEL]
--SELECT * FROM OPM_INFO_LKUP WHERE [ORGUNIT]<>[OPM ORGUNIT] ORDER BY PERNR
--SELECT * FROM OPM_INFO_LKUP WHERE [ORGUNIT]=[OPM ORGUNIT] AND SOC <> 0 ORDER BY PERNR
--SELECT * FROM OPM_INFO_LKUP WHERE PERNR IN (SELECT PERNR FROM OPM_INFO_LKUP WHERE PERNR_NUM >= 2) ORDER BY POSITION, PERNR
--SELECT * FROM OPM_INFO_LKUP WHERE POSITION IN (SELECT POSITION FROM OPM_INFO_LKUP WHERE POSITION_NUM >= 2) ORDER BY POSITION, PERNR


--SELECT * FROM PA0001_OPM_ORGUNIT ORDER BY OBJID
--PA0001 -> First Level ORGUNIT(ORGUN)
--SELECT ORGEH FROM P0_PA0001
--10065804/10065722/10065685/10065721/10065459/10030687/10000000
    
	--DECLARE @which_date AS VARCHAR(20)='2021-03-10';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS OPM_INFO_LKUP;
	                                         DROP TABLE IF EXISTS OPM_ORGUNIT;
	                                         DROP TABLE IF EXISTS HRP1001_OPM_ORGUNIT;
											 DROP TABLE IF EXISTS HRP1001_OPM_NEXT_LEVEL_ORGUNIT;
	                                         DROP TABLE IF EXISTS PA0001_OPM_POSITION;
											 DROP TABLE IF EXISTS HRP1001_OPM_NEXT_POSITION;
											 DROP TABLE IF EXISTS HRP1001_OPM_PERSNO;
											 DROP TABLE IF EXISTS CTE_OPM_NEXT_LEVEL_POSITION;';


	SELECT DISTINCT TRIM(PERNR) OBJID, TRIM(PLANS) SOBID, ORGEH ORGUNIT 
	    INTO PA0001_OPM_POSITION
		FROM P0_PA0001
		WHERE BEGDA <= CAST(@which_date AS DATE) AND
			  ENDDA >= CAST(@which_date AS DATE)

	SELECT DISTINCT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_OPM_NEXT_POSITION
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'S' AND 
			RELAT = '002' AND 
			PLVAR = '01';

	SELECT DISTINCT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_OPM_PERSNO
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,REPLACE(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'P' AND 
			RELAT = '008' AND 
			PLVAR = '01';

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
	    INTO HRP1001_OPM_ORGUNIT
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'S' AND
			RSIGN = 'A' AND
			SCLAS = 'O' AND 
			RELAT = '003' AND
			PLVAR = '01'

	SELECT TRIM(OBJID) OBJID, TRIM(SOBID) SOBID 
		INTO HRP1001_OPM_NEXT_LEVEL_ORGUNIT
		FROM GV_HRP1001
		WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			OTYPE = 'O' AND
			RSIGN = 'A' AND
			SCLAS = 'O' AND 
			RELAT = '002' AND 
			PLVAR = '01';

	SELECT *, 
	       POSITION WD_POSITION, 
		   CAST(NULL AS NVARCHAR(40)) [OLD_ORGUNIT], 	       
		   CAST(NULL AS NVARCHAR(40)) [SUPERIOR_ORGUNIT], 	       
		   CAST(NULL AS NVARCHAR(40)) [OPM_SUPERIOR_POSITION], 	       
		   CAST(NULL AS NVARCHAR(40)) [OPM_SUPERIOR_HRCORE_ORGUNIT], 	       
		   CAST(NULL AS NVARCHAR(40)) [OPM_SUPERIOR_ORGUNIT], 	       
	       CAST(NULL AS NVARCHAR(40)) [CHILD], 
		   CAST(NULL AS NVARCHAR(40)) [PARENT], 	       
	       CAST(0 AS INT) [NOR], 
		   CAST(0 AS INT) [SOC], 
		   CAST(NULL AS INT) [LEVEL], 
	       CAST(NULL AS NVARCHAR(4000)) [BRED GRAM POSITION], 
	       CAST(NULL AS NVARCHAR(4000)) [BRED GRAM ORGUNIT], 
	       ROW_NUMBER() OVER(PARTITION BY POSITION ORDER BY POSITION) POSITION_NUM,
		   ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY PERNR) PERNR_NUM
		   INTO OPM_INFO_LKUP FROM (
		SELECT DISTINCT A1.OBJID PERNR, A1.SOBID POSITION, A1.ORGUNIT, A2.SOBID [OPM POSITION], A4.SOBID [OPM ORGUNIT], A3.SOBID [OPM PERSNO] 
		    FROM PA0001_OPM_POSITION A1 
			  LEFT JOIN	HRP1001_OPM_NEXT_POSITION A2 ON A1.SOBID=A2.OBJID
		      LEFT JOIN	HRP1001_OPM_PERSNO A3 ON A2.SOBID=A3.OBJID
			  LEFT JOIN HRP1001_OPM_ORGUNIT A4 ON A2.SOBID=A4.OBJID
	) A1;

	/* Cancatenating Rank for multiple PERNR belongs to same positon */
	UPDATE OPM_INFO_LKUP SET 
	   WD_POSITION='P-'+POSITION+'-'+CAST(POSITION_NUM AS VARCHAR(20))
	WHERE POSITION IN (SELECT POSITION FROM OPM_INFO_LKUP WHERE POSITION_NUM >= 2);

	/* Populating OPM's Superior Position and Org Unit */
	--SELECT DISTINCT [OPM POSITION] FROM OPM_INFO_LKUP WHERE NOR >= 1
	UPDATE A4 SET
	   [OPM_SUPERIOR_POSITION]=A5.[OPM POSITION],
	   [OPM_SUPERIOR_ORGUNIT]=A5.[OPM ORGUNIT],
	   [OPM_SUPERIOR_HRCORE_ORGUNIT]=A5.[OPM ORGUNIT]
	FROM OPM_INFO_LKUP A4 
	     LEFT JOIN (SELECT A1.[PERNR], A3.[POSITION], A3.[ORGUNIT], A3.[OPM POSITION], A3.[OPM ORGUNIT] 
		               FROM OPM_INFO_LKUP A1
	                        INNER JOIN OPM_INFO_LKUP A2 ON A1.[OPM POSITION]=A2.[POSITION]
			                INNER JOIN OPM_INFO_LKUP A3 ON A2.[OPM POSITION]=A3.[POSITION]) A5 ON A4.[PERNR]=A5.[PERNR];

	/* Creating Bed Gram for Position and Org Unit */
    WITH CTE AS (
		SELECT DISTINCT [POSITION], [POSITION] [NEXT LEVEL POSITION], [ORGUNIT], 1 [LEVEL], 
		                CAST([POSITION] AS NVARCHAR(2000)) [BRED GRAM POSITION], 
						CAST([ORGUNIT] AS NVARCHAR(2000)) [BRED GRAM ORGUNIT] 
		      FROM OPM_INFO_LKUP WHERE [OPM POSITION] IS NOT NULL
		UNION ALL
		SELECT A2.POSITION, A1.SOBID [NEXT LEVEL POSITION], A3.SOBID [ORGUNIT], [LEVEL]+1, 
		      CAST([BRED GRAM POSITION]+'/'+TRIM(A1.SOBID) AS NVARCHAR(2000)),
			  CAST([BRED GRAM ORGUNIT]+'/'+TRIM(A3.SOBID) AS NVARCHAR(2000))
			  --CAST(IIF([BRED GRAM ORGUNIT]='', TRIM(A3.SOBID), [BRED GRAM ORGUNIT]+'/'+TRIM(A3.SOBID)) AS NVARCHAR(2000))
			 FROM HRP1001_OPM_NEXT_POSITION A1
			   INNER JOIN CTE A2 ON A1.OBJID=A2.[NEXT LEVEL POSITION]
			   INNER JOIN HRP1001_OPM_ORGUNIT A3 ON A3.OBJID=A2.[NEXT LEVEL POSITION]
			 WHERE A1.SOBID IS NOT NULL
	)
	SELECT DISTINCT A1.POSITION, A1.[NEXT LEVEL POSITION], [ORGUNIT], [LEVEL], [BRED GRAM POSITION], [BRED GRAM ORGUNIT],
					ROW_NUMBER() OVER(PARTITION BY A1.POSITION ORDER BY A1.[LEVEL] DESC) RNUM 
	INTO CTE_OPM_NEXT_LEVEL_POSITION
	FROM CTE A1

	UPDATE A1 SET 
	      [BRED GRAM POSITION]=A2.[BRED GRAM POSITION],
		  [BRED GRAM ORGUNIT]=A2.[BRED GRAM ORGUNIT],
		  [LEVEL]=A2.[LEVEL]
	   FROM OPM_INFO_LKUP A1 LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A2 ON A1.POSITION=A2.POSITION
	   WHERE RNUM=1;

	UPDATE A1 SET 
		  [CHILD]=IIF(A1.[POSITION_NUM]=1, A1.[POSITION], A1.[WD_POSITION]),
		  [PARENT]=[OPM POSITION],
		  [SUPERIOR_ORGUNIT]=[OPM ORGUNIT],
		  [OLD_ORGUNIT]=[ORGUNIT]
	   FROM OPM_INFO_LKUP A1;

	/* Direct and Indirect Count */
	WITH CTE AS (
	     SELECT [CHILD], [PARENT] FROM OPM_INFO_LKUP
		 UNION ALL
		 SELECT A1.[CHILD], A2.[PARENT] FROM CTE A1 INNER JOIN OPM_INFO_LKUP A2 ON A1.PARENT=A2.CHILD
	)
	UPDATE A1 SET
	   NOR=[CHILD_COUNT],
	   SOC=(SELECT COUNT(PERNR) FROM OPM_INFO_LKUP WHERE PARENT=A1.CHILD)
	FROM OPM_INFO_LKUP A1 INNER JOIN 
	(
		SELECT [PARENT], COUNT([CHILD]) [CHILD_COUNT] FROM CTE
		GROUP BY [PARENT]
	) A2 ON A1.CHILD=A2.PARENT

	/* Moving one level up OPM and their Superior */
	PRINT 'OPM ORG UNIT'
	SELECT DISTINCT 'OPM' [MANAGER], [OPM POSITION] [POSITION], (A3.[LEVEL]+1) [LEVEL], CAST(A4.ORGUNIT AS NVARCHAR(40)) [ORGUNIT] INTO OPM_ORGUNIT FROM (
		SELECT DISTINCT A1.[OPM POSITION], MAX(A2.LEVEL) [LEVEL] 
			FROM OPM_INFO_LKUP A1 
				LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A2 ON A1.[OPM POSITION]=A2.POSITION AND A2.[ORGUNIT]=A1.[OPM ORGUNIT]
			WHERE A1.[ORGUNIT]=A1.[OPM ORGUNIT]
			GROUP BY A1.[OPM POSITION]
	) A3 LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A4 ON A3.[OPM POSITION]=A4.POSITION AND A4.LEVEL=(A3.LEVEL+1)
	WHERE A3.[LEVEL] IS NOT NULL
	
	UPDATE A1 SET
	   [ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[POSITION]=A2.[POSITION] AND A2.MANAGER='OPM'

	UPDATE A1 SET
	   [SUPERIOR_ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[OPM POSITION]=A2.[POSITION] AND A2.MANAGER='OPM'

	UPDATE A1 SET
	   [OPM_SUPERIOR_ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[OPM_SUPERIOR_POSITION]=A2.[POSITION] AND A2.MANAGER='OPM'

	PRINT 'SUPERIOR OPM ORG UNIT'
	INSERT INTO OPM_ORGUNIT
	SELECT DISTINCT 'SUP' [MANAGER], [OPM_SUPERIOR_POSITION] [POSITION], (A3.[LEVEL]+1) [LEVEL], CAST(A4.ORGUNIT AS NVARCHAR(40)) [ORGUNIT] FROM (
		SELECT DISTINCT A1.[OPM_SUPERIOR_POSITION], MAX(A2.LEVEL) [LEVEL] 
			FROM OPM_INFO_LKUP A1 
				LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A2 ON A1.[OPM_SUPERIOR_POSITION]=A2.POSITION AND A2.[ORGUNIT]=A1.[OPM_SUPERIOR_ORGUNIT]
			WHERE A1.[ORGUNIT]=A1.[OPM_SUPERIOR_ORGUNIT]
			GROUP BY A1.[OPM_SUPERIOR_POSITION]
	) A3 LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A4 ON A3.[OPM_SUPERIOR_POSITION]=A4.POSITION AND A4.LEVEL=(A3.LEVEL+1)
	WHERE A3.[LEVEL] IS NOT NULL
	
	UPDATE A1 SET
	   [ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[POSITION]=A2.[POSITION] AND A2.MANAGER='SUP'

	UPDATE A1 SET
	   [SUPERIOR_ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[OPM POSITION]=A2.[POSITION] AND A2.MANAGER='SUP'

	UPDATE A1 SET
	   [OPM_SUPERIOR_ORGUNIT]=A2.[ORGUNIT]
	FROM OPM_INFO_LKUP A1 JOIN OPM_ORGUNIT A2 ON A1.[OPM_SUPERIOR_POSITION]=A2.[POSITION] AND A2.MANAGER='SUP'

END
GO

--SELECT * FROM CTE_OPM_NEXT_LEVEL_POSITION WHERE [POSITION]='20762983' ORDER BY POSITION, [LEVEL]
--SELECt * FROM CTE_OPM_NEXT_LEVEL_POSITION WHERE [POSITION]='20836064' ORDER BY POSITION, [LEVEL]
--SELECT * FROM OPM_INFO_LKUP WHERE [POSITION]='20762983'
----SELECT * FROM OPM_INFO_LKUP WHERE [ORGUNIT]=[OPM ORGUNIT] AND SOC <> 0 ORDER BY PERNR

--SELECT DISTINCT A1.*, A2.* FROM OPM_INFO_LKUP A1 
--			LEFT JOIN SELECT * FROM CTE_OPM_NEXT_LEVEL_POSITION A2 ON A1.[OPM POSITION]=A2.POSITION
--	   WHERE A1.[ORGUNIT]=A1.[OPM ORGUNIT] AND A1.[POSITION]='20762983'

--SELECT [OPM POSITION], ([LEVEL]+1) [LEVEL] FROM (
--	SELECT DISTINCT A1.[OPM POSITION], MAX(A2.LEVEL) [LEVEL] 
--		FROM OPM_INFO_LKUP A1 
--			LEFT JOIN CTE_OPM_NEXT_LEVEL_POSITION A2 ON A1.[OPM POSITION]=A2.POSITION AND A2.[ORGUNIT]=A1.[OPM ORGUNIT]
--	   WHERE A1.[ORGUNIT]=A1.[OPM ORGUNIT]
--	   GROUP BY A1.[OPM POSITION]
--) A1 WHERE [LEVEL] IS NOT NULL

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OPM_CPM_HRM_POSITION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OPM_CPM_HRM_POSITION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OPM_CPM_HRM_POSITION]
	@which_date AS VARCHAR(50)
AS
BEGIN
   
   EXEC PROC_WAVE_NM_AUTOMATE_HRM_POSITION '2021-03-10';
   EXEC PROC_WAVE_NM_AUTOMATE_CPM_POSITION '2021-03-10';
   EXEC PROC_WAVE_NM_AUTOMATE_OPM_POSITION '2021-03-10';

END
GO

--EXEC PROC_WAVE_NM_AUTOMATE_OPM_CPM_HRM_POSITION '2021-03-10'