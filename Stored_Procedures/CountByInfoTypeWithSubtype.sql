USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[CheckInfotypeCountAEDTM_SP]    Script Date: 5/9/2021 2:28:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:<Author,,>
-- Create date: <,,>
-- Description:<Description,,>
-- =============================================

ALTER PROCEDURE [dbo].[CheckInfotypeCountAEDTM_SP]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
	DROP TABLE IF EXISTS #TempInfotypes2

	create table #TempInfotypes2
	(
	RowID int IDENTITY(1, 1), 
	tablename nvarchar(50)
	)

	DECLARE @NumberRecords int, @RowCount int
	DECLARE @tablename varchar(50)
	DECLARE @country varchar(50)
	DECLARE @iso3 varchar(50)
	DECLARE @CountAEDTM varchar(50)
	DECLARE @subTy varchar(50)
	
	DECLARE @infotypeDescription varchar(200)
	DECLARE @subtyDescription varchar(200)

	Declare @SQL varchar(MAX)

	INSERT INTO #TempInfotypes2 (tablename)
	SELECT DISTINCT t.TABLE_NAME
	FROM INFORMATION_SCHEMA.COLUMNS t
	INNER JOIN INFORMATION_SCHEMA.COLUMNS t2 on (t2.table_name=t.TABLE_NAME AND t2.COLUMN_NAME ='AEDTM')
	--INNER JOIN INFORMATION_SCHEMA.COLUMNS t3 on (t3.table_name=t.TABLE_NAME AND t3.COLUMN_NAME ='PERNR')
	INNER JOIN INFORMATION_SCHEMA.COLUMNS t4 on (t4.table_name=t.TABLE_NAME and t4.COLUMN_NAME ='SUBTY')
	WHERE t.TABLE_NAME LIKE 'GV_%' 
	--OR t.TABLE_NAME LIKE 'P0_%' 
	AND t.TABLE_CATALOG='Prod_DataClean'
	
	SET @NumberRecords = @@ROWCOUNT
	SET @RowCount = 1

	truncate table InfotypeCountryCountAEDTM

	-- loop through all records in the temporary table
	-- using the WHILE loop construct
	WHILE @RowCount <= @NumberRecords
	BEGIN
		--set @tablename=null
		SELECT @tablename = tablename FROM #TempInfotypes2
		WHERE RowID = @RowCount

		DECLARE @NumberRecordsCountries int, @RowCountCountries int

		IF SUBSTRING(@tablename, 4, 3)<>'HRP'
			set @SQL='INSERT INTO InfotypeCountryCountAEDTM (Infotype, InfotypeDescription, Country, ISO3, Count_AEDTM, Subty, SubtyDescription, Country_Count_AEDTM)
				SELECT [Info Type], max([Infotype text]) [Infotype text], Country, ISO3, COUNT([AEDTM]) AEDTM, SUBTY, 
					   max([Subtype Description]) [Subtype Description], max([Country_Count_AEDTM]) [Country_Count_AEDTM] FROM (
					SELECT ''' + SUBSTRING(@tablename, 4, LEN(@tablename)) + ''' [Info Type], ISNULL(t.[Infotype text], '''') [Infotype text], 
						   c.Country, c.ISO3, i.AEDTM, 
						   isnull(i.SUBTY, '''') SUBTY, IIF(ISNULL(s.[Name], '''')='''', ISNULL(u.[SubType Text], ''''), ISNULL(s.[Name], '''')) [Subtype Description], 
						   ''0'' [Country_Count_AEDTM]
					FROM ' + @tablename + ' i
					JOIN p0_position_management p ON i.PERNR = p.[emp - personnel number]
					JOIN COUNTRY_LKUP c ON p.[geo - country (CC)] = c.ISO2
					LEFT JOIN GV_T582S t ON t.IType = RIGHT (''' + @tablename + ''', 4)
					LEFT JOIN GV_T777U u ON u.IT = RIGHT (''' + @tablename + ''', 4) AND u.Sty=i.Subty
					LEFT JOIN P0_T591S s ON s.Itype = RIGHT (''' + @tablename + ''', 4) AND s.Styp=i.Subty
					WHERE 
					i.AEDTM > ''20190101'' AND i.Subty<>''STy.'' AND p.[geo - country (CC)] IS NOT NULL AND '''+SUBSTRING(@tablename, 4, 3)+'''<>''''
				) A2
				GROUP BY [Info Type], SUBTY, Country, ISO3'
		IF SUBSTRING(@tablename, 4, 3)='HRP'
			set @SQL='INSERT INTO InfotypeCountryCountAEDTM (Infotype, InfotypeDescription, Country, ISO3, Count_AEDTM, Subty, SubtyDescription, Country_Count_AEDTM)
				SELECT [Info Type], max([Infotype text]) [Infotype text], Country, ISO3, COUNT([AEDTM]) AEDTM, SUBTY, 
					   max([Subtype Description]) [Subtype Description], max([Country_Count_AEDTM]) [Country_Count_AEDTM] FROM (
					SELECT ''' + SUBSTRING(@tablename, 4, LEN(@tablename)) + ''' [Info Type], ISNULL(t.[Infotype text], '''') [Infotype text], 
						   '''' Country, '''' ISO3, i.AEDTM, 
						   isnull(i.SUBTY, '''') SUBTY, IIF(ISNULL(s.[Name], '''')='''', ISNULL(u.[SubType Text], ''''), ISNULL(s.[Name], '''')) [Subtype Description], 
						   ''0'' [Country_Count_AEDTM]
					FROM ' + @tablename + ' i
					LEFT JOIN GV_T582S t ON t.IType = RIGHT (''' + @tablename + ''', 4)
					LEFT JOIN GV_T777U u ON u.IT = RIGHT (''' + @tablename + ''', 4) AND u.Sty=i.Subty
					LEFT JOIN P0_T591S s ON s.Itype = RIGHT (''' + @tablename + ''', 4) AND s.Styp=i.Subty
					WHERE 
					i.AEDTM > ''20190101'' AND i.Subty<>''STy.'' AND '''+SUBSTRING(@tablename, 4, 3)+'''=''HRP''
				) A2
				GROUP BY [Info Type], SUBTY, Country, ISO3;'

		Print @tablename
		Print @SQL
		exec(@SQL)
		
		SET @RowCount = @RowCount + 1

		
	END

	drop table #TempInfotypes2

	UPDATE A1 
	   SET Country_Count_AEDTM=ISNULL(CAST((SELECT SUM(CAST(COUNT_AEDTM AS INT)) FROM InfotypeCountryCountAEDTM A2 WHERE A2.ISO3=A1.ISO3 AND A2.InfoType=A1.InfoType) AS VARCHAR(100)), '0')
	FROM InfotypeCountryCountAEDTM A1
END
GO

--SELECT * FROM InfotypeCountryCountAEDTM WHERe ISO3='BGD' AND InfoType='GV_PA0006_old'
--SELECT DISTINCT COUNT_AEDTM FROM InfotypeCountryCountAEDTM ORDER BY COUNT_AEDTM DESC
--SELECT * FROM P0_T591S WHERE ITYPE='0014'
--SELECT DISTINCT SUBTY FROM GV_PA0008


/*
EXECUTE Stored Procedure
--EXEC [dbo].[CheckInfotypeCountAEDTM_SP]
--SELECT * FROM InfotypeCountryCountAEDTM ORDER BY InfoType, ISO3, Subty
--SELECT * FROM GV_HRP1002


Select Newly Created Table of AEDTM Count
-- SELECT * FROM InfotypeCountryCountAEDTM --WHERE Country = 'Belgium' AND Infotype LIKE '%21%'

Select Vinson's Table
--SELECT * FROM InfotypeCountryLatestDate WHERE Country = 'Belgium' AND Infotype LIKE '%21%'


Create Table for Count AEDTM

CREATE TABLE [dbo].[InfotypeCountryCountAEDTM](
	[Infotype]						[nvarchar](50)	NOT NULL,
	[InfotypeDescription]			[nvarchar](255)	NULL,
	[Country]						[nvarchar](50)	NOT NULL,
	[ISO3]							[nvarchar](5)	NOT NULL,
	[Count_AEDTM]					[nvarchar](50)	NOT NULL,
	[Subty]							[nvarchar](50)	NULL,
	[SubtyDescription]				[nvarchar](255) NULL,
	[Country_Count_AEDTM]		    [nvarchar](50)	NOT NULL,
)

--DROP TABLE IF EXISTS InfotypeCountryCountAEDTM

*/
