USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT] Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Validate Employee Contract */
IF OBJECT_ID('dbo.ValidateEmployeeContract') IS NOT NULL
  DROP FUNCTION ValidateEmployeeContract
GO
CREATE FUNCTION ValidateEmployeeContract (
    @Employee                        AS VARCHAR(300),
	@EmployeeType                    AS VARCHAR(30),
	@HRCoreContractType              AS VARCHAR(30),  
	@EffectiveDate                   AS VARCHAR(30),
	@ContractStartDate               AS VARCHAR(30),
	@ContractEndDate                 AS VARCHAR(30),
	@LatestHireDate                  AS VARCHAR(30),
	@TerminationDate                 AS VARCHAR(30),
	@NoofRows                        AS INT,
	@CurrentRow                      AS INT 
)
RETURNS varchar(4000)  
BEGIN  
    DECLARE @result AS VARCHAR(4000)='';
	IF (@NoofRows >= @CurrentRow)
	BEGIN
        SET @result=IIF(@Employee='', 'Employee Number should not be empty;', '')+
			    IIF(@EmployeeType IN ('7', '9') AND @ContractEndDate <> '', 'External employee should not be in the report;', '')+
				IIF(@EffectiveDate='', 'Effective Date should not be empty;', '') +
				IIF(@HRCoreContractType='02', IIF(@ContractEndDate='', 'Contact end date should not be blank for fixed terms;', ''), '') +
				IIF(@ContractStartDate = '' AND @ContractEndDate <> '', 'Contract start date should not be blank;', '') + 
				IIF(@ContractStartDate <> '' AND @LatestHireDate <> '', 
				    IIF(Convert(datetime, @ContractStartDate) < Convert(datetime, @LatestHireDate), 'Contract start date should be greater than Latest Hire Date;', ''), '') +
				IIF(@ContractStartDate <> '' AND @EffectiveDate <> '', 
					IIF(Convert(datetime, @ContractStartDate) > Convert(datetime, @EffectiveDate), 'Contract start date should be less than Effective Date;', ''), '') +
				IIF(@ContractStartDate <> '' AND @ContractEndDate <> '', 
					IIF(Convert(datetime, @ContractStartDate) > Convert(datetime, @ContractEndDate), 'Contract start date should be less than Contract end date;', ''), '') +
				IIF(@TerminationDate <> '' AND @ContractEndDate <> '', 
					IIF(Convert(datetime, @TerminationDate) < Convert(datetime, @ContractEndDate), 'Contract End date should be less than Termination date;', ''), '')
	 END
     RETURN (IIF(@result='','', 'Row Number('+CAST(@CurrentRow AS VARCHAR(50))+')# '+@result));
END
GO

/* If the function('dbo.GetEmployeeContractStatus') already exist */
IF OBJECT_ID('dbo.GetEmployeeContractStatus') IS NOT NULL
  DROP FUNCTION GetEmployeeContractStatus
GO
CREATE FUNCTION GetEmployeeContractStatus (
    @END_DATE        AS VARCHAR(30),
	@START_DATE      AS VARCHAR(30)	
)
RETURNS varchar(50)  
BEGIN  
    DECLARE @result AS VARCHAR(50)='Employee_Contract_Status_Open';
	IF @START_DATE = '00000000'
	BEGIN
	    SET @result='Employee_Contract_Status_Open';
	END
	ELSE IF @START_DATE <> ''
	BEGIN
	    SET @result='Employee_Contract_Status_Closed';
		IF CAST(@END_DATE AS DATE) <=  CAST(@START_DATE AS DATE) SET @result='Employee_Contract_Status_Open';
	END

	RETURN @result;
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT]
    @which_wavestage     AS NVARCHAR(50),
	@which_report        AS NVARCHAR(500),
	@which_date          AS NVARCHAR(50),
	@PrefixCheck         AS NVARCHAR(50),
	@PrefixCopy          AS NVARCHAR(50)
AS
BEGIN

	/* Required Info type table */
	PRINT GetDate();
	PRINT 'WAVE_NM_PA0016';
	DECLARE @SQL AS VARCHAR(4000)='drop table WAVE_NM_PA0016;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0016 FROM '+@which_wavestage+'_PA0016;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0016', @PrefixCheck, @PrefixCopy

	PRINT 'WAVE_NM_PA0019';
	SET @SQL='drop table WAVE_NM_PA0019;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0019 FROM '+@which_wavestage+'_PA0019;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0019', @PrefixCheck, @PrefixCopy

	PRINT 'WAVE_NM_CITIZENSHIP_LKUP';
	SET @SQL='drop table if exists WAVE_NM_CITIZENSHIP_LKUP;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_CITIZENSHIP_LKUP FROM '+@which_wavestage+'_CITIZENSHIP_LKUP;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	PRINT 'WAVE_NM_POSITION_MANAGEMENT_BASE';
	SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
				WHERE a.RNK=1'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	PRINT GetDate()
	PRINT 'Contract Type LKUP table';
	DECLARE @CONTRACT_TYPE_INFO TABLE (
		[Country2 Code]              NVARCHAR(200),
		[Contract Type]              NVARCHAR(200),
		[Emp SubGroup]               NVARCHAR(200),  
		[Citizenship]                NVARCHAR(200),
		[Contract Type Text]         NVARCHAR(200),
		[WD Contract Type]           NVARCHAR(200)
	);

	INSERT INTO @CONTRACT_TYPE_INFO
	SELECT DISTINCT 
	   [GEO - Work Country], 
	   CTTYP, 
	   [Emp - SubGroup],
	   'UN' [Citizenship],
	   (CASE
	      WHEN CTTYP='00' THEN 'Apprentice'
		  WHEN CTTYP='01' THEN 'Permanent'
		  WHEN CTTYP='02' THEN 'Fixed Terms'
		  WHEN CTTYP='03' THEN 'No Fixed Terms'
		END) [Contract Type Text],
		'EMPLOYEE_CONTRACT_TYPE-'+CTTYP [WD Contract Type]
	FROM P0_PA0016 A1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[Emp - Personnel Number] 
	WHERE A2.[Emp - Personnel Number] IS NOT NULL AND CTTYP IS NOT NULL

	/*
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('CN','01','00','UN','Permanent','EMPLOYEE_CONTRACT_TYPE-6-0');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('TW','03','00','UN','No Fixed Terms - Taiwan','EMPLOYEE_CONTRACT_TYPE-6-3');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('HK','01','00','UN','Permanent','EMPLOYEE_CONTRACT_TYPE-6-0');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('MY','01','00','UN','Permanent','EMPLOYEE_CONTRACT_TYPE-6-0');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('CN','02','00','UN','Fixed Terms - China','EMPLOYEE_CONTRACT_TYPE-6-1');
    INSERT INTO @CONTRACT_TYPE_INFO VALUES('CN','03','00','UN','No Fixed Terms - China','EMPLOYEE_CONTRACT_TYPE-6-2');
    --INSERT INTO @CONTRACT_TYPE_INFO VALUES('HK','03','00','UN','No Fixed Terms - Hong Kong','EMPLOYEE_CONTRACT_TYPE-6-4');
    INSERT INTO @CONTRACT_TYPE_INFO VALUES('MY','02','00','Citizen','Fixed Term - Citizen - Malaysia','EMPLOYEE_CONTRACT_TYPE-6-5');
    INSERT INTO @CONTRACT_TYPE_INFO VALUES('MY','02','00','Non-Citizen','Fixed Term - Non Citizen - Malaysia','EMPLOYEE_CONTRACT_TYPE-6-6');

	--SELECT * FROM W4_PHONE_VALIDATION

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('FR', '00','00', 'UN', 'Apprentice', 'EMPLOYEE_CONTRACT_TYPE-Apprentice - France');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('FR', '01','00', 'UN', 'Permanent', 'EMPLOYEE_CONTRACT_TYPE-Permanent - France');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('FR', '02','00', 'UN', 'Fixed Terms - France', 'EMPLOYEE_CONTRACT_TYPE-Fixed-Term Contract - France');

	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '01', 'D2', 'UN', 'Unlimited - Executive', 'EMPLOYEE_CONTRACT_TYPE-Unlimited - Executive - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '01', 'D1', 'UN', 'Unlimited - General Managers', 'EMPLOYEE_CONTRACT_TYPE-Unlimited - General Managers - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '01', 'D8', 'UN', 'Unlimited - Hourly Associates', 'EMPLOYEE_CONTRACT_TYPE-Unlimited - Hourly Associates - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '01', 'D5', 'UN', 'Unlimited - Non-Tariff Associate', 'EMPLOYEE_CONTRACT_TYPE-Unlimited - Non-Tariff Associate - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '01', 'D6', 'UN', 'Unlimited - Tariff Associate', 'EMPLOYEE_CONTRACT_TYPE-Unlimited - Tariff Associate - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', 'D5', 'UN', 'Limited - Non-Tariff Associate', 'EMPLOYEE_CONTRACT_TYPE-Limited - Non-Tariff Associate - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', 'D6', 'UN', 'Limited - Tariff Associate', 'EMPLOYEE_CONTRACT_TYPE-Limited - Tariff Associate - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', 'DM', 'UN', 'Limited - Apprentice', 'EMPLOYEE_CONTRACT_TYPE-Limited - Apprentice - Germany');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', 'DN', 'UN', 'Limited - Intern', 'EMPLOYEE_CONTRACT_TYPE-Limited - Intern - Germany');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', '00', 'UN', 'Fixed-Term Contract', 'EMPLOYEE_CONTRACT_TYPE-Fixed-Term Contract');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '02', 'DR', 'UN', 'Limited - Working Student', 'EMPLOYEE_CONTRACT_TYPE-Limited - Working Student');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '98', '00', 'UN', 'Semi Retirement - Active Phase', 'EMPLOYEE_CONTRACT_TYPE-Active Phase - Germany');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '99', '00', 'UN', 'Semi Retirement - Passive Phase', 'EMPLOYEE_CONTRACT_TYPE-Passive Phase - Germany');

	--SELECT A2.CTTYP, A1.* FROM  WAVE_NM_POSITION_MANAGEMENT_BASE A1 JOIN WAVE_NM_PA0016 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
	--   WHERE [Geo - Work Country]='DE' AND [Emp - Group] IN ('2', '6') AND 
	--         BEGDA <= CAST('2021-02-14' AS DATE) AND ENDDA >= CAST('2021-02-14' AS DATE) AND 
	--		 CTTYP<> '02'
	--SELECT A1.* FROM  W4_GOLD_POSITION_MANAGEMENT A1
	--   WHERE [Emp - SubGroup] IN ('DR')
	--SELECT A1.* FROM  W4_GOLD_POSITION_MANAGEMENT A1 WHERE [Emp - Personnel Number] IN ('02100041', '02116200', '02117009', '02117475', '02117699', '02117927')

	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '98', '00', 'UN', 'Active', 'EMPLOYEE_CONTRACT_TYPE-6-47');
	--INSERT INTO @CONTRACT_TYPE_INFO VALUES('DE', '99', '00', 'UN', 'Passive', 'EMPLOYEE_CONTRACT_TYPE-6-48');	

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('CH', '02','00', 'UN', 'Fixed Term Contract', 'EMPLOYEE_CONTRACT_TYPE-Fixed Term Contract - Switzerland');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('AT', '02','00', 'UN', 'Fixed Term Contract', 'EMPLOYEE_CONTRACT_TYPE-Fixed Term Contract - Austria');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('CZ', '01','00', 'UN', 'Permanent', 'EMPLOYEE_CONTRACT_TYPE-Permanent - Czech Republic');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('CZ', '02','00', 'UN', 'Fixed', 'EMPLOYEE_CONTRACT_TYPE-Fixed - Czech Republic');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('HR', '01','00', 'UN', 'Permanent', 'EMPLOYEE_CONTRACT_TYPE-Permanent - Croatia');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('HR', '02','00', 'UN', 'Fixed', 'EMPLOYEE_CONTRACT_TYPE-Fixed - Croatia');
	
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('SK', '01','00', 'UN', 'Permanent', 'EMPLOYEE_CONTRACT_TYPE-Permanent - Slovakia');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('SK', '02','00', 'UN', 'Fixed', 'EMPLOYEE_CONTRACT_TYPE-Fixed - Slovakia');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('SK', '00','00', 'UN', '*Identify Paid Externals (2) 1 year contract', 'EMPLOYEE_CONTRACT_TYPE-Paid Externals (1 year contract) - Slovakia');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('TR', '02','00', 'UN', 'Fixed Term Contract', 'EMPLOYEE_CONTRACT_TYPE-Fixed Term Contract - Turkey');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('TR', '01','00', 'UN', 'Permanent Contract', 'EMPLOYEE_CONTRACT_TYPE-Permanent Contract - Turkey');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('SP', '00','00', 'UN', 'Student (3rd Party Assoc)', 'EMPLOYEE_CONTRACT_TYPE-Student (3rd Party Assoc) - Spain');

    INSERT INTO @CONTRACT_TYPE_INFO VALUES('IT', '02','00', 'UN', 'Lim Fixed Temporary contract', 'EMPLOYEE_CONTRACT_TYPE-Lim Fixed Temporary contract - Italy');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('IT', '01','00', 'UN', 'Permanent Contract', 'EMPLOYEE_CONTRACT_TYPE-Permanent Contract - Italy');

    INSERT INTO @CONTRACT_TYPE_INFO VALUES('PL', '02','00', 'UN', 'Lim-Fixed Term', 'EMPLOYEE_CONTRACT_TYPE-Lim-Fixed Term - Poland');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('PL', '01','00', 'UN', 'Permanent Contract', 'EMPLOYEE_CONTRACT_TYPE-Permanent Contract - Poland');

    INSERT INTO @CONTRACT_TYPE_INFO VALUES('RU', '02','00', 'UN', 'Lim-Fixed', 'EMPLOYEE_CONTRACT_TYPE-Lim-Fixed - Russia');
	INSERT INTO @CONTRACT_TYPE_INFO VALUES('RU', '01','00', 'UN', 'Permanent Contract', 'EMPLOYEE_CONTRACT_TYPE-Permanent Contract - Russia');

	INSERT INTO @CONTRACT_TYPE_INFO VALUES('DK', '02','00', 'UN', 'Fix Term for Temporary', 'EMPLOYEE_CONTRACT_TYPE-Fix Term for Temporary - Denmark');
	*/
	
	PRINT 'Partial Retirement Table';
	PRINT GetDate();
	DECLARE @WAVE_NM_PARTIAL_RETIREMENT TABLE (
		[PersNr] [nvarchar](8) NOT NULL,
		[Last Name] [nvarchar](255) NULL,
		[First Name] [nvarchar](255) NULL,
		[Cost Center] [nvarchar](255) NULL,
		[Start] [date] NULL,
		[End] [date] NULL,
		[Active or Passive Phase] [nvarchar](255) NULL,
		[Increase Percentage] [nvarchar](255) NULL
	)

	DECLARE @WAVE_NM_PA0016_POPULATION TABLE (
	     PERNR    NVARCHAR(255),
		 BEGDA    NVARCHAR(255),
		 ENDDA    NVARCHAR(255),
		 CTTYP    NVARCHAR(255),
		 CTNUM    NVARCHAR(255),
		 CTEDT    NVARCHAR(255),
		 ISO2     NVARCHAR(255),
		 CSDT     NVARCHAR(255),
		 CEDT     NVARCHAR(255),
		 LHDT     NVARCHAR(255),
		 FLAG     NVARCHAR(255)
	);

	--SELECT DISTINCT [GEO - Work Country], CTTYP FROM P0_PA0016 A1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[Emp - Personnel Number] WHERE A2.[Emp - Personnel Number] IS NOT NULL
	--SELECT * FROM W4_GOLD_RETIREMENT_CONTRACT
	--SELECT * FROM W4_GOLD_PARTIAL_RETIREMENT
	--SELECT * FROM WAVE_NM_PARTIAL_RETIREMENT
	--SELECT * FROM @WAVE_NM_PARTIAL_RETIREMENT ORDER BY PERSNR
	INSERT INTO @WAVE_NM_PA0016_POPULATION
	SELECT DISTINCT PERNR, BEGDA, ENDDA, CTTYP, CTNUM, CTEDT, [GEO - WORK COUNTRY] ISO2,
	       IIF(ISNULL([BEGDA], CAST('1900-01-01' AS DATE))<=CAST('1900-01-01' AS DATE), '', CONVERT(varchar(10), [BEGDA], 101)) [Contract Start Date],
	       IIF(ISNULL(CTTYP, '')<>'02', '', IIF(ISNULL(CTEDT, '00000000')='00000000', '', CONVERT(varchar(10), CAST(CTEDT as date), 101))) [Contract End Date],
		   IIF(ISNULL(wd_latest_hire_Date, '1900-01-01')<='1900-01-01', '', CONVERT(varchar(10), wd_latest_hire_Date, 101)) [Latest Hire Date],
		   'Y'
	    FROM WAVE_NM_PA0016 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE) AND [GEO - WORK COUNTRY] <> 'CN' AND 
		      A1.PERNR NOT IN (SELECT DISTINCT PERSNR FROM @WAVE_NM_PARTIAL_RETIREMENT) 

	UPDATE @WAVE_NM_PA0016_POPULATION SET FLAG='E' WHERE ISNULL([CEDT], '') <> '' AND Convert(datetime, [CEDT]) < Convert(datetime, [LHDT]) AND ISO2='CN'
	UPDATE @WAVE_NM_PA0016_POPULATION SET FLAG='S' WHERE ISNULL([CSDT], '') <> '' AND Convert(datetime, [CSDT]) > Convert(datetime, @which_date) AND ISO2='CN'   
	PRINT GetDate();

    DECLARE @MAINTAIN_EMPLOYEE_CONTRACT_INFO TABLE(
		[Spreadsheet Key]                               NVARCHAR(200),
		[Employee]                                      NVARCHAR(200),
		[Row ID]                                        NVARCHAR(200),
		[Employee Contract]                             NVARCHAR(200),
		[Employee Contract Reason]                      NVARCHAR(200),
		[Employee Contract ID]                          NVARCHAR(200),
		[Effective Date]                                NVARCHAR(200),
		[HR Core Contract Type]                         NVARCHAR(200),
		[Contract ID]                                   NVARCHAR(200),
		[Contract Type]                                 NVARCHAR(200),
		[Contract Start Date]                           NVARCHAR(200),
		[Contract End Date]                             NVARCHAR(200),
		[Employee Contract Collective Agreement]        NVARCHAR(200),
		[Maximum Weekly Hours]                          NVARCHAR(200),
		[Minimum Weekly Hours]                          NVARCHAR(200),
		[Contract Status]                               NVARCHAR(200),
		[Position]                                      NVARCHAR(200),
		[Contract Description]                          NVARCHAR(200),
		[Date Employee Signed]                          NVARCHAR(200),
		[Date Employer Signed]                          NVARCHAR(200),
		[Worker Document]                               NVARCHAR(200),
		[Country2 Code]                                 NVARCHAR(200),
		[PA0016_PERNR]                                  NVARCHAR(200),
		[Original Hire Date]                            NVARCHAR(200),
		[Latest Hire Date]                              NVARCHAR(200),
		[Date - Term. Date]                             NVARCHAR(200),
		[Employee Type]                                 NVARCHAR(200),
		[wd_emp_type]                                   NVARCHAR(200),
		[Employee Rank]                                 NVARCHAR(200)
	);

	/* Maintain Employee Contract Populating data starts */
	PRINT 'Maintain Employee Contract Populating data starts'
	PRINT GETDATE();
	INSERT INTO @MAINTAIN_EMPLOYEE_CONTRACT_INFO
	SELECT *, ROW_NUMBER() OVER ( PARTITION BY [Employee] ORDER BY [Employee], [CSDT] ) [Employee Rank] FROM (
	SELECT DISTINCT * FROM (
    SELECT '1' [Spreadsheet Key]
		,ISNULL([Persno_New], '') [Employee]
		,'' [Row ID]
		,ISNULL(b.CTNUM, '') [Employee Contract]   
		,'' [Employee Contract Reason]
		,'' [Employee Contract ID]
		,IIF(ISNULL(b.BEGDA, '1900-01-01')<='1900-01-01', '', CONVERT(varchar(10), b.BEGDA, 101)) [Effective Date]
		--,'' [Effective Date]
		,b.CTTYP [HR Core Contract Type]
		,ISNULL((SELECT TOP 1 [WD Contract Type] 
		             FROM @CONTRACT_TYPE_INFO 
		             WHERE [Country2 Code]=[Geo - Work Country] AND 
					       [Contract Type]= ISNULL(b.CTTYP, '') AND 
						   (([Geo - Work Country] <> 'DE') OR ([Geo - Work Country] = 'DE' AND ([Emp SubGroup] = '00' OR [Emp SubGroup]= ISNULL(f.[Emp - Subgroup], '')))) AND 
						   (([Geo - Work Country] <> 'MY') OR ([Geo - Work Country] = 'MY' AND ISNULL(h.[Citizenship Status], '')=[Citizenship]))), '') [Contract ID]
		,ISNULL((SELECT TOP 1 [Contract Type Text] 
		             FROM @CONTRACT_TYPE_INFO 
				     WHERE [Country2 Code]=[Geo - Work Country] AND 
					       [Contract Type]= ISNULL(b.CTTYP, '') AND 
						   (([Geo - Work Country] <> 'DE') OR ([Geo - Work Country] = 'DE' AND ([Emp SubGroup] = '00' OR [Emp SubGroup]= ISNULL(f.[Emp - Subgroup], '')))) AND 
						   (([Geo - Work Country] <> 'MY') OR ([Geo - Work Country] = 'MY' AND ISNULL(h.[Citizenship Status], '')=[Citizenship]))), '') [Contract Type]
		--,IIF(ISNULL(b.[BEGDA], CAST('1900-01-01' AS DATE))<=CAST('1900-01-01' AS DATE), '', CONVERT(varchar(10), b.[BEGDA], 101)) [Contract Start Date]
		,b.[CSDT]
		--,IIF(ISNULL(b.CTEDT, '00000000')='00000000', '', CONVERT(varchar(10), CAST(b.CTEDT as date), 101)) [Contract End Date]
		,b.[CEDT]
		,'' [Employee Contract Collective Agreement]
		,'' [Maximum Weekly Hours]
		,'' [Minimum Weekly Hours]
		,dbo.GetEmployeeContractStatus(CONVERT(VARCHAR(10), GETDATE(), 101), IIF(ISNULL(b.CTEDT, '00000000')='00000000', '00000000', 
																	                  CONVERT(varchar(10), CAST(b.CTEDT as date), 101))) [Contract Status]
		--,'' [Contract Status]
		,IIF([emp - group]='3' OR [emp - group]='4', [Org - Position], '') [Position]
		,'' [Contract Description]
		,'' [Date Employee Signed]
		,'' [Date Employer Signed]
		,'' [Worker Document]
		,f.[Geo - Work Country]
		,b.PERNR [PA0016_PERNR]
		,IIF(ISNULL(f.wd_original_hire_date, '1900-01-01')<='1900-01-01', '', CONVERT(varchar(10), f.wd_original_hire_date, 101)) [Original Hire Date]
		,IIF(ISNULL(f.wd_latest_hire_Date, '1900-01-01')<='1900-01-01', '', CONVERT(varchar(10), f.wd_latest_hire_Date, 101)) [Latest Hire Date]
		,IIF(ISNULL(f.[Date - Term. Date], '1900-01-01')<='1900-01-01', '', CONVERT(varchar(10), f.[Date - Term. Date], 101)) [Date - Term. Date]
		,[Emp - Group] [Employee Type]
		,[wd_emp_type]
	FROM (SELECT * FROM WAVE_NM_POSITION_MANAGEMENT_BASE 
	          WHERE [Geo - Work Country] IN (SELECT DISTINCT [Country2 Code] FROM @CONTRACT_TYPE_INFO) AND WD_location_id <> '0010_HongKong_CNHK') f
	    LEFT JOIN WAVE_NM_CITIZENSHIP_LKUP h ON f.[Emp - Personnel Number] = h.PERNR
	    LEFT JOIN (SELECT * FROM @WAVE_NM_PA0016_POPULATION WHERE FLAG='Y') b ON f.[Emp - Personnel Number] = b.PERNR) e ) a
	WHERE ISNULL([PA0016_PERNR], '') <> '';

	PRINT 'PIVOT Start';
	PRINT GETDATE();
	DECLARE @CONTRACT_STATUS_TRANSPOSED TABLE (
			EMPLOYEE                            NVARCHAR(255),
			MAX_RANK                            INT,  
		    EMPLOYEE_TYPE                       NVARCHAR(255),
		    LATEST_HIRE_DATE                    NVARCHAR(255),
		    TERMINATION_DATE                    NVARCHAR(255),

			STATUS_01                           NVARCHAR(255),
			STATUS_02                           NVARCHAR(255),
			STATUS_03                           NVARCHAR(255),
			STATUS_04                           NVARCHAR(255),
			STATUS_05                           NVARCHAR(255),
			STATUS_06                           NVARCHAR(255),
			STATUS_07                           NVARCHAR(255),
			STATUS_08                           NVARCHAR(255),
			STATUS_09                           NVARCHAR(255),
			STATUS_10                           NVARCHAR(255),
			STATUS_11                           NVARCHAR(255),
			STATUS_12                           NVARCHAR(255),
			STATUS_13                           NVARCHAR(255),
			STATUS_14                           NVARCHAR(255),
			STATUS_15                           NVARCHAR(255),

			Effective_Date_01                   NVARCHAR(255),
			Effective_Date_02                   NVARCHAR(255),
			Effective_Date_03                   NVARCHAR(255),
			Effective_Date_04                   NVARCHAR(255),
			Effective_Date_05                   NVARCHAR(255),
			Effective_Date_06                   NVARCHAR(255),
			Effective_Date_07                   NVARCHAR(255),
			Effective_Date_08                   NVARCHAR(255),
			Effective_Date_09                   NVARCHAR(255),
			Effective_Date_10                   NVARCHAR(255),
			Effective_Date_11                   NVARCHAR(255),
			Effective_Date_12                   NVARCHAR(255),
			Effective_Date_13                   NVARCHAR(255),
			Effective_Date_14                   NVARCHAR(255),
			Effective_Date_15                   NVARCHAR(255),

			Contract_Start_Date_01              NVARCHAR(255),
			Contract_Start_Date_02              NVARCHAR(255),
			Contract_Start_Date_03              NVARCHAR(255),
			Contract_Start_Date_04              NVARCHAR(255),
			Contract_Start_Date_05              NVARCHAR(255),
			Contract_Start_Date_06              NVARCHAR(255),
			Contract_Start_Date_07              NVARCHAR(255),
			Contract_Start_Date_08              NVARCHAR(255),
			Contract_Start_Date_09              NVARCHAR(255),
			Contract_Start_Date_10              NVARCHAR(255),
			Contract_Start_Date_11              NVARCHAR(255),
			Contract_Start_Date_12              NVARCHAR(255),
			Contract_Start_Date_13              NVARCHAR(255),
			Contract_Start_Date_14              NVARCHAR(255),
			Contract_Start_Date_15              NVARCHAR(255),

			Contract_End_Date_01                NVARCHAR(255),
			Contract_End_Date_02                NVARCHAR(255),
			Contract_End_Date_03                NVARCHAR(255),
			Contract_End_Date_04                NVARCHAR(255),
			Contract_End_Date_05                NVARCHAR(255),
			Contract_End_Date_06                NVARCHAR(255),
			Contract_End_Date_07                NVARCHAR(255),
			Contract_End_Date_08                NVARCHAR(255),
			Contract_End_Date_09                NVARCHAR(255),
			Contract_End_Date_10                NVARCHAR(255),
			Contract_End_Date_11                NVARCHAR(255),
			Contract_End_Date_12                NVARCHAR(255),
			Contract_End_Date_13                NVARCHAR(255),
			Contract_End_Date_14                NVARCHAR(255),
			Contract_End_Date_15                NVARCHAR(255),

			HR_Core_Contract_Type_01            NVARCHAR(255),
			HR_Core_Contract_Type_02            NVARCHAR(255),
			HR_Core_Contract_Type_03            NVARCHAR(255),
			HR_Core_Contract_Type_04            NVARCHAR(255),
			HR_Core_Contract_Type_05            NVARCHAR(255),
			HR_Core_Contract_Type_06            NVARCHAR(255),
			HR_Core_Contract_Type_07            NVARCHAR(255),
			HR_Core_Contract_Type_08            NVARCHAR(255),
			HR_Core_Contract_Type_09            NVARCHAR(255),
			HR_Core_Contract_Type_10            NVARCHAR(255),
			HR_Core_Contract_Type_11            NVARCHAR(255),
			HR_Core_Contract_Type_12            NVARCHAR(255),
			HR_Core_Contract_Type_13            NVARCHAR(255),
			HR_Core_Contract_Type_14            NVARCHAR(255),
			HR_Core_Contract_Type_15            NVARCHAR(255)
	)

	;WITH CTE_Rank AS
	(
	SELECT [EMPLOYEE]
	      ,[EMPLOYEE RANK]
		  ,[CONTRACT STATUS]
		  ,[EFFECTIVE DATE]
		  ,[CONTRACT START DATE]
		  ,[CONTRACT END DATE]
		  ,[HR CORE CONTRACT TYPE]
		  ,[EMPLOYEE TYPE]
		  ,[LATEST HIRE DATE]
		  ,A1.[DATE - TERM. DATE]
		  ,sStatus='STATUS_' + IIF([EMPLOYEE RANK] <= 9, '0'+CAST([EMPLOYEE RANK] AS VARCHAR(200)), CAST([EMPLOYEE RANK] AS VARCHAR(200)))
		  ,sEffective_Date='EFFECTIVE_DATE_' + IIF([EMPLOYEE RANK] <= 9, '0'+CAST([EMPLOYEE RANK] AS VARCHAR(200)), CAST([EMPLOYEE RANK] AS VARCHAR(200)))
		  ,sContract_Start_Date='CONTRACT_START_DATE_' + IIF([EMPLOYEE RANK] <= 9, '0'+CAST([EMPLOYEE RANK] AS VARCHAR(200)), CAST([EMPLOYEE RANK] AS VARCHAR(200)))
		  ,sContract_End_Date='CONTRACT_END_DATE_' + IIF([EMPLOYEE RANK] <= 9, '0'+CAST([EMPLOYEE RANK] AS VARCHAR(200)), CAST([EMPLOYEE RANK] AS VARCHAR(200)))
		  ,sHR_Core_Contract_Type='HR_CORE_CONTRACT_TYPE_' + IIF([EMPLOYEE RANK] <= 9, '0'+CAST([EMPLOYEE RANK] AS VARCHAR(200)), CAST([EMPLOYEE RANK] AS VARCHAR(200)))
	FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO A1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.Employee=A2.[Emp - Personnel Number]
	WHERE [GEO - WORK COUNTRY]='CN'
	)
	INSERT INTO @CONTRACT_STATUS_TRANSPOSED
	SELECT [EMPLOYEE]
	      ,MAX([EMPLOYEE RANK])
		  ,MAX([EMPLOYEE TYPE])
		  ,MAX([LATEST HIRE DATE])
		  ,MAX([DATE - TERM. DATE])

		  ,STATUS_01 = MAX(ISNULL(STATUS_01, ''))
		  ,STATUS_02 = MAX(ISNULL(STATUS_02, ''))
		  ,STATUS_03 = MAX(ISNULL(STATUS_03, ''))
		  ,STATUS_04 = MAX(ISNULL(STATUS_04, ''))
		  ,STATUS_05 = MAX(ISNULL(STATUS_05, ''))
		  ,STATUS_06 = MAX(ISNULL(STATUS_06, ''))
		  ,STATUS_07 = MAX(ISNULL(STATUS_07, ''))
		  ,STATUS_08 = MAX(ISNULL(STATUS_08, ''))
		  ,STATUS_09 = MAX(ISNULL(STATUS_09, ''))
		  ,STATUS_10 = MAX(ISNULL(STATUS_10, ''))
		  ,STATUS_11 = MAX(ISNULL(STATUS_11, ''))
		  ,STATUS_12 = MAX(ISNULL(STATUS_12, ''))
		  ,STATUS_13 = MAX(ISNULL(STATUS_13, ''))
		  ,STATUS_14 = MAX(ISNULL(STATUS_14, ''))
		  ,STATUS_15 = MAX(ISNULL(STATUS_15, ''))

		  ,EFFECTIVE_DATE_01 = MAX(ISNULL(EFFECTIVE_DATE_01, ''))
		  ,EFFECTIVE_DATE_02 = MAX(ISNULL(EFFECTIVE_DATE_02, ''))
		  ,EFFECTIVE_DATE_03 = MAX(ISNULL(EFFECTIVE_DATE_03, ''))
		  ,EFFECTIVE_DATE_04 = MAX(ISNULL(EFFECTIVE_DATE_04, ''))
		  ,EFFECTIVE_DATE_05 = MAX(ISNULL(EFFECTIVE_DATE_05, ''))
		  ,EFFECTIVE_DATE_06 = MAX(ISNULL(EFFECTIVE_DATE_06, ''))
		  ,EFFECTIVE_DATE_07 = MAX(ISNULL(EFFECTIVE_DATE_07, ''))
		  ,EFFECTIVE_DATE_08 = MAX(ISNULL(EFFECTIVE_DATE_08, ''))
		  ,EFFECTIVE_DATE_09 = MAX(ISNULL(EFFECTIVE_DATE_09, ''))
		  ,EFFECTIVE_DATE_10 = MAX(ISNULL(EFFECTIVE_DATE_10, ''))
		  ,EFFECTIVE_DATE_11 = MAX(ISNULL(EFFECTIVE_DATE_11, ''))
		  ,EFFECTIVE_DATE_12 = MAX(ISNULL(EFFECTIVE_DATE_12, ''))
		  ,EFFECTIVE_DATE_13 = MAX(ISNULL(EFFECTIVE_DATE_13, ''))
		  ,EFFECTIVE_DATE_14 = MAX(ISNULL(EFFECTIVE_DATE_14, ''))
		  ,EFFECTIVE_DATE_15 = MAX(ISNULL(EFFECTIVE_DATE_15, ''))

		  ,CONTRACT_START_DATE_01 = MAX(ISNULL(CONTRACT_START_DATE_01, ''))
		  ,CONTRACT_START_DATE_02 = MAX(ISNULL(CONTRACT_START_DATE_02, ''))
		  ,CONTRACT_START_DATE_03 = MAX(ISNULL(CONTRACT_START_DATE_03, ''))
		  ,CONTRACT_START_DATE_04 = MAX(ISNULL(CONTRACT_START_DATE_04, ''))
		  ,CONTRACT_START_DATE_05 = MAX(ISNULL(CONTRACT_START_DATE_05, ''))
		  ,CONTRACT_START_DATE_06 = MAX(ISNULL(CONTRACT_START_DATE_06, ''))
		  ,CONTRACT_START_DATE_07 = MAX(ISNULL(CONTRACT_START_DATE_07, ''))
		  ,CONTRACT_START_DATE_08 = MAX(ISNULL(CONTRACT_START_DATE_08, ''))
		  ,CONTRACT_START_DATE_09 = MAX(ISNULL(CONTRACT_START_DATE_09, ''))
		  ,CONTRACT_START_DATE_10 = MAX(ISNULL(CONTRACT_START_DATE_10, ''))
		  ,CONTRACT_START_DATE_11 = MAX(ISNULL(CONTRACT_START_DATE_11, ''))
		  ,CONTRACT_START_DATE_12 = MAX(ISNULL(CONTRACT_START_DATE_12, ''))
		  ,CONTRACT_START_DATE_13 = MAX(ISNULL(CONTRACT_START_DATE_13, ''))
		  ,CONTRACT_START_DATE_14 = MAX(ISNULL(CONTRACT_START_DATE_14, ''))
		  ,CONTRACT_START_DATE_15 = MAX(ISNULL(CONTRACT_START_DATE_15, ''))

		  ,CONTRACT_END_DATE_01 = MAX(ISNULL(CONTRACT_END_DATE_01, ''))
		  ,CONTRACT_END_DATE_02 = MAX(ISNULL(CONTRACT_END_DATE_02, ''))
		  ,CONTRACT_END_DATE_03 = MAX(ISNULL(CONTRACT_END_DATE_03, ''))
		  ,CONTRACT_END_DATE_04 = MAX(ISNULL(CONTRACT_END_DATE_04, ''))
		  ,CONTRACT_END_DATE_05 = MAX(ISNULL(CONTRACT_END_DATE_05, ''))
		  ,CONTRACT_END_DATE_06 = MAX(ISNULL(CONTRACT_END_DATE_06, ''))
		  ,CONTRACT_END_DATE_07 = MAX(ISNULL(CONTRACT_END_DATE_07, ''))
		  ,CONTRACT_END_DATE_08 = MAX(ISNULL(CONTRACT_END_DATE_08, ''))
		  ,CONTRACT_END_DATE_09 = MAX(ISNULL(CONTRACT_END_DATE_09, ''))
		  ,CONTRACT_END_DATE_10 = MAX(ISNULL(CONTRACT_END_DATE_10, ''))
		  ,CONTRACT_END_DATE_11 = MAX(ISNULL(CONTRACT_END_DATE_11, ''))
		  ,CONTRACT_END_DATE_12 = MAX(ISNULL(CONTRACT_END_DATE_12, ''))
		  ,CONTRACT_END_DATE_13 = MAX(ISNULL(CONTRACT_END_DATE_13, ''))
		  ,CONTRACT_END_DATE_14 = MAX(ISNULL(CONTRACT_END_DATE_14, ''))
		  ,CONTRACT_END_DATE_15 = MAX(ISNULL(CONTRACT_END_DATE_15, ''))

		  ,HR_CORE_CONTRACT_TYPE_01 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_01, ''))
		  ,HR_CORE_CONTRACT_TYPE_02 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_02, ''))
		  ,HR_CORE_CONTRACT_TYPE_03 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_03, ''))
		  ,HR_CORE_CONTRACT_TYPE_04 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_04, ''))
		  ,HR_CORE_CONTRACT_TYPE_05 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_05, ''))
		  ,HR_CORE_CONTRACT_TYPE_06 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_06, ''))
		  ,HR_CORE_CONTRACT_TYPE_07 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_07, ''))
		  ,HR_CORE_CONTRACT_TYPE_08 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_08, ''))
		  ,HR_CORE_CONTRACT_TYPE_09 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_09, ''))
		  ,HR_CORE_CONTRACT_TYPE_10 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_10, ''))
		  ,HR_CORE_CONTRACT_TYPE_11 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_11, ''))
		  ,HR_CORE_CONTRACT_TYPE_12 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_12, ''))
		  ,HR_CORE_CONTRACT_TYPE_13 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_13, ''))
		  ,HR_CORE_CONTRACT_TYPE_14 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_14, ''))
		  ,HR_CORE_CONTRACT_TYPE_15 = MAX(ISNULL(HR_CORE_CONTRACT_TYPE_15, ''))

	FROM CTE_Rank AS R
		  PIVOT(MAX([CONTRACT STATUS]) FOR sStatus IN 
		        ([STATUS_01], [STATUS_02], [STATUS_03], [STATUS_04], [STATUS_05], 
		         [STATUS_06], [STATUS_07], [STATUS_08], [STATUS_09], [STATUS_10],
				 [STATUS_11], [STATUS_12], [STATUS_13], [STATUS_14], [STATUS_15])) [EMPLOYEE STATUS]
		  PIVOT(MAX([EFFECTIVE DATE]) FOR sEffective_Date IN 
		        ([EFFECTIVE_DATE_01], [EFFECTIVE_DATE_02], [EFFECTIVE_DATE_03], [EFFECTIVE_DATE_04], [EFFECTIVE_DATE_05], 
                 [EFFECTIVE_DATE_06], [EFFECTIVE_DATE_07], [EFFECTIVE_DATE_08], [EFFECTIVE_DATE_09], [EFFECTIVE_DATE_10],
				 [EFFECTIVE_DATE_11], [EFFECTIVE_DATE_12], [EFFECTIVE_DATE_13], [EFFECTIVE_DATE_14], [EFFECTIVE_DATE_15])) [EFFECTIVE DATE]
		  PIVOT(MAX([CONTRACT START DATE]) FOR sContract_Start_Date IN 
		        ([CONTRACT_START_DATE_01], [CONTRACT_START_DATE_02], [CONTRACT_START_DATE_03], [CONTRACT_START_DATE_04], [CONTRACT_START_DATE_05], 
                 [CONTRACT_START_DATE_06], [CONTRACT_START_DATE_07], [CONTRACT_START_DATE_08], [CONTRACT_START_DATE_09], [CONTRACT_START_DATE_10],
				 [CONTRACT_START_DATE_11], [CONTRACT_START_DATE_12], [CONTRACT_START_DATE_13], [CONTRACT_START_DATE_14], [CONTRACT_START_DATE_15])) [CONTRACT START DATE]
		  PIVOT(MAX([CONTRACT END DATE]) FOR sContract_End_Date IN 
		        ([CONTRACT_END_DATE_01], [CONTRACT_END_DATE_02], [CONTRACT_END_DATE_03], [CONTRACT_END_DATE_04], [CONTRACT_END_DATE_05], 
                 [CONTRACT_END_DATE_06], [CONTRACT_END_DATE_07], [CONTRACT_END_DATE_08], [CONTRACT_END_DATE_09], [CONTRACT_END_DATE_10],
				 [CONTRACT_END_DATE_11], [CONTRACT_END_DATE_12], [CONTRACT_END_DATE_13], [CONTRACT_END_DATE_14], [CONTRACT_END_DATE_15])) [CONTRACT END DATE]
		  PIVOT(MAX([HR CORE CONTRACT TYPE]) FOR sHR_Core_Contract_Type IN 
		        ([HR_CORE_CONTRACT_TYPE_01], [HR_CORE_CONTRACT_TYPE_02], [HR_CORE_CONTRACT_TYPE_03], [HR_CORE_CONTRACT_TYPE_04], [HR_CORE_CONTRACT_TYPE_05], 
                 [HR_CORE_CONTRACT_TYPE_06], [HR_CORE_CONTRACT_TYPE_07], [HR_CORE_CONTRACT_TYPE_08], [HR_CORE_CONTRACT_TYPE_09], [HR_CORE_CONTRACT_TYPE_10],
				 [HR_CORE_CONTRACT_TYPE_11], [HR_CORE_CONTRACT_TYPE_12], [HR_CORE_CONTRACT_TYPE_13], [HR_CORE_CONTRACT_TYPE_14], [HR_CORE_CONTRACT_TYPE_15])) [HR CORE CONTRACT TYPE]
	GROUP BY EMPLOYEE

	/* Maintain Employee Contract Error List starts */
	PRINT 'Maintain Employee Contract Error List starts';
	PRINT GETDATE();
    DECLARE @ERROR_TABLE TABLE (
	   [WAVE]                 NVARCHAR(255),
	   [REPORT NAME]          NVARCHAR(255),
	   [EMPLOYEE]             NVARCHAR(255),
	   [COUNTRY2 CODE]         NVARCHAR(255),
	   [ERROR TYPE]           NVARCHAR(255),
	   [ERROR TEXT]           NVARCHAR(255)
	)
	INSERT INTO @ERROR_TABLE
	SELECT * FROM (
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[Employee],
						[Country2 Code],
						'Employee Number' [Error Type],
						(
						   IIF([Employee]='', 'Employee Number should not be empty;', '')
						) ErrorText
		FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO a WHERE [Country2 Code] <> 'CN'
		UNION ALL
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[Employee],
						[Country2 Code],
						'External Employee' [Error Type],
						(
						   IIF([Employee Type] = 'External' AND [Contract End Date] <> '', 'External employee should not be in the report;', '')
						) ErrorText
		FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO a WHERE [Country2 Code] <> 'CN'
		UNION ALL
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[Employee],
						[Country2 Code],
						'Effective Date' [Error Type],
						(
						   IIF([Effective Date]='', 'Effective Date should not be empty;', '')
						) ErrorText
		FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO a WHERE [Country2 Code] <> 'CN'
		UNION ALL
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[Employee],
						[Country2 Code],
						'Contract Date' [Error Type],
						(
							 IIF([HR Core Contract Type]='02', IIF([Contract End Date]='', 'Contact end date should not be blank for fixed terms;', ''), '') +
							 IIF([Contract Start Date] = '' AND [Contract End Date] <> '', 'Contract start date should not be blank;', '') + 
							 IIF([Contract Start Date] <> '' AND [Latest Hire Date] <> '', 
									IIF(Convert(datetime, [Contract Start Date]) < Convert(datetime, [Latest Hire Date]), 'Contract start date should be greater than Latest Hire Date;', ''), '') +
							 IIF([Contract Start Date] <> '' AND [Effective Date] <> '', 
									IIF(Convert(datetime, [Contract Start Date]) > Convert(datetime, [Effective Date]), 'Contract start date should be less than Effective Date;', ''), '') +
							 IIF([Contract Start Date] <> '' AND [Contract End Date] <> '', 
									IIF(Convert(datetime, [Contract Start Date]) > Convert(datetime, [Contract End Date]), 'Contract start date should be less than Contract end date;', ''), '') +
							 IIF([Date - Term. Date] <> '' AND [Contract End Date] <> '', 
									IIF(Convert(datetime, [Date - Term. Date]) < Convert(datetime, [Contract End Date]), 'Contract End date should be less than Termination date;', ''), '')
						) ErrorText
		FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO a WHERE [Country2 Code] <> 'CN'
		UNION ALL
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[Employee],
						'CN' [Country2 Code], 
						'China(CN) More entries' [Error Type],
						(
							  IIF(MAX_RANK >= 4, 'This employee has 4 or more entries;',
							  dbo.ValidateEmployeeContract ([EMPLOYEE], [EMPLOYEE_TYPE], [HR_CORE_CONTRACT_TYPE_01], 
															[EFFECTIVE_DATE_01], [CONTRACT_START_DATE_01], [CONTRACT_END_DATE_01],
															[LATEST_HIRE_DATE], [TERMINATION_DATE], MAX_RANK, 1)+

							  dbo.ValidateEmployeeContract ([EMPLOYEE], [EMPLOYEE_TYPE], [HR_CORE_CONTRACT_TYPE_02], 
															[EFFECTIVE_DATE_02], [CONTRACT_START_DATE_02], [CONTRACT_END_DATE_02],
															[LATEST_HIRE_DATE], [TERMINATION_DATE], MAX_RANK, 2)+

							  dbo.ValidateEmployeeContract ([EMPLOYEE], [EMPLOYEE_TYPE], [HR_CORE_CONTRACT_TYPE_03], 
															[EFFECTIVE_DATE_03], [CONTRACT_START_DATE_03], [CONTRACT_END_DATE_03],
															[LATEST_HIRE_DATE], [TERMINATION_DATE], MAX_RANK, 3))
						) ErrorText
		FROM @CONTRACT_STATUS_TRANSPOSED
		UNION ALL
		SELECT DISTINCT @which_wavestage Wave,
						@which_report [Report Name],
						[PERNR],
						'CN' [Country2 Code], 
						'China(CN) Contract Date' [Error Type],
						(
							IIF(FLAG='S', 'Row Suppressed# Contract Start date('+[CSDT]+') must be less than '+@which_date, '')+
							IIF(FLAG='E', 'Row Suppressed# Contract End date('+[CEDT]+') must be greater than Latest Hire Date('+[LHDT]+')', '')
						) ErrorText 
		 FROM @WAVE_NM_PA0016_POPULATION WHERE FLAG='E' OR FLAG = 'S'
	) a WHERE ErrorText <> ''

    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_EMPLOYEE_CONTRACT_VALIDATION;';
	SELECT DISTINCT 
	        Wave                 [Build Number] 
	       ,[Report Name]        [Report Name]
		   ,[EMPLOYEE]           [Employee ID]
		   ,[Country]            [Country Name]
		   ,[ISO3]               [Country ISO3 Code]
		   ,[WD_EMP_TYPE]        [Employee Type]
		   ,[Emp - Group]        [Employee Group]
		   ,[Error Type]         [Error Type]
		   ,[Error Text]         [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_EMPLOYEE_CONTRACT_VALIDATION 
	FROM @ERROR_TABLE A1 
	    LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[EMPLOYEE]=A2.[Emp - Personnel Number]
		LEFT JOIN COUNTRY_LKUP A3 ON A1.[COUNTRY2 CODE]=A3.[ISO2]

	/*
	DELETE FROM ALCON_MIGRATION_ERROR_LIST WHERE WAVE=@which_wavestage AND [Report Name]=@which_report
	INSERT INTO ALCON_MIGRATION_ERROR_LIST
	SELECT
		 [Wave], [Report Name], [Employee], [Country Code],
		 STUFF(
			 (SELECT DISTINCT ',' + [Error Text]
			  FROM @ERROR_TABLE
			  WHERE [Wave] = a.[Wave] AND [Report Name] = a.[Report Name] AND [Employee] = a.[Employee] AND [Country Code]=a.[Country Code]
			  FOR XML PATH (''))
			  , 1, 1, '')  AS URLList
	FROM @ERROR_TABLE AS a WHERE [Employee] IS NOT NULL
	GROUP BY [Wave], [Report Name], [Employee], [Country Code]
	ORDER BY [Wave], [Report Name], [Employee], [Country Code];
	*/

	PRINT GETDATE();
	UPDATE @MAINTAIN_EMPLOYEE_CONTRACT_INFO SET
	        [Contract Start Date]=CONVERT(varchar(10), CAST([Latest Hire Date] as date), 23),
			[Effective Date]=CONVERT(varchar(10), CAST([Latest Hire Date] as date), 23)
	   WHERE Convert(datetime, [Contract Start Date]) < Convert(datetime, [Latest Hire Date]) --AND [Country2 Code] <> 'CN'

	/* Creating DGW table for Maintain Employee Contract report */
	PRINT 'Creating DGW table for Maintain Employee Contract report';
	PRINT GETDATE();
	DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT';
	EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
	PRINT 'Drop table, If exists: '+@Table_Name;

    SELECT [Spreadsheet Key]
		,[Employee]
		,[Employee Rank] [Row ID]
		,[Employee Contract]
		,[Employee Contract Reason]
		,[Employee Contract ID]
		,[Effective Date]
		,[Contract ID]
		,[Contract Type]
		,[Contract Start Date]
		,[Contract End Date]
		,[Employee Contract Collective Agreement]
		,[Maximum Weekly Hours]
		,[Minimum Weekly Hours]
		,[Contract Status]
		,[Position]
		,[Contract Description]
		,[Date Employee Signed]
		,[Date Employer Signed]
		,[Worker Document]
		,[Latest Hire Date]
		,[Date - Term. Date]
		,[Employee Type]
		,[Country2 Code]
		,[wd_emp_type]
	INTO WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT
	FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO 
	WHERE [Employee Type] NOT IN ('7', '9') AND NOT(([Contract Type] = ''))

	/* Creating Delta DGW table for Maintain Employee Contract report */
	SET @Table_Name = 'WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT_DELTA';
	EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
	PRINT 'Drop table, If exists: '+@Table_Name;

    SELECT * INTO [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT_DELTA]
	    FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] 
		WHERE [Employee] IN (SELECT DISTINCT [PersNr] FROM @WAVE_NM_PARTIAL_RETIREMENT) ORDER BY [Employee], [Row ID]
	PRINT GETDATE();

	/*
	SELECT * FROM @MAINTAIN_EMPLOYEE_CONTRACT_INFO
		WHERE [Employee] IN (SELECT [Employee ID] 
								 FROM [ALCON_MIGRATION_ERROR_LIST] 
								 WHERE Wave=@which_wavestage AND [Report Name]='Maintain Employee Contract' AND 
									  [Employee ID] NOT IN (SELECT [Employee] FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT]))  ORDER BY [Employee] 
	*/

