USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_RELATIVE_NAMES]    Script Date: 10/02/2020 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Subramanian.C>
-- =============================================
/****** Object:  UserDefinedFunction [dbo].[fnSplitIndex]    Script Date: 12/02/2020 09:26:44 ******/
IF OBJECT_ID('dbo.fnSplitIndex') IS NOT NULL
  DROP FUNCTION fnSplitIndex
GO

CREATE FUNCTION [dbo].[fnSplitIndex](
    @sInputList NVARCHAR(MAX) -- List of delimited items
  , @sDelimiter NVARCHAR(MAX) = ',' -- delimiter that separates items
) RETURNS @List TABLE (ind int, item NVARCHAR(MAX))

BEGIN
	DECLARE @sItem NVARCHAR(MAX);
	DECLARE @Index INT=1;

	WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
	BEGIN
		SELECT
			@sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
			@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
		IF LEN(@sItem) > 0
		BEGIN
			INSERT INTO @List SELECT @Index, @sItem;
			SET @Index=@Index+1;
		END
	END

	IF LEN(@sInputList) > 0
		INSERT INTO @List SELECT @Index, @sInputList -- Put the last item in

	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[GetSecoundaryName]    Script Date: 12/02/2020 09:26:44 ******/
IF OBJECT_ID('dbo.GetSecoundaryName') IS NOT NULL
  DROP FUNCTION GetSecoundaryName
GO

CREATE FUNCTION [dbo].[GetSecoundaryName](
    @FirstName  VARCHAR(500)
) RETURNS varchar(MAX)

BEGIN
	DECLARE @RetValue AS VARCHAR(MAX)='';
	DECLARE @Count AS INT=0;

	/****** Script to automate Service Date table  ******/
	DECLARE @VALUE_INFO TABLE(
	    VALUE_INDEX   INT,
		VALUE_SPLIT   VARCHAR(MAX)
	);
	INSERT INTO @VALUE_INFO SELECT * FROM dbo.fnSplitIndex(@FirstName, ' ');
	SELECT @Count=COUNT(*) FROM @VALUE_INFO WHERE VALUE_SPLIT IN ('DE', 'DOS', 'DA');
	IF (@Count >= 1) RETURN '';

	SET @Count=0;
	SELECT @Count=COUNT(*) FROM @VALUE_INFO;
	SELECT @RetValue=CASE 
	                    WHEN @Count=3 THEN ISNULL((SELECT VALUE_SPLIT FROM @VALUE_INFO WHERE VALUE_INDEX=3), '')
						ELSE ''
	                 END

	RETURN @RetValue;
END
GO

IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_RELATIVE_NAMES', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_RELATIVE_NAMES;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_RELATIVE_NAMES]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Worker Relative Name  ******/
	BEGIN TRY 

		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='drop table if exists WD_HR_TR_AUTOMATED_RELATIVE_NAMES;
		                               drop table if exists NOVARTIS_DATA_MIGRATION_RELATIVE_NAMES_VALIDATION';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		SET @SQL='drop table if exists WAVE_NM_PA0021;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT PERNR, FAMSA, FVRSW, FAVOR, FANAM INTO WAVE_NM_PA0021 FROM '+@which_wavestage+'_PA0021 
		              WHERE BEGDA <= CAST('''+@which_date+''' AS DATE)  AND ENDDA >= CAST('''+@which_date+''' AS DATE) AND FAMSA IN (''11'', ''12'');';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		SET @SQL='drop table if exists WAVE_NM_PA0105;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT PERNR, REPLACE([USRID_LONG], ''AN-'','''') NAME INTO WAVE_NM_PA0105 FROM '+@which_wavestage+'_PA0105 
		              WHERE SUBTY = ''9006'' AND USRID_LONG like ''AN%'';';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					 FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							   FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
				  WHERE a.RNK=1'
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	    DECLARE @RELATIVE_NAMES_INFO TABLE (
		      [Legacy System ID]            NVARCHAR(2000),
		      [Employee ID]                 NVARCHAR(2000),
			  [Worker Type]                 NVARCHAR(2000), 
			  [Applicant ID]                NVARCHAR(2000),
			  [Relative Type Id]            NVARCHAR(2000), 
			  [Relative Type]               NVARCHAR(2000), 
			  [Country ISO Code]            NVARCHAR(2000), 
			  [Prefix]                      NVARCHAR(2000), 
			  [First Name]                  NVARCHAR(2000), 
			  [Middle Name]                 NVARCHAR(2000), 
			  [Last Name]                   NVARCHAR(2000), 
			  [Secondary Name]              NVARCHAR(2000), 
			  [Suffix]                      NVARCHAR(2000) 
		);

		INSERT INTO @RELATIVE_NAMES_INFO
	    SELECT [Employee ID] AS [Legacy System ID], * FROM ( 
			SELECT a.[Emp - Personnel Number] [Employee ID]
				  ,a.wd_emp_type [Worker Type]
				  ,'' [Applicant ID]
				  ,(CASE 
				      WHEN a.[Geo - Work Country]='BR' THEN IIF(b.FAMSA='11', 'Relative_Type_BR_Father', 'Relative_Type_BR_Mother') 
					  WHEN a.[Geo - Work Country]='HU' THEN 'Relative_Type_HU_Mother Maiden'
					  ELSE ''
				   END) [Relative Type Id]				  
				  ,(CASE 
				      WHEN a.[Geo - Work Country]='BR' THEN IIF(b.FAMSA='11', 'Relative_Type_BR_Father', 'Relative_Type_BR_Mother') 
					  WHEN a.[Geo - Work Country]='HU' THEN 'Relative_Type_HU_Mother Maiden'
					  ELSE ''
				   END) [Relative Type]				  
				  ,ISNULL((SELECT TOP 1 [Country Code] FROM [WAVE_ALL_FIELDS_VALIDATION] WHERE [Country2 Code] = a.[Geo - Work Country]), '') [Country ISO Code]
				  ,(CASE 
				      WHEN a.[Geo - Work Country]='BR' THEN ISNULL(b.FVRSW, '')
					  WHEN a.[Geo - Work Country]='HU' THEN ''
					  ELSE ''
				   END) [Prefix]
				  ,dbo.SetCamelCaseCharacter(
					  LTRIM(RTRIM((CASE 
						  WHEN a.[Geo - Work Country]='BR' THEN ISNULL(b.FAVOR, '')
						  WHEN a.[Geo - Work Country]='HU' THEN ISNULL(SUBSTRING(c.[NAME],1,CHARINDEX(' ',c.[NAME])), '')
						  ELSE ISNULL(SUBSTRING(c.[NAME],1,CHARINDEX(' ',c.[NAME])), '')
					   END)))
				   ) [First Name]
				  ,'' [Middle Name]
				  ,dbo.SetCamelCaseCharacter(
					  LTRIM(RTRIM((CASE 
						  WHEN a.[Geo - Work Country]='BR' THEN ISNULL(b.FANAM, '')
						  WHEN a.[Geo - Work Country]='HU' THEN ISNULL(SUBSTRING(c.[NAME],CHARINDEX(' ',c.[NAME]), LEN([NAME])), '')
						  ELSE ISNULL(SUBSTRING(c.[NAME],CHARINDEX(' ',c.[NAME]), LEN([NAME])), '')
					   END)))
				   ) [Last Name]
				  ,dbo.SetCamelCaseCharacter(
					  (CASE 
						  WHEN a.[Geo - Work Country]='BR' THEN IIF(b.FAMSA='12', dbo.GetSecoundaryName(ISNULL(a.[Emp - First Name], '')), '')
						  WHEN a.[Geo - Work Country]='HU' THEN ''
						  ELSE ''
					   END)
				   ) [Secondary Name]  
				  ,'' [Suffix] 
			  FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] a
			      LEFT JOIN WAVE_NM_PA0021 b ON a.[Emp - Personnel Number]=b.PERNR
				  LEFT JOIN WAVE_NM_PA0105 c ON a.[Emp - Personnel Number]=c.PERNR
			  WHERE a.[Geo - Work Country] IN (SELECT [Country2 Code] FROM [WAVE_ALL_FIELDS_VALIDATION] WHERE [Relatives' Names (Worker)] <> 'Hidden')
		) a
		SELECT * FROM @RELATIVE_NAMES_INFO

		/***** Relative Names Validation Query Starts *****/
	    SELECT * INTO NOVARTIS_DATA_MIGRATION_RELATIVE_NAMES_VALIDATION FROM (
			SELECT @which_wavestage              [Build Number]
		          ,@which_report                 [Report Name]
				  ,[Employee ID]                 [Employee ID]
				  ,[Countries]                   [Country Name]
				  ,[Country ISO Code]            [Country ISO3 Code]
				  ,[WD_EMP_TYPE]                 [Employee Type]
		          ,[Emp - Group]                 [Employee Group]
				  ,'Employee Name'               [Error Type]
				  ,(IIF(ISNULL([First Name], '')='', 'First Name is required;', '')+ 
					IIF(ISNULL([Last Name], '')='', 'Last Name is required;', '')) ErrorText
			FROM @RELATIVE_NAMES_INFO A1
			        LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[Employee ID]=A2.[emp - personnel number]
					LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] A3 ON A1.[Country ISO Code]=A3.[Country Code]
			WHERE [Country ISO Code] IN (SELECT [Country Code] FROM [WAVE_ALL_FIELDS_VALIDATION] WHERE [Relatives' Names (Worker)] = 'Required')) c WHERE ErrorText <> '';

		/***** Relative Names Automtion Query *****/
		/* First Name and Last Name correction*/
		UPDATE @RELATIVE_NAMES_INFO SET 
		    [Relative Type Id]=''
		   ,[Relative Type]=''
		   ,[Country ISO Code]=''
		WHERE [First Name]='' AND [Last Name]=''

		SELECT * INTO WD_HR_TR_AUTOMATED_RELATIVE_NAMES FROM @RELATIVE_NAMES_INFO

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
--EXEC PROC_WAVE_NM_AUTOMATE_RELATIVE_NAMES 'P0', 'Relative Names', '2021-03-10'
--SELECT * FROM WD_HR_TR_AUTOMATED_RELATIVE_NAMES ORDER BY [Employee ID]
--SELECT * FROM [NOVARTIS_DATA_MIGRATION_RELATIVE_NAMES_VALIDATION] ORDER BY [Employee ID]
--SELECT * FROM [W2_VALIDATION_CHECK_LIST] WHERE [Relatives' Names (Worker)] <> 'Hidden'
--INSERT INTO [W2_VALIDATION_CHECK_LIST]([Country Code], [ISO2 Code], [Relatives' Names (Worker)]) VALUES('HUN', 'HU', 'Required')
--SELECT * FROM WAVE_NM_PA0105
--SELECT [Geo - Work Country] FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] WHERE [Emp - Personnel Number] like '21%';
--SELECT PERNR, CNAME FROM W4_P2_PA0002 WHERe CNAME IS NOT NULL