USE [Prod_DataClean]
GO

/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES]    Script Date: 10/02/2020 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Subramanian.C>
-- =============================================
/* If the function('dbo.CheckDateValue') already exist */
IF OBJECT_ID('dbo.CheckDateValue') IS NOT NULL
  DROP FUNCTION CheckDateValue
GO
CREATE FUNCTION CheckDateValue (
   @DateValue   AS VARCHAR(30)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	SET @result=IIF(ISNULL(@DateValue, '00000000')='00000000', '',CONVERT(varchar(15), CAST(@DateValue as date), 101));

    RETURN (IIF(@result<>'',@result+';', ''));
END
GO

/* If the function('dbo.CheckVocationOverrideDate') already exist */
IF OBJECT_ID('dbo.CheckVacationOverrideDate') IS NOT NULL
  DROP FUNCTION CheckVacationOverrideDate
GO
CREATE FUNCTION CheckVacationOverrideDate (
   @DateValue               AS VARCHAR(30),
   @OriginalHireDate        AS VARCHAR(30),
   @ContinuousServiceDate   AS VARCHAR(30)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	SET @result=IIF(ISNULL(@DateValue, '00000000')='00000000', '', @DateValue);
	IF (@result < @OriginalHireDate AND @result < @ContinuousServiceDate AND @result <> '')
	BEGIN
		SET @result=IIF(ISNULL(@DateValue, '00000000')='00000000', '',CONVERT(varchar(15), CAST(@DateValue as date), 101));
	END
	ELSE
	BEGIN
		SET @result='';
	END

    RETURN (IIF(@result<>'', @result+';', ''));
END
GO

/* If the function('dbo.CheckTimeOfServiceDate') already exist */
IF OBJECT_ID('dbo.CheckTimeOfServiceDate') IS NOT NULL
  DROP FUNCTION CheckTimeOfServiceDate
GO
CREATE FUNCTION CheckTimeOfServiceDate (
   @DateValue   AS VARCHAR(30),
   @CountryCode AS VARCHAR(30),
   @DateType    AS VARCHAR(30)
)
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	--SELECT * FROM W4_PHONE_VALIDATION ORDER BY COUNTRY
	
	SET @result=(CASE
	                WHEN (@DateType='T1' AND @CountryCode='TR') THEN 
					     IIF(ISNULL(@DateValue, '00000000')='00000000', '', CONVERT(varchar(15), CAST(@DateValue as date), 101))
					WHEN (@DateType='R0' AND @CountryCode='UA') THEN 
					     IIF(ISNULL(@DateValue, '00000000')='00000000', '', CONVERT(varchar(15), CAST(@DateValue as date), 101))
					WHEN (@DateType='81' AND (@CountryCode<>'UA' AND @CountryCode<>'TR')) THEN 
					     IIF(ISNULL(@DateValue, '00000000')='00000000', '', CONVERT(varchar(15), CAST(@DateValue as date), 101))
				ELSE ''
				END)

    RETURN (IIF(@result<>'',@result+';', ''));
END
GO


-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES]
    @which_wavestage    AS NVARCHAR(50),
	@which_report       AS NVARCHAR(500),
	@which_date         AS NVARCHAR(50),
	@PrefixCheck        AS VARCHAR(50),
	@PrefixCopy         AS VARCHAR(50)
AS
BEGIN

	/* Required Info type table */
	DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_PA0041;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0041 FROM '+@which_wavestage+'_PA0041 WHERE [DAR01] <> ''Date'';';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							FROM '+@which_wavestage+'_POSITION_MANAGEMENT  WHERE WD_COMPANY <> ''ES42'') a
				WHERE a.RNK=1'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	--EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'ALTER TABLE WAVE_NM_POSITION_MANAGEMENT_BASE ADD [Emp - Emp Stat HRC] NVARCHAR(200);';
	--UPDATE WAVE_NM_POSITION_MANAGEMENT_BASE SET [Emp - Emp Stat HRC]='999'

	/****** Script to automate Service Date table  ******/
	DECLARE @SD_VALUE_INFO TABLE(
		VALUE_SPLIT   VARCHAR(10)
	);
	INSERT INTO @SD_VALUE_INFO SELECT * FROM dbo.fnsplit('U4,74,T2', ',');

	DECLARE @SD_COUNTRY_INFO TABLE(
		COUNTRY_SPLIT   VARCHAR(10)
	);
	INSERT INTO @SD_COUNTRY_INFO SELECT * FROM dbo.fnsplit('US,CA,TR', ',');

	DECLARE @RED_VALUE_INFO TABLE(
		VALUE_SPLIT   VARCHAR(10)
	);
	INSERT INTO @RED_VALUE_INFO SELECT * FROM dbo.fnsplit('Z3', ',');

	DECLARE @RED_COUNTRY_INFO TABLE(
		COUNTRY_SPLIT   VARCHAR(10)
	);
	INSERT INTO @RED_COUNTRY_INFO SELECT * FROM dbo.fnsplit('TR', ',');


	DECLARE @VO_COUNTRY_INFO TABLE(
		COUNTRY_SPLIT   VARCHAR(10)
	);
	INSERT INTO @VO_COUNTRY_INFO SELECT * FROM dbo.fnsplit('US', ',');

	DECLARE @TS_COUNTRY_INFO TABLE(
		COUNTRY_SPLIT   VARCHAR(10)
	);
	INSERT INTO @TS_COUNTRY_INFO SELECT * FROM dbo.fnsplit('US,CA,MX', ',');

	DECLARE @TS_VALUE_INFO TABLE(
		VALUE_SPLIT   VARCHAR(10)
	);
	INSERT INTO @TS_VALUE_INFO SELECT * FROM dbo.fnsplit('T1,R0,81', ',');

	DECLARE @VS_VALUE_INFO TABLE(
		VALUE_SPLIT   VARCHAR(10)
	);
	INSERT INTO @VS_VALUE_INFO SELECT * FROM dbo.fnsplit('M1,14,', ',');

	DECLARE @SI_VALUE_INFO TABLE(
		VALUE_SPLIT   VARCHAR(10)
	);
	INSERT INTO @SI_VALUE_INFO SELECT * FROM dbo.fnsplit('I4,F0', ',');

	DECLARE @SERVICE_DATES TABLE (
	     [Employee or Contingent Worker ID]                        VARCHAR(200),
		 [Emp - Personnel Number]                                  VARCHAR(200), 
		 [Original Hire Date]                                      VARCHAR(200),
		 [Continuous Service Date]                                 VARCHAR(200),
		 [Expected Retirement Date]                                VARCHAR(200),
		 [Retirement Eligibility Date]                             VARCHAR(200),
		 [End_Employment Date]                                     VARCHAR(200),
		 [Seniority Date]                                          VARCHAR(200),
		 [Severance Date]                                          VARCHAR(200),
		 [Contract End Date]                                       VARCHAR(200),
	     [Benefits Service Date]                                   VARCHAR(200),
	     [Company Service Date]                                    VARCHAR(200),
		 [Time Off Service Date]                                   VARCHAR(200),
		 [Vesting Date]                                            VARCHAR(200),
	     [Date Entered Workforce]                                  VARCHAR(200),
		 [Days Unemployed]                                         VARCHAR(200),
	     [Months Continuous Prior Employment]                      VARCHAR(200),
		 [Vacation Seniority]                                      VARCHAR(200),
		 [Vacation Override]                                       VARCHAR(200),
		 [Latest Hire Date]                                        VARCHAR(200),
		 [Emp - SubGroup]                                          VARCHAR(200),
		 [Emp Type]                                                VARCHAR(200),
		 [Country CC]                                              VARCHAR(200)
	);

	/********** Service Dates ***********/
	PRINT 'AE Service Dates Starts'
	INSERT INTO @SERVICE_DATES
	SELECT * FROM (
	SELECT a.[PERSNO_NEW]  [Employee or Contingent Worker ID]
	      ,a.[Emp - Personnel Number]
		  ,IIF(ISNULL(a.[wd_original_hire_Date], '')='', '', CAST(CONVERT(varchar(10), CAST(a.[wd_original_hire_Date] as date), 101) AS VARCHAR(15)))  [Original Hire Date]
		  ,IIF(ISNULL(a.[wd_continuous_service_date], '')='', '', CAST(CONVERT(varchar(10), CAST(a.[wd_continuous_service_date] as date), 101) AS VARCHAR(15))) [Continuous Service Date]
		  ,'' [Expected Retirement Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		    IIF((ISNULL(a.[Geo - Country (CC)], '') IN (SELECT * FROM @RED_COUNTRY_INFO)),
		   (IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] IN (SELECT * FROM @RED_VALUE_INFO)), dbo.CheckDateValue([DAT24]), ''), '')), ''),'')), ';')), '') [Retirement Eligibility Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
          (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		        ISNULL(a.[Emp - Emp Stat HRC], '') <> '2' AND 
				a.[emp - group] in ('2', '6')),
		    IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] = 'Z2'), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] = 'Z2'), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] = 'Z2'), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] = 'Z2'), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] = 'Z2'), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] = 'Z2'), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] = 'Z2'), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] = 'Z2'), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] = 'Z2'), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] = 'Z2'), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] = 'Z2'), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] = 'Z2'), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] = 'Z2'), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] = 'Z2'), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] = 'Z2'), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] = 'Z2'), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] = 'Z2'), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] = 'Z2'), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] = 'Z2'), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] = 'Z2'), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] = 'Z2'), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] = 'Z2'), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] = 'Z2'), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] = 'Z2'), dbo.CheckDateValue([DAT24]), ''), ''), '')), ';')), '') [End_Employment Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		   (IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] IN (SELECT * FROM @SI_VALUE_INFO)), dbo.CheckDateValue([DAT24]), ''), '')), '')), ';')), '')  [Seniority Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		    IIF((ISNULL(a.[Geo - Country (CC)], '') IN (SELECT * FROM @SD_COUNTRY_INFO)),
		   (IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] IN (SELECT * FROM @SD_VALUE_INFO)), dbo.CheckDateValue([DAT24]), ''), '')), ''),'')), ';')), '')  [Severance Date]
		  ,'' [Contract End Date]
		  ,'' [Benefits Service Date]
		  ,'' [Company Service Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		   (IIF(ISNULL([DAR01], '') <> '', dbo.CheckTimeOfServiceDate([DAT01], [Geo - Country (CC)], [DAR01]), '') +
		    IIF(ISNULL([DAR02], '') <> '', dbo.CheckTimeOfServiceDate([DAT02], [Geo - Country (CC)], [DAR02]), '') +
			IIF(ISNULL([DAR03], '') <> '', dbo.CheckTimeOfServiceDate([DAT03], [Geo - Country (CC)], [DAR03]), '') +
			IIF(ISNULL([DAR04], '') <> '', dbo.CheckTimeOfServiceDate([DAT04], [Geo - Country (CC)], [DAR04]), '') +
			IIF(ISNULL([DAR05], '') <> '', dbo.CheckTimeOfServiceDate([DAT05], [Geo - Country (CC)], [DAR05]), '') +
			IIF(ISNULL([DAR06], '') <> '', dbo.CheckTimeOfServiceDate([DAT06], [Geo - Country (CC)], [DAR06]), '') +
			IIF(ISNULL([DAR07], '') <> '', dbo.CheckTimeOfServiceDate([DAT07], [Geo - Country (CC)], [DAR07]), '') +
			IIF(ISNULL([DAR08], '') <> '', dbo.CheckTimeOfServiceDate([DAT08], [Geo - Country (CC)], [DAR08]), '') +
			IIF(ISNULL([DAR09], '') <> '', dbo.CheckTimeOfServiceDate([DAT09], [Geo - Country (CC)], [DAR09]), '') +
			IIF(ISNULL([DAR10], '') <> '', dbo.CheckTimeOfServiceDate([DAT10], [Geo - Country (CC)], [DAR10]), '') +
			IIF(ISNULL([DAR11], '') <> '', dbo.CheckTimeOfServiceDate([DAT11], [Geo - Country (CC)], [DAR11]), '') +
			IIF(ISNULL([DAR12], '') <> '', dbo.CheckTimeOfServiceDate([DAT12], [Geo - Country (CC)], [DAR12]), '') +
			IIF(ISNULL([DAR13], '') <> '', dbo.CheckTimeOfServiceDate([DAT13], [Geo - Country (CC)], [DAR13]), '') +
			IIF(ISNULL([DAR14], '') <> '', dbo.CheckTimeOfServiceDate([DAT14], [Geo - Country (CC)], [DAR14]), '') +
			IIF(ISNULL([DAR15], '') <> '', dbo.CheckTimeOfServiceDate([DAT15], [Geo - Country (CC)], [DAR15]), '') +
			IIF(ISNULL([DAR16], '') <> '', dbo.CheckTimeOfServiceDate([DAT16], [Geo - Country (CC)], [DAR16]), '') +
			IIF(ISNULL([DAR17], '') <> '', dbo.CheckTimeOfServiceDate([DAT17], [Geo - Country (CC)], [DAR17]), '') +
			IIF(ISNULL([DAR18], '') <> '', dbo.CheckTimeOfServiceDate([DAT18], [Geo - Country (CC)], [DAR18]), '') +
			IIF(ISNULL([DAR19], '') <> '', dbo.CheckTimeOfServiceDate([DAT19], [Geo - Country (CC)], [DAR19]), '') +
			IIF(ISNULL([DAR20], '') <> '', dbo.CheckTimeOfServiceDate([DAT20], [Geo - Country (CC)], [DAR20]), '') +
			IIF(ISNULL([DAR21], '') <> '', dbo.CheckTimeOfServiceDate([DAT21], [Geo - Country (CC)], [DAR21]), '') +
			IIF(ISNULL([DAR22], '') <> '', dbo.CheckTimeOfServiceDate([DAT22], [Geo - Country (CC)], [DAR22]), '') +
			IIF(ISNULL([DAR23], '') <> '', dbo.CheckTimeOfServiceDate([DAT23], [Geo - Country (CC)], [DAR23]), '') +
			IIF(ISNULL([DAR24], '') <> '', dbo.CheckTimeOfServiceDate([DAT24], [Geo - Country (CC)], [DAR24]), '')), '')), ';')), '')  [Time Off Service Date]
		  ,'' [Vesting Date]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		   (IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] = '80'), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] = '80'), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] = '80'), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] = '80'), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] = '80'), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] = '80'), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] = '80'), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] = '80'), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] = '80'), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] = '80'), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] = '80'), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] = '80'), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] = '80'), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] = '80'), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] = '80'), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] = '80'), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] = '80'), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] = '80'), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] = '80'), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] = '80'), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] = '80'), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] = '80'), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] = '80'), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] = '80'), dbo.CheckDateValue([DAT24]), ''), '')), '')), ';')), '') [Date Entered Workforce]
		  ,'' [Days Unemployed]
		  ,'' [Months Continuous Prior Employment]
		  ,ISNULL((SELECT TOP 1 * FROM dbo.fnsplit(
		   (IIF((ISNULL(a.[Emp - Emp Stat HRC], '') <> '0' AND
		         ISNULL(a.[Emp - Emp Stat HRC], '') <> '2'),
		   (IIF(ISNULL([DAR01], '') <> '', IIF(([DAR01] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT01]), ''), '') +
		    IIF(ISNULL([DAR02], '') <> '', IIF(([DAR02] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT02]), ''), '') +
			IIF(ISNULL([DAR03], '') <> '', IIF(([DAR03] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT03]), ''), '') +
			IIF(ISNULL([DAR04], '') <> '', IIF(([DAR04] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT04]), ''), '') +
			IIF(ISNULL([DAR05], '') <> '', IIF(([DAR05] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT05]), ''), '') +
			IIF(ISNULL([DAR06], '') <> '', IIF(([DAR06] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT06]), ''), '') +
			IIF(ISNULL([DAR07], '') <> '', IIF(([DAR07] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT07]), ''), '') +
			IIF(ISNULL([DAR08], '') <> '', IIF(([DAR08] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT08]), ''), '') +
			IIF(ISNULL([DAR09], '') <> '', IIF(([DAR09] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT09]), ''), '') +
			IIF(ISNULL([DAR10], '') <> '', IIF(([DAR10] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT10]), ''), '') +
			IIF(ISNULL([DAR11], '') <> '', IIF(([DAR11] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT11]), ''), '') +
			IIF(ISNULL([DAR12], '') <> '', IIF(([DAR12] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT12]), ''), '') +
			IIF(ISNULL([DAR13], '') <> '', IIF(([DAR13] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT13]), ''), '') +
			IIF(ISNULL([DAR14], '') <> '', IIF(([DAR14] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT14]), ''), '') +
			IIF(ISNULL([DAR15], '') <> '', IIF(([DAR15] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT15]), ''), '') +
			IIF(ISNULL([DAR16], '') <> '', IIF(([DAR16] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT16]), ''), '') +
			IIF(ISNULL([DAR17], '') <> '', IIF(([DAR17] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT17]), ''), '') +
			IIF(ISNULL([DAR18], '') <> '', IIF(([DAR18] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT18]), ''), '') +
			IIF(ISNULL([DAR19], '') <> '', IIF(([DAR19] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT19]), ''), '') +
			IIF(ISNULL([DAR20], '') <> '', IIF(([DAR20] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT20]), ''), '') +
			IIF(ISNULL([DAR21], '') <> '', IIF(([DAR21] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT21]), ''), '') +
			IIF(ISNULL([DAR22], '') <> '', IIF(([DAR22] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT22]), ''), '') +
			IIF(ISNULL([DAR23], '') <> '', IIF(([DAR23] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT23]), ''), '') +
			IIF(ISNULL([DAR24], '') <> '', IIF(([DAR24] IN (SELECT * FROM @VS_VALUE_INFO)), dbo.CheckDateValue([DAT24]), ''), '')), '')), ';')), '')  [Vacation Seniority]
          ,'' [Vacation Override]
		  ,IIF(ISNULL(a.[wd_latest_hire_Date], '')='', '', CAST(CONVERT(varchar(10), CAST(a.[wd_latest_hire_Date] as date), 101) AS VARCHAR(15)))  [Latest Hire Date]
         ,[emp - subgroup]
		 ,[WD_emp_type]
		 ,[Geo - Country (CC)]
	  FROM (SELECT DISTINCT [Emp - Personnel Number]
	              ,[PERSNO_NEW]
				  ,CAST(CAST([Emp - Emp Stat HRC] AS DECIMAL(20)) AS VARCHAR(20)) [Emp - Emp Stat HRC]
				  ,[emp - group]
				  ,[emp - subgroup]
				  ,[WD_emp_type]
				  ,[Geo - Country (CC)]
				  ,[wd_original_hire_Date]
				  ,[wd_continuous_service_date]
				  ,[wd_latest_hire_date]
			FROM [WAVE_NM_POSITION_MANAGEMENT_BASE]) a  
			     LEFT JOIN (SELECT DISTINCT * FROM WAVE_NM_PA0041 WHERE BEGDA <= @which_date AND ENDDA >=@which_date) b 
				    ON a.[Emp - Personnel Number]=b.PERNR
			WHERE a.[Emp - Group] NOT IN ('7', '9')
	) a 
	--SELECT COUNT([Emp - Emp Stat HRC]) FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] WHERE [Emp - Group] NOT IN ('7', '9')

	/********** Validation Starts ************/
	PRINT 'AE Service dates Validation starts'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_AE_SERVICE_DATES_VALIDATION;';
	SELECT DISTINCT 
	        Wave                 [Build Number] 
	       ,[Report Name]        [Report Name]
		   ,[Employee ID]        [Employee ID]
		   ,[Country]            [Country Name]
		   ,[ISO3]               [Country ISO3 Code]
		   ,[Emp Type]           [Employee Type]
		   ,[Emp - SubGroup]     [Employee Group]
		   ,'Hire Dates'         [Error Type]
		   ,[ErrorText]          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_AE_SERVICE_DATES_VALIDATION 
	FROM (
		SELECT @which_wavestage Wave, 
		       @which_report [Report Name],
			   [Employee or Contingent Worker ID] [Employee Id], 
			   [Emp Type],
			   [Emp - SubGroup],
			   A2.Country,
			   A2.[Country Code] ISO3,
			   (IIF(ISNULL(a.[Original Hire Date], '')='', 'Original Hire Date is required;', '') +
				IIF(ISNULL(a.[Continuous Service Date], '')='', 'Continious Hire Date is required;', '') +
			    IIF([Original Hire Date] <> '' AND [Latest Hire Date] <> '', 
				    IIF(Convert(datetime, [Original Hire Date]) > Convert(datetime, [Latest Hire Date]), 'Original Hire Date cannot be greater than either the Hire Date or the earliest Hire Date from previous Hire Events.;', ''), '')) ErrorText
		FROM @SERVICE_DATES a LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON a.[Country CC]=A2.[Country2 Code]
    ) b WHERE ErrorText <> ''

	/********* Service Dates for Active Employees *********/
	DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_AE_SERVICE_DATES';
	EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
	PRINT 'Drop table, If exists: '+@Table_Name;

	SELECT 
	      [Employee or Contingent Worker ID]
		 ,[Original Hire Date]
		 ,[Continuous Service Date]
		 ,[Expected Retirement Date]
		 ,[Retirement Eligibility Date]
		 ,[End_Employment Date]
		 ,[Seniority Date]
		 ,[Severance Date]
		 ,[Contract End Date]
	     ,[Benefits Service Date]
	     ,[Company Service Date]
		 ,[Time Off Service Date]
		 ,[Vesting Date]
	     ,[Date Entered Workforce]
		 ,[Days Unemployed]
	     ,[Months Continuous Prior Employment]
    INTO WD_HR_TR_AUTOMATED_AE_SERVICE_DATES
	FROM @SERVICE_DATES

    /********* Service Dates for Active Employees(Delta) *********/
	SET @Table_Name='WD_HR_TR_AUTOMATED_DELTA_AE_SERVICE_DATES';
	EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
	PRINT 'Drop table, If exists: '+@Table_Name;

	SELECT * INTO WD_HR_TR_AUTOMATED_DELTA_AE_SERVICE_DATES FROM WD_HR_TR_AUTOMATED_AE_SERVICE_DATES WHERE [Retirement Eligibility Date] <> ''


END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES 'P0', 'Service Dates(AE)', '2021-03-10', 'P0_', 'P0_' 
--SELECT * FROM WD_HR_TR_AUTOMATED_AE_SERVICE_DATES ORDER BY [Employee or Contingent Worker ID]
--SELECT * FROM NOVARTIS_DATA_MIGRATION_AE_SERVICE_DATES_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]

--EXEC PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES 'W4_P2', 'Service Dates(AE)', '2020-10-02', 'W4_P2_', 'W4_P2_' 
--EXEC PROC_WAVE_NM_AUTOMATE_AE_SERVICE_DATES 'W4_GOLD', 'Service Dates(AE)', '2021-02-14', 'W4_GOLD_', 'W4_GOLD_'
--SELECT * FROM WD_HR_TR_AUTOMATED_DELTA_AE_SERVICE_DATES ORDER BY [Employee or Contingent Worker ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_AE_SERVICE_DATES ORDER BY [Employee or Contingent Worker ID]
--SELECT * FROM [Dev_DataCleansing].[dbo].[ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_GOLD' AND [Report Name]='Service Dates(AE)' ORDER BY [Employee Id]
--SELECT * FROM WD_HR_TR_AUTOMATED_AE_SERVICE_DATES WHERE [Employee or Contingent Worker ID] IN (SELECT PERSNO FROM WAVE_NM_p2_IT41_AU_NZ) ORDER BY [Employee or Contingent Worker ID]
--SELECT * FROM WAVE_NM_p2_IT41_AU_NZ ORDER BY PERSNO
--SELECT * FROM WD_HR_TR_AUTOMATED_AE_SERVICE_DATES WHERE [Employee or Contingent Worker ID] IN (SELECT PERSNO FROM WAVE_NM_p2_IT41_AU_NZ) ORDER BY [Employee or Contingent Worker ID]
--SELECT * FROM WAVE_NM_PA0041 WHERE 