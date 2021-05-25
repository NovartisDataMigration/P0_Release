USE PROD_DATACLEAN
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_JOBPROFILE', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_JOBPROFILE;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_JOBPROFILE]
    @which_wavestage      AS NVARCHAR(50),
	@which_report         AS NVARCHAR(500),
	@which_date           AS NVARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_JOBPROFILE 'P0', 'Job Profile', '2021-03-10'
--SELECT * FROM WD_HR_TR_JobProfile ORDER BY [Spreadsheet Key*2]
--SELECT * FROM WD_HR_TR_JobKeyCode ORDER BY [JobProfile]
--SELECT * FROM WD_HR_TR_JobProfile WHERE SUBSTRING([Job Code5], 1, 1) <> '1' ORDER BY [Spreadsheet Key*2]
--SELECT * FROM P0_HRP1000 WHERE OBJID IN (SELECT Fields1 FROM WD_HR_TR_JobProfile WHERE SUBSTRING([Job Code5], 1, 1) <> '1') ORDER BY OBJID

	DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_HRP1000;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT DISTINCT * INTO WAVE_NM_HRP1000 FROM '+@which_wavestage+'_HRP1000 WHERE CAST(endda AS DATE) >=CAST('''+@which_date+''' as date)	and CAST(begda AS DATE) <= CAST('''+@which_date+''' as date);;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_HRP1000 add SHOW_LANGU nvarchar(255);';
	UPDATE WAVE_NM_HRP1000 SET SHOW_LANGU=IIF(LANGU='E', 'E', 'F');

	--SELECT * FROM (
	--SELECT  *, ROW_NUMBER() OVER( PARTITION BY OBJID, MC_SHORT ORDER BY OBJID, MC_SHORT, SHOW_LANGU) RNUM FROM WAVE_NM_HRP1000
	--) A1 WHERE OBJID IN (SELECT Fields1 FROM WD_HR_TR_JobProfile WHERE SUBSTRING([Job Code5], 1, 1) <> '1') ORDER BY OBJID

	/* Removing duplicate rows */
	WITH cte AS (
		SELECT  *, ROW_NUMBER() OVER( PARTITION BY OBJID, MC_SHORT ORDER BY OBJID, MC_SHORT, SHOW_LANGU) RNUM FROM WAVE_NM_HRP1000
	) 
	DELETE FROM cte WHERE [RNUM] > 1;
	--DELETE FROM [P0_HRP1000] WHERE BEGDA='Start Date'

	/* Populating data in final table */
    SET @SQL='drop table if exists WD_HR_TR_JobProfile;
	          drop table if exists WD_HR_TR_JobKeyCode';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SELECT 
		 CAST(ROW_NUMBER() OVER(PARTITION BY MC_SHORT ORDER BY OBJID) AS VARCHAR(10))+MC_SHORT [Fields1]
		,ROW_NUMBER() OVER(ORDER BY OBJID) [Spreadsheet Key*2]
		,'' [Add Only3]
		,'' [Job Profile4]
		--,CAST(ROW_NUMBER() OVER(PARTITION BY MC_SHORT ORDER BY OBJID) AS VARCHAR(10))+MC_SHORT [Job Code5]
		,ISNULL(OBJID, '') [Job Code5]
		,CONVERT(VARCHAR(20), CAST(BEGDA AS DATE), 120) [Effective Date6]
		,'' [Inactive7]
		,ISNULL(MC_STEXT, '') [Job Title8]
		,'' [Include Job Code in Name9]
		,'' [Job Profile Private Title10]
		,'' [Job Profile Summary11]
		,'' [Job Description12]
		,'' [Additional Job Description13]
		,'' [Work Shift Required14]
		,'' [Public Job15]
		,'' [Management Level16]
		,'' [Job Category17]
		,'' [Job Level18]
		,'' [Row ID*19]
		,'' [Delete20]
		,'' [Job Family*21]
		,'' [Row ID*22]
		,'' [Delete23]
		,'' [Company Insider Type*24]
		,'' [Referral Payment Plan25]
		,'' [Critical Job26]
		,'' [Difficulty to Fill27]
		,'' [Restrict to Country+28]
		,'' [Row ID*29]
		,'' [Delete30]
		,'' [Job Classifications*31]
		,'' [Row ID*32]
		,'' [Delete33]
		,'' [Country*34]
		,'' [Pay Rate Type35]
		,'' [Row ID*36]
		,'' [Delete37]
		,'' [Location Context*38]
		,'' [ISO 3166 1 Alpha 2 Code39]
		,'' [Job Exempt40]
		,'' [Row ID*41]
		,'' [Workers Compensation Code42]
		,'' [Delete43]
		,'' [Row ID*44]
		,'' [Responsibility Description*45]
		,'' [Required46]
		,'' [Delete47]
		,'' [Row ID*48]
		,'' [Worker Experience*49]
		,'' [Work Experience Rating50]
		,'' [Required51]
		,'' [Delete52]
		,'' [Row ID*53]
		,'' [Degree54]
		,'' [Field Of Study55]
		,'' [Required56]
		,'' [Delete57]
		,'' [Row ID*58]
		,'' [Language*59]
		,'' [Row ID*60]
		,'' [Language Ability Type*61]
		,'' [Language Proficiency62]
		,'' [Required63]
		,'' [Delete64]
		,'' [Row ID*65]
		,'' [Competency*66]
		,'' [Proficiency Rating67]
		,'' [Required68]
		,'' [Delete69]
		,'' [Row ID*70]
		,'' [Country71]
		,'' [Certification72]
		,'' [Name73]
		,'' [Issuer74]
		,'' [Required75]
		,'' [Row ID*76]
		,'' [Specialty77]
		,'' [Subspecialty+78]
		,'' [Delete79]
		,'' [Row ID*80]
		,'' [Training Name81]
		,'' [Description82]
		,'' [Training Type83]
		,'' [Required84]
		,'' [Delete85]
		,'' [Row ID*86]
		,'' [Skill87]
		,'' [Name88]
		,'' [Required89]
		,'' [Row ID*90]
		,'' [Field91]
		,'' [Integration Document Name92]
		,'' [Value93]
		,'' [Compensation Grade94]
		,'' [Compensation Grade Profile+95]
		,'' [Requirement Option96]
		,'' [Union+97]
		,'' [Requirement Option98]
		,'' [Allowed Student Award Sources+99]
      INTO WD_HR_TR_JobProfile
	  FROM WAVE_NM_HRP1000 
	  WHERE PLVAR='01' AND OTYPE='C';
    
	/* Job Key Code DGW */
	SELECT 
		 ISNULL(OBJID, '') [JobProfile]
		,CAST(ROW_NUMBER() OVER(PARTITION BY MC_SHORT ORDER BY OBJID) AS VARCHAR(10))+MC_SHORT [JobKeyCode] 
      INTO WD_HR_TR_JobKeyCode
	  FROM WAVE_NM_HRP1000 
	  WHERE PLVAR='01' AND OTYPE='C';

	  --SELECT * FROM WAVE_NM_HRP1000 WHERE PLVAR='01' AND OTYPE='C' AND MC_SHORT='CABSPL01XXAX'
	  --SELECT * FROM WAVE_NM_HRP1000 WHERE PLVAR='01' AND OTYPE='C' AND OBJID='30048654'
END
GO