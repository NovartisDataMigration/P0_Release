USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_CURRENT]    Script Date: 3/21/2021 7:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_CURRENT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_CURRENT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_CURRENT]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Other ID(Novartis Migration)  ******/
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_CURRENT 'P0', 'Other ID', '2021-03-10'
--SELECT * FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID ORDER BY CAST([Change Other IDs Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID ORDER BY CAST([Change Other IDs Key] AS INT)
--SELECT * FROM NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION ORDER BY [Employee ID]

--SELECT * FROM [WAVE_NM_POSITION_MANAGEMENT_INITIAL]
--SELECT DISTINCT [Person Reference ID type] FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID WHERE [Custom ID Shared Reference ID]='Home_Persno' ORDER BY CAST([Change Other IDs Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID WHERE [Custom ID Shared Reference ID]='Host_Persno' ORDER BY CAST([Change Other IDs Key] AS INT)


	BEGIN TRY 
		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_CHANGE_OTHERID';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		DECLARE @CHANGE_OTHERID TABLE (
           [Change Other IDs Key]                   NVARCHAR(2000),
           [Auto Complete]                          NVARCHAR(2000),
           [Run Now]                                NVARCHAR(2000),
           [Comment]                                NVARCHAR(2000),
           [Worker Reference Descriptor]            NVARCHAR(2000),
           [Worker Reference ID type]               NVARCHAR(2000),
           [Worker Reference ID]                    NVARCHAR(2000),
           [Person Reference Descriptor]            NVARCHAR(2000),
           [Person Reference ID type]               NVARCHAR(2000),
           [Person Reference ID]                    NVARCHAR(2000),
           [Universal ID Reference Descriptor]      NVARCHAR(2000),
           [Universal ID Reference ID type]         NVARCHAR(2000),
           [Universal ID Reference ID]              NVARCHAR(2000),
           [Replace All]                            NVARCHAR(2000)
		)

		INSERT INTO @CHANGE_OTHERID
		    SELECT ROW_NUMBER() OVER(ORDER BY [Person Reference ID]) [Change Other IDs Key], * FROM (
			   SELECT 
				   'TRUE' [Auto Complete]
				  ,'TRUE' [Run Now]
				  ,'' [Comment]
				  ,'' [Worker Reference Descriptor]
				  ,'' [Worker Reference ID type]
				  ,'' [Worker Reference ID]
				  ,'' [Person Reference Descriptor]
				  ,IIF([Emp - Group] NOT IN ('7', '9'), 'Employee_ID', 'Contingent_Worker_ID') [Person Reference ID type]
				  ,[emp - personnel number] [Person Reference ID]
				  ,'' [Universal ID Reference Descriptor]
				  ,'' [Universal ID Reference ID type]
				  ,'' [Universal ID Reference ID]
				  ,'' [Replace All]
	      FROM (SELECT DISTINCT [emp - personnel number], [Emp - Group] FROM [P0_POSITION_MANAGEMENT]) A6) A5
		SELECT * INTO WD_HR_TR_AUTOMATED_CHANGE_OTHERID FROM @CHANGE_OTHERID


	    DECLARE @OTHERID_CUSTOM_ID TABLE (
           [Change Other IDs Key]                   NVARCHAR(2000),
           [Custom ID Key]                          NVARCHAR(2000),
           [Delete]                                 NVARCHAR(2000),
           [Custom ID Reference Descriptor]         NVARCHAR(2000),
           [Custom ID Reference ID type]            NVARCHAR(2000),
           [Custom ID Reference ID]                 NVARCHAR(2000),
           [ID]                                     NVARCHAR(2000),
           [Issued Date]                            NVARCHAR(2000),
           [Expiration Date]                        NVARCHAR(2000),
           [Custom Description]                     NVARCHAR(2000),
           [ID Type Reference Descriptor]           NVARCHAR(2000),
           [ID Type Reference ID type]              NVARCHAR(2000),
           [ID Type Reference ID]                   NVARCHAR(2000),
           [Organization ID Reference Descriptor]   NVARCHAR(2000),
           [Organization ID Reference ID type]      NVARCHAR(2000),
           [Organization ID Reference ID]           NVARCHAR(2000),
           [Custom ID Shared Reference Descriptor]  NVARCHAR(2000),
           [Custom ID Shared Reference ID type]     NVARCHAR(2000),
           [Custom ID Shared Reference ID]          NVARCHAR(2000),
		   [Person Reference ID]                    NVARCHAR(2000)
		);

		INSERT INTO @OTHERID_CUSTOM_ID
			SELECT [Change Other IDs Key]
			      ,ROW_NUMBER() OVER(PARTITION BY [Change Other IDs Key] ORDER BY [Change Other IDs Key]) [Custom ID Key]
                  ,[Delete]
                  ,[Custom ID Reference Descriptor]
                  ,[Custom ID Reference ID type]
                  ,[Custom ID Reference ID]
                  ,[ID]
                  ,[Issued Date]
                  ,[Expiration Date]
                  ,[Custom Description]
                  ,[ID Type Reference Descriptor]
                  ,[ID Type Reference ID type]
                  ,[ID Type Reference ID]
                  ,[Organization ID Reference Descriptor]
                  ,[Organization ID Reference ID type]
                  ,[Organization ID Reference ID]
                  ,[Custom ID Shared Reference Descriptor]
                  ,[Custom ID Shared Reference ID type]
                  ,[Custom ID Shared Reference ID]
				  ,[Person Reference ID]
		    FROM (
				SELECT
					 A1.[Change Other IDs Key]
					,''  [Delete]
					,''  [Custom ID Reference Descriptor]
					,''  [Custom ID Reference ID type]
					,''  [Custom ID Reference ID]
					,A2.[ID]  [ID]
					,''  [Issued Date]
					,''  [Expiration Date]
					,''  [Custom Description]
					,''  [ID Type Reference Descriptor]
					,'Custom_ID_Type_ID'  [ID Type Reference ID type]
					,[Type]  [ID Type Reference ID]
					,''  [Organization ID Reference Descriptor]
					,''  [Organization ID Reference ID type]
					,''  [Organization ID Reference ID]
					,''  [Custom ID Shared Reference Descriptor]
					,''  [Custom ID Shared Reference ID type]
					,''  [Custom ID Shared Reference ID]
					,[Person Reference ID]
				FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID A1 
					LEFT JOIN (
					     SELECT [Emp - Personnel Number], [Emp - GDDB ID] AS ID, 'GDDB_ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - GDDB ID] IS NOT NULL
						 UNION ALL
						 SELECT [Emp - Personnel Number], [Emp - FirstPort ID] AS ID, 'FirstPort_ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - FirstPort ID] IS NOT NULL
						 UNION ALL
						 SELECT [Emp - Personnel Number], [Emp - HRCGLPers. id] AS ID, 'Global_Person_ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - HRCGLPers. id] IS NOT NULL
						 UNION ALL
						 SELECT A1.[Emp - Personnel Number], A2.[Emp - Personnel Number] AS ID, 'Home_Persno' [Type] FROM [P0_POSITION_MANAGEMENT] A1 
						        LEFT JOIN (SELECT [Emp - Personnel Number], [Emp - HRCGLPers. id] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - Group]='3') A2
								     ON A1.[Emp - HRCGLPers. id] = A2.[Emp - HRCGLPers. id]
						    WHERE A1.[Emp - Group]='4'
						 UNION ALL
						 SELECT A1.[Emp - Personnel Number], A2.[Emp - Personnel Number] AS ID, 'Host_Persno' [Type] FROM [P0_POSITION_MANAGEMENT] A1 
						        LEFT JOIN (SELECT [Emp - Personnel Number], [Emp - HRCGLPers. id] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - Group]='4') A2
							         ON A1.[Emp - HRCGLPers. id] = A2.[Emp - HRCGLPers. id]
						    WHERE A1.[Emp - Group]='3'
					) A2 ON A1.[Person Reference ID]=A2.[Emp - Personnel Number]
		       ) A3

		/***** Other ID custom ID Validation Query Starts *****/
		SET @SQL='drop table if exists NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	    SELECT * INTO NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION FROM (
			SELECT @which_wavestage          [Build Number]
		          ,@which_report             [Report Name]
				  ,[Person Reference ID]     [Employee ID]
				  ,A3.[Country]              [Country Name]
				  ,A3.[Country Code]         [Country ISO3 Code]
				  ,A2.[WD_EMP_TYPE]          [Employee Type]
				  ,A2.[Emp - Group]          [Employee Group]
				  ,'Missing Custom ID'       [Summary]
                  ,(IIF(ISNULL([ID], '')='',[Person Reference ID]+'( '+[Change Other IDs Key]+', '+[Custom ID Key]+' ) missing '+[Custom ID Shared Reference ID], '')) ErrorText
			FROM @OTHERID_CUSTOM_ID  A1 
			     LEFT JOIN P0_POSITION_MANAGEMENT A2 ON A2.[Emp - Personnel Number]=[Person Reference ID]
				 LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A2.[geo - country (CC)]=A3.[Country2 Code]
				 WHERE A2.[emp - personnel number] IS NOT NULL				 
	        ) c WHERE ErrorText <> '';

		/***** Other ID(Novartis Migration) Automtion Query *****/
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SELECT * INTO WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID FROM @OTHERID_CUSTOM_ID 

		SELECT * FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID ORDER BY CAST([Change Other IDs Key] AS INT)
		SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID ORDER BY CAST([Change Other IDs Key] AS INT) 
		SELECT * FROM NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION ORDER BY [Employee ID]

		-- Removing ID from the DGW which is NULL or Empty
		DELETE FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID WHERE ISNULL([ID], '')=''


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
