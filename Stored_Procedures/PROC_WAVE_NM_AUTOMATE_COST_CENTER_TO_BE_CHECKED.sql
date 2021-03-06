USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_COST_CENTER]    Script Date: 4/13/2021 3:47:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_COST_CENTER]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate COST_CENTER(Novartis Migration)  ******/
	--EXEC [PROC_WAVE_NM_AUTOMATE_COST_CENTER] 'P0', 'Cost Center', '2021-03-10'

	BEGIN TRY 
		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_COST_CENTER;		                               
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY_FLAT;
									   DROP TABLE IF EXISTS DATA_SOURCE_COST_CENTER;		                               
									   ';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		--Data Source query for Cost Center
		--INSERT INTO [P0_CSKS_DATA] (COAR, [Cost Ctr], [to], [Valid From], [Language]) VALUES('', 'unmatched-CC', '9999-12-31', '1900-01-01','E')
		--INSERT INTO [P0_CSKT_Cost_Center_Text] (COAR, [Cost Ctr], [Description], [to], [Language]) VALUES('', 'unmatched-CC', 'Missing Cost Center', '31-12-9999', 'E')
		--SELECT * FROM P0_CSKT_Cost_Center_Text WHERE [Cost Ctr]='unmatched-CC'
		--UPDATE P0_CSKT_Cost_Center_Text SET Description='Missing Cost Center' WHERE [Cost Ctr]='unmatched-CC'
		--UPDATE P0_CSKT_Cost_Center_Text SET [To]='31-12-9999' WHERE [Cost Ctr]='0080009023'
		--SELECT * FROM P0_CSKS_DATA WHERE [Cost Ctr]='unmatched-CC'
		--DELETE FROM P0_CSKS_DATA WHERE [Cost Ctr]='unmatched-CC'
		--SELECT * FROM DATA_SOURCE_COST_CENTER WHERE [Cost Ctr]='unmatched-CC'
		SELECT DISTINCT * INTO DATA_SOURCE_COST_CENTER FROM 
		  (SELECT * FROM [P0_CSKS_DATA] WHERE [TO] >= CAST(@which_date AS DATE) AND [Valid From] <= CAST(@which_date AS DATE)) A1 
			 LEFT JOIN      
		  (SELECT [LANGUAGE] AS TXT_LANGUAGE, [COAr] AS TXT_COAr, [Cost Ctr] AS TXT_CostCtr, ISNULL([Description], '') AS TXT_Description  FROM (
			  SELECT [LANGUAGE],
					 [COAr],
					 [Cost Ctr], 
					 [Description], 
					 TRY_CONVERT(date, CONVERT(VARCHAR(30), CONVERT(Date, [TO], 103), 102)) [TO], 
					 ROW_NUMBER() OVER(PARTITION BY [Cost Ctr], [COAr] ORDER BY TRY_CONVERT(date, CONVERT(VARCHAR(30), CONVERT(Date, [TO], 103), 102)) DESC, CHECK_LANGUAGE ASC) RNUM
				 FROM (SELECT *, (CASE 
						   WHEN [Language]='E' THEN '0'
						   ELSE [Language]
						 END) AS CHECK_LANGUAGE FROM [P0_CSKT_Cost_Center_Text] WHERE [LANGUAGE]='E'
					  ) A2 WHERE DESCRIPTION IS NOT NULL
			) A10 WHERE RNUM=1
		) A2 ON A1.[Cost Ctr]=A2.[TXT_CostCtr] AND A1.[COAr]=A2.[TXT_COAr] --AND A1.[Language]=A2.[Language]
		ORDER BY A1.[Cost Ctr], A1.[COAr]
		
		DECLARE @COST_CENTER TABLE(
			[Cost Center Key]                                       NVARCHAR(2000),
			[Add Only]                                              NVARCHAR(2000),
			[Cost Center Reference Descriptor]                      NVARCHAR(2000),
			[Cost Center Reference ID type]                         NVARCHAR(2000),
			[Cost Center Reference ID]                              NVARCHAR(2000),
			[Effective Date]                                        NVARCHAR(2000),
			[ID]                                                    NVARCHAR(2000),
			[Include Organization ID in Name]                       NVARCHAR(2000),
			[Organization Name]										NVARCHAR(2000),
			[Phonetic Name]											NVARCHAR(2000),
			[Organization Code]                                     NVARCHAR(2000),
			[Include Organization Code in Name]                     NVARCHAR(2000),
			[Organization Active]                                   NVARCHAR(2000),
			[Availability Date]                                     NVARCHAR(2000),
			[Organization Visibility Reference Descriptor]          NVARCHAR(2000),
			[Organization Visibility Reference ID type]             NVARCHAR(2000),
			[Organization Visibility Reference ID]                  NVARCHAR(2000),
			[External URL Reference Descriptor]                     NVARCHAR(2000),
			[External URL Reference ID type]                        NVARCHAR(2000),
			[External URL Reference ID]                             NVARCHAR(2000),
			[Organization Subtype Reference Descriptor]             NVARCHAR(2000),
			[Organization Subtype Reference ID type]                NVARCHAR(2000),
			[Organization Subtype Reference ID]                     NVARCHAR(2000),
			[Replace All]											NVARCHAR(2000)
			)

		INSERT INTO @COST_CENTER
			SELECT DENSE_RANK() OVER(ORDER BY [ID]) [Cost Center Key], * FROM (
			    SELECT 
					''[Add Only]
					,''[Cost Center Reference Descriptor]
					,''[Cost Center Reference ID type]
					,''[Cost Center Reference ID]
					,[Valid From] [Effective Date]
					,[Cost Ctr] [ID]
					,''[Include Organization ID in Name]
					,[TXT_Description] [Organization Name]
					,''[Phonetic Name]
					,[Cost Ctr] [Organization Code]
					,IIF(ISNULL([TXT_Description], '') = '', 'TRUE','FALSE') [Include Organization Code in Name]
					,'TRUE'[Organization Active]
					,[Valid From] [Availability Date]
					,''[Organization Visibility Reference Descriptor]
					,'WID'[Organization Visibility Reference ID type]
					,'9c875610c4fc496499e39741b6541dbc'[Organization Visibility Reference ID]
					,''[External URL Reference Descriptor]
					,''[External URL Reference ID type]
					,''[External URL Reference ID]
					,''[Organization Subtype Reference Descriptor]
					,'Organization_Subtype_ID'[Organization Subtype Reference ID type]
					,'Cost_Center'[Organization Subtype Reference ID]
					,''[Replace All]
				FROM (SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY [Cost Ctr] ORDER BY [Cost Ctr]) RNUM FROM DATA_SOURCE_COST_CENTER) A1 WHERE RNUM=1) A10
			) A1
		
		SELECT * into WD_HR_TR_AUTOMATED_COST_CENTER FROM @COST_CENTER
		--SELECT * FROM WD_HR_TR_AUTOMATED_COST_CENTER WHERE [ID]='unmatched-CC'
		--SELECT Top 10 * FROM WD_HR_TR_AUTOMATED_COST_CENTER

		
		DECLARE @COST_CENTER_HIERARCHY TABLE(
			[Cost Center Hierarchy Key]							   NVARCHAR(2000),
			[Add Only]											   NVARCHAR(2000),
			[Cost Center Hierarchy Reference Descriptor]		   NVARCHAR(2000),	
			[Cost Center Hierarchy Reference ID type]			   NVARCHAR(2000),
			[Cost Center Hierarchy Reference ID]				   NVARCHAR(2000),
			[Effective Date]									   NVARCHAR(2000),
			[ID]												   NVARCHAR(2000),
			[Include Organization ID in Name]					   NVARCHAR(2000),
			[Organization Name]								       NVARCHAR(2000),
			[Phonetic Name]										   NVARCHAR(2000),
			[Organization Code]									   NVARCHAR(2000),
			[Include Organization Code in Name]					   NVARCHAR(2000),
			[Organization Active]								   NVARCHAR(2000),
			[Availability Date]									   NVARCHAR(2000),
			[Organization Visibility Reference Descriptor]		   NVARCHAR(2000),
			[Organization Visibility Reference ID type]			   NVARCHAR(2000),
			[Organization Visibility Reference ID]				   NVARCHAR(2000),
			[External URL Reference Descriptor]					   NVARCHAR(2000),
			[External URL Reference ID type]					   NVARCHAR(2000),
			[External URL Reference ID]							   NVARCHAR(2000),
			[Organization Subtype Reference Descriptor]			   NVARCHAR(2000),
			[Organization Subtype Reference ID type]			   NVARCHAR(2000),
			[Organization Subtype Reference ID]					   NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference Descriptor]  NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference ID type]     NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference ID]          NVARCHAR(2000)
		);

		INSERT INTO @COST_CENTER_HIERARCHY
		SELECT DENSE_RANK() OVER(ORDER BY [ID]) [Cost Center Hierarchy Key], * FROM (
			SELECT
				 'FALSE' [Add Only]
				,''[Cost Center Hierarchy Reference Descriptor]
				,'Organization_Reference_ID'[Cost Center Hierarchy Reference ID type]
				,[Cost Ctr] [Cost Center Hierarchy Reference ID]
				,[Valid From] [Effective Date]
				,[Cost Ctr] [ID]
				,''[Include Organization ID in Name]
				,[TXT_Description] [Organization Name]
				,''[Phonetic Name]
				,''[Organization Code]
				,IIF([TXT_Description] is null or [TXT_Description] = '','TRUE','FALSE')[Include Organization Code in Name]
				,'TRUE'[Organization Active]
				,[Valid From] [Availability Date]
				,''[Organization Visibility Reference Descriptor]
				,'WID'[Organization Visibility Reference ID type]
				,'9c875610c4fc496499e39741b6541dbc'[Organization Visibility Reference ID]
				,''[External URL Reference Descriptor]
				,''[External URL Reference ID type]
				,''[External URL Reference ID]
				,''[Organization Subtype Reference Descriptor]
				,'Organization_Subtype_ID'[Organization Subtype Reference ID type]
				,'Function'[Organization Subtype Reference ID]
				,''[Cost Center Hierarchy Superior Reference Descriptor]
				,'Organization_Reference_ID'[Cost Center Hierarchy Superior Reference ID type]
				,'CC_Hier_1000'[Cost Center Hierarchy Superior Reference ID]
			FROM (SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY [Cost Ctr] ORDER BY [Cost Ctr]) RNUM FROM DATA_SOURCE_COST_CENTER) A1 WHERE RNUM=1) A10
		) A1

		SELECT * INTO WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY FROM @COST_CENTER_HIERARCHY


		DECLARE @COST_CENTER_HIERARCHY_FLAT TABLE(
			[Cost Center Hierarchy Key]								NVARCHAR(2000),
			[Add Only]												NVARCHAR(2000),
			[Cost Center Hierarchy Reference Descriptor]			NVARCHAR(2000),
			[Cost Center Hierarchy Reference ID type]				NVARCHAR(2000),
			[Cost Center Hierarchy Reference ID]					NVARCHAR(2000),
			[Effective Date]										NVARCHAR(2000),
			[ID]													NVARCHAR(2000),
			[Include Organization ID in Name]						NVARCHAR(2000),
			[Organization Name]										NVARCHAR(2000),
			[Phonetic Name]											NVARCHAR(2000),
			[Organization Code]										NVARCHAR(2000),
			[Include Organization Code in Name]						NVARCHAR(2000),
			[Organization Active]									NVARCHAR(2000),
			[Availability Date]										NVARCHAR(2000),
			[Organization Visibility Reference Descriptor]			NVARCHAR(2000),
			[Organization Visibility Reference ID type]				NVARCHAR(2000),
			[Organization Visibility Reference ID]					NVARCHAR(2000),
			[External URL Reference Descriptor]						NVARCHAR(2000),
			[External URL Reference ID type]						NVARCHAR(2000),
			[External URL Reference ID]								NVARCHAR(2000),
			[Organization Subtype Reference Descriptor]				NVARCHAR(2000),
			[Organization Subtype Reference ID type]				NVARCHAR(2000),
			[Organization Subtype Reference ID]						NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference Descriptor]   NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference ID type]      NVARCHAR(2000),
			[Cost Center Hierarchy Superior Reference ID]           NVARCHAR(2000)
		);

		INSERT INTO @COST_CENTER_HIERARCHY_FLAT
		SELECT DENSE_RANK() OVER(ORDER BY [ID]) [Cost Center Hierarchy Key], * FROM (
			SELECT
				 'TRUE' [Add Only]
				,''[Cost Center Hierarchy Reference Descriptor]
				,''[Cost Center Hierarchy Reference ID type]
				,''[Cost Center Hierarchy Reference ID]
				,[Valid From] [Effective Date]
				,[Cost Ctr] [ID]
				,''[Include Organization ID in Name]
				,[TXT_Description] [Organization Name]
				,''[Phonetic Name]
				,''[Organization Code]
				,IIF(ISNULL([TXT_Description], '')='','TRUE','FALSE') [Include Organization Code in Name]
				,'TRUE'[Organization Active]
				,[Valid From] [Availability Date]
				,''[Organization Visibility Reference Descriptor]
				,'WID'[Organization Visibility Reference ID type]
				,'9c875610c4fc496499e39741b6541dbc'[Organization Visibility Reference ID]
				,''[External URL Reference Descriptor]
				,''[External URL Reference ID type]
				,''[External URL Reference ID]
				,''[Organization Subtype Reference Descriptor]
				,'Organization_Subtype_ID'[Organization Subtype Reference ID type]
				,'Function'[Organization Subtype Reference ID]
				,''[Cost Center Hierarchy Superior Reference Descriptor]
				,''[Cost Center Hierarchy Superior Reference ID type]
				,''[Cost Center Hierarchy Superior Reference ID]
			FROM (SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY [Cost Ctr] ORDER BY [Cost Ctr]) RNUM FROM DATA_SOURCE_COST_CENTER) A1 WHERE RNUM=1) A10
		) A1

		SELECT * INTO WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY_FLAT FROM @COST_CENTER_HIERARCHY_FLAT

		/***** Cost Center Validation Query Starts *****/
		SET @SQL='drop table if exists NOVARTIS_DATA_MIGRATION_COST_CENTER_VALIDATION;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

        SELECT DISTINCT * INTO NOVARTIS_DATA_MIGRATION_COST_CENTER_VALIDATION FROM (
            SELECT @which_wavestage [Build Number]
                ,@which_report [Report Name]
                ,[Cost Center Key]+'( '+A1.[ID]+' )' [Employee ID]
                ,'' [Country Name]
				,'' [Country ISO3 Code]
				,'' [Employee Type]
				,'' [Employee Group]
                ,(
                    IIF(ISNULL(A1.[ID], '') <> '', 'Cost Center and Company Code are the same ( '+A1.[ID]+' )', '')
                 ) ErrorText
            FROM WD_HR_TR_AUTOMATED_COST_CENTER A1 
			JOIN p0_dgw_company a2
			ON A1.[ID] = A2.[ID]
            ) c WHERE ErrorText <> '';
      


		SELECT * FROM WD_HR_TR_AUTOMATED_COST_CENTER ORDER BY CAST([Cost Center Key] AS INT)
		SELECT * FROM WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY ORDER BY CAST([Cost Center Hierarchy Key] AS INT)
		SELECT * FROM WD_HR_TR_AUTOMATED_COST_CENTER_HIERARCHY_FLAT ORDER BY CAST([Cost Center Hierarchy Key] AS INT)
		SELECT * FROM NOVARTIS_DATA_MIGRATION_COST_CENTER_VALIDATION ORDER BY [Employee ID]

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
