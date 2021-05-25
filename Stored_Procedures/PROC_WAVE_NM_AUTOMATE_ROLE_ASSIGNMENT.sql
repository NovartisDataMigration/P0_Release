USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_ROLE_ASSIGNMENT]    Script Date: 3/22/2021 5:55:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_ROLE_ASSIGNMENT]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN

--EXECUTE [dbo].[PROC_WAVE_NM_AUTOMATE_ROLE_ASSIGNMENT] 'P0', 'Role Assignment', '2021-03-10'
--SELECT * FROM P0_ROLE_ASSIGNMENT_SOURCE ORDER BY CAST([ROLE_ASSIGNER_KEY] AS INT), CAST([ROLE_ASSIGNMENT_DATA_KEY] AS INT), CAST([ROLE_ASSIGNEE_REFERENCEE_KEY] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_ROLE_ASSIGNER ORDER BY CAST([Role Assigner Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_ROLE_ASSIGNMENT_DATA ORDER BY CAST([Role Assigner Key] AS INT), CAST([Role Assignment Data Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_ROLE_ASSIGNEE_REFERENCE ORDER BY CAST([Role Assigner Key] AS INT), CAST([Role Assignment Data Key] AS INT), CAST([Role Assignee Reference Key] AS INT)

--select * from p0_SUP_ORG
--SELECT DISTINCT SUP_ORG FROM P0_SUP_ORG
--SELECT DISTINCT superior_position_id FROM P0_SUP_ORG

	/****** Script to automate Role Assignment(Novartis Migration)  ******/
	BEGIN TRY 
		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS P0_ROLE_ASSIGNMENT_SOURCE;
		                               DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_ROLE_ASSIGNER;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_ROLE_ASSIGNMENT_DATA;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_ROLE_ASSIGNEE_REFERENCE;
									   ';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		

		SELECT DENSE_RANK() OVER(ORDER BY SUP_ORG) [ROLE_ASSIGNER_KEY]
		       ,'1' [ROLE_ASSIGNMENT_DATA_KEY]
			   ,'1' [ROLE_ASSIGNEE_REFERENCEE_KEY]
			   ,SUP_ORG
			   ,SUPERIOR_POSITION_ID
		INTO P0_ROLE_ASSIGNMENT_SOURCE
		FROM (SELECT DISTINCT RTRIM(LTRIM(ISNULL(SUP_ORG, ''))) SUP_ORG, RTRIM(LTRIM(ISNULL(SUPERIOR_POSITION_ID, ''))) SUPERIOR_POSITION_ID FROM P0_SUP_ORG) A1

    	SELECT 
		       [ROLE_ASSIGNER_KEY] [Role Assigner Key]
			  ,'1900-01-01' [Effective Date]
			  ,'' [Effective Timezone Reference Descriptor]
			  ,'' [Effective Timezone Reference ID type]
			  ,'' [Effective Timezone Reference ID]
			  ,'' [Role Assigner Reference Descriptor]
			  ,'Organization_Reference_ID'  [Role Assigner Reference ID type]
			  ,SUP_ORG  [Role Assigner Reference ID]
			  ,'' [Role Assigner Reference ID parent type]
			  ,'' [Role Assigner Reference ID parent id]
        INTO WD_HR_TR_AUTOMATED_ROLE_ASSIGNER
		FROM P0_ROLE_ASSIGNMENT_SOURCE

		SELECT
		     [ROLE_ASSIGNER_KEY] [Role Assigner Key]
			,[ROLE_ASSIGNMENT_DATA_KEY] [Role Assignment Data Key]
			,'' [Delete]
			,'' [Update]
			,'' [Organization Role Reference Descriptor]
			,'Organization_Role_ID' [Organization Role Reference ID type]
			,'Manager' [Organization Role Reference ID]
        INTO WD_HR_TR_AUTOMATED_ROLE_ASSIGNMENT_DATA
		FROM P0_ROLE_ASSIGNMENT_SOURCE

		SELECT
		     [ROLE_ASSIGNER_KEY] [Role Assigner Key]
		    ,[ROLE_ASSIGNMENT_DATA_KEY] [Role Assignment Data Key]
			,[ROLE_ASSIGNEE_REFERENCEE_KEY] [Role Assignee Reference Key]
			,'' [Descriptor]
			,'Position_ID' [ID type]
			,IIF((SUBSTRING(SUPERIOR_POSITION_ID, 1, 2)='P-' OR SUPERIOR_POSITION_ID=''), SUPERIOR_POSITION_ID, 'P-'+SUPERIOR_POSITION_ID) [ID]
        INTO WD_HR_TR_AUTOMATED_ROLE_ASSIGNEE_REFERENCE
		FROM P0_ROLE_ASSIGNMENT_SOURCE

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
