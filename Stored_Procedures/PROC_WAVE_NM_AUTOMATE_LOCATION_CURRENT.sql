SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* If the function('dbo.GetAddressInfo') already exist */
IF OBJECT_ID('dbo.GetAddressInfo') IS NOT NULL
  DROP FUNCTION GetAddressInfo
GO
CREATE FUNCTION GetAddressInfo (
    @ISO2                  AS NVARCHAR(2000),
    @ENTITY                AS NVARCHAR(2000),	
    @ADDRESS_LINE1         AS NVARCHAR(2000),
	@ADDRESS_LINE2         AS NVARCHAR(2000),
	@ADDRESS_LINE3         AS NVARCHAR(2000),
	@ADDRESS_LINE4         AS NVARCHAR(2000),
	@ADDRESS_LINE5         AS NVARCHAR(2000),
	@ADDRESS_LINE6         AS NVARCHAR(2000),
	@ADDRESS_LINE7         AS NVARCHAR(2000),
	@ADDRESS_LINE8         AS NVARCHAR(2000),
	@ADDRESS_LINE9         AS NVARCHAR(2000),
	@CITY                  AS NVARCHAR(2000),
	@REGION                AS NVARCHAR(2000),
	@CITY_SUBDIVISION_1    AS NVARCHAR(2000),
	@CITY_SUBDIVISION_2    AS NVARCHAR(2000),
	@REGION_SUBDIVISION_1  AS NVARCHAR(2000),
	@REGION_SUBDIVISION_2  AS NVARCHAR(2000),
	@POSTAL_CODE           AS NVARCHAR(2000)
)
RETURNS NVARCHAR(4000)  
BEGIN  
     DECLARE @SrcMapField AS VARCHAR(1000)='';
	 DECLARE @ReturnValue AS NVARCHAR(2000)='';

	 --SELECT DISTINCT  FROM SET_ADDRESS_FIELD_MAPPING_LOCATION_FINAL
	 --SELECT DISTINCT SRC_MAP_FIELD FROM SET_ADDRESS_FIELD_MAPPING_COMPANY_FINAL
	 --SELECT * INTO [SET_ADDRESS_FIELD_MAPPING_LOCATION_FINAL] FROM [SET_ADDRESS_FIELD_MAPPING_LOCATION]
	 --SELECT DISTINCT * FROM [SET_ADDRESS_FIELD_MAPPING_LOCATION] WHERE DST_MAP_FIELD='_city_subdivision'
	 --UPDATE [SET_ADDRESS_FIELD_MAPPING_LOCATION] SET DST_MAP_FIELD='_city_subdivision_1' WHERE DST_MAP_FIELD='_city_subdivision'

     DECLARE cursor_item CURSOR FOR SELECT SRC_MAP_FIELD 
	                                    FROM [SET_ADDRESS_FIELD_MAPPING_LC] 
										WHERE ISNULL(SRC_MAP_FIELD, '') <> '' AND DST_MAP_FIELD=@ENTITY AND ISO2=@ISO2 ORDER BY [INDEX]
	 OPEN cursor_item;
	 FETCH NEXT FROM cursor_item INTO @SrcMapField;
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
	    SET @ReturnValue = @ReturnValue + (CASE 
		                       WHEN (@SrcMapField='Location Street 1' OR @SrcMapField='Address #1') THEN IIF(ISNULL(@ADDRESS_LINE1, '')='', '', ','+@ADDRESS_LINE1)
							   WHEN (@SrcMapField='Location Street 2' OR @SrcMapField='Address #2') THEN IIF(ISNULL(@ADDRESS_LINE2, '')='', '', ','+@ADDRESS_LINE2)
							   WHEN (@SrcMapField='Location Street 3' OR @SrcMapField='Address #3') THEN IIF(ISNULL(@ADDRESS_LINE3, '')='', '', ','+@ADDRESS_LINE3)
							   WHEN (@SrcMapField='Location Street 4' OR @SrcMapField='Address #4') THEN IIF(ISNULL(@ADDRESS_LINE4, '')='', '', ','+@ADDRESS_LINE4)
							   WHEN (@SrcMapField='Location Street 5' OR @SrcMapField='Address #5') THEN IIF(ISNULL(@ADDRESS_LINE5, '')='', '', ','+@ADDRESS_LINE5)
							   WHEN (@SrcMapField='Location Street 6' OR @SrcMapField='Address #6') THEN IIF(ISNULL(@ADDRESS_LINE6, '')='', '', ','+@ADDRESS_LINE6)
							   WHEN (@SrcMapField='Location Street 7' OR @SrcMapField='Address #7') THEN IIF(ISNULL(@ADDRESS_LINE7, '')='', '', ','+@ADDRESS_LINE7)
							   WHEN (@SrcMapField='Location Street 8' OR @SrcMapField='Address #8') THEN IIF(ISNULL(@ADDRESS_LINE8, '')='', '', ','+@ADDRESS_LINE8)
							   WHEN (@SrcMapField='Location Street 9' OR @SrcMapField='Address #9') THEN IIF(ISNULL(@ADDRESS_LINE9, '')='', '', ','+@ADDRESS_LINE9)
							   WHEN (@SrcMapField='Location Town' OR @SrcMapField='City') THEN IIF(ISNULL(@CITY, '')='', '', ','+@CITY)
							   WHEN (@SrcMapField='Region') THEN IIF(ISNULL(@REGION, '')='', '', ','+@REGION)
							   WHEN (@SrcMapField='Postal Code' OR @SrcMapField='Postl Code') THEN IIF(ISNULL(@POSTAL_CODE, '')='', '', ','+@POSTAL_CODE)
							   WHEN (@SrcMapField='City Subdivision 1') THEN IIF(ISNULL(@CITY_SUBDIVISION_1, '')='', '', ','+@CITY_SUBDIVISION_1)
							   WHEN (@SrcMapField='City Subdivision 2') THEN IIF(ISNULL(@CITY_SUBDIVISION_2, '')='', '', ','+@CITY_SUBDIVISION_2)
							   WHEN (@SrcMapField='Region Subdivision 1') THEN IIF(ISNULL(@REGION_SUBDIVISION_1, '')='', '', ','+@REGION_SUBDIVISION_1)
							   WHEN (@SrcMapField='Region Subdivision 2') THEN IIF(ISNULL(@REGION_SUBDIVISION_2, '')='', '', ','+@REGION_SUBDIVISION_2)
							END)
     	FETCH NEXT FROM cursor_item INTO @SrcMapField;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	RETURN IIF(@ReturnValue='', '', SUBSTRING(@ReturnValue, 2, LEN(@ReturnValue)));
END
GO

IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_LOCATIONS', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_LOCATIONS;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_LOCATIONS]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN

--EXECUTE [dbo].[PROC_WAVE_NM_AUTOMATE_LOCATIONS] 'P0', 'Location', '2021-03-10'
--SELECT * FROM WD_HR_TR_AUTOMATED_LOCATIONS ORDER BY CAST([LOCATION KEY] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_LOCATION_USAGE_REFERENCE ORDER BY CAST([LOCATION KEY] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_LOCATION_TYPE_REFERENCE ORDER BY CAST([LOCATION KEY] AS INT)
--select * from WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_DATA ORDER BY CAST([LOCATION KEY] AS INT),  CAST([ADDRESS DATA KEY] AS INT)
--select * from WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_LINE_DATA order BY CAST([LOCATION KEY] AS INT),  CAST([ADDRESS DATA KEY] AS INT),  CAST([ADDRESS LINE DATA KEY] AS INT) 
--select * from WD_HR_TR_AUTOMATED_LOCATION_SUB_MUNICIPALITY_DATA order BY CAST([LOCATION KEY] AS INT)
--select * from WD_HR_TR_AUTOMATED_LOCATION_REGION_SUBDIVISION_DATA  order BY CAST([LOCATION KEY] AS INT)
--select * from WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_REFERENCE order BY CAST([LOCATION KEY] AS INT)
--select * from WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY order BY CAST([Location Hierarchy Key] AS INT) 
--select * from WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_FLAT order BY CAST([Location Hierarchy Key] AS INT)
--SELECT DISTINCT * FROM NOVARTIS_DATA_MIGRATION_LOCATION_ERROR_LIST ORDER BY [LOCATION ID]
--SELECT DISTINCT * FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE Wave='P0' AND Report='Location' AND [Error Text] like '%Postal Code is missing;%'

--SELECT * FROM P0_LOCATION_SOURCE WHERE [LOCATION KEY]='31'
--SELECT * FROM P0_LOCATION_SOURCE WHERE [LOCATION ID]='JPFN'
--SELECT * FROM P0_LOCATION_SOURCE WHERE ISO3='NLD'
--SELECT * FROM WAVE_ADDRESS_VALIDATION WHERE [Country Code]='BEN'

--select * from WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY WHERE ISNULL([Location Hierarchy Reference ID], '')='' order BY CAST([Location Hierarchy Key] AS INT) 
--select * from WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_FLAT WHERE ISNULL([ID], '')='' order BY CAST([Location Hierarchy Key] AS INT)
 
--SELECT * FROM P0_LOCATION_SOURCE where [Location Key]='81' ORDER BY CAST([LOCATION KEY] AS INT)

	/****** Script to automate Location(Novartis Migration)  ******/
	BEGIN TRY 

		-- Set Address Validation table
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_ADDRESS_VALIDATION;';
		SELECT DISTINCT A1.* INTO WAVE_ADDRESS_VALIDATION 
		  FROM WAVE_ADDRESS_VALIDATION_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[Country2 Code]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]

		--Set Field Mapping table
		--UPDATE SET_ADDRESS_FIELD_MAPPING_FINAL SET FLAG='Basic'
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists SET_ADDRESS_FIELD_MAPPING_LC;';
		SELECT DISTINCT A1.* INTO SET_ADDRESS_FIELD_MAPPING_LC 
		  FROM SET_ADDRESS_FIELD_MAPPING_LOCATION_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[ISO2]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]
		  WHERE ISNULL(SRC_MAP_FIELD, '') <> '' AND ISNULL(DST_MAP_FIELD, '') <> ''
		DELETE FROM SET_ADDRESS_FIELD_MAPPING_LC WHERE ISNULL(ISO2, '') = ''

		/* Required Info type table */
		DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS P0_LOCATION_SOURCE;
                                       DROP TABLE IF EXISTS P0_LOCATION_SOURCE_TEMP;
		                               DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATIONS;
		                               DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_USAGE_REFERENCE;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_TYPE_REFERENCE;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_DATA;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_LINE_DATA;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_SUB_MUNICIPALITY_DATA;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_REGION_SUBDIVISION_DATA;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_REFERENCE;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY;
									   DROP TABLE IF EXISTS WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_FLAT;
									   DROP TABLE IF EXISTS NOVARTIS_DATA_MIGRATION_LOCATION_ERROR_LIST;
									   ';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		
		DECLARE @DefaultFlag AS VARCHAR(50)='No';
		DECLARE @LOCATION_SOURCE TABLE (
		      [LOCATION KEY]               NVARCHAR(2000),
			  [ADDRESS DATA KEY]           NVARCHAR(2000),
		      [LOCATION ID]                NVARCHAR(2000),
			  [LOCATION NAME]              NVARCHAR(2000),
			  [ISO3]                       NVARCHAR(2000),
			  [LOC_STREET1]                NVARCHAR(2000),
			  [LOC_STREET2]                NVARCHAR(2000),
			  [LOC_STREET3]                NVARCHAR(2000),
			  [LOC_STREET4]                NVARCHAR(2000),
			  [LOC_STREET5]                NVARCHAR(2000),
			  [LOC_STREET6]                NVARCHAR(2000),
			  [LOC_STREET7]                NVARCHAR(2000),
			  [LOC_STREET8]                NVARCHAR(2000),
			  [LOC_STREET9]                NVARCHAR(2000),
			  [LOC_TOWN]                   NVARCHAR(2000),
              [LOC_REGION]                 NVARCHAR(2000),
              [LOC_CITYSUBDIVISION_01]     NVARCHAR(2000),
			  [LOC_CITYSUBDIVISION_02]     NVARCHAR(2000),
              [LOC_REGIONSUBDIVISION_01]   NVARCHAR(2000),
			  [LOC_REGIONSUBDIVISION_02]   NVARCHAR(2000),
			  [MAIL_BOX]                   NVARCHAR(2000),
			  [BUSINESS UNIT CODE]         NVARCHAR(2000),
              [RNUM]                       NVARCHAR(2000) 
		);
		INSERT INTO @LOCATION_SOURCE
		SELECT DENSE_RANK() OVER(ORDER BY [LOCATION ID]) [LOCATION KEY], 
		       DENSE_RANK() OVER(PARTITION BY [LOCATION ID] ORDER BY [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [MAIL_BOX]) [ADDRESS DATA KEY], 
		       * FROM (
                   SELECT *, ROW_NUMBER() OVER(PARTITION BY [LOCATION ID] ORDER BY [LOCATION ID]) RNUM FROM (
                        SELECT DISTINCT 
                             RTRIM(LTRIM(ISNULL(A3.[Site Code], ''))) [LOCATION ID]
                            ,RTRIM(LTRIM(ISNULL(A3.[Site Text], '')))   [LOCATION NAME]
                            ,RTRIM(LTRIM(ISNULL((SELECT [ISO3] FROM COUNTRY_LKUP WHERE [ISO2]=A3.[ISO code]), ''))) ISO3  
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine1', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET1
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine2', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET2
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine3', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET3
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine4', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET4
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine5', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET5
							,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine6', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET6
							,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine7', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET7
							,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine8', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET8
							,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_addressLine9', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_STREET9
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_city', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_TOWN
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_region', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_REGION
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_city_subdivision_1', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_CITYSUBDIVISION_01
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_city_subdivision_2', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_CITYSUBDIVISION_02
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_Region_Subdivision_1', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_REGIONSUBDIVISION_01
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_Region_Subdivision_2', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) LOC_REGIONSUBDIVISION_02
                            ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A3.[ISO code], '_postalcode', 
							                                       A3.[Location Street 1], A3.[Location Street 2], A3.[Location Street 3], '', '', '', '', '', '',
																   A3.[Location Town],
																   IIF(A2.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''),
																   IIF(A2.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(A2.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
																   IIF(RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], '')))='', 
																         IIF(A2.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A2.[Postal Code Default Values], ''), '')), 
																		 RTRIM(LTRIM(ISNULL(A3.[Mail P.O. Box], ''))))
																   ), ''))) MAIL_BOX
                            ,RTRIM(LTRIM(ISNULL(A3.[BUSINESS UNIT CODE], ''))) [BUSINESS UNIT CODE]		   
                        FROM P0_YPAXX_SITE_CODE A3 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A2.[Country2 Code]=A3.[ISO code]
                        WHERE (A3.[End Date] >= CAST(@which_date as date) and A3.[Start Date] <= CAST(@which_date as date))
                   ) R1 			
		) A10 WHERE RNUM = 1
		--UPDATE WAVE_ADDRESS_VALIDATION_FINAL SET [Postal Code Default Values]='4096'
		--SELECT * FROM P0_LOCATION_SOURCE
		
		SELECT * INTO P0_LOCATION_SOURCE FROM @LOCATION_SOURCE
        SELECT * INTO P0_LOCATION_SOURCE_TEMP FROM @LOCATION_SOURCE
		/*
        UPDATE P0_LOCATION_SOURCE SET MAIL_BOX=IIF(SUBSTRING(MAIL_BOX, 1, LEN('P.O. BOX '))='P.O. BOX ', SUBSTRING(MAIL_BOX, LEN('P.O. BOX ')+2, LEN(MAIL_BOX)), MAIL_BOX)
        UPDATE P0_LOCATION_SOURCE SET MAIL_BOX=IIF(SUBSTRING(MAIL_BOX, 1, LEN('P.O.BOX '))='P.O.BOX ', SUBSTRING(MAIL_BOX, LEN('P.O.BOX ')+2, LEN(MAIL_BOX)), MAIL_BOX)

        UPDATE A1 SET LOC_STREET1= LOC_STREET2, LOC_STREET2=''
            FROM P0_LOCATION_SOURCE A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code] 
            WHERE A2.[Address Line #2]<>'Required' AND ISNULL(LOC_STREET1, '')=''

        UPDATE A1 SET LOC_STREET2= IIF(ISNULL(LOC_STREET2, '')='', LOC_STREET3, IIF(ISNULL(LOC_STREET3, '')='', '', ISNULL(LOC_STREET2, '')+','+ISNULL(LOC_STREET3, ''))), LOC_STREET3=''
            FROM P0_LOCATION_SOURCE A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code] 
            WHERE A2.[Address Line #3]='Not Accepted'

        UPDATE A1 SET LOC_STREET2= IIF(ISNULL(LOC_STREET2, '')='', LOC_TOWN, IIF(ISNULL(LOC_TOWN, '')='', '', ISNULL(LOC_STREET2, '')+','+ISNULL(LOC_TOWN, ''))), LOC_TOWN=''
            FROM P0_LOCATION_SOURCE A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code] 
            WHERE A2.[Municipality(City)]='Not Accepted'

        UPDATE A1 SET LOC_STREET2= IIF(ISNULL(LOC_STREET2, '')='', MAIL_BOX, IIF(ISNULL(MAIL_BOX, '')='', '', ISNULL(LOC_STREET2, '')+','+ISNULL(MAIL_BOX, ''))), MAIL_BOX=''
            FROM P0_LOCATION_SOURCE A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code] 
            WHERE A2.[Postal Code]='Not Accepted'

        UPDATE A1 SET LOC_STREET1= ISNULL(LOC_TOWN, '')
            FROM P0_LOCATION_SOURCE A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code] 
            WHERE ISNULL(LOC_STREET1, '') = '' AND ISNULL(LOC_STREET2, '') = '' AND ISNULL(LOC_STREET3, '') = ''
		*/

        /***** Location Validation Query Starts *****/
	    SELECT * INTO NOVARTIS_DATA_MIGRATION_LOCATION_ERROR_LIST FROM (
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'Address' [Error Type]
				  ,(
                     IIF(ISNULL([LOC_STREET1], '')='' AND ISNULL(A2.[Address Line #1], '')='Required', ' Address Line #1 is missing;', '')+
                     IIF(ISNULL([LOC_STREET1], '')<>'' AND ISNULL(A2.[Address Line #1], '')='Not Accepted', ' Address Line #1 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET2], '')='' AND ISNULL(A2.[Address Line #2], '')='Required', ' Address Line #2 is missing;', '')+
                     IIF(ISNULL([LOC_STREET2], '')<>'' AND ISNULL(A2.[Address Line #2], '')='Not Accepted', ' Address Line #2 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET3], '')='' AND ISNULL(A2.[Address Line #3], '')='Required', ' Address Line #3 is missing;', '')+
                     IIF(ISNULL([LOC_STREET3], '')<>'' AND ISNULL(A2.[Address Line #3], '')='Not Accepted', ' Address Line #3 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET4], '')='' AND ISNULL(A2.[Address Line #4], '')='Required', ' Address Line #4 is missing;', '')+
                     IIF(ISNULL([LOC_STREET4], '')<>'' AND ISNULL(A2.[Address Line #4], '')='Not Accepted', ' Address Line #4 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET5], '')='' AND ISNULL(A2.[Address Line 5], '')='Required', ' Address Line #5 is missing;', '')+
                     IIF(ISNULL([LOC_STREET5], '')<>'' AND ISNULL(A2.[Address Line 5], '')='Not Accepted', ' Address Line #5 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET6], '')='' AND ISNULL(A2.[Address Line 6], '')='Required', ' Address Line #6 is missing;', '')+
                     IIF(ISNULL([LOC_STREET6], '')<>'' AND ISNULL(A2.[Address Line 6], '')='Not Accepted', ' Address Line #6 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET7], '')='' AND ISNULL(A2.[Address Line 7], '')='Required', ' Address Line #7 is missing;', '')+
                     IIF(ISNULL([LOC_STREET7], '')<>'' AND ISNULL(A2.[Address Line 7], '')='Not Accepted', ' Address Line #7 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET8], '')='' AND ISNULL(A2.[Address Line 8], '')='Required', ' Address Line #8 is missing;', '')+
                     IIF(ISNULL([LOC_STREET8], '')<>'' AND ISNULL(A2.[Address Line 8], '')='Not Accepted', ' Address Line #8 must be empty;', '')+
                     IIF(ISNULL([LOC_STREET9], '')='' AND ISNULL(A2.[Address Line 9], '')='Required', ' Address Line #9 is missing;', '')+
                     IIF(ISNULL([LOC_STREET9], '')<>'' AND ISNULL(A2.[Address Line 9], '')='Not Accepted', ' Address Line #9 must be empty;', '')
                    ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			UNION ALL
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'City' [Error Type]
				  ,(
                     IIF(ISNULL([LOC_TOWN], '')='' AND ISNULL(A2.[Municipality(City)], '')='Required', ' Municipality(City) is missing;', '')+
                     IIF(ISNULL([LOC_TOWN], '')<>'' AND ISNULL(A2.[Municipality(City)], '')='Not Accepted', ' Municipality(City) must be empty;', '')
                   ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			UNION ALL
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'Region' [Error Type]
				  ,(
                     IIF(ISNULL([LOC_REGION], '')='' AND ISNULL(A2.[Region(State)], '')='Required', ' Region(State) is missing;', '')+
                     IIF(ISNULL([LOC_REGION], '')<>'' AND ISNULL(A2.[Region(State)], '')='Not Accepted', ' Region(State) must be empty;', '')
                   ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			UNION ALL
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'City Subdivision' [Error Type]
				  ,(
                     IIF(ISNULL([LOC_CITYSUBDIVISION_01], '')='' AND ISNULL(A2.[City Subdivision], '')='Required', ' City Subdivision 1 is missing;', '')+
                     IIF(ISNULL([LOC_CITYSUBDIVISION_01], '')<>'' AND ISNULL(A2.[City Subdivision], '')='Not Accepted', ' City Subdivision 1 must be empty;', '')+
                     IIF(ISNULL([LOC_CITYSUBDIVISION_02], '')='' AND ISNULL(A2.[City Subdivision 2], '')='Required', ' City Subdivision 2 is missing;', '')+
                     IIF(ISNULL([LOC_CITYSUBDIVISION_02], '')<>'' AND ISNULL(A2.[City Subdivision 2], '')='Not Accepted', ' City Subdivision 2 must be empty;', '')
                   ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			UNION ALL
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'Region Subdivision' [Error Type]
				  ,(
                     IIF(ISNULL([LOC_REGIONSUBDIVISION_01], '')='' AND ISNULL(A2.[Region Subdivision 1], '')='Required', ' Region Subdivision 1 is missing;', '')+
                     IIF(ISNULL([LOC_REGIONSUBDIVISION_01], '')<>'' AND ISNULL(A2.[Region Subdivision 1], '')='Not Accepted', ' Region Subdivision 1 must be empty;', '')+
                     IIF(ISNULL([LOC_REGIONSUBDIVISION_02], '')='' AND ISNULL(A2.[Region Subdivision 2], '')='Required', ' Region Subdivision 2 is missing;', '')+
                     IIF(ISNULL([LOC_REGIONSUBDIVISION_02], '')<>'' AND ISNULL(A2.[Region Subdivision 2], '')='Not Accepted', ' Region Subdivision 2 must be empty;', '')
                   ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			UNION ALL
			SELECT @which_wavestage Wave
		          ,@which_report Report
				  ,[LOCATION ID]+'( '+[LOCATION KEY]+' )' [Location ID]
				  ,A2.[Country] [Country Name]
				  ,A1.[ISO3] [Country ISO3 Code]
				  ,'Postal Code' [Error Type]
				  ,(
                     IIF(ISNULL([MAIL_BOX], '')='' AND (ISNULL(A2.[Postal Code], '')='Required'), ' Postal Code is missing;', '')+
                     IIF(ISNULL([MAIL_BOX], '')<>'' AND ISNULL(A2.[Postal Code], '')='Not Accepted', ' Postal Code must be empty;', '')+
                     IIF(ISNULL([MAIL_BOX], '')<>'' AND ISNULL(A2.[Postal Code], '')='Required' OR ISNULL(A2.[Postal Code], '')='Optional', 
					        dbo.CheckPostalCode('', ISNULL([MAIL_BOX], ''), ISNULL(A2.[Postal Code Validations], '')), '')
                   ) ErrorText
			FROM P0_LOCATION_SOURCE A1 
            LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
			) c WHERE ErrorText <> '';
        
		/*
        UPDATE A2 SET [MAIL_BOX]=A3.[Postal Code Default Values]
            FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST A1 
                  LEFT JOIN P0_LOCATION_SOURCE A2 ON A1.[Country Code]=A2.[ISO3]
                  LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.[Country Code]=A3.[Country Code]
            WHERE A1.Wave='P0' AND Report='Location' AND A1.[Error Text] like '%:Postal%' AND 
                  A2.[LOCATION KEY] = SUBSTRING(A1.[Employee ID], 1, CHARINDEX('(', A1.[Employee ID], 1)-1) AND
                  A2.[LOCATION ID] = SUBSTRING(A1.[Employee ID], CHARINDEX('(', A1.[Employee ID], 1)+2, 4);
        IF (@@ROWCOUNT >= 1)
        BEGIN
            /***** Location Validation Query Starts *****/
            DELETE FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE WAVE=@which_wavestage AND [Report]=@which_report
            INSERT INTO NOVARTIS_DATA_MIGRATION_ERROR_LIST
            SELECT * FROM (
                SELECT @which_wavestage Wave
                    ,@which_report Report
                    ,[LOCATION KEY]+'( '+[LOCATION ID]+' )' [Employee ID]
                    ,A1.[ISO3] [Country Code]
                    ,(
                        IIF(ISNULL([LOC_STREET1], '')='' AND ISNULL(A2.[Address Line #1], '')='Required', ' Address Line #1 is missing;', '')+
                        IIF(ISNULL([LOC_STREET1], '')<>'' AND ISNULL(A2.[Address Line #1], '')='Not Accepted', ' Address Line #1 must be empty;', '')+
                        IIF(ISNULL([LOC_STREET2], '')='' AND ISNULL(A2.[Address Line #2], '')='Required', ' Address Line #2 is missing;', '')+
                        IIF(ISNULL([LOC_STREET2], '')<>'' AND ISNULL(A2.[Address Line #2], '')='Not Accepted', ' Address Line #2 must be empty;', '')+
                        IIF(ISNULL([LOC_STREET3], '')='' AND ISNULL(A2.[Address Line #3], '')='Required', ' Address Line #3 is missing;', '')+
                        IIF(ISNULL([LOC_STREET3], '')<>'' AND ISNULL(A2.[Address Line #3], '')='Not Accepted', ' Address Line #3 must be empty;', '')+
                        IIF(ISNULL([LOC_TOWN], '')='' AND ISNULL(A2.[Municipality(City)], '')='Required', ' Municipality(City) is missing;', '')+
                        IIF(ISNULL([LOC_TOWN], '')<>'' AND ISNULL(A2.[Municipality(City)], '')='Not Accepted', ' Municipality(City) must be empty;', '')+
                        IIF(ISNULL([MAIL_BOX], '')='' AND ISNULL(A2.[Postal Code], '')='Required', ' Postal Code is missing;', '')+
                        IIF(ISNULL([MAIL_BOX], '')<>'' AND ISNULL(A2.[Postal Code], '')='Not Accepted', ' Postal Code must be empty;', '')+
                        IIF(ISNULL([MAIL_BOX], '')<>'' AND ISNULL(A2.[Postal Code], '')='Required', dbo.CheckPostalCode('', ISNULL([MAIL_BOX], ''), ISNULL(A2.[Postal Code Validations], '')), '')
                        ) ErrorText
                FROM P0_LOCATION_SOURCE A1 
                LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]) c WHERE ErrorText <> '';
        END
		*/

		DECLARE @LOCATION TABLE(
			[Location Key]                                              NVARCHAR(2000),
			[Add Only]                                                  NVARCHAR(2000),
			[Location Reference Descriptor]                             NVARCHAR(2000),
			[Location Reference ID type]                                NVARCHAR(2000),
			[Location Reference ID]                                     NVARCHAR(2000),
			[Location ID]                                               NVARCHAR(2000),
			[Effective Date]                                            NVARCHAR(2000),
			[Location Name]                                             NVARCHAR(2000),
			[Superior Location Reference Descriptor]                    NVARCHAR(2000),
			[Superior Location Reference ID type]                       NVARCHAR(2000),
			[Superior Location Reference ID]                            NVARCHAR(2000),
			[Inactive]                                                  NVARCHAR(2000),
			[Latitude]                                                  NVARCHAR(2000),
			[Longitude]                                                 NVARCHAR(2000),
			[Altitude]                                                  NVARCHAR(2000),
			[Time Profile Reference Descriptor]                         NVARCHAR(2000),
			[Time Profile Reference ID type]                            NVARCHAR(2000),
			[Time Profile Reference ID]                                 NVARCHAR(2000),
			[Locale Reference Descriptor]                               NVARCHAR(2000),
			[Locale Reference ID type]                                  NVARCHAR(2000),
			[Locale Reference ID]                                       NVARCHAR(2000),
			[Display Language Reference Descriptor]                     NVARCHAR(2000),
			[Display Language Reference ID type]                        NVARCHAR(2000),
			[Display Language Reference ID]                             NVARCHAR(2000),
			[Time Zone Reference Descriptor]                            NVARCHAR(2000),
			[Time Zone Reference ID type]                               NVARCHAR(2000),
			[Time Zone Reference ID]                                    NVARCHAR(2000),
			[Default Currency Reference Descriptor]                     NVARCHAR(2000),
			[Default Currency Reference ID type]                        NVARCHAR(2000),
			[Default Currency Reference ID]                             NVARCHAR(2000),
			[External Name]                                             NVARCHAR(2000),
			[Default Job Posting Location Reference Descriptor]         NVARCHAR(2000),
			[Default Job Posting Location Reference ID type]            NVARCHAR(2000),
			[Default Job Posting Location Reference ID]                 NVARCHAR(2000),
			[Trade Name]                                                NVARCHAR(2000),
			[Worksite ID Code]                                          NVARCHAR(2000),
			[Global Location Number]                                    NVARCHAR(2000),
			[Location Identifier]                                       NVARCHAR(2000),
			[Academic Unit Reference Descriptor]                        NVARCHAR(2000),
			[Academic Unit Reference ID type]                           NVARCHAR(2000),
			[Academic Unit Reference ID]                                NVARCHAR(2000),
			[Instructional Site Data Capacity]                          NVARCHAR(2000),
			[Off-Site]                                                  NVARCHAR(2000),
			[Instructional Use Only]                                    NVARCHAR(2000)
		)

		INSERT INTO @LOCATION
			   SELECT 
			     A6.[LOCATION KEY] [Location Key]
				,'TRUE' [Add Only]
				,''[Location Reference Descriptor]
				,''[Location Reference ID type]
				,''[Location Reference ID]
				,[LOCATION ID] [Location ID]
				,''[Effective Date]
				,[LOCATION NAME] [Location Name]
				,''[Superior Location Reference Descriptor]
				,''[Superior Location Reference ID type]
				,''[Superior Location Reference ID]
				,'FALSE' [Inactive]
				,''[Latitude]
				,''[Longitude]
				,''[Altitude]
				,''[Time Profile Reference Descriptor]
				,'Time_Profile_ID'[Time Profile Reference ID type]
				,'Standard_Hours_40'[Time Profile Reference ID]
				,''[Locale Reference Descriptor]
				,'Locale_ID'[Locale Reference ID type]
				,'en_US'[Locale Reference ID]
				,''[Display Language Reference Descriptor]
				,'User_Language_ID'[Display Language Reference ID type]
				,'en_US'[Display Language Reference ID]
				,''[Time Zone Reference Descriptor]
				,'Time_Zone_ID'[Time Zone Reference ID type]
				,'GMT'[Time Zone Reference ID]
				,''[Default Currency Reference Descriptor]
				,''[Default Currency Reference ID type]
				,''[Default Currency Reference ID]
				,''[External Name]
				,''[Default Job Posting Location Reference Descriptor]
				,''[Default Job Posting Location Reference ID type]
				,''[Default Job Posting Location Reference ID]
				,''[Trade Name]
				,''[Worksite ID Code]
				,''[Global Location Number]
				,''[Location Identifier]
				,''[Academic Unit Reference Descriptor]
				,''[Academic Unit Reference ID type]
				,''[Academic Unit Reference ID]
				,''[Instructional Site Data Capacity]
				,''[Off-Site]
				,''[Instructional Use Only]
	    FROM (SELECT DISTINCT [LOCATION KEY], [LOCATION ID], [LOCATION NAME] FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATIONS FROM @LOCATION

		DECLARE @LOCATION_USAGE_REFERENCE TABLE(
			[Location Key]                      NVARCHAR(2000),
			[Location Usage Reference Key]      NVARCHAR(2000),
			[Descriptor]                        NVARCHAR(2000),
			[ID type]                           NVARCHAR(2000),
			[ID]                                NVARCHAR(2000)
		);

		INSERT INTO @LOCATION_USAGE_REFERENCE
		SELECT
			 [LOCATION KEY] [Location Key]
			,ROW_NUMBER() OVER(PARTITION BY [Location Key] ORDER BY [Location Key]) [Location Usage Reference Key]
			,''[Descriptor]
			,'Location_Usage_ID' [ID type]
			,'BUSINESS SITE'[ID]
		FROM (SELECT DISTINCT [LOCATION KEY], [LOCATION ID], [LOCATION NAME] FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_USAGE_REFERENCE FROM @LOCATION_USAGE_REFERENCE

		DECLARE @LOCATION_TYPE_REFERENCE TABLE(
			[Location Key]                   NVARCHAR(2000),
			[Location Type Reference Key]    NVARCHAR(2000),
			[Descriptor]                     NVARCHAR(2000),
			[ID type]                        NVARCHAR(2000),
			[ID]                             NVARCHAR(2000)
		)

		INSERT INTO @LOCATION_TYPE_REFERENCE
		SELECT
			 [LOCATION KEY] [Location Key]
			,ROW_NUMBER() OVER(PARTITION BY [Location Key] ORDER BY [Location Key]) [Location Type Reference Key]
			,''[Descriptor]
			,'Location_Type_ID' [ID type]
			,'Local Office' [ID]
		FROM (SELECT DISTINCT [LOCATION KEY], [LOCATION ID], [LOCATION NAME] FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_TYPE_REFERENCE FROM @LOCATION_TYPE_REFERENCE

		DECLARE @ADDRESS_DATA TABLE(
			[Location Key]                              NVARCHAR(2000),
			[Address Data Key]                          NVARCHAR(2000),
			[Formatted Address]                         NVARCHAR(2000),
			[Address Format Type]                       NVARCHAR(2000),
			[Defaulted Business Site Address]           NVARCHAR(2000),
			[Delete]                                    NVARCHAR(2000),
			[Do Not Replace All]                        NVARCHAR(2000),
			[Effective Date]                            NVARCHAR(2000),
			[Country Reference Descriptor]              NVARCHAR(2000),
			[Country Reference ID type]                 NVARCHAR(2000),
			[Country Reference ID]                      NVARCHAR(2000),
			[Last Modified]                             NVARCHAR(2000),
			[Municipality]                              NVARCHAR(2000),
			[Country City Reference Descriptor]         NVARCHAR(2000),
			[Country City Reference ID type]            NVARCHAR(2000),
			[Country City Reference ID]                 NVARCHAR(2000),
			[Country City Reference ID parent type]     NVARCHAR(2000),
			[Country City Reference ID parent id]       NVARCHAR(2000),
			[Country Region Reference Descriptor]       NVARCHAR(2000),
			[Country Region Reference ID type]          NVARCHAR(2000),
			[Country Region Reference ID]               NVARCHAR(2000),
			[Country Region Descriptor]                 NVARCHAR(2000),
			[Postal Code]                               NVARCHAR(2000),
			[Public]                                    NVARCHAR(2000),
			[Primary]                                   NVARCHAR(2000),
			[Type Reference Descriptor]                 NVARCHAR(2000),
			[Type Reference ID type]                    NVARCHAR(2000),
			[Type Reference ID]                         NVARCHAR(2000),
			[Comments]                                  NVARCHAR(2000),
			[Number of Days]                            NVARCHAR(2000),
			[Municipality Local]                        NVARCHAR(2000),
			[Address Reference Descriptor]              NVARCHAR(2000),
			[Address Reference ID type]                 NVARCHAR(2000),
			[Address Reference ID]                      NVARCHAR(2000),
			[Address ID]                                NVARCHAR(2000)
		);

		INSERT INTO @ADDRESS_DATA
		SELECT
			 [LOCATION KEY] [Location Key]
			,ROW_NUMBER() OVER(PARTITION BY [Location Key] ORDER BY [Location Key]) [Address Data Key]
			,''[Formatted Address]
			,''[Address Format Type]
			,''[Defaulted Business Site Address]
			,''[Delete]
			,''[Do Not Replace All]
			,'2000-01-01' [Effective Date]
			,''[Country Reference Descriptor]
			,'ISO_3166-1_Alpha-3_Code'[Country Reference ID type]
			,ISO3 [Country Reference ID]
			,''[Last Modified]
			,ISNULL(LOC_TOWN, '') [Municipality]
			,''[Country City Reference Descriptor]
			,''[Country City Reference ID type]
			,''[Country City Reference ID]
			,''[Country City Reference ID parent type]
			,''[Country City Reference ID parent id]
			,''[Country Region Reference Descriptor]
			,IIF(ISNULL([LOC_REGION], '')='', '', 'Country_Region_ID') [Country Region Reference ID type]
			,ISNULL([LOC_REGION], '') [Country Region Reference ID]
			,''[Country Region Descriptor]
			,ISNULL(MAIL_BOX, '') [Postal Code]
			,'TRUE'[Public]
			,'TRUE'[Primary]
			,''[Type Reference Descriptor]
			,'Communication_Usage_Type_ID' [Type Reference ID type]
			,'Business' [Type Reference ID]
			,''[Comments]
			,''[Number of Days]
			,''[Municipality Local]
			,''[Address Reference Descriptor]
			,''[Address Reference ID type]
			,''[Address Reference ID]
			,''[Address ID]
		FROM (SELECT DISTINCT [ISO3], [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [LOC_REGION], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_DATA FROM @ADDRESS_DATA
        --SELECT * FROM WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_DATA

		DECLARE @ADDRESS_LINE_DATA TABLE(
			[Location Key]                  NVARCHAR(2000),
			[Address Data Key]              NVARCHAR(2000),
			[Address Line Data Key]         NVARCHAR(2000),
			[Address Line Data Descriptor]  NVARCHAR(2000),
			[Address Line Data Type]        NVARCHAR(2000),
			[Address Line Data]             NVARCHAR(2000)
		)

		INSERT INTO @ADDRESS_LINE_DATA
		SELECT
		     [LOCATION KEY] [Location Key]
			,[Address Data Key]
			,ROW_NUMBER() OVER(PARTITION BY [Location Key], [Address Data Key] ORDER BY [Location Key], [Address Data Key]) [Address Line Data Key]
			,''[Address Line Data Descriptor]
			,[Address Line Data Type]
			,ISNULL([LOC_STREET], '') [Address Line Data]
        FROM (
		    SELECT * FROM (
				SELECT
					 [LOCATION KEY] [Location Key]
					,[ADDRESS DATA KEY] [Address Data Key]
					,'ADDRESS_LINE_' [Address Line Data Type]
					,ISNULL([LOC_STREET1], '') [LOC_STREET]
				FROM (SELECT DISTINCT [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) ADDR1
				UNION ALL
				SELECT
					 [LOCATION KEY] [Location Key]
					,[ADDRESS DATA KEY] [Address Data Key]
					,'ADDRESS_LINE_' [Address Line Data Type]
					,ISNULL([LOC_STREET2], '') [LOC_STREET]
				FROM (SELECT DISTINCT [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) ADDR2
				UNION ALL
				SELECT
					 [LOCATION KEY] [Location Key]
					,[ADDRESS DATA KEY] [Address Data Key]
					,'ADDRESS_LINE_' [Address Line Data Type]
					,ISNULL([LOC_STREET3], '') [LOC_STREET]
				FROM (SELECT DISTINCT [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) ADDR3
			) A7 WHERE ISNULL([LOC_STREET], '') <> ''
		) A8

		UPDATE @ADDRESS_LINE_DATA SET [Address Line Data Type]=[Address Line Data Type]+[Address Line Data Key];
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_ADDRESS_LINE_DATA FROM @ADDRESS_LINE_DATA

		DECLARE @SUB_MUNICIPALITY_DATA TABLE(
			[Location Key]                                  NVARCHAR(2000),
			[Address Data Key]                              NVARCHAR(2000),
			[Submunicipality Data Key]                      NVARCHAR(2000),
			[Submunicipality Data Address Component Name]   NVARCHAR(2000),
			[Submunicipality Data Type]                     NVARCHAR(2000),
			[Submunicipality Data]                          NVARCHAR(2000)
		)

		INSERT INTO @SUB_MUNICIPALITY_DATA
		SELECT
			 [LOCATION KEY] [Location Key]
			,[Address Data Key]
			,'1'[Submunicipality Data Key]
			,''[Submunicipality Data Address Component Name]
			,IIF(LOC_CITYSUBDIVISION_01='', '', 'CITY_SUBDIVISION_1') [Submunicipality Data Type]
			,ISNULL(LOC_CITYSUBDIVISION_01, '') [Submunicipality Data]
		FROM (SELECT DISTINCT [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [LOC_CITYSUBDIVISION_01], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_SUB_MUNICIPALITY_DATA FROM @SUB_MUNICIPALITY_DATA WHERE [Submunicipality Data]<>''

		DECLARE @REGION_SUBDIVISION_DATA TABLE(
			[Location Key]                  NVARCHAR(2000),
			[Address Data Key]              NVARCHAR(2000),
			[Subregion Data Key]            NVARCHAR(2000),
			[Subregion Data Descriptor]     NVARCHAR(2000),
			[Subregion Data Type]           NVARCHAR(2000),
			[Subregion Data]                NVARCHAR(2000)
		)

		INSERT INTO @REGION_SUBDIVISION_DATA
		SELECT
			 [LOCATION KEY]  [Location Key]
			,[Address Data Key]
			,'1' [Subregion Data Key]
			,''[Subregion Data Descriptor]
			,IIF(LOC_REGIONSUBDIVISION_01='', '','REGION_SUBDIVISION_1') [Subregion Data Type]
			,ISNULL([LOC_REGIONSUBDIVISION_01], '') [Subregion Data]
		FROM (SELECT DISTINCT [LOCATION KEY], [ADDRESS DATA KEY], [LOC_STREET1], [LOC_STREET2], [LOC_STREET3], [LOC_TOWN], [LOC_REGIONSUBDIVISION_01], [MAIL_BOX]  FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_REGION_SUBDIVISION_DATA FROM @REGION_SUBDIVISION_DATA WHERE [Subregion Data]<>''


		DECLARE @LOCATION_HIERARCHY_REFERENCE TABLE(
			[Location Key]                       NVARCHAR(2000),
			[Location Hierarchy Reference Key]   NVARCHAR(2000),
			[Descriptor]                         NVARCHAR(2000),
			[ID type]                            NVARCHAR(2000),
			[ID]                                 NVARCHAR(2000)
		);

		INSERT INTO @LOCATION_HIERARCHY_REFERENCE
		SELECT
			 [LOCATION KEY] [Location Key]
			,ROW_NUMBER() OVER(PARTITION BY [Location Key] ORDER BY [Location Key]) [Location Hierarchy Reference Key]
			,''[Descriptor]
			,'Organization_Reference_ID' [ID type]
			,[LOCATION ID] [ID]
		FROM (SELECT * FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_REFERENCE FROM @LOCATION_HIERARCHY_REFERENCE

		DECLARE @LOCATION_HIERARCHY TABLE(
			[Location Hierarchy Key]                            NVARCHAR(2000),
			[Add Only]                                          NVARCHAR(2000),
			[Location Hierarchy Reference Descriptor]           NVARCHAR(2000),
			[Location Hierarchy Reference ID type]              NVARCHAR(2000),
			[Location Hierarchy Reference ID]                   NVARCHAR(2000),
			[Effective Date]                                    NVARCHAR(2000),
			[ID]                                                NVARCHAR(2000),
			[Include Organization ID in Name]                   NVARCHAR(2000),
			[Organization Name]                                 NVARCHAR(2000),
			[Phonetic Name]                                     NVARCHAR(2000),
			[Organization Code]                                 NVARCHAR(2000),
			[Include Organization Code in Name]                 NVARCHAR(2000),
			[Organization Active]                               NVARCHAR(2000),
			[Availability Date]                                 NVARCHAR(2000),
			[Organization Visibility Reference Descriptor]      NVARCHAR(2000),
			[Organization Visibility Reference ID type]         NVARCHAR(2000),
			[Organization Visibility Reference ID]              NVARCHAR(2000),
			[External URL Reference Descriptor]                 NVARCHAR(2000),
			[External URL Reference ID type]                    NVARCHAR(2000),
			[External URL Reference ID]                         NVARCHAR(2000),
			[Organization Subtype Reference Descriptor]         NVARCHAR(2000),
			[Organization Subtype Reference ID type]            NVARCHAR(2000),
			[Organization Subtype Reference ID]                 NVARCHAR(2000),
			[Location Hierarchy Superior Reference Descriptor]  NVARCHAR(2000),
			[Location Hierarchy Superior Reference ID type]     NVARCHAR(2000),
			[Location Hierarchy Superior Reference ID]          NVARCHAR(2000)
		);

		INSERT INTO @LOCATION_HIERARCHY
		SELECT
			 [LOCATION KEY] [Location Hierarchy Key]
			,'FALSE' [Add Only]
			,''[Location Hierarchy Reference Descriptor]
			,'Organization_Reference_ID' [Location Hierarchy Reference ID type]
			,[LOCATION ID] [Location Hierarchy Reference ID]
			,'1900-01-01'[Effective Date]
			,[LOCATION ID] [ID]
			,'FALSE' [Include Organization ID in Name]
			,[LOCATION NAME] [Organization Name]
			,''[Phonetic Name]
			,''[Organization Code]
			,'FALSE' [Include Organization Code in Name]
			,'TRUE' [Organization Active]
			,'1900-01-01' [Availability Date]
			,''[Organization Visibility Reference Descriptor]
			,'WID' [Organization Visibility Reference ID type]
			,'9c875610c4fc496499e39741b6541dbc' [Organization Visibility Reference ID]
			,''[External URL Reference Descriptor]
			,''[External URL Reference ID type]
			,''[External URL Reference ID]
			,''[Organization Subtype Reference Descriptor]
			,'Organization_Subtype_ID' [Organization Subtype Reference ID type]
			,''[Organization Subtype Reference ID]
			,''[Location Hierarchy Superior Reference Descriptor]
			,'Organization_Reference_ID'[Location Hierarchy Superior Reference ID type]
			,[ISO3] [Location Hierarchy Superior Reference ID]
		FROM (SELECT DISTINCT [LOCATION KEY], [LOCATION ID], [LOCATION NAME], [ISO3] FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY FROM @LOCATION_HIERARCHY

		DECLARE @LOCATION_HIERARCHY_FLAT TABLE(
			[Location Hierarchy Key]                              NVARCHAR(2000),
			[Add Only]                                            NVARCHAR(2000),
			[Location Hierarchy Reference Descriptor]             NVARCHAR(2000),
			[Location Hierarchy Reference ID type]                NVARCHAR(2000),
			[Location Hierarchy Reference ID]                     NVARCHAR(2000),
			[Effective Date]                                      NVARCHAR(2000),
			[ID]                                                  NVARCHAR(2000),
			[Include Organization ID in Name]                     NVARCHAR(2000),
			[Organization Name]                                   NVARCHAR(2000),
			[Phonetic Name]                                       NVARCHAR(2000),
			[Organization Code]                                   NVARCHAR(2000),
			[Include Organization Code in Name]                   NVARCHAR(2000),
			[Organization Active]                                 NVARCHAR(2000),
			[Availability Date]                                   NVARCHAR(2000),
			[Organization Visibility Reference Descriptor]        NVARCHAR(2000),
			[Organization Visibility Reference ID type]           NVARCHAR(2000),
			[Organization Visibility Reference ID]                NVARCHAR(2000),
			[External URL Reference Descriptor]                   NVARCHAR(2000),
			[External URL Reference ID type]                      NVARCHAR(2000),
			[External URL Reference ID]                           NVARCHAR(2000),
			[Organization Subtype Reference Descriptor]           NVARCHAR(2000),
			[Organization Subtype Reference ID type]              NVARCHAR(2000),
			[Organization Subtype Reference ID]                   NVARCHAR(2000),
			[Location Hierarchy Superior Reference Descriptor]    NVARCHAR(2000),
			[Location Hierarchy Superior Reference ID type]       NVARCHAR(2000),
			[Location Hierarchy Superior Reference ID]            NVARCHAR(2000)
		);

		INSERT INTO @LOCATION_HIERARCHY_FLAT
		SELECT
			 [LOCATION KEY] [Location Hierarchy Key]
			,'TRUE' [Add Only]
			,''[Location Hierarchy Reference Descriptor]
			,''[Location Hierarchy Reference ID type]
			,''[Location Hierarchy Reference ID]
			,'1900-01-01'[Effective Date]
			,[LOCATION ID] [ID]
			,'FALSE' [Include Organization ID in Name]
			,[LOCATION NAME] [Organization Name]
			,''[Phonetic Name]
			,''[Organization Code]
			,'FALSE' [Include Organization Code in Name]
			,'TRUE' [Organization Active]
			,'1900-01-01' [Availability Date]
			,''[Organization Visibility Reference Descriptor]
			,'WID' [Organization Visibility Reference ID type]
			,'9c875610c4fc496499e39741b6541dbc' [Organization Visibility Reference ID]
			,''[External URL Reference Descriptor]
			,''[External URL Reference ID type]
			,''[External URL Reference ID]
			,''[Organization Subtype Reference Descriptor]
			,'Organization_Subtype_ID' [Organization Subtype Reference ID type]
			,'Global_Region' [Organization Subtype Reference ID]
			,''[Location Hierarchy Superior Reference Descriptor]
			,''[Location Hierarchy Superior Reference ID type]
			,''[Location Hierarchy Superior Reference ID]
		FROM (SELECT DISTINCT [LOCATION KEY], [LOCATION ID], [LOCATION NAME] FROM P0_LOCATION_SOURCE) A6
		SELECT * INTO WD_HR_TR_AUTOMATED_LOCATION_HIERARCHY_FLAT FROM @LOCATION_HIERARCHY_FLAT

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


--UPDATE A2 SET [Postal Code Default Values]=A1.DefaultValues
--    FROM (
--    SELECT [COUNTRY CODE], (CASE 
--    WHEN ([Postal Code Validations]='Postal code must be 1 letter followed by 4 digits and 3 letters The 3 letters at the end are optional') THEN 'A0000XXX'
--    WHEN ([Postal Code Validations]='Postal code must be 4 digits') THEN '0000'
--    WHEN ([Postal Code Validations]='Postal code must be 4 digits followed by 2 letters. A space is allowed after the 4th digit') THEN 'AA0000'
--	WHEN ([Postal Code Validations]='Postal code must be 4 digits, may be proceeded by ''B-'' or ''S-''') THEN 'B-0000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits. A dash is allowed after the 2nd digit') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits. A space is allowed after the 3rd digit') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits, may be preceeded by ''LT''') THEN 'LT00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits or ZIP+4 format (#####-####)') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 or 7 digits') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 6 digits') THEN '000000'
--    WHEN ([Postal Code Validations]='Postal code must be 6 digits, may be preceeded by ''LV''') THEN '000000'
--    WHEN ([Postal Code Validations]='Postal code must be 6 digits. A dash is allowed after the 3rd digit') THEN '000000'
--    WHEN ([Postal Code Validations]='Postal code must be 6 digits. A space is allowed after the 3rd digit') THEN '000000'
--    WHEN ([Postal Code Validations]='Postal code must be 7 digits. A dash is allowed after the 3rd digit') THEN '0000000'
--    WHEN ([Postal Code Validations]='Postal code must be 7 digits. A dash is allowed after the 4th digit') THEN '0000000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits or 8 digits') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 7 characters in the format (A#A #A#)') THEN 'A#A A#A'
--	WHEN ([Postal Code Validations]='Postal code must be 6 characters in the format (A#A #A#)') THEN 'A#A#A#'
--	WHEN ([Postal Code Validations]='Postal code must be 5 digits or 6 digits with an optional dash after the third') THEN '00000'
--	WHEN ([Postal Code Validations]='Postal code must be 3 or 5 digits') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 or 8 digits') THEN '00000'
--    WHEN ([Postal Code Validations]='Postal code must be 4 digits, may be preceeded by ''AZ''') THEN 'AZ0000'
--    WHEN ([Postal Code Validations]='Postal code must be 5 digits, may be preceeded by ''BB''') THEN 'BB00000'
--    WHEN ([Postal Code Validations]='Postal code must be 4 characters, first 2 characters must be letters') THEN 'AZ0000'
--    WHEN ([Postal Code Validations]='Postal code must be 7 digits. A dash is allowed after the third digit') THEN '0000000'
--    WHEN ([Postal Code Validations]='Postal code must be 4 digits, may be preceeded by ''SI''') THEN 'SI0000'
--    WHEN ([Postal Code Validations]='Postal code must be 6 characters and in following format (A#A #A#)') THEN 'A#A#A#'
--    ELSE '0000'
--    END) DefaultValues
--    FROM WAVE_ADDRESS_VALIDATION) A1
--    LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[Country Code]=A2.[Country Code]

--UPDATE WAVE_ADDRESS_VALIDATION SET [Postal Code Validations]='Postal code must be 4 digits' WHERE [Country Code]='MYS'
/*
SELECT * FROM WAVE_ADDRESS_VALIDATION

SELECT DISTINCT A1.[Country Code], A2.[Postal Code], A2.[Postal Code Validations], [Postal Code Default Values]
  FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[Country Code]=A2.[Country Code]
  WHERE A1.Wave='P0' AND Report='Location' AND [Error Text] like '%Postal Code is missing;%'

SELECT DISTINCT A1.[Country Code], A2.[MAIL_BOX], A2.[Location Key], A2.[Location ID]
  FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST A1 LEFT JOIN P0_LOCATION_SOURCE A2 ON A1.[Country Code]=A2.[ISO3]
  WHERE A1.Wave='P0' AND Report='Location' AND SUBSTRING(A2.MAIL_BOX, 1, 4) <> '0000'

UPDATE A2 SET [MAIL_BOX]=''
  FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST A1 LEFT JOIN P0_LOCATION_SOURCE A2 ON A1.[Country Code]=A2.[ISO3]
  WHERE A1.Wave='P0' AND Report='Location' AND SUBSTRING(A2.MAIL_BOX, 1, 4) <> '0000'

SELECT * FROM P0_LOCATION_SOURCE WHERE Mail_BOX like '%P.O.Box %'  
SELECT * FROM P0_LOCATION_SOURCE WHERE Mail_BOX like 'P%'  
SELECT * FROM P0_LOCATION_SOURCE WHERE [ISO3]='KWT'


*/