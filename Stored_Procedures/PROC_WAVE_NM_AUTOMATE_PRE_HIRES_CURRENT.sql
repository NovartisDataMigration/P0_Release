USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_PRE_HIRES]    Script Date: 4/9/2021 8:54:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_PRE_HIRES', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_PRE_HIRES;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_PRE_HIRES]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Pre Hires(Novartis Migration)  ******/
--EXEC PROC_WAVE_NM_AUTOMATE_PRE_HIRES 'P0', 'Pre Hires', '2021-03-10'
--SELECT * FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT ORDER BY CAST([Applicant Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS ORDER BY CAST([Applicant Key] AS INT)
--SELECT * FROM NOVARTIS_DATA_MIGRATION_PRE_HIRES_VALIDATION ORDER BY [Employee ID]

--SELECT * FROM [WAVE_NM_POSITION_MANAGEMENT_INITIAL]
--SELECT COUNT(*) FROM [P0_POSITION_MANAGEMENT] WHERE ISNULL([Emp - email address], '')=''
--SELECT COUNT(*) FROM [P0_POSITION_MANAGEMENT]
--SELECT DISTINCT USRID_LONG FROM P0_PA0105 WHERE SUBTY='0010' AND ENDDA >= CAST('2021-03-10' AS DATE) AND BEGDA <= CAST('2021-03-10' AS DATE)

	BEGIN TRY 
		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		DECLARE @PRE_HIRES_APPLICANT TABLE (
			[Applicant Key]                                                                                                 NVARCHAR(2000),
			[Applicant Reference Descriptor]                                                                                NVARCHAR(2000),
			[Applicant Reference ID type]                                                                                   NVARCHAR(2000),
			[Applicant Reference ID]                                                                                        NVARCHAR(2000),
			[Applicant ID]                                                                                                  NVARCHAR(2000),
			[Universal ID]                                                                                                  NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Formatted Name]                                                           NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Reporting Name]                                                           NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Country Reference Descriptor]                                             NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Country Reference ID type]                                                NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Country Reference ID]                                                     NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Title Reference Descriptor]                                 NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Title Reference ID type]                                    NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Title Reference ID]                                         NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Title Descriptor]                                           NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference Descriptor]                            NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference ID type]                               NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference ID]                                    NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - First Name]                                                               NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Middle Name]                                                              NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Last Name]                                                                NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Secondary Last Name]                                                      NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Tertiary Last Name]                                                       NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Local Name]                                      NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Local Script]                                    NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - First Name]                                      NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Middle Name]                                     NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Last Name]                                       NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name]                             NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - First Name 2]                                    NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Middle Name 2]                                   NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Last Name 2]                                     NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name 2]                           NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference Descriptor]                         NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID type]                            NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID]                                 NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Descriptor]                                   NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference Descriptor]                       NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID type]                          NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID]                               NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference Descriptor]                     NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID type]                        NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID]                             NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference Descriptor]                       NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID type]                          NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID]                               NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference Descriptor]                   NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID type]                      NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID]                           NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference Descriptor]                      NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID type]                         NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID]                              NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference Descriptor]                          NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID type]                             NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID]                                  NVARCHAR(2000),
			[Legal Name Data - Name Detail Data - Full Name for Singapore and Malaysia]                                     NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Formatted Name]                                                       NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Reporting Name]                                                       NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Country Reference Descriptor]                                         NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Country Reference ID type]                                            NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Country Reference ID]                                                 NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Title Reference Descriptor]                             NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Title Reference ID type]                                NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Title Reference ID]                                     NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Title Descriptor]                                       NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference Descriptor]                        NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference ID type]                           NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference ID]                                NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - First Name]                                                           NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Middle Name]                                                          NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Last Name]                                                            NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Secondary Last Name]                                                  NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Tertiary Last Name]                                                   NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Local Name]                                  NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Local Script]                                NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - First Name]                                  NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Middle Name]                                 NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Last Name]                                   NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name]                         NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - First Name 2]                                NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Middle Name 2]                               NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Last Name 2]                                 NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name 2]                       NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference Descriptor]                     NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID type]                        NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID]                             NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Descriptor]                               NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference Descriptor]                   NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID type]                      NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID]                           NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference Descriptor]                 NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID type]                    NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID]                         NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference Descriptor]                   NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID type]                      NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID]                           NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference Descriptor]               NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID type]                  NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID]                       NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference Descriptor]                  NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID type]                     NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID]                          NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference Descriptor]                      NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID type]                         NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID]                              NVARCHAR(2000),
			[Preferred Name Data - Name Detail Data - Full Name for Singapore and Malaysia]                                 NVARCHAR(2000),
			[Gender Reference Descriptor]                                                                                   NVARCHAR(2000),
			[Gender Reference ID type]                                                                                      NVARCHAR(2000),
			[Gender Reference ID]                                                                                           NVARCHAR(2000),
			[Birth Date]                                                                                                    NVARCHAR(2000),
			[Date of Death]                                                                                                 NVARCHAR(2000),
			[Country of Birth Reference Descriptor]                                                                         NVARCHAR(2000),
			[Country of Birth Reference ID type]                                                                            NVARCHAR(2000),
			[Country of Birth Reference ID]                                                                                 NVARCHAR(2000),
			[Region of Birth Reference Descriptor]                                                                          NVARCHAR(2000),
			[Region of Birth Reference ID type]                                                                             NVARCHAR(2000),
			[Region of Birth Reference ID]                                                                                  NVARCHAR(2000),
			[Region of Birth Descriptor]                                                                                    NVARCHAR(2000),
			[City of Birth]                                                                                                 NVARCHAR(2000),
			[City of Birth Reference Descriptor]                                                                            NVARCHAR(2000),
			[City of Birth Reference ID type]                                                                               NVARCHAR(2000),
			[City of Birth Reference ID]                                                                                    NVARCHAR(2000),
			[City of Birth Reference ID parent type]                                                                        NVARCHAR(2000),
			[City of Birth Reference ID parent id]                                                                          NVARCHAR(2000),
			[Marital Status Reference Descriptor]                                                                           NVARCHAR(2000),
			[Marital Status Reference ID type]                                                                              NVARCHAR(2000),
			[Marital Status Reference ID]                                                                                   NVARCHAR(2000),
			[Marital Status Reference ID parent type]                                                                       NVARCHAR(2000),
			[Marital Status Reference ID parent id]                                                                         NVARCHAR(2000),
			[Marital Status Date]                                                                                           NVARCHAR(2000),
			[Religion Reference Descriptor]                                                                                 NVARCHAR(2000),
			[Religion Reference ID type]                                                                                    NVARCHAR(2000),
			[Religion Reference ID]                                                                                         NVARCHAR(2000),
			[Hispanic or Latino]                                                                                            NVARCHAR(2000),
			[Primary Nationality Reference Descriptor]                                                                      NVARCHAR(2000),
			[Primary Nationality Reference ID type]                                                                         NVARCHAR(2000),
			[Primary Nationality Reference ID]                                                                              NVARCHAR(2000),
			[Hukou Region Reference Descriptor]                                                                             NVARCHAR(2000),
			[Hukou Region Reference ID type]                                                                                NVARCHAR(2000),
			[Hukou Region Reference ID]                                                                                     NVARCHAR(2000),
			[Hukou Subregion Reference Descriptor]                                                                          NVARCHAR(2000),
			[Hukou Subregion Reference ID type]                                                                             NVARCHAR(2000),
			[Hukou Subregion Reference ID]                                                                                  NVARCHAR(2000),
			[Hukou Locality]                                                                                                NVARCHAR(2000),
			[Hukou Postal Code]                                                                                             NVARCHAR(2000),
			[Hukou Type Reference Descriptor]                                                                               NVARCHAR(2000),
			[Hukou Type Reference ID type]                                                                                  NVARCHAR(2000),
			[Hukou Type Reference ID]                                                                                       NVARCHAR(2000),
			[Local Hukou]                                                                                                   NVARCHAR(2000),
			[Native Region Reference Descriptor]                                                                            NVARCHAR(2000),
			[Native Region Reference ID type]                                                                               NVARCHAR(2000),
			[Native Region Reference ID]                                                                                    NVARCHAR(2000),
			[Native Region Descriptor]                                                                                      NVARCHAR(2000),
			[Personnel File Agency for Person]                                                                              NVARCHAR(2000),
			[Last Medical Exam Date]                                                                                        NVARCHAR(2000),
			[Last Medical Exam Valid To]                                                                                    NVARCHAR(2000),
			[Medical Exam Notes]                                                                                            NVARCHAR(2000),
			[Blood Type Reference Descriptor]                                                                               NVARCHAR(2000),
			[Blood Type Reference ID type]                                                                                  NVARCHAR(2000),
			[Blood Type Reference ID]                                                                                       NVARCHAR(2000),
			[Tobacco Use]                                                                                                   NVARCHAR(2000),
			[Political Affiliation Reference Descriptor]                                                                    NVARCHAR(2000),
			[Political Affiliation Reference ID type]                                                                       NVARCHAR(2000),
			[Political Affiliation Reference ID]                                                                            NVARCHAR(2000),
			[Social Benefits Locality Reference Descriptor]                                                                 NVARCHAR(2000),
			[Social Benefits Locality Reference ID type]                                                                    NVARCHAR(2000),
			[Social Benefits Locality Reference ID]                                                                         NVARCHAR(2000),
			[Replace All]                                                                                                   NVARCHAR(2000),
			[Applicant Entered Date]                                                                                        NVARCHAR(2000),
			[Applicant Comments]                                                                                            NVARCHAR(2000),
			[Eligible For Hire Reference Descriptor]                                                                        NVARCHAR(2000),
			[Eligible For Hire Reference ID type]                                                                           NVARCHAR(2000),
			[Eligible For Hire Reference ID]                                                                                NVARCHAR(2000),
			[Eligible for Rehire Comments]                                                                                  NVARCHAR(2000),
			[Applicant Has Marked as No Show Reference Descriptor]                                                          NVARCHAR(2000),
			[Applicant Has Marked as No Show Reference ID type]                                                             NVARCHAR(2000),
			[Applicant Has Marked as No Show Reference ID]                                                                  NVARCHAR(2000),
			[Applicant Source Reference Descriptor]                                                                         NVARCHAR(2000),
			[Applicant Source Reference ID type]                                                                            NVARCHAR(2000),
			[Applicant Source Reference ID]                                                                                 NVARCHAR(2000)
		);

		INSERT INTO @PRE_HIRES_APPLICANT
		    SELECT ROW_NUMBER() OVER(ORDER BY [Applicant ID]) [Applicant Key], * FROM (
			   SELECT 
				 '' [Applicant Reference Descriptor]
				,'' [Applicant Reference ID type]
				,'' [Applicant Reference ID]
				,IIF(ISNULL([Emp - Personnel Number], '')='', '', 'A'+[Emp - Personnel Number]) [Applicant ID]
				,'' [Universal ID]
				,'' [Legal Name Data - Name Detail Data - Formatted Name]
				,'' [Legal Name Data - Name Detail Data - Reporting Name]
				,'' [Legal Name Data - Name Detail Data - Country Reference Descriptor]
				,'ISO_3166-1_Alpha-3_Code' [Legal Name Data - Name Detail Data - Country Reference ID type]
				,ISNULL((SELECT ISO3 FROM COUNTRY_LKUP WHERE ISO2=[Geo - Country (CC)]), '') [Legal Name Data - Name Detail Data - Country Reference ID]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Title Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Title Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Title Reference ID]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Title Descriptor]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Prefix Data - Salutation Reference ID]
				,ISNULL([Emp - First Name], '') [Legal Name Data - Name Detail Data - First Name]
				,'' [Legal Name Data - Name Detail Data - Middle Name]
				,ISNULL([Emp - Last Name], '') [Legal Name Data - Name Detail Data - Last Name]
				,'' [Legal Name Data - Name Detail Data - Secondary Last Name]
				,'' [Legal Name Data - Name Detail Data - Tertiary Last Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Local Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Local Script]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - First Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Middle Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Last Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - First Name 2]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Middle Name 2]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Last Name 2]
				,'' [Legal Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name 2]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Social Suffix Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference Descriptor]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID type]
				,'' [Legal Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID]
				,'' [Legal Name Data - Name Detail Data - Full Name for Singapore and Malaysia]
				,'' [Preferred Name Data - Name Detail Data - Formatted Name]
				,'' [Preferred Name Data - Name Detail Data - Reporting Name]
				,'' [Preferred Name Data - Name Detail Data - Country Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Country Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Country Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Title Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Title Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Title Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Title Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Prefix Data - Salutation Reference ID]
				,'' [Preferred Name Data - Name Detail Data - First Name]
				,'' [Preferred Name Data - Name Detail Data - Middle Name]
				,'' [Preferred Name Data - Name Detail Data - Last Name]
				,'' [Preferred Name Data - Name Detail Data - Secondary Last Name]
				,'' [Preferred Name Data - Name Detail Data - Tertiary Last Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Local Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Local Script]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - First Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Middle Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Last Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - First Name 2]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Middle Name 2]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Last Name 2]
				,'' [Preferred Name Data - Name Detail Data - Local Name Detail Data - Secondary Last Name 2]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Social Suffix Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Academic Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Hereditary Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Honorary Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Professional Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Religious Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference Descriptor]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID type]
				,'' [Preferred Name Data - Name Detail Data - Suffix Data - Royal Suffix Reference ID]
				,'' [Preferred Name Data - Name Detail Data - Full Name for Singapore and Malaysia]
				,'' [Gender Reference Descriptor]
				,'' [Gender Reference ID type]
				,'' [Gender Reference ID]
				,'' [Birth Date]
				,'' [Date of Death]
				,'' [Country of Birth Reference Descriptor]
				,'' [Country of Birth Reference ID type]
				,'' [Country of Birth Reference ID]
				,'' [Region of Birth Reference Descriptor]
				,'' [Region of Birth Reference ID type]
				,'' [Region of Birth Reference ID]
				,'' [Region of Birth Descriptor]
				,'' [City of Birth]
				,'' [City of Birth Reference Descriptor]
				,'' [City of Birth Reference ID type]
				,'' [City of Birth Reference ID]
				,'' [City of Birth Reference ID parent type]
				,'' [City of Birth Reference ID parent id]
				,'' [Marital Status Reference Descriptor]
				,'' [Marital Status Reference ID type]
				,'' [Marital Status Reference ID]
				,'' [Marital Status Reference ID parent type]
				,'' [Marital Status Reference ID parent id]
				,'' [Marital Status Date]
				,'' [Religion Reference Descriptor]
				,'' [Religion Reference ID type]
				,'' [Religion Reference ID]
				,'' [Hispanic or Latino]
				,'' [Primary Nationality Reference Descriptor]
				,'' [Primary Nationality Reference ID type]
				,'' [Primary Nationality Reference ID]
				,'' [Hukou Region Reference Descriptor]
				,'' [Hukou Region Reference ID type]
				,'' [Hukou Region Reference ID]
				,'' [Hukou Subregion Reference Descriptor]
				,'' [Hukou Subregion Reference ID type]
				,'' [Hukou Subregion Reference ID]
				,'' [Hukou Locality]
				,'' [Hukou Postal Code]
				,'' [Hukou Type Reference Descriptor]
				,'' [Hukou Type Reference ID type]
				,'' [Hukou Type Reference ID]
				,'' [Local Hukou]
				,'' [Native Region Reference Descriptor]
				,'' [Native Region Reference ID type]
				,'' [Native Region Reference ID]
				,'' [Native Region Descriptor]
				,'' [Personnel File Agency for Person]
				,'' [Last Medical Exam Date]
				,'' [Last Medical Exam Valid To]
				,'' [Medical Exam Notes]
				,'' [Blood Type Reference Descriptor]
				,'' [Blood Type Reference ID type]
				,'' [Blood Type Reference ID]
				,'' [Tobacco Use]
				,'' [Political Affiliation Reference Descriptor]
				,'' [Political Affiliation Reference ID type]
				,'' [Political Affiliation Reference ID]
				,'' [Social Benefits Locality Reference Descriptor]
				,'' [Social Benefits Locality Reference ID type]
				,'' [Social Benefits Locality Reference ID]
				,'' [Replace All]
				,'' [Applicant Entered Date]
				,'' [Applicant Comments]
				,'' [Eligible For Hire Reference Descriptor]
				,'' [Eligible For Hire Reference ID type]
				,'' [Eligible For Hire Reference ID]
				,'' [Eligible for Rehire Comments]
				,'' [Applicant Has Marked as No Show Reference Descriptor]
				,'' [Applicant Has Marked as No Show Reference ID type]
				,'' [Applicant Has Marked as No Show Reference ID]
				,'' [Applicant Source Reference Descriptor]
				,'' [Applicant Source Reference ID type]
				,'' [Applicant Source Reference ID]
	      FROM (SELECT DISTINCT [Emp - Personnel Number], 
		                        IIF([Geo - Country (CC)]='JP', ISNULL(A2.FNAMR, ''), [Emp - First Name]) [Emp - First Name], 
								IIF([Geo - Country (CC)]='JP', ISNULL(A2.LNAMR, ''), [Emp - Last Name]) [Emp - Last Name], [Geo - Country (CC)] 
		        FROM [P0_POSITION_MANAGEMENT] A1
				  LEFT JOIN P0_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR 
				WHERE BEGDA <= CAST(@which_date as Date) AND ENDDA >= CAST(@which_date as Date)) A6) A5
		SELECT * INTO WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT FROM @PRE_HIRES_APPLICANT

	    DECLARE @PRE_HIRES_APPLICANT_EMAIL_ADDRESS TABLE (
			[Applicant Key]               NVARCHAR(2000),
			[Email Address Data Key]      NVARCHAR(2000),
			[Delete]                      NVARCHAR(2000),
			[Do Not Replace All]          NVARCHAR(2000),
			[Email Address]               NVARCHAR(2000),
			[Email Comment]               NVARCHAR(2000),
			[Public]                      NVARCHAR(2000),
			[Primary]                     NVARCHAR(2000),
			[Type Reference Descriptor]   NVARCHAR(2000),
			[Type Reference ID type]      NVARCHAR(2000),
			[Type Reference ID]           NVARCHAR(2000),
			[Comments]                    NVARCHAR(2000),
			[Email Reference Descriptor]  NVARCHAR(2000),
			[Email Reference ID type]     NVARCHAR(2000),
			[Email Reference ID]          NVARCHAR(2000),
			[ID]                          NVARCHAR(2000),
			[Applicant ID]                NVARCHAR(2000)
		);

		INSERT INTO @PRE_HIRES_APPLICANT_EMAIL_ADDRESS
			SELECT [Applicant Key]
			    ,ROW_NUMBER() OVER(PARTITION BY [Applicant Key] ORDER BY [Applicant Key]) [Email Address Data Key]
				,[Delete]
				,[Do Not Replace All]
				,[Email Address]
				,[Email Comment]
				,[Public]
				,[Primary]
				,[Type Reference Descriptor]
				,[Type Reference ID type]
				,[Type Reference ID]
				,[Comments]
				,[Email Reference Descriptor]
				,[Email Reference ID type]
				,[Email Reference ID]
				,[ID]
				,[Applicant ID]
		    FROM (
				SELECT
					 A1.[Applicant Key] [Applicant Key]
					,'' [Email Address Data Key]
					,'' [Delete]
					,'' [Do Not Replace All]
					,IIF(ISNULL(A2.[Emp - Email Address], '')='', 'applicantid@default.novartis.com', A2.[Emp - Email Address]) [Email Address]
					,'' [Email Comment]
					,'TRUE' [Public]
					,'TRUE' [Primary]
					,'' [Type Reference Descriptor]
					,'Communication_Usage_Type_ID' [Type Reference ID type]
					,'WORK' [Type Reference ID]
					,'' [Comments]
					,'' [Email Reference Descriptor]
					,'' [Email Reference ID type]
					,'' [Email Reference ID]
					,'' [ID]
					,A1.[Applicant ID]
				FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT A1 
					LEFT JOIN (
					     SELECT [Emp - Personnel Number], [Emp - HRCGLPers. id], [Emp - Email Address], 'Email ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - Email Address] IS NOT NULL
					) A2 ON A1.[Applicant ID]=('A'+A2.[Emp - Personnel Number])
		       ) A3

		/***** Pre Hires Email Address Validation Query Starts *****/
		SET @SQL='drop table if exists NOVARTIS_DATA_MIGRATION_PRE_HIRES_VALIDATION;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	    SELECT * INTO NOVARTIS_DATA_MIGRATION_PRE_HIRES_VALIDATION  FROM (
			SELECT @which_wavestage     [Build Number]
		          ,@which_report        [Report Name]
				  ,A1.[Applicant ID]    [Employee ID]
				  ,A3.[Country]         [Country Name]
				  ,A3.[Country Code]    [Country ISO3 Code]
				  ,A2.[WD_EMP_TYPE]     [Employee Type]
				  ,A2.[Emp - Group]     [Employee Group]
				  ,'Email Address'      [Summary]
				  ,(IIF(ISNULL([Email Address], '')='applicantid@default.novartis.com', [Applicant ID]+'( '+[Applicant Key]+' ) is missing email address', '')) ErrorText
			FROM @PRE_HIRES_APPLICANT_EMAIL_ADDRESS A1 
			     LEFT JOIN P0_POSITION_MANAGEMENT A2 ON A2.[Emp - Personnel Number]=SUBSTRING([Applicant ID], 2, LEN([Applicant ID]))
				 LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A2.[geo - country (CC)]=A3.[Country2 Code]
				 WHERE A2.[emp - personnel number] IS NOT NULL
		    UNION ALL
			SELECT @which_wavestage     [Build Number]
		          ,@which_report        [Report Name]
				  ,A1.[Applicant ID]    [Employee ID]
				  ,A3.[Country]         [Country Name]
				  ,A3.[Country Code]    [Country ISO3 Code]
				  ,A2.[WD_EMP_TYPE]     [Employee Type]
				  ,A2.[Emp - Group]     [Employee Group]
				  ,'Missing Personnel Number'      [Summary]
				  ,(IIF(ISNULL([Emp - Personnel Number], '')='', [Applicant ID]+'( '+[Applicant Key]+' ) employee personnel number is not a contigent worker or hire worker', '')) ErrorText
			FROM @PRE_HIRES_APPLICANT A1 
			     LEFT JOIN P0_POSITION_MANAGEMENT A2 ON A2.[Emp - Personnel Number]=SUBSTRING([Applicant ID], 2, LEN([Applicant ID]))
				 LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A2.[geo - country (CC)]=A3.[Country2 Code]
				 WHERE A2.[emp - personnel number] IS NOT NULL				 
	    ) c WHERE ErrorText <> '';

		/***** Pre Hires Email Address(Novartis Migration) Table Query *****/
        --SELECT * FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS WHERE [Email Address]='applicantid@default.novartis.com'
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SELECT [Applicant Key]
			  ,[Email Address Data Key]
			  ,[Delete]
			  ,[Do Not Replace All]
			  ,[Email Address]
		      ,[Email Comment]
			  ,[Public]
			  ,[Primary]
			  ,[Type Reference Descriptor]
			  ,[Type Reference ID type]
			  ,[Type Reference ID]
			  ,[Comments]
			  ,[Email Reference Descriptor]
			  ,[Email Reference ID type]
			  ,[Email Reference ID]
			  ,[ID] 
		INTO WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS 
		FROM @PRE_HIRES_APPLICANT_EMAIL_ADDRESS 

		SELECT * FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT ORDER BY CAST([Applicant Key] AS INT)
		SELECT * FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS ORDER BY CAST([Applicant Key] AS INT)
		SELECT * FROM NOVARTIS_DATA_MIGRATION_PRE_HIRES_VALIDATION ORDER BY [Employee ID]
		--SELECT * FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE Report=@which_report AND Wave=@which_wavestage

	    -- Removing Email ID from the DGW which is NULL or Empty
		DELETE FROM WD_HR_TR_AUTOMATED_PRE_HIRES_APPLICANT_EMAIL_ADDRESS WHERE ISNULL([Email Address], '')=''

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
