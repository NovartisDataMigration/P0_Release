USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE]    Script Date: 10/02/2020 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Subramanian.C>
-- =============================================
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Worker Health Insurance  ******/
	BEGIN TRY 
		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_PA0013;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT [Emp - Personnel Number], [Start Date], [End date], [Health Ins. Fund] INTO WAVE_NM_PA0013 FROM '+@which_wavestage+'_PA0013
		              WHERE [Start Date] <= CAST('''+@which_date+''' AS DATE)  AND [End Date] >= CAST('''+@which_date+''' AS DATE);';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		--SELECT DISTINCT * FROM WAVE_NM_PA0013 

		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					 FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							   FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
				  WHERE a.RNK=1'
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

		DECLARE @HEALTH_INSURANCE_NUMBER_LKUP TABLE (
			HEALTH_INSURANCE_NUMBER          NVARCHAR(30),
			WD_VALUE                         NVARCHAR(4000)
		)
		INSERT INTO @HEALTH_INSURANCE_NUMBER_LKUP
		SELECT LTRIM(RTRIM(SUBSTRING(ITEM, LEN(ITEM)-7, 8))), ITEM  FROM [dbo].[fnSplitIndex](
		'LKK Niedersachsen-Bremen Hanno 29147110
		KKH Kaufmnnische Krankenkasse 29137937
		BKK TUI 29074470
		BKK EWE 26515319
		BKK24 23709856
		BKK Technoform 23446040
		BKK exklusiv 22178373
		BKK Publik 21488086
		BKK Salzgitter 21203214
		BKK firmus 20156168
		atlas BKK 20156113
		hkk 20013461
		IKK gesund plus 20013109
		AOK Bremen/Bremerhaven 20012084
		IKK classic Vereinigte IKK - R 19976066
		BKK Beiersdorf AG 16839984
		BKK RWE 16665321
		pronova BKK (Ost) 15874275
		pronova BKK 15872672
		SECURVITA 15517482
		BKK MOBIL OIL 15517302
		Shell BKK/LIFE 15517299
		IKK classic in Hamburg LD 15039837
		AOK Hamburg 15039702
		DAK-Gesundheit 15035218
		HEK Hauptverwaltung 15031806
		Techniker Krankenkasse 15027365
		IKK Nord 14228571
		AOK NordWest  Schleswig-Hol 13460004
		LKK Kiel 13199426
		BKK S-H 11576709
		BKK ESSANELLE (Ost) 8640881
		BKK PricewaterhouseCoopers Ost 8596570
		BKK VBU (Ost) Verkehrsbau Unio 8476370
		Bahn-BKK (Ost) 8316149
		BKK TUI (Ost) 8227948
		BKK Kassana (Ost) 8129778
		BKK ProVita (Ost) 8090728
		mhplus BKK (Ost) 7812433
		BKK Miele Ost 7684386
		BKK Pfalz (Ost) 7251093
		Schwenninger BKK (Ost) 6818233
		BKK Wirtschaft & Finanzen (Ost 6785450
		AOK Plus Sachsen und Thüringen 5174740
		BKK KBA (Ost) 5045203
		BIG  direkt gesund (Ost) 5012943
		BKK VDN (Ost) 4309904
		Novitas BKK (Ost) 3847834
		BKK exklusiv (Ost) 3591039
		Daimler BKK (Ost) 2988673
		BKK24 (Ost) 2430065
		actimonda Krankenkasse 1086312
		Debeka BKK (Ost) 1086243
		BKK DEMAG (Ost) Kraus-MAFFEi 1086163
		Heimat Krankenkasse (Ost) 1086094
		BKK EWE (Ost) 1086050
		BKK R + V (Ost) 1085890
		Südzucker-BKK Ost 1085823
		energie-BKK (Ost) 1085812
		SBK HV (Ost) 1085787
		BKK BMW (Ost) 1085754
		Vaillant BKK (Ost) 1085594
		Deutsche BKK (Ost) 1085583
		BKK Salzgitter (Ost) 1085538
		BKK Linde (Ost) 1085457
		BKK PFAFF (Ost) 1085446
		SECURVITA BKK (Ost) 1085402
		SKD BKK (Ost) 1085242
		WMF BKK (Ost) 1085231
		Vereinigte BKK (Ost) 1085219
		Salus BKK (Ost) 1085195
		BKK Braun-Gillette (Ost) 1085082
		Bertelsmann BKK (Ost) 1085037
		BKK Würth Ost 1085026
		Audi BKK (Ost) 1083422
		BKK advita (Ost) 1075558
		Bosch BKK (Ost) 1073497
		Thüringer BKK (Ost) 1068979
		BKK firmus (Ost) 1058922
		IKK classic (Ost) 1049203
		BKK VerbundPlus (Ost) 1049156
		DAK-Gesundheit (ehem. BKK Ost) 1031123
		AOK Sachsen-Anhalt 1029141
		BKK ZF & Partner (Ost) 1020870
		IKK Brandenburg und Berlin 1020803
		BKK Herford Minden Ravensberg 1018182
		Brandenburgische BKK 1017272
		BKK Diakonie (Ost) 1013837
		BKK Gildemeister-Seidensticker 1011777
		IKK Nord (Ost) 1005483
		BKK Deutsche Bank AG (Ost) 1000672
		Krankenkasse für den Gartenbau 1000650
		IKK-classic Thüringen 1000477
		IKK gesund plus (Ost) 1000455
		Shell BKK/LIFE (Ost) 1000364
		LKK Mittel- und Ostdeutschland 1000308
		AOK PLUS  Thüringen 1000159
		AOK Nordost Brandenburg 1000126
		BKK ProVita 88571250
		SBK HV BKK 87954699
		AOK Bayern 87880235
		BKK BMW 87271125
		LKK Niederbayern/Oberpfalz und 87119868
		BKK Faber-Castell & Partner 86772584
		Audi BKK 82889062
		BKK Stadt Augsburg 81211334
		BKK KBA 75925585
		SKD BKK 74773896
		BKK Krones 74157435
		BKK Kassana 73170441
		BKK Textilgruppe Hof 73170269
		LKK Franken und Oberbayern 72360029
		BKK Akzo Nobel 71579930
		BKK VerbundPlus 69785429
		BKK ZF & Partner 69753266
		BKK Wieland-Werke AG 68659646
		Daimler BKK 68216980
		LKK Baden-Württemberg Stuttgar 67574619
		Deutsche BKK 67573219
		Bosch BKK 67572593
		BKK Mahle 67572537
		AOK Baden-Württemberg 67450665
		BKK Würth 67161380
		Barmer GEK (ehem. GEK) 66761998
		BKK Rieker Ricosta Weiser 66626976
		BKK SBH 66614249
		BKK AESCULAP 66458503
		Schwenninger BKK 66458477
		Metzinger BKK 66105948
		BKK MTU Friedrichshafen 65710574
		BKK Freudenberg 63922962
		IKK Classic 63774343
		mhplus BKK 63494759
		BKK Südzucker 62332660
		WMF BKK 61232769
		BKK SCHEUFELEN 61232758
		BKK Groz-Beckert 60393261
		BKK advita 60255652
		IKK Südwest 55811201
		AOK Saarland 55420162
		BKK vital 52654083
		BKK Pfalz 52598579
		Debeka BKK 52156763
		AOK Rheinland-Pfalz 51605725
		BKK Pfaff 51588416
		Bahn-BKK 49003443
		BKK R + V 48944809
		DAK-Gesundheit 48698890
		BKK Linde 48698889
		BKK family 48698845
		BKK KARL MAYER 48063096
		BKK PricewaterhouseCoopers 47307817
		Landwirtschaftliche Krankenk. 47069693
		LKK Hessen, Rheinland-Pfalz u. 47068420
		BKK B. Braun Melsungen AG 47034975
		BKK Herkules 47034953
		BKK HENSCHEL Plus 47034920
		BKK Wirtschaft & Finanzen 46967693
		BKK Ernst & Young 46939789
		AOK Hessen 45118687
		Vereinigte BKK 45094601
		BKK Braun-Gillette 45094199
		Salus BKK 44953697
		BKK Merck 44377882
		HEAG BKK 44377871
		BKK WERRA-MEISSNER 44037562
		BARMER 42938966
		BARMER GEK 42938966
		DIE BERGISCHE KRANKENKASSE 42039708
		Vaillant BKK 42039582
		BKK der SIEMAG 41378558
		BKK Achenbach Buschhütten 41378433
		VIACTIV Krankenkasse 40180080
		LKK Nordrhein-Westfalen Münste 39873587
		BKK VDN 37416328
		BKK Herford Minden Ravensberg 36916980
		BKK Melitta Plus 36916935
		E.ON BKK 35430071
		NOVITAS BKK 35134022
		BKK DEMAG Kraus MaFFEI 35087770
		BKK Deutsche Bank AG 34401277
		BKK ESSANELLE 34369034
		AOK Rheinland/Hamburg 34364249
		Die Continentale BKK 33865367
		AOK Westfalen-Lippe 33526082
		IKK classic Vereinigte IKK 33461466
		BKK Basell 32579095
		BKK Gildemeister-Seidensticker 31323802
		BKK Dürkopp Adler 31323799
		BKK Miele 31323700
		BKK Diakonie 31323686
		Bertelsmann BKK 31323584
		Heimat Krankenkasse 31209131
		BKK BPW Wiehl 30980327
		BKK EUREGIO 30168049
		actimonda krankenkasse 30165364
		AOK Niedersachsen 29720865
		energie-BKK 29717581
		Knappschaft Bahn See 98000006
		Knappschaft 98000001
		Thüringer BKK 97565837
		BKK Voralb 97352653
		BIG 97141402
		BKK VBU 92644250
		IKK Brandenburg und Berlin 90397224
		AOK Berlin 90235319
		AOK Nordost Meck.-Vorpommern 1000080', CHAR(13));

		--SELECT * FROM W4_GOLD_PA0013
	    DECLARE @HEALTH_INSURANCE TABLE (
		      [Field]							NVARCHAR(2000),
		      [Spreadsheet Key]					NVARCHAR(2000),
			  [Effective Date]					NVARCHAR(2000),
		      [Worker]							NVARCHAR(2000),
			  [Expected End Date]				NVARCHAR(2000),			  
			  [Secondment Reason]				NVARCHAR(2000),
			  [Benefit Custom File]				NVARCHAR(2000),
			  [Health Insurance Fund Field]     NVARCHAR(2000),
			  [Health Ins. Fund]				NVARCHAR(2000)
		);

		INSERT INTO @HEALTH_INSURANCE
		    SELECT '', DENSE_RANK() OVER(ORDER BY [Worker] ASC) AS [Spreadsheet Key], * FROM (
			SELECT 
			      IIF(ISNULL([Start Date], '')<>'', CONVERT(varchar(10), CAST([Start Date] as date), 23), '') [Effective Date]
			      ,a.[PERSNO_NEW] [Worker]
				  ,'' [Expected End Date]
				  ,'' [Secondment Reason]
				  ,'' [Benefit Custom File]
				  ,ISNULL((SELECT TOP 1 LTRIM(RTRIM(WD_VALUE)) FROM @HEALTH_INSURANCE_NUMBER_LKUP WHERE HEALTH_INSURANCE_NUMBER=b.[Health Ins. Fund]),'') [Health Insurance Fund Field]
				  ,[Health Ins. Fund]
			  FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] a
			         LEFT JOIN WAVE_NM_PA0013 b ON a.[Emp - Personnel Number]=b.[Emp - Personnel Number]) A1
		--SELECt * FROM WAVE_NM_PA0013

		/***** Health Insurance Validation Query Starts *****/
	    SELECT * FROM (
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[Worker]+'( '+[Spreadsheet Key]+' )' [Employee ID]
				  ,'' [Country Code]
				  ,(IIF(ISNULL([Health Insurance Fund Field], '')='', '', '')) ErrorText
			FROM @HEALTH_INSURANCE) c WHERE ErrorText <> '';

		DECLARE @HEALTH_INSURANCE_HR_CORE_MISSING_WD_VALUE TABLE (
			  [Health Ins. Fund]            NVARCHAR(2000)
		);
		INSERT INTO @HEALTH_INSURANCE_HR_CORE_MISSING_WD_VALUE
        SELECT DISTINCT [Health Ins. Fund] FROM @HEALTH_INSURANCE WHERE [Health Ins. Fund] IS NOT NULL AND [Health Insurance Fund Field] = ''
		--SELECT * FROM @HEALTH_INSURANCE_HR_CORE_MISSING_WD_VALUE

		INSERT INTO ALCON_MIGRATION_ERROR_LIST
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,'HR Core Id( '+[Health Ins. Fund]+' )' [Employee ID]
				  ,'' [Country Code]
				  ,'WD VALUE MISSING' ErrorText
			FROM @HEALTH_INSURANCE_HR_CORE_MISSING_WD_VALUE;

		/***** Health Insurance Automtion Query *****/
		DECLARE @Table_Name AS VARCHAR(100)='WD_HR_TR_AUTOMATED_HEALTH_INSURANCE';
		EXEC PROC_DROP_TABLE_WITH_BATCH @Table_Name;
		PRINT 'Drop table, If exists: '+@Table_Name;

		SELECT  
		   [Field]
		  ,[Spreadsheet Key]
		  ,[Effective Date]
		  ,[Worker]
		  ,[Expected End Date]
		  ,[Secondment Reason]
		  ,[Benefit Custom File]
		  ,[Health Insurance Fund Field] [Health Insurance Fund]
        INTO WD_HR_TR_AUTOMATED_HEALTH_INSURANCE FROM @HEALTH_INSURANCE WHERE [Health Insurance Fund Field] <> ''

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
--EXEC PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE 'P0', 'Health Insurance', '2021-03-10'
--EXEC PROC_WAVE_NM_AUTOMATE_HEALTH_INSURANCE 'W4_GOLD', 'Health Insurance', '2021-02-14'
--SELECT * FROM WD_HR_TR_AUTOMATED_HEALTH_INSURANCE ORDER BY [Worker]
--SELECT * FROM WD_HR_TR_AUTOMATED_HEALTH_INSURANCE WHERE [Health Ins. Fund] IS NOT NULL AND [Benefits Custom Field] = '' ORDER BY [Worker]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_GOLD' AND [Report Name]='Health Insurance' ORDER BY [Employee ID]