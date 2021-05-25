USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT]    Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_SPLIT_INFO_JSON_DATA', 'P' ) IS NOT NULL   
  DROP PROCEDURE PROC_SPLIT_INFO_JSON_DATA
GO
CREATE PROCEDURE PROC_SPLIT_INFO_JSON_DATA
    @SrcInfoType  AS NVARCHAR(200),
	@Delimeter    AS VARCHAR(50),
	@WhichDate    AS VARCHAR(50) 
AS
BEGIN  
    DECLARE @FIELD_INFO TABLE (
	    PERSNO            NVARCHAR(200),
        COUNTRY_CODE      NVARCHAR(200),
		FIRST_NAME        NVARCHAR(200),
		MIDDLE_NAME       NVARCHAR(200),
		LAST_NAME         NVARCHAR(200),
		PREIX             NVARCHAR(200)
	);

	DECLARE @PERNR     AS NVARCHAR(200);
	DECLARE @SrcFields AS NVARCHAR(200);

	--DECLARE cursor_split CURSOR FOR 
	   --   DECLARE @WhichDate AS VARCHAR(20)='2021-03-10';
	   --   SELECT DISTINCT PERNR, ALNAM 
		  --   FROM WAVE_NM_PA0182 a1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT a2 ON a1.PERNR=a2.[EMP - PERSONNEL NUMBER]
			 --WHERE ENDDA >= CAST(@WhichDate AS DATE) AND BEGDA<=CAST(@WhichDate AS DATE) AND a2.[GEO - WORK COUNTRY]='TH'
	--OPEN cursor_split;
	--SELECT DISTINCT ALNAM FROM WAVE_NM_PA0182

	PRINT GetDate();
	DECLARE cursor_split CURSOR FOR 
	      SELECT DISTINCT PERNR, ALNAM 
		     FROM WAVE_NM_PA0182 a1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT a2 ON a1.PERNR=a2.[EMP - PERSONNEL NUMBER]
			 WHERE a1.ENDDA >= CAST(@WhichDate AS DATE) AND a1.BEGDA<=CAST(@WhichDate AS DATE) AND a2.[GEO - WORK COUNTRY]='TH'
	OPEN cursor_split;

 
	FETCH NEXT FROM cursor_split INTO @PERNR, @SrcFields;
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
	 
		DECLARE @SQL AS NVARCHAR(MAX)='';
		DECLARE @JsonArray NVARCHAR(MAX)=CONCAT('[["',REPLACE(@SrcFields, @Delimeter, '","'),'"]]');

		DECLARE @SRC00        AS NVARCHAR(2000)='';
		DECLARE @SRC01        AS NVARCHAR(2000)='';
		DECLARE @SRC02        AS NVARCHAR(2000)='';
		DECLARE @SRC03        AS NVARCHAR(2000)='';
		DECLARE @SRC04        AS NVARCHAR(2000)='';
		DECLARE @SRC05        AS NVARCHAR(2000)='';
		DECLARE @SRC06        AS NVARCHAR(2000)='';
		DECLARE @SRC07        AS NVARCHAR(2000)='';
		DECLARE @SRC08        AS NVARCHAR(2000)='';
		DECLARE @SRC09        AS NVARCHAR(2000)='';
		DECLARE @SRC10        AS NVARCHAR(2000)='';
	        
		DECLARE @DST00        AS NVARCHAR(2000)='';
		DECLARE @DST01        AS NVARCHAR(2000)='';
		DECLARE @DST02        AS NVARCHAR(2000)='';
		DECLARE @DST03        AS NVARCHAR(2000)='';
		DECLARE @DST04        AS NVARCHAR(2000)='';
		DECLARE @DST05        AS NVARCHAR(2000)='';
		DECLARE @DST06        AS NVARCHAR(2000)='';
		DECLARE @DST07        AS NVARCHAR(2000)='';
		DECLARE @DST08        AS NVARCHAR(2000)='';
		DECLARE @DST09        AS NVARCHAR(2000)='';
		DECLARE @DST10        AS NVARCHAR(2000)='';

		SELECT @SRC00=ValuesFromTheArray.SRC00, 
			   @SRC01=ValuesFromTheArray.SRC01, 
			   @SRC02=ValuesFromTheArray.SRC02, 
			   @SRC03=ValuesFromTheArray.SRC03, 
			   @SRC04=ValuesFromTheArray.SRC04, 
			   @SRC05=ValuesFromTheArray.SRC05, 
			   @SRC06=ValuesFromTheArray.SRC06, 
			   @SRC07=ValuesFromTheArray.SRC07, 
			   @SRC08=ValuesFromTheArray.SRC08, 
			   @SRC09=ValuesFromTheArray.SRC09, 
			   @SRC10=ValuesFromTheArray.SRC10 
		   FROM OPENJSON(@JsonArray)
		WITH(SRC00                       NVARCHAR(2000) '$[0]'
			,SRC01                       NVARCHAR(2000) '$[1]'
			,SRC02                       NVARCHAR(2000) '$[2]'
			,SRC03                       NVARCHAR(2000) '$[3]'
			,SRC04                       NVARCHAR(2000) '$[4]'
			,SRC05                       NVARCHAR(2000) '$[5]'
			,SRC06                       NVARCHAR(2000) '$[6]'
			,SRC07                       NVARCHAR(2000) '$[7]'
			,SRC08                       NVARCHAR(2000) '$[8]'
			,SRC09                       NVARCHAR(2000) '$[9]'
			,SRC10                       NVARCHAR(2000) '$[10]') ValuesFromTheArray

        UPDATE WAVE_NM_PA0182 SET
		   FIRST_NAME  = @SRC01,
		   LAST_NAME   = @SRC02,
		   PREFIX      = @SRC00
		WHERE PERNR=@PERNR AND  ENDDA >= CAST(@WhichDate AS DATE) AND BEGDA<=CAST(@WhichDate AS DATE)

		FETCH NEXT FROM cursor_split INTO @PERNR, @SrcFields;
	END;
 
	CLOSE cursor_split; 
	DEALLOCATE cursor_split;



	PRINT GetDate();
END
GO

IF OBJECT_ID('dbo.SetPhoneNumberForFrance') IS NOT NULL
  DROP FUNCTION SetPhoneNumberForFrance
GO
CREATE FUNCTION SetPhoneNumberForFrance(
    @Value               NVARCHAR(2000)
)
RETURNS NVARCHAR(2000)
BEGIN
    IF ISNULL(@Value, '')='' RETURN '';
    DECLARE @Result   AS NVARCHAR(2000)=@Value;

    SET @Result=(CASE 
					WHEN SUBSTRING(@Value, 1, 5)='00331' THEN '01'+SUBSTRING(@Value, 6, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 5)='00336' THEN '06'+SUBSTRING(@Value, 6, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 5)='00337' THEN '07'+SUBSTRING(@Value, 6, LEN(@Value))

					WHEN SUBSTRING(@Value, 1, 4)='+331' THEN '01'+SUBSTRING(@Value, 5, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 4)='+336' THEN '06'+SUBSTRING(@Value, 5, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 4)='+337' THEN '07'+SUBSTRING(@Value, 5, LEN(@Value))

					WHEN SUBSTRING(@Value, 1, 3)='331' THEN '01'+SUBSTRING(@Value, 4, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 3)='336' THEN '06'+SUBSTRING(@Value, 4, LEN(@Value))
					WHEN SUBSTRING(@Value, 1, 3)='337' THEN '07'+SUBSTRING(@Value, 4, LEN(@Value))

				ELSE @Value END)

   RETURN @Result;
END
GO


IF OBJECT_ID('dbo.SetCamelCaseCharacter') IS NOT NULL
  DROP FUNCTION SetCamelCaseCharacter
GO
CREATE FUNCTION SetCamelCaseCharacter(
   @Value            NVARCHAR(2000)
)  
RETURNS nvarchar(2000)  
BEGIN  
    DECLARE @result AS NVARCHAR(2000)=@Value;

	SET @Value=IIF(dbo.getNonEnglishName(RTRIM(LTRIM(ISNULL(@Value, ''))))='', RTRIM(LTRIM(ISNULL(@Value, ''))), '');
	IF (@Value<>'')
	BEGIN
		DECLARE @i INT;
		DECLARE @w INT;
		DECLARE @j NCHAR(1);

		SELECT @i=1, @w=0, @result = '';
		WHILE (@i <= LEN(@Value))
		BEGIN
			SELECT @j=SUBSTRING(@Value,@i,1),@i=@i+1;
			IF @j COLLATE Latin1_General_BIN like '[a-z]' SET @w=1;
		END

		IF (@w=0)
		BEGIN
			SELECT @i=1, @w=1, @result = '';
			WHILE (@i <= LEN(@Value))
			BEGIN
				SELECT @j= SUBSTRING(@Value,@i,1),
				@result = @result + CASE WHEN @w=1 THEN UPPER(@j) ELSE LOWER(@j) END,
				@i = @i +1;
				IF @j like '[ ]' SET @w=0;
				SET @w = @w +1;
			END
		END
		ELSE SET @result=@Value;
	END

	RETURN @result;
END
GO
--PRINT dbo.SetCamelCaseCharacter(N'Ana Clemente'), Joana Carranca,
--PRINT dbo.SetCamelCaseCharacter('GANCSOV')
--PRINT dbo.SetCamelCaseCharacter(N'TAMÁS')
--PRINT dbo.[GetNonEnglishName](N'TAMÁS')
--DECLARE @Value AS NVARCHAR(MAX) = N'TAMÁS';
--DECLARE @KeepValues AS VARCHAR(MAX) = @Value;
--PRINT @KeepValues
--IF (@Value <> @KeepValues) PRINT @Value;

--PRINT dbo.getNonEnglishName('GANCSOV')

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_TRANDPOSED', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_TRANDPOSED;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_TRANDPOSED] 
      @PHONE_TYPE         AS  VARCHAR(50)
AS
BEGIN
	UPDATE A1
	   SET A1.PERNR=A2.PERNR
	 FROM (SELECT * FROM PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING WHERE emp_group=4) A1 JOIN 
	      (SELECT * FROM PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING WHERE emp_group=3) A2 ON A1.pernr_new=A2.pernr_new

	DECLARE @WORKER_PERSONEL_CONTACT_TRANSPOSED TABLE (
		pernr                      [nvarchar](255),

		[Phone_Country_1]          [nvarchar](255) NULL,
		[Phone_Code_1]             [nvarchar](255) NULL,
		[Phone_1]                  [nvarchar](255) NULL,
		[Phone_Type_1]             [varchar](8) NULL,
		[Phone_Public_1]           [nvarchar](255) NULL,

		[Phone_Country_2]          [nvarchar](255) NULL,
		[Phone_Code_2]             [nvarchar](255) NULL,
		[Phone_2]                  [nvarchar](255) NULL,
		[Phone_Type_2]             [varchar](8) NULL,
		[Phone_Public_2]           [nvarchar](255) NULL,

		[Phone_Country_3]          [nvarchar](255) NULL,
		[Phone_Code_3]             [nvarchar](255) NULL,
		[Phone_3]                  [nvarchar](255) NULL,
		[Phone_Type_3]             [varchar](8) NULL,
		[Phone_Public_3]           [nvarchar](255) NULL,

		[Phone_Country_4]          [nvarchar](255) NULL,
		[Phone_Code_4]             [nvarchar](255) NULL,
		[Phone_4]                  [nvarchar](255) NULL,
		[Phone_Type_4]             [varchar](8) NULL,
		[Phone_Public_4]           [nvarchar](255) NULL,
    
		[Phone_Country_5]          [nvarchar](255) NULL,
		[Phone_Code_5]             [nvarchar](255) NULL,
		[Phone_5]                  [nvarchar](255) NULL,
		[Phone_Type_5]             [varchar](8) NULL,
		[Phone_Public_5]           [nvarchar](255) NULL,

		[Phone_Country_6]          [nvarchar](255) NULL,
		[Phone_Code_6]             [nvarchar](255) NULL,
		[Phone_6]                  [nvarchar](255) NULL,
		[Phone_Type_6]             [varchar](8) NULL,
		[Phone_Public_6]           [nvarchar](255) NULL
	)

    ;WITH CTE_Rank AS
	(
		SELECT [pernr]
 			  ,[Phone_Country]
			  ,[Phone_Code]
			  ,[Phone]
			  ,[Phone_Type]
			  ,[Phone_Public]
			  ,sPhone_Country='Phone_Country_' + CAST(RNUM AS VARCHAR(200))
			  ,sPhone_Code='Phone_Code_' + CAST(RNUM AS VARCHAR(200))
			  ,sPhone='Phone_' + CAST(RNUM AS VARCHAR(200))
			  ,sPhone_Type='Phone_Type_' + CAST(RNUM AS VARCHAR(200))
			  ,sPhone_Public='Phone_Public_' + CAST(RNUM AS VARCHAR(200))
		FROM PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	)
	INSERT INTO @WORKER_PERSONEL_CONTACT_TRANSPOSED
	SELECT PERNR

		  ,Phone_Country_1 = MAX(ISNULL(Phone_Country_1, ''))
		  ,Phone_Code_1 = MAX(ISNULL(Phone_Code_1, ''))
		  ,Phone_1 = MAX(ISNULL(Phone_1, ''))
		  ,Phone_Type_1 = MAX(ISNULL(Phone_Type_1, ''))
		  ,Phone_Public_1 = MAX(ISNULL(Phone_Public_1, ''))

          ,Phone_Country_2 = MAX(ISNULL(Phone_Country_2, ''))
		  ,Phone_Code_2 = MAX(ISNULL(Phone_Code_2, ''))
		  ,Phone_2 = MAX(ISNULL(Phone_2, ''))
		  ,Phone_Type_2 = MAX(ISNULL(Phone_Type_2, ''))
		  ,Phone_Public_2 = MAX(ISNULL(Phone_Public_2, ''))

          ,Phone_Country_3 = MAX(ISNULL(Phone_Country_3, ''))
		  ,Phone_Code_3 = MAX(ISNULL(Phone_Code_3, ''))
		  ,Phone_3 = MAX(ISNULL(Phone_3, ''))
		  ,Phone_Type_3 = MAX(ISNULL(Phone_Type_3, ''))
		  ,Phone_Public_3 = MAX(ISNULL(Phone_Public_3, ''))

          ,Phone_Country_4 = MAX(ISNULL(Phone_Country_4, ''))
		  ,Phone_Code_4 = MAX(ISNULL(Phone_Code_4, ''))
		  ,Phone_4 = MAX(ISNULL(Phone_4, ''))
		  ,Phone_Type_4 = MAX(ISNULL(Phone_Type_4, ''))
		  ,Phone_Public_4 = MAX(ISNULL(Phone_Public_4, ''))

          ,Phone_Country_5 = MAX(ISNULL(Phone_Country_5, ''))
		  ,Phone_Code_5 = MAX(ISNULL(Phone_Code_5, ''))
		  ,Phone_5 = MAX(ISNULL(Phone_5, ''))
		  ,Phone_Type_5 = MAX(ISNULL(Phone_Type_5, ''))
		  ,Phone_Public_5 = MAX(ISNULL(Phone_Public_5, ''))

          ,Phone_Country_6 = MAX(ISNULL(Phone_Country_6, ''))
		  ,Phone_Code_6 = MAX(ISNULL(Phone_Code_6, ''))
		  ,Phone_6 = MAX(ISNULL(Phone_6, ''))
		  ,Phone_Type_6 = MAX(ISNULL(Phone_Type_6, ''))
		  ,Phone_Public_6 = MAX(ISNULL(Phone_Public_6, ''))

	FROM CTE_Rank AS R
		PIVOT(MAX(Phone_Country) FOR sPhone_Country IN (
		       [Phone_Country_1], [Phone_Country_2], [Phone_Country_3], [Phone_Country_4], [Phone_Country_5], [Phone_Country_6])
		   ) Phone_Country
		PIVOT(MAX(Phone_Code) FOR sPhone_Code IN (
		       [Phone_Code_1], [Phone_Code_2], [Phone_Code_3], [Phone_Code_4], [Phone_Code_5], [Phone_Code_6])
		   ) Phone_Code
		PIVOT(MAX(Phone) FOR sPhone IN (
		       [Phone_1], [Phone_2], [Phone_3], [Phone_4], [Phone_5], [Phone_6])
		   ) Phone
		PIVOT(MAX(Phone_Type) FOR sPhone_Type IN (
		       [Phone_Type_1], [Phone_Type_2], [Phone_Type_3],[Phone_Type_4], [Phone_Type_5], [Phone_Type_6])
		   ) Phone_Type
		PIVOT(MAX(Phone_Public) FOR sPhone_Public IN (
		       [Phone_Public_1], [Phone_Public_2], [Phone_Public_3], [Phone_Public_4], [Phone_Public_5], [Phone_Public_6])
		   ) Phone_Public
    GROUP BY PERNR

	--SELECT * FROM @WORKER_PERSONEL_CONTACT_TRANSPOSED

	IF (@PHONE_TYPE='HOME')
	BEGIN
	    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists PERSONNEL_CONTACT_HOME_PHONE_NUMBER_ORDERING;';
	    SELECT * INTO PERSONNEL_CONTACT_HOME_PHONE_NUMBER_ORDERING FROM @WORKER_PERSONEL_CONTACT_TRANSPOSED
	END
	IF (@PHONE_TYPE='WORK')
	BEGIN
	    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists PERSONNEL_CONTACT_WORK_PHONE_NUMBER_ORDERING;';
	    SELECT * INTO PERSONNEL_CONTACT_WORK_PHONE_NUMBER_ORDERING FROM @WORKER_PERSONEL_CONTACT_TRANSPOSED
	END
END 
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_ERROR_LIST', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_ERROR_LIST;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_ERROR_LIST]
AS
BEGIN

     DECLARE @List TABLE (
	     [Build Number]         VARCHAR(MAX),
		 [Report Name]          VARCHAR(MAX),
		 [EmployeeID]           VARCHAR(MAX), 
	     [Country Name]         VARCHAR(MAX), 
		 [Country ISO3 Code]    VARCHAR(MAX), 
		 [Employee Group]       VARCHAR(MAX),
		 [Employee Type]        VARCHAR(MAX),
		 [Error Type]           VARCHAR(MAX),
		 [ErrorText]            VARCHAR(MAX)
	)

    INSERT INTO @List 
	SELECT * FROM (
		SELECT 
		   'P0' [Build Number],
		   'Personnel Contact' [Report Name],
		   [EmployeeID],
		   [Country],
		   [Country Code],
		   [Emp - Group],
		   [wd_emp_type],		   
		   'Employee Name' [ApplicantID],
		   (
		       -- Required fields validation
			   IIF(ISNULL([LegalFirst Name], '')='', '[LegalFirst Name]:- Value should not be empty or null;', 
			                                         dbo.CheckNames('[LegalFirst Name]', [LegalFirst Name], a3.[Country Code], 'English')) +
			   IIF(ISNULL([LegalLast Name], '')='', '[LegalLast Name]:- Value should not be empty or null;', 
			                                         dbo.CheckNames('[LegalLast Name]', [LegalLast Name], a3.[Country Code], 'English')) +

			   IIF(ISNULL([LocalName1 Legal FirstName], '')='' AND a3.[Country Code]='CHN', '[LocalName1 Legal FirstName]:- Value should not be empty or null;', '') +
			   dbo.CheckNames('[LocalName1 Legal FirstName]', [LocalName1 Legal FirstName], a3.[Country Code], 'Non English') +
			   IIF(ISNULL([LocalName1 Legal LastName], '')='' AND a3.[Country Code]='CHN', '[LocalName1 Legal LastName]:- Value should not be empty or null;', '') +
               dbo.CheckNames('[LocalName1 Legal LastName]', [LocalName1 Legal LastName], a3.[Country Code], 'Non English')
			)  ErrorText
		   FROM WD_HR_TR_WorkerPersonalContact a1, WAVE_POSITION_MANAGEMENT a2 LEFT JOIN WAVE_PHONE_VALIDATION a3 ON a3.[Country2 Code]=a2.[Geo - Country (CC)]
		   WHERE a1.EmployeeID=a2.[Emp - Personnel Number] and [Geo - Country (CC)] not in ('PK')

	) a WHERE ErrorText <> ''
	UNION ALL
	SELECT * FROM (
		SELECT 
		   'P0' [Build Number],
		   'Personnel Contact' [Report Name],
		   [EmployeeID],
		   [Country],
		   [Country Code],
		   [Emp - Group],
		   [wd_emp_type],		   
		   'Country ISO Code' [ApplicantID],
		   (
			   -- Country exist in country lkup
			   IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[legalname_CountryISOCode]), '')='', IIF(ISNULL([legalname_CountryISOCode], '') = '', '[legalname_CountryISOCode]:- Value should not be empty or null;', '[legalname_CountryISOCode]:- Value is not in Country lkup;'), '') +
			   IIF([PreferredFirst Name] <> '', IIF(ISNULL((SELECT [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[Preferred Name CountryISO Code]), '')='', IIF(ISNULL([Preferred Name CountryISO Code], '') = '', '[Preferred Name CountryISO Code]:- Value should not be empty or null;', '[Preferred Name CountryISO Code]:- Value is not in Country lkup;'), ''), '') 
			)  ErrorText
		   FROM WD_HR_TR_WorkerPersonalContact a1, WAVE_POSITION_MANAGEMENT a2 LEFT JOIN WAVE_PHONE_VALIDATION a3 ON a3.[Country2 Code]=a2.[Geo - Country (CC)]
		   WHERE a1.EmployeeID=a2.[Emp - Personnel Number] and [Geo - Country (CC)] not in ('PK')

	) a WHERE ErrorText <> ''
	UNION ALL
	SELECT * FROM (
		SELECT 
		   'P0' [Build Number],
		   'Personnel Contact' [Report Name],
		   [EmployeeID],
		   [Country],
		   [Country Code],
		   [Emp - Group],
		   [wd_emp_type],		   
		   'Email Address' [ApplicantID],
		   (
		       -- Email address check
		       dbo.CheckEmailValue('[Email Address]', [Email Address], [Email Address])+
			   dbo.CheckEmailValue('[Email2 Address]', [Email2 Address], [Email Address])+
			   dbo.CheckEmailValue('[Email3 Address]', [Email3 Address], [Email Address])+
			   dbo.CheckEmailValue('[homeEmail Address]', [homeEmail Address], [homeEmail Address])+
			   dbo.CheckEmailValue('[home2Email Address]', [home2Email Address], [homeEmail Address])+
			   dbo.CheckEmailValue('[home3Email Address]', [home3Email Address], [homeEmail Address])
			)  ErrorText
		   FROM WD_HR_TR_WorkerPersonalContact a1, WAVE_POSITION_MANAGEMENT a2 LEFT JOIN WAVE_PHONE_VALIDATION a3 ON a3.[Country2 Code]=a2.[Geo - Country (CC)]
		   WHERE a1.EmployeeID=a2.[Emp - Personnel Number] and [Geo - Country (CC)] not in ('PK')

	) a WHERE ErrorText <> ''
	UNION ALL
	SELECT * FROM (
		SELECT 
		   'P0' [Build Number],
		   'Personnel Contact' [Report Name],
		   [EmployeeID],
		   [Country],
		   [Country Code],
		   [Emp - Group],
		   [wd_emp_type],		   
		   'Phone Number' [ApplicantID],
		   (
			   -- Phone format check
			   IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[primaryworkphonenumber_countryisocode]), '')='', '',
			        dbo.CheckPhoneFormat('[workphone PhoneNumber]', [workphone PhoneNumber], [primaryworkphonenumber_countryisocode], [workphone IntlCd], [workphone PhoneNumber]))+
               IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[workphone2number_countryisocode]), '')='', '',
			        dbo.CheckPhoneFormat('[workphone2 PhoneNumber]', [workphone2 PhoneNumber], [workphone2number_countryisocode], [workphone2 IntlCd], [workphone PhoneNumber]))+
			   IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[workphone3number_countryisocode]), '')='', '',
			        dbo.CheckPhoneFormat('[workphone3 PhoneNumber]', [workphone3 PhoneNumber], [workphone3number_countryisocode], [workphone3 IntlCd], [workphone PhoneNumber]))+
               IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[primaryhomephonenumber_countryISOCode]), '')='', '',
			        dbo.CheckPhoneFormat('[Homephone PhoneNumber]', [Homephone PhoneNumber], [primaryhomephonenumber_countryISOCode], [Homephone IntlCd], [Homephone PhoneNumber])) +
               IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[homephone2number_countryISOCode]), '')='', '', 
			        dbo.CheckPhoneFormat('[Homephone2 PhoneNumber]', [Homephone2 PhoneNumber], [homephone2number_countryISOCode], [Homephone2 IntlCd], [Homephone PhoneNumber])) +
               IIF(ISNULL((SELECT TOP 1 [Country] FROM [COUNTRY_LKUP] WHERE [ISO3]=[homephone3number_countryISOCode]), '')='', '',   
			        dbo.CheckPhoneFormat('[Homephone3 PhoneNumber]', [Homephone3 PhoneNumber], [homephone3number_countryISOCode], [Homephone3 IntlCd], [Homephone PhoneNumber])) 

		   ) ErrorText
		   FROM WD_HR_TR_WorkerPersonalContact a1, WAVE_POSITION_MANAGEMENT a2 LEFT JOIN WAVE_PHONE_VALIDATION a3 ON a3.[Country2 Code]=a2.[Geo - Country (CC)]
		   WHERE a1.EmployeeID=a2.[Emp - Personnel Number] and [Geo - Country (CC)] not in ('PK')

	) a WHERE ErrorText <> ''

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_PERSONNEL_CONTACT_VALIDATION;';
	SELECT * INTO NOVARTIS_DATA_MIGRATION_PERSONNEL_CONTACT_VALIDATION FROM @List

END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT 'P0', 'Worker Personal Contact', '2021-03-10', 'N', 'P0_', 'P0_' 
--SELECT * FROM WD_HR_TR_WorkerPersonalContact ORDER BY EmployeeID
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_ERROR_LIST
--SELECT * FROM NOVARTIS_DATA_MIGRATION_PERSONNEL_CONTACT_VALIDATION ORDER BY [Country Name], [EmployeeID],	[Error Type]

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT]
    @which_wavestage AS NVARCHAR(50),
	@which_report AS NVARCHAR(500),
	@which_date AS NVARCHAR(50),
	@deltaflag AS NVARCHAR(50),
	@PrefixCheck AS NVARCHAR(50),
	@PrefixCopy AS NVARCHAR(50)

AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT 'P0', 'Worker Personal Contact', '2021-03-10', 'N', 'P0_', 'P0_' 
--SELECT * FROM WD_HR_TR_WorkerPersonalContact_Temp ORDER BY EmployeeID
--SELECT * FROM ALCON_MIGRATION_ERROR_LIST WHERE Wave='P0' AND [Report Name]='Worker Personal Contact' ORDER BY [Employee ID]
--SELECT * FROM WAVE_PHONE_VALIDATION_FINAL

	DECLARE @SQL AS VARCHAR(MAX)='drop table if exists WAVE_NM_work_phone_source;
	                              drop table if exists WAVE_NM_address_phone_source';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='drop table if exists WAVE_NM_PHONE_SOURCE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	SET @SQL='drop table if exists WAVE_NM_SUP_ORG_SOURCE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_SUP_ORG_SOURCE FROM '+SUBSTRING(@which_wavestage, 1, 2)+'_SUP_ORG_SOURCE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	
	/* Required Info type table */
	SET @SQL='drop table WAVE_NM_PA0002;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0002 FROM '+@which_wavestage+'_PA0002;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0002', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0006;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0006 FROM '+@which_wavestage+'_PA0006;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0006', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA9008;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA9008 FROM '+@which_wavestage+'_PA9008;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA9008', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0182;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0182 FROM '+@which_wavestage+'_PA0182;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0182', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0539;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0539 FROM '+@which_wavestage+'_PA0539;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0539', @PrefixCheck, @PrefixCopy

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	    ALTER TABLE WAVE_NM_PA0182 ADD FIRST_NAME NVARCHAR(200);
	    ALTER TABLE WAVE_NM_PA0182 ADD MIDDLE_NAME NVARCHAR(200);
	    ALTER TABLE WAVE_NM_PA0182 ADD LAST_NAME NVARCHAR(200);
	    ALTER TABLE WAVE_NM_PA0182 ADD PREFIX NVARCHAR(200);
	';

	/* Split data for Thailand */
	EXEC PROC_SPLIT_INFO_JSON_DATA 'PA0182', ' ', @which_date

	--SELECT COUNT(*) FROM W3_CATCHUP1_POSITION_MANAGEMENT
	SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT
					FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - email address], [emp - group], [emp - personnel number]) RNK    
							FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
				WHERE a.RNK>=1'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	
	select distinct 
	PERNR as persno,
	SUBTY as subtype,
	cast(ENDDA as nvarchar(255)) as EndDate,
	cast(BEGDA as nvarchar(255)) as StartDate,
	ANSSA as Type,
	NAME2 as CareofName,
	STRAS as Street,
	ORT01 as City,
	ORT02 as District,
	RCTVC as municipality,
	PSTLZ as PostalCode,
	LAND1 as Country,
	TELNR as Phone,
	WKWNG as CH,
	BUSRT as Bus,
	LOCAT as AddressLine2,
	ADR03 as Street2,
	ADR04 as Street3,
	STATE as Region,
	HSNMR as Houseno,
	POSTA as Apartment,
	BLDNG as Buildings,
	FLOOR as Floor,
	STRDS as SA,
	COM01 as PhoneType1,
	NUM01 as PhoneNumber1,
	COM02 as PhoneType2,
	NUM02 as PhoneNumber2,
	COM03 as PhoneType3,
	NUM03 as PhoneNumber3,
	COUNC as Prefecture,
	OR1KK,
	OR2KK,
	CONKK
	into WAVE_NM_address_phone_source
    from [dbo].[WAVE_NM_PA0006] a
	join WAVE_NM_SUP_ORG_SOURCE b
	on a.pernr = b.persno
	where a.begDa<=CAST(@which_date as date)
	and a.endda>=CAST(@which_date as date)
	and a.subty in ('1','5')
	and (ISNULL(STRAS, '') <> '' OR ISNULL(LOCAT, '') <> '')

	select *,phone as old_phone,phonenumber1 as old_phone1,
	Phonenumber2 as old_phone2,
	Phonenumber3 as old_phone3
	into WAVE_NM_phone_source
	from WAVE_NM_address_phone_source
	where subtype = '1';

	select distinct
	PERNR as persno,
	SUBTY as subtype,
	cast(ENDDA as nvarchar(255)) as enddate,
	cast(BEGDA as nvarchar(255)) as startdate,
	INTCA as country,
	MAIN_FIX_NO as mainphone,
	SEC_FIX_NO as secondphone,
	MOBILE_NO as mobilephone,
	FAX as faxnumber ,
	MAIN_FIX_NO as old_mainphone,
	SEC_FIX_NO as old_secondphone,
	MOBILE_NO as old_mobilephone,
	FAX as old_faxnumber 
	into WAVE_NM_work_phone_source
	from WAVE_NM_PA9008 a
	join WAVE_NM_SUP_ORG_SOURCE b
	on a.pernr=b.persno
	where endda>=CAST(@which_date as date)
	and begda<=CAST(@which_date as date);

	update WAVE_NM_phone_source
	set phone = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(phone,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	Phonenumber1 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(Phonenumber1,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	Phonenumber2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(Phonenumber2,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	Phonenumber3 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(Phonenumber3,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>','');


	update WAVE_NM_work_phone_source
	set mainphone = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(mainphone,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	secondphone = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(secondphone,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	mobilephone = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(mobilephone,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>',''),
	faxnumber = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(faxnumber,')',''),'(',''),'+',''),' ',''),'-',''),'.',''),',',''),'''',''),'`',''),'/',''),'\',''),'<',''),'>','');

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	alter table WAVE_NM_phone_source
	add phone_Code nvarchar(10);

	alter table WAVE_NM_phone_source
	add phonenumber1_Code nvarchar(10);

	alter table WAVE_NM_phone_source
	add phonenumber2_Code nvarchar(10);

	alter table WAVE_NM_phone_source
	add phonenumber3_Code nvarchar(10);

	alter table WAVE_NM_Work_phone_source
	add mainphone_Code nvarchar(10);

	alter table WAVE_NM_Work_phone_source
	add mobilephone_Code nvarchar(10);

	alter table WAVE_NM_Work_phone_source
	add secondphone_Code nvarchar(10);

	alter table WAVE_NM_Work_phone_source
	add faxnumber_Code nvarchar(10);';

	update WAVE_NM_phone_source set phone=[dbo].[RemoveNonNumeric](phone);
	update WAVE_NM_phone_source set phonenumber1=[dbo].[RemoveNonNumeric](phonenumber1);
	update WAVE_NM_phone_source set phonenumber2=[dbo].[RemoveNonNumeric](phonenumber2);
	update WAVE_NM_phone_source set phonenumber3=[dbo].[RemoveNonNumeric](phonenumber3);
	update WAVE_NM_Work_phone_source set mainphone=[dbo].[RemoveNonNumeric](mainphone);
	update WAVE_NM_Work_phone_source set mobilephone=[dbo].[RemoveNonNumeric](mobilephone);
	update WAVE_NM_Work_phone_source set secondphone=[dbo].[RemoveNonNumeric](secondphone);
	update WAVE_NM_Work_phone_source set faxnumber=[dbo].[RemoveNonNumeric](faxnumber);

	--Change +331 to 01, +336 to 06 and +337 to 07
	--SELECT DISTINCT SUBSTRING(MAIN_FIX_NO, 1, 5) FROM W4_GOLD_PA9008 WHERE BEGDA <= '20210214' AND ENDDA >='20210214' AND PERNR like '06%' AND MAIN_FIX_NO IS NOT NULL
	--SELECT DISTINCT * FROM W4_GOLD_PA9008 WHERE BEGDA <= '20210214' AND ENDDA >='20210214' AND PERNR = '06004850' --AND MAIN_FIX_NO IS NOT NULL
	--SELECT DISTINCT SUBSTRING(mainphone, 1, 4) FROM WAVE_NM_work_phone_source WHERE PERSNO like '06%' AND mainphone IS NOT NULL
	--SELECT * FROM WAVE_NM_work_phone_source WHERE COUNTRY='FR'
	UPDATE WAVE_NM_work_phone_source SET 
	    mainphone=dbo.SetPhoneNumberForFrance(mainphone),
		secondphone=dbo.SetPhoneNumberForFrance(secondphone),
		mobilephone=dbo.SetPhoneNumberForFrance(mobilephone),
		faxnumber=dbo.SetPhoneNumberForFrance(faxnumber)
	WHERE COUNTRY='FR'
	UPDATE WAVE_NM_phone_source SET 
	    phone=dbo.SetPhoneNumberForFrance(phone),
		Phonenumber1=dbo.SetPhoneNumberForFrance(Phonenumber1),
		Phonenumber2=dbo.SetPhoneNumberForFrance(Phonenumber2),
		Phonenumber3=dbo.SetPhoneNumberForFrance(Phonenumber3)
	WHERE COUNTRY='FR'
	
	--SELECT * FROM WAVE_NM_PHONE_SOURCE WHERE PERSNO IN ('01000009', '01000012', '01001122')
	--SELECT * FROM WAVE_NM_Work_phone_source WHERE PERSNO IN ('01000009', '01000012', '01001122')
	update a1
	set phone=(case when a1.country = a2.[country2 code] and len(a1.phone) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.phone, 1, len(a2.[International Phone Code]))=a2.[International Phone Code] 
	                then substring(a1.phone, len(a2.[International Phone Code])+1, len(a1.phone)) else a1.phone end), 
		phone_Code = isnull(a2.[International Phone Code], ''),

		phonenumber1=(case when a1.country = a2.[country2 code] and len(a1.phonenumber1) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.phonenumber1, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.phonenumber1, len(a2.[International Phone Code])+1, len(a1.phonenumber1)) else a1.phonenumber1 end), 
		phonenumber1_Code = isnull(a2.[International Phone Code], ''),

		phonenumber2=(case when a1.country = a2.[country2 code] and len(a1.phonenumber2) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.phonenumber2, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.phonenumber2, len(a2.[International Phone Code])+1, len(a1.phonenumber2)) else a1.phonenumber2 end), 
		phonenumber2_Code = isnull(a2.[International Phone Code], ''),

		phonenumber3=(case when a1.country = a2.[country2 code] and len(a1.phonenumber3) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.phonenumber3, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.phonenumber3, len(a2.[International Phone Code])+1, len(a1.phonenumber3)) else a1.phonenumber3 end), 
		phonenumber3_Code = isnull(a2.[International Phone Code], '')
			
	from WAVE_NM_phone_source a1 left join WAVE_PHONE_VALIDATION a2 on a1.[country]=a2.[country2 code];
	--SELECT * FROM W4_PHONE_VALIDATION WHERE [COUNTRY2 CODE]='DE'
	--SELECT * FROM WAVE_NM_PHONE_SOURCE WHERE PERSNO='01000009'

	update a1
	set mainphone=(case when a1.country = a2.[country2 code] and len(a1.mainphone) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.mainphone, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.mainphone, len(a2.[International Phone Code])+1, len(a1.mainphone)) else a1.mainphone end), 
		mainphone_Code = isnull(a2.[International Phone Code], ''),
	    mobilephone=(case when a1.country = a2.[country2 code] and len(a1.mobilephone) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.mobilephone, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.mobilephone, len(a2.[International Phone Code])+1, len(a1.mobilephone)) else a1.mobilephone end), 
		mobilephone_Code = isnull(a2.[International Phone Code], ''),
		secondphone=(case when a1.country = a2.[country2 code] and len(a1.secondphone) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.secondphone, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.secondphone, len(a2.[International Phone Code])+1, len(a1.secondphone)) else a1.secondphone end), 
	    secondphone_Code = isnull(a2.[International Phone Code], ''),
		faxnumber=(case when a1.country = a2.[country2 code] and len(a1.faxnumber) > cast(isnull(a2.[phone length], '0') as int) and substring(a1.faxnumber, 1, len(a2.[International Phone Code]))=a2.[International Phone Code]
	                then substring(a1.faxnumber, len(a2.[International Phone Code])+1, len(a1.faxnumber)) else a1.faxnumber end), 
	    faxnumber_Code = isnull(a2.[International Phone Code], '')
	from WAVE_NM_Work_phone_source a1 left join WAVE_PHONE_VALIDATION a2 on a1.[country]=a2.[country2 code];
	--SELECT * FROM WAVE_NM_Work_phone_source WHERE PERSNO='40024028'

	update WAVE_NM_phone_source
	set phonetype1='Landline'
	where phonetype1='TEL2';

	update WAVE_NM_phone_source
	set phonetype2='Landline'
	where phonetype2='TEL2';

	update WAVE_NM_phone_source
	set phonetype1='Mobile'
	where phonetype1='Cell';

	update WAVE_NM_phone_source
	set phonetype2='Mobile'
	where phonetype2='Cell';

	SET @SQL='drop table if exists WAVE_NM_phone;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	select [emp - personnel number] as persno,
	b.startdate as eff_Date,
	case when a.persno is not null then a.country else b.country end as country,
	case when phone is not null then a.country end as phone_country,
	case when phone is not null then phone_Code end as phone_Code,
	phone,
	case when phone is not null then 'Landline' end as Phone_Type,
	case when phone is not null then 'N' end as Phone_Public,
	case when phonenumber1 is not null then a.country end as phonenumber1_country,
	case when phonenumber1 is not null then phonenumber1_Code end as phonenumber1_Code,
	phonenumber1,
	case when phonenumber1 is not null then PhoneType1 end as PhoneNumber1_Type,
	case when PhoneNumber1 is not null then 'N' end as PhoneNumber1_Public,
	case when phonenumber2 is not null then a.country end as phonenumber2_country,
	case when phonenumber2 is not null then phonenumber2_Code end as phonenumber2_Code,
	phonenumber2,
	case when phonenumber2 is not null then PhoneType2 end as PhoneNumber2_Type,
	case when PhoneNumber2 is not null then 'N' end as PhoneNumber2_Public,
	case when mainphone is not null then b.country end as mainphone_country,
	case when mainphone is not null then mainphone_Code end as mainphone_Code,
	mainphone,
	case when mainphone is not null then 'Landline' end as mainphone_Type,
	case when mainphone is not null then 'Y' end as mainphone_public,
	case when mobilephone is not null then b.country end as mobilephone_country,
	case when mobilephone is not null then mobilephone_Code end as mobilephone_Code,
	mobilephone,
	case when mobilephone is not null then 'Mobile' end as mobilephone_Type,
	case when mobilephone is not null then 'Y' end as mobilephone_Public,
	case when secondphone is not null then b.country end as secondphone_country,
	case when secondphone is not null then secondphone_Code end as secondphone_Code,
	secondphone,
	case when secondphone is not null then 'Landline' end as secondphone_Type,
	case when secondphone is not null then 'Y' end as secondphone_Public
	into WAVE_NM_phone
	from WAVE_NM_position_management c   --select * from WAVE_NM_position_management
	left join WAVE_NM_phone_source a on a.persno=c.[Emp - Personnel Number]
	full outer join WAVE_NM_work_phone_source b on a.persno = b.persno;

	--SELECT * FROM W4_P1_position_management WHERE [Emp - Personnel Number] IN ('44000353', '06910450')
	--SELECT * FROM WAVE_NM_phone_source WHERE PERSNO IN ('40024028', '06910450')
	--SELECT * FROM WAVE_NM_address_phone_source WHERE PERSNO IN ('40024028', '06910450')
	--SELECT * FROM [WAVE_NM_PA0006] WHERE PERNR IN ('44000353', '06910450')
	--SELECT * FROM WAVE_NM_phone WHERE PERSNO IN ('40024028', '06910450')
	--SELECT * FROM WAVE_NM_phone WHERe PERSNO='41001990';

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	alter table WAVE_NM_phone
	add title nvarchar(255),
	prefix nvarchar(255),
	prefix_type nvarchar(255),
	legal_firstname nvarchar(255),
	legal_lastname nvarchar(255),
	legal_middlename nvarchar(255),
	secondary_fullname nvarchar(255),
	additional_firstname nvarchar(255),
	additional_lastname nvarchar(255),
	additional_nametype nvarchar(255),
	preferred_firstname nvarchar(255),
	preferred_lastname nvarchar(255),
	preferred_eff_Date nvarchar(255),
	Katakana_firstname nvarchar(255),
	Katakana_lastname nvarchar(255),
	Katakana_secondary_fullname nvarchar(255),
	Romaji_firstname nvarchar(255),
	Romaji_lastname nvarchar(255),
	Romaji_secondary_fullname nvarchar(255),
	Katakana_preferred_firstname nvarchar(255),
	Katakana_preferred_lastname nvarchar(255),
	Romaji_preferred_firstname nvarchar(255),
	Romaji_preferred_lastname nvarchar(255),
	Legal_preferred_firstname nvarchar(255),
	Legal_preferred_lastname nvarchar(255);'

	update a 
	set legal_firstname =b.[emp - first name],
	legal_lastname =b.[emp - last name],
	legal_middlename  =b.[emp - middle name],
	preferred_firstname =IIF([geo - work country]='JP', b.[emp - first name], b.[emp - nickname]),
	preferred_lastname=IIF([geo - work country]='JP', '', IIF(ISNULL(b.[emp - nickname], '')='', '', b.[emp - last name])),
	katakana_firstname = [Emp - FName-Katakana],
	katakana_lastname = [Emp - Last Name(Kat)],
	Romaji_firstname = [Emp - FName (Romaji)],
	Romaji_lastname  = [Emp - Last Name(Rom)]
	from  WAVE_NM_phone a
	join WAVE_NM_position_management b
	on persno = [emp - personnel number];

	-- Update Additional names for France
	update a set 
	additional_firstname =IIF(ISNULL(b.[Emp - Name at Birth], '')='', '', a.legal_firstname),
	additional_lastname =ISNULL(b.[Emp - Name at Birth], ''),
	additional_nametype =IIF(ISNULL(b.[Emp - Name at Birth], '')='', '', 'Former')
	from  WAVE_NM_phone a
	join WAVE_NM_position_management b
	on persno = [emp - personnel number]
	where [Geo - Work Country]='FR';
	
	-- Updates secondary full name for Ukraine
	update a1 set 
	secondary_fullname='',
	Katakana_secondary_fullname='',
	Romaji_secondary_fullname=alnam
	from WAVE_NM_phone a1
	join WAVE_NM_position_management A3
	on persno = [emp - personnel number] 
	join(
		select distinct pernr, alnam
		from WAVE_NM_PA0182
		where endda>=CAST(@which_date as date)
		and begda<=CAST(@which_date as date)
	) a2
	on a1.persno = a2.PERNR
	where a3.[Geo - Work Country]='UA';

	update a1 set 
	title=Title_WorkDay
	from WAVE_NM_phone a1
	join WAVE_NM_position_management A3
	on persno = [emp - personnel number] 
	join(
		select distinct pernr, (CASE
		                           WHEN TITEL like 'dr%' THEN 'COUNTRY_PREDEFINED_NAME_COMPONENT_DE_Dr.'
								   WHEN TITEL like 'prof%' THEN 'COUNTRY_PREDEFINED_NAME_COMPONENT_DE_Prof.'
								   ELSE ''
								END) Title_WorkDay
		from WAVE_NM_PA0002
		where endda>=CAST(@which_date as date)
		and begda<=CAST(@which_date as date)
	) a2
	on a1.persno = a2.PERNR
	where a3.[Geo - Work Country]='DE';

    /* Updation for Japan */
	UPDATE WAVE_NM_phone SET 
	    preferred_lastname='',
		katakana_preferred_lastname = '',
		Romaji_preferred_lastname  = ''
	 WHERE [COUNTRY]='JP'

	update a
	set 
	legal_preferred_firstname = a.legal_firstname,
	legal_preferred_lastname = b.legal_preferred_lastname,
	katakana_preferred_firstname = a.Katakana_firstname,
	katakana_preferred_lastname = b.katakana_preferred_lastname,
	Romaji_preferred_firstname = a.Romaji_firstname,
	Romaji_preferred_lastname  = b.Romaji_preferred_lastname,
	preferred_lastname=b.legal_preferred_lastname
	from WAVE_NM_phone a
	join(
		select distinct pernr as persno,
		NABIR as legal_preferred_lastname,
		NAME2 as Romaji_preferred_lastname,
		NABIK as katakana_preferred_lastname 
		from WAVE_NM_PA0002 
		where endda>=CAST(@which_date as date)
		and begda<=CAST(@which_date as date)
		and NABIR IS NOT NULL
	) b
	on a.persno = b.persno	

	/* If preferred last name is nul or empty then empty preferred first name and effective date */
	UPDATE WAVE_NM_phone SET 
	    [preferred_firstname]='',
	    [Preferred_eff_Date]=''
	  WHERE ISNULL(preferred_lastname, '')=''

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	alter table WAVE_NM_phone
	add email nvarchar(255);

	alter table WAVE_NM_phone
	add  country_code nvarchar(255),
	phone_country_Code  nvarchar(255),
	phonenumber1_country_Code  nvarchar(255),
	phonenumber2_country_Code  nvarchar(255),
	mainphone_country_Code  nvarchar(255),
	mobilephone_country_Code  nvarchar(255),
	secondphone_country_Code  nvarchar(255);'

	update a
	set country=b.[Geo - Work Country]
	from WAVE_NM_phone a
    left join WAVE_NM_position_management b on a.persno=b.[Emp - Personnel Number]

	update a
	set country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.country = b.iso2;

	update a
	set phone_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.phone_country= b.iso2;

	update a
	set phonenumber1_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.phonenumber1_country= b.iso2;

	update a
	set phonenumber2_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.phonenumber2_country= b.iso2;

	update a
	set mobilephone_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.mobilephone_country= b.iso2;

	update a
	set secondphone_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.secondphone_country= b.iso2;

	update a
	set mainphone_country_code = iso3
	from WAVE_NM_phone a
	join COUNTRY_LKUP b
	on a.mainphone_country= b.iso2;
	--SELECT * FROM WAVE_NM_phone WHERE PERSNO IN ('40024028')

	--SELECT * FROM W3_POSITION_MANAGEMENT WHERE [Emp - Personnel Number]='25000159'
	--SELECT * FROM WAVE_NM_phone WHERE [PERSNO]='06910450'
	--SELECT * FROM WAVE_NM_workday_prefix WHERE COUNTRY='SG'
    update a
	set prefix_type =[prefix type id],
	prefix =[prefix type],
	preferred_eff_Date =b.startdate
	from WAVE_NM_phone a
	join(
	select distinct pernr as persno,begda as startdate,NACHN as lastname,
	VORNA as firstname,
	MIDNM as middlename,
	RUFNM as preferred_firstname,
	NACHN as preferred_lastname,
	ANRED as title from WAVE_NM_PA0002 
	where endda>=CAST(@which_date as date)
	and begda<=CAST(@which_date as date)) b
	on a.persno = b.persno
	left join COUNTRY_LKUP c
	on a.country = c.iso2
	left join WAVE_PREFIX_TYPE_LKUP d
	on a.country=d.[country code]
	and b.title= d.title;

	--SELECT * FROM WAVE_PREFIX_TYPE_LKUP
	/*
	delete from WAVE_NM_phone
	where persno in (select [emp - personnel number] From WAVE_NM_position_management
	where [emp - group] = '4');
	*/

	--------------------------------------------------------------------------------------
	SET @SQL='drop table if exists [WAVE_NM_phone_final];';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SET @SQL='
	CREATE TABLE [dbo].[WAVE_NM_phone_final](
		[persno] [nvarchar](20) NULL,
		[persno_new] [nvarchar](20) NULL,
		[eff_Date] [nvarchar](255) NULL,
		[country] [nvarchar](255) NULL,

		[phone_country] [nvarchar](255) NULL,
		[phone_Code]  [nvarchar](255) NULL,
		[phone] [nvarchar](255) NULL,
		[Phone_Type] [varchar](8) NULL,
		[Phone_Public] [nvarchar](255) NULL,

		[phonenumber1_country] [nvarchar](255) NULL,
		[phonenumber1_Code]  [nvarchar](255) NULL,
		[phonenumber1] [nvarchar](255) NULL,
		[PhoneNumber1_Type] [nvarchar](255) NULL,
		[PhoneNumber1_Public]  [nvarchar](255) NULL,
		[phonenumber2_country] [nvarchar](255) NULL,
		[phonenumber2_Code] [nvarchar](255) NULL,
		[phonenumber2] [nvarchar](255) NULL,
		[PhoneNumber2_Type] [nvarchar](255) NULL,
		[PhoneNumber2_Public] [nvarchar](255) NULL,
		[mainphone_country] [nvarchar](255) NULL,
		[mainphone_Code] [nvarchar](255) NULL,
		[mainphone] [nvarchar](255) NULL,
		[mainphone_Type]  [nvarchar](255) NULL,
		[mainphone_public] [nvarchar](255) NULL,
		[mobilephone_country] [nvarchar](255) NULL,
		[mobilephone_Code] [nvarchar](255) NULL,
		[mobilephone] [nvarchar](255) NULL,
		[mobilephone_Type] [nvarchar](255) NULL,
		[mobilephone_Public] [nvarchar](255) NULL,
		[secondphone_country] [nvarchar](255) NULL,
		[secondphone_Code] [nvarchar](255) NULL,
		[secondphone] [nvarchar](255) NULL,
		[secondphone_Type] [nvarchar](255) NULL,
		[secondphone_Public] [nvarchar](255) NULL,

		[phone_countryIAs] [nvarchar](255) NULL,
		[phone_CodeIAs]  [nvarchar](255) NULL,
		[phoneIAs] [nvarchar](255) NULL,
		[Phone_TypeIAs] [varchar](8) NULL,
		[Phone_PublicIAs] [nvarchar](255) NULL,
		[phonenumber1_countryIAs] [nvarchar](255) NULL,
		[phonenumber1_CodeIAs]  [nvarchar](255) NULL,
		[phonenumber1IAs] [nvarchar](255) NULL,
		[PhoneNumber1_TypeIAs] [nvarchar](255) NULL,
		[PhoneNumber1_PublicIAs]  [nvarchar](255) NULL,
		[phonenumber2_countryIAs] [nvarchar](255) NULL,
		[phonenumber2_CodeIAs] [nvarchar](255) NULL,
		[phonenumber2IAs] [nvarchar](255) NULL,
		[PhoneNumber2_TypeIAs] [nvarchar](255) NULL,
		[PhoneNumber2_PublicIAs] [nvarchar](255) NULL,
		[mainphone_countryIAs] [nvarchar](255) NULL,
		[mainphone_CodeIAs] [nvarchar](255) NULL,
		[mainphoneIAs] [nvarchar](255) NULL,
		[mainphone_TypeIAs]  [nvarchar](255) NULL,
		[mainphone_publicIAs] [nvarchar](255) NULL,
		[mobilephone_countryIAs] [nvarchar](255) NULL,
		[mobilephone_CodeIAs] [nvarchar](255) NULL,
		[mobilephoneIAs] [nvarchar](255) NULL,
		[mobilephone_TypeIAs] [nvarchar](255) NULL,
		[mobilephone_PublicIAs] [nvarchar](255) NULL,
		[secondphone_countryIAs] [nvarchar](255) NULL,
		[secondphone_CodeIAs] [nvarchar](255) NULL,
		[secondphoneIAs] [nvarchar](255) NULL,
		[secondphone_TypeIAs] [nvarchar](255) NULL,
		[secondphone_PublicIAs] [nvarchar](255) NULL,

		[title] [nvarchar](255) NULL,
		[prefix] [nvarchar](255) NULL,
		[prefix_type] [nvarchar](255) NULL,
		[legal_firstname] [nvarchar](255) NULL,
		[legal_lastname] [nvarchar](255) NULL,
		[legal_middlename] [nvarchar](255) NULL,
		[secondary_fullname] [nvarchar](255) NULL,
		[additional_firstname] nvarchar(255),
		[additional_lastname] nvarchar(255),
		[additional_nametype] nvarchar(255),
		[preferred_firstname] [nvarchar](255) NULL,
		[preferred_lastname] [nvarchar](255) NULL,
		[preferred_eff_Date] [nvarchar](255) NULL,
		[email] [nvarchar](255) NULL,

		[country_code] [nvarchar](255) NULL,
		[phone_country_Code] [nvarchar](255) NULL,
		[phonenumber1_country_Code] [nvarchar](255) NULL,
		[phonenumber2_country_Code] [nvarchar](255) NULL,
		[mainphone_country_Code] [nvarchar](255) NULL,
		[mobilephone_country_Code] [nvarchar](255) NULL,
		[secondphone_country_Code] [nvarchar](255) NULL,

		[country_codeIAs] [nvarchar](255) NULL,
		[phone_country_CodeIAs] [nvarchar](255) NULL,
		[phonenumber1_country_CodeIAs] [nvarchar](255) NULL,
		[phonenumber2_country_CodeIAs] [nvarchar](255) NULL,
		[mainphone_country_CodeIAs] [nvarchar](255) NULL,
		[mobilephone_country_CodeIAs] [nvarchar](255) NULL,
		[secondphone_country_CodeIAs] [nvarchar](255) NULL,

		[katakana_firstname] [nvarchar](255) NULL,
		[katakana_lastname] [nvarchar](255) NULL,
		[Katakana_secondary_fullname] [nvarchar](255) NULL,
		[Romaji_firstname] [nvarchar](255) NULL,
		[Romaji_lastname] [nvarchar](255) NULL,
		[Romaji_secondary_fullname] [nvarchar](255) NULL,

		[legal_preferred_firstname] [nvarchar](255) NULL,
		[legal_preferred_lastname] [nvarchar](255) NULL,
		[katakana_preferred_firstname] [nvarchar](255) NULL,
		[katakana_preferred_lastname] [nvarchar](255) NULL,
		[Romaji_preferred_firstname] [nvarchar](255) NULL,
		[Romaji_preferred_lastname] [nvarchar](255) NULL,
		[Emp_Group] [nvarchar](255) NULL
	) ON [PRIMARY]'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	insert into [WAVE_NM_phone_final]
	select 
	[emp - personnel number] as persno,
	[PERSNO_NEW] as persno_new,
	[eff_Date] ,
	[country] ,

	[phone_country] ,
	[phone_Code]  ,
	[phone] ,
	[Phone_Type] ,
	[Phone_Public] ,

	[phonenumber1_country] ,
	[phonenumber1_Code]  ,
	[phonenumber1] ,
	[PhoneNumber1_Type] ,
	[PhoneNumber1_Public]  ,

	[phonenumber2_country] ,
	[phonenumber2_Code] ,
	[phonenumber2] ,
	[PhoneNumber2_Type] ,
	[PhoneNumber2_Public] ,

	[mainphone_country] ,
	[mainphone_Code] ,
	[mainphone] ,
	[mainphone_Type]  ,
	[mainphone_public] ,

	[mobilephone_country] ,
	[mobilephone_Code] ,
	[mobilephone] ,
	[mobilephone_Type] ,
	[mobilephone_Public] ,

	[secondphone_country] ,
	[secondphone_Code] ,
	[secondphone] ,
	[secondphone_Type] ,
	[secondphone_Public] ,

	'' [phone_countryIAs] ,
	'' [phone_CodeIAs]  ,
	'' [phoneIAs] ,
	'' [Phone_TypeIAs] ,
	'' [Phone_PublicIAs] ,

	'' [phonenumber1_countryIAs] ,
	'' [phonenumber1_CodeIAs]  ,
	'' [phonenumber1IAs] ,
	'' [PhoneNumber1_TypeIAs] ,
	'' [PhoneNumber1_PublicIAs]  ,

	'' [phonenumber2_countryIAs] ,
	'' [phonenumber2_CodeIAs] ,
	'' [phonenumber2IAs] ,
	'' [PhoneNumber2_TypeIAs] ,
	'' [PhoneNumber2_PublicIAs] ,

	'' [mainphone_countryIAs] ,
	'' [mainphone_CodeIAs] ,
	'' [mainphoneIAs] ,
	'' [mainphone_TypeIAs]  ,
	'' [mainphone_publicIAs] ,

	'' [mobilephone_countryIAs] ,
	'' [mobilephone_CodeIAs] ,
	'' [mobilephoneIAs] ,
	'' [mobilephone_TypeIAs] ,
	'' [mobilephone_PublicIAs] ,

	'' [secondphone_countryIAs] ,
	'' [secondphone_CodeIAs] ,
	'' [secondphoneIAs] ,
	'' [secondphone_TypeIAs] ,
	'' [secondphone_PublicIAs] ,

	[title],
	[prefix],
	[prefix_type],
	[legal_firstname],
	[legal_lastname],
	[legal_middlename],
	[secondary_fullname],
	[additional_firstname],
	[additional_lastname],
	[additional_nametype],
	[preferred_firstname],
	[preferred_lastname],
	[preferred_eff_Date],
	[email],
	
	[country_code],
	[phone_country_Code],
	[phonenumber1_country_Code],
	[phonenumber2_country_Code],
	[mainphone_country_Code],
	[mobilephone_country_Code],
	[secondphone_country_Code],

	'' [country_codeIAs],
	'' [phone_country_CodeIAs],
	'' [phonenumber1_country_CodeIAs],
	'' [phonenumber2_country_CodeIAs],
	'' [mainphone_country_CodeIAs],
	'' [mobilephone_country_CodeIAs],
	'' [secondphone_country_CodeIAs],

	[katakana_firstname],
	[katakana_lastname],
	[Katakana_secondary_fullname],
	[Romaji_firstname],
	[Romaji_lastname],
	[Romaji_secondary_fullname],
	[legal_preferred_firstname],
	[legal_preferred_lastname],
	[katakana_preferred_firstname],
	[katakana_preferred_lastname],
	[Romaji_preferred_firstname],
	[Romaji_preferred_lastname],
	[Emp - Group]
	from WAVE_NM_position_management a
	left join WAVE_NM_phone b
	on [emp - personnel number] = b.persno;
	--SELECT * FROM WAVE_NM_phone WHERE PERSNO IN ('41001990')
	--SELECT * FROM WAVE_NM_phone WHERE PERSNO IN ('41001990')

	--Code for IA changes
	--SELECT * FROM [WAVE_NM_phone_final]
	--SELECT * FROM WAVE_NM_phone WHERE 
	DECLARE @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING TABLE (
	    [pernr]          [nvarchar](255) NULL,
		[pernr_new]      [nvarchar](255) NULL,
		[emp_group]      [nvarchar](255) NULL,
		[phone_country]  [nvarchar](255) NULL,
		[phone_Code]     [nvarchar](255) NULL,
		[phone]          [nvarchar](255) NULL,
		[Phone_Type]     [varchar](8) NULL,
		[Phone_Public]   [nvarchar](255) NULL,
		[RNUM]           [nvarchar](255) NULL
	)

	DELETE FROM @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	INSERT INTO @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	SELECT *, ROW_NUMBER() OVER(PARTITION BY persno_new ORDER BY persno_new, Emp_Group) [rnum] FROM (
		SELECT persno, persno_new, Emp_Group, [phone_country], [phone_Code], [phone],	[Phone_Type], [Phone_Public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([phone], '') <> ''
		UNION ALL
		SELECT persno, persno_new, Emp_Group, [phonenumber1_country], 	[phonenumber1_Code], [phonenumber1], [PhoneNumber1_Type], [PhoneNumber1_Public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([phonenumber1], '') <> ''
		UNION ALL
		SELECT persno, persno_new, Emp_Group, [phonenumber2_country], 	[phonenumber2_Code], [phonenumber2], [PhoneNumber2_Type], [PhoneNumber2_Public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([phonenumber2], '') <> ''
     ) A1

	 EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists [PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING];';
	 SELECT * INTO PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING FROM @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	 EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_TRANDPOSED 'HOME'

	 UPDATE PERSONNEL_CONTACT_HOME_PHONE_NUMBER_ORDERING
	    SET PHONE_COUNTRY_1=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_1), ''),
		    PHONE_COUNTRY_2=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_2), ''),
			PHONE_COUNTRY_3=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_3), ''),
			PHONE_COUNTRY_4=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_4), ''),
			PHONE_COUNTRY_5=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_5), ''),
		    PHONE_COUNTRY_6=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_6), '')

	--SELECT * FROM PERSONNEL_CONTACT_HOME_PHONE_NUMBER_ORDERING

	 DELETE FROM @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	 INSERT INTO @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	 SELECT *, ROW_NUMBER() OVER(PARTITION BY persno_new ORDER BY persno_new, Emp_Group) [rnum] FROM (
		SELECT persno, persno_new, Emp_Group, [mainphone_country], [mainphone_Code], [mainphone], [mainphone_Type], [mainphone_public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([mainphone], '') <> ''
		UNION ALL
		SELECT persno, persno_new, Emp_Group, [mobilephone_country], [mobilephone_Code], [mobilephone], [mobilephone_Type], [mobilephone_Public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([mobilephone], '') <> ''
		UNION ALL
		SELECT persno, persno_new, Emp_Group, [secondphone_country], [secondphone_Code], [secondphone], [secondphone_Type], [secondphone_Public] 
			   FROM [WAVE_NM_phone_final] WHERE ISNULL([secondphone], '') <> ''
	) A1

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists [PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING];';
	SELECT * INTO PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING FROM @PERSONNEL_CONTACT_PHONE_NUMBER_ORDERING
	EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT_TRANDPOSED 'WORK'

	 UPDATE PERSONNEL_CONTACT_WORK_PHONE_NUMBER_ORDERING
	    SET PHONE_COUNTRY_1=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_1), ''),
		    PHONE_COUNTRY_2=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_2), ''),
			PHONE_COUNTRY_3=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_3), ''),
			PHONE_COUNTRY_4=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_4), ''),
			PHONE_COUNTRY_5=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_5), ''),
		    PHONE_COUNTRY_6=ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=PHONE_COUNTRY_6), '')

	--SELECT * FROM PERSONNEL_CONTACT_WORK_PHONE_NUMBER_ORDERING

	update a
	set email = [Emp - Email Address]
	From WAVE_NM_phone_final a
	join WAVE_NM_position_management b
	on a.persno = b.[emp - personnel number];

	/* WD_HR_TR_WorkerPersonalContact_Temp table creation */
	SET @SQL='drop table if exists WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES
					FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY [PERSNO] ORDER BY [PERSNO], [emp_group], [email] DESC, [phone] DESC) RNK    
							FROM WAVE_NM_phone_final) a
				WHERE a.RNK=1'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	delete from WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES where persno = '34006132';

	SET @SQL='drop table if exists WD_HR_TR_WorkerPersonalContact_Temp;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	SELECT
	   ISNULL(a.persno_new, '') [LegacySystem ID]
      ,ISNULL(a.persno_new, '')  [EmployeeID]
      ,a.persno [ApplicantID]
      ,IIF(ISNULL(eff_date, '')='', '', CONVERT(varchar(10), CAST(eff_date as date), 101)) [ApplicantEntered Date]
      ,IIF(ISNULL(preferred_eff_date, '')='', '', CONVERT(varchar(10), CAST(preferred_eff_date as date), 101)) [Legal Name Effective Date]
      ,ISNULL(country_code, '') [legalname_CountryISOCode]
	  ,ISNULL(title, '') [Legal Name Prefix Title]
      ,ISNULL(prefix, '') [Legal Name Prefix]
      ,ISNULL(prefix_type, '') [Legal Name PrefixType]
	  ,'' as [LegalFull Name]
      ,dbo.SetCamelCaseCharacter(ISNULL(legal_firstname, '')) [LegalFirst Name]
	  --,ISNULL(legal_firstname, '') [LegalFirst Name]
      ,dbo.SetCamelCaseCharacter(ISNULL(legal_middlename, '')) [LegalMiddle Name]
	  --,ISNULL(legal_middlename, '') [LegalMiddle Name]
      ,ISNULL('', '') [MothersMaidenName]
      ,''[Last Name Type]
      ,dbo.SetCamelCaseCharacter(ISNULL(legal_lastname, '')) [LegalLast Name]
	  --,ISNULL(legal_lastname, '') [LegalLast Name]
      ,''[Legal Secondary Name Type]
      ,''[Legal SecondaryName]
      ,''[Legal Name Suffix]
      ,''[Legal Name SuffixType]

      ,IIF(ISNULL([Preferred_firstname],'')='','',IIF(ISNULL([Preferred_eff_Date], '')='', '', CONVERT(varchar(10), CAST([Preferred_eff_Date] as date), 101))) [Preferred Name Effective Date]
      ,IIF(ISNULL([Preferred_firstname],'')='','', IIF(ISNULL([country_code], '')='', '', [country_code])) [Preferred Name CountryISO Code]
      ,''[Preferred Name PrefixType]
      ,''[Preferred Name Prefix]
	  ,'' [Preferred Full Name]
      ,ISNULL(preferred_firstname, '') [PreferredFirst Name]
      ,''[PreferredMiddle Name]
      ,''[Preferred Last Name Type]
      ,ISNULL(preferred_lastname, '')  [PreferredLast Name]
      ,''[Preferred Secondary Name Type]
      ,''[Preferred SecondaryName]
      ,''[preferred Name SuffixType]
      ,''[Preferred Name Suffix]

      ,''[LocalName1 Legal Name]
	  ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([Romaji_secondary_fullname], ''), ISNULL([katakana_secondary_fullname], '')) [LocalName1 Secondary FullName]
      ,IIF((ISNULL([country_code], '') IN ('JPN')), IIF(ISNULL([Romaji_firstname],'')='','','Kanji'), '') [LocalName1 Legal Script]
      ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([Romaji_firstname],''), ISNULL([katakana_firstname],'')) as [LocalName1 Legal FirstName]
      ,''[LocalName1 Legal MiddleName]
      ,''[LocalName1 Legal Last NameType]
      ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([Romaji_lastname],''), ISNULL([katakana_lastname],'')) as [LocalName1 Legal LastName]
	  ,''[LocalName2 Legal Name]
	  ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([Katakana_secondary_fullname], ''), ISNULL([Romaji_secondary_fullname], '')) [LocalName2 Secondary FullName]
      ,IIF(ISNULL([country_code], '') IN ('JPN'), IIF(isnull([katakana_firstname],'')='','','Furigana'), '') [LocalName2 Legal Script]
      ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([katakana_firstname],''), ISNULL([Romaji_firstname],'')) as [LocalName2 Legal FirstName]
      ,''[LocalName2 Legal MiddleName]
      ,'' [LocalName2 Legal Last NameType]
      ,IIF((ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR')), ISNULL([katakana_lastname],''), ISNULL([Romaji_lastname],'')) as [LocalName2 Legal LastName]

	  ,''[LocalName1 Preferred Name]
      ,IIF(ISNULL([country_code], '') IN ('JPN'), IIF(isnull([Romaji_preferred_firstname],'')='','','Kanji'), '') [LocalName1 Preferred Script]
      ,IIF(ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR'), ISNULL([Romaji_preferred_firstname],''), ISNULL([katakana_preferred_firstname],'')) as [LocalName1 Preferred FirstName]
      ,''[LocalName1 Preferred MiddleName]
      ,''[LocalName1 Preferred Last NameType]
      ,IIF(ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR'), ISNULL([Romaji_preferred_lastname],''), ISNULL([katakana_preferred_lastname],'')) as [LocalName1 Preferred LastName]
	  ,''[LocalName2 Preferred Name]
      ,IIF(ISNULL([country_code], '') IN ('JPN'), IIF(isnull([katakana_preferred_firstname],'')='','','Furigana'), '') [LocalName2 Preferred Script]
      ,IIF(ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR'), ISNULL([katakana_preferred_firstname],''), ISNULL([Romaji_preferred_firstname],'')) as [LocalName2 Preferred FirstName]
      ,''[LocalName2 Preferred MiddleName]
      ,''[LocalName2 Preferred Last NameType]
      ,IIF(ISNULL([country_code], '') IN ('JPN', 'CHE', 'CZE', 'RUS', 'UKR'), ISNULL([katakana_preferred_lastname],''), ISNULL([Romaji_preferred_lastname],'')) as [LocalName2 Preferred LastName] 

	  ,ISNULL(additional_nametype, '') [Additional Name Type]
      ,''[Additional Effective Date]
	  ,'' [Additional Country ISO Code]
	  ,''[Additional PrefixType]
	  ,''[Additional Prefix]
      ,ISNULL(additional_firstname, '') [AdditionalFirst Name]
      ,''[AdditionalMiddle Name]
      ,''[additional Last Name Type]
      ,ISNULL(additional_lastname, '') [AdditionalLast Name]
      ,''[additional Secondary Name Type]
      ,''[additional SecondaryName]
      ,''[additional SuffixType]
      ,''[additional Suffix]
      ,REPLACE(REPLACE(ISNULL(email, ''), char(39), ''''), ',', '') [Email Address]
      ,''[Email Comment]
      ,''[email Public]
      ,''[Email2 Address]
      ,''[Email2 Comment]
      ,''[email2 Public]
      ,''[Email3 Address]
      ,''[Email3 Comment]
      ,''[email3 Public]
      ,''[homeEmail Address]
      ,''[homeEmail Comment]
      ,''[home Public]
      ,''[home2Email Address]
      ,''[home2Email Comment]
      ,''[home2 Public]
      ,''[home3Email Address]
      ,''[home3Email Comment]
      ,''[home3 Public]

	  --Normal associates
      ,IIF(ISNULL(c.Phone_1, '')='', '', ISNULL(c.Phone_Country_1, '')) [primaryworkphonenumber_countryisocode]
      ,IIF(ISNULL(c.Phone_1, '')='', '', ISNULL(c.Phone_Code_1, '')) [workphone IntlCd]
      ,''[workphone AreaCode]
      ,IIF(ISNULL(c.Phone_1, '')='', '', ISNULL(c.Phone_1, '')) [workphone PhoneNumber]
      ,'' [workphone PhoneExtension]
      ,IIF(ISNULL(c.Phone_1, '')='', '', ISNULL(c.Phone_Type_1, 'Landline'))  [workphone PhoneType]
      ,IIF(ISNULL(c.Phone_1, '')='', '', ISNULL(c.Phone_Public_1, ''))  [workphone Public]

      ,IIF(ISNULL(c.Phone_2, '')='', '', ISNULL(c.Phone_Country_2, ''))  [workphone2number_countryisocode]
      ,IIF(ISNULL(c.Phone_2, '')='', '', ISNULL(c.Phone_Code_2, ''))  [workphone2 IntlCd]
      ,''[workphone2 AreaCode]
      ,IIF(ISNULL(c.Phone_2, '')='', '', ISNULL(c.Phone_2, ''))  [workphone2 PhoneNumber]
      ,''[workphone2 PhoneExtension]
      ,IIF(ISNULL(c.Phone_2, '')='', '', ISNULL(c.Phone_Type_2, 'Landline'))  [workphone2 PhoneType]
      ,IIF(ISNULL(c.Phone_2, '')='', '', ISNULL(c.Phone_Public_2, ''))  [workphone2 Public]

      ,IIF(ISNULL(c.Phone_3, '')='', '', ISNULL(c.Phone_Country_3, ''))  [workphone3number_countryisocode]
      ,IIF(ISNULL(c.Phone_3, '')='', '', ISNULL(c.Phone_Code_3, ''))  [workphone3 IntlCd]
      ,''[workphone3 AreaCode]
      ,IIF(ISNULL(c.Phone_3, '')='', '', ISNULL(c.Phone_3, ''))  [workphone3 PhoneNumber]
      ,''[workphone3 PhoneExtension]
      ,IIF(ISNULL(c.Phone_3, '')='', '', ISNULL(c.Phone_Type_3, 'Landline'))  [workphone3 PhoneType]
      ,IIF(ISNULL(c.Phone_3, '')='', '', ISNULL(c.Phone_Public_3, ''))  [workphone3 Public]

      ,IIF(ISNULL(d.Phone_1, '')='', '', ISNULL(d.Phone_Country_1, '')) [primaryhomephonenumber_countryISOCode]
      ,IIF(ISNULL(d.Phone_1, '')='', '', ISNULL(d.Phone_Code_1, '')) [Homephone IntlCd]
      ,''[Homephone AreaCode]
      ,IIF(ISNULL(d.Phone_1, '')='', '', ISNULL(d.Phone_1, ''))  [Homephone PhoneNumber]
      ,''[Homephone PhoneExtension]
      ,IIF(ISNULL(d.Phone_1, '')='', '', ISNULL(d.Phone_Type_1, 'Landline'))  [Homephone PhoneType]
      ,IIF(ISNULL(d.Phone_1, '')='', '', ISNULL(d.Phone_Public_1, ''))  [Homephone Public]

      ,IIF(ISNULL(d.Phone_2, '')='', '', ISNULL(d.Phone_Country_2, ''))  [homephone2number_countryISOCode]
      ,IIF(ISNULL(d.Phone_2, '')='', '', ISNULL(d.Phone_Code_2, ''))  [Homephone2 IntlCd]
      ,''[Homephone2 AreaCode]
      ,IIF(ISNULL(d.Phone_2, '')='', '', ISNULL(d.Phone_2, ''))  [Homephone2 PhoneNumber]
      ,''[Homephone2 PhoneExtension]
      ,IIF(ISNULL(d.Phone_2, '')='', '', ISNULL(d.Phone_Type_2, 'Landline')) [Homephone2 PhoneType]
      ,IIF(ISNULL(d.Phone_2, '')='', '', ISNULL(d.Phone_Public_2, ''))  [Homephone2 Public]

      ,IIF(ISNULL(d.Phone_3, '')='', '', ISNULL(d.Phone_Country_3, ''))  [homephone3number_countryISOCode]
      ,IIF(ISNULL(d.Phone_3, '')='', '', ISNULL(d.Phone_Code_3, ''))  [Homephone3 IntlCd]
      ,''[Homephone3 AreaCode]
      ,IIF(ISNULL(d.Phone_3, '')='', '', ISNULL(d.Phone_3, ''))  [Homephone3 PhoneNumber]
      ,''[Homephone3 PhoneExtension]
      ,IIF(ISNULL(d.Phone_3, '')='', '', ISNULL(d.Phone_Type_3, 'Landline'))  [Homephone3 PhoneType]
      ,IIF(ISNULL(d.Phone_3, '')='', '', ISNULL(d.Phone_Public_3, ''))  [Homephone3 Public]

	  /*
	  --IA associates
      ,IIF(ISNULL(mainphoneIAs, '')='', '', ISNULL(mainphone_country_codeIAs, '')) [primaryworkphonenumber_countryisocodeIAs]
      ,IIF(ISNULL(mainphoneIAs, '')='', '', ISNULL(mainphone_codeIAs, '')) [workphone IntlCdIAs]
      ,''[workphone AreaCodeIAs]
      ,IIF(ISNULL(mainphoneIAs, '')='', '', ISNULL(mainphoneIAs, '')) [workphone PhoneNumberIAs]
      ,'' [workphone PhoneExtensionIAs]
      ,IIF(ISNULL(mainphoneIAs, '')='', '', ISNULL(mainphone_typeIAs, 'Landline'))  [workphone PhoneTypeIAs]
      ,IIF(ISNULL(mainphoneIAs, '')='', '', ISNULL(mainphone_publicIAs, ''))  [workphone PublicIAs]

      ,IIF(ISNULL(mobilephoneIAs, '')='', '', ISNULL(mobilephone_country_CodeIAs, ''))  [workphone2number_countryisocodeIAs]
      ,IIF(ISNULL(mobilephoneIAs, '')='', '', ISNULL(mobilephone_CodeIAs, ''))  [workphone2 IntlCdIAs]
      ,''[workphone2 AreaCodeIAs]
      ,IIF(ISNULL(mobilephoneIAs, '')='', '', ISNULL(mobilephoneIAs, ''))  [workphone2 PhoneNumberIAs]
      ,''[workphone2 PhoneExtensionIAs]
      ,IIF(ISNULL(mobilephoneIAs, '')='', '', ISNULL(mobilephone_typeIAs, 'Landline'))  [workphone2 PhoneTypeIAs]
      ,IIF(ISNULL(mobilephoneIAs, '')='', '', ISNULL(mobilephone_PublicIAs, ''))  [workphone2 PublicIAs]

      ,IIF(ISNULL(secondphoneIAs, '')='', '', ISNULL(secondphone_country_CodeIAs, ''))  [workphone3number_countryisocodeIAs]
      ,IIF(ISNULL(secondphoneIAs, '')='', '', ISNULL(secondphone_CodeIAs, ''))  [workphone3 IntlCdIAs]
      ,''[workphone3 AreaCodeIAs]
      ,IIF(ISNULL(secondphoneIAs, '')='', '', ISNULL(secondphoneIAs, ''))  [workphone3 PhoneNumberIAs]
      ,''[workphone3 PhoneExtensionIAs]
      ,IIF(ISNULL(secondphoneIAs, '')='', '', ISNULL(secondphone_TypeIAs, 'Landline'))  [workphone3 PhoneTypeIAs]
      ,IIF(ISNULL(secondphoneIAs, '')='', '', ISNULL(secondphone_PublicIAs, ''))  [workphone3 PublicIAs]

      ,IIF(ISNULL(phoneIAs, '')='', '', ISNULL(phone_country_CodeIAs, '')) [primaryhomephonenumber_countryISOCodeIAs]
      ,IIF(ISNULL(phoneIAs, '')='', '', ISNULL(phone_CodeIAs, '')) [Homephone IntlCdIAs]
      ,''[Homephone AreaCodeIAs]
      ,IIF(ISNULL(phoneIAs, '')='', '', ISNULL(phoneIAs, ''))  [Homephone PhoneNumberIAs]
      ,''[Homephone PhoneExtensionIAs]
      ,IIF(ISNULL(phoneIAs, '')='', '', ISNULL(Phone_TypeIAs, 'Landline'))  [Homephone PhoneTypeIAs]
      ,IIF(ISNULL(phoneIAs, '')='', '', ISNULL(Phone_PublicIAs, ''))  [Homephone PublicIAs]

      ,IIF(ISNULL(phonenumber1IAs, '')='', '', ISNULL(phonenumber1_country_CodeIAs, ''))  [homephone2number_countryISOCodeIAs]
      ,IIF(ISNULL(phonenumber1IAs, '')='', '', ISNULL(phonenumber1_CodeIAs, ''))  [Homephone2 IntlCdIAs]
      ,''[Homephone2 AreaCodeIAs]
      ,IIF(ISNULL(phonenumber1IAs, '')='', '', ISNULL(phonenumber1IAs, ''))  [Homephone2 PhoneNumberIAs]
      ,''[Homephone2 PhoneExtensionIAs]
      ,IIF(ISNULL(phonenumber1IAs, '')='', '', ISNULL(phoneNumber1_TypeIAs, 'Landline')) [Homephone2 PhoneTypeIAs]
      ,IIF(ISNULL(phonenumber1IAs, '')='', '', ISNULL(phoneNumber1_PublicIAs, ''))  [Homephone2 PublicIAs]

      ,IIF(ISNULL(phonenumber2IAs, '')='', '', ISNULL(phonenumber2_country_CodeIAs, ''))  [homephone3number_countryISOCodeIAs]
      ,IIF(ISNULL(phonenumber2IAs, '')='', '', ISNULL(phonenumber2_CodeIAs, ''))  [Homephone3 IntlCdIAs]
      ,''[Homephone3 AreaCodeIAs]
      ,IIF(ISNULL(phonenumber2IAs, '')='', '', ISNULL(phonenumber2IAs, ''))  [Homephone3 PhoneNumberIAs]
      ,''[Homephone3 PhoneExtensionIAs]
      ,IIF(ISNULL(phonenumber2IAs, '')='', '', ISNULL(PhoneNumber2_TypeIAs, 'Landline'))  [Homephone3 PhoneTypeIAs]
      ,IIF(ISNULL(phonenumber2IAs, '')='', '', ISNULL(PhoneNumber2_PublicIAs, ''))  [Homephone3 PublicIAs]
	  */

      ,''[Web1 WebAddress]
      ,''[Web1 Web Address Comment]
      ,''[Web1 Public]
      ,''[Web2 WebAddress]
      ,''[Web2 Web Address Comment]
      ,''[Web2 Public]
      ,''[Web3 WebAddress]
      ,''[Web3 Web Address Comment]
      ,''[Web3 Public]
      ,''[IM1 IMAddress]
      ,''[IM1 IM Comments]
      ,''[IM1 IM Provider]
      ,''[IM1 Public]
      ,''[IM2 IMAddress]
      ,''[IM2 IM Comments]
      ,''[IM2 IMProvider]
      ,''[IM2 Public]
      ,''[IM3 IMAddress]
      ,''[IM3 IM Comments]
      ,''[IM3 IMProvider]
      ,''[IM3 Public]
	  ,a.[Emp_Group]
	INTO WD_HR_TR_WorkerPersonalContact_Temp
	FROM WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES a
	LEFT JOIN WAVE_NM_POSITION_MANAGEMENT b ON a.persno=b.[Emp - Personnel Number]
	LEFT JOIN PERSONNEL_CONTACT_WORK_PHONE_NUMBER_ORDERING c ON c.PERNR= a.PERSNO
	LEFT JOIN PERSONNEL_CONTACT_HOME_PHONE_NUMBER_ORDERING d ON d.PERNR= a.PERSNO;

	--SELECt * FROM W4_PHONE_VALIDATION WHERE [COUNTRY CODE]='ISR'
	--SELECT * FROM WD_HR_TR_WorkerPersonalContact_Temp

	/* Switzerland Last name and Middle Name changes */
	UPDATE WD_HR_TR_WorkerPersonalContact_Temp 
	      SET [LegalLast Name]=IIF(ISNULL([LegalMiddle Name], '')='', [LegalLast Name], [LegalMiddle Name]+' '+[LegalLast Name])
	WHERE ([legalname_CountryISOCode]='CHE' OR [legalname_CountryISOCode]='ISR')
	UPDATE WD_HR_TR_WorkerPersonalContact_Temp 
	      SET [LegalMiddle Name]=''
	WHERE ([legalname_CountryISOCode]='CHE' OR [legalname_CountryISOCode]='ISR')

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
		    ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [LocalName1 Legal Name] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [LocalName1 Legal FirstName] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [LocalName1 Legal MiddleName] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [LocalName1 Legal LastName] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [Preferred Name Prefix] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [LegalFull Name] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [Preferred Full Name] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [PreferredFirst Name] NVARCHAR(MAX);
			ALTER TABLE WD_HR_TR_WorkerPersonalContact_Temp ALTER COLUMN [PreferredLast Name] NVARCHAR(MAX);
	';

	PRINT 'THAILAND CHANGES'
	UPDATE a
		SET 
			[LocalName1 Legal Script]='',
			[Preferred Name Prefix]='',
	        [LocalName1 Legal FirstName]=ISNULL(b.[PREFIX], N'')+' '+ISNULL(b.[FIRST_NAME], N''),
	        [LocalName1 Legal LastName]=ISNULL(b.[LAST_NAME], N'')

	FROM WD_HR_TR_WorkerPersonalContact_Temp a 
         JOIN (SELECT DISTINCT PERNR, [PREFIX], [FIRST_NAME], [LAST_NAME]  
		            FROM WAVE_NM_PA0182 
					WHERE ENDDA >= CAST(@which_date AS DATE) AND BEGDA<=CAST(@which_date AS DATE)) b ON a.[ApplicantID]=b.[PERNR]
	WHERE [legalname_CountryISOCode] = 'THA'
	PRINT 'THAILAND CHANGES done'

	PRINT 'KOREA CHANGES'
	UPDATE a
		SET 
			[LocalName1 Legal Script]='',
			[Preferred Name Prefix]='',
	        [LocalName1 Legal FirstName]=ISNULL(b.[FIRST_NAME], N''),
	        [LocalName1 Legal LastName]=ISNULL(b.[LAST_NAME], N'')

	FROM WD_HR_TR_WorkerPersonalContact_Temp a 
        JOIN (SELECT DISTINCT PERNR, [FNMHG] [FIRST_NAME], [LNMHG] [LAST_NAME]  
		            FROM WAVE_NM_PA0539 
					WHERE ENDDA >= CAST(@which_date AS DATE) AND BEGDA<=CAST(@which_date AS DATE)) b ON a.[ApplicantID]=b.[PERNR]
	WHERE [legalname_CountryISOCode] = 'KOR'
	--SELECT * FROM W3_CATCHUP1_PA0539

	PRINT 'KOR CHANGES done'

	PRINT 'PORTUGAL CHANGES'
	UPDATE A1 SET
	      [Preferred Name Effective Date]=IIF(ISNULL(A3.CNAME, '')='','', [Legal Name Effective Date]),
		  [Preferred Name CountryISO Code]=IIF(ISNULL(A3.CNAME, '')='','', [legalname_CountryISOCode]), 
	      [Preferred Full Name]=dbo.SetCamelCaseCharacter(ISNULL(A3.CNAME, '')),
		  [PreferredFirst Name]=dbo.SetCamelCaseCharacter(IIF(ISNULL(A3.CNAME, '') = '', '', 
		                            SUBSTRING(A3.CNAME, 1, IIF(CHARINDEX([LegalLast Name], A3.CNAME)=0, LEN([LegalLast Name]), CHARINDEX([LegalLast Name], A3.CNAME)-1)))),
		  [PreferredLast Name]=dbo.SetCamelCaseCharacter(IIF(ISNULL(A3.CNAME, '') = '', '', SUBSTRING(A3.CNAME, CHARINDEX([LegalLast Name], A3.CNAME), LEN(A3.[CNAME]))))
	  FROM WD_HR_TR_WorkerPersonalContact_Temp A1 
	       JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.[ApplicantID]=A2.[Emp - Personnel Number]
		   JOIN WAVE_NM_PA0002 A3 ON  A1.[ApplicantID]=A3.PERNR
      WHERE A2.[Geo - Work Country]='PT'
	  --SELECT PERNR, CNAME FROM WAVE_NM_PA0002 WHERE PERNR LIKE '19%' AND CNAME IS NULL

	/* Custom data changes */
	UPDATE WD_HR_TR_WorkerPersonalContact_Temp SET [LocalName1 Legal FirstName]='' WHERE [LocalName1 Legal FirstName]='RO';
	UPDATE WD_HR_TR_WorkerPersonalContact_Temp SET [PreferredFirst Name]=N'Sheila Campos dos', [PreferredLast Name]=N'Santos Patrício' WHERE EmployeeID='19003388'


	/* Interchange Legal name with Preffered legal name */
	DECLARE @LegalNameInterChange TABLE (
	     PERNR                        NVARCHAR(2000),
		  
	     LEGAL_NAME                   NVARCHAR(2000),
		 LEGAL_FIRST_NAME             NVARCHAR(2000),
		 LEGAL_LAST_NAME              NVARCHAR(2000),

	     PREFERRED_LEGAL_NAME         NVARCHAR(2000),
		 PREFERRED_LEGAL_FIRST_NAME   NVARCHAR(2000),
		 PREFERRED_LEGAL_LAST_NAME    NVARCHAR(2000)
	)
	INSERT @LegalNameInterChange
	    SELECT [ApplicantID], [Preferred Full Name], [PreferredFirst Name], [PreferredLast Name], [LegalFull Name], [LegalFirst Name], [LegalLast Name] 
		FROM WD_HR_TR_WorkerPersonalContact_Temp WHERE [legalname_CountryISOCode]='PRT' AND [Emp_Group] NOT IN ('7', '9')

	UPDATE A1 SET
	   A1.[LegalFull Name]=A2.LEGAL_NAME,
	   A1.[LegalFirst Name]=A2.LEGAL_FIRST_NAME,
	   A1.[LegalLast Name]=A2.LEGAL_LAST_NAME,
	   A1.[Preferred Full Name]=A2.PREFERRED_LEGAL_NAME,
	   A1.[PreferredFirst Name]=A2.PREFERRED_LEGAL_FIRST_NAME,
	   A1.[PreferredLast Name]=A2.PREFERRED_LEGAL_LAST_NAME
	FROM WD_HR_TR_WorkerPersonalContact_Temp A1 JOIN @LegalNameInterChange A2 ON A1.[ApplicantID]=A2.PERNR

	/*Delta sheet*/
	SET @SQL='drop table if exists WD_HR_TR_WorkerPersonalContact_Temp_DELTA;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SELECT * INTO WD_HR_TR_WorkerPersonalContact_Temp_DELTA 
	   FROM WD_HR_TR_WorkerPersonalContact_Temp
	   WHERE [AdditionalLast Name] <> '';

	--SELECT * INTO WD_HR_TR_WorkerPersonalContact_Temp_DELTA 
	--   FROM WD_HR_TR_WorkerPersonalContact_Temp
	--   WHERE [LocalName1 Legal FirstName] <> '' OR legalname_CountryISOCode = 'PRT' OR [Legal Name Prefix Title] <> '' OR [ApplicantID]='18003336';

	SET @SQL='drop table if exists WD_HR_TR_WorkerPersonalContact_DELTA;
	          drop table if exists WD_HR_TR_WorkerPersonalContact;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SELECT * INTO WD_HR_TR_WorkerPersonalContact FROM WD_HR_TR_WorkerPersonalContact_Temp;
	SELECT * INTO WD_HR_TR_WorkerPersonalContact_DELTA FROM WD_HR_TR_WorkerPersonalContact_Temp_DELTA;
	
	/* Temporary Table for getting Persno */
	SET @SQL='drop table if exists '+@which_wavestage+'_WorkerPersonalContact_PERSNO;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO '+@which_wavestage+'_WorkerPersonalContact_PERSNO FROM WD_HR_TR_WorkerPersonalContact_Temp;'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	/* Worker Personal Contact Error List */
	SET @SQL='drop table if exists WAVE_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_POSITION_MANAGEMENT FROM WAVE_NM_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	/*
    PRINT 'Sub Query'
	DELETE FROM ALCON_MIGRATION_ERROR_LIST WHERE Wave=@which_wavestage AND [Report Name]=@which_report;
	INSERT INTO ALCON_MIGRATION_ERROR_LIST	
	SELECT @which_wavestage, @which_report, EmployeeID, CountryCC, ErrorText FROM dbo.GetPersonalContact('Wave 4');
	*/    

	UPDATE WD_HR_TR_WorkerPersonalContact SET [ApplicantID]='';
	SET @SQL='ALTER TABLE WD_HR_TR_WorkerPersonalContact DROP COLUMN Emp_Group;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	UPDATE WD_HR_TR_WorkerPersonalContact_DELTA SET [ApplicantID]='';
	SET @SQL='ALTER TABLE WD_HR_TR_WorkerPersonalContact_DELTA DROP COLUMN Emp_Group;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
END
GO

--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_PERSONAL_CONTACT 'P0', 'Worker Personal Contact', '2021-03-10', 'N', 'P0_', 'P0_' 
--SELECT * FROM WD_HR_TR_WorkerPersonalContact ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE EmployeeID IN ('85008171', '02117513') ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE [EmployeeID] like '06%' ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact_DELTA ORDER BY EmployeeID
--SELECT * FROM ALCON_MIGRATION_ERROR_LIST WHERE Wave='W4_P2' AND [Report Name]='Worker Personal Contact' ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE EmployeeID='19003388' ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE [LegalFirst Name] = '' ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE [LocalName1 Legal FirstName] <> '' ORDER BY EmployeeID
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE [LegalLast Name] = '' ORDER BY EmployeeID
--SELECT * FROM WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES WHERE PERSNO IN (SELECT EmployeeID FROM WD_HR_TR_WorkerPersonalContact WHERE [LegalFirst Name] = '')
--SELECT * FROM WAVE_NM_PHONE_FINAL_WITH_IA_CHANGES WHERE [Legal_FirstName] = '' 
--SELECT * FROM WD_HR_TR_WorkerPersonalContact WHERE [EmployeeID] like '06%' ORDER BY EmployeeID
--SELECT DISTINCT SUBSTRING(MAIN_FIX_NO, 1, 4) FROM W4_GOLD_PA9008 WHERE BEGDA <= '20210214' AND ENDDA >='20210214' AND PERNR like '06%' AND MAIN_FIX_NO IS NOT NULL
--SELECT DISTINCT MAIN_FIX_NO FROM W4_GOLD_PA9008 WHERE BEGDA <= '20210214' AND ENDDA >='20210214' AND PERNR IN ('06001079', '06001742')
--+33147101212, +33147101319

