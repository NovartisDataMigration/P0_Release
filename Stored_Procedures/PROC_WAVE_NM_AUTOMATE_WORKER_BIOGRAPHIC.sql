USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_BIOGRAPICS]    Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--A90DBC11

/* If the function('dbo.udf_GetNumeric') already exist */
IF OBJECT_ID('dbo.udf_GetNumeric') IS NOT NULL
  DROP FUNCTION udf_GetNumeric
GO
CREATE FUNCTION dbo.udf_GetNumeric
(
  @strAlphaNumeric VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
  DECLARE @intAlpha INT
  SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
  BEGIN
    WHILE @intAlpha > 0
    BEGIN
      SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
      SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
    END
  END
  RETURN ISNULL(@strAlphaNumeric,0)
END
GO
--PRINT dbo.udf_GetNumeric('ABDBC9011');

/* If the function('dbo.GetWorkDayValue') already exist */
IF OBJECT_ID('dbo.GetWorkDayValue') IS NOT NULL
  DROP FUNCTION GetWorkDayValue
GO
CREATE FUNCTION GetWorkDayValue (
    @HR_CORE_VALUE   AS VARCHAR(300),
	@COUNTRY_CODE    AS VARCHAR(30),
	@WD_TYPE         AS VARCHAR(100)
)
RETURNS varchar(500)  
BEGIN  
    --DECLARE @COUNTRY3_CODE AS VARCHAR(20)='';
	--SELECT @COUNTRY3_CODE=[Country Code] FROM COUNTRY_LKUP WHERE [Country2 Code]=@COUNTRY_CODE
    DECLARE @result AS VARCHAR(500)=@WD_TYPE+'_'+@COUNTRY_CODE+'_'+REPLACE(@HR_CORE_VALUE, ' ', '_');
	RETURN IIF(@HR_CORE_VALUE='', '', @result);
END
GO


-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_COUNT_SHEET', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_COUNT_SHEET;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_COUNT_SHEET]
    @which_report    AS NVARCHAR(50),
	@final_table     AS NVARCHAR(500)
AS
BEGIN
   DECLARE @DGW_COUNT_CONFIG_TABLE TABLE (
      DGW             NVARCHAR(200),
      ENTITY          NVARCHAR(1000),
	  HR_FIELD        NVARCHAR(1000),
	  HR_CORE_ID      NVARCHAR(1000),
	  HR_COUNC        NVARCHAR(1000),
	  HR_LKUP         NVARCHAR(1000), 
	  WD_FIELD        NVARCHAR(1000),
	  DGW_FIELD       NVARCHAR(1000),
	  EXP_FIELD       NVARCHAR(1000),
	  INFO_TYPE       NVARCHAR(1000),
	  OPER_TYPE       NVARCHAR(10)
   );

   --INSERT INTO @@DGW_COUNT_CONFIG_TABLE VALUE('DGW', 'ENTITY', 'HR_FIELD', 'HR_CORE_ID', 'HR_COUNC', 'HR_LKUP', 'WD_FIELD', 'DGW_FIELD', 'INFO_TYPE', 'OPER_TYPE');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Date of Birth', 'GBDAT', '', '', '', '', 'DateofBirth', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Country of Birth', 'GBLND', '', '', '', '', 'CountryISOCode', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Region of Birth', 'GBDEP', '', '', '', '', 'RegionofBirthID', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'City of Birth', 'GBORT', '', '', '', '', 'CityofBirth', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disable Certificate Authority', 'SBDST', '', '', '', '', 'DisabCertAuCertificationAuthority', '', 'PA0004', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Last Medical Exam Valid To', 'TERMN', '', '', '', '', 'LastMedical_ExamValidTo', 'BVMRK IS NULL AND TMART=#V1#', 'PA0019', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Gender', 'GESCH', '1', '', '', 'Male', 'GenderID', '', 'PA0002', 'WID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Gender', 'GESCH', '2', '', '', 'FeMale', 'GenderID', '', 'PA0002', 'WID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disablity Grade ID', 'DISGR', 'HR_CORE_ID', 'COUNTRY2 CODE', 'BIOGRAPHICS_DISABILITYGRADE_LKUP', 'WD_VALUE', 'DisabilityGradeID', '', 'PA0004', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disablity ID', 'SBGRU', 'HR_CORE_ID', 'COUNTRY2 CODE', 'BIOGRAPHICS_DISABILITY_LKUP', 'WD_VALUE', 'DisabilityID', '', 'PA0004', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disablity Authority', 'DNSTL', 'HR_CORE_ID', 'COUNTRY2 CODE', 'BIOGRAPHICS_DISABILITYAUTHORITY_LKUP', 'WD_VALUE', 'DisabCertAuCertificationAuthority', '', 'PA0004', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disability Severity Recognization Date', 'SBADT', '', '', '', '', 'Severity_RecognitionDate', '', 'PA0004', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('BIOGRAPHICS', 'Disability Certified At', 'DSITZ', '', '', '', '', 'DisabilityCertifiedAt', '', 'PA0004', 'VID');

	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Marital Status', 'FAMST', 'HR_CORE_ID', 'COUNTRY_CODE2', 'DEMOGRAPHICS_MARITAL_STATUS_INFO', 'WD_ID', 'Marital Status', '', 'PA0002', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Ethnicity', 'RACKY', 'HR_CORE_ID', 'CC', 'DEMOGRAPHICS_ETHNICITY_LKUP', 'WD_ID', 'RACKY', '', 'INFO_TYPE_ETHNICITY', 'MID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Citizenship Status', 'NATIO', 'CITIZEN_STATUS', 'COUNTRY_CODE', 'DEMOGRAPHICS_CITIZENSHIP_INFO', 'WD_ID', 'Citizenship Status', '((ISNULL(A2.[NATIO], ##) = A1.[GEO - WORK COUNTRY] AND #@HR_CORE_ID#=#Citizen#) OR (ISNULL(A2.[NATIO], ##) <> A1.[GEO - WORK COUNTRY] AND #@HR_CORE_ID#=#Non Citizen#))', 'PA0002', 'CID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Religion', 'KONFE', 'HR_CORE_ID', 'COUNTRY_CODE', 'DEMOGRAPHICS_RELIGION_LKUP', 'WD_ID', 'Religion', '', 'PA0002', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Political Affiliation', 'PCODE', 'HR_CORE_ID', 'COUNTRY_CODE', 'DEMOGRAPHICS_POLITICAL_STATUS_LKUP', 'WD_VALUE', 'Political Affiliation', '', 'PA0529', 'LID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Nationality', 'NATIO', '', '', '', '', 'Nationality', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Additional Nationality 1', 'NATI2', '', '', '', '', 'Additional Nationality 1', '', 'PA0002', 'VID');
	INSERT INTO @DGW_COUNT_CONFIG_TABLE VALUES('DEMOGRAPHICS', 'Additional Nationality 2', 'NATI3', '', '', '', '', 'Additional Nationality 2', '', 'PA0002', 'VID');

    DECLARE @DGW             NVARCHAR(200);
    DECLARE @ENTITY          NVARCHAR(1000);
	DECLARE @HR_FIELD        NVARCHAR(1000);
	DECLARE @HR_CORE_ID      NVARCHAR(1000);
	DECLARE @HR_COUNC        NVARCHAR(1000);
	DECLARE @HR_LKUP         NVARCHAR(1000); 
	DECLARE @WD_FIELD        NVARCHAR(1000);
	DECLARE @WD_TEXT         NVARCHAR(1000);
	DECLARE @WD_VALUE        NVARCHAR(1000);
	DECLARE @EXP_FIELD       NVARCHAR(1000);
	DECLARE @DGW_FIELD       NVARCHAR(1000);
	DECLARE @INFO_TYPE       NVARCHAR(1000);
	DECLARE @OPER_TYPE       NVARCHAR(10);
	DECLARE @DGW_COUNT       INT;
	DECLARE @HR_CORE_COUNT   INT;

   DECLARE @DGW_COUNT_TABLE TABLE (
      ISO2            NVARCHAR(100),
      ENTITY          NVARCHAR(1000),
	  HR_FIELD        NVARCHAR(1000),
	  WD_TEXT         NVARCHAR(1000),
	  HR_CORE_ID      NVARCHAR(1000),
	  WD_VALUE        NVARCHAR(1000),
	  DGW_COUNT       INT,
	  DGW_FIELD       NVARCHAR(1000), 
	  HR_CORE_COUNT   INT,
	  EXP_FIELD       NVARCHAR(1000), 
	  INFO_TYPE       NVARCHAR(1000), 
	  OPER_TYPE       NVARCHAR(10)
   );
	
	DECLARE @SQL AS NVARCHAR(MAX)='drop table if exists WAVE_NM_DGW_COUNT_TABLE;
	                               drop table if exists WAVE_NM_DGW_HRCORE_WDVALUE_COUNTS;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	DECLARE cursor_item CURSOR FOR SELECT * FROM @DGW_COUNT_CONFIG_TABLE WHERE DGW=@which_report;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @DGW, @ENTITY, @HR_FIELD, @HR_CORE_ID, @HR_COUNC, @HR_LKUP, @WD_FIELD, @DGW_FIELD, @EXP_FIELD, @INFO_TYPE, @OPER_TYPE;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF (@OPER_TYPE='VID')
		BEGIN
		     INSERT INTO @DGW_COUNT_TABLE 
		     SELECT @HR_COUNC ISO2, @ENTITY ENTITY, @HR_FIELD HR_FIELD, @ENTITY+'( '+@HR_FIELD+' )' WD_TEXT, @HR_CORE_ID HR_CORE_ID, @WD_FIELD WD_VALUE, 
			        0 DGW_COUNT, @DGW_FIELD DGW_FIELD, 0 HR_COUNT, @EXP_FIELD EXP_FIELD, @INFO_TYPE INFO_TYPE, @OPER_TYPE OPER_TYPE
		END
	    IF (@OPER_TYPE='WID')
		BEGIN
		     INSERT INTO @DGW_COUNT_TABLE 
		     SELECT @HR_COUNC ISO2, @ENTITY ENTITY, @HR_FIELD HR_FIELD, @ENTITY+'( '+@HR_FIELD+' )' WD_TEXT, @HR_CORE_ID HR_CORE_ID, @WD_FIELD WD_VALUE, 
			        0 DGW_COUNT, @DGW_FIELD DGW_FIELD, 0 HR_COUNT, @EXP_FIELD EXP_FIELD, @INFO_TYPE INFO_TYPE, @OPER_TYPE OPER_TYPE
		END
	    IF (@OPER_TYPE='LID')
		BEGIN
		     SET @SQL='SELECT DISTINCT ['+@HR_COUNC+'] ISO2, '''+@ENTITY +''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@ENTITY+'( '+@HR_FIELD+' )'+''' WD_TEXT, '+@HR_CORE_ID+' HR_CORE_ID, '+
			                       @WD_FIELD+' WD_VALUE, 0 DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, 0 HR_COUNT, '''+@EXP_FIELD+''' EXP_FIELD,'''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE 
				       FROM '+@HR_LKUP+' A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.['+@HR_COUNC+']=A2.[GEO - Work Country]'
		     INSERT INTO @DGW_COUNT_TABLE EXEC(@SQL);

		END
	    IF (@OPER_TYPE='MID')
		BEGIN
		     SET @SQL='SELECT DISTINCT ['+@HR_COUNC+'] ISO2, '''+@ENTITY +''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@ENTITY+'( '+@HR_FIELD+' )'+''' WD_TEXT, '+@HR_CORE_ID+' HR_CORE_ID, '+
			                       @WD_FIELD+' WD_VALUE, 0 DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, 0 HR_COUNT, '''+@EXP_FIELD+''' EXP_FIELD,'''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE 
				       FROM '+@HR_LKUP+' A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.['+@HR_COUNC+']=A2.[GEO - Work Country]'
		     INSERT INTO @DGW_COUNT_TABLE EXEC(@SQL);

		END
	    IF (@OPER_TYPE='CID')
		BEGIN
		     SET @SQL='SELECT DISTINCT ['+@HR_COUNC+'] ISO2, '''+@ENTITY +''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@ENTITY+'( '+@HR_FIELD+' )'+''' WD_TEXT, '+@HR_CORE_ID+' HR_CORE_ID, '+
			                       @WD_FIELD+' WD_VALUE, 0 DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, 0 HR_COUNT, '''+@EXP_FIELD+''' EXP_FIELD,'''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE 
				       FROM '+@HR_LKUP+' A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.['+@HR_COUNC+']=A2.[GEO - Work Country]'
		     INSERT INTO @DGW_COUNT_TABLE EXEC(@SQL);
    	END
		FETCH NEXT FROM cursor_item INTO @DGW, @ENTITY, @HR_FIELD, @HR_CORE_ID, @HR_COUNC, @HR_LKUP, @WD_FIELD, @DGW_FIELD, @EXP_FIELD, @INFO_TYPE, @OPER_TYPE;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	/* Missing HR core ID */
	SELECT * INTO WAVE_NM_DGW_COUNT_TABLE FROM @DGW_COUNT_TABLE
	DELETE FROM @DGW_COUNT_TABLE

	DECLARE cursor_item CURSOR FOR SELECT DISTINCT * FROM WAVE_NM_DGW_COUNT_TABLE;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @HR_COUNC, @ENTITY, @HR_FIELD, @WD_TEXT, @HR_CORE_ID, @WD_VALUE, @DGW_COUNT, @DGW_FIELD, @HR_CORE_COUNT, @EXP_FIELD, @INFO_TYPE, @OPER_TYPE;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF (@OPER_TYPE='VID')
		BEGIN
			SET @SQL='SELECT DISTINCT A1.[GEO - WORK COUNTRY] ISO2, '''+@ENTITY+''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@WD_TEXT+''' WD_TEXT, '''+@HR_CORE_ID+''' HR_CORE_ID, '''+@WD_VALUE+''' WD_VALUE,
			                 (SELECT COUNT(*) FROM '+@final_table+' A2 WHERE ISNULL(['+@DGW_FIELD+'], '''') <> '''' AND A2.[Geo - Work Country]=A1.[Geo - Work Country]) DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, COUNT(*) HR_COUNT, 							 
							 '''+@EXP_FIELD+''' EXP_FIELD, '''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE
						 FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_'+@INFO_TYPE+' A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
						 WHERE ISNULL(A2.['+@HR_FIELD+'], '''') <> '''''+IIF(@EXP_FIELD='', '', 'AND '+REPLACE(@EXP_FIELD, '#', ''''))+'
						 GROUP BY A1.[GEO - WORK COUNTRY];'
		END
	    IF (@OPER_TYPE='WID')
		BEGIN
			SET @SQL='SELECT DISTINCT A1.[GEO - WORK COUNTRY] ISO2, '''+@ENTITY+''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@WD_TEXT+''' WD_TEXT, '''+@HR_CORE_ID+''' HR_CORE_ID, '''+REPLACE(@WD_VALUE,char(39),char(39)+char(39))+''' WD_VALUE,
			                 (SELECT COUNT(*) FROM '+@final_table+' A2 WHERE ISNULL(['+@DGW_FIELD+'], '''') = '''+@WD_VALUE+''' AND A2.[Geo - Work Country]=A1.[Geo - Work Country]) DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, COUNT(*) HR_COUNT, 							 
							 '''+@EXP_FIELD+''' EXP_FIELD, '''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE
						 FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_'+@INFO_TYPE+' A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
						 WHERE ISNULL(A2.['+@HR_FIELD+'], '''') = '''+@HR_CORE_ID+''''+IIF(@EXP_FIELD='', '', 'AND '+REPLACE(@EXP_FIELD, '#', ''''))+'
						 GROUP BY A1.[GEO - WORK COUNTRY];'
		END
	    IF (@OPER_TYPE='LID')
		BEGIN
			SET @SQL='SELECT DISTINCT '''+@HR_COUNC+''' ISO2, '''+@ENTITY+''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@WD_TEXT+''' WD_TEXT, '''+@HR_CORE_ID+''' HR_CORE_ID, '''+REPLACE(@WD_VALUE,char(39),char(39)+char(39))+''' WD_VALUE,
			                 (SELECT COUNT(*) FROM '+@final_table+' A2 WHERE ISNULL(['+@DGW_FIELD+'], '''') = '''+REPLACE(@WD_VALUE,char(39),char(39)+char(39))+''' AND A2.[Geo - Work Country]=A1.[Geo - Work Country]) DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, COUNT(*) HR_COUNT, 							 
							 '''+@EXP_FIELD+''' EXP_FIELD, '''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE
						 FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_'+@INFO_TYPE+' A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
						 WHERE ISNULL(A2.['+@HR_FIELD+'], '''') = '''+@HR_CORE_ID+''''+IIF(@EXP_FIELD='', '', ' AND '+REPLACE(@EXP_FIELD, '#', ''''))+' AND A1.[GEO - WORK COUNTRY]='''+@HR_COUNC+'''
						 GROUP BY A1.[GEO - WORK COUNTRY];'
		END
	    IF (@OPER_TYPE='MID')
		BEGIN
			SET @SQL='SELECT DISTINCT '''+@HR_COUNC+''' ISO2, '''+@ENTITY+''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@WD_TEXT+''' WD_TEXT, '''+@HR_CORE_ID+''' HR_CORE_ID, '''+REPLACE(@WD_VALUE,char(39),char(39)+char(39))+''' WD_VALUE,
			                 (SELECT COUNT(*) FROM WAVE_NM_'+@INFO_TYPE+' A3
							      WHERE ISNULL(['+@DGW_FIELD+'], '''') = '''+@HR_CORE_ID+''' AND A3.[CC]=A1.[Geo - Work Country]) DGW_COUNT, 
							 '''+@DGW_FIELD+''' DGW_FIELD, COUNT(*) HR_COUNT, '''+@EXP_FIELD+''' EXP_FIELD, '''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE
						 FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_'+@INFO_TYPE+' A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
						 WHERE ISNULL(A2.['+@HR_FIELD+'], '''') = '''+@HR_CORE_ID+''''+IIF(@EXP_FIELD='', '', ' AND '+REPLACE(@EXP_FIELD, '#', ''''))+' AND A1.[GEO - WORK COUNTRY]='''+@HR_COUNC+'''
						 GROUP BY A1.[GEO - WORK COUNTRY], ['+@DGW_FIELD+'];'
		END
	    IF (@OPER_TYPE='CID')
		BEGIN
			SET @SQL='SELECT DISTINCT '''+@HR_COUNC+''' ISO2, '''+@ENTITY+''' ENTITY, '''+@HR_FIELD+''' HR_FIELD, '''+@WD_TEXT+''' WD_TEXT, '''+@HR_CORE_ID+''' HR_CORE_ID, '''+@WD_VALUE+''' WD_VALUE,
			                 (SELECT COUNT(*) FROM '+@final_table+' A2 WHERE ISNULL(['+@DGW_FIELD+'], '''') = '''+@WD_VALUE+''' AND A2.[Geo - Work Country]=A1.[Geo - Work Country]) DGW_COUNT, '''+@DGW_FIELD+''' DGW_FIELD, COUNT(*) HR_COUNT, 							 
							 '''+@EXP_FIELD+''' EXP_FIELD, '''+@INFO_TYPE+''' INFO_TYPE, '''+@OPER_TYPE+''' OPER_TYPE
						 FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_'+@INFO_TYPE+' A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
						 WHERE A1.[GEO - WORK COUNTRY]='''+@HR_COUNC+''''+IIF(@EXP_FIELD='', '', ' AND '+REPLACE(REPLACE(@EXP_FIELD, '#', ''''), '@HR_CORE_ID', @HR_CORE_ID))+'
						 GROUP BY A1.[GEO - WORK COUNTRY];'
		END
		PRINT @SQL;
		INSERT INTO @DGW_COUNT_TABLE EXEC(@SQL);

	    FETCH NEXT FROM cursor_item INTO @HR_COUNC, @ENTITY, @HR_FIELD, @WD_TEXT, @HR_CORE_ID, @WD_VALUE, @DGW_COUNT, @DGW_FIELD, @HR_CORE_COUNT, @EXP_FIELD, @INFO_TYPE, @OPER_TYPE;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	--Count sheet adjustment
    UPDATE @DGW_COUNT_TABLE SET 
	    [HR_CORE_ID]='', 
		[HR_FIELD]='',
		[HR_CORE_COUNT]='0'
	WHERE HR_CORE_ID IN ('TV1', 'TV2', 'TV3')


	SELECT ISO2, HR_FIELD [HR CORE FIELD], HR_CORE_ID [HR CORE ID], ENTITY [WD TEXT], WD_VALUE [WD VALUE], 
	       HR_CORE_COUNT [HR CORE COUNT], DGW_COUNT [DGW COUNT] INTO WAVE_NM_DGW_HRCORE_WDVALUE_COUNTS FROM @DGW_COUNT_TABLE ORDER BY [WD TEXT], ISO2, [WD VALUE]
END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_COUNT_SHEET 'Biographics', '[WD_HR_TR_WorkerBiographicData]'
--SELECT * FROM WAVE_NM_DGW_HRCORE_WDVALUE_COUNTS ORDER BY ISO2, [HR CORE FIELD]
--EXEC PROC_WAVE_NM_AUTOMATE_COUNT_SHEET 'DEMOGRAPHICS', '[WD_HR_TR_AUTOMATED_DEMOGRAPHICS]'
--SELECT * FROM WAVE_NM_DGW_HRCORE_WDVALUE_COUNTS ORDER BY ISO2, [HR CORE FIELD]

--SELECT DISTINCT SBGRU FROM WAVE_NM_PA0004
--SELECT DISTINCT * FROM WAVE_NM_PA0004
--SELECT * FROM WAVE_NM_INFO_TYPE_ETHNICITY

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_BIOGRAPHICS_ERROR_LIST', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_BIOGRAPHICS_ERROR_LIST;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_BIOGRAPHICS_ERROR_LIST] 
    @which_wavestage   AS VARCHAR(50),
	@which_report      AS VARCHAR(500),
	@which_date        AS VARCHAR(50)
AS
BEGIN
	BEGIN TRY
	   
	   /***** Biographics Validation Query Starts *****/
	   EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_BIOGRAPHICS_VALIDATION;';
	   SELECT  ISNULL(Wave, '')                 [Build Number] 
	          ,ISNULL([Report Name], '')        [Report Name]
		      ,ISNULL([EmployeeID], '')         [Employee ID]
		      ,ISNULL(A2.[Country], '')         [Country Name]
		      ,ISNULL([ISO3], '')               [Country ISO3 Code]
		      ,ISNULL([wd_emp_type], '')        [Employee Type]
		      ,ISNULL([Emp - SubGroup], '')     [Employee Group]
		      ,ISNULL([Error Type], '')         [Error Type]
		      ,ISNULL([ErrorText], '')          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_BIOGRAPHICS_VALIDATION 
	   FROM (
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Gender]' [Error Type],
				  (dbo.CheckFieldScope(g.[Gender (Worker)], g.[Country2 Code], '[Gender]', [Gender], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Date Of Birth]' [Error Type],
				  (dbo.CheckFieldScope(g.[Date of Birth (Worker)], g.[Country2 Code], '[DateofBirth]', [DateofBirth], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[City Of Birth]' [Error Type],
				  (dbo.CheckFieldScope(g.[City of Birth (Worker)], g.[Country2 Code], '[CityofBirth]', [CityofBirth], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Region Of Birth]' [Error Type],
				  (dbo.CheckFieldScope(g.[Region of Birth (Worker)], g.[Country2 Code], '[RegionofBirth]', [RegionofBirth], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Country ISO Code]' [Error Type],
				  (dbo.CheckFieldScope(g.[Country of Birth (Worker)], g.[Country2 Code], '[CountryISOCode]', [CountryISOCode], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Disability Name]' [Error Type],
				  (dbo.CheckFieldScope(g.[Disability (Worker)], g.[Country2 Code], '[DisabilityName]', [DisabilityName], 'N') )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]
			UNION ALL
			SELECT DISTINCT 
			       @which_wavestage Wave,
				   @which_report [Report Name],
				   [EmployeeID],
				   g.[COUNTRY CODE] [ISO3],
				   [wd_emp_type],
				   [Emp - SubGroup],
				   '[Last Medical Exam]' [Error Type],
				  (
				     IIF((ISNULL([LastMedical_ExamDate], '')<>'' AND ISNULL([LastMedical_ExamValidTo], '')<>''), 
					      IIF((Convert(datetime, [LastMedical_ExamDate]) > Convert(datetime, [LastMedical_ExamValidTo])), 'Last Medical Exam Valid To Date must be after Last Medical Exam Date;', ''), '') +
					 IIF((ISNULL([LastMedical_ExamDate], '')='' AND ISNULL([LastMedical_ExamValidTo], '')<>''), 'Last Medical Exam Date cannot be blank if Last Medical Exam Valid To Date is populated;', '') +
					 IIF(Convert(datetime, [LastMedical_ExamDate]) > Convert(datetime, @which_date), 'Last Medical Exam Date cannot be a future date;', '')
				   )  ErrorText
			 FROM WD_HR_TR_WorkerBiographicData f 
			      LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.[CountryISOCode]=g.[COUNTRY CODE]

			) A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[ISO3]=A2.[Country Code]
		WHERE A1.ErrorText <> ''

	END TRY  
	BEGIN CATCH  
		SELECT  
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_BIOGRAPICS 'P0', 'BIOGRAPICS', '2021-03-10', 'P0_', 'P0_', 'P0' 
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] ORDER BY [EmployeeID]
--EXEC PROC_WAVE_NM_AUTOMATE_COUNT_SHEET 'Biographics', '[WD_HR_TR_WorkerBiographicData]'
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] WHERE COUNTRYISOCode='ROU' AND REGIONOFBIRTH <>'' ORDER BY [EmployeeID]
--EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_BIOGRAPHICS_ERROR_LIST] 'P0', 'Biographics', '2021-03-10'
--SELECT * FROM NOVARTIS_DATA_MIGRATION_BIOGRAPHICS_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]


-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_BIOGRAPICS', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_BIOGRAPICS;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_BIOGRAPICS]
    @which_wavestage    AS NVARCHAR(50),
	@which_report       AS NVARCHAR(500),
	@which_date         AS NVARCHAR(50),
	@PrefixCheck        AS VARCHAR(50),
	@PrefixCopy         AS VARCHAR(50),
	@Correction         AS VARCHAR(50)
AS
BEGIN
    DECLARE @DISABILITY_LKUP TABLE (
	    [COUNTRY2 CODE]      VARCHAR(50),
		[COUNTRY3 CODE]      VARCHAR(50),
		[HR_CORE_ID]         VARCHAR(50),
		[HR_CORE_TEXT]       NVARCHAR(500),
		[CREDIT_FACTOR]      VARCHAR(20), 
		[WD_VALUE]           NVARCHAR(500)
	);
	--INSERT INTO @DISABILITY_LKUP VALUES('','CHN','','Yes, Have Disability Certification', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','CHN','','No, Do Not Have Disability Certification', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','TWN','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','TWN','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','TWN','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','TWN','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','TWN','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IDN','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','THA','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','IND','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','AUS','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','NZL','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J1','Sight', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J2','Hearing', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J3','Equilibrium', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J4','Voice', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J5','Upper Limbs', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J6','Lower Limbs', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J7','Body Trunk', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J8','Cerebral Lesion Upper', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','J9','Cerebral Lesion', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JA','Heart', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JB','Kidney', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JC','Breathing', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JD','Other inside disable', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JE','Psychological', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JF',N'知的障害', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','JPN','JG',N'その他', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Disability of Brain Lesion', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Speech Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Facial Disfigurement', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Kidney Dysfunction', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Cardiac Dysfunction', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Hepatic Dysfunction', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Respiratory Dysfunction', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Intestinal / Urinary Fistula', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Epilepsy', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Intellectual Disorder', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','','Autistic Disorder', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','KOR','54','Mental Disorder', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','PHL','','Other Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','','Hearing Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','','Mobility Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','52','Physical Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','','Sensory Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','51','Visual Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','55','Multiple Disability', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','MYS','','Other Disability', '');

	--SELECt DISTINCT SBFAK FROM W4_P2_PA0004	
	--INSERT INTO @DISABILITY_LKUP VALUES('','DEU','06','Severely Disabled equivalent, count as multiple', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','DEU','03','Severely disabled employer', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','DEU','02','Severely disabled traniee', '');
	--INSERT INTO @DISABILITY_LKUP VALUES('','DEU','01','Severely disabled', 'DISABILITY_DE_Severely_disabled');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','05','Disabled or equivalent trainee (Germany)', '10', 'DISABILITY_DE_Disabled_or_equivalent_trainee');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','04','Disabled or equivalent (Germany)', '10', 'DISABILITY_DE_Disabled_or_equivalent');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','04','Severely Disabled equivalent, counts as multiple (Germany)', '20', 'DISABILITY_DE_Severely_Disabled_equivalent,_counts_as_multiple');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','05','Severely Disabled Trainee Equivalent, counts as multiple (Germany)', '20', 'DISABILITY_DE_Severely_Disabled_Trainee_Equivalent,_counts_as_multiple');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','01','Severely Disabled SB, counts as multiple (Germany)', '20', 'DISABILITY_DE_Severely_Disabled_SB,_counts_as_multiple');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','02','Severely Disabled Trainee/SB, counts as multiple (Germany)', '20', 'DISABILITY_DE_Severely_Disabled_Trainee/SB,_counts_as_multiple');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','03','Severely disabled employer (Germany)', '10', 'DISABILITY_DE_Severely_disabled_employer');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','02','Severely disabled trainee (Germany)', '10', 'DISABILITY_DE_Severely_disabled_traniee');
	INSERT INTO @DISABILITY_LKUP VALUES('','DEU','01','Severely disabled (Germany)', '10', 'DISABILITY_DE_Severely_disabled');
	INSERT INTO @DISABILITY_LKUP VALUES('','ITA','I1','Disabile', '10', 'DISABILITY_IT_Disabile');
	
	--HR Core IDs not present in the Info type 04 and those HR core ids manually created.
	INSERT INTO @DISABILITY_LKUP VALUES('','TUR','TV1','Disabile', '10', 'DISABILITY_TR_Disable');

	UPDATE b SET 
	       b.[COUNTRY2 CODE]=a.[ISO2]
	    FROM COUNTRY_LKUP a, @DISABILITY_LKUP b
		 WHERE b.[COUNTRY3 CODE]=a.[ISO3] 

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists BIOGRAPHICS_DISABILITY_LKUP;';
    SELECT * INTO BIOGRAPHICS_DISABILITY_LKUP FROM @DISABILITY_LKUP

    DECLARE @DISABILITYGRADE_LKUP TABLE (
	    [COUNTRY2 CODE]      VARCHAR(50),
		[HR_CORE_ID]         VARCHAR(50),
		[WD_TEXT]            NVARCHAR(500),
		[WD_VALUE]           NVARCHAR(500)
	);

	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J1', N'Grade 1(1 級) (Japan)', 'Disability_Grade_JP_Grade 1')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J2', N'Grade 2(2 級) (Japan)', 'Disability_Grade_JP_Grade 2')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J3', N'Grade 3(3 級) (Japan)', 'Disability_Grade_JP_Grade 3')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J4', N'Grade 4(4 級) (Japan)', 'Disability_Grade_JP_Grade 4')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J5', N'Grade 5(5 級) (Japan)', 'Disability_Grade_JP_Grade 5')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J6', N'Grade 6(6 級) (Japan)', 'Disability_Grade_JP_Grade 6')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'J7', N'Grade 7(7 級) (Japan)', 'Disability_Grade_JP_Grade 7')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'JA', N'A (Japan)', 'Disability_Grade_JP_A')
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('JP', 'JB', N'B (Japan)', 'Disability_Grade_JP_B')

	--HR Core IDs not present in the Info type 04 and those HR core ids manually created.
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('TR', 'TV1', N'DERECEDEN SAKAT/ 1 st degree disable (Turkey)', 'DISABILITY_GRADE_TR_DERECEDEN SAKAT/ 1 st degree disable') 
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('TR', 'TV2', N'DERECEDEN SAKAT/ 2nd degree disable (Turkey)', 'DISABILITY_GRADE_TR_DERECEDEN SAKAT/ 2nd degree disable') 
	INSERT INTO @DISABILITYGRADE_LKUP VALUES('TR', 'TV3', N'DERECEDEN SAKAT / 3rd degree disable (Turkey)', 'DISABILITY_GRADE_TR_DERECEDEN SAKAT / 3rd degree disable') 

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists BIOGRAPHICS_DISABILITYGRADE_LKUP;';
    SELECT * INTO BIOGRAPHICS_DISABILITYGRADE_LKUP FROM @DISABILITYGRADE_LKUP

    DECLARE @DISABILITYAUTHORITY_LKUP TABLE (
	    [COUNTRY2 CODE]      VARCHAR(50),
		[HR_CORE_ID]         VARCHAR(50),
		[WD_TEXT]            NVARCHAR(500),
		[WD_VALUE]           NVARCHAR(500)
	);

	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'AA', N'Agentur für Arbeit', 'Disability_Certification_Authority_DE_Agentur für Arbeit')
	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'AFS', N'Amt für (Familie und) Soziales', 'Disability_Certification_Authority_DE_Amt für (Familie und) Soziales')
	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'IA', N'Integrationsamt', 'Disability_Certification_Authority_DE_Integrationsamt')
	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'LVWA', N'Landesverwaltungsamt', 'Disability_Certification_Authority_DE_Landesverwaltungsamt')
	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'LRA', N'Landratsamt', 'Disability_Certification_Authority_DE_Landratsamt')
	INSERT INTO @DISABILITYAUTHORITY_LKUP VALUES('DE', 'VA', N'Versorgungsamt', 'Disability_Certification_Authority_DE_Versorgungsamt')

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists BIOGRAPHICS_DISABILITYAUTHORITY_LKUP;';
    SELECT * INTO BIOGRAPHICS_DISABILITYAUTHORITY_LKUP FROM @DISABILITYAUTHORITY_LKUP

	DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_biographic_source;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	/* Required Info type table */
	SET @SQL='drop table WAVE_NM_PA0002;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0002 FROM '+@which_wavestage+'_PA0002 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0002', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0004;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0004 FROM '+@which_wavestage+'_PA0004 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0004', @PrefixCheck, @PrefixCopy

	/* Correction to PA0004 */
	PRINT 'DISGR is not part of Info type 04. Adding this field for Disability Grade. Populating SBGRU to DISGR';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_PA0004 add DISGR NVARCHAR(255);';

    UPDATE WAVE_NM_PA0004 SET DISGR=SBGRU;
	--SELECt * FROM WAVE_NM_PA0004 WHERE PERNR IN ('47200298', '47200145', '47201531')
	INSERT INTO WAVE_NM_PA0004(MANDT, PERNR, BEGDA, ENDDA, SBGRU, DISGR, SBPRO) VALUES
	                          ('200', '47200298', @which_date, @which_date, 'TV1', 'TV1', '85'),
							  ('200', '47200145', @which_date, @which_date, 'TV1', 'TV2', '73'),
							  ('200', '47201531', @which_date, @which_date, 'TV1', 'TV3', '40')

	SET @SQL='drop table WAVE_NM_PA0077;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0077 FROM '+@which_wavestage+'_PA0077 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0077', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0019;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0019 FROM '+@which_wavestage+'_PA0019;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0019', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW
	          FROM (SELECT * 
	                  FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
			                     FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
	                  WHERE a.RNK=1) a
			  WHERE ISNULL([Emp - group], '''') <> ''4'''
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	select distinct pernr as persno,
	[emp - personnel number],
	endda as enddate,
	begda as startdate,
	GESCH as gender,
	GBDAT as birthdate,
	GBLND as countryofbirth,
	GBDEP as stateofbirth,
	GBORT as birthplace
	into WAVE_NM_biographic_source
	From [dbo].[WAVE_NM_PA0002] a
	join WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW b
	on a.pernr =b.[emp - personnel number]
	where begda<=CAST(@which_date as date)
	and endda>=CAST(@which_date as date);

	--SELECT DISTINCT PERNR, GBDEP 
	--     FROM WAVE_NM_PA0002 A1 LEFT JOIN WAVE_AM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[Emp - Personnel Number] 
	--     WHERE endda >=CAST('2021-03-10' as date)	and begda <= CAST('2021-03-10' as date) AND ISNULL(GBDEP, '')<>'' AND [geo - work country]='RO'--PERNR='04000013'
	--SELECT * FROM WAVE_NM_biographic_source A1 
	--   LEFT JOIN WAVE_AM_POSITION_MANAGEMENT A2 ON A1.PERSNO=A2.[Emp - Personnel Number] 
	--   WHERE ISNULL(stateofbirth, '') <> '' AND [geo - work country]='RO'
	--(SELECT DISTINCT f.*, b.[Country2 Code] FROM VALIDATION_LIST_BIOGRAPHICS f, COUNTRY_LKUP b WHERE f.[Country Code]=b.[Country Code]) g
	--SELECT * FROM VALIDATION_LIST_BIOGRAPHICS WHERe [Region of Birth (Worker)] <> 'Hidden'

    SET @SQL='drop table if exists WAVE_NM_biographic;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	--SELECt DISTINCT PERSNO, ISO3 FROM WAVE_NM_biographic_source  a
	--left join w2_p1_country c
	--on a.countryofbirth = c.ISO2 
	--left join HRcore_Region_Text d
	--on stateofbirth = region
	--left join WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW e
	--on e.[EMP - PERSONNEL NUMBER]=a.persno
	--left join (SELECT DISTINCT f.*, b.[Country2 Code] FROM VALIDATION_LIST_BIOGRAPHICS f, COUNTRY_LKUP b WHERE f.[Country Code]=b.[Country Code] AND [Region of Birth (Worker)] <> 'Hidden') g
	--on e.[GEO - WORK COUNTRY]=g.[COUNTRY2 CODE]
	--WHERE ISO3 IS NOT NULL AND e.[EMP - PERSONNEL NUMBER] IS NOT NULL AND REGION IS NOT NULL

	--and countryofbirth = country WHERE PERSNO='34000661' 

	PRINT 'Creating Source Data'
	select distinct a.persno,a.[emp - personnel number],birthdate,iso3 as countryofbirth,description as regionofbirth,
	cast(null as nvarchar(255)) as regionofbirthid,
	birthplace as cityofbirth,
	case when gender = '1' then 'Male' when gender = '2' then 'Female'
	else ''
	end as Gender,
	case when gender = '1' then 'Male' when gender = '2' then 'Female'
	else ''
	end as Gender_ID,
	ChallengeGroup as DisabilityGroup,
	IIF(f.[GEO - WORK COUNTRY]='JP', '', Degree) DisabilityDegree,
	TypeOfChallenge as DisabilityGroupJP,
	CertOfAuthority as CertificateOfAuthority,
	[Certificate] as DisabilityCertificate,
	[DisabilityAuthority] as DisabilityAuthority,
    CAST(ISNULL((SELECT WD_TEXT FROM @DISABILITYGRADE_LKUP WHERE [COUNTRY2 CODE]=f.[GEO - WORK COUNTRY] AND HR_CORE_ID=ISNULL(DiabilityGrade, N'999999')), N'') AS NVARCHAR(500))  [Disability_Grade],
    ISNULL((SELECT WD_VALUE FROM @DISABILITYGRADE_LKUP WHERE [COUNTRY2 CODE]=f.[GEO - WORK COUNTRY] AND HR_CORE_ID=ISNULL(DiabilityGrade, N'999999')), N'') [Disability_GradeID],
	ISNULL((SELECT HR_CORE_TEXT FROM @DISABILITY_LKUP WHERE HR_CORE_ID=IIF(f.[GEO - WORK COUNTRY]='JP', ISNULL(TypeOfChallenge, N'999999'), ISNULL(ChallengeGroup, N'999999')) AND
	                                                         [COUNTRY2 CODE]=f.[GEO - WORK COUNTRY] AND ((CREDIT_FACTOR=CreditFactor AND f.[GEO - WORK COUNTRY]='DE') OR (f.[GEO - WORK COUNTRY]<>'DE'))), N'') DisabilityText,
	ISNULL((SELECT TOP 1 WD_VALUE FROM @DISABILITY_LKUP WHERE HR_CORE_ID=IIF(f.[GEO - WORK COUNTRY]='JP', ISNULL(TypeOfChallenge, N'999999'), ISNULL(ChallengeGroup, N'999999')) AND
	                                                    [COUNTRY2 CODE]=f.[GEO - WORK COUNTRY] AND ((CREDIT_FACTOR=CreditFactor AND f.[GEO - WORK COUNTRY]='DE') OR (f.[GEO - WORK COUNTRY]<>'DE'))),'') DisabilityID,
	--IIF(ISNULL(h.DISAB, '')='X', h.DISDT, b.startdate) as disability_date,
	IIF(ISNULL(h.DISAB, '')='X', b.startdate, b.startdate) as disability_date,
	IIF(ISNULL(h.DISAB, '')='X', IIF(f.[GEO - WORK COUNTRY]='UA', 'DISABILITY_UA_Disabled', ''), '') AS disability_status,
	IIF(ISNULL(b.SBAUD, '00000000')='00000000', '00000000', b.SBAUD) AS disability_end_date,
	IIF(ISNULL(b.SBAUD, '')='', '', b.DSITZ) AS disability_certified_at,
	IIF(ISNULL(b.SBAUD, '00000000')='00000000', '00000000', b.SBADT) AS disability_severity_recognization_date
	into WAVE_NM_biographic
	--SELECT DISTINCT disability_date FROM WAVE_NM_biographic ORDER BY disability_date  where persno='04000013'
	FROM WAVE_NM_biographic_source  a
	left join WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW f
	on a.persno=f.[emp - personnel number]
	left join COUNTRY_LKUP c
	on a.countryofbirth = c.ISO2 
	left join HRcore_Region_Text d
	on stateofbirth = region
	and countryofbirth = d.country
	left join (	select distinct pernr as persno,begda as startdate,endda as enddate,CAST(SBGRU AS NVARCHAR(50)) as ChallengeGroup, SBPRO as Degree, SBDST CertOfAuthority,
	                            DNSTL DisabilityAuthority, SBAUD, DSITZ, SBADT, CAST(SBART AS NVARCHAR(50)) TypeOfChallenge, DISGR DiabilityGrade, SBFAK CreditFactor
	            From [dbo].[WAVE_NM_PA0004] Where endda >=CAST(@which_date as date)	and begda <= CAST(@which_date as date)) b
	on a.persno=b.persno
	LEFT JOIN (SELECT DISTINCT PERNR, BEGDA, DISAB, DISDT FROM [dbo].[WAVE_NM_PA0077] Where endda >=CAST(@which_date as date)	and begda <= CAST(@which_date as date)) h
	on a.persno=h.pernr
	left join (	select distinct pernr as persno, 'RQTH' as [Certificate]
	            From [dbo].[WAVE_NM_PA0004] Where endda >=CAST(@which_date as date)	and begda <= CAST(@which_date as date) AND SBGRU='F0') e
	on a.persno=e.persno;
	PRINT 'End Source Data'
	--PRINT CAST('2021-03-10' as date)

	update WAVE_NM_biographic
	set regionofbirth = replace(regionofbirth,'''','');

	update WAVE_NM_biographic  
	set regionofbirthid = (SELECT top 1 regionid FROM WAVE_REGION_WORKDAY WHERE regionofbirth=region
	and countryofbirth = countrycode3)
	where regionofbirth is not null;
	--SELECT * FROM w2_p2_region_workday WHERE 

	--/* deleted CAC data for P2..check for other builds */
	--update WAVE_NM_biographic
	--set countryofbirth = null,
	--regionofbirth = null,
	--cityofbirth = null
	--where countryofbirth in ('CRI','PAN','SLV','DOM','GTM');

	--update WAVE_NM_biographic
	--set countryofbirth = null,
	--regionofbirth = null,
	--cityofbirth = null
	--where regionofbirthid is null
	--and regionofbirth is not null;

	SELECT PERSNO FROM WAVE_NM_BIOGRAPHIC WHERE birthdate = '19000101'
	update WAVE_NM_biographic
	set birthdate = null
	where birthdate <= '19000101'

	/* Last Medical exam : Last Medical exam (DGW) -> latest value of IT 19 - TERMN when BVMRK is 2 or 1 and TMART is V1 */
	DECLARE @LAST_MEDICAL_EXAM TABLE (
	     PERNR         VARCHAR(200),
		 TERMN         VARCHAR(200)
	);

	--SELECT * FROM W4_GOLD_PA0019 WHERE PERNR='46001203'
	INSERT INTO @LAST_MEDICAL_EXAM
	SELECT PERNR, TERMN FROM (
		SELECT A2.PERNR, '20210101' TERMN, ROW_NUMBER() OVER(PARTITION BY A2.PERNR ORDER BY A2.PERNR, A2.TERMN DESC) ROW_NUM
			FROM WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW A1 JOIN WAVE_NM_PA0019 A2 ON A1.[Emp - Personnel Number]=A2.PERNR 
			WHERE BVMRK IS NULL AND TMART='V1' AND A2.TERMN >= '20210101'
	) A3 WHERE ROW_NUM=1
	SELECT * FROM @LAST_MEDICAL_EXAM
	
	/* Last Medical exam : Last Medical exam (DGW) -> latest value of IT 19 - TERMN when BVMRK is null and TMART is V1 */
	DECLARE @LAST_MEDICAL_EXAM_VALID_TO TABLE (
	     PERNR         VARCHAR(200),
		 TERMN         VARCHAR(200)
	);
	INSERT INTO @LAST_MEDICAL_EXAM_VALID_TO
	SELECT PERNR, TERMN FROM (
		SELECT A2.PERNR, A2.TERMN, ROW_NUMBER() OVER(PARTITION BY A2.PERNR ORDER BY A2.PERNR, A2.TERMN DESC) ROW_NUM
			FROM WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW A1 JOIN WAVE_NM_PA0019 A2 ON A1.[Emp - Personnel Number]=A2.PERNR 
			WHERE BVMRK IS NULL AND TMART='V1' AND A2.TERMN >= '20210101'
	) A3 WHERE ROW_NUM=1
	SELECT * FROM @LAST_MEDICAL_EXAM_VALID_TO

	/* Populate data in final table */
	SET @SQL='drop table if exists WD_HR_TR_WorkerBiographicData;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	PRINT 'Biographics Starts'
	SELECT 
	   ISNULL(c.persno_new, '') [LegacySystemID]
      ,ISNULL(c.persno_new, '') [EmployeeID]
      ,''[WorkerType]
      ,c.[Emp - Personnel Number] [ApplicantID]
      ,IIF(g.[Date of Birth (Worker)]='Hidden', '', IIF(ISNULL(birthdate, '')='', '', CONVERT(varchar(10), CAST(birthdate as date), 101))) [DateofBirth]
      ,IIF(g.[Country of Birth (Worker)]='Hidden', '', ISNULL(countryofbirth, '')) [CountryISOCode]
      ,IIF(g.[Region of Birth (Worker)]='Hidden', '', ISNULL(regionofbirth, '')) [RegionofBirth]
      ,IIF(g.[Region of Birth (Worker)]='Hidden', '', ISNULL(regionofbirthid, '')) [RegionofBirthID]
      ,IIF(g.[City of Birth (Worker)]='Hidden', '', ISNULL(cityofbirth, '')) [CityofBirth]
      ,''[DateofDeath]
      ,IIF(g.[Gender (Worker)]='Hidden', '', ISNULL(gender, '')) [Gender]
      ,IIF(g.[Gender (Worker)]='Hidden', '', ISNULL(gender, '')) [GenderID]
      ,'' [DisabilityStatus]
      ,'' [DisabilityStatus ID]
      ,IIF(g.[Disability (Worker)]='Hidden', '', ISNULL(disabilityText, '')) [DisabilityName]
      ,IIF(g.[Disability (Worker)]='Hidden', '', IIF(c.[Geo - Work Country]='UA', ISNULL(disability_status, ''), ISNULL(disabilityID, ''))) [DisabilityID]
      ,IIF(g.[Disability (Worker)]='Hidden', '', IIF(ISNULL(disability_date, '1900-01-01')='1900-01-01', '', CONVERT(varchar(10), CAST(disability_date as date), 101))) [StatusDate]
	  --,'' [StatusDate]
      ,''[DateKnown]
      ,IIF(g.[Disability (Worker)]='Hidden', '', IIF(ISNULL(disability_end_date, '00000000')='00000000', '', CONVERT(varchar(10), CAST(disability_end_date as date), 101))) [EndDate]
	  --,'' [EndDate]
      ,[Disability_Grade]  [DisabilityGrade]
      ,[Disability_GradeID] [DisabilityGradeID]
      ,ISNULL(DisabilityDegree, '') [DisabilityDegree]
      ,''[RemainingCapacity]
      ,''[DisabCertAuRefDescCertificationAuthority]
      ,''[CertificationAuthorityID]
      --,ISNULL(Replace(CAST(CertificateOfAuthority AS VARCHAR(1000)), '?', ''), 'Others') [DisabCertAuCertificationAuthority]
	  ,IIF([GEO - WORK COUNTRY]='JP', 
	          IIF(ISNULL(CertificateOfAuthority,'')<>'','Others',''), 
			  ISNULL((SELECT WD_VALUE FROM @DISABILITYAUTHORITY_LKUP WHERE [COUNTRY2 CODE]=[GEO - WORK COUNTRY] AND [HR_CORE_ID]=DisabilityAuthority), '')) [DisabCertAuCertificationAuthority] 
      ,ISNULL(disability_certified_at, '') [DisabilityCertifiedAt]
	  --Replace(Replace(CAST(CertificateOfAuthority AS VARCHAR(1000)), '?', ''), '#', '')
      ,IIF(ISNULL(CertificateOfAuthority,'')='', ISNULL(DisabilityCertificate, ''), dbo.udf_GetNumeric(CAST(CertificateOfAuthority AS VARCHAR(1000)))) [Certification_ID]
      ,''[Certification_Basis]
      ,''[Certification_BasisID]
      ,IIF(ISNULL(disability_severity_recognization_date, '00000000')<>'00000000', CAST(CONVERT(varchar(10), CAST(disability_severity_recognization_date AS Date), 101) AS VARCHAR(15)), '') [Severity_RecognitionDate]
      ,''[Disability_FTETowardQuota]
      ,''[Disability_WorkRestrictions]
      ,''[Accommodations_Requested]
      ,''[Accommodations_Provided]
      ,''[Rehabilitation_Requested]
      ,''[Rehabilitation_Provided]
      ,''[Disability_StatusNote]
      ,IIF(ISNULL(d.TERMN, '00000000')<>'00000000', CAST(CONVERT(varchar(10), CAST(d.TERMN AS Date), 101) AS VARCHAR(15)), '') [LastMedical_ExamDate]
      ,IIF(ISNULL(e.TERMN, '00000000')<>'00000000', CAST(CONVERT(varchar(10), CAST(e.TERMN AS Date), 101) AS VARCHAR(15)), '') [LastMedical_ExamValidTo]
      ,''[Medical_ExamNotes]
      ,''[Uses_Tobacco]
	  ,c.[Geo - Work Country]
	  ,c.[Emp - subgroup]
	  ,c.[wd_emp_type]
   INTO WD_HR_TR_WorkerBiographicData
   FROM WAVE_NM_biographic a
   LEFT JOIN (SELECT * FROM WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW) c ON a.[PERSNO]=c.[Emp - Personnel Number]
   LEFT JOIN @LAST_MEDICAL_EXAM d ON d.PERNR=a.[PERSNO]
   LEFT JOIN @LAST_MEDICAL_EXAM_VALID_TO e ON e.PERNR=a.[PERSNO]
   LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON c.[Geo - Work Country]=g.[Country2 Code]
   WHERE c.[Emp - Personnel Number] IS NOT NULL
   
   UPDATE WD_HR_TR_WorkerBiographicData SET [ApplicantID]=''


   --Remove Disability information for france
   UPDATE WD_HR_TR_WorkerBiographicData SET 
          [DisabilityName]='', [DisabilityID]='', [StatusDate]='', [EndDate]='', [DisabilityGrade]='', [DisabilityGradeID]='', [DisabilityDegree]='',
	      [DisabCertAuCertificationAuthority]='', [DisabilityCertifiedAt]='', [Certification_ID]='', [Severity_RecognitionDate]=''
   WHERE [Geo - Work Country]='FR';

   -- In DGW move 'Last Medical Exam Valid To Date' to 'Last Medical Exam Date' when Last Medical Exam Date is blank
   UPDATE WD_HR_TR_WorkerBiographicData SET [LastMedical_ExamDate]=[LastMedical_ExamValidTo] WHERE (ISNULL([LastMedical_ExamDate], '')='' AND 
                                                                                                    ISNULL([LastMedical_ExamValidTo], '')<>'')

   -- If Region of Birth ID is blank then Region of Birth should be empty
   UPDATE WD_HR_TR_WorkerBiographicData SET [RegionOfBirth]='' WHERE [RegionofBirthID]=''
   
   -- If Disability ID then Disability Name, Status Date and End Date should be blank
   UPDATE WD_HR_TR_WorkerBiographicData SET [DisabilityName]='', [StatusDate]='', [EndDate]='' WHERE [DisabilityID]=''

   SET @SQL='drop table if exists [WD_HR_TR_Delta_WorkerBiographicData];';
   EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

   SELECT * INTO [WD_HR_TR_Delta_WorkerBiographicData] FROM (
	   SELECT * FROM [WD_HR_TR_WorkerBiographicData]
   ) A1 ORDER BY [EmployeeID]
END

--EXEC PROC_WAVE_NM_AUTOMATE_BIOGRAPICS 'P0', 'BIOGRAPICS', '2021-03-10', 'P0_', 'P0_', 'P0' 
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] ORDER BY [EmployeeID]

--EXEC PROC_WAVE_NM_AUTOMATE_BIOGRAPICS 'W4_P2', 'BIOGRAPICS', '2020-10-02', 'W4_P2_', 'W4_P2_', 'W4_P2' 
--EXEC PROC_WAVE_NM_AUTOMATE_BIOGRAPICS 'W4_GOLD', 'BIOGRAPICS', '2021-02-14', 'W4_GOLD_', 'W4_GOLD_', 'W4_GOLD' 
--EXEC PROC_WAVE_NM_AUTOMATE_COUNT_SHEET 'Biographics', '[WD_HR_TR_WorkerBiographicData]'
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] WHERE [LastMedical_ExamDate] <> '' OR LastMedical_ExamValidTo <>'' ORDER BY [EmployeeID]
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] ORDER BY [EmployeeID]
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] WHERE [DisabilityStatus] <> '' ORDER BY [EmployeeID]

--SELECT * FROM [WD_HR_TR_Delta_WorkerBiographicData] ORDER BY [EmployeeID]
--SELECT * FROM [WD_HR_TR_WorkerBiographicData] WHERE [EmployeeID]='36000629' ORDER BY [EmployeeID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='BIOGRAPICS' ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='BIOGRAPICS' AND [Employee ID] LIKE '46%' ORDER BY [Employee ID]

--SELECT * FROM [WD_HR_TR_WorkerBiographicData] WHERE [DisabilityID]<>'' OR [DisabilityGradeID] <> '' OR [DisabCertAuCertificationAuthority] <> ''  ORDER BY [EmployeeID]
--SELECT * FROM [W3_GOLD_MALAYSIA_CORRECTIONS]

--SELECt * FROM VALIDATION_LIST_BIOGRAPHICS
--SELECT * FROM W4_P2_POSITION_MANAGEMENT
--SELECT * FROM W3_GOLD_POSITION_MANAGEMENT
--SELECT * FROM W2_GOLD_POSITION_MANAGEMENT

--SELECT * FROM WAVE_NM_biographic WHERE PERSNO='22054194' 
--SELECT * FROM WAVE_NM_biographic_source  WHERE PERSNO='22054194' 
--SELECT DISTINCT PERNR, SBGRU FROM W4_P2_PA0004 WHERE PERNR IN (SELECT [EmployeeID] FROM [WD_HR_TR_WorkerBiographicData])
--SELECT * FROM WAVE_NM_position_management
--SELECT * FROM [W3_P1_PA0002]
--SELECt [EMP - PERSONNEL NUMBER], [Emp - group] FROM W3_P2_position_management WHERE [persno_new]  IN
--(select distinct PERNR From [dbo].[W3_P2_PA0004] Where endda >=CAST('2020-06-18' as date)	and begda <= CAST('2020-06-18' as date) AND PERNR LIKE '22%' AND
--     PERNR NOT IN (SELECT [EMPLOYEEID] FROM [WD_HR_TR_WorkerBiographicData] WHERE [DisabilityID]<>'' OR [DisabilityGradeID] <> '' OR [DisabCertAuCertificationAuthority] <> ''))

SELECT DISTINCT GBDEP, A2.[Geo - Work Country] 
FROM WAVE_NM_PA0002 A1
   LEFT JOIN [WD_HR_TR_WorkerBiographicData] A2 ON A1.PERNR=A2.[EmployeeID]
WHERE [RegionofBirth] = '' AND 
      A2.[Geo - Work Country] IN (SELECT [Country2 Code]  FROM [WAVE_ALL_FIELDS_VALIDATION] WHERE [Region of Birth (Worker)]='Required') 
	  AND ISNULL(GBDEP, '') <> ''
	  AND A2.[Geo - Work Country]='RO'

--SELECT [Geo - Country (CC)], [Geo - Work Country] FROM WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW WHERE [Emp - Personnel Number] LIKE '36000629%'
--SELECT * FROM W3_GOLD_MALAYSIA_CORRECTIONS
--select distinct SBAUD, DSITZ, SBADT From [dbo].[W4_P2_PA0004] Where endda >=CAST('2020-10-02' as date) and begda <= CAST('2020-10-02' as date) --AND PERNR LIKE '12%'

--select distinct PERNR From [dbo].[W3_P2_PA0004] Where endda >=CAST('2020-06-18' as date)	and begda <= CAST('2020-06-18' as date) AND PERNR NOT LIKE '%22%' --AND
--     PERNR NOT IN (SELECT [EMPLOYEEID] FROM [WD_HR_TR_WorkerBiographicData] WHERE [DisabilityID]<>'' OR [DisabilityGradeID] <> '' OR [DisabCertAuCertificationAuthority] <> '')