END
--Multiples contract logic need to be implemented -> Check with Hitesh.
--for contracts, if we are loading multiple contracts for any employee like we did for China w3 gold, 
--then instead of overwriting the start date with hire date, we should not load any contract with start date before hire date 

--EXEC PROC_WAVE_NM_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT 'P0', 'Maintain Employee Contract', '2021-03-10', 'P0_', 'P0_'
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] ORDER BY [Employee], [Row ID]
--SELECT DISTINCT * FROM NOVARTIS_DATA_MIGRATION_EMPLOYEE_CONTRACT_VALIDATION ORDER BY [EMPLOYEE ID]

--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT_DELTA] ORDER BY [Employee], [Row ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_GOLD' AND [Report Name]='Maintain Employee Contract' ORDER BY [Employee ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Employee]='33007145' ORDER BY [Employee], [Row ID]
--SELECT [Country2 Code], wd_emp_type FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] A2 WHERE [Contract Type] like '%fixed%' AND [Country2 Code] NOT IN ('DE', 'CH', 'AT', 'DK')
--SELECT [Country2 Code], wd_emp_type, COUNT(*)
--   FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] A2 
--   WHERE [Contract Type] like '%fixed%' AND [Country2 Code] NOT IN ('DE', 'CH', 'AT', 'DK')
--   GROUP BY [Country2 Code], wd_emp_type

--EXEC PROC_W3_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT 'W4_P2', 'Maintain Employee Contract', '2020-10-02', 'W4_P2_', 'W4_P2_'
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] ORDER BY [Employee], [Row ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT_DELTA] ORDER BY [Employee], [Row ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='Maintain Employee Contract' ORDER BY [Employee ID]

--EXEC PROC_W3_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT 'W4_P2', 'Maintain Employee Contract', '2020-10-02', 'W4_P2_', 'W4_P2_'
--EXEC PROC_W3_AUTOMATE_MAINTAIN_EMPLOYEE_CONTRACT 'W3_GOLD', 'Maintain Employee Contract', '2020-10-11', 'W3_GOLD_', 'W3_GOLD_'
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] ORDER BY [Employee], [Row ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Employee] IN (SELECT DISTINCT [PersNr] FROM W4_P2_PARTIAL_RETIREMENT) ORDER BY [Employee], [Row ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Contract End Date] <> '' ORDER BY [Employee], [Row ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Employee] IN ('01004330', '02116379') ORDER BY [Employee], [Row ID]
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Employee Type] IN ('4', '3') ORDER BY [Employee], [Row ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_P2' AND [Report Name]='Maintain Employee Contract' ORDER BY [Employee ID]
--SELECT * FROM W3_GOLD_CITIZENSHIP_LKUP WHERe PERNR like '14%' ORDER BY PERNR
--SELECT * FROM WAVE_NM_PA0016_POPULATION WHERE FLAG='Y' ORDER BY CTTYP, PERNR
--SELECT * INTO WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT_OLD FROM WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [COUNTRY2 CODE]='MY' AND [Contract Type] <> ''
--SELECT DISTINCT [Date - Term. Date] FROM W3_POSITION_MANAGEMENT
--SELECT * FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] WHERE [Employee] IN (SELECT [Employee ID] FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W3_P1' AND [Report Name]='Maintain Employee Contract')  ORDER BY [Employee] 
--SELECT * 
--    FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT] 
--	WHERE [Employee] IN (SELECT [Employee ID] 
--	                         FROM [ALCON_MIGRATION_ERROR_LIST] 
--							 WHERE Wave='W3_P1' AND [Report Name]='Maintain Employee Contract' AND 
--							      [Employee ID] NOT IN (SELECT [Employee] FROM [WD_HR_TR_AUTOMATED_MAINTAIN_EMPLOYEE_CONTRACT]))  ORDER BY [Employee] 
--SELECT DISTINCT IIF(CTEDT='00000000', '', CONVERT(varchar(10), CAST(CTEDT as date), 101)) CTEDT FROM WAVE_NM_PA0016 WHERE BEGDA <= CAST('2020-04-11' AS DATE) AND ENDDA >= CAST('2020-04-11' AS DATE) ORDEr BY CTEDT
--PRINT CONVERT(varchar(10), CAST('99991231' as date), 101)
--SELECT DISTINCT CTTYP FROM WAVE_NM_PA0016 WHERE BEGDA <= CAST('2020-10-02' AS DATE) AND ENDDA >= CAST('2020-10-02' AS DATE) AND PERNR LIKE '01%' ORDEr BY CTTYP
--SELECT DISTINCT CTEDT, CTTYP FROM WAVE_NM_PA0016 WHERE CTTYP='02' AND BEGDA <= CAST('2020-10-02' AS DATE) AND ENDDA >= CAST('2020-10-02' AS DATE) AND PERNR IN ('14900143', '28011157', '28011242') ORDEr BY CTEDT
--SELECT * FROM WAVE_NM_CITIZENSHIP_LKUP WHERe PERNR IN ('14900143', '28011157', '28011242')
--SELECT DISTINCT CTEDT, CTTYP FROM WAVE_NM_PA0016 WHERE CTTYP='02' AND BEGDA <= CAST('2020-10-02' AS DATE) AND ENDDA >= CAST('2020-10-02' AS DATE)
--SELECT DISTINCT BEGDA FROM WAVE_NM_PA0016 WHERE BEGDA <= CAST('2020-06-18' AS DATE) AND ENDDA >= CAST('2020-06-18' AS DATE) ORDEr BY BEGDA
--SELECT [Geo - Country (CC)], [Geo - Work Country], [WD_location_id] FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [Geo - Country (CC)] IN ('HK')
--SELECT COUNT(*)
--    FROM W3_GOLD_PA0016 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
--	WHERE BEGDA <= CAST('2020-10-11' AS DATE) AND ENDDA >= CAST('2020-10-11' AS DATE) AND [Geo - Work Country]='MY' AND CTTYP='01' --ORDEr BY BEGDA
--SELECT [emp - sub group] FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [Emp - Personnel Number]=''
--SELECt * FROM W3_CATCHUP1_PA0016 WHERE PERNR='14000053'
--SELECT * FROM W3_GOLD_CITIZENSHIP_LKUP
--SELECT [Emp - Subgroup] FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [Emp - Personnel Number]='01008678'