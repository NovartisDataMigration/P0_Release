-- Verify that the stored procedure does not already exist.  
USE PROD_DATACLEAN
GO

IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_JOB_PROFILE_EDIT_POSITION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_JOB_PROFILE_EDIT_POSITION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_JOB_PROFILE_EDIT_POSITION]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_JOB_PROFILE_EDIT_POSITION 'P0', 'Job Profilev Edit Position', '2021-03-10'
--SELECT * FROM WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION ORDER BY [Spreadsheet Key*]

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS WAVE_NM_PA0001;
	                                         DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION;';

	SELECT DISTINCT PERNR, [STELL], A3.[GLOBAL JOB CODE] [GLOBAL JOB CODE(Local)], A4.[GLOBAL JOB CODE] [GLOBAL JOB CODE(Global)] INTO WAVE_NM_PA0001 FROM P0_PA0001 A2 
	   LEFT JOIN (SELECT DISTINCT [LOCAL JOB CODE], [GLOBAL JOB CODE] FROM P0_JOB_FAMILY) A3 ON A2.[STELL]=A3.[LOCAL JOB CODE]
	   LEFT JOIN (SELECT DISTINCT [LOCAL JOB CODE], [GLOBAL JOB CODE] FROM P0_JOB_FAMILY) A4 ON A2.[STELL]=A4.[GLOBAL JOB CODE]
	WHERE ENDDA >= CAST('2021-03-10' AS DATE) AND BEGDA <= CAST('2021-03-10' AS DATE)

	SELECT 
		 ROW_NUMBER() over(order by [emp - personnel number] ) [Spreadsheet Key*]
		,[emp - personnel number] [Worker]
		,isnull(wd_positionid,'') [Position]
		--,IIF(ISNULL([wd_latest_hire_Date], '')='', '', CONVERT(varchar(20), CAST([wd_latest_hire_Date] as date), 23)) [Effective Date*]
		,'2021-03-10' [Effective Date*]
		,'Edit_Position_Conversion' [Position Change Reason]
		,isnull(wd_positionid,'') [Position ID]
		,IIF(ISNULL([EMP - GROUP], '') NOT IN ('7', '9'), ISNULL([wd_emp_type], ''), '') [Employee Type]
		,IIF(ISNULL([EMP - GROUP], '') IN ('7', '9'), ISNULL([wd_emp_type], ''), '') [Contingent Worker Type]
		,IIF(ISNULL([GLOBAL JOB CODE(Local)], '')='', ISNULL([GLOBAL JOB CODE(Global)], ''), ISNULL([GLOBAL JOB CODE(Local)], '')) [Job Profile]
		,'' [Position Title]
		,'' [Business Title]
		,ISNULL([WD_location_id], '') [Location]
		,'' [Work Space]
		,'Full_Time' [Position Time Type]
		,'' [Work Shift]
		,'' [Work Hours Profile]
		,'40' [Default Hours]
		,'40' [Scheduled Hours]
		,'' [Working Time Frequency]
		,'' [Working Time Unit]
		,'' [Working Time Value]
		,'' [Specify Paid FTE]
		,'' [Paid FTE]
		,'' [Specify Working FTE]
		,'' [Working FTE]
		,ISNULL(wd_pay_type_id, '') [Pay Rate Type]
		,'' [Additional Job Classifications+]
		,'' [Company Insider Type+]
		,'' [Annual Work Period]
		,'' [Disbursement Plan Period]
		,'' [Work Study]
		,'' [Workers  Compensation Code Override]
		,'' [System ID]
		,'' [External ID*]
		,'' [End Employment Date]
		,'' [Contract End Date]
		,'' [Contract Pay Rate]
		,'' [Currency]
		,'' [Frequency]
		,'' [Contract Assignment Details]
		,'' [Exclude from Headcount]
		,'' [Expected Assignment End Date]
		,'' [Assignment Type]
	INTO WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION
	FROM P0_POSITION_MANAGEMENT A1
		 LEFT JOIN WAVE_NM_PA0001 A3 ON A1.[emp - personnel number] = A3.PERNR;
	DELETE FROM WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION WHERE ISNULL([Job Profile], '')=''
END
GO


