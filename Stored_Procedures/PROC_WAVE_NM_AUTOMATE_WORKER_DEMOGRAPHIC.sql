USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC]    Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:<Subramanian.C>
-- =============================================
/* If the function('dbo.CreateWorkDayValue') already exist */
IF OBJECT_ID('dbo.CreateWorkDayValue') IS NOT NULL
  DROP FUNCTION CreateWorkDayValue
GO
CREATE FUNCTION CreateWorkDayValue (
    @HR_CORE_VALUE   AS VARCHAR(300),
	@COUNTRY_CODE    AS VARCHAR(30),
	@WD_TYPE         AS VARCHAR(100)
)
RETURNS varchar(500)  
BEGIN  
    --DECLARE @COUNTRY3_CODE AS VARCHAR(20)='';
	--SELECT @COUNTRY3_CODE=[Country Code] FROM W4_COUNTRY_LKUP WHERE [Country2 Code]=@COUNTRY_CODE
    DECLARE @result AS VARCHAR(500)=@WD_TYPE+'_'+@COUNTRY_CODE+'_'+REPLACE(@HR_CORE_VALUE, ' ', '_');
	RETURN @result;
END
GO

/* If the function('dbo.CheckUSAEthinicity') already exist */
IF OBJECT_ID('dbo.CheckUSAEthinicity') IS NOT NULL
  DROP FUNCTION CheckUSAEthinicity
GO
CREATE FUNCTION CheckUSAEthinicity (
   @HRC   AS VARCHAR(30),
   @RAC1  AS VARCHAR(30),
   @RAC2  AS VARCHAR(30),
   @RAC3  AS VARCHAR(30),
   @RAC4  AS VARCHAR(30),
   @RAC5  AS VARCHAR(30),
   @RAC6  AS VARCHAR(30),
   @RAC7  AS VARCHAR(30),
   @RAC8  AS VARCHAR(30),
   @RAC9  AS VARCHAR(30),
   @RAC10  AS VARCHAR(30)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	IF (ISNULL(@RAC1, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC2, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC3, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC4, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC5, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC6, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC7, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC8, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC9, '') = @HRC) SET @result=@HRC;
	IF (ISNULL(@RAC10, '') = @HRC) SET @result=@HRC;

    RETURN (@result)  
END
GO

/* If the function('dbo.CheckVetrenStatus') already exist */
IF OBJECT_ID('dbo.CheckVetrenStatus') IS NOT NULL
  DROP FUNCTION CheckVetrenStatus
GO
CREATE FUNCTION CheckVetrenStatus (
   @VETS1  AS VARCHAR(30),
   @VETS2  AS VARCHAR(30),
   @VETS3  AS VARCHAR(30),
   @VETS4  AS VARCHAR(30),
   @VETS5  AS VARCHAR(30),
   @VETS6  AS VARCHAR(30),
   @VETS7  AS VARCHAR(30),
   @VETS8  AS VARCHAR(30),
   @VETS9  AS VARCHAR(30),
   @VETS10  AS VARCHAR(30),
   @VETS11  AS VARCHAR(30),
   @VETS12  AS VARCHAR(30),
   @YYVETS01  AS VARCHAR(30)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @Count AS INT = 0;
    DECLARE @result AS VARCHAR(500)='';
	IF (ISNULL(@VETS1, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS2, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS3, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS4, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS5, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS6, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS7, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS8, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS9, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS10, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS11, '') <> '') SET @Count = @Count + 1;
	IF (ISNULL(@VETS12, '') <> '') SET @Count = @Count + 1;

	IF (@Count >= 2)
		SET @result='Contains values in more than one field;';
   
    RETURN (@result)  
END
GO

IF OBJECT_ID('dbo.ArrangeVetrenStatus') IS NOT NULL
  DROP FUNCTION ArrangeVetrenStatus
GO

CREATE FUNCTION [dbo].[ArrangeVetrenStatus](
   @VETS1     AS VARCHAR(30),
   @VETS2     AS VARCHAR(30),
   @VETS3     AS VARCHAR(30),
   @VETS4     AS VARCHAR(30),
   @VETS5     AS VARCHAR(30),
   @VETS6     AS VARCHAR(30),
   @VETS7     AS VARCHAR(30),
   @VETS8     AS VARCHAR(30),
   @VETS9     AS VARCHAR(30),
   @VETS10    AS VARCHAR(30),
   @VETS11    AS VARCHAR(30),
   @VETS12    AS VARCHAR(30),
   @YYVETS01  AS VARCHAR(30),
   @VETS      AS VARCHAR(30),
   @Status    AS VARCHAR(30)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @KeepValues AS VARCHAR(500) = '';
	DECLARE @Index AS INT = 1;

	IF ((ISNULL(@VETS1, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS1, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS1;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS2, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS2, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS2;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS3, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS3, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS3;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS4, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS4, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS4;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS5, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS5, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS5;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS6, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS6, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS6;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS7, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS7, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS7;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS8, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS8, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS8;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS9, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS9, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS9;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS10, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS10, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS10;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS11, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS11, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS11;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@VETS12, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@VETS12, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @VETS12;
		SET @Index = @Index + 1;
	END
	IF ((ISNULL(@YYVETS01, '') IN ('V1', 'V8', 'VA', 'V9') AND @Status='ID') OR (ISNULL(@YYVETS01, '') IN ('V4', 'V5', 'V6', 'V7') AND @Status='TYPE'))
	BEGIN
	    IF (@Index = @VETS) SET @KeepValues = @YYVETS01;
		SET @Index = @Index + 1;
	END

    RETURN @KeepValues;
END
GO

IF OBJECT_ID('dbo.ArrangeRaceValue') IS NOT NULL
  DROP FUNCTION ArrangeRaceValue
GO

CREATE FUNCTION [dbo].[ArrangeRaceValue](
   @RAC1   AS VARCHAR(30),
   @RAC2   AS VARCHAR(30),
   @RAC3   AS VARCHAR(30),
   @RAC4   AS VARCHAR(30),
   @RAC5   AS VARCHAR(30),
   @RAC6   AS VARCHAR(30),
   @RAC7   AS VARCHAR(30),
   @RAC8   AS VARCHAR(30),
   @RAC9   AS VARCHAR(30),
   @RAC10  AS VARCHAR(30),
   @RAC    AS int
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @KeepValues AS VARCHAR(500) = '';
	DECLARE @Index AS INT = 1;

	IF (@RAC1 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC1;
		SET @Index = @Index + 1;
	END
	IF (@RAC2 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC2;
		SET @Index = @Index + 1;
	END
	IF (@RAC3 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC3;
		SET @Index = @Index + 1;
	END
	IF (@RAC4 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC4;
		SET @Index = @Index + 1;
	END
	IF (@RAC5 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC5;
		SET @Index = @Index + 1;
	END
	IF (@RAC6 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC6;
		SET @Index = @Index + 1;
	END
	IF (@RAC7 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC7;
		SET @Index = @Index + 1;
	END
	IF (@RAC8 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC8;
		SET @Index = @Index + 1;
	END
	IF (@RAC9 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC9;
		SET @Index = @Index + 1;
	END
	IF (@RAC10 <> '')
	BEGIN
	    IF (@Index = @RAC) SET @KeepValues = @RAC10;
		SET @Index = @Index + 1;
	END

    RETURN @KeepValues;
END
GO

/* If the function('dbo.GetHideCountries') already exist */
IF OBJECT_ID('dbo.GetHideCountries') IS NOT NULL
  DROP FUNCTION GetHideCountries
GO
CREATE FUNCTION GetHideCountries (
   @COUNTRY               AS VARCHAR(100)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
    IF (ISNULL((SELECT [Country] FROM HIDE_COUNTRY_INFO WHERE [Country2 Code]=@COUNTRY), '') <> '') SET @result='Hide';
    RETURN (@result)  
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC_ERROR_LIST', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC_ERROR_LIST;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC_ERROR_LIST] 
    @which_wavestage   AS VARCHAR(50),
	@which_report      AS VARCHAR(500)
AS
BEGIN
	BEGIN TRY
		/***** Demographic Validation Query Starts *****/
	   EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_DEMOGRAPHICS_VALIDATION;';
	   SELECT  'P0'                 [Build Number] 
	          ,'Demographic'        [Report Name]
		      ,[Employee ID]        [Employee ID]
		      ,A2.[Country]         [Country Name]
		      ,[ISO3]               [Country ISO3 Code]
		      ,[Worker Type]        [Employee Type]
		      ,[Emp - SubGroup]     [Employee Group]
		      ,[Error Type]         [Error Type]
		      ,[ErrorText]          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_DEMOGRAPHICS_VALIDATION 
	   FROM (
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[US Protected Veteran Status]' [Error Type],
				  (IIF(((ISNULL([Military Discharge Dt 1], '00000000')='00000000' OR ISNULL([Military Discharge Dt 1], '')='') AND 
							  [US Protected Veteran Status Type 01]='RECENTLY_SEPARATED_VETERAN'),'Discharge Date only valid for recently separated veterans(Veteran status type);','') +
				   IIF((ISNULL([US Protected Veteran Status Type 01], '') <> '' AND ISNULL([US Veteran Status 01], '')=''),'US Veteran Status(01) is required if US Protected Veteran Status Type is populated;','') +
				   IIF((ISNULL([US Protected Veteran Status Type 02], '') <> '' AND ISNULL([US Veteran Status 02], '')=''),'US Veteran Status(02) is required if US Protected Veteran Status Type is populated;','') +
				   IIF((ISNULL([US Protected Veteran Status Type 03], '') <> '' AND ISNULL([US Veteran Status 03], '')=''),'US Veteran Status(03) is required if US Protected Veteran Status Type is populated;','') +
				   IIF((ISNULL([US Protected Veteran Status Type 04], '') <> '' AND ISNULL([US Veteran Status 04], '')=''),'US Veteran Status(04) is required if US Protected Veteran Status Type is populated;','') +
				   IIF((ISNULL([US Protected Veteran Status Type 05], '') <> '' AND ISNULL([US Veteran Status 05], '')=''),'US Veteran Status(05) is required if US Protected Veteran Status Type is populated;','') 
			  )  ErrorText
			  FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Additional Nationality 2]' [Error Type],
				  (dbo.CheckFieldScope(g.[Additional Nationalities (Worker)], ISO3, '[Additional Nationality 2]', [Additional Nationality 2], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Additional Nationality 1]' [Error Type],
				  (dbo.CheckFieldScope(g.[Additional Nationalities (Worker)], ISO3, '[Additional Nationality 1]', [Additional Nationality 1], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Political Affiliation]' [Error Type],
				  (dbo.CheckFieldScope(g.[Political Affiliation (Worker)], ISO3, '[Political Affiliation]', [Political Affiliation], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Religion]' [Error Type],
				  (dbo.CheckFieldScope(g.[Religion (Worker)], ISO3, '[Religion]', [Religion], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Military Service]' [Error Type],
				  (dbo.CheckFieldScope(g.[Military Service (Worker)], ISO3, '[Military Service]', [Military Service], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Citizenship Status]' [Error Type],
				  (dbo.CheckFieldScope(g.[Citizenship Status (Worker)], ISO3, '[Citizenship Status]', [Citizenship Status], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Nationality]' [Error Type],
				  (dbo.CheckFieldScope(g.[Primary Nationality (Worker)], ISO3, '[Nationality]', [Nationality], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Hispanic or Latino]' [Error Type],
				  (dbo.CheckFieldScope(g.[Hispanic/Latino (Worker)], ISO3, '[Hispanic or Latino]', [Hispanic or Latino], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Ethnicity Id]' [Error Type],
				  (dbo.CheckFieldScope(g.[Race/Ethnicity (Worker)], ISO3, '[Ethnicity Id]', [Ethnicity Id 01], 'N') )  ErrorText
			   FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
				UNION ALL
			SELECT DISTINCT @which_wavestage Wave,
				   @which_report [Report Name],
				   [Employee ID],
				   [ISO3],
				   [Worker Type],
				   [Emp - SubGroup],
				   '[Marital Status]' [Error Type],
				  (dbo.CheckFieldScope(g.[Marital Status (Worker)], ISO3, '[Marital Status]', [Marital Status], 'N')  )  ErrorText
			 FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET f 
			       LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON f.ISO3=g.[COUNTRY CODE]
			) A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[ISO3]=A2.[Country Code]
		WHERE A1.ErrorText <> ''
		--SELECT * FROM VALIDATION_LIST_DEMOGRAPHICS WHERE [Country Code]='OM'
		--SELECT * FROM [WAVE_ALL_FIELDS_VALIDATION] WHERE [Country Code]='BGD'
		--SELECT * FROM @DEMOGRAPHICS_INFO WHERE [Employee ID]='14904616'
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
--EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC_ERROR_LIST] 'P0', '2021-03-10'
--SELECT * FROM NOVARTIS_DATA_MIGRATION_DEMOGRAPHICS_VALIDATION ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET WHERE PERNR='10004286'

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC] 
    @which_wavestage   AS VARCHAR(50),
	@which_report      AS VARCHAR(500),
	@which_date        AS VARCHAR(50),
	@PrefixCheck       AS VARCHAR(50),
	@PrefixCopy        AS VARCHAR(50),
	@Correction        AS VARCHAR(50)
AS
BEGIN
	BEGIN TRY
	
		DECLARE @ETHINICITY_INFO TABLE(
		COUNTRY_CODE2 VARCHAR(10),
		COUNTRY_CODE3 VARCHAR(10),
		HR_CORE_ID    VARCHAR(500),
		WD_VALUE VARCHAR(500),
		WD_ID VARCHAR(500)
		);

		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','White - Other European (United Kingdom)','Ethnicity_UK_White_Other_European');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Asian - Indian (United Kingdom)','Ethnicity_UK_Asian_Indian');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Mixed - White & Black African (United Kingdom)','Ethnicity_UK_Mixed_White_&_Black_African');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Black - British (United Kingdom)','Ethnicity_UK_Black_British');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Mixed - Other (United Kingdom)','Ethnicity_UK_Mixed_Other');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Other (United Kingdom)','Ethnicity_UK_Other');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Not Declaring (United Kingdom)','Ethnicity_UK_Not_Declaring');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Mixed - White & Asian (United Kingdom)','Ethnicity_UK_Mixed_White_&_Asian');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Asian - Bangladeshi (United Kingdom)','Ethnicity_UK_Asian_Bangladeshi');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Black - Other (United Kingdom)','Ethnicity_UK_Black_Other');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Black - African (United Kingdom)','Ethnicity_UK_Black_African');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Asian - Pakistani (United Kingdom)','Ethnicity_UK_Asian_Pakistani');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Mixed - White & Black Caribbean (United Kingdom)','Ethnicity_UK_Mixed_White_&_Black_Caribbean');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Asian - Chinese (United Kingdom)','Ethnicity_UK_Asian_Chinese');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','White - British (United Kingdom)','Ethnicity_UK_White_British');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Asian - Other (United Kingdom)','Ethnicity_UK_Asian_Other');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','White - Other (United Kingdom)','Ethnicity_UK_White_Other');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','White - Irish (United Kingdom)','Ethnicity_UK_White_Irish');
		INSERT INTO @ETHINICITY_INFO VALUES('UK', 'GBR', '99','Black - Caribbean (United Kingdom)','Ethnicity_UK_Black_Caribbean');
		INSERT INTO @ETHINICITY_INFO VALUES('US', 'USA', 'R1','American Indian or Alaskan Native (United States of America)','Ethnicity_US_American_Indian_or_Alaskan_Native');
		INSERT INTO @ETHINICITY_INFO VALUES('US', 'USA', 'R2','Asian (United States of America)','Ethnicity_US_Asian');
		INSERT INTO @ETHINICITY_INFO VALUES('US', 'USA', 'R3','Black or African American (United States of America)','Ethnicity_US_Black_or_African_American');
		INSERT INTO @ETHINICITY_INFO VALUES('US', 'USA', 'R4','Native Hawaiian or Other Pacific Islander (United States of America)','Ethnicity_US_Native Hawaiian_or_Other_Pacific_Islander');
		INSERT INTO @ETHINICITY_INFO VALUES('US', 'USA', 'R5','White (United States of America)','Ethnicity_US_White');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '0','Indigena/Indigenous (Brazil)','Ethnicity_BR_Indigena_Indigenous');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '2','Branca/Caucasian (Brazil)','Ethnicity_BR_Branca_Caucasian');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '4','Preta/Black (Brazil)','Ethnicity_BR_Preta_Black');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '6','Amarela/Yellow (Brazil)','Ethnicity_BR_Amarela_Yellow');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '8','Pardo/Mulato (Brazil)','Ethnicity_BR_Pardo_Mulato');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '9','Não Informado/Not Informed (Brazil)','Ethnicity_BR_Não_Informado_Not_Informed');
		INSERT INTO @ETHINICITY_INFO VALUES('BR', 'BRA', '99','Outros/Others (Brazil)','Ethnicity_BR_Outros_Others');

		INSERT INTO @ETHINICITY_INFO VALUES('MY', 'MYS', 'Others','Others','Ethnicity_MY_Others');
		INSERT INTO @ETHINICITY_INFO VALUES('MY', 'MYS', 'Other Indigenous','Other Indigenous','Ethnicity_MY_Other_Indigenous');
		INSERT INTO @ETHINICITY_INFO VALUES('MY', 'MYS', 'Malay','Malay','Ethnicity_MY_Malay');
		INSERT INTO @ETHINICITY_INFO VALUES('MY', 'MYS', 'Indian','Indian','Ethnicity_MY_Indian');

        DECLARE @ETHNICITY_LKUP TABLE(
		    CC               NVARCHAR(10),
			HR_CORE_ID       NVARCHAR(10),
			HR_CORE_TEXT     NVARCHAR(500),
			WD_ID            NVARCHAR(500)
		);

		INSERT INTO @ETHNICITY_LKUP VALUES('US', 'R1','American Indian or Alaskan Native (United States of America)','Ethnicity_US_American_Indian_or_Alaskan_Native');
		INSERT INTO @ETHNICITY_LKUP VALUES('US', 'R2','Asian (United States of America)','Ethnicity_US_Asian');
		INSERT INTO @ETHNICITY_LKUP VALUES('US', 'R3','Black or African American (United States of America)','Ethnicity_US_Black_or_African_American');
		INSERT INTO @ETHNICITY_LKUP VALUES('US', 'R4','Native Hawaiian or Other Pacific Islander (United States of America)','Ethnicity_US_Native Hawaiian_or_Other_Pacific_Islander');
		INSERT INTO @ETHNICITY_LKUP VALUES('US', 'R5','White (United States of America)','Ethnicity_US_White');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '0','Indigena/Indigenous (Brazil)','Ethnicity_BR_Indigena_Indigenous');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '2','Branca/Caucasian (Brazil)','Ethnicity_BR_Branca_Caucasian');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '4','Preta/Black (Brazil)','Ethnicity_BR_Preta_Black');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '6','Amarela/Yellow (Brazil)','Ethnicity_BR_Amarela_Yellow');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '8','Pardo/Mulato (Brazil)','Ethnicity_BR_Pardo_Mulato');
		INSERT INTO @ETHNICITY_LKUP VALUES('BR', '9','Não Informado/Not Informed (Brazil)','Ethnicity_BR_Não_Informado_Not_Informed');

		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'AC','Achang ethnic group','Ethnicity_CN_Achang');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'BA','Bai ethnic group','Ethnicity_CN_Bai');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'BL','Blang ethnic group','Ethnicity_CN_Blang');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'BN','Bonan ethnic group','Ethnicity_CN_Bonan');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'BY','Bouyei ethnic group','Ethnicity_CN_Buyei');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DA','Dai ethnic group','Ethnicity_CN_Dai');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DU','Daur ethnic group','Ethnicity_CN_Daur');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DE','Deang ethnic group','Ethnicity_CN_De''ang');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DO','Dong ethnic group','Ethnicity_CN_Dong');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DX','Dongxiang ethnic group','Ethnicity_CN_Dongxiang');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'DR','Drung ethnic group','Ethnicity_CN_Derung');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'EW','Ewenki ethnic group','Ethnicity_CN_Ewenki');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'GS','Gaoshan ethnic group','Ethnicity_CN_Gaoshan');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'GL','Gelao ethnic group','Ethnicity_CN_Gelao');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'HA','Han ethnic group','Ethnicity_CN_Han');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'HZ','Hezhen ethnic group','Ethnicity_CN_Hezhen');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'HU','Hui ethnic group','Ethnicity_CN_Hui');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'GI','Jing ethnic group','Ethnicity_CN_Jing');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'JP','Jingpo ethnic group','Ethnicity_CN_Jingpo');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'JN','Jino ethnic group','Ethnicity_CN_Jino');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'KZ','Kazak ethnic group','Ethnicity_CN_Kazakh');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'KG','Kirgiz ethnic group','Ethnicity_CN_Kyrgyz');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'CS','Korean ethnic group','Ethnicity_CN_Korean');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'LH','Lahu ethnic group','Ethnicity_CN_Lahu');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'LB','Lhoba ethnic group','Ethnicity_CN_Lhoba');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'LI ','Li ethnic group','Ethnicity_CN_Li');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'LS','Lisu ethnic group','Ethnicity_CN_Lisu');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'MA','Manchu ethnic group','Ethnicity_CN_Manchu');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'MN','Maonan ethnic group','Ethnicity_CN_Maonan');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'MG','Mengol ethnic group','Ethnicity_CN_Mongols');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'MH','Miao ethnic group','Ethnicity_CN_Miao');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'MB','Moinba ethnic group','Ethnicity_CN_Monba');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'ML','Mulam ethnic group','Ethnicity_CN_Mulao');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'NX','Naxi ethnic group','Ethnicity_CN_Nakhi');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'NU','Nu ethnic group','Ethnicity_CN_Nu');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'OR','Oroqen ethnic group','Ethnicity_CN_Oroqen');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'UZ','Ozbek ethnic group','Ethnicity_CN_Uzbek');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'PM','Pumi ethnic group','Ethnicity_CN_Pumi');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'QI','Qiang ethnic group','Ethnicity_CN_Qiang');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'RS','Russian ethnic group','Ethnicity_CN_Russian');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'SL','Salar ethnic group','Ethnicity_CN_Salar');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'SH','She ethnic group','Ethnicity_CN_She');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'SU','Shui ethnic group','Ethnicity_CN_Sui');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'TA','Tajik ethnic group','Ethnicity_CN_Tajik');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'TT','Tatar ethnic group','Ethnicity_CN_Tatars');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'ZA','Tibetan ethnic group','Ethnicity_CN_Tibetan');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'TU','Tu ethnic group','Ethnicity_CN_Tu');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'TJ','Tujia ethnic group','Ethnicity_CN_Tujia');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'UG','Uygur ethnic group','Ethnicity_CN_Uyghurs');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'VA','Va ethnic group','Ethnicity_CN_Va');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'XB','Xibe ethnic group','Ethnicity_CN_Xibe');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'YA','Yao ethnic group','Ethnicity_CN_Yao');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'YI ','Yi ethnic group','Ethnicity_CN_Yi');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'YG','Yugur ethnic group','Ethnicity_CN_Yugur');
		INSERT INTO @ETHNICITY_LKUP VALUES('CN', 'ZH','Zhuang ethnic group','Ethnicity_CN_Zhuang');

		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '01','Malay','Ethnicity_MY_Malay');
		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '02','Chinese','Ethnicity_MY_Chinese');
		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '03','Indian','Ethnicity_MY_Indian');
		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '04','Eurasian','Ethnicity_MY_Eurasia');
		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '05','Others','Ethnicity_MY_Others');
		INSERT INTO @ETHNICITY_LKUP VALUES('MY', '06','Other Indigenous','Ethnicity_MY_Other_Indigenous');

		INSERT INTO @ETHNICITY_LKUP VALUES('SG', '01','Malay','Ethnicity_SG_Malay');
		INSERT INTO @ETHNICITY_LKUP VALUES('SG', '02','Chinese','Ethnicity_SG_Chinese');
		INSERT INTO @ETHNICITY_LKUP VALUES('SG', '03','Indian','Ethnicity_SG_Indian');
		INSERT INTO @ETHNICITY_LKUP VALUES('SG', '04','Eurasian','Ethnicity_SG_Eurasia');
		INSERT INTO @ETHNICITY_LKUP VALUES('SG', '05','Others','Ethnicity_SG_Others');

		--INSERT INTO @ETHNICITY_LKUP VALUES('','Indigenous (Taiwan)','Ethnicity_TW_Indigenous');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Non-indigenous (Taiwan)','Ethnicity_TW_Non-indigenous');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kinh (Vietnam)','Ethnicity_VN_Kinh');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Tày (Vietnam)','Ethnicity_VN_Tày');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Thái (Vietnam)','Ethnicity_VN_Thái');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Hoa (Vietnam)','Ethnicity_VN_Hoa');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Khơ-me (Vietnam)','Ethnicity_VN_Khơ-me');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Mường (Vietnam)','Ethnicity_VN_Mường');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Nùng (Vietnam)','Ethnicity_VN_Nùng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Hmông (Vietnam)','Ethnicity_VN_Hmông');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Dao (Vietnam)','Ethnicity_VN_Dao');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Gia-rai (Vietnam)','Ethnicity_VN_Gia-rai');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ngái (Vietnam)','Ethnicity_VN_Ngái');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ê-đê (Vietnam)','Ethnicity_VN_Ê-đê');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ba-na (Vietnam)','Ethnicity_VN_Ba-na');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Xơ-đăng (Vietnam)','Ethnicity_VN_Xơ-đăng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','SánChay (Vietnam)','Ethnicity_VN_SánChay');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Cơ-ho (Vietnam)','Ethnicity_VN_Cơ-ho');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chăm (Vietnam)','Ethnicity_VN_Chăm');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','SánDìu (Vietnam)','Ethnicity_VN_SánDìu');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Hrê (Vietnam)','Ethnicity_VN_Hrê');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Mnông (Vietnam)','Ethnicity_VN_Mnông');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ra-glai (Vietnam)','Ethnicity_VN_Ra-glai');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Xtiêng (Vietnam)','Ethnicity_VN_Xtiêng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Bru-VânKiều (Vietnam)','Ethnicity_VN_Bru-VânKiều');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Thổ (Vietnam)','Ethnicity_VN_Thổ');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Giáy (Vietnam)','Ethnicity_VN_Giáy');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Cơ-tu (Vietnam)','Ethnicity_VN_Cơ-tu');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Gié-Triêng (Vietnam)','Ethnicity_VN_Gié-Triêng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Mạ (Vietnam)','Ethnicity_VN_Mạ');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Khơ-mú (Vietnam)','Ethnicity_VN_Khơ-mú');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Co (Vietnam)','Ethnicity_VN_Co');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ta-ôi (Vietnam)','Ethnicity_VN_Ta-ôi');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chơ-ro (Vietnam)','Ethnicity_VN_Chơ-ro');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kháng (Vietnam)','Ethnicity_VN_Kháng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Xinh-mun (Vietnam)','Ethnicity_VN_Xinh-mun');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','HàNhì (Vietnam)','Ethnicity_VN_HàNhì');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chu-ru (Vietnam)','Ethnicity_VN_Chu-ru');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Lào (Vietnam)','Ethnicity_VN_Lào');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','LaChi (Vietnam)','Ethnicity_VN_LaChi');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','LaHa (Vietnam)','Ethnicity_VN_LaHa');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','PhùLá (Vietnam)','Ethnicity_VN_PhùLá');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','LaHủ (Vietnam)','Ethnicity_VN_LaHủ');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Lự (Vietnam)','Ethnicity_VN_Lự');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','LôLô (Vietnam)','Ethnicity_VN_LôLô');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chứt (Vietnam)','Ethnicity_VN_Chứt');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Mảng (Vietnam)','Ethnicity_VN_Mảng');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','PàThẻn (Vietnam)','Ethnicity_VN_PàThẻn');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','CơLao (Vietnam)','Ethnicity_VN_CơLao');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Cống (Vietnam)','Ethnicity_VN_Cống');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','BốY (Vietnam)','Ethnicity_VN_BốY');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','SiLa (Vietnam)','Ethnicity_VN_SiLa');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','PuPéo (Vietnam)','Ethnicity_VN_PuPéo');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Brâu (Vietnam)','Ethnicity_VN_Brâu');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','ƠĐu (Vietnam)','Ethnicity_VN_ƠĐu');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Rơ-măm (Vietnam)','Ethnicity_VN_Rơ-măm');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Bikol/Bicol (Philippines)','Ethnicity_PH_Bikol/Bicol');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Cebuano (Philippines)','Ethnicity_PH_Cebuano');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Hiligaynon, Ilongo (Philippines)','Ethnicity_PH_Hiligaynon,_Ilongo');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ibanag (Philippines)','Ethnicity_PH_Ibanag');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ifugao (Philippines)','Ethnicity_PH_Ifugao');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ilocano (Philippines)','Ethnicity_PH_Ilocano');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kankanai/Kankaney (Philippines)','Ethnicity_PH_Kankanai/Kankaney');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kapampangan (Philippines)','Ethnicity_PH_Kapampangan');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Manobo/Ata-Manobo (Philippines)','Ethnicity_PH_Manobo/Ata-Manobo');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Masbateno/Masbatenon (Philippines)','Ethnicity_PH_Masbateno/Masbatenon');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Pangasinan/Panggalato (Philippines)','Ethnicity_PH_Pangasinan/Panggalato');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Surigaonon (Philippines)','Ethnicity_PH_Surigaonon');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Tagalog (Philippines)','Ethnicity_PH_Tagalog');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Waray (Philippines)','Ethnicity_PH_Waray');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Apayao/Yapayao (Philippines)','Ethnicity_PH_Apayao/Yapayao');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Bisaya/Binisaya (Philippines)','Ethnicity_PH_Bisaya/Binisaya');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Caviteno (Philippines)','Ethnicity_PH_Caviteno');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Isamal Kanlaw (Philippines)','Ethnicity_PH_Isamal_Kanlaw');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Itawis (Philippines)','Ethnicity_PH_Itawis');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Ivatan/Itbayat (Philippines)','Ethnicity_PH_Ivatan/Itbayat');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kalagan (Philippines)','Ethnicity_PH_Kalagan');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kalinga (Philippines)','Ethnicity_PH_Kalinga');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Sambal, Zambal (Philippines)','Ethnicity_PH_Sambal,_Zambal');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Others (Philippines)','Ethnicity_PH_Others');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Malay (Malaysia)','Ethnicity_MY_Malay');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chinese (Malaysia)','Ethnicity_MY_Chinese');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Indian (Malaysia)','Ethnicity_MY_Indian');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Others (Malaysia)','Ethnicity_MY_Others');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Iban (Malaysia)','Ethnicity_MY_Iban');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Kadazan (Malaysia)','Ethnicity_MY_Kadazan');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Bidayuh (Malaysia)','Ethnicity_MY_Bidayuh');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Other Indigenous (Malaysia)','Ethnicity_MY_Other_Indigenous');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Dusun (Malaysia)','Ethnicity_MY_Dusun');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Murut (Malaysia)','Ethnicity_MY_Murut');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Melanaus (Malaysia)','Ethnicity_MY_Melanaus');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Eurasia (Malaysia)','Ethnicity_MY_Eurasia');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Chinese (Singapore)','Ethnicity_SG_Chinese');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Malay (Singapore)','Ethnicity_SG_Malay');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Indian (Singapore)','Ethnicity_SG_Indian');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Eurasia (Singapore)','Ethnicity_SG_Eurasia');
		--INSERT INTO @ETHNICITY_LKUP VALUES('','Other (Singapore)','Ethnicity_SG_Other');		

		INSERT INTO @ETHNICITY_LKUP VALUES('RO','','Romanian','Ethnicity_RO_Romanian');
		INSERT INTO @ETHNICITY_LKUP VALUES('RO','','Others','Ethnicity_RO_Others');
		INSERT INTO @ETHNICITY_LKUP VALUES('ZA','01','African','Ethnicity_ZA_African');
		INSERT INTO @ETHNICITY_LKUP VALUES('ZA','03','Indian','Ethnicity_ZA_Indian');
		INSERT INTO @ETHNICITY_LKUP VALUES('ZA','02','Coloured','Ethnicity_ZA_Coloured');
		INSERT INTO @ETHNICITY_LKUP VALUES('ZA','04','White','Ethnicity_ZA_White');
		INSERT INTO @ETHNICITY_LKUP VALUES('ZA','05','Other','Ethnicity_ZA_Other');
		INSERT INTO @ETHNICITY_LKUP VALUES('HU','','Hungarian','Ethnicity_HU_Hungarian');
		INSERT INTO @ETHNICITY_LKUP VALUES('HU','','Other','Ethnicity_HU_Other');
		INSERT INTO @ETHNICITY_LKUP VALUES('AM','','Armenian','Ethnicity_AM_Armenian');
		INSERT INTO @ETHNICITY_LKUP VALUES('AM','','Others','Ethnicity_AM_Others');
		INSERT INTO @ETHNICITY_LKUP VALUES('GE','','Georgian','Ethnicity_GE_Georgian');
		INSERT INTO @ETHNICITY_LKUP VALUES('GE','','Others','Ethnicity_GE_Others');
		INSERT INTO @ETHNICITY_LKUP VALUES('UA','','Ukrainian','Ethnicity_UA_Ukrainian');
		INSERT INTO @ETHNICITY_LKUP VALUES('UA','','Others','Ethnicity_UA_Others');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_ETHNICITY_LKUP;';
		SELECT * INTO DEMOGRAPHICS_ETHNICITY_LKUP FROM @ETHNICITY_LKUP

		DECLARE @MARITAL_STATUS_INFO TABLE(
			COUNTRY_CODE2 VARCHAR(10),
			COUNTRY_CODE3 VARCHAR(10),
			HR_CORE_ID    VARCHAR(10),
			WD_VALUE      VARCHAR(50),
			WD_ID         VARCHAR(50)
		);
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '7','Civil Partnership (United Kingdom)','GBR_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '3','Divorced (United Kingdom)','GBR_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '1','Married (United Kingdom)','GBR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '5','Separated (United Kingdom)','GBR_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '0','Single (United Kingdom)','GBR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UK', 'GBR', '2','Widowed (United Kingdom)','GBR_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '7','Civil Partnership (Ireland)','IRL_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '3','Divorced (Ireland)','IRL_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '1','Married (Ireland)','IRL_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '5','Separated (Ireland)','IRL_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '0','Single (Ireland)','IRL_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IR', 'IRL', '2','Widowed (Ireland)','IRL_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AR', 'ARG', '99','Cohabiting (Argentina)','Marital_Status_AR_Cohabiting');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AR', 'ARG', '3','Divorced (Argentina)','Marital_Status_AR_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AR', 'ARG', '1','Married (Argentina)','Marital_Status_AR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AR', 'ARG', '0','Single (Argentina)','Marital_Status_AR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AR', 'ARG', '2','Widowed (Argentina)','Marital_Status_AR_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '1','Casado/Married (Brazil)','Marital_Status_BR_Casado/Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '3','Divorciado/Divorced (Brazil)','Marital_Status_BR_Divorciado/Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '99','Não informado/Not Informed (Brazil)','Marital_Status_BR_Não informado/Not Informed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '0','Solteiro/Single (Brazil)','Marital_Status_BR_Solteiro/Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '99','União Estável/Commom Law Partner (Brazil)','Marital_Status_BR_União Estável/Commom Law Partner');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BR', 'BRA', '99','Viúvo/Widower (Brazil)','Marital_Status_BR_Viúvo/Widower');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CA', 'CAN', '99','Commonlaw (Canada)','Marital_Status_CA_Commonlaw');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CA', 'CAN', '1','Married (Canada)','Marital_Status_CA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CA', 'CAN', '0','Single (Canada)','Marital_Status_CA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CL', 'CHL', '99','Cohabiting (Chile)','Marital_Status_CL_Cohabiting');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CL', 'CHL', '3','Divorced (Chile)','Marital_Status_CL_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CL', 'CHL', '1','Married (Chile)','Marital_Status_CL_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CL', 'CHL', '0','Single (Chile)','Marital_Status_CL_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CL', 'CHL', '2','Widowed (Chile)','Marital_Status_CL_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CO', 'COL', '7' ,'Civil Partnership (Colombia)','Marital_Status_CO_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CO', 'COL', '3' ,'Divorced (Colombia)','Marital_Status_CO_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CO', 'COL', '1' ,'Married (Colombia)','Marital_Status_CO_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CO', 'COL', '0' ,'Single (Colombia)','Marital_Status_CO_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CO', 'COL', '2' ,'Widowed (Colombia)','Marital_Status_CO_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CR', 'CRI', '7','Civil Partnership (Costa Rica)','Marital_Status_CR_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CR', 'CRI', '3','Divorced (Costa Rica)','Marital_Status_CR_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CR', 'CRI', '1','Married (Costa Rica)','Marital_Status_CR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CR', 'CRI', '0','Single (Costa Rica)','Marital_Status_CR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CR', 'CRI', '2','Widowed (Costa Rica)','Marital_Status_CR_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('DO', 'DOM', '7','Civil Partnership (Dominican Republic)','Marital_Status_DO_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('DO', 'DOM', '3','Divorced (Dominican Republic)','Marital_Status_DO_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('DO', 'DOM', '1','Married (Dominican Republic)','Marital_Status_DO_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('DO', 'DOM', '0','Single (Dominican Republic)','Marital_Status_DO_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('DO', 'DOM', '2','Widowed (Dominican Republic)','Marital_Status_DO_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('EC', 'ECU', '7','Civil Partnership (Ecuador)','Marital_Status_EC_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('EC', 'ECU', '3','Divorced (Ecuador)','Marital_Status_EC_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('EC', 'ECU', '1','Married (Ecuador)','Marital_Status_EC_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('EC', 'ECU', '0','Single (Ecuador)','Marital_Status_EC_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('EC', 'ECU', '2','Widowed (Ecuador)','Marital_Status_EC_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('GT', 'GTM', '7','Civil Partnership (Guatemala)','Marital_Status_GT_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('GT', 'GTM', '3','Divorced (Guatemala)','Marital_Status_GT_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('GT', 'GTM', '1','Married (Guatemala)','Marital_Status_GT_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('GT', 'GTM', '0','Single (Guatemala)','Marital_Status_GT_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('GT', 'GTM', '2','Widowed (Guatemala)','Marital_Status_GT_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '7','Civil Partnership (Mexico)','Marital_Status_MX_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '99','Cohabiting (Mexico)','Marital_Status_MX_Cohabiting');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '3','Divorced (Mexico)','Marital_Status_MX_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '1','Married (Mexico)','Marital_Status_MX_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '0','Single (Mexico)','Marital_Status_MX_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MX', 'MEX', '2','Widowed (Mexico)','Marital_Status_MX_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PA', 'PAN', '7','Civil Partnership (Panama)','Marital_Status_PA_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PA', 'PAN', '3','Divorced (Panama)','Marital_Status_PA_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PA', 'PAN', '1','Married (Panama)','Marital_Status_PA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PA', 'PAN', '0','Single (Panama)','Marital_Status_PA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PA', 'PAN', '2','Widowed (Panama)','Marital_Status_PA_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PE', 'PER', '99','Cohabiting (Peru)','Marital_Status_PE_Cohabiting');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PE', 'PER', '3','Divorced (Peru)','Marital_Status_PE_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PE', 'PER', '1','Married (Peru)','Marital_Status_PE_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PE', 'PER', '0','Single (Peru)','Marital_Status_PE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PE', 'PER', '2','Widowed (Peru)','Marital_Status_PE_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SV', 'SLV', '7','Civil Partnership (El Salvador)','Marital_Status_SV_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SV', 'SLV', '3','Divorced (El Salvador)','Marital_Status_SV_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SV', 'SLV', '1','Married (El Salvador)','Marital_Status_SV_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SV', 'SLV', '0','Single (El Salvador)','Marital_Status_SV_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SV', 'SLV', '2','Widowed (El Salvador)','Marital_Status_SV_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '3','Divorced (United States of America)','Marital_Status_US_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '1','Married (United States of America)','Marital_Status_US_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '99','Partnered (United States of America)','Marital_Status_US_Partnered');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '5','Separated (United States of America)','Marital_Status_US_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '0','Single (United States of America)','Marital_Status_US_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('US', 'USA', '2','Widowed (United States of America)','Marital_Status_US_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UY', 'UYU', '99','Cohabiting (Uruguay)','Marital_Status_UY_Cohabiting');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UY', 'UYU', '3','Divorced (Uruguay)','Marital_Status_UY_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UY', 'UYU', '1','Married (Uruguay)','Marital_Status_UY_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UY', 'UYU', '0','Single (Uruguay)','Marital_Status_UY_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('UY', 'UYU', '2','Widowed (Uruguay)','Marital_Status_UY_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VE', 'VEN', '7','Civil Partnership (Venezuela)','Marital_Status_VE_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VE', 'VEN', '3','Divorced (Venezuela)','Marital_Status_VE_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VE', 'VEN', '1','Married (Venezuela)','Marital_Status_VE_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VE', 'VEN', '0','Single (Venezuela)','Marital_Status_VE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VE', 'VEN', '2','Widowed (Venezuela)','Marital_Status_VE_Widowed');

		
		INSERT INTO @MARITAL_STATUS_INFO VALUES('HK','HKG','0','Single','Marital_Status_HK_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('HK','HKG','1','Married','Marital_Status_HK_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('HK','HKG','3','Divorced','Marital_Status_HK_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('HK','HKG','2','Widow/Widower','Marital_Status_HK_Widow/Widower');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('KR','KOR','1','Married','Marital_Status_KR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('KR','KOR','0','Single','Marital_Status_KR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MY','MYS','1','Married','Marital_Status_MY_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MY','MYS','0','Single','Marital_Status_MY_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MY','MYS','2','Widowed','Marital_Status_MY_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MY','MYS','3','Divorced','Marital_Status_MY_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('MY','MYS','5','Separated','');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','5','Separated','Marital_Status_SG_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','0','Single','Marital_Status_SG_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','1','Married','Marital_Status_SG_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','5','Separated','Marital_Status_SG_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','2','Widowed','Marital_Status_SG_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('SG','SGP','3','Divorced','Marital_Status_SG_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PK','PAK','0','Single','Marital_Status_PK_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PK','PAK','1','Married','Marital_Status_PK_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PK','PAK','5','Separated','Marital_Status_PK_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PK','PAK','2','Widowed','Marital_Status_PK_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PK','PAK','3','Divorced','Marital_Status_PK_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BD','BGD','0','Single','Marital_Status_BD_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BD','BGD','1','Married','Marital_Status_BD_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BD','BGD','5','Separated','Marital_Status_BD_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BD','BGD','2','Widowed','Marital_Status_BD_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('BD','BGD','3','Divorced','Marital_Status_BD_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IN','IND','0','Single','Marital_Status_IN_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IN','IND','1','Married','Marital_Status_IN_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IN','IND','5','Separated','Marital_Status_IN_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IN','IND','2','Widowed','Marital_Status_IN_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('IN','IND','3','Divorced','Marital_Status_IN_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AU','AUS','99','De facto','Marital_Status_AU_De facto');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AU','AUS','1','Married','Marital_Status_AU_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AU','AUS','2','Widowed','Marital_Status_AU_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('AU','AUS','0','Single','Marital_Status_AU_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('NZ','NZL','0','Single','Marital_Status_NZ_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('NZ','NZL','1','Married','Marital_Status_NZ_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('NZ','NZL','99','De facto','Marital_Status_NZ_De facto');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('NZ','NZL','2','Widowed','Marital_Status_NZ_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('JP','JPN','1','Married','Marital_Status_JP_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('JP','JPN','0','Single','Marital_Status_JP_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TH','THA','0','Single','Marital_Status_TH_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TH','THA','1','Married','Marital_Status_TH_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('ID','IDN','0','Single','Marital_Status_ID_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('ID','IDN','1','Married','Marital_Status_ID_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('ID','IDN','3','Divorced','Marital_Status_ID_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('ID','IDN','2','Widowed','Marital_Status_ID_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VN','VNM','0','Single','Marital_Status_VN_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VN','VNM','1','Married','Marital_Status_VN_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VN','VNM','3','Divorced','Marital_Status_VN_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('VN','VNM','2','Widowed','Marital_Status_VN_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PH','PHL','0','Single','Marital_Status_PH_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('PH','PHL','1','Married','Marital_Status_PH_Married');
    	INSERT INTO @MARITAL_STATUS_INFO VALUES('PH','PHL','2','Widowed','Marital_Status_PH_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CN','CHN','0','Single','Marital_Status_CN_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CN','CHN','1','Married','Marital_Status_CN_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CN','CHN','5','Separated','Marital_Status_CN_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CN','CHN','2','Widowed','Marital_Status_CN_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('CN','CHN','3','Divorced','Marital_Status_CN_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TW','TWN','0','Single','Marital_Status_TW_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TW','TWN','1','Married','Marital_Status_TW_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TW','TWN','5','Separated','Marital_Status_TW_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TW','TWN','2','Widowed','Marital_Status_TW_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES('TW','TWN','3','Divorced','Marital_Status_TW_Divorced');

		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AM','ARM','0','Single (Armenia)','Marital_Status_AM_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AM','ARM','1','Married (Armenia)','Marital_Status_AM_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AM','ARM','3','Divorced (Armenia)','Marital_Status_AM_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','0','Single (Austria)','Marital_Status_AT_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','1','Married (Austria)','Marital_Status_AT_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','2','Widowed (Austria)','Marital_Status_AT_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','3','Divorced (Austria)','Marital_Status_AT_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','5','Separated (Austria)','Marital_Status_AT_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','7','Registered Partnership (Austria)','Marital_Status_AT_Registered Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AT','AUT','8','Divorced Partnership (Austria)','Marital_Status_AT_Divorced Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','1','Gehuwd (Belgium)','Marital_Status_BE_Gehuwd');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','3','Gescheiden (Belgium)','Marital_Status_BE_Gescheiden');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','99','Wettelijk samenwonend (Belgium)','Marital_Status_BE_Wettelijk samenwonend');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','0','Single (Belgium)','Marital_Status_BE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','2','Weduwe/weduwnaar (Belgium)','Marital_Status_BE_Weduwe/weduwnaar');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BE','BEL','5','Gescheiden van tafel en bed (Belgium)','Marital_Status_BE_Gescheiden van tafel en bed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BY','BLR','0','Single (Belarus)','Marital_Status_BY_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BY','BLR','1','Married (Belarus)','Marital_Status_BY_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'BY','BLR','3','Divorced (Belarus)','Marital_Status_BY_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'EG','EGY','0','Single (Egypt)','Marital_Status_EG_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'EG','EGY','1','Married (Egypt)','Marital_Status_EG_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'EG','EGY','3','Divorced (Egypt)','Marital_Status_EG_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'EG','EGY','2','Widowed (Egypt)','Marital_Status_EG_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'FR','FRA','0','Single (France)','Marital_Status_FR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'FR','FRA','1','Married (France)','Marital_Status_FR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'FR','FRA','3','Divorced (France)','Marital_Status_FR_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'FR','FRA','2','Widowed (France)','Marital_Status_FR_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'FR','FRA','7','Civil Partnership (France)','Marital_Status_FR_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GE','GEO','0','Single (Georgia)','Marital_Status_GE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GE','GEO','1','Married (Georgia)','Marital_Status_GE_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GE','GEO','3','Divorced (Georgia)','Marital_Status_GE_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','0','Single (Germany)','Marital_Status_DE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','1','Married (Germany)','Marital_Status_DE_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','2','Widowed (Germany)','Marital_Status_DE_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','3','Divorced (Germany)','Marital_Status_DE_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','5','Separated (Germany)','Marital_Status_DE_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','7','Registered Partnership (Germany)','Marital_Status_DE_Registered Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','8','Divorced Partnership (Germany)','Marital_Status_DE_Divorced Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','99','entitled to maintenance (Germany)','Marital_Status_DE_entitled to maintenance');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'DE','DEU','99','not known (Germany)','Marital_Status_DE_not known');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','0','Single (Greece)','Marital_Status_GR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','1','Married (Greece)','Marital_Status_GR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','3','Divorced (Greece)','Marital_Status_GR_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','5','Separated (Greece)','Marital_Status_GR_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','2','Widowed (Greece)','Marital_Status_GR_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','7','Civil Partnership (Greece)','Marital_Status_GR_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'GR','GRC','8','Divorced Partnership (Greece)','Marital_Status_GR_Divorced Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'HU','HUN','1','Married (Hungary)','Marital_Status_HU_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'HU','HUN','3','Divorced (Hungary)','Marital_Status_HU_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'HU','HUN','0','Single (Hungary)','Marital_Status_HU_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'HU','HUN','2','Widowed (Hungary)','Marital_Status_HU_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IL','ISR','0','Single (Israel)','Marital_Status_IL_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IL','ISR','1','Married (Israel)','Marital_Status_IL_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IL','ISR','3','Divorced (Israel)','Marital_Status_IL_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IL','ISR','2','Widowed (Israel)','Marital_Status_IL_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IT','ITA','1','Sposato (Italy)','Marital_Status_IT_Sposato');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IT','ITA','0','Celibe (Italy)','Marital_Status_IT_Celibe');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IT','ITA','99','Nubile (Italy)','Marital_Status_IT_Nubile');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IT','ITA','2','Vedovo (Italy)','Marital_Status_IT_Vedovo');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'IT','ITA','3','Divorziato (Italy)','Marital_Status_IT_Divorziato');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'KZ','KAZ','0','Single (Kazakhstan)','Marital_Status_KZ_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'KZ','KAZ','1','Married (Kazakhstan)','Marital_Status_KZ_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'KZ','KAZ','3','Divorced (Kazakhstan)','Marital_Status_KZ_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'LB','LBN','0','Single (Lebanon)','Marital_Status_LB_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'LB','LBN','1','Married (Lebanon)','Marital_Status_LB_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'LB','LBN','3','Divorced (Lebanon)','Marital_Status_LB_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'LB','LBN','2','Widowed (Lebanon)','Marital_Status_LB_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'MA','MAR','0','Single (Morocco)','Marital_Status_MA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'MA','MAR','1','Married (Morocco)','Marital_Status_MA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'MA','MAR','3','Divorced (Morocco)','Marital_Status_MA_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'MA','MAR','2','Widowed (Morocco)','Marital_Status_MA_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'PT','PRT','0','Solteiro/a (Portugal)','Marital_Status_PT_Solteiro/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'PT','PRT','1','Casado/a (Portugal)','Marital_Status_PT_Casado/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'PT','PRT','99','União de Facto (Portugal)','Marital_Status_PT_União de Facto');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'PT','PRT','3','Divorciado/a (Portugal)','Marital_Status_PT_Divorciado/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'PT','PRT','2','Viúvo/a (Portugal)','Marital_Status_PT_Viúvo/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RO','ROU','1','Not married (Romania)','Marital_Status_RO_Not married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RO','ROU','3','Divorced (Romania)','Marital_Status_RO_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RO','ROU','1','Married (Romania)','Marital_Status_RO_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RO','ROU','2','Widowed (Romania)','Marital_Status_RO_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RU','RUS','0','Single (Russian Federation)','Marital_Status_RU_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RU','RUS','1','Married (Russian Federation)','Marital_Status_RU_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RU','RUS','3','Divorced (Russian Federation)','Marital_Status_RU_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'RU','RUS','2','Widowed (Russian Federation)','Marital_Status_RU_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'SA','SAU','0','Single (Saudi Arabia)','Marital_Status_SA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'SA','SAU','1','Married (Saudi Arabia)','Marital_Status_SA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'SA','SAU','3','Divorced (Saudi Arabia)','Marital_Status_SA_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'SA','SAU','2','Widowed (Saudi Arabia)','Marital_Status_SA_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','1','Married (South Africa)','Marital_Status_ZA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','2','Widowed (South Africa)','Marital_Status_ZA_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','0','Single (South Africa)','Marital_Status_ZA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','7','Civil Partnership (South Africa)','Marital_Status_ZA_Civil Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','3','Divorced (South Africa)','Marital_Status_ZA_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ZA','ZAF','5','Separated (South Africa)','Marital_Status_ZA_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ES','ESP','0','Soltero/a (Spain)','Marital_Status_ES_Soltero/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ES','ESP','1','Casado/a (Spain)','Marital_Status_ES_Casado/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ES','ESP','7','Pareja de hecho (Spain)','Marital_Status_ES_Pareja de hecho');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ES','ESP','3','Divorciado/a (Spain)','Marital_Status_ES_Divorciado/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'ES','ESP','2','Viudo/a (Spain)','Marital_Status_ES_Viudo/a');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','0','Single (Switzerland)','Marital_Status_CH_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','1','Married (Switzerland)','Marital_Status_CH_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','2','Widowed (Switzerland)','Marital_Status_CH_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','3','Divorced (Switzerland)','Marital_Status_CH_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','5','Separated (Switzerland)','Marital_Status_CH_Separated');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','7','Registered Partnership (Switzerland)','Marital_Status_CH_Registered Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'CH','CHE','8','Divorced Partnership (Switzerland)','Marital_Status_CH_Divorced Partnership');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'TR','TUR','0','Single (Turkey)','Marital_Status_TR_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'TR','TUR','1','Married (Turkey)','Marital_Status_TR_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AE','ARE','0','Single (United Arab Emirates)','Marital_Status_AE_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AE','ARE','1','Married (United Arab Emirates)','Marital_Status_AE_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AE','ARE','3','Divorced (United Arab Emirates)','Marital_Status_AE_Divorced');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'AE','ARE','2','Widowed (United Arab Emirates)','Marital_Status_AE_Widowed');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'UA','UKR','0','Single (Ukraine)','Marital_Status_UA_Single');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'UA','UKR','1','Married (Ukraine)','Marital_Status_UA_Married');
		INSERT INTO @MARITAL_STATUS_INFO VALUES( 'UA','UKR','3','Divorced (Ukraine)','Marital_Status_UA_Divorced');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_MARITAL_STATUS_INFO;';
		SELECT * INTO DEMOGRAPHICS_MARITAL_STATUS_INFO FROM @MARITAL_STATUS_INFO

		DECLARE @MILITARY_STATUS_INFO TABLE(
		COUNTRY2_CODE      VARCHAR(100),
		COUNTRY_GROUP      VARCHAR(10),
		MILSA              VARCHAR(10),
		COUNTRY_NAME       VARCHAR(100),
		TEXT_VALUE         NVARCHAR(500)
		);
		INSERT INTO @MILITARY_STATUS_INFO VALUES('CA', '07','01','Canada','Reserves');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('CA', '07','02','Canada','Regular Forces');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('CA', '07','03','Canada','Militia');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('CA', '07','04','Canada','Cadets');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('CA', '07','05','Canada','Veterans');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('', '08','01','','Reserve');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('', '08','02','','Territorial Army');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('US', '10','04','USA','Inactive reserve');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('US', '10','05','USA','Reserve');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('SG', '25','01','','Not applicable');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('SG', '25','02','','Active reservist');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('SG', '25','03','','Exempted');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('SG', '25','04','','Completed reservist');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('KR','41','01','','Completed');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('KR','41','02','','Not Completed');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('KR','41','03','','Exempted');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('TH','26','01','','Active Duty');
		INSERT INTO @MILITARY_STATUS_INFO VALUES('TH','26','01','','Inactive Duty');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_MILITARY_STATUS_INFO;';
		SELECT * INTO DEMOGRAPHICS_MILITARY_STATUS_INFO FROM @MILITARY_STATUS_INFO

		DECLARE @VETREN_STATUS_INFO TABLE(
		VETREN_CODE      VARCHAR(10),
		VETREN_STATUS    VARCHAR(10),
		WD_VALUE         VARCHAR(500),
		WD_ID            VARCHAR(500)
		);
		INSERT INTO @VETREN_STATUS_INFO VALUES('V1','Id','I AM NOT A VETERAN','NOT_A_VETERAN');
		--INSERT INTO @VETREN_STATUS_INFO VALUES('V8','Id','IDENTIFY AS A VETERAN, JUST NOT A PROTECTED VETERAN','IDENTIFY_AS_VETERAN');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V8','Id','IDENTIFY AS A VETERAN, JUST NOT A PROTECTED VETERAN','NOT_A_VETERAN');		
		INSERT INTO @VETREN_STATUS_INFO VALUES('VA','Id','IDENTIFY AS ONE OR MORE OF THE CLASSIFICATIONS OF PROTECTED VETERANS','IDENTIFY_AS_ONE_OR_MORE_OF_PROTECTED_VETERANS');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V9','Id','I DO NOT WISH TO SELF-IDENTIFY','DO_NOT_WISH_TO_SELF-IDENTIFY');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V7','Type','Disabled Veteran','DISABLED_VETERAN');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V5','Type','Recently Separated Veteran','RECENTLY_SEPARATED_VETERAN');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V4','Type','Active Duty Wartime or Campaign Badge Veteran','WARTIME_VETERAN');
		INSERT INTO @VETREN_STATUS_INFO VALUES('V6','Type','Armed Forces Service Medal Veteran','ARMED_FORCES_VETERAN');
		--SELECT * INTO VETREN_STATUS_INFO_LKUP FROM @VETREN_STATUS_INFO

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_VETREN_STATUS_INFO;';
		SELECT * INTO DEMOGRAPHICS_VETREN_STATUS_INFO FROM @VETREN_STATUS_INFO

		DECLARE @CITIZENSHIP_INFO TABLE(
			COUNTRY_CODE      VARCHAR(10),
			CITIZEN_STATUS    VARCHAR(2000),
			WD_TEXT           VARCHAR(2000),
			WD_ID             VARCHAR(2000)
		);

		INSERT INTO @CITIZENSHIP_INFO VALUES('AM','Citizen','AM - Citizen','Citizenship_Statses_AM_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AM','Non Citizen','AM - Non-citizen','Citizenship_Statses_AM_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AT','Citizen','AT - Citizen','Citizenship_Statses_AT_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AT','Non Citizen','AT - Non Citizen','Citizenship_Statses_AT_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BY','Citizen','BY - Citisen','Citizenship_Statses_BY_Citisen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BY','Non Citizen','BY - Non-citizen','Citizenship_Statses_BY_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BY','Resident','BY - Resident','Citizenship_Statses_BY_Resident');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BE','Citizen','BE - Citizen','Citizenship_Statses_BE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BE','CitizenEU','BE - EU Citizen','Citizenship_Statses_BE_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BE','Non Citizen','BE - Non-EU Citizen','Citizenship_Statses_BE_Non-EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DK','Citizen','DK - Citizen','Citizenship_Statses_DK_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DK','Non Citizen','DK - Non Citizen','Citizenship_Statses_DK_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EG','Citizen','EG - Citizen','Citizenship_Statses_EG_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EG','Non Citizen','EG - Non citizen','Citizenship_Statses_EG_Non citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EE','Citizen','EE - Citizen','Citizenship_Statses_EE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EE','Non Citizen','EE - Non-citizen','Citizenship_Statses_EE_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('FI','Citizen','FI - Citizen','Citizenship_Statses_FI_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('FI','Non Citizen','FI - Non Citizen','Citizenship_Statses_FI_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('FR','Citizen','FR - France Citizen','Citizenship_Statses_FR_France Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('FR','Non Citizen','FR - Non UE','Citizenship_Statses_FR_Non UE');
		INSERT INTO @CITIZENSHIP_INFO VALUES('FR','CitizenUE','FR - UE / Swiss Citizen','Citizenship_Statses_FR_UE / Swiss Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GE','Citizen','GE - Citizen','Citizenship_Statses_GE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GE','Non Citizen','GE - Non-citizen','Citizenship_Statses_GE_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DE','Citizen','DE - Citizen','Citizenship_Statses_DE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DE','Non Citizen','DE - Non Citizen','Citizenship_Statses_DE_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GR','Citizen','GR - Citizen','Citizenship_Statses_GR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GR','CitizenEU','GR - EU Citizen','Citizenship_Statses_GR_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GR','Non Citizen','GR - Non EU Citizen','Citizenship_Statses_GR_Non EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HU','Citizen','HU - Citizen / Magyar állampolgár','Citizenship_Statses_HU_Citizen / Magyar állampolgár');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HU','Non Citizen','HU - Non citizen / Nem magyar állampolgár','Citizenship_Statses_HU_Non citizen / Nem magyar állampolgár');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IL','Citizen','IL - Citizen','Citizenship_Statses_IL_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IL','Non Citizen','IL - Non-Citizen','Citizenship_Statses_IL_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IT','Citizen','IT - Cittadinanza Italiana','Citizenship_Statses_IT_Cittadinanza Italiana');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IT','Non Citizen','IT - Cittadinanza non UE','Citizenship_Statses_IT_Cittadinanza non UE');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IT','CitizenUE','IT - Cittadinanza UE','Citizenship_Statses_IT_Cittadinanza UE');
		INSERT INTO @CITIZENSHIP_INFO VALUES('KZ','Citizen','KZ - Citizen','Citizenship_Statses_KZ_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('KZ','Non Citizen','KZ - Non-citizen','Citizenship_Statses_KZ_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LV','Citizen','LV - Citizen','Citizenship_Statses_LV_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LV','Non Citizen','LV - Non-citizen','Citizenship_Statses_LV_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LB','Citizen','LB - Citizen','Citizenship_Statses_LB_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LB','Non Citizen','LB - Non Citizen','Citizenship_Statses_LB_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LT','Citizen','LT - Citizen','Citizenship_Statses_LT_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('LT','Non Citizen','LT - Non-citizen','Citizenship_Statses_LT_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MA','Citizen','MA - Citizen','Citizenship_Statses_MA_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MA','Non Citizen','MA - Non Citizen','Citizenship_Statses_MA_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NO','Citizen','NO - Citizen','Citizenship_Statses_NO_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NO','Non Citizen','NO - Non Citizen','Citizenship_Statses_NO_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PL','CitizenEU','PL - EU Citizen','Citizenship_Statses_PL_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PL','Non Citizen','PL - Non-EU Citizen','Citizenship_Statses_PL_Non-EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PL','Citizen','PL - Polish Citizen','Citizenship_Statses_PL_Polish Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PT','Citizen','PT - Citizen','Citizenship_Statses_PT_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PT','Non Citizen','PT - Non Citizen','Citizenship_Statses_PT_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('RO','Citizen','RO - Citizen','Citizenship_Statses_RO_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('RO','Non Citizen','RO - Non Citizen','Citizenship_Statses_RO_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('RU','Citizen','RU - Citizen','Citizenship_Statses_RU_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('RU','CitizenEU','RU - Eurasian Economic Union citizen','Citizenship_Statses_RU_Eurasian Economic Union citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('RU','Non Citizen','RU - Non-citizen','Citizenship_Statses_RU_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SA','Citizen','SA - National KSA or descent of Saudi mother or Spouse of Saudi','Citizenship_Statses_SA_National KSA or descent of Saudi mother or Spouse of Saudi');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SA','Non Resident','SA - Non resident ( only for candidates)','Citizenship_Statses_SA_Non resident ( only for candidates)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SA','Resident','SA - Resident KSA','Citizenship_Statses_SA_Resident KSA');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ZA','Citizen','ZA - Citizen','Citizenship_Statses_ZA_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ZA','Non Citizen','ZA - Non-Citizen','Citizenship_Statses_ZA_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ES','Citizen','ES - Citizen','Citizenship_Statses_ES_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ES','CitizenEU','ES - EU Citizen','Citizenship_Statses_ES_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ES','Non Citizen','ES - Non EU Citizen','Citizenship_Statses_ES_Non EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SE','Citizen','SE - Citizen','Citizenship_Statses_SE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SE','Non Citizen','SE - Non Citizen','Citizenship_Statses_SE_Non Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CH','CitizenEU','CH - EU/AELE Citizen','Citizenship_Statses_CH_EU/AELE Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CH','Non Citizen','CH - Non EU/AELE Citizen','Citizenship_Statses_CH_Non EU/AELE Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CH','Citizen','CH - Swiss Citizen','Citizenship_Statses_CH_Swiss Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TR','Citizen','TR - Citizen','Citizenship_Statses_TR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TR','Non Citizen','TR - Non Citizen','Citizenship_Statses_TR_Non Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AE','Citizen','AE - National UAE','Citizenship_Statses_AE_National UAE');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AE','Non Resident','AE - Non resident ( only for candidates)','Citizenship_Statses_AE_Non resident ( only for candidates)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AE','Resident','AE - Resident UAE','Citizenship_Statses_AE_Resident UAE');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UA','Citizen','UA - Citizen','Citizenship_Statses_UA_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UA','Non Citizen','UA - Non-citizen','Citizenship_Statses_UA_Non-citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NL','Citizen','NL - Citizen','Citizenship_Statses_NL_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NL','CitizenEU','NL - EU Citizen','Citizenship_Statses_NL_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NL','Non Citizen','NL - Non-EU Citizen','Citizenship_Statses_NL_Non-EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CZ','Citizen','CZ - Citizen','Citizenship_Statses_CZ_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CZ','CitizenEU','CZ - EU Citizen','Citizenship_Statses_CZ_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CZ','Non Citizen','CZ - Non-EU Citizen','Citizenship_Statses_CZ_Non-EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SK','Citizen','SK - Citizen','Citizenship_Statses_SK_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SK','CitizenEU','SK - EU Citizen','Citizenship_Statses_SK_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SK','Non Citizen','SK - Non-EU Citizen','Citizenship_Statses_SK_Non-EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HR','Citizen','HR - Citizen','Citizenship_Statses_HR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HR','CitizenEU','HR - EU Citizen','Citizenship_Statses_HR_EU Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HR','Non Citizen','HR - Non-EU Citizen','Citizenship_Statses_HR_Non-EU Citizen');

		INSERT INTO @CITIZENSHIP_INFO VALUES('IR','Non Citizen', '', 'IRL_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UK','Non Citizen', '', 'GBR_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IR','Citizen', '', 'IRL_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UK','Citizen', '', 'GBR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PE','Citizen', '', 'Citizenship_Status_PE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PE','Non Citizen', '', 'Citizenship_Status_PE_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EC','Citizen', '', 'Citizenship_Status_EC_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('EC','Non Citizen', '', 'Citizenship_Status_EC_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CO','Citizen', '', 'Citizenship_Status_CO_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CO','Non Citizen', '', 'Citizenship_Status_CO_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MX','Citizen', '', 'Citizenship_Status_MX_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MX','Non Citizen', '', 'Citizenship_Status_MX_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BR','Citizen', '', 'Citizenship_Status_BR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BR','Non Citizen', '', 'Citizenship_Status_BR_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AR','Citizen', '', 'Citizenship_Status_AR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('AR','Non Citizen', '', 'Citizenship_Status_AR_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UY','Citizen', '', 'Citizenship_Status_UY_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('UY','Non Citizen', '', 'Citizenship_Status_UY_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('US','Non Citizen', '', 'Citizenship_Status_US_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CA','Citizen', '', 'Citizenship_Status_CA_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CA','Non Citizen', '', 'Citizenship_Status_CA_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CR','Citizen', '', 'Citizenship_Status_CR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CR','Non Citizen', '', 'Citizenship_Status_CR_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PA','Citizen', '', 'Citizenship_Status_PA_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PA','Non Citizen', '', 'Citizenship_Status_PA_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SV','Citizen', '', 'Citizenship_Status_SV_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SV','Non Citizen', '', 'Citizenship_Status_SV_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DO','Citizen', '', 'Citizenship_Status_DO_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('DO','Non Citizen', '', 'Citizenship_Status_DO_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('VE','Citizen', '', 'Citizenship_Status_VE_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('VE','Non Citizen', '', 'Citizenship_Status_VE_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CL','Citizen', '', 'Citizenship_Status_CL_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CL','Non Citizen', '', 'Citizenship_Status_CL_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('US','Citizen', '', 'Citizenship_Status_US_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('US','Permanent Residence', '', 'Citizenship_Status_US_Permanent Residence');
		INSERT INTO @CITIZENSHIP_INFO VALUES('US','Temporary Residence', '', 'Citizenship_Status_US_Temporary Residence');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GT','Citizen', '', 'Citizenship_Status_GT_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('GT','Non Citizen', '', 'Citizenship_Status_GT_Non-Citizen');

		--INSERT INTO @CITIZENSHIP_INFO VALUES('PE','Citizen','Citizenship_Statses_PE_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('US','Citizen','Citizenship_Statses_US_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('UY','Citizen','Citizenship_Statses_UY_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('SV','Citizen','Citizenship_Statses_SV_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('GB','Citizen','GBR_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('IR','Citizen','IRL_Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('VE','Citizen','Citizenship_Statses_VE_Citizen');

		--INSERT INTO @CITIZENSHIP_INFO VALUES('AR','Non-Citizen','Citizenship_Statses_AR_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('BR','Non-Citizen','Citizenship_Statses_BR_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CA','Non-Citizen','Citizenship_Statses_CA_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CL','Non-Citizen','Citizenship_Statses_CL_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CO','Non-Citizen','Citizenship_Statses_CO_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('CR','Non-Citizen','Citizenship_Statses_CR_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('DO','Non-Citizen','Citizenship_Statses_DO_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('EC','Non-Citizen','Citizenship_Statses_EC_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('GT','Non-Citizen','Citizenship_Statses_GT_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('US','Non-Citizen','Citizenship_Statses_US_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('UY','Non-Citizen','Citizenship_Statses_UY_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('VE','Non-Citizen','Citizenship_Statses_VE_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('GB','Non-Citizen','GBR_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('IR','Non-Citizen','IRL_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('MX','Non-Citizen','Citizenship_Statses_MX_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('PA','Non-Citizen','Citizenship_Statses_PA_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('PE','Non-Citizen','Citizenship_Statses_PE_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('SV','Non-Citizen','Citizenship_Statses_SV_Non-Citizen');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('US','Permanent Residence','Citizenship_Statses_US_Permanent Residence');
		--INSERT INTO @CITIZENSHIP_INFO VALUES('US','Temporary Residence','Citizenship_Statses_US_Temporary Residence');

		INSERT INTO @CITIZENSHIP_INFO VALUES('AU','Citizen','Citizen','Citizenship_Statses_AU_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BD','Citizen','Citizen','Citizenship_Statses_BD_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('CN','Citizen','Citizen','Citizenship_Statses_CN_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HK','Citizen','Citizen','Citizenship_Statses_HK_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ID','Citizen','Citizen','Citizenship_Statses_ID_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IN','Citizen','Citizen','Citizenship_Statses_IN_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('JP','Citizen','Citizen','Citizenship_Statses_JP_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('KR','Citizen','Citizen','Citizenship_Statses_KR_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MY','Citizen','Citizen','Citizenship_Statses_MY_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NZ','Citizen','Citizen','Citizenship_Statses_NZ_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PH','Citizen','Citizen','Citizenship_Statses_PH_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SG','Citizen','Citizen','Citizenship_Statses_SG_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TH','Citizen','Citizen','Citizenship_Statses_TH_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TW','Citizen','Citizen','Citizenship_Statses_TW_Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('VN','Citizen','Citizen','Citizenship_Statses_VN_Citizen');

		INSERT INTO @CITIZENSHIP_INFO VALUES('CN','Non-Citizen','Non-Citizen','Citizenship_Statses_CN_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('BD','Non-Citizen','Non-Citizen','Citizenship_Statses_BD_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('HK','Non-Citizen','Non-Citizen','Citizenship_Statses_HK_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('ID','Non-Citizen','Non-Citizen','Citizenship_Statses_ID_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('IN','Non-Citizen','Non-Citizen','Citizenship_Statses_IN_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('JP','Non-Citizen','Non-Citizen','Citizenship_Statses_JP_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('KR','Non-Citizen','Non-Citizen','Citizenship_Statses_KR_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('PH','Non-Citizen','Non-Citizen','Citizenship_Statses_PH_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TH','Non-Citizen','Non-Citizen','Citizenship_Statses_TH_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('TW','Non-Citizen','Non-Citizen','Citizenship_Statses_TW_Non-Citizen');
		INSERT INTO @CITIZENSHIP_INFO VALUES('VN','Non-Citizen','Non-Citizen','Citizenship_Statses_VN_Non-Citizen');

		INSERT INTO @CITIZENSHIP_INFO VALUES('AU','Not Permanent Residence','Non-Citizen','Citizenship_Statses_AU_Non-citizen_(Not_Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MY','Not Permanent Residence','Non-Citizen','Citizenship_Statses_MY_Non-citizen_(Not_Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NZ','Not Permanent Residence','Non-Citizen','Citizenship_Statses_NZ_Non-citizen_(Not_Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SG','Not Permanent Residence','Non-Citizen','Citizenship_Statses_SG_Non-citizen_(Not_Permanent_Residence)');

		INSERT INTO @CITIZENSHIP_INFO VALUES('AU','Permanent Residence','Non-Citizen','Citizenship_Statses_AU_Non-citizen_(Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('MY','Permanent Residence','Non-Citizen','Citizenship_Statses_MY_Non-citizen_(Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('NZ','Permanent Residence','Non-Citizen','Citizenship_Statses_NZ_Non-citizen_(Permanent_Residence)');
		INSERT INTO @CITIZENSHIP_INFO VALUES('SG','Permanent Residence','Non-Citizen','Citizenship_Statses_SG_Non-citizen_(Permanent_Residence)');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_CITIZENSHIP_INFO;';
		SELECT * INTO DEMOGRAPHICS_CITIZENSHIP_INFO FROM @CITIZENSHIP_INFO


		--SELECT * FROM @CITIZENSHIP_INFO

		DECLARE @POLITICAL_STATUS_LKUP TABLE(
		    COUNTRY_CODE     NVARCHAR(10), 
			HR_CORE_ID       NVARCHAR(10),
			HR_CORE_TEXT     NVARCHAR(200),
			WD_VALUE         NVARCHAR(255) 
		);
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '01','member of Communist Party of China', 'POLITICAL_AFFILIATION_CH_01_Member_of_Communist_Party_of_China');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '02','prep member of Communist Party of China', 'POLITICAL_AFFILIATION_CH_02_Prep_Member_of_Communist_Party_of_China');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '03','China Communist Youth League member', 'POLITICAL_AFFILIATION_CH_03_China_Comumnist_Youth_League_member');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '04','mem/Revolutionary Com. Chinese Kuomintan', 'POLITICAL_AFFILIATION_CH_04_Member/Revolutionary_Com._Chinese_Kuomintan');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '05','member of China Democratic League', 'POLITICAL_AFFILIATION_CH_05_Member_of_China_Democratic_League');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '06','mem/China Demo. National Constru. Assoc.', 'POLITICAL_AFFILIATION_CH_06_Member/China_Demo._National_Constru.Assoc.');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '07','mem/China Assoc. for Promoting Democracy', 'POLITICAL_AFFILIATION_CH_07_Member/China_Assoc._For_Promoting_Democracy');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '08','mem/Chinese peasants'' and Workers'' Democ', 'POLITICAL_AFFILIATION_CH_08_Member/Chinese_peasants''_and_Workers''_Democ');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '09','member of the China Zhi Gong Dang', 'POLITICAL_AFFILIATION_CH_09_Member_of_the_China_Zhi_Gong_Dang');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '10','member of the Jiu San Society', 'POLITICAL_AFFILIATION_CH_10_Member_of_the_Jiu_San_Society');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '11','memeber of Taiwan Democ. Self-Gov League', 'POLITICAL_AFFILIATION_CH_11_Member_of_Taiwan_Democ._Self-Gov_League');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '12','democratic personage without party', 'POLITICAL_AFFILIATION_CH_12_Democratic_personage_without_party');
		INSERT INTO @POLITICAL_STATUS_LKUP VALUES('CN', '13','common people', 'POLITICAL_AFFILIATION_CH_13_Common_People');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_POLITICAL_STATUS_LKUP;';
		SELECT * INTO DEMOGRAPHICS_POLITICAL_STATUS_LKUP FROM @POLITICAL_STATUS_LKUP


        DECLARE @RELIGION_LKUP TABLE(
			HR_CORE_ID       NVARCHAR(10),
			COUNTRY_CODE     NVARCHAR(200),
			WD_ID            NVARCHAR(200)
		);
		INSERT INTO @RELIGION_LKUP VALUES('02','ID','Religion_ID_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('02','KR','Religion_KR_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('02','MY','Religion_MY_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('02','PH','Religion_PH_Roman_Catholicism');
		INSERT INTO @RELIGION_LKUP VALUES('02','SG','Religion_SG_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('02','VN','Religion_VN_Roman_Catholicism');

		INSERT INTO @RELIGION_LKUP VALUES('22','BD','Religion_BD_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','ID','Religion_ID_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','IN','Religion_IN_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','MY','Religion_MY_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','PK','Religion_PK_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','SG','Religion_SG_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','TH','Religion_TH_Hindu');
		INSERT INTO @RELIGION_LKUP VALUES('22','VN','Religion_VN_Hinduism');

		INSERT INTO @RELIGION_LKUP VALUES('24','BD','Religion_BD_Buddhism');
		INSERT INTO @RELIGION_LKUP VALUES('24','ID','Religion_ID_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','IN','Religion_IN_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','KR','Religion_KR_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','MY','Religion_MY_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','PH','Religion_PH_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','SG','Religion_SG_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','TH','Religion_TH_Buddhist');
		INSERT INTO @RELIGION_LKUP VALUES('24','VN','Religion_VN_Buddhism');

		INSERT INTO @RELIGION_LKUP VALUES('29','BD','Religion_BD_Islamic');
		INSERT INTO @RELIGION_LKUP VALUES('29','PK','Religion_PK_Islamic');
		INSERT INTO @RELIGION_LKUP VALUES('29','ID','Religion_ID_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('29','IN','Religion_IN_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('29','MY','Religion_MY_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('29','SG','Religion_SG_Muslim');

		INSERT INTO @RELIGION_LKUP VALUES('30','VN','Religion_VN_Judaism');
		
		INSERT INTO @RELIGION_LKUP VALUES('31','PH','Religion_PH_Muslim');		
		INSERT INTO @RELIGION_LKUP VALUES('31','TH','Religion_TH_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('31','VN','Religion_VN_Islam');
		INSERT INTO @RELIGION_LKUP VALUES('31','ID','Religion_ID_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('31','IN','Religion_IN_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('31','MY','Religion_MY_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('31','SG','Religion_SG_Muslim');

		INSERT INTO @RELIGION_LKUP VALUES('36','ID','Religion_ID_Protestant');
		INSERT INTO @RELIGION_LKUP VALUES('36','KR','Religion_KR_Protestant');
		INSERT INTO @RELIGION_LKUP VALUES('36','PH','Religion_PH_Protestantism');
		INSERT INTO @RELIGION_LKUP VALUES('36','VN','Religion_VN_Protestantism');

		INSERT INTO @RELIGION_LKUP VALUES('91','BD','Religion_BD_Others');
		INSERT INTO @RELIGION_LKUP VALUES('91','KR','Religion_KR_Others');
		INSERT INTO @RELIGION_LKUP VALUES('91','PK','Religion_PK_Others');
		INSERT INTO @RELIGION_LKUP VALUES('91','TH','Religion_TH_Others');
		INSERT INTO @RELIGION_LKUP VALUES('91','VN','Religion_VN_Others');
		INSERT INTO @RELIGION_LKUP VALUES('91','MY','Religion_MY_Other');

		INSERT INTO @RELIGION_LKUP VALUES('92','BD','Religion_BD_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('92','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('92','MY','Religion_MY_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('92','PK','Religion_PK_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('92','SG','Religion_SG_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('92','TH','Religion_TH_Christian');

        INSERT INTO @RELIGION_LKUP VALUES('42','BD','Religion_BD_Islamic');
		INSERT INTO @RELIGION_LKUP VALUES('42','PK','Religion_PK_Islamic');
		INSERT INTO @RELIGION_LKUP VALUES('42','ID','Religion_ID_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','IN','Religion_IN_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','MY','Religion_MY_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','PH','Religion_PH_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','SG','Religion_SG_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','TH','Religion_TH_Muslim');
		INSERT INTO @RELIGION_LKUP VALUES('42','VN','Religion_VN_Islam');

		INSERT INTO @RELIGION_LKUP VALUES('05','ID','Religion_ID_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('05','KR','Religion_KR_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('05','MY','Religion_MY_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('05','PH','Religion_PH_Roman_Catholicism');
		INSERT INTO @RELIGION_LKUP VALUES('05','SG','Religion_SG_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('05','VN','Religion_VN_Roman_Catholicism');

		INSERT INTO @RELIGION_LKUP VALUES('33','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('36','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('20','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('02','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('28','IN','Religion_IN_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('99','IN','');

		INSERT INTO @RELIGION_LKUP VALUES('03','SG','Religion_SG_Christian');

		INSERT INTO @RELIGION_LKUP VALUES('25','MY','Religion_MY_Christian');
		INSERT INTO @RELIGION_LKUP VALUES('12','MY','Religion_MY_Other');
		INSERT INTO @RELIGION_LKUP VALUES('37','MY','Religion_MY_Christian');

		INSERT INTO @RELIGION_LKUP VALUES('92','ID','Religion_ID_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('19','ID','Religion_ID_Catholic');
		INSERT INTO @RELIGION_LKUP VALUES('91','ID','');

		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEMOGRAPHICS_RELIGION_LKUP;';
		SELECT * INTO DEMOGRAPHICS_RELIGION_LKUP FROM @RELIGION_LKUP

		--SELECT * INTO WAVE_NMGOLD_RELIGION_LKUP FROM @RELIGION_LKUP
		--SELECT DISTINCT KONFE FROM WAVE_NMGOLD_PA0002 WHERE BEGDA <= CAST('2020-10-11' AS DATE) AND ENDDA >= CAST('2020-10-11' AS DATE) AND 
		--(KONFE NOT IN (SELECT HR_CORE_ID FROM WAVE_NMGOLD_RELIGION_LKUP)) AND PERNR like '%40%'

		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_PA0002;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0002 FROM '+@which_wavestage+'_PA0002 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0002', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0077;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0077 FROM '+@which_wavestage+'_PA0077 WHERE endda >= '''+@which_date+'''	and begda <= '''+@which_date+''';';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0077', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0094;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0094 FROM '+@which_wavestage+'_PA0094 WHERE endda >= '''+@which_date+'''	and begda <= '''+@which_date+''';';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0094', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0529;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0529 FROM '+@which_wavestage+'_PA0529 WHERE  endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0529', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW
				  FROM (SELECT * 
						  FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
									 FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
						  WHERE a.RNK=1) a
				  WHERE ISNULL([Emp - group], '''') <> ''4'''
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	    /* Info Type Vetren Status */
		--SELECT * FROM WAVE_NM_PA0077
		--DECLARE @which_date AS VARCHAR(20)='2020-10-02';
		--DECLARE @SQL AS VARCHAR(2000)='';
		PRINT 'Vetren Status'
        DECLARE @INFO_TYPE_VETREN_STATUS TABLE(
		    PERNR            NVARCHAR(30),
			VETREN           NVARCHAR(10),
			RANK_ID          int
		);
		INSERT INTO @INFO_TYPE_VETREN_STATUS 
		   SELECT * FROM (
		   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 1, 'ID') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
		      WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
		   UNION ALL 
		   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 2, 'ID') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
		      WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
		    UNION ALL 
		   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 3, 'ID') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
		      WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
           UNION ALL  
		   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 4, 'ID') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
		      WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
		   UNION ALL  
		   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 5, 'ID') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
		      WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
		) A1

		SET @SQL='drop table if exists INFO_TYPE_VETREN_STATUS;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SELECT * INTO INFO_TYPE_VETREN_STATUS FROM @INFO_TYPE_VETREN_STATUS
		DELETE FROM INFO_TYPE_VETREN_STATUS WHERE VETREN=''

		UPDATE A2 SET RANK_ID=A1.RNK
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERNR ORDER BY PERNR, VETREN) RNK FROM INFO_TYPE_VETREN_STATUS) A1 JOIN @INFO_TYPE_VETREN_STATUS A2 
		   ON A1.PERNR=A2.PERNR AND A1.VETREN=A2.VETREN

		DECLARE @VETREN_STATUS_TRANSPOSED TABLE (
			  PERNR             NVARCHAR(255),

			  VETREN_1           NVARCHAR(255),
			  VETREN_2           NVARCHAR(255),
			  VETREN_3           NVARCHAR(255),
			  VETREN_4           NVARCHAR(255),
			  VETREN_5           NVARCHAR(255)
		)

		;WITH CTE_Rank AS
		(
		SELECT [PERNR]
			  ,[VETREN]
			  ,sVETREN='VETREN_' + CAST(RANK_ID AS VARCHAR(200))
		FROM @INFO_TYPE_VETREN_STATUS
		)
		INSERT INTO @VETREN_STATUS_TRANSPOSED
		SELECT PERNR

			  ,VETREN_1 = MAX(ISNULL(VETREN_1, ''))
			  ,VETREN_2 = MAX(ISNULL(VETREN_2, ''))
			  ,VETREN_3 = MAX(ISNULL(VETREN_3, ''))
			  ,VETREN_4 = MAX(ISNULL(VETREN_4, ''))
			  ,VETREN_5 = MAX(ISNULL(VETREN_5, ''))
		FROM CTE_Rank AS R
			  PIVOT(MAX(VETREN) FOR sVETREN IN ([VETREN_1], [VETREN_2], [VETREN_3], [VETREN_4], [VETREN_5])) VETREN
		GROUP BY PERNR

	    /* Info Type Vetren Type */
		PRINT 'Vetren Type'
        DECLARE @INFO_TYPE_VETREN_TYPE TABLE(
		    PERNR            NVARCHAR(30),
			VETREN           NVARCHAR(10),
			RANK_ID          int
		);
		INSERT INTO @INFO_TYPE_VETREN_TYPE 
		   SELECT DISTINCT * FROM (
			   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 1, 'TYPE') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 2, 'TYPE') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 3, 'TYPE') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 4, 'TYPE') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL 
			   SELECT PERNR, dbo.[ArrangeVetrenStatus](VETS1, VETS2, VETS3, VETS4, VETS5, VETS6, VETS7, VETS8, VETS9, VETS10, VETS11, VETS12, YYVETS01, 5, 'TYPE') VETREN, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
        ) A1

		SET @SQL='drop table if exists INFO_TYPE_VETREN_TYPE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SELECT DISTINCT * INTO INFO_TYPE_VETREN_TYPE FROM @INFO_TYPE_VETREN_TYPE
		DELETE FROM INFO_TYPE_VETREN_TYPE WHERE VETREN=''
		--SELECT * FROM INFO_TYPE_VETREN_TYPE

		UPDATE A2 SET RANK_ID=A1.RNK
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERNR ORDER BY PERNR, VETREN) RNK FROM INFO_TYPE_VETREN_TYPE) A1 JOIN @INFO_TYPE_VETREN_TYPE A2 
		   ON A1.PERNR=A2.PERNR AND A1.VETREN=A2.VETREN
		--SELECT * FROM @INFO_TYPE_VETREN_TYPE WHERE VETREN <> '' ORDER BY PERNR

		DECLARE @VETREN_TYPE_TRANSPOSED TABLE (
			  PERNR             NVARCHAR(255),

			  VETREN_1           NVARCHAR(255),
			  VETREN_2           NVARCHAR(255),
			  VETREN_3           NVARCHAR(255),
			  VETREN_4           NVARCHAR(255),
			  VETREN_5           NVARCHAR(255)
		)

		;WITH CTE_Rank AS
		(
		SELECT [PERNR]
			  ,[VETREN]
			  ,sVETREN='VETREN_' + CAST(RANK_ID AS VARCHAR(200))
		FROM @INFO_TYPE_VETREN_TYPE
		)
		INSERT INTO @VETREN_TYPE_TRANSPOSED
		SELECT PERNR

			  ,VETREN_1 = MAX(ISNULL(VETREN_1, ''))
			  ,VETREN_2 = MAX(ISNULL(VETREN_2, ''))
			  ,VETREN_3 = MAX(ISNULL(VETREN_3, ''))
			  ,VETREN_4 = MAX(ISNULL(VETREN_4, ''))
			  ,VETREN_5 = MAX(ISNULL(VETREN_5, ''))
		FROM CTE_Rank AS R
			  PIVOT(MAX(VETREN) FOR sVETREN IN ([VETREN_1], [VETREN_2], [VETREN_3], [VETREN_4], [VETREN_5])) VETREN
		GROUP BY PERNR
			
	    /* Info Type Ethnicity */
		PRINT 'Ethnicity'
		--SELECT DISTINCT Ethnicities FROM WAVE_NMGOLD_Malaysia_Corrections
        DECLARE @INFO_TYPE_ETHNICITY TABLE(
		    PERNR            NVARCHAR(30),
			CC               NVARCHAR(30), 
			RACKY            NVARCHAR(10),
			RANK_ID          int
		);
		INSERT INTO @INFO_TYPE_ETHNICITY 
		   SELECT DISTINCT * FROM (
			   SELECT PERNR, '' CC, RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE) AND RACKY IS NOT NULL
			   UNION ALL
			   SELECT PERNR, '' CC, RACKY, 0 RANK_ID FROM WAVE_NM_PA0529 WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE) AND RACKY IS NOT NULL
			   UNION ALL
			   SELECT PERNR, '' CC, dbo.[ArrangeRaceValue](RAC01, RAC02, RAC03, RAC04, RAC05, RAC06, RAC07, RAC08, RAC09, RAC10, 1) RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, '' CC, dbo.[ArrangeRaceValue](RAC01, RAC02, RAC03, RAC04, RAC05, RAC06, RAC07, RAC08, RAC09, RAC10, 2) RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, '' CC, dbo.[ArrangeRaceValue](RAC01, RAC02, RAC03, RAC04, RAC05, RAC06, RAC07, RAC08, RAC09, RAC10, 3) RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL
			   SELECT PERNR, '' CC, dbo.[ArrangeRaceValue](RAC01, RAC02, RAC03, RAC04, RAC05, RAC06, RAC07, RAC08, RAC09, RAC10, 4) RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
			   UNION ALL 
			   SELECT PERNR, '' CC, dbo.[ArrangeRaceValue](RAC01, RAC02, RAC03, RAC04, RAC05, RAC06, RAC07, RAC08, RAC09, RAC10, 5) RACKY, 0 RANK_ID FROM WAVE_NM_PA0077 
				  WHERE BEGDA <=CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)
        ) A1

		UPDATE A2 SET A2.CC=A1.[GEO - WORK COUNTRY]
		   FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] A1 JOIN @INFO_TYPE_ETHNICITY A2 ON A1.[Emp - Personnel Number]=A2.PERNR

		SET @SQL='drop table if exists WAVE_NM_INFO_TYPE_ETHNICITY;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SELECT * INTO WAVE_NM_INFO_TYPE_ETHNICITY FROM @INFO_TYPE_ETHNICITY
		DELETE FROM WAVE_NM_INFO_TYPE_ETHNICITY WHERE RACKY=''
		--SELECT * FROM WAVE_NM_INFO_TYPE_ETHNICITY

		SET @SQL='drop table if exists INFO_TYPE_ETHNICITY;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SELECT * INTO INFO_TYPE_ETHNICITY FROM @INFO_TYPE_ETHNICITY
		DELETE FROM INFO_TYPE_ETHNICITY WHERE RACKY=''

		UPDATE A2 SET RANK_ID=A1.RNK
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERNR ORDER BY PERNR, RACKY) RNK FROM INFO_TYPE_ETHNICITY) A1 JOIN @INFO_TYPE_ETHNICITY A2
		     ON A1.PERNR=A2.PERNR AND A1.RACKY=A2.RACKY
		--SELECT * FROM @INFO_TYPE_ETHNICITY WHERE RACKY <> '' ORDER BY PERNR

		DECLARE @RACKY_TRANSPOSED TABLE (
			  PERNR             NVARCHAR(255),

			  RACKY_1           NVARCHAR(255),
			  RACKY_2           NVARCHAR(255),
			  RACKY_3           NVARCHAR(255),
			  RACKY_4           NVARCHAR(255),
			  RACKY_5           NVARCHAR(255)
		)

		;WITH CTE_Rank AS
		(
		SELECT [PERNR]
			  ,[RACKY]
			  ,sRACKY='RACKY_' + CAST(RANK_ID AS VARCHAR(200))
		FROM @INFO_TYPE_ETHNICITY
		)
		INSERT INTO @RACKY_TRANSPOSED
		SELECT PERNR

			  ,RACKY_1 = MAX(ISNULL(RACKY_1, ''))
			  ,RACKY_2 = MAX(ISNULL(RACKY_2, ''))
			  ,RACKY_3 = MAX(ISNULL(RACKY_3, ''))
			  ,RACKY_4 = MAX(ISNULL(RACKY_4, ''))
			  ,RACKY_5 = MAX(ISNULL(RACKY_5, ''))
		FROM CTE_Rank AS R
			  PIVOT(MAX(RACKY) FOR sRACKY IN ([RACKY_1], [RACKY_2], [RACKY_3], [RACKY_4], [RACKY_5])) RACKY
		GROUP BY PERNR
		SELECT * FROM @INFO_TYPE_ETHNICITY WHERE PERNR='10002247'
		SELECt * FROM @RACKY_TRANSPOSED WHERE ISNULL(RACKY_2, '') <> '' ORDER BY PERNR 

		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW
				  FROM (SELECT * 
						  FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
									 FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
						  WHERE a.RNK=1) a
				  WHERE ISNULL([Emp - group], '''') <> ''4'''
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		DECLARE @DEMOGRAPHICS_INFO TABLE(
			[Legacy System ID]                                   VARCHAR(200), 
			[Employee ID]                                        VARCHAR(200),
			[PERNR]                                              VARCHAR(200),
			[Worker Type]                                        VARCHAR(200),
			[Applicant ID]                                       VARCHAR(200),
			[Marital Status]                                     VARCHAR(200),
			[Marital Status ID]                                  VARCHAR(200),
			[Marital Status Date]                                VARCHAR(200), 
			[Hispanic or Latino]                                 VARCHAR(200),
			[Ethnicity Desc 01]                                  VARCHAR(200),
			[Ethnicity Id 01]                                    VARCHAR(200),
			[Ethnicity Desc 02]                                  VARCHAR(200),
			[Ethnicity Id 02]                                    VARCHAR(200),
			[Ethnicity Desc 03]                                  VARCHAR(200),
			[Ethnicity Id 03]                                    VARCHAR(200),
			[Hispanic or Latino 2]                               VARCHAR(200), 
			[Ethnicity Desc 2]                                   VARCHAR(200), 
			[Ethnicity Id 2]                                     VARCHAR(200), 
			[LGBT ID]                                            VARCHAR(200),
			[Citizenship Status Without Hidden]                  VARCHAR(200),
			[Citizenship Status]                                 VARCHAR(200),
			[Citizenship Status ID]                              VARCHAR(200),                                           
			[Nationality]                                        VARCHAR(200),
			[Nationality ID]                                     VARCHAR(200),
			[Religion]                                           VARCHAR(200),
			[Religion ID]                                        VARCHAR(200),
			[Hukou Region]                                       VARCHAR(200),
			[Hukou Region ID]                                    VARCHAR(200),
			[Hukou Sub Region]                                   VARCHAR(200),
			[Hukou Sub Region ID]                                VARCHAR(200),
			[Hukou Locality]                                     VARCHAR(200),
			[Hukou Postal Code]                                  VARCHAR(200),
			[Hukou Type]                                         VARCHAR(200),
			[Hukou Type ID]                                      VARCHAR(200),
			[Native Region]                                      VARCHAR(200),
			[Native Region ID]                                   VARCHAR(200),
			[Personnel File Agency]                              VARCHAR(200),
			[Military Service]                                   VARCHAR(200),
			[Military Service ID]                                VARCHAR(200),
			[Military Status]                                    VARCHAR(200), 
			[Military Status ID]                                 VARCHAR(200),
			[Military Discharge Dt]                              VARCHAR(200),
			[Military Status Begin Date]                         VARCHAR(200),
			[Service Type]                                       VARCHAR(200),
			[Service Type ID]                                    VARCHAR(200),
			[Military Rank]                                      VARCHAR(200),
			[Military Rank ID]                                   VARCHAR(200),
			[Service Notes]                                      VARCHAR(200),
			[US Veteran Status 01]                               VARCHAR(200),
			[US Veteran Status ID 01]                            VARCHAR(200),
			[US Veteran Status 02]                               VARCHAR(200),
			[US Veteran Status ID 02]                            VARCHAR(200),
			[US Veteran Status 03]                               VARCHAR(200),
			[US Veteran Status ID 03]                            VARCHAR(200),
			[US Veteran Status 04]                               VARCHAR(200),
			[US Veteran Status ID 04]                            VARCHAR(200),
			[US Veteran Status 05]                               VARCHAR(200),
			[US Veteran Status ID 05]                            VARCHAR(200),
			[US Protected Veteran Status Type 01]                VARCHAR(200),
			[US Protected Veteran Status Type ID 01]             VARCHAR(200),
			[US Protected Veteran Status Type 02]                VARCHAR(200),
			[US Protected Veteran Status Type ID 02]             VARCHAR(200),
			[US Protected Veteran Status Type 03]                VARCHAR(200),
			[US Protected Veteran Status Type ID 03]             VARCHAR(200),
			[US Protected Veteran Status Type 04]                VARCHAR(200),
			[US Protected Veteran Status Type ID 04]             VARCHAR(200),
			[US Protected Veteran Status Type 05]                VARCHAR(200),
			[US Protected Veteran Status Type ID 05]             VARCHAR(200),
			[Military Discharge Dt 1]                            VARCHAR(200),
			[Additional Nationality 1]                           VARCHAR(200),
			[Additional Nationality ID 1]                        VARCHAR(200),
			[Additional Nationality 2]                           VARCHAR(200),
			[Additional Nationality ID 2]                        VARCHAR(200),
			[Political Affiliation]                              VARCHAR(200),
			[Political Affiliation ID]                           VARCHAR(200),
			[LGBT ID 1]                                          VARCHAR(200),
			[Social Benefits Locality]                           VARCHAR(200),
			[Social Benefits Locality ID]                        VARCHAR(200),
			[VETS1]                                              VARCHAR(200),
			[VETS2]                                              VARCHAR(200),
			[VETS3]                                              VARCHAR(200),
			[VETS4]                                              VARCHAR(200),
			[VETS5]                                              VARCHAR(200),
			[VETS6]                                              VARCHAR(200),
			[VETS7]                                              VARCHAR(200),
			[VETS8]                                              VARCHAR(200),
			[VETS9]                                              VARCHAR(200),
			[VETS10]                                             VARCHAR(200),
			[VETS11]                                             VARCHAR(200),
			[VETS12]                                             VARCHAR(200),
			[YYVETS01]                                           VARCHAR(200),
			[ISO2]                                               VARCHAR(200),    
			[ISO3]                                               VARCHAR(200),
			[Citizenship Status (Worker)]                        VARCHAR(200),
			[Geo - Work Country]                                 VARCHAR(200),
			[Emp - SubGroup]                                     VARCHAR(200) 
		);

		PRINT 'Demographic Automation Starts'
		INSERT INTO @DEMOGRAPHICS_INFO
		SELECT [Employee ID] AS [Legacy System ID], * FROM (
			SELECT  a.[PERSNO_NEW] [Employee ID]
			        ,a.[Emp - Personnel Number] PERNR
					,ISNULL(a.[WD_emp_type], '') [Worker Type]
					,a.[Emp - Personnel Number]  [Applicant ID]
					,IIF(g.[Marital Status (Worker)]='Hidden', '', 
					     ISNULL((SELECT TOP 1 WD_ID FROM @MARITAL_STATUS_INFO 
						            WHERE HR_CORE_ID=b.FAMST AND 
									      ((a.[Geo - Work Country]='HK' AND COUNTRY_CODE2=a.[Geo - Country (CC)]) OR (a.[Geo - Work Country]<>'HK' AND COUNTRY_CODE2=a.[Geo - Work Country])) AND 
										    b.FAMST IS NOT NULL), '')) [Marital Status]
					,'' [Marital Status ID]
					,IIF(g.[Marital Status (Worker)]='Hidden', '', 
					      IIF(ISNULL(b.FAMDT, '00000000')='00000000', '',CAST(CONVERT(varchar(10), CAST(b.FAMDT as date), 101) AS VARCHAR(15)))) [Marital Status Date]
					,IIF(g.[Hispanic/Latino (Worker)]='Hidden', '', IIF(c.ETHEN='E1','Y', IIF(c.ETHEN='E2','N', ''))) [Hispanic or Latino] 
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_1=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Desc 01]
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_1=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Id 01]
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_2=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Desc 02]
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_2=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Id 02]
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_3=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Desc 03]
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', 
                                ISNULL((SELECT TOP 1 WD_ID FROM @ETHNICITY_LKUP ETHI WHERE e.RACKY_3=ETHI.HR_CORE_ID AND a.[GEO - COUNTRY (CC)]=ETHI.CC), '')) [Ethnicity Id 03]
					,IIF(g.[Hispanic/Latino (Worker)]='Hidden', '', '') [Hispanic or Latino 2] 
					,'' [Ethnicity Desc 2] 
					,IIF(g.[Race/Ethnicity (Worker)]='Hidden', '', '') [Ethnicity Id 2] 
					,'' [LGBT ID]
					,IIF((ISNULL(b.NATIO, 'UN') <> 'UN' AND b.NATIO=a.[Geo - Country (CC)]),
							  ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), 
								IIF((ISNULL(b.NATIO, 'UN')='UN' OR b.NATIO<>a.[Geo - Country (CC)]), 
									ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE (CITIZEN_STATUS='Non Citizen' OR CITIZEN_STATUS='Non-Citizen') AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), '')) [Citizenship Status Without Hidden]
					,IIF((g.[Citizenship Status (Worker)]='Hidden'), '',
					    IIF(a.[Geo - Country (CC)] IN ('CA', 'US'), 
							IIF(d.RESIS='C', ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), 
								IIF(d.RESIS='N', ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Non Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), 
									IIF(b.NATIO=a.[Geo - Country (CC)],
										ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), 
											IIF((b.NATIO='UN' OR ISNULL(b.NATIO, '')=''), '',
												ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Non Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''))))), 					 										 
							 IIF((ISNULL(b.NATIO, 'UN') <> 'UN' AND b.NATIO=a.[Geo - Country (CC)]),
								  ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE CITIZEN_STATUS='Citizen' AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), 
									IIF((ISNULL(b.NATIO, 'UN')='UN' OR b.NATIO<>a.[Geo - Country (CC)]), 
										ISNULL((SELECT TOP 1 WD_ID FROM @CITIZENSHIP_INFO WHERE (CITIZEN_STATUS='Non Citizen' OR CITIZEN_STATUS='Non-Citizen') AND COUNTRY_CODE=a.[Geo - Country (CC)]), ''), '')))) [Citizenship Status]
					,'Invalid Value' [Citizenship Status ID]                                           
					,IIF(g.[Primary Nationality (Worker)]='Hidden', '', 
					       ISNULL((SELECT TOP 1 [Country Code] FROM COUNTRY_LKUP WHERE [Country2 Code]=b.NATIO), '')) [Nationality]
					,'Invalid Value' [Nationality ID]
					,IIF([Religion (Worker)]='Hidden', '', 
					     ISNULL((SELECT TOP 1 WD_ID FROM @RELIGION_LKUP WHERE HR_CORE_ID=ISNULL(b.KONFE, '') AND COUNTRY_CODE=a.[Geo - Work Country]), '')) [Religion]
					--,IIF([Religion (Worker)]='Hidden', '', ISNULL(b.KONFE, '')) [Religion ID]
					,IIF([Religion (Worker)]='Hidden', '', '') [Religion ID]                -- Temporary fix(Hitesh should give info. This is only for Wave 4.)
					,'' [Hukou Region]
					,'' [Hukou Region ID]
					,'' [Hukou Sub Region]
					,'' [Hukou Sub Region ID]
					,'' [Hukou Locality]
					,'' [Hukou Postal Code]
					,'' [Hukou Type]
					,'' [Hukou Type ID]
					,'' [Native Region]
					,'' [Native Region ID]
					,'' [Personnel File Agency]
					,'' [Military Service]
					,'' [Military Service ID]
					,IIF(g.[Military Service (Worker)]='Hidden', '', ISNULL((SELECT TOP 1 (MSI.COUNTRY_NAME+ ' ' + MSI.TEXT_VALUE) 
							 FROM @MILITARY_STATUS_INFO MSI 
							 WHERE MSI.MILSA=c.MILSA AND a.[Geo - Country (CC)]=MSI.[COUNTRY2_CODE]), '')) [Military Status]
					,'' [Military Status ID]
					,'' [Military Discharge Dt]
					,IIF(IIF(g.[Military Service (Worker)]='Hidden', '', ISNULL((SELECT TOP 1 (MSI.COUNTRY_NAME+ ' ' + MSI.TEXT_VALUE) 
							 FROM @MILITARY_STATUS_INFO MSI 
							 WHERE MSI.MILSA=c.MILSA AND a.[Geo - Country (CC)]=MSI.[COUNTRY2_CODE]), ''))='', '',
					      IIF(ISNULL(c.BEGDA, '1900/01/01')='1900/01/01', '', Convert(VARCHAR(10), CAST(c.BEGDA AS DATE), 101))) [Military Status Begin Date]
					,'' [Service Type]
					,'' [Service Type ID]
					,'' [Military Rank]
					,'' [Military Rank ID]
					,'' [Service Notes]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=j.VETREN_1) AND VETREN_STATUS='ID'), '') [US Veteran Status 01]                                                             -- Check with Hitesh
					,'' [US Veteran Status ID 01]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=j.VETREN_2) AND VETREN_STATUS='ID'), '') [US Veteran Status 02]                                                             -- Check with Hitesh
					,'' [US Veteran Status ID 02]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=j.VETREN_3) AND VETREN_STATUS='ID'), '') [US Veteran Status 03]                                                             -- Check with Hitesh
					,'' [US Veteran Status ID 03]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=j.VETREN_4) AND VETREN_STATUS='ID'), '') [US Veteran Status 04]                                                             -- Check with Hitesh
					,'' [US Veteran Status ID 04]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=j.VETREN_5) AND VETREN_STATUS='ID'), '') [US Veteran Status 05]                                                             -- Check with Hitesh
					,'' [US Veteran Status ID 05]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=k.VETREN_1) AND VETREN_STATUS='TYPE'), '') [US Protected Veteran Status Type 01]                                      -- Check with Hitesh
					,'' [US Protected Veteran Status Type ID 01]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=k.VETREN_2) AND VETREN_STATUS='TYPE'), '') [US Protected Veteran Status Type 02]                                      -- Check with Hitesh
					,'' [US Protected Veteran Status Type ID 02]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=k.VETREN_3) AND VETREN_STATUS='TYPE'), '') [US Protected Veteran Status Type 03]                                      -- Check with Hitesh
					,'' [US Protected Veteran Status Type ID 03]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=k.VETREN_4) AND VETREN_STATUS='TYPE'), '') [US Protected Veteran Status Type 04]                                      -- Check with Hitesh
					,'' [US Protected Veteran Status Type ID 04]
					,ISNULL((SELECT TOP 1 WD_ID FROM @VETREN_STATUS_INFO WHERE (VETREN_CODE=k.VETREN_5) AND VETREN_STATUS='TYPE'), '') [US Protected Veteran Status Type 05]                                      -- Check with Hitesh
					,'' [US Protected Veteran Status Type ID 05]
					,IIF(ISNULL(c.DCRDT, '00000000')='00000000', '',CAST(CONVERT(varchar(10), CAST(c.DCRDT as date), 101) AS VARCHAR(15))) [Military Discharge Dt 1]
					,IIF(g.[Additional Nationalities (Worker)]='Hidden', '', ISNULL(b.NATI2, '')) [Additional Nationality 1]
					,'' [Additional Nationality ID 1]
					,IIF(g.[Additional Nationalities (Worker)]='Hidden', '', ISNULL(b.NATI3, '')) [Additional Nationality 2]
					,'' [Additional Nationality ID 2]
					,IIF([Political Affiliation (Worker)]='Hidden', '', 
					     ISNULL((SELECT TOP 1 WD_VALUE FROM @POLITICAL_STATUS_LKUP WHERE HR_CORE_ID=ISNULL(i.PCODE, '')), '')) [Political Affiliation]
                    ,'' [Political Affiliation ID]
					,'' [LGBT ID 1]
					,'' [Social Benefits Locality]
					,'' [Social Benefits Locality ID]
					,c.[VETS1]
					,c.[VETS2]
					,c.[VETS3]
					,c.[VETS4]
					,c.[VETS5]
					,c.[VETS6]
					,c.[VETS7]
					,c.[VETS8]
					,c.[VETS9]
					,c.[VETS10]
					,c.[VETS11]
					,c.[VETS12]
					,c.[YYVETS01]
					,g.[Country2 Code]
					,g.[Country Code]
					,g.[Citizenship Status (Worker)]
					,a.[Geo - Work Country]
					,a.[Emp - SubGroup]
			FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] a 
			    LEFT JOIN (SELECT DISTINCT * FROM WAVE_NM_PA0002 WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)) b ON a.[Emp - Personnel Number]=b.PERNR
				LEFT JOIN (SELECT DISTINCT * FROM WAVE_NM_PA0077 WHERE BEGDA <= @which_date AND ENDDA >= @which_date) c ON a.[Emp - Personnel Number]=c.PERNR
				LEFT JOIN (SELECT DISTINCT * FROM WAVE_NM_PA0094 WHERE BEGDA <= @which_date AND ENDDA >= @which_date) d ON a.[Emp - Personnel Number]=d.PERNR
				LEFT JOIN (SELECT DISTINCT * FROM WAVE_NM_PA0529 WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)) i ON a.[Emp - Personnel Number]=i.PERNR
				LEFT JOIN [WAVE_ALL_FIELDS_VALIDATION] g ON a.[Geo - Work Country]=g.[Country2 Code]
				LEFT JOIN @RACKY_TRANSPOSED e  ON a.[Emp - Personnel Number]=e.[PERNR]
				LEFT JOIN @VETREN_STATUS_TRANSPOSED j  ON a.[Emp - Personnel Number]=j.[PERNR]
				LEFT JOIN @VETREN_TYPE_TRANSPOSED k  ON a.[Emp - Personnel Number]=k.[PERNR]
		) z

		--SELECT * FROM @DEMOGRAPHICS_INFO WHERE [Geo - Work Country] IN ('RU', 'LV', 'LB', 'BH', 'KW', 'QA', 'JO', 'OM', 'UZ', 'BH', 'KW', 'QA', 'SD') ORDER BY [Employee ID]

		/* Marital status date should be empty if Marital Status is empty */
		UPDATE @DEMOGRAPHICS_INFO SET [Marital Status Date]='' WHERE [Marital Status]='' AND [Marital Status Date] <> ''

		--SELECT * FROM W2_VALIDATION_CHECK_LIST
		--SELECT * FROM VALIDATION_LIST_DEMOGRAPHICS
		--SELECT * FROM WAVE_ALL_FIELD_VALIDATION
		--SELECT [emp - Personnel Number], [Geo - Country (CC)], [Geo - Work Country] FROM W4_P1_POSITION_MANAGEMENT WHERE [EMP - PERSONNEL NUMBER]='46903812'
		--SELECT [emp - Personnel Number], [Geo - Country (CC)] FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] WHERE ISNULL([Geo - Country (CC)], '') = 'PL'
		--SELECT * FROM WAVE_ALL_FIELD_VALIDATION WHERe [Country Code]='EGY'
		--SELECT DISTINCT PERNR, MILSA FROM W4_P2_PA0077
		--SELECT DISTINCT A2.[GEO - WORK COUNTRY], A2.[Geo - Country (CC)], A3.[Citizenship Status (Worker)] FROM @DEMOGRAPHICS_INFO A1 
		--   LEFt JOIN [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] A2 ON A1.[Employee ID]=A2.[Emp - Personnel Number]
		--   LEFT JOIN (SELECT DISTINCT f.*, b.[Country2 Code] FROM VALIDATION_LIST_DEMOGRAPHICS f, W4_COUNTRY_LKUP b WHERE f.[Country Code]=b.[Country Code]) A3 ON A2.[Geo - Work Country]=A3.[Country2 Code]
		--WHERE [Citizenship Status] = ''

		/* Validating Demographic Resultset */
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET;';
		SELECT * INTO WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET FROM @DEMOGRAPHICS_INFO


		/********** Demograpics Resultset **************/
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_DEMOGRAPHICS';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SELECT 			
		     [Legacy System ID]
			,[Employee ID]
			,[Worker Type]
			,[Applicant ID]
			,[Marital Status]
			,[Marital Status ID]
			,[Marital Status Date]
			,[Hispanic or Latino]
			,[Ethnicity Desc 01]
			,[Ethnicity Id 01]
			,[Ethnicity Desc 02]
			,[Ethnicity Id 02]
			,[Ethnicity Desc 03]
			,[Ethnicity Id 03]
			,[LGBT ID]
			,[Citizenship Status]
			,[Citizenship Status ID]
			,[Nationality]
			,[Nationality ID]
			,[Religion]
			,[Religion ID]
			,[Hukou Region]
			,[Hukou Region ID]
			,[Hukou Sub Region]
			,[Hukou Sub Region ID]
			,[Hukou Locality]
			,[Hukou Postal Code]
			,[Hukou Type]
			,[Hukou Type ID]
			,[Native Region]
			,[Native Region ID]
			,[Personnel File Agency]
			,[Military Service]
			,[Military Service ID]
			,[Military Status]
			,[Military Status ID]
			,[Military Discharge Dt]
			,[Military Status Begin Date]
			,[Service Type]
			,[Service Type ID]
			,[Military Rank]
			,[Military Rank ID]
			,[Service Notes]
			,[US Veteran Status 01]
			,[US Veteran Status ID 01]
			,[US Veteran Status 02]
			,[US Veteran Status ID 02]
			,[US Veteran Status 03]
			,[US Veteran Status ID 03]
			,[US Veteran Status 04]
			,[US Veteran Status ID 04]
			,[US Veteran Status 05]
			,[US Veteran Status ID 05]
			,[US Protected Veteran Status Type 01]
			,[US Protected Veteran Status Type ID 01]
			,[US Protected Veteran Status Type 02]
			,[US Protected Veteran Status Type ID 02]
			,[US Protected Veteran Status Type 03]
			,[US Protected Veteran Status Type ID 03]
			,[US Protected Veteran Status Type 04]
			,[US Protected Veteran Status Type ID 04]
			,[US Protected Veteran Status Type 05]
			,[US Protected Veteran Status Type ID 05]
			,[Military Discharge Dt 1]
			,[Additional Nationality 1]
			,[Additional Nationality ID 1]
			,[Additional Nationality 2]
			,[Additional Nationality ID 2] 
			,[Political Affiliation]
			,[Political Affiliation ID]
			,[LGBT ID 1]
			,[Social Benefits Locality]
			,[Social Benefits Locality ID]
			,[Geo - Work Country]
      INTO WD_HR_TR_AUTOMATED_DEMOGRAPHICS 
	  FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET
	  WHERE (
			[Marital Status] <> '' OR
			[Marital Status ID] <> '' OR
			[Marital Status Date] <> '' OR
			[Hispanic or Latino] <> '' OR
			[Ethnicity Desc 01] <> '' OR
			[Ethnicity Id 01] <> '' OR
			[Hispanic or Latino 2] <> '' OR
			[Ethnicity Desc 2] <> '' OR
			[Ethnicity Id 2] <> '' OR
			[LGBT ID] <> '' OR
			[Citizenship Status] <> '' OR
			([Citizenship Status ID] <> '' AND [Citizenship Status ID] <> 'Invalid Value') OR
			[Nationality] <> '' OR
			([Nationality ID] <> '' AND [Nationality ID] <> 'Invalid Value') OR
			[Religion] <> '' OR
			[Religion ID] <> '' OR
			[Hukou Region] <> '' OR
			[Hukou Region ID] <> '' OR
			[Hukou Sub Region] <> '' OR
			[Hukou Sub Region ID] <> '' OR
			[Hukou Locality] <> '' OR
			[Hukou Postal Code] <> '' OR
			[Hukou Type] <> '' OR
			[Hukou Type ID] <> '' OR
			[Native Region] <> '' OR
			[Native Region ID] <> '' OR
			[Personnel File Agency] <> '' OR
			[Military Service] <> '' OR
			[Military Service ID] <> '' OR
			[Military Status] <> '' OR
			[Military Status ID] <> '' OR
			[Military Discharge Dt] <> '' OR
			[Military Status Begin Date] <> '' OR
			[Service Type] <> '' OR
			[Service Type ID] <> '' OR
			[Military Rank] <> '' OR
			[Military Rank ID] <> '' OR
			[Service Notes] <> '' OR
			[US Veteran Status 01] <> '' OR
			[US Veteran Status ID 01] <> '' OR
			[US Protected Veteran Status Type 01] <> '' OR
			[US Protected Veteran Status Type ID 01] <> '' OR
			[Military Discharge Dt 1] <> '' OR
			[Additional Nationality 1] <> '' OR
			[Additional Nationality ID 1] <> '' OR
			[Additional Nationality 2] <> '' OR
			[Additional Nationality ID 2] <> '' OR
			[Political Affiliation] <> '' OR
			[LGBT ID 1] <> '' OR
			[Social Benefits Locality] <> '' OR
			[Social Benefits Locality ID] <> '')

         /* Emptying Applicant ID */
	     UPDATE WD_HR_TR_AUTOMATED_DEMOGRAPHICS SET [Applicant ID]='';


        /********** Citizenship LKUP using Demographics Resultset **************/
		SET @Table_Name='WAVE_NM_CITIZENSHIP_LKUP';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;
		SELECT [PERNR], [Citizenship Status], [Citizenship Status Without Hidden] INTO WAVE_NM_CITIZENSHIP_LKUP FROM @DEMOGRAPHICS_INFO

		SET @Table_Name=@which_wavestage+'_CITIZENSHIP_LKUP';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SET @SQL='SELECT [PERNR], SUBSTRING([Citizenship Status Without Hidden], LEN([Citizenship Status Without Hidden])-10, 11) [Citizenship], 
		                 IIF(SUBSTRING([Citizenship Status Without Hidden], LEN([Citizenship Status Without Hidden])-10, 11)=''Non-Citizen'', ''Non-Citizen'', ''Citizen'') [Citizenship Status] 
		                    INTO '+@Table_Name+' 
		             FROM WAVE_NM_CITIZENSHIP_LKUP 
					 WHERE ISNULL([Citizenship Status Without Hidden], '''')<> '''''
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		PRINT @SQL;

	   SET @SQL='drop table if exists [WD_HR_TR_Delta_WorkerDemograhicsData];';
	   EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	   SELECT * INTO WD_HR_TR_Delta_WorkerDemograhicsData 
	      FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS 
		  WHERE [Geo - Work Country] IN ('RU', 'LV', 'LB', 'BH', 'KW', 'QA', 'JO', 'OM', 'UZ', 'BH', 'KW', 'QA', 'SD') 
		  ORDER BY [Employee ID]

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

--EXEC PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC 'P0', 'DEMOGRAPHICS', '2021-03-10', 'P0_', 'P0_', 'P0_'
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS ORDER BY [Employee ID]
--EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_DEMOGRAPHIC_ERROR_LIST] 'P0', '2021-03-10'
--SELECT * FROM NOVARTIS_DATA_MIGRATION_DEMOGRAPHICS_VALIDATION ORDER BY [Employee ID]

