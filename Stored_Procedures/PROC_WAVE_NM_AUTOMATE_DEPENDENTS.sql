USE [Prod_DataClean]
GO

/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_DEPENDENTS]    Script Date: 10/02/2020 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Subramanian.C>
-- =============================================
IF OBJECT_ID('dbo.CheckNationalIdType') IS NOT NULL
  DROP FUNCTION CheckNationalIdType
GO
CREATE FUNCTION CheckNationalIdType(
   @COUNC                VARCHAR(10),
   @ICTYPE               VARCHAR(10),
   @ICNUM                NVARCHAR(500),
   @TYPE                 VARCHAR(20)
)  
RETURNS NVARCHAR(500)  
BEGIN  
    DECLARE @RESULT     AS NVARCHAR(500)='';
	DECLARE @PATTERN    AS NVARCHAR(500)='';
	DECLARE @FORMAT     AS NVARCHAR(500)='';
	IF (@TYPE='ERROR')
	BEGIN
	    IF (@COUNC <> '' AND (@ICTYPE='' OR @ICNUM='')) RETURN '[National ID]: Either or Both WD Reference Id and Value are missing;'
	    SELECT @PATTERN = [PATTERN], @FORMAT = [FORMAT]  FROM WAVE_NATIONAL_ID_TYPE_LKUP WHERE [COUNTRY3 CODE]=@COUNC AND [WD VALUE]=@ICTYPE
        IF (PATINDEX(@PATTERN, @ICNUM)=0)
		BEGIN
			SET @RESULT = IIF(@FORMAT<>'', '[National ID]: '+@FORMAT, '');
		END
	END

	RETURN(@RESULT)
END
GO

IF OBJECT_ID('dbo.GetNationalIdInfo') IS NOT NULL
  DROP FUNCTION GetNationalIdInfo
GO
CREATE FUNCTION GetNationalIdInfo(
   @PERSNO                 VARCHAR(20),
   @SUBTY                  VARCHAR(20),
   @OBJPS                  VARCHAR(20),
   @DOB                    VARCHAR(20), 
   @TYPE                   VARCHAR(20) 
)  
RETURNS NVARCHAR(500)  
BEGIN  
    DECLARE @RESULT     AS NVARCHAR(500)='';
	DECLARE @COUNC      AS NVARCHAR(500)='';
	DECLARE @ICNUM      AS NVARCHAR(500)='';
	DECLARE @ICTYPE     AS NVARCHAR(500)='';
	DECLARE @FGBDT      AS NVARCHAR(500)=IIF(LEN(ISNULL(@SUBTY, '0'))=1, '0'+ISNULL(@SUBTY, '0'), ISNULL(@SUBTY, '0'))+
		                                 IIF(LEN(ISNULL(@OBJPS, '0'))=1, '0'+ISNULL(@OBJPS, '0'), ISNULL(@OBJPS, '0'))+
										 IIF(ISNULL(@DOB, '')='', '00000000', @DOB); 

	IF (@TYPE='COUNC')
	BEGIN
	    SELECT @COUNC=COUNC FROM WAVE_NM_DEPENDENT_NATI_TYPE WHERE PERSNO=@PERSNO AND FGBDT=@FGBDT;
		SET @RESULT=ISNULL((SELECT TOP 1 [Country Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]=@COUNC), '');
	END
	IF (@TYPE='ICNUM')
	BEGIN
	    SELECT @ICNUM=ICNUM FROM WAVE_NM_DEPENDENT_NATI_TYPE WHERE PERSNO=@PERSNO AND FGBDT=@FGBDT;
		SET @RESULT=dbo.RemoveNonAlphaNumericCharacters(ISNULL(@ICNUM, ''));
	END
	IF (@TYPE='TYPE')
	BEGIN
	    SELECT @ICTYPE=ICTYPE, @COUNC=COUNC FROM WAVE_NM_DEPENDENT_NATI_TYPE WHERE PERSNO=@PERSNO AND FGBDT=@FGBDT;
	    SELECT @RESULT = [WD VALUE] FROM WAVE_NATIONAL_ID_TYPE_LKUP WHERE [COUNTRY2 CODE]=@COUNC AND CAST([ICTYPE] AS INT)=CAST(@ICTYPE AS INT)
	END

	RETURN(@RESULT)
END
GO
--SELECT * FROm WAVE_NM_DEPENDENT_NATI_TYPE
--SELECT * FROM WAVE_NATIONAL_ID_TYPE_LKUP

IF OBJECT_ID('dbo.CheckNamesForAssociates') IS NOT NULL
  DROP FUNCTION CheckNamesForAssociates
GO
CREATE FUNCTION CheckNamesForAssociates(
   @column_name VARCHAR(max),
   @column_value NVARCHAR(max)
)  
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	DECLARE @Position AS INT=0;
	SET @column_value=REPLACE(REPLACE(@column_value, char(39), ''), ' ', '');
	SELECT @Position = PATINDEX('%[^a-zA-Z0-9 "&\/,.;#()+:-_\-]%', RTRIM(LTRIM(@column_value)));
	IF (@Position >= 1) SET @result= @column_name+': Contains "special" character at '+CAST(@Position AS VARCHAR(30))+'('+@column_value+');';

	--SET @column_value=REPLACE(@column_value, char(39), '');
	--IF (@column_value LIKE '%[^a-zA-Z0-9 .-\-"]%')
	--	SET @result= @column_name+': Contains "special" characters;';

    RETURN (@result)  
END
GO

IF OBJECT_ID('dbo.GetLocalLanguageFlag') IS NOT NULL
  DROP FUNCTION GetLocalLanguageFlag
GO
CREATE FUNCTION [dbo].[GetLocalLanguageFlag](
   @CC               NVARCHAR(50),
   @FValue_ENG       NVARCHAR(4000),
   @LValue_ENG       NVARCHAR(4000),
   @FValue_JPN       NVARCHAR(4000),
   @LValue_JPN       NVARCHAR(4000),
   @FValue_KOR       NVARCHAR(4000),
   @LValue_KOR       NVARCHAR(4000)
)
RETURNS NVARCHAR(500)
BEGIN
    DECLARE @Result     AS VARCHAR(500) = 'L';
    DECLARE @KeepValues AS VARCHAR(500) = ISNULL(@FValue_ENG, '');
	DECLARE @Value      AS NVARCHAR(500) =ISNULL(@FValue_ENG, '');
	IF (@KeepValues = @Value)
	BEGIN
           SET @KeepValues = ISNULL(@LValue_ENG, '');
	       SET @Value = ISNULL(@LValue_ENG, '');		   
		   IF (@KeepValues = @Value) SET @Result='W';
	END

	IF (@CC = 'JP') 
	BEGIN 
	    SET @KeepValues = @FValue_JPN;
		SET @Value = @FValue_JPN;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'J';

	    SET @KeepValues = @LValue_JPN;
		SET @Value = @LValue_JPN;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'J';

	END
	IF (@CC = 'KR') 
	BEGIN
	    SET @KeepValues = @FValue_KOR;
		SET @Value = @FValue_KOR;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'K';

		SET @KeepValues = @LValue_KOR;
		SET @Value = @LValue_KOR;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'K';
    END
	IF ((@CC <> 'JP') AND (@CC <> 'KR'))
	BEGIN 
	    SET @KeepValues = @FValue_ENG;
		SET @Value = @FValue_ENG;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'L';

		SET @KeepValues = @LValue_ENG;
		SET @Value = @LValue_ENG;
		IF (@KeepValues <> @Value) SET @Result=@Result+ 'L';
    END

	IF ((((CAST(@FValue_ENG AS VARCHAR(MAX)) COLLATE SQL_Latin1_General_Cp1251_CS_AS) <> @FValue_ENG) OR
	     ((CAST(@LValue_ENG AS VARCHAR(MAX)) COLLATE SQL_Latin1_General_Cp1251_CS_AS) <> @LValue_ENG)) AND @Result='W')
		SET @Result='AA';

	return IIF(LEN(@Result)=1, @Result+@Result, @Result);
END 
GO

IF OBJECT_ID('dbo.GetDependentEnglishName') IS NOT NULL
  DROP FUNCTION GetDependentEnglishName
GO

CREATE FUNCTION [dbo].[GetDependentEnglishName](
   @Value_ENG        NVARCHAR(4000),
   @Value_JPN        NVARCHAR(4000),
   @CC               NVARCHAR(50)
)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @KeepValues AS VARCHAR(500) = @Value_ENG;
	DECLARE @Value      AS NVARCHAR(500) = @Value_ENG;
	IF (@CC = 'JP' OR @CC = 'KR') 
	BEGIN 
	    SET @KeepValues = @Value_JPN;
		SET @Value = @Value_JPN;
	END
	IF (@Value = @KeepValues) return @KeepValues;

	return '';
END 
GO

IF OBJECT_ID('dbo.GetDependentNonEnglishName') IS NOT NULL
  DROP FUNCTION GetDependentNonEnglishName
GO

CREATE FUNCTION [dbo].[GetDependentNonEnglishName](
   @Value_ENG        NVARCHAR(4000),
   @Value_JPN        NVARCHAR(4000),
   @CC               NVARCHAR(50),
   @Position         NVARCHAR(5) 
)
RETURNS NVARCHAR(500)
AS
BEGIN
    IF (@Position='2' AND @CC<>'JP' AND @CC<>'KR') RETURN '';

    DECLARE @KeepValues AS VARCHAR(500) = @Value_ENG;
	DECLARE @Value      AS NVARCHAR(500) = @Value_ENG;
	--IF (@Value <> @KeepValues)
	--BEGIN
		IF (@CC = 'JP' OR @CC = 'KR') 
		BEGIN 
			SET @KeepValues = @Value_JPN;
			SET @Value = @Value_JPN;
		END
	--END
	IF (@Value <> @KeepValues) RETURN @Value;

	RETURN '';
END 
GO

IF OBJECT_ID('dbo.ArrangeEducationalStatus') IS NOT NULL
  DROP FUNCTION ArrangeEducationalStatus
GO

CREATE FUNCTION [dbo].[ArrangeEducationalStatus](
   @OES01        VarChar(100),
   @OES02        VarChar(100),
   @OES03        VarChar(100),
   @OES04        VarChar(100),
   @OES05        VarChar(100),
   @OES06        VarChar(100),
   @OES07        VarChar(100),
   @OES08        VarChar(100),
   @OES09        VarChar(100),
   @OES10        VarChar(100),
   @OES11        VarChar(100),
   @OES12        VarChar(100),
   @OES13        VarChar(100),
   @OES14        VarChar(100),
   @OES15        VarChar(100),
   @OES16        VarChar(100),
   @OES17        VarChar(100),
   @OES18        VarChar(100),
   @OES19        VarChar(100),
   @OES20        VarChar(100),
   @OES21        VarChar(100),
   @OES          int
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @KeepValues AS VARCHAR(500) = '';
	DECLARE @Index AS INT = 1;

	IF (@OES01 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues = @OES01;
		SET @Index = @Index + 1;
	END
	IF (@OES02 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES02;
		SET @Index = @Index + 1;
	END
	IF (@OES03 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES03;
		SET @Index = @Index + 1;
	END
	IF (@OES04 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES04;
		SET @Index = @Index + 1;
	END
	IF (@OES05 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES05;
		SET @Index = @Index + 1;
	END
	IF (@OES06 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES06;
		SET @Index = @Index + 1;
	END
	IF (@OES07 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES07;
		SET @Index = @Index + 1;
	END
	IF (@OES08 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES08;
		SET @Index = @Index + 1;
	END
	IF (@OES09 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES09;
		SET @Index = @Index + 1;
	END
	IF (@OES10 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES10;
		SET @Index = @Index + 1;
	END
	IF (@OES11 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES11;
		SET @Index = @Index + 1;
	END
	IF (@OES12 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES12;
		SET @Index = @Index + 1;
	END
	IF (@OES13 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES13;
		SET @Index = @Index + 1;
	END
	IF (@OES14 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES14;
		SET @Index = @Index + 1;
	END
	IF (@OES15 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES15;
		SET @Index = @Index + 1;
	END
	IF (@OES16 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES16;
		SET @Index = @Index + 1;
	END
	IF (@OES17 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES17;
		SET @Index = @Index + 1;
	END
	IF (@OES18 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES18;
		SET @Index = @Index + 1;
	END
	IF (@OES19 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES19;
		SET @Index = @Index + 1;
	END
	IF (@OES20 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES20;
		SET @Index = @Index + 1;
	END
	IF (@OES21 <> '')
	BEGIN
	    IF (@Index = @OES) SET @KeepValues =  @OES21;
		SET @Index = @Index + 1;
	END

    RETURN @KeepValues;
END
GO

IF OBJECT_ID('dbo.CheckDependentLocalNameFormat') IS NOT NULL
  DROP FUNCTION CheckDependentLocalNameFormat
GO
CREATE FUNCTION CheckDependentLocalNameFormat(
   @column_validate VARCHAR(max)
)  
RETURNS varchar(500)
BEGIN  
	DECLARE @column_value VARCHAR(max)='';
	DECLARE @column_name VARCHAR(max)='';
    DECLARE @result AS VARCHAR(500)='';

	DECLARE cursor_validate CURSOR FOR SELECT * FROM dbo.fnsplit(@column_validate, ';'); 
	OPEN cursor_validate;
 
	FETCH NEXT FROM cursor_validate INTO @column_value;
 
	WHILE @@FETCH_STATUS = 0
	BEGIN

	    SET @column_name= SUBSTRING(@column_value, CHARINDEX('|', @column_value)+1, LEN(@column_value));
		IF (CHARINDEX('Not Accepted', @column_value) >= 1)
		BEGIN
			IF CHARINDEX('HasValue', @column_value) >= 1
			BEGIN
				SET @result=@column_name+': Value not allowed;';
			END
		END
		IF (CHARINDEX('Required', @column_value) >= 1)
		BEGIN
			IF CHARINDEX('NONE', @column_value) >= 1
			BEGIN
				SET @result=@column_name+': Value is mandatory;';
			END
		END
		FETCH NEXT FROM cursor_validate INTO @column_value;
	END;
 
	CLOSE cursor_validate; 
	DEALLOCATE cursor_validate;

   
    RETURN (@result)  
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_DEPENDENTS_ERROR_VALIDATION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_DEPENDENTS_ERROR_VALIDATION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_DEPENDENTS_ERROR_VALIDATION]
    @which_wavestage     AS VARCHAR(50),
	@which_report        AS VARCHAR(500),
	@which_date         AS NVARCHAR(50)
AS
BEGIN
	/********* Validation ***********/
	PRINT 'VALIDATION'
	PRINT GETDATE()

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_DEPENDENTS_VALIDATION;';
	SELECT DISTINCT 
	        Wave                 [Build Number] 
	       ,[Report Name]        [Report Name]
		   ,[Employee ID]        [Employee ID]
		   ,[Country]            [Country Name]
		   ,[ISO3]               [Country ISO3 Code]
		   ,[WD_EMP_TYPE]        [Employee Type]
		   ,[Emp - SubGroup]     [Employee Group]
		   ,[Error Type]         [Error Type]
		   ,[ErrorText]          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_DEPENDENTS_VALIDATION 
	FROM (
		SELECT @which_wavestage Wave, @which_report [Report Name], [Employee ID], 
		       [Countries] [Country], [Legal Name Country] [ISO3], 'Country ISO Code' [Error Type], 
			   [WD_emp_type], [Emp - SubGroup],
		(
			IIF(ISNULL([Legal Name Country], '')='', 'Legal Name Country is required;', '')
		) ErrorText
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL a
		LEFT JOIN WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
		WHERE ISNULL([Employee ID], '') <> ''
		UNION ALL
		SELECT @which_wavestage Wave, @which_report [Report Name], [Employee ID], 
		       [Countries] [Country], [Legal Name Country] [ISO3], 'Legal Name' [Error Type], 
			   [WD_emp_type], [Emp - SubGroup],
		(
			IIF((a.[Geo - Country (CC)] = 'JP' OR a.[Geo - Country (CC)] = 'KR' OR 
					a.[Geo - Country (CC)] = 'TW' OR a.[Geo - Country (CC)] = 'TH' OR 
					a.[Geo - Country (CC)] = 'CN'),
					IIF(([Legal First Name] <> '' OR [Legal Last Name] <> ''),
						dbo.CheckDependentLocalNameFormat(
							ISNULL((SELECT LOCAL1_FIRST_NAME + '#' + IIF([Given Name - Local Script 01]=N'', 'NONE', 'HasValue') + '|LOCAL1_FIRST_NAME;' + 
											LOCAL1_LAST_NAME + '#' + IIF([Family Name - Local Script 01]=N'', 'NONE', 'HasValue') + '|LOCAL1_LAST_NAME;' + 
											LOCAL2_FIRST_NAME + '#' + IIF([Given Name - Local Script 02]=N'', 'NONE', 'HasValue') + '|LOCAL2_FIRST_NAME;' + 
											LOCAL2_LAST_NAME + '#' + IIF([Given Name - Local Script 02]=N'', 'NONE', 'HasValue') + '|LOCAL2_LAST_NAME;' +
											WESTERN_FIRST_NAME + '#' + IIF([Legal First Name]='', 'NONE', 'HasValue') + '|Legal First Name;' + 
											WESTERN_LAST_NAME  + '#' + IIF([Legal Last Name]='', 'NONE', 'HasValue') + '|Legal last Name'
										FROM DEPENDENDENTS_LOCAL_NAME_VALIDATION_INFO
										WHERE COUNTRY=a.[GEO - COUNTRY (CC)] AND WESTERN_SCRIPT_FLAG='Yes'), '')
							),
						dbo.CheckDependentLocalNameFormat(
							ISNULL((SELECT LOCAL1_FIRST_NAME + '#' + IIF([Given Name - Local Script 01]=N'', 'NONE', 'HasValue') + '|LOCAL1_FIRST_NAME;' + 
											LOCAL1_LAST_NAME + '#' + IIF([Family Name - Local Script 01]=N'', 'NONE', 'HasValue') + '|LOCAL1_LAST_NAME;' + 
											LOCAL2_FIRST_NAME + '#' + IIF([Given Name - Local Script 02]=N'', 'NONE', 'HasValue') + '|LOCAL2_FIRST_NAME;' + 
											LOCAL2_LAST_NAME + '#' + IIF([Given Name - Local Script 02]=N'', 'NONE', 'HasValue') + '|LOCAL2_LAST_NAME;' +
											WESTERN_FIRST_NAME + '#' + IIF([Legal First Name]='', 'NONE', 'HasValue') + '|Legal First Name;' + 
											WESTERN_LAST_NAME  + '#' + IIF([Legal Last Name]='', 'NONE', 'HasValue') + '|Legal last Name;'
										FROM DEPENDENDENTS_LOCAL_NAME_VALIDATION_INFO
										WHERE COUNTRY=a.[GEO - COUNTRY (CC)] AND WESTERN_SCRIPT_FLAG='No'), ''))), '') +

			dbo.CheckNamesForAssociates('[Legal First Name]', ISNULL([Legal First Name], '')) + 
			dbo.CheckNamesForAssociates('[Legal Last Name]', ISNULL([Legal Last Name], ''))

		) ErrorText
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL a
		LEFT JOIN WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
		WHERE ISNULL([Employee ID], '') <> ''
		UNION ALL
		SELECT @which_wavestage Wave, @which_report [Report Name], [Employee ID], 
		       [Countries] [Country], [Legal Name Country] [ISO3], 'Nationality' [Error Type], 
			   [WD_emp_type], [Emp - SubGroup],
		(
			dbo.CheckFieldScope(g.[Primary Nationality (Dependent)], g.[Country2 Code], '[Primary Nationality]', [Primary Nationality], 'N') +
			dbo.CheckFieldScope(g.[Additional Nationalities (Dependent)], g.[Country2 Code], '[Additional Nationality]', [Additional Nationality], 'N')
		) ErrorText
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL a
		LEFT JOIN WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
		WHERE ISNULL([Employee ID], '') <> ''
		UNION ALL
		SELECT @which_wavestage Wave, @which_report [Report Name], [Employee ID], 
		       [Countries] [Country], [Legal Name Country] [ISO3], 'Birth' [Error Type], 
			   [WD_emp_type], [Emp - SubGroup],
		(
			dbo.CheckFieldScope(g.[City of Birth (Dependent)], g.[Country2 Code], '[City of Birth]', [City of Birth], 'N') +
			dbo.CheckFieldScope(g.[Region of Birth (Dependent)], g.[Country2 Code], '[Region of Birth]', [Region of Birth], 'N') +
			dbo.CheckFieldScope(g.[Country of Birth (Dependent)], g.[Country2 Code], '[Country of Birth]', [Country of Birth], 'N')
		) ErrorText
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL a
		LEFT JOIN WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
		WHERE ISNULL([Employee ID], '') <> ''
		UNION ALL
		SELECT @which_wavestage Wave, @which_report [Report Name], [Employee ID], 
		       [Countries] [Country], [Legal Name Country] [ISO3], 'Tax' [Error Type], 
			   [WD_emp_type], [Emp - SubGroup],
		(
			dbo.CheckFieldScope(g.[Allowed for Tax Deduction (Dependent)], g.[Country2 Code], '[Allowed for Tax Deduction]', [Allowed for Tax Deduction], 'N')
		) ErrorText
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL a
		LEFT JOIN WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
		WHERE ISNULL([Employee ID], '') <> ''
	) b WHERE ErrorText <> ''

END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_DEPENDENTS_ERROR_VALIDATION 'P0', 'Dependents', '2021-03-10'

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_DEPENDENTS', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_DEPENDENTS;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_DEPENDENTS]
    @which_wavestage     AS VARCHAR(50),
	@which_report        AS VARCHAR(500),
	@which_date          AS VARCHAR(50),
	@EliminateFlag       AS VARCHAR(50),
	@PrefixCheck         AS VARCHAR(50),
	@PrefixCopy          AS VARCHAR(50),
	@Correction          AS VARCHAR(50)
AS
BEGIN

	DECLARE @EDUCATIONAL_INFO TABLE(
		HR_CORE_CODE      VARCHAR(10),
		HR_CORE_VALUE     VARCHAR(500),
		WD_ID             VARCHAR(500)
	);
    INSERT INTO @EDUCATIONAL_INFO VALUES('1','Illiterate','');
	INSERT INTO @EDUCATIONAL_INFO VALUES('10','DO NOT USE','');
	INSERT INTO @EDUCATIONAL_INFO VALUES('11','Compl.postgraduate','Postgraduate_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('12','DO NOT USE','');
	INSERT INTO @EDUCATIONAL_INFO VALUES('13','Compl.master''s deg.','Master''s_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('14','DO NOT USE','');
	INSERT INTO @EDUCATIONAL_INFO VALUES('15','Complete PhD','Doctorate_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('16','DO NOT USE','');
	INSERT INTO @EDUCATIONAL_INFO VALUES('17','Compl.postdoctoral','Postdoctorate_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('2','Incompl.elementary','Elementary_Incomplete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('20','Inc.tec.high school','High School_Incomplete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('21','Comp.tec.high school','High School_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('3','Complete elementary','Elementary_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('4','Incomp.middle-school','Middle School_Incomplete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('5','Compl.middle-school','Middle School_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('6','Incompl.high school','High School_Incomplete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('7','Complete high school','High School_Complete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('8','Incomplete college','Bachelor''s_Incomplete');
	INSERT INTO @EDUCATIONAL_INFO VALUES('9','Complete college','Bachelor''s_Complete');

	DECLARE @RELATIONSHIP_INFO TABLE(
		HR_CORE_CODE      VARCHAR(10),
		HR_CORE_VALUE     VARCHAR(500),
		WD_ID             VARCHAR(500)
	);
	INSERT INTO @RELATIONSHIP_INFO VALUES('1','Spouse','Spouse_Partner');
	INSERT INTO @RELATIONSHIP_INFO VALUES('10','Divorced spouse','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('11','Father','Parent');
	INSERT INTO @RELATIONSHIP_INFO VALUES('12','Mother','Parent');
	INSERT INTO @RELATIONSHIP_INFO VALUES('13','Domestic Partner','Spouse_Partner');
	INSERT INTO @RELATIONSHIP_INFO VALUES('14','Child of Domestic Partner','Child');
	INSERT INTO @RELATIONSHIP_INFO VALUES('15','Registered Partner','Spouse_Partner');
	INSERT INTO @RELATIONSHIP_INFO VALUES('17','Brother/Sister','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('2','Child','Child');
	INSERT INTO @RELATIONSHIP_INFO VALUES('3','Legal guardian','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('4','Testator','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('5','Guardian','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('6','Stepchild','Child');
	INSERT INTO @RELATIONSHIP_INFO VALUES('8','Related persons','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AR01','Prenatal AR','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AR02','Minor under wardship','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AR03','Minor-temporary wardship','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AR04','Child of spouse','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AR05','De facto partner','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('AU01','Beneficiary''s Details','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('FRST','Internship Supervisor','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('J1','Guarantor (JP)','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('KW01','Wife','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('MY01','Beneficiary''s Details','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('MY02','Joint Account Holder','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('OM01','Husband','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('OM02','Wife','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('QA01','Wife','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('QA02','Husband','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('Z1','Father-in-law','Other');
	INSERT INTO @RELATIONSHIP_INFO VALUES('Z2','Mother-in-law','Other');

	DECLARE @BELGIUM_DEPENDENT_OCCUPATION TABLE (
	     [HR_CORE_CODE]         NVARCHAR(200),
         [HR_CORE_VALUE]        NVARCHAR(200),
         [WD_ID]                NVARCHAR(200), 
         [SD Work value]        NVARCHAR(200), 
         [Description]          NVARCHAR(200)
    );

    INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('1', 'Manual workers', 'CUSTOM_ORGANIZATION_Blue collar', '1', 'blue collar');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('2', 'Domestics', 'CUSTOM_ORGANIZATION_Domestic servant', '3', 'domestic servant');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('3', 'Foreman', 'CUSTOM_ORGANIZATION_White collar', '2', 'white collar');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('4', 'Self-employed person', 'CUSTOM_ORGANIZATION_Self employed', '4', 'self employed');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('5', 'Miner', 'CUSTOM_ORGANIZATION_Miner', '5', 'miner');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('6', 'Seaman', 'CUSTOM_ORGANIZATION_Sailor', '6', 'sailor');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('7', 'Civil servant', 'CUSTOM_ORGANIZATION_State/Province/City', '7', 'state/province/city');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('8', 'Others', 'CUSTOM_ORGANIZATION_Other', '8', 'other');
	INSERT INTO @BELGIUM_DEPENDENT_OCCUPATION VALUES('9', 'Nothing', 'CUSTOM_ORGANIZATION_Without', '9', 'without');

	DECLARE @LOCAL_NAME_VALIDATION_INFO TABLE(
	    COUNTRY                  VARCHAR(100),
		WESTERN_SCRIPT_FLAG      VARCHAR(100),
		LOCAL1_FIRST_NAME        VARCHAR(100),
		LOCAL1_LAST_NAME         VARCHAR(100),
		LOCAL2_FIRST_NAME        VARCHAR(100),
		LOCAL2_LAST_NAME         VARCHAR(100),
		WESTERN_FIRST_NAME       VARCHAR(100),
		WESTERN_LAST_NAME        VARCHAR(100),
		SCRIPT_FLAG              VARCHAR(100)      
	);
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('CN', 'No', 'Required', 'Required', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('CN', 'Yes', 'Optional', 'Optional', 'Not Accepted', 'Not Accepted', 'Required', 'Required', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('JP', 'No', 'Required', 'Required', 'Optional', 'Optional', 'Not Accepted', 'Not Accepted', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('JP', 'Yes', 'Optional', 'Optional', 'Optional', 'Optional', 'Required', 'Required', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('KR', 'No', 'Required', 'Required', 'Optional', 'Optional', 'Not Accepted', 'Not Accepted', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('KR', 'Yes', 'Optional', 'Optional', 'Optional', 'Optional', 'Required', 'Required', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('TW', 'No', 'Required', 'Required', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('TW', 'Yes', 'Optional', 'Optional', 'Not Accepted', 'Not Accepted', 'Required', 'Required', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('TH', 'No', 'Required', 'Required', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'Not Accepted', 'No');
	INSERT INTO @LOCAL_NAME_VALIDATION_INFO VALUES('TH', 'Yes', 'Optional', 'Optional', 'Not Accepted', 'Not Accepted', 'Required', 'Required', 'No');

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists DEPENDENDENTS_LOCAL_NAME_VALIDATION_INFO;';
	SELECT * INTO DEPENDENDENTS_LOCAL_NAME_VALIDATION_INFO FROM @LOCAL_NAME_VALIDATION_INFO

	--EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_NATIONAL_ID_TYPE_LKUP;';
	--DECLARE @WAVE_NATIONAL_ID_TYPE_LKUP TABLE(
	--    [COUNTRY2 CODE]                  NVARCHAR(100),
	--	[COUNTRY3 CODE]                  NVARCHAR(100),
	--	[ICTYPE]                         NVARCHAR(100),
	--	[TEXT]                           NVARCHAR(100),
	--	[WD VALUE]                       NVARCHAR(100),
	--	[PATTERN]                        NVARCHAR(MAX),
	--	[FORMAT]                         NVARCHAR(MAX)
	--);
	--SELECT * INTO WAVE_NATIONAL_ID_TYPE_LKUP FROM @WAVE_NATIONAL_ID_TYPE_LKUP

	DELETE FROM WAVE_NATIONAL_ID_TYPE_LKUP
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '01','PermanentResidence', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '02','Temporary,ConditionalStay', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '11','BritishNationalOverseas', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '12','BritishDepTerritoryCitizen', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '21','CertificateofIdentity', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '31','EntrytoChinaPermit', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '32','Re-entryPermit', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '41','GeneralEmploymentVisa', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '42','ImportedSkillLabour', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '91','LocalDriver''sLicence', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('HK', 'HKG', '92','ForeignPassport', '', '', '');
	INSERT INTO WAVE_NATIONAL_ID_TYPE_LKUP VALUES('SG', 'SGP', '01','NRIC', 'SGP-NRIC', '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]', '');

	BEGIN TRY  

		DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					 FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							   FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
				  WHERE a.RNK=1'
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		/* Required Info type table */
		SET @SQL='drop table if exists WAVE_NM_PA0021;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0021 FROM '+@which_wavestage+'_PA0021;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0021', @PrefixCheck, @PrefixCopy

        SET @SQL='ALTER TABLE WAVE_NM_PA0021 ALTER COLUMN PERNR NVARCHAR(50) NOT NULL;
		          ALTER TABLE WAVE_NM_PA0021 ADD NATIID NVARCHAR(50) NULL;
				  ALTER TABLE WAVE_NM_PA0021 ADD ORG_COMPANY NVARCHAR(50) NULL;
		          ALTER TABLE WAVE_NM_PA0021 ADD CC NVARCHAR(50) NULL;
				  ALTER TABLE WAVE_NM_PA0021 ADD LOCAL_FLAG NVARCHAR(50) NULL';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		--W4_GOLD_PA9008
		SET @SQL='drop table if exists WAVE_NM_PA9008;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA9008 FROM '+@which_wavestage+'_PA9008;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA9008', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0167;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0167 FROM '+@which_wavestage+'_PA0167;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0167', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0138;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0138 FROM '+@which_wavestage+'_PA0138;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0138', @PrefixCheck, @PrefixCopy
		DELETE FROM WAVE_NM_PA0138 WHERE SUBTY='STy.';

		SET @SQL='drop table if exists WAVE_NM_PA0288;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0288 FROM '+@which_wavestage+'_PA0288;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0288', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0101;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0101 FROM '+@which_wavestage+'_PA0101;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0101', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0344;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0344 FROM '+@which_wavestage+'_PA0344;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0344', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0148;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0148 FROM '+@which_wavestage+'_PA0148;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0148', @PrefixCheck, @PrefixCopy

		SET @SQL='drop table if exists WAVE_NM_PA0540;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_PA0540 FROM '+@which_wavestage+'_PA0540;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		EXEC PROC_CHECK_TABLE_IN_DB 'PA0540', @PrefixCheck, @PrefixCopy

		UPDATE A1 SET
	      A1.ORG_COMPANY=A2.[Org - Company Code],
	      A1.CC=A2.[Geo - Work Country]
		FROM WAVE_NM_PA0021 A1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number]

		-- Determine Brazil and Belgium population
		SET @SQL='drop table if exists WAVE_NM_DEPENDENT_POPULATION_FOR_EXCEPTION_COUNTRIES;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SELECT c.* INTO WAVE_NM_DEPENDENT_POPULATION_FOR_EXCEPTION_COUNTRIES FROM 
		(SELECT DISTINCT PA0021.* FROM WAVE_NM_PA0021 PA0021 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE PM ON PA0021.PERNR=PM.[Emp - Personnel Number]
					WHERE PA0021.BEGDA <= CAST(@which_date AS DATE) AND 
							PA0021.ENDDA >= CAST(@which_date AS DATE) AND [Geo - Work Country] IN ('BR', 'BE')) c 
				JOIN
				(SELECT DISTINCT * FROM WAVE_NM_PA0167 WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE)) w
					      ON (c.PERNR=w.PERNR AND ((w.DTY01=c.FAMSA AND ISNULL(w.DID01, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY02=c.FAMSA AND ISNULL(w.DID02, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY03=c.FAMSA AND ISNULL(w.DID03, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY04=c.FAMSA AND ISNULL(w.DID04, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY05=c.FAMSA AND ISNULL(w.DID05, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY06=c.FAMSA AND ISNULL(w.DID06, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY07=c.FAMSA AND ISNULL(w.DID07, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY08=c.FAMSA AND ISNULL(w.DID08, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY09=c.FAMSA AND ISNULL(w.DID09, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY10=c.FAMSA AND ISNULL(w.DID10, '')=ISNULL(c.OBJPS, '')) OR
					                               (w.DTY11=c.FAMSA AND ISNULL(w.DID11, '')=ISNULL(c.OBJPS, '')) OR
					                               (w.DTY12=c.FAMSA AND ISNULL(w.DID12, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY13=c.FAMSA AND ISNULL(w.DID13, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY14=c.FAMSA AND ISNULL(w.DID14, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY15=c.FAMSA AND ISNULL(w.DID15, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY16=c.FAMSA AND ISNULL(w.DID16, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY17=c.FAMSA AND ISNULL(w.DID17, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY18=c.FAMSA AND ISNULL(w.DID18, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY19=c.FAMSA AND ISNULL(w.DID19, '')=ISNULL(c.OBJPS, '')) OR 
					                               (w.DTY20=c.FAMSA AND ISNULL(w.DID20, '')=ISNULL(c.OBJPS, ''))))
		DELETE FROM WAVE_NM_PA0021 WHERE CC IN ('BE', 'BR');
		INSERT INTO WAVE_NM_PA0021 SELECT * FROM WAVE_NM_DEPENDENT_POPULATION_FOR_EXCEPTION_COUNTRIES

		SET @SQL='drop table if exists WAVE_NM_DEPENDENT_INFO;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		SELECT  '' BEGDA_0397, '' MOTHE_0397, 
				'' ICNUM_0397, '' ESCOL_0397, 
				'' EXCEP_0397, '' IRFLG_0397, 
				'' ESTUD_0397, d.INTCA INTCA_9008,
				k.FNAMK FNAMK_0148, k.LNAMK LNAMK_0148,
				k.FAVOR FAVOR_0148, k.FANAM FANAM_0148,
				l.FNMHG FNMHG_0540, l.LNMHG LNMHG_0540,
				y.DATOL DATOL_0138, y.TELNR TELNR_0138, y.BVEPC BVEPC_0138, y.BVXMV BVXMV_0138,
				c.PERNR, c.BEGDA, c.ENDDA, c.FAMSA, c.FAVOR, c.FANAM, c.FASEX,
				c.FNAC2, c.NATIID, c.FGBDT, c.FGBLD, c.FGDEP, c.FGBOT, c.FANAT, 
				c.FANA2, c.SUBTY, c.OBJPS, c.EGAGA,
				z.ICNM1 HK_ICNUM, z.ICTY1 HK_ICTY, C.LOCAL_FLAG,
				v.BVECH BVECH_0101,
				x.NAHVN NAHVN_0288,
				c.AHVNR AHVNR_0021
		INTO WAVE_NM_DEPENDENT_INFO
		FROM (SELECT DISTINCT * FROM WAVE_NM_PA0021 
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
							ENDDA >= CAST(@which_date AS DATE)) c
				LEFT JOIN
				(SELECT DISTINCT * FROM WAVE_NM_PA0138 
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						ENDDA >= CAST(@which_date AS DATE)) y 
				ON c.PERNR=y.PERNR AND CAST(ISNULL(c.SUBTY, '0') AS INT)=CAST(ISNULL(y.SUBTY, '0') AS INT) AND CAST(ISNULL(c.OBJPS, '0') AS INT)=CAST(ISNULL(y.OBJPS, '0') AS INT)
				LEFT JOIN
				(SELECT DISTINCT * FROM WAVE_NM_PA0101 
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						ENDDA >= CAST(@which_date AS DATE)) v
				ON c.PERNR=v.PERNR
				LEFT JOIN
				(SELECT DISTINCT * FROM WAVE_NM_PA0288 
					WHERE BEGDA <= @which_date AND ENDDA >= @which_date) x
				ON c.PERNR=x.PERNR AND CAST(ISNULL(c.SUBTY, '0') AS INT)=CAST(ISNULL(x.SUBTY, '0') AS INT) AND CAST(ISNULL(c.OBJPS, '0') AS INT)=CAST(ISNULL(x.OBJPS, '0') AS INT)
				LEFT JOIN
				(SELECT DISTINCT * FROM WAVE_NM_PA0344 
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						ENDDA >= CAST(@which_date AS DATE)) z 
				ON c.PERNR=z.PERNR AND CAST(ISNULL(c.SUBTY, '0') AS INT)=CAST(ISNULL(z.SUBTY, '0') AS INT) AND CAST(ISNULL(c.OBJPS, '0') AS INT)=CAST(ISNULL(z.OBJPS, '0') AS INT)
				LEFT JOIN 
				(SELECT DISTINCT * FROM WAVE_NM_PA9008 
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						ENDDA >= CAST(@which_date AS DATE)) d 
				ON c.[PERNR]=d.PERNR
				LEFT JOIN 
				(SELECT DISTINCT PERNR, BEGDA, ENDDA, FAVOR, FANAM, FNAMK, LNAMK, SUBTY, OBJPS  
					FROM WAVE_NM_PA0148
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						  ENDDA >= CAST(@which_date AS DATE)) k
				ON c.[PERNR]=k.PERNR AND ISNULL(c.SUBTY, '')=ISNULL(k.[SUBTY], '') AND ISNULL(c.[OBJPS], '')=ISNULL(k.[OBJPS], '')
				LEFT JOIN 
				(SELECT DISTINCT PERNR, BEGDA, ENDDA, FNMHG, LNMHG, SUBTY, OBJPS
					FROM WAVE_NM_PA0540
					WHERE BEGDA <= CAST(@which_date AS DATE) AND 
						ENDDA >= CAST(@which_date AS DATE)) l
				ON c.[PERNR]=l.[PERNR] AND ISNULL(c.SUBTY, '')=ISNULL(l.[SUBTY], '') AND ISNULL(c.[OBJPS], '')=ISNULL(l.[OBJPS], '')
        
		PRINT 'Local Flag Start'
        UPDATE  e
		    SET LOCAL_FLAG=dbo.GetLocalLanguageFlag(a.[Geo - Country (CC)], e.FAVOR, e.FANAM, e.FAVOR_0148, FANAM_0148, e.FNMHG_0540, e.LNMHG_0540)
	    FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] a 
			LEFT JOIN  WAVE_NM_DEPENDENT_INFO e ON a.[Emp - Personnel Number]=e.PERNR
	    WHERE ISNULL([FAMSA], '') <> '' AND ISNULL([PERNR], '') <> ''
		SELECT * FROM WAVE_NM_DEPENDENT_INFO
		PRINT 'Local Flag End'

		--SET @SQL='drop table if exists WAVE_NM_DEPENDENT_NATI_TYPE;';
		--EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		--DECLARE @WAVE_NM_DEPENDENT_NATI_TYPE TABLE(
		--	[PERSNO]                 NVARCHAR(100),
		--	[FGBDT]                  NVARCHAR(100),
		--	[ICTYPE]                 NVARCHAR(100),
		--	[ICNUM]                  NVARCHAR(100),
		--	[COUNC]                  NVARCHAR(100)
		--);
		--SELECT * INTO WAVE_NM_DEPENDENT_NATI_TYPE FROM @WAVE_NM_DEPENDENT_NATI_TYPE
		--SELECT DISTINCT FASEX FROM P0_PA0021 

		DELETE FROM WAVE_NM_DEPENDENT_NATI_TYPE
		INSERT INTO WAVE_NM_DEPENDENT_NATI_TYPE
		SELECT DISTINCT * FROM (
        SELECt PERNR, IIF(LEN(ISNULL(SUBTY, '0'))=1, '0'+ISNULL(SUBTY, '0'), ISNULL(SUBTY, '0'))+
		              IIF(LEN(ISNULL(OBJPS, '0'))=1, '0'+ISNULL(OBJPS, '0'), ISNULL(OBJPS, '0'))+
					  IIF(ISNULL(FGBDT, '')='', '00000000', FGBDT) [FGBDT], '01' [ICTYPE], NATIID [ICNUM], 'SG' [COUNC]
	    FROM WAVE_NM_DEPENDENT_INFO WHERE ISNULL(NATIID, '') <> ''
		UNION ALL 
		SELECt PERNR, IIF(LEN(ISNULL(SUBTY, '0'))=1, '0'+ISNULL(SUBTY, '0'), ISNULL(SUBTY, '0'))+
		              IIF(LEN(ISNULL(OBJPS, '0'))=1, '0'+ISNULL(OBJPS, '0'), ISNULL(OBJPS, '0'))+
					  IIF(ISNULL(FGBDT, '')='', '00000000', FGBDT) [FGBDT], ISNULL(HK_ICTY, '') [ICTYPE], ISNULL(HK_ICNUM, '') [ICNUM], 'HK' [COUNC]
	    FROM WAVE_NM_DEPENDENT_INFO WHERE ISNULL(HK_ICTY, '') <> ''
		UNION ALL 
		SELECt PERNR, IIF(LEN(ISNULL(SUBTY, '0'))=1, '0'+ISNULL(SUBTY, '0'), ISNULL(SUBTY, '0'))+
		              IIF(LEN(ISNULL(OBJPS, '0'))=1, '0'+ISNULL(OBJPS, '0'), ISNULL(OBJPS, '0'))+
					  IIF(ISNULL(FGBDT, '')='', '00000000', FGBDT) [FGBDT], '05' [ICTYPE], ISNULL(NAHVN_0288, '') [ICNUM], 'CH' [COUNC]
	    FROM WAVE_NM_DEPENDENT_INFO WHERE ISNULL(NAHVN_0288, '') <> ''
		UNION ALL
		SELECt PERNR, IIF(LEN(ISNULL(SUBTY, '0'))=1, '0'+ISNULL(SUBTY, '0'), ISNULL(SUBTY, '0'))+
		              IIF(LEN(ISNULL(OBJPS, '0'))=1, '0'+ISNULL(OBJPS, '0'), ISNULL(OBJPS, '0'))+
					  IIF(ISNULL(FGBDT, '')='', '00000000', FGBDT) [FGBDT], '04' [ICTYPE], ISNULL(AHVNR_0021, '') [ICNUM], 'ES' [COUNC]
	    FROM WAVE_NM_DEPENDENT_INFO WHERE ISNULL(AHVNR_0021, '') <> ''
		) A1

		PRINT 'Dependents Starts';
		DECLARE @DEPENDENTS_INFO TABLE(
		    [Legacy System ID]                                NVARCHAR(200),
			[Emp - First Name]                                NVARCHAR(200),
			[Geo - Country (CC)]                              NVARCHAR(200),
			[FAMSA]                                           NVARCHAR(200),
			[Employee ID]                                     NVARCHAR(200),
			[Legal Name Country]                              NVARCHAR(200),
			[Title]                                           NVARCHAR(200),
			[Local_Flag]                                      NVARCHAR(200),
			[Legal First Name]                                NVARCHAR(200),
			[Legal Middle Name]                               NVARCHAR(200),
			[Legal Last Name]                                 NVARCHAR(200),
			[Secondary Last Name]                             NVARCHAR(200),
			[Belgium dependent occupation HR Core]            NVARCHAR(200),
			[Belgium dependent occupation]                    NVARCHAR(200),
			[Suffix]                                          NVARCHAR(200),
			[Preferred First Name]                            NVARCHAR(200),
			[Preferred Last Name]                             NVARCHAR(200),
			[Given Name - Local Script 01]                    NVARCHAR(200), 
			[Family Name - Local Script 01]                   NVARCHAR(200),
			[Kanji / Furigana (Japan only) 01]                NVARCHAR(200),
			[Given Name - Local Script 02]                    NVARCHAR(200), 
			[Family Name - Local Script 02]                   NVARCHAR(200),
			[Kanji / Furigana (Japan only) 02]                NVARCHAR(200),
			[Mother's Name_(Brazil only)]                     NVARCHAR(200),
			[Education Status_(Brazil only)]                  NVARCHAR(200),
			[Organization (Education Status) 01]              NVARCHAR(200),
			--[Organization (Education Status) 02]              NVARCHAR(200),
			--[Organization (Education Status) 03]              NVARCHAR(200),
			--[Organization (Education Status) 04]              NVARCHAR(200),
			--[Organization (Education Status) 05]              NVARCHAR(200),
			[Relationship to Employee HR Core]                NVARCHAR(200),
			[Relationship to Employee]                        NVARCHAR(200),
	        [Use Employee Address?]                           NVARCHAR(200),
			[Use Employee Phone?]                             NVARCHAR(200),
			[Country Code]                                    NVARCHAR(200),
			[Address Line 1]                                  NVARCHAR(200),
			[Address Line 2]                                  NVARCHAR(200),
			[City]                                            NVARCHAR(200),
			[Neighborhood]                                    NVARCHAR(200),
			[Region]                                          NVARCHAR(200),
			[Postal Code]                                     NVARCHAR(200),
			[Country ISO code (Home)]                         NVARCHAR(200),
			[International Phone Code (Home)]                 NVARCHAR(200),
			[Area Code (Home)]                                NVARCHAR(200),
			[Phone Number (Home)]                             NVARCHAR(200),
			[Phone Type (Home)]                               NVARCHAR(200),
			[Primary? (Home)]                                 NVARCHAR(200),
			[Public? (Home)]                                  NVARCHAR(200),
			[Country ISO code (Work)]                         NVARCHAR(200),
			[International Phone Code (Work)]                 NVARCHAR(200),
			[Area Code (Work)]                                NVARCHAR(200),
			[Phone Number (Work)]                             NVARCHAR(200),
			[Phone Extension (Work)]                          NVARCHAR(200),
			[Phone Type (Work)]                               NVARCHAR(200),
			[Primary? (Work)]                                 NVARCHAR(200),
			[Public? (Work)]                                  NVARCHAR(200),
			[Country ISO code (Work Mobile)]                  NVARCHAR(200),
			[International Phone Code (Work Mobile)]          NVARCHAR(200),
			[Area Code (Work Mobile)]                         NVARCHAR(200),
			[Phone Number (Work Mobile)]                      NVARCHAR(200),
			[Phone Type (Work Mobile)]                        NVARCHAR(200),
			[Primary? (Work Mobile)]                          NVARCHAR(200),
			[Public? (Work Mobile)]                           NVARCHAR(200),
			[Country (Personal Mobile)]                       NVARCHAR(200),
			[International Phone Code (Personal Mobile)]      NVARCHAR(200),
			[Area Code (Personal Mobile)]                     NVARCHAR(200),
			[Phone Number (Personal Mobile)]                  NVARCHAR(200),
			[Phone Type (Personal Mobile)]                    NVARCHAR(200),
			[Primary? (Personal Mobile)]                      NVARCHAR(200),
			[Public? (Personal Mobile)]                       NVARCHAR(200),
	        [Country Code (National ID)]                      NVARCHAR(200),
		    [National ID]                                     NVARCHAR(200),
			[National ID Type]                                NVARCHAR(200),
			[Date of Birth]                                   NVARCHAR(200),
			[Country of Birth]                                NVARCHAR(200),
			[Region of Birth]                                 NVARCHAR(200),
			[City of Birth]                                   NVARCHAR(200),
			[Gender]                                          NVARCHAR(200),
			[Primary Nationality]                             NVARCHAR(200),
			[Additional Nationality]                          NVARCHAR(200),
			[Date of Death]                                   NVARCHAR(200),
			[Uses Tobacco?]                                   NVARCHAR(200),
			[Disabled?]                                       NVARCHAR(200),
			[Allowed for Tax Deduction]                       NVARCHAR(200),
			[Effective Date (Allowed for Tax eduction)]       NVARCHAR(200),
			[Full-time Student?]                              NVARCHAR(200),
			[Student Status Start Date]                       NVARCHAR(200),
			[Student Status End Date]                         NVARCHAR(200),
			[Court Order - Benefit Coverage Type]             NVARCHAR(200),
			[Start Date]                                      NVARCHAR(200),
			[End Date]                                        NVARCHAR(200),
			[Trust Name]                                      NVARCHAR(200),
			[Tax ID]                                          NVARCHAR(200),
			[Trust Date]                                      NVARCHAR(200),
			[WD_emp_type]                                     NVARCHAR(200),
			[Emp - SubGroup]                                  NVARCHAR(200)
		);

		/********** Dependents Resultset **********/
		INSERT INTO @DEPENDENTS_INFO
		SELECT DISTINCT 
		     [Legacy System ID]
            ,[Emp - First Name]
		    ,[Geo - Country (CC)]
			,[FAMSA]
			,[Employee ID]
			,[Legal Name Country]
			,[Title]
			,[Local_Flag]
			,[Legal First Name]
			,[Legal Middle Name] 
			,[Legal Last Name]
			,[Secondary Last Name]
			,[Belgium dependent occupation HR Core]
			,[Belgium dependent occupation]
			,[Suffix]
			,[Preferred First Name]
			,[Preferred Last Name]
			,[Given Name - Local Script 01]
			,[Family Name - Local Script 01]
			,[Kanji / Furigana (Japan only) 01]
			,[Given Name - Local Script 02]
			,[Family Name - Local Script 02]
			,[Kanji / Furigana (Japan only) 02]
			,[Mother's Name_(Brazil only)]
			,dbo.ArrangeEducationalStatus([OES01], [OES02], [OES03], [OES04], [OES05], [OES06], [OES07], [OES08], [OES09], [OES10], [OES11], 
			                              [OES12], [OES13], [OES14], [OES15], [OES16], [OES17], [OES18], [OES19], [OES20], [OES21], 1) [Education Status_(Brazil only)]
			,'' [Organization (Education Status) 01]
			--,dbo.ArrangeEducationalStatus([OES01], [OES02], [OES03], [OES04], [OES05], [OES06], [OES07], [OES08], [OES09], [OES10], [OES11], 
			--                              [OES12], [OES13], [OES14], [OES15], [OES16], [OES17], [OES18], [OES19], [OES20], [OES21], 2)  [Organization (Education Status) 02]
			--,dbo.ArrangeEducationalStatus([OES01], [OES02], [OES03], [OES04], [OES05], [OES06], [OES07], [OES08], [OES09], [OES10], [OES11], 
			--                              [OES12], [OES13], [OES14], [OES15], [OES16], [OES17], [OES18], [OES19], [OES20], [OES21], 3)  [Organization (Education Status) 03]
			--,dbo.ArrangeEducationalStatus([OES01], [OES02], [OES03], [OES04], [OES05], [OES06], [OES07], [OES08], [OES09], [OES10], [OES11], 
			--                              [OES12], [OES13], [OES14], [OES15], [OES16], [OES17], [OES18], [OES19], [OES20], [OES21], 4)  [Organization (Education Status) 04]
			--,dbo.ArrangeEducationalStatus([OES01], [OES02], [OES03], [OES04], [OES05], [OES06], [OES07], [OES08], [OES09], [OES10], [OES11], 
			--                              [OES12], [OES13], [OES14], [OES15], [OES16], [OES17], [OES18], [OES19], [OES20], [OES21], 5)  [Organization (Education Status) 05]
			,[Relationship to Employee HR Core]
			,[Relationship to Employee]
	        ,[Use Employee Address?]
			,[Use Employee Phone?]
			,[Country Code]
			,[Address Line 1]
			,[Address Line 2]
			,[City]
			,[Neighborhood]
			,[Region]
			,[Postal Code]
			,[Country ISO code (Home)]
			,[International Phone Code (Home)]
			,[Area Code (Home)]
			,[Phone Number (Home)]
			,[Phone Type (Home)]
			,[Primary? (Home)]
			,[Public? (Home)]
			,[Country ISO code (Work)]
			,[International Phone Code (Work)]
			,[Area Code (Work)]
			,[Phone Number (Work)]
			,[Phone Extension (Work)]
			,[Phone Type (Work)]
			,[Primary? (Work)]
			,[Public? (Work)]
			,[Country ISO code (Work Mobile)]
			,[International Phone Code (Work Mobile)]
			,[Area Code (Work Mobile)]
			,[Phone Number (Work Mobile)]
			,[Phone Type (Work Mobile)]
			,[Primary? (Work Mobile)]
			,[Public? (Work Mobile)]
			,[Country (Personal Mobile)]
			,[International Phone Code (Personal Mobile)]
			,[Area Code (Personal Mobile)]
			,[Phone Number (Personal Mobile)]
			,[Phone Type (Personal Mobile)]
			,[Primary? (Personal Mobile)]
			,[Public? (Personal Mobile)]
	        ,[Country Code (National ID)]
		    ,[National ID]
			,[National ID Type]
			,[Date of Birth]
			,[Country of Birth]
			,[Region of Birth]
			,[City of Birth]
			,[Gender]
			,[Primary Nationality]
			,[Additional Nationality]
			,[Date of Death]
			,[Uses Tobacco?]
			,[Disabled?]
			,[Allowed for Tax Deduction]
			,[Effective Date (Allowed for Tax eduction)]
			,[Full-time Student?]
			,[Student Status Start Date]
			,[Student Status End Date]
			,[Court Order - Benefit Coverage Type]
			,[Start Date]
			,[End Date]
			,[Trust Name]
			,[Tax ID]
			,[Trust Date]
			,[WD_emp_type]
			,[Emp - Group]
		FROM (
			SELECT DISTINCT 
				 [Legacy System ID]
                ,[Emp - First Name]
				,[Geo - Country (CC)]
				,[FAMSA]
				,[Employee ID]
				,[Legal Name Country]
				,[Title]
				,[Local_Flag]
				,[Legal First Name]
				,[Legal Middle Name] 
				,[Legal Last Name]
				,[Secondary Last Name]
				,[Belgium dependent occupation HR Core]
				,[Belgium dependent occupation]
				,[Suffix]
				,[Preferred First Name]
				,[Preferred Last Name]
				,[Given Name - Local Script 01]
				,[Family Name - Local Script 01]
				,[Kanji / Furigana (Japan only) 01]
				,[Given Name - Local Script 02]
				,[Family Name - Local Script 02]
				,[Kanji / Furigana (Japan only) 02]
				,[Mother's Name_(Brazil only)]
				,[Education Status_(Brazil only)]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[1]), '')  [OES01]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[2]), '')  [OES02]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[3]), '')  [OES03]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[4]), '')  [OES04]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[5]), '')  [OES05]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[6]), '')  [OES06]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[7]), '')  [OES07]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[8]), '')  [OES08]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[9]), '')  [OES09]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[10]), '')  [OES10]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[11]), '')  [OES11]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[12]), '')  [OES12]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[13]), '')  [OES13]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[14]), '')  [OES14]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[15]), '')  [OES15]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[16]), '')  [OES16]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[17]), '')  [OES17]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[18]), '')  [OES18]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[19]), '')  [OES19]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[20]), '')  [OES20]
				,ISNULL((SELECT WD_ID FROM @EDUCATIONAL_INFO WHERE HR_CORE_CODE=[21]), '')  [OES21]
				,[Relationship to Employee HR Core]
				,[Relationship to Employee]
				,[Use Employee Address?]
				,[Use Employee Phone?]
				,[Country Code]
				,[Address Line 1]
				,[Address Line 2]
				,[City]
				,[Neighborhood]
				,[Region]
				,[Postal Code]
				,[Country ISO code (Home)]
				,[International Phone Code (Home)]
				,[Area Code (Home)]
				,[Phone Number (Home)]
				,[Phone Type (Home)]
				,[Primary? (Home)]
				,[Public? (Home)]
				,[Country ISO code (Work)]
				,[International Phone Code (Work)]
				,[Area Code (Work)]
				,[Phone Number (Work)]
				,[Phone Extension (Work)]
				,[Phone Type (Work)]
				,[Primary? (Work)]
				,[Public? (Work)]
				,[Country ISO code (Work Mobile)]
				,[International Phone Code (Work Mobile)]
				,[Area Code (Work Mobile)]
				,[Phone Number (Work Mobile)]
				,[Phone Type (Work Mobile)]
				,[Primary? (Work Mobile)]
				,[Public? (Work Mobile)]
				,[Country (Personal Mobile)]
				,[International Phone Code (Personal Mobile)]
				,[Area Code (Personal Mobile)]
				,[Phone Number (Personal Mobile)]
				,[Phone Type (Personal Mobile)]
				,[Primary? (Personal Mobile)]
				,[Public? (Personal Mobile)]
				,[Country Code (National ID)]
				,[National ID]
				,[National ID Type]
				,[Date of Birth]
				,[Country of Birth]
				,[Region of Birth]
				,[City of Birth]
				,[Gender]
				,[Primary Nationality]
				,[Additional Nationality]
				,[Date of Death]
				,[Uses Tobacco?]
				,[Disabled?]
				,[Allowed for Tax Deduction]
				,[Effective Date (Allowed for Tax eduction)]
				,[Full-time Student?]
				,[Student Status Start Date]
				,[Student Status End Date]
				,[Court Order - Benefit Coverage Type]
				,[Start Date]
				,[End Date]
				,[Trust Name]
				,[Tax ID]
				,[Trust Date]
				,[WD_emp_type]
				,[Emp - Group]
			FROM (
			SELECT  [Employee ID] AS [Legacy System ID], * FROM (
				SELECT DISTINCT a.[Emp - First Name]
				      ,a.[Geo - Country (CC)]
					  ,e.[FAMSA]
					  ,a.persno_new [Employee ID]
					  ,'' [Title]
					  ,[LOCAL_FLAG]
					  ,ISNULL((SELECT TOP 1 [Country Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]=ISNULL(e.INTCA_9008, '')), '') [Legal Name Country] 
					  ,IIF((SUBSTRING(e.LOCAL_FLAG, 1, 1)='W' OR SUBSTRING(e.LOCAL_FLAG, 1, 1)='A'), ISNULL(e.FAVOR, ''), '') [Legal First Name]
					  ,IIF((SUBSTRING(e.LOCAL_FLAG, 1, 1)='W' OR SUBSTRING(e.LOCAL_FLAG, 1, 1)='A') and [Geo - Country (CC)]='PH',ISNULL(e.FNAC2, ''), '')  [Legal Middle Name]
					  ,IIF((SUBSTRING(e.LOCAL_FLAG, 1, 1)='W' OR SUBSTRING(e.LOCAL_FLAG, 1, 1)='A'), ISNULL(e.FANAM, ''), '') [Legal Last Name]
					  ,IIF((SUBSTRING(e.LOCAL_FLAG, 1, 1)='W' OR SUBSTRING(e.LOCAL_FLAG, 1, 1)='A') and [Geo - Country (CC)]<>'PH' and [Geo - Country (CC)]<>'HU', ISNULL(e.FNAC2, ''), '') [Secondary Last Name]
					  ,IIF(ISNULL(e.FAMSA, '')='1', ISNULL((SELECT HR_CORE_VALUE FROM @BELGIUM_DEPENDENT_OCCUPATION WHERE HR_CORE_CODE=ISNULL(e.BVECH_0101, '')), ''), '') [Belgium dependent occupation HR Core]
					  ,IIF(ISNULL(e.FAMSA, '')='1', ISNULL((SELECT WD_ID FROM @BELGIUM_DEPENDENT_OCCUPATION WHERE HR_CORE_CODE=ISNULL(e.BVECH_0101, '')), ''), '') [Belgium dependent occupation]
					  ,'' [Suffix]
					  ,'' [Preferred First Name]
					  ,'' [Preferred Last Name]
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J', ISNULL(e.FAVOR_0148, ''),  
					       IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='K', ISNULL(e.FNMHG_0540, ''), 
						        IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='L', ISNULL(e.FAVOR, ''), ''))) [Given Name - Local Script 01]
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J', ISNULL(e.FANAM_0148, ''),
					       IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='K', ISNULL(e.LNMHG_0540, ''),
						        IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='L', ISNULL(e.FANAM, ''), '')))  [Family Name - Local Script 01]
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J',  'Kanji', '') [Kanji / Furigana (Japan only) 01] 
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J', ISNULL(e.FNAMK_0148, ''), '') [Given Name - Local Script 02]
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J', ISNULL(e.LNAMK_0148, ''), '') [Family Name - Local Script 02]
					  ,IIF(SUBSTRING(e.LOCAL_FLAG, 2, 1)='J' AND (ISNULL(e.FNAMK_0148, '') <> '' OR ISNULL(e.LNAMK_0148, '') <> ''), 'Furigana', '') [Kanji / Furigana (Japan only) 02]
					  ,ISNULL(e.MOTHE_0397, '') [Mother's Name_(Brazil only)]
					  ,'' [Education Status_(Brazil only)]
					  ,ISNULL(e.ESCOL_0397, '') [Organization (Education Status)]
					  ,ISNULL((SELECT HR_CORE_VALUE FROM @RELATIONSHIP_INFO WHERE HR_CORE_CODE=e.FAMSA), '') [Relationship to Employee HR Core]
					  ,ISNULL((SELECT WD_ID FROM @RELATIONSHIP_INFO WHERE HR_CORE_CODE=e.FAMSA), '') [Relationship to Employee]
					  ,'Y' [Use Employee Address?]
					  ,'N' [Use Employee Phone?]
					  ,'' [Country Code]
					  --,ISNULL(e.EGAGA, '') [Address Line 1]
					  ,'' [Address Line 1]
					  ,'' [Address Line 2]
					  ,'' [City]
					  ,'' [Neighborhood]
					  ,'' [Region]
					  ,'' [Postal Code]
					  ,IIF(ISNULL(e.TELNR_0138, '')<>'', ISNULL((SELECT TOP 1 [Country Code] 
					                                               FROM WAVE_ADDRESS_VALIDATION 
																   WHERE [Country2 Code]=ISNULL(e.INTCA_9008, '')), ''), '') [Country ISO code (Home)]
					  ,'' [International Phone Code (Home)]
					  ,'' [Area Code (Home)]
					  ,ISNULL(e.TELNR_0138, '') [Phone Number (Home)]
					  ,'' [Phone Type (Home)]
					  ,'' [Primary? (Home)]
					  ,'' [Public? (Home)]
					  ,'' [Country ISO code (Work)]
					  ,'' [International Phone Code (Work)]
					  ,'' [Area Code (Work)]
					  ,'' [Phone Number (Work)]
					  ,'' [Phone Extension (Work)]
					  ,'' [Phone Type (Work)]
					  ,'' [Primary? (Work)]
					  ,'' [Public? (Work)]
					  ,'' [Country ISO code (Work Mobile)]
					  ,'' [International Phone Code (Work Mobile)]
					  ,'' [Area Code (Work Mobile)]
					  ,'' [Phone Number (Work Mobile)]
					  ,'' [Phone Type (Work Mobile)]
					  ,'' [Primary? (Work Mobile)]
					  ,'' [Public? (Work Mobile)]
					  ,'' [Country (Personal Mobile)]
					  ,'' [International Phone Code (Personal Mobile)]
					  ,'' [Area Code (Personal Mobile)]
					  ,'' [Phone Number (Personal Mobile)]
					  ,'' [Phone Type (Personal Mobile)]
					  ,'' [Primary? (Personal Mobile)]
					  ,'' [Public? (Personal Mobile)]
					  ,dbo.GetNationalIdInfo(e.PERNR, e.SUBTY, e.OBJPS, e.FGBDT, 'COUNC') [Country Code (National ID)]
					  ,dbo.GetNationalIdInfo(e.PERNR, e.SUBTY, e.OBJPS, e.FGBDT, 'ICNUM') [National ID]
					  ,dbo.GetNationalIdInfo(e.PERNR, e.SUBTY, e.OBJPS, e.FGBDT, 'TYPE') [National ID Type]
					  ,IIF(ISNULL(e.FGBDT, '00000000') >= '19000101', CAST(CONVERT(varchar(10), CAST(e.FGBDT AS Date), 101) AS VARCHAR(15)), '') [Date of Birth]
					  ,IIF(g.[Country of Birth (Dependent)]='Hidden', '', 
					        ISNULL((SELECT TOP 1 [Country Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]=ISNULL(e.FGBLD, '')), '')) [Country of Birth]
					  ,IIF(g.[Region of Birth (Dependent)]='Hidden', '', 
					        ISNULL(e.FGDEP, '')) [Region of Birth]
					  ,IIF(g.[City of Birth (Dependent)]='Hidden', '', 
					        ISNULL(e.FGBOT, '')) [City of Birth]
					  ,IIF(ISNULL(e.FASEX, '')='2', 'Female', IIF(ISNULL(e.FASEX, '')='1', 'Male', '')) [Gender]
					  ,IIF((g.[Primary Nationality (Dependent)]='Hidden' OR a.[GEO - WORK COUNTRY]='BD' OR e.FANAT='US'), '', 
					     ISNULL((SELECT TOP 1 [Country Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]=ISNULL(e.FANAT, '')), '')) [Primary Nationality]
					  ,IIF((g.[Additional Nationalities (Dependent)]='Hidden' OR a.[GEO - WORK COUNTRY]='BD' OR e.FANA2='US'), '', 
					     ISNULL((SELECT TOP 1 [Country Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]=ISNULL(e.FANA2, '')), '')) [Additional Nationality]
					  ,IIF(ISNULL(e.DATOL_0138, '00000000')<>'00000000', CAST(CONVERT(varchar(10), CAST(e.DATOL_0138 AS Date), 101) AS VARCHAR(15)), '') [Date of Death]
					  ,'' [Uses Tobacco?]
					  ,IIF(a.[Geo - Country (CC)]='BE', IIF(ISNULL(e.BVXMV_0138, '')='X', 'Y', 'N'), ISNULL(e.EXCEP_0397, '')) [Disabled?]
					  ,IIF(g.[Allowed for Tax Deduction (Dependent)]='Hidden', '', 
					     ISNULL(e.IRFLG_0397, '')) [Allowed for Tax Deduction]
					  ,IIF(ISNULL(Convert(VARCHAR(10), e.BEGDA_0397, 112), '00000000')='00000000', '', CAST(CONVERT(varchar(10), e.BEGDA_0397, 101) AS VARCHAR(15)))  [Effective Date (Allowed for Tax eduction)]
					  ,IIF(ISNULL(e.ESTUD_0397, '')='X', 'Y', ISNULL(e.ESTUD_0397, '')) [Full-time Student?]
					  ,'' [Student Status Start Date]
					  ,'' [Student Status End Date]
					  ,'' [Court Order - Benefit Coverage Type]
					  ,'' [Start Date]
					  ,'' [End Date]
					  ,'' [Trust Name]
					  ,'' [Tax ID]
					  ,'' [Trust Date]
					  ,[WD_emp_type]
					  ,[Emp - Group]
				FROM (SELECT * FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] WHERE [Geo - Work Country]<>'DE') a 
				     LEFT JOIN  WAVE_ALL_FIELDS_VALIDATION  g ON a.[Geo - Country (CC)]=g.[Country2 Code]
					 LEFT JOIN  WAVE_NM_DEPENDENT_INFO e ON a.[Emp - Personnel Number]=e.PERNR
				) h WHERE ISNULL([Relationship to Employee], '') <> '' AND ISNULL([Employee ID], '') <> '') emp
			PIVOT 
			(
				MIN([Organization (Education Status)])
				FOR [Organization (Education Status)] IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21])
			)
			AS PivotTable
		) ArrangeDependents

		/********** Dependents Resultset **************/
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL';
		PRINT 'Drop table, If exists: '+@Table_Name

	    SET @SQL='drop table if exists WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL;
		          drop table if exists WD_HR_TR_AUTOMATED_DEPENDENTS;
				  drop table if exists WD_HR_TR_AUTOMATED_DELTA_DEPENDENTS;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		SELECT *, ROW_NUMBER() OVER(PARTITION BY [Employee ID] ORDER BY [Employee ID]) RNUM INTO WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL FROM (
		SELECT DISTINCT * FROM @DEPENDENTS_INFO ) A1 WHERE ([Gender] <> '' OR @EliminateFlag='No')

		/* Subramanian Chandrasekaran If dependent DoB is missing then keep default it to 1st jan 1900 but keep it in validation report. 
		   When dependent first name or last name is missing then default it to hyphen (-) but keep it in error report */
		UPDATE WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL SET
		   [Legal First Name]=IIF([Legal First Name]='' AND [Legal Last Name]='', '', 
		                      IIF(([Legal First Name]='' AND [Legal Last Name]<>''), '-', [Legal First Name])),
		   [Legal Last Name]=IIF([Legal First Name]='' AND [Legal Last Name]='', '', 
		                      IIF(([Legal First Name]<>'' AND [Legal Last Name]=''), '-', [Legal Last Name])),
		   [Date of Birth]=IIF([Date of Birth]='', '01/01/1900', [Date of Birth])

        --/* Move all local names for dependents to english legal names(From Task) */
		--DECLARE @LOCAL_NAME_CHANGES TABLE (
		--     PERNR                     NVARCHAR(2000),
		--	 FIRST_NAME                NVARCHAR(2000),
		--	 LAST_NAME                 NVARCHAR(2000),
		--	 RNUM                      INT
		--)
		--INSERT INTO @LOCAL_NAME_CHANGES
		--SELECT [Employee ID], [Given Name - Local Script 01], [Family Name - Local Script 01], RNUM 
		--    FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL 
		--	WHERE [Given Name - Local Script 01] <> '' OR [Family Name - Local Script 01] <> '' ORDER BY [Employee Id]

		--UPDATE A1 SET
		--    [Legal First Name]=A2.FIRST_NAME,
		--	[Legal Last Name]=A2.LAST_NAME,
		--	[Given Name - Local Script 01]='',
		--	[Family Name - Local Script 01]=''
		--FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL A1 JOIN @LOCAL_NAME_CHANGES A2 ON A1.[Employee ID]=A2.PERNR AND A1.RNUM=A2.RNUM

		SELECT DISTINCT
			 [Employee ID]
			,[Legal Name Country]
			,[Title]
			--,[Local_Flag]
			,[Legal First Name]
			,[Legal Middle Name] 
			,[Legal Last Name]
			,[Secondary Last Name]
			,[Belgium dependent occupation HR Core]
			,[Belgium dependent occupation]
			,[Suffix]
			,[Preferred First Name]
			,[Preferred Last Name]
			,[Given Name - Local Script 01]
			,[Family Name - Local Script 01]
			,[Kanji / Furigana (Japan only) 01]
			,[Given Name - Local Script 02]
			,[Family Name - Local Script 02]
			,[Kanji / Furigana (Japan only) 02]
			,[Mother's Name_(Brazil only)]
			,[Education Status_(Brazil only)]
			,[Organization (Education Status) 01]
			--,[Organization (Education Status) 02]
			--,[Organization (Education Status) 03]
			--,[Organization (Education Status) 04]
			--,[Organization (Education Status) 05]
			,[Relationship to Employee]
	        ,[Use Employee Address?]
			,[Use Employee Phone?]
			,[Country Code]
			,[Address Line 1]
			,[Address Line 2]
			,[City]
			,[Neighborhood]
			,[Region]
			,[Postal Code]
			,[Country ISO code (Home)]
			,[International Phone Code (Home)]
			,[Area Code (Home)]
			,[Phone Number (Home)]
			,[Phone Type (Home)]
			,[Primary? (Home)]
			,[Public? (Home)]
			,[Country ISO code (Work)]
			,[International Phone Code (Work)]
			,[Area Code (Work)]
			,[Phone Number (Work)]
			,[Phone Extension (Work)]
			,[Phone Type (Work)]
			,[Primary? (Work)]
			,[Public? (Work)]
			,[Country ISO code (Work Mobile)]
			,[International Phone Code (Work Mobile)]
			,[Area Code (Work Mobile)]
			,[Phone Number (Work Mobile)]
			,[Phone Type (Work Mobile)]
			,[Primary? (Work Mobile)]
			,[Public? (Work Mobile)]
			,[Country (Personal Mobile)]
			,[International Phone Code (Personal Mobile)]
			,[Area Code (Personal Mobile)]
			,[Phone Number (Personal Mobile)]
			,[Phone Type (Personal Mobile)]
			,[Primary? (Personal Mobile)]
			,[Public? (Personal Mobile)]
	        ,[Country Code (National ID)]
		    ,[National ID]
			,[National ID Type]
			,[Date of Birth]
			,[Country of Birth]
			,[Region of Birth]
			,[City of Birth]
			,[Gender]
			,[Primary Nationality]
			,[Additional Nationality]
			,[Date of Death]
			,[Uses Tobacco?]
			,[Disabled?]
			,[Allowed for Tax Deduction]
			,[Effective Date (Allowed for Tax eduction)]
			,[Full-time Student?]
			,[Student Status Start Date]
			,[Student Status End Date]
			,[Court Order - Benefit Coverage Type]
			,[Start Date]
			,[End Date]
			,[Trust Name]
			,[Tax ID]
			,[Trust Date]
		INTO WD_HR_TR_AUTOMATED_DEPENDENTS
		FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL

		/********** Delta Dependents Resultset **************/
		SELECT * INTO WD_HR_TR_AUTOMATED_DELTA_DEPENDENTS 
		   FROM WD_HR_TR_AUTOMATED_DEPENDENTS 
		   WHERE [Employee ID] IN ('') ORDER BY [Employee Id]

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
--EXEC PROC_WAVE_NM_AUTOMATE_DEPENDENTS 'P0', 'Dependents', '2021-03-10', 'No', 'P0_', 'P0_', 'P0' 
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS ORDER BY [Employee Id]
--EXEC PROC_WAVE_NM_AUTOMATE_DEPENDENTS_ERROR_VALIDATION 'P0', 'Dependents', '2021-03-10'
--SELECT * FROM NOVARTIS_DATA_MIGRATION_DEPENDENTS_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM NOVARTIS_DATA_MIGRATION_DEPENDENTS_VALIDATION WHERE [Error Type]='Legal Name' ORDER BY [Build Number], [Report Name], [Employee ID]

--02100379
--EXEC PROC_WAVE_NM_AUTOMATE_DEPENDENTS 'W4_P2', 'Dependents', '2020-10-02', 'W4_P2_', 'W4_P2_', 'W4_P2' 
--EXEC PROC_WAVE_NM_AUTOMATE_DEPENDENTS 'W4_GOLD', 'Dependents', '2021-02-14', 'W4_GOLD_', 'W4_GOLD_', 'W4_GOLD' 
--SELECT * FROM WD_HR_TR_AUTOMATED_DELTA_DEPENDENTS ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS_PREFINAL ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Phone Number (Home)] <> '' ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Employee Id] like '12%' AND [Relationship to Employee]<>'Spouse_Partner' ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Given Name - Local Script 01] <> '' OR [Family Name - Local Script 01] <> '' ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Employee Id]='02100379' ORDER BY [Employee Id]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='Dependents' ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Employee Id] IN (SELECT [Emp - Personnel Number] FROM [WAVE_NM_Singapore_Dependents_Corrections]);
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Employee Id] LIKE '12%';
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERE [Employee Id] IN (SELECT DISTINCT ITEM FROM DBO.[fnSplit]('25000389,25000441,25000473,25000615,25000615,25000764,25000855,25000892,25001438,25001438,25001513,25001513,25001714,25001913,25001913', ','));
--SELECT * FROM WAVE_NM_GOLD_SINGAPORE_DEPENDENTS_CORRECTIONS
--SELECT * FROM WAVE_NM_CATCHUP1_PA0021
--SELECT * FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERe [Employee Id] IN ('25001438', '25001604') ORDER BY [Employee Id]
--SELECT * INTO WD_HR_TR_AUTOMATED_DEPENDENTS_GOLD_DELTA FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERe [Employee Id] IN ('25000916', '25001438', '25001604', '25002891', '25003087', '25004661') ORDER BY [Employee Id]
--SELECT * INTO WD_HR_TR_AUTOMATED_DEPENDENTS_CATCHUP1_DELTA FROM WD_HR_TR_AUTOMATED_DEPENDENTS WHERe [Employee Id] IN ('25000916', '25001438', '25001604', '25002891', '25003087', '25004661') ORDER BY [Employee Id]
--SELECT * FROM WAVE_NM_GOLD_SINGAPORE_DEPENDENTS_CORRECTIONS WHERe [Emp - Personnel Number] IN ('25000916', '25001438', '25001604', '25002891', '25003087', '25004661') ORDER BY [Emp - Personnel Number]
--SELECT DISTINCT DATOL FROM W4_P2_PA0138 WHERE PERNR like '12%'
--SELECT DISTINCT EGAGA FROM W4_P2_PA0021 WHERE PERNR like '12%'
--SELECT DISTINCT * FROM W4_GOLD_PA0021 WHERE PERNR='02100379'
--SELECT * FROM W4_P2_PA0101
--SELECT * FROM W4_P2_PA0288


