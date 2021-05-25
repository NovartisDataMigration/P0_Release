USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID]    Script Date: 10/02/2020 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Subramanian.C>
-- =============================================
--IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_POSITION_MANAGEMENT', 'P' ) IS NOT NULL   
--    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_POSITION_MANAGEMENT;  
--GO
--CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_POSITION_MANAGEMENT]
--    @which_wavestage AS VARCHAR(50),
--	@which_report AS VARCHAR(500),
--	@which_date AS VARCHAR(50)
--AS
--BEGIN
--    DECLARE @SQL AS VARCHAR(4000)='drop table if exists [WAVE_NM_POSITION_MANAGEMENT_INITIAL];';
--	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

--	select count(*) From w4_gold_Sup_Org;
--	select persno as [Emp - Personnel Number]
--		  ,personid_ext as globalID
--		  ,personid_ext as [Emp - HRCGLPers. id]
--		  ,j.[USRID] AS [Emp - GDDB ID]
--		  ,k.[USRID] AS [Emp - FirstPort ID]
--		  ,c.PERSG  as [Emp - Group]
--		  ,c.PERSK as [Emp - subgroup]
--		  ,h.INTCA as [Geo - Work Country]
--		  ,h.INTCA as [Geo - Country (CC)]
--		  ,l.VORNA as [Emp - First Name]
--		  ,l.NACHN as [Emp - Last Name]
--		  ,m.USRID_LONG as [Emp - Email Address]
--		  ,MASSG as [Emp - Hire Type]
--		  ,iif(CTEDT='00000000',NULL,CTEDT) as [Emp - Contr End Date]
--		  ,iif(CTEDT='00000000',NULL,TERMN) as [dt - expiryprobation]
--		  --,BEGDA
--		  ,[ORGEH] [org - Org unit]
--		  --,[org unit desc]
--		  ,[PLANS] [org - position]
--		  ,'' [Org - Position Text]
--		  --,[position text]
--		  --,[job code description (GJFA)]
--		  --,[job code long description]
--		  ,yysite as [geo - site code]
--		  ,TEILK as [emp - part time flag}
--		  ,KOSTL as [org - cost center]
--    INTO [WAVE_NM_POSITION_MANAGEMENT_INITIAL]
--	from w4_gold_Sup_Org a
--	left join 
--	(select * from w4_gold_pa0709 
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) b
--	on a.persno = b.pernr
--	left join 
--	(select * from w4_gold_pa0001
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) c
--	on a.persno = c.pernr
--	left join 
--	(select * from w4_gold_pa0000
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) d
--	on a.persno = d.pernr
--	left join 
--	(select * from w4_gold_pa0016
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) e
--	on a.persno = e.pernr
--	left join
--	(select * from w4_gold_pa0019 -- duplicates happening
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' 
--	and SPRPS is null) f
--	on a.persno = f.pernr
--	--left join 
--	--(select * from w4_gold_pa1001 
--	--where convert(date,begda)<='2021-02-14'
--	--and convert(date,endda)>='2021-02-14' ) g
--	--on a.persno = g.pernr
--	left join 
--	(select * from w4_gold_pa9008
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) h
--	on a.persno = h.pernr
--	left join 
--	(select * from w4_gold_pa0007
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) i
--	on a.persno = i.pernr
--	left join 
--	(select * from w4_gold_pa0105
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' 
--	and SUBTY='0001' ) j
--	on a.persno = j.pernr
--	left join 
--	(select * from w4_gold_pa0105
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' 
--	and SUBTY='9000' ) k
--	on a.persno = k.pernr
--	left join 
--	(select * from w4_gold_pa0105
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' 
--	and SUBTY='0010' ) m
--	on a.persno = m.pernr
--	left join 
--	(select * from w4_gold_pa0002
--	where convert(date,begda)<='2021-02-14'
--	and convert(date,endda)>='2021-02-14' ) l
--	on a.persno = l.pernr
--END
--GO

--EXEC PROC_WAVE_NM_AUTOMATE_POSITION_MANAGEMENT 'W4_GOLD', 'Other ID', '2020-10-02'
--SELECT * FROM [WAVE_NM_POSITION_MANAGEMENT_INITIAL]
--SELECT * FROM [P0_POSITION_MANAGEMENT]
--[Org - OpLevel 3], [Org - OpLevel 2], [Org - OpLevel 1], [Org - Funct Dep Code], [CB - Payroll ref No.], [Emp-Prev PrsNo Legcy]

IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Other ID(Novartis Migration)  ******/
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID 'P0', 'Other ID', '2021-03-10'
--SELECT * FROM [WAVE_NM_POSITION_MANAGEMENT_INITIAL]
--SELECT * FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID ORDER BY CAST([Change Other IDs Key] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID ORDER BY CAST([Change Other IDs Key] AS INT)

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
				  ,'Employee_ID' [Person Reference ID type]
				  ,[Emp - HRCGLPers. id] [Person Reference ID]
				  ,'' [Universal ID Reference Descriptor]
				  ,'' [Universal ID Reference ID type]
				  ,'' [Universal ID Reference ID]
				  ,'' [Replace All]
	      FROM (SELECT DISTINCT [Emp - HRCGLPers. id] FROM [P0_POSITION_MANAGEMENT]) A6) A5
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
           [Custom ID Shared Reference ID]          NVARCHAR(2000)
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
					,''  [ID Type Reference ID type]
					,''  [ID Type Reference ID]
					,''  [Organization ID Reference Descriptor]
					,''  [Organization ID Reference ID type]
					,''  [Organization ID Reference ID]
					,''  [Custom ID Shared Reference Descriptor]
					,'Custom_ID_Type_ID'  [Custom ID Shared Reference ID type]
					,[Type]  [Custom ID Shared Reference ID]
				FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID A1 
					LEFT JOIN (
					     SELECT [Emp - HRCGLPers. id], [Emp - GDDB ID] AS ID, 'GDDB ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - GDDB ID] IS NOT NULL
						 UNION ALL
						 SELECT [Emp - HRCGLPers. id], [Emp - FirstPort ID] AS ID, 'FirstPort ID' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - FirstPort ID] IS NOT NULL
						 UNION ALL
						 SELECT [Emp - HRCGLPers. id], [Emp - Personnel Number] AS ID, 'Personnel Number' [Type] FROM [P0_POSITION_MANAGEMENT] WHERE [Emp - Personnel Number] IS NOT NULL
					) A2 ON A1.[Person Reference ID]=A2.[Emp - HRCGLPers. id]
		       ) A3
        --SELECT * FROM P0_POSITION_MANAGEMENT WHERE [Emp - HRCGLPers. id] like '%?%'

		/***** Other ID custom ID Validation Query Starts *****/
		DELETE FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE WAVE=@which_wavestage AND [Report]=@which_report
		INSERT INTO NOVARTIS_DATA_MIGRATION_ERROR_LIST
	    SELECT * FROM (
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,'' [Employee ID]
				  ,'' [Country Code]
				  ,(IIF(ISNULL([ID], '')='', '', '')) ErrorText
			FROM @OTHERID_CUSTOM_ID) c WHERE ErrorText <> '';

		/***** Other ID(Novartis Migration) Automtion Query *****/
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SELECT * INTO WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID FROM @OTHERID_CUSTOM_ID 

		SELECT * FROM WD_HR_TR_AUTOMATED_CHANGE_OTHERID ORDER BY CAST([Change Other IDs Key] AS INT)
		SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_CUSTOM_ID ORDER BY CAST([Change Other IDs Key] AS INT)
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