--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS_RESULTSET WHERE PERNR='10004286'
--SELECT * FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - Personnel Number]='86908606'
--SELECT * FROM WAVE_NM_PA0002 WHERE PERNR='86908606'
--SELECT * FROM WAVE_NM_PA0077 WHERE PERNR='86908606'
--SELECT * FROM WAVE_NM_PA0529 WHERE PERNR='86908606'
--SELECT * FROM WAVE_NM_PA0094 WHERE PERNR='86908606'

--EXEC PROC_WAVE_NMAUTOMATE_DEMOGRAPHIC 'W2_GOLD', 'DEMOGRAPHICS', '2020-06-20', 'W2_GOLD_', 'W2_GOLD_', 'W2_GOLD_' 
--EXEC PROC_WAVE_NMAUTOMATE_DEMOGRAPHIC 'W4_P2', 'DEMOGRAPHICS', '2020-10-02', 'W4_P2_', 'W4_P2_', 'W4_P2_' 
--EXEC PROC_WAVE_NMAUTOMATE_DEMOGRAPHIC 'W4_GOLD', 'DEMOGRAPHICS', '2021-02-14', 'W4_GOLD_', 'W4_GOLD_', 'W4_GOLD_' 
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS ORDER BY [Employee ID]
--SELECT DISTINCT [Citizenship Status] FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERE [Geo - Work Country]='CH' --ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERE [Religion ID] <> '' ORDER BY [Employee ID]
--SELECT * FROM W4_PHONE_VALIDATION ORDEr BY COUNTRY WHERE [COUNTRY CODE] IN ('UZB', 'SDN', 'OMN', 'KWT', 'BHR', 'JOR', 'QAT')
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERE [Geo - Work Country] IN ('RU', 'LV', 'LB', 'BH', 'KW', 'QA', 'JO', 'OM', 'UZ', 'BH', 'KW', 'QA', 'SD') ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERE [Employee ID] IN ('10014279') ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='DEMOGRAPHICS' AND [COUNTRY CODE] IN ('UZB', 'SDN', 'OMN', 'KWT', 'BHR', 'JOR', 'QAT') ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_GOLD' AND [Report Name]='DEMOGRAPHICS' ORDER BY [Employee ID]
--UPDATE WD_HR_TR_AUTOMATED_DEMOGRAPHICS SET [Religion ID]=''
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERE [US Veteran Status 01]='NOT_A_VETERAN' ORDER BY [Employee ID]
--SELECT * FROM W2_GOLD_PA0077 WHERE BEGDA <= '2020-10-02' AND ENDDA >= '2020-10-02' AND PERNR='10003894' --AND VETS2 IS NOT NULL
--SELECT [Emp - Personnel Number], [GEO - Work Country], [Emp - Group]  FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] WHERe [GEO - Work Country]  IN ('Uz', 'SD', 'OM', 'KW', 'BH', 'JO', 'QA')
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERe [Employee ID] IN (SELECT [PERSNO_NEW] FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] WHERe [GEO - Work Country]  IN ('Uz', 'SD', 'OM', 'KW', 'BH', 'JO', 'QA')) ORDEr BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEMOGRAPHICS WHERe [Employee ID] IN (SELECT [PERSNO_NEW] FROM [WAVE_NM_POSITION_MANAGEMENT_HOME_WITHOUT_OOW] WHERe [GEO - Work Country]  IN ('SA')) ORDEr BY [Employee ID]
