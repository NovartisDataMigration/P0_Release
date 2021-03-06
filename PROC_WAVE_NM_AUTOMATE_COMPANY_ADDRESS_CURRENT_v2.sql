USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS_CURRENT]    Script Date: 22.07.2021 09:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS_CURRENT]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
    --EXEC [PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS_CURRENT] 'GV', 'Company', '2021-03-10';
	--SELECT * FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS ORDER BY SNo, [Address No]
	--SELECt * FROM NOVARTIS_DATA_MIGRATION_COMPANY_ERROR_LIST ORDER BY [Address No]
	--Select * from WAVE_NM_COMPANY_DGW_COMPANY
	--Select * from WAVE_NM_COMPANY_DGW_Organization_Container
	--Select * from WAVE_NM_COMPANY_DGW_Address_Data
	--Select * from WAVE_NM_COMPANY_DGW_Address_LINE_Data
	--Select * from WAVE_NM_COMPANY_DGW_Submunicipality_Data
	--Select * from WAVE_NM_COMPANY_DGW_Subregion_Data
	--Select * from WAVE_NM_COMPANY_DGW_TaxID_Data
	--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_LC

	DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS;
	                               Drop table if exists WAVE_NM_COMPANY_DGW_T001_source2;
								   Drop table if exists WAVE_NM_COMPANY_DGW_T001;
								   Drop table if exists NOVARTIS_DATA_MIGRATION_COMPANY_ERROR_LIST
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_COMPANY
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_Organization_Container
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_Address_Data
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_Address_LINE_Data
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_Submunicipality_Data
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_Subregion_Data
								   DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_TaxID_Data';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	-- Set Address Validation table
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_ADDRESS_VALIDATION;';
	SELECT DISTINCT A1.* INTO WAVE_ADDRESS_VALIDATION 
		FROM WAVE_ADDRESS_VALIDATION_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[Country2 Code]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]

	--Set Field Mapping table
	--UPDATE SET_ADDRESS_FIELD_MAPPING_FINAL SET FLAG='Basic'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists SET_ADDRESS_FIELD_MAPPING_LC;';
	SELECT DISTINCT A1.* INTO SET_ADDRESS_FIELD_MAPPING_LC 
		FROM SET_ADDRESS_FIELD_MAPPING_COMPANY_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[ISO2]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]
		WHERE ISNULL(SRC_MAP_FIELD, '') <> '' AND ISNULL(DST_MAP_FIELD, '') <> ''
	DELETE FROM SET_ADDRESS_FIELD_MAPPING_LC WHERE ISNULL(ISO2, '') = ''

	SET @SQL='DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_T001_source;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_COMPANY_DGW_T001_source FROM '+@which_wavestage+'_T001_SOURCE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	--SELECT * INTO GV_T001_SOURCE FROM P0_T001_SOURCE

	SET @SQL='DROP TABLE IF EXISTS WAVE_NM_COMPANY_DGW_ADRC;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_COMPANY_DGW_ADRC FROM '+@which_wavestage+'_ADRC;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	--SELECT * INTO GV_ADRC FROM P0_ADRC

	select * into WAVE_NM_COMPANY_DGW_T001_source2
	from WAVE_NM_COMPANY_DGW_T001_source
	where [CoCd] not in ('AEE0',
	'AME0',
	'AT32',
	'BAE0',
	'BE02',
	'BE14',
	'BG02',
	'BHB0',
	'BYE0',
	'C220',
	'C222',
	'C223',
	'C224',
	'C254',
	'CZ08',
	'D104',
	'D105',
	'DE07',
	'DK13',
	'EEE0',
	'EGE0',
	'ESA6',
	'FIE0',
	'FR56',
	'GEE0',
	'GR08',
	'HR05',
	'HU11',
	'IL01',
	'IT55',
	'JOB0',
	'KWB0',
	'KZE0',
	'LBE0',
	'LTE0',
	'LVE0',
	'MA04',
	'NL41',
	'NOE0',
	'OMB0',
	'PT19',
	'QAB0',
	'RO08',
	'RU08',
	'SAE0',
	'SDB0',
	'SEE0',
	'SKE1',
	'UA05',
	'UAE0',
	'UZE0',
	'ZA18',
	'BDE0',
	'PKE0',
	'VNE0',
	'PL18',
	'TR14',
	'AR12',
	'BR20',
	'CA39',
	'CL07',
	'CO06',
	'CRE0',
	'DO03',
	'EC06',
	'GTE0',
	'MX19',
	'NIE0',
	'PA11',
	'PE05',
	'PR06',
	'SVE0',
	'U339',
	'U341',
	'UY03',
	'VE06',
	'AU21',
	'CN20',
	'HK15',
	'ID01',
	'IDE0',
	'IN19',
	'JP23',
	'KR12',
	'MY07',
	'MY08',
	'NZ12',
	'PH10',
	'SG11',
	'SG17',
	'SG18',
	'TH11',
	'TWE0',
	'IE13',
	'GB13',
	'G013',
	'BHB0',
	'DE07',
	'IL01',
	'JOB0',
	'KWB0',
	'OMB0',
	'QAB0',
	'SDB0',
	'ID01',
	'MY07',
	'SG11',
	'AZE0',
	'BA04',
	'DE09',
	'DZE0',
	'FI06',
	'FR61',
	'HNE0',
	'JP25',
	'NO07',
	'RSE0',
	'SE24',
	'SI17',
	'SKE0',
	'TN01',
	'U342',
	'U343',
	'ZZ99')
     
	select ROW_NUMBER() over(order by [CoCd]) SNo, * into WAVE_NM_COMPANY_DGW_t001 from WAVE_NM_COMPANY_DGW_T001_source2
	update WAVE_NM_COMPANY_DGW_t001 set [company name] = 'Novartis Tech. Ops. (NTO)' where COcd = 'BE13'

	DECLARE @DefaultFlag AS VARCHAR(50)='No';
	SELECT DISTINCT 
		 [Country2 Code] [ISO2]
		,[Country Code] [ISO3]
		,isnull(A2.[Addr. No.],'') [Address No]
		,A1.SNo
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine1', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='', IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #1]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine2', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #2]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine3', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #3]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine4', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #4]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine5', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #5]
		,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine6', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #6]
		,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine7', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #7]
		,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine8', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #8]
		,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_addressLine9', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [Address #9]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_city', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) CITY
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_region', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) REGION
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_city_subdivision_1', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='',IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [CITY SUBDIVISION]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_city_subdivision_2', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='', IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [CITY SUBDIVISION 02]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_Region_Subdivision_1', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='', IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [SUB REGION]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_Region_Subdivision_2', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='', IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [REGION SUBDIVISION 02]
        ,RTRIM(LTRIM(ISNULL(dbo.GetAddressInfo(A1.[CTR], '_postalcode', 
							                    A2.[Street], A2.[Street 2], A2.[Street 3], A2.[Street 4], '', '', '', '', '',
												IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='', IIF(@DefaultFlag='Yes', 'Default', ''), A1.[City]), A2.[City]), ISNULL(A2.[City], '')),
												IIF(ISNULL([RG], '')='',IIF(A3.[Region(State)]='Required', IIF(@DefaultFlag='Yes', 'NVS', ''), ''), A3.[Country Code]+'-'+[RG]),
												IIF(A3.[City Subdivision]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[City Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 1]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(A3.[Region Subdivision 2]='Required', IIF(@DefaultFlag='Yes', 'Default', ''), ''),
												IIF(RTRIM(LTRIM(ISNULL(A2.[Postl Code], '')))='', 
														IIF(A3.[Postal Code]='Not Accepted', '', IIF(@DefaultFlag='Yes', ISNULL(A3.[Postal Code Default Values], ''), '')), 
														RTRIM(LTRIM(ISNULL(A2.[Postl Code], ''))))
												), ''))) [POSTAL CODE]
	INTO WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS
	FROM WAVE_NM_COMPANY_DGW_T001 A1 
		LEFT JOIN WAVE_NM_COMPANY_DGW_ADRC A2 ON A1.ADDRESS=A2.[Addr. No.]
		LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.Ctr=A3.[Country2 Code];
	--WHERE A1.[Ctr] IS NOT NULL AND A2.[Addr. No.] IS NOT NULL;  /* commented for p0*/

	select * from WAVE_NM_COMPANY_DGW_T001 
    /***** Location Validation Query Starts *****/
	SELECT * INTO NOVARTIS_DATA_MIGRATION_COMPANY_ERROR_LIST FROM (
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'Address' [Error Type]
				,(
                    IIF(ISNULL([Address #1], '')='' AND ISNULL(A2.[Address Line #1], '')='Required', ' Address Line #1 is missing;', '')+
                    IIF(ISNULL([Address #1], '')<>'' AND ISNULL(A2.[Address Line #1], '')='Not Accepted', ' Address Line #1 must be empty;', '')+
                    IIF(ISNULL([Address #2], '')='' AND ISNULL(A2.[Address Line #2], '')='Required', ' Address Line #2 is missing;', '')+
                    IIF(ISNULL([Address #2], '')<>'' AND ISNULL(A2.[Address Line #2], '')='Not Accepted', ' Address Line #2 must be empty;', '')+
                    IIF(ISNULL([Address #3], '')='' AND ISNULL(A2.[Address Line #3], '')='Required', ' Address Line #3 is missing;', '')+
                    IIF(ISNULL([Address #3], '')<>'' AND ISNULL(A2.[Address Line #3], '')='Not Accepted', ' Address Line #3 must be empty;', '')+
                    IIF(ISNULL([Address #4], '')='' AND ISNULL(A2.[Address Line #4], '')='Required', ' Address Line #4 is missing;', '')+
                    IIF(ISNULL([Address #4], '')<>'' AND ISNULL(A2.[Address Line #4], '')='Not Accepted', ' Address Line #4 must be empty;', '')+
                    IIF(ISNULL([Address #5], '')='' AND ISNULL(A2.[Address Line 5], '')='Required', ' Address Line #5 is missing;', '')+
                    IIF(ISNULL([Address #5], '')<>'' AND ISNULL(A2.[Address Line 5], '')='Not Accepted', ' Address Line #5 must be empty;', '')+
                    IIF(ISNULL([Address #6], '')='' AND ISNULL(A2.[Address Line 6], '')='Required', ' Address Line #6 is missing;', '')+
                    IIF(ISNULL([Address #6], '')<>'' AND ISNULL(A2.[Address Line 6], '')='Not Accepted', ' Address Line #6 must be empty;', '')+
                    IIF(ISNULL([Address #7], '')='' AND ISNULL(A2.[Address Line 7], '')='Required', ' Address Line #7 is missing;', '')+
                    IIF(ISNULL([Address #7], '')<>'' AND ISNULL(A2.[Address Line 7], '')='Not Accepted', ' Address Line #7 must be empty;', '')+
                    IIF(ISNULL([Address #8], '')='' AND ISNULL(A2.[Address Line 8], '')='Required', ' Address Line #8 is missing;', '')+
                    IIF(ISNULL([Address #8], '')<>'' AND ISNULL(A2.[Address Line 8], '')='Not Accepted', ' Address Line #8 must be empty;', '')+
                    IIF(ISNULL([Address #9], '')='' AND ISNULL(A2.[Address Line 9], '')='Required', ' Address Line #9 is missing;', '')+
                    IIF(ISNULL([Address #9], '')<>'' AND ISNULL(A2.[Address Line 9], '')='Not Accepted', ' Address Line #9 must be empty;', '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		UNION ALL
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'City' [Error Type]
				,(
                    IIF(ISNULL([CITY], '')='' AND ISNULL(A2.[Municipality(City)], '')='Required', ' Municipality(City) is missing;', '')+
                    IIF(ISNULL([CITY], '')<>'' AND ISNULL(A2.[Municipality(City)], '')='Not Accepted', ' Municipality(City) must be empty;', '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		UNION ALL
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'Region' [Error Type]
				,(
                    IIF(ISNULL([REGION], '')='' AND ISNULL(A2.[Region(State)], '')='Required', ' Region(State) is missing;', '')+
                    IIF(ISNULL([REGION], '')<>'' AND ISNULL(A2.[Region(State)], '')='Not Accepted', ' Region(State) must be empty;', '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		UNION ALL
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'City Subdivision' [Error Type]
				,(
                    IIF(ISNULL(A1.[CITY SUBDIVISION], '')='' AND ISNULL(A2.[City Subdivision], '')='Required', ' City Subdivision 1 is missing;', '')+
                    IIF(ISNULL(A1.[CITY SUBDIVISION], '')<>'' AND ISNULL(A2.[City Subdivision], '')='Not Accepted', ' City Subdivision 1 must be empty;', '')+
                    IIF(ISNULL([CITY SUBDIVISION 02], '')='' AND ISNULL(A2.[City Subdivision 2], '')='Required', ' City Subdivision 2 is missing;', '')+
                    IIF(ISNULL([CITY SUBDIVISION 02], '')<>'' AND ISNULL(A2.[City Subdivision 2], '')='Not Accepted', ' City Subdivision 2 must be empty;', '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		UNION ALL
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'Region Subdivision' [Error Type]
				,(
                    IIF(ISNULL([SUB REGION], '')='' AND ISNULL(A2.[Region Subdivision 1], '')='Required', ' Region Subdivision 1 is missing;', '')+
                    IIF(ISNULL([SUB REGION], '')<>'' AND ISNULL(A2.[Region Subdivision 1], '')='Not Accepted', ' Region Subdivision 1 must be empty;', '')+
                    IIF(ISNULL([REGION SUBDIVISION 02], '')='' AND ISNULL(A2.[Region Subdivision 2], '')='Required', ' Region Subdivision 2 is missing;', '')+
                    IIF(ISNULL([REGION SUBDIVISION 02], '')<>'' AND ISNULL(A2.[Region Subdivision 2], '')='Not Accepted', ' Region Subdivision 2 must be empty;', '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		UNION ALL
		SELECT @which_wavestage Wave
		        ,@which_report Report
				,CAST([SNo] AS VARCHAR(50))+'( '+[ADDRESS No]+' )' [Address No]
				,A2.[Country] [Country Name]
				,A1.[ISO3] [Country ISO3 Code]
				,'Postal Code' [Error Type]
				,(
                    IIF(ISNULL(A1.[POSTAL CODE], '')='' AND (ISNULL(A2.[Postal Code], '')='Required'), ' Postal Code is missing;', '')+
                    IIF(ISNULL(A1.[POSTAL CODE], '')<>'' AND ISNULL(A2.[Postal Code], '')='Not Accepted', ' Postal Code must be empty;', '')+
                    IIF(ISNULL(A1.[POSTAL CODE], '')<>'' AND ISNULL(A2.[Postal Code], '')='Required' OR ISNULL(A2.[Postal Code], '')='Optional', 
					    dbo.CheckPostalCode('', ISNULL(A1.[POSTAL CODE], ''), ISNULL(A2.[Postal Code Validations], '')), '')
                ) ErrorText
		FROM WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		) c WHERE ErrorText <> '';

--select * from WAVE_NM_COMPANY_DGW_COMPANY_ADDRESS order by sno

	select	[SNo] [Company Key],
				'TRUE'[Add Only],
				''[Company Reference Descriptor],
				''[Company Reference ID type],
				''[Company Reference ID],
				'1900-01-01'[Effective Date],
				''[VAT on Payment],
				''[Generate Award Costs at Business Process Completion],
				''[Begin Effective Date To Generate Award Costs],
				''[Ignore Award Line Dates for Award Costs],
				''[Default Tax Applicability Reference Descriptor],
				''[Default Tax Applicability Reference ID type],
				''[Default Tax Applicability Reference ID],
				''[Company Tax Recovery Pro Rata Factor Percentage],
				''[Default Tax Code Reference Descriptor],
				''[Default Tax Code Reference ID type],
				''[Default Tax Code Reference ID],
				''[Workers Compensation Carrier Reference Descriptor],
				''[Workers Compensation Carrier Reference ID type],
				''[Workers Compensation Carrier Reference ID],
				[CoCd] [ID],
				''[Include Organization ID in Name],
				[Company Name][Organization Name],
				''[Phonetic Name],
				[CoCd][Organization Code],
				'FALSE'[Include Organization Code in Name],
				'TRUE'[Organization Active],
				'1900-01-01'[Availability Date],
				''[Organization Visibility Reference Descriptor],
				'WID'[Organization Visibility Reference ID type],
				'9c875610c4fc496499e39741b6541dbc'[Organization Visibility Reference ID],
				''[External URL Reference Descriptor],
				''[External URL Reference ID type],
				''[External URL Reference ID],
				''[Organization Subtype Reference Descriptor],
				'Organization_Subtype_ID'[Organization Subtype Reference ID type],
				'Company'[Organization Subtype Reference ID],
				''[Currency Rate Type Override Reference Descriptor],
				''[Currency Rate Type Override Reference ID type],
				''[Currency Rate Type Override Reference ID],
				''[Fiscal Schedule Reference Descriptor],
				''[Fiscal Schedule Reference ID type],
				''[Fiscal Schedule Reference ID],
				''[Account Set Reference Descriptor],
				''[Account Set Reference ID type],
				''[Account Set Reference ID],
				''[Alternate Account Set Reference Descriptor],
				''[Alternate Account Set Reference ID type],
				''[Alternate Account Set Reference ID],
				''[Default Account Set Reference Descriptor],
				''[Default Account Set Reference ID type],
				''[Default Account Set Reference ID],
				''[Currency Reference Descriptor],
				''[Currency Reference ID type],
				''[Currency Reference ID],
				''[Account Control Rule Set Reference Descriptor],
				''[Account Control Rule Set Reference ID type],
				''[Account Control Rule Set Reference ID],
				''[Account Posting Rule Set Reference Descriptor],
				''[Account Posting Rule Set Reference ID type],
				''[Account Posting Rule Set Reference ID],
				''[Account Translation Rule Set Reference Descriptor],
				''[Account Translation Rule Set Reference ID type],
				''[Account Translation Rule Set Reference ID],
				''[Reverse Debit Credit],
				''[Keep Debit Credit and Reverse Sign],
				''[Default Reporting Book Reference Descriptor],
				''[Default Reporting Book Reference ID type],
				''[Default Reporting Book Reference ID],
				''[Average Daily Balance Rule Reference Descriptor],
				''[Average Daily Balance Rule Reference ID type],
				''[Average Daily Balance Rule Reference ID],
				''[Average Daily Balance Start Date],
				''[Procurement Tax Option Reference Descriptor],
				''[Procurement Tax Option Reference ID type],
				''[Procurement Tax Option Reference ID],
				''[Use Third Party Tax Service],
				''[Tax Service Name],
				''[Allow Invoice Accounting in Arrears],
				''[Accounting Date Required],
				''[Advanced],
				''[Customer Payment Application Rule Set Reference Descriptor],
				''[Customer Payment Application Rule Set Reference ID type],
				''[Customer Payment Application Rule Set Reference ID],
				''[Do Not Apply Payment to Invoices on Hold],
				''[Enable Journal Sequencing],
				''[Sequence Generator Rule Configuration Reference Descriptor],
				''[Sequence Generator Rule Configuration Reference ID type],
				''[Sequence Generator Rule Configuration Reference ID],
				''[Sequencing Start Period Reference Descriptor],
				''[Sequencing Start Period Reference ID type],
				''[Sequencing Start Period Reference ID],
				''[Create Sequence ID Generators with New Ledger Years],
				''[Consolidate Requisitions on Purchase Orders],
				''[Exclude Ship-To Address when Consolidating Requisition Lines],
				''[Exclude Purchase Items having Catalog Entries],
				''[Exclude Catalog Items from Secondary Suppliers in Catalog Search],
				''[Enable Requisition Line Defaults],
				''[Enable Requisition Auto-Sourcing for Non-Catalog Lines],
				''[Enable Transaction Tax on Requisition],
				''[Enable Requisition Line Attributes to Default from Linked Purchase Item],
				''[Spend Category Hierarchy Root Node Reference Descriptor],
				''[Spend Category Hierarchy Root Node Reference ID type],
				''[Spend Category Hierarchy Root Node Reference ID],
				''[Inventory Replenishment Requisition Rounding Option Reference Descriptor],
				''[Inventory Replenishment Requisition Rounding Option Reference ID type],
				''[Inventory Replenishment Requisition Rounding Option Reference ID],
				''[Par Replenishment Requisition Rounding Option Reference Descriptor],
				''[Par Replenishment Requisition Rounding Option Reference ID type],
				''[Par Replenishment Requisition Rounding Option Reference ID],
				''[Ship-To Contact Reference Descriptor],
				''[Ship-To Contact Reference ID type],
				''[Ship-To Contact Reference ID],
				''[Bill-To Contact Reference Descriptor],
				''[Bill-To Contact Reference ID type],
				''[Bill-To Contact Reference ID],
				''[Shipping Method Reference Descriptor],
				''[Shipping Method Reference ID type],
				''[Shipping Method Reference ID],
				''[Shipping Terms Reference Descriptor],
				''[Shipping Terms Reference ID type],
				''[Shipping Terms Reference ID],
				''[Allow Change of UOM and Unit Cost of Stockable Purchase Item on Replenishment Requisition],
				''[Allow Change of UOM of Stockable Purchase Item on NonReplenishment Requisition],
				''[Allow Change of UOM and Unit Cost of NonStockable Purchase Item on NonReplenishment Requisition],
				''[Enable Unit of Measure Change for Catalog Items on Requisitions],
				''[Disable Lot and Serials Capture on Receipt],
				''[Lot Capture Mandatory on Receipt],
				''[Serials Capture Mandatory on Receipt],
				''[Lot Expiration Behavior for Lots within Alert Period on Receipt Reference Descriptor],
				''[Lot Expiration Behavior for Lots within Alert Period on Receipt Reference ID type],
				''[Lot Expiration Behavior for Lots within Alert Period on Receipt Reference ID],
				''[Lot Expiration Behavior for Expired Lots on Receipt Reference Descriptor],
				''[Lot Expiration Behavior for Expired Lots on Receipt Reference ID type],
				''[Lot Expiration Behavior for Expired Lots on Receipt Reference ID],
				''[Allow Different Invoicing and Purchasing Supplier],
				''[Enable Payment Practices Reporting],
				''[Prevent Changes to Invoice after Final Print Run],
				''[Company Override Settings Reference Descriptor],
				''[Company Override Settings Reference ID type],
				''[Company Override Settings Reference ID],
				''[Electronic Invoicing Agreement Date],
				''[Enable Accounting for Negative Reimbursable Expense Reports],
				''[Customer Contract Sequence Generator Reference Descriptor],
				''[Customer Contract Sequence Generator Reference ID type],
				''[Customer Contract Sequence Generator Reference ID],
				''[Mandate Pre-notification Business Form Layout Reference Descriptor],
				''[Mandate Pre-notification Business Form Layout Reference ID type],
				''[Mandate Pre-notification Business Form Layout Reference ID],
				''[Award Contract Sequence Generator Reference Descriptor],
				''[Award Contract Sequence Generator Reference ID type],
				''[Award Contract Sequence Generator Reference ID],
				''[Award Proposal Sequence Generator Reference Descriptor],
				''[Award Proposal Sequence Generator Reference ID type],
				''[Award Proposal Sequence Generator Reference ID],
				''[Customer Invoice Sequence Generator Reference Descriptor],
				''[Customer Invoice Sequence Generator Reference ID type],
				''[Customer Invoice Sequence Generator Reference ID],
				''[Customer Invoice Credit Adjustment Sequence Generator Reference Descriptor],
				''[Customer Invoice Credit Adjustment Sequence Generator Reference ID type],
				''[Customer Invoice Credit Adjustment Sequence Generator Reference ID],
				''[Customer Invoice Debit Adjustment Sequence Generator Reference Descriptor],
				''[Customer Invoice Debit Adjustment Sequence Generator Reference ID type],
				''[Customer Invoice Debit Adjustment Sequence Generator Reference ID],
				''[Customer Invoice Rebill Sequence Generator Reference Descriptor],
				''[Customer Invoice Rebill Sequence Generator Reference ID type],
				''[Customer Invoice Rebill Sequence Generator Reference ID],
				''[Supplier Invoice Sequence Generator Reference Descriptor],
				''[Supplier Invoice Sequence Generator Reference ID type],
				''[Supplier Invoice Sequence Generator Reference ID],
				''[Customer Refund Sequence Generator Reference Descriptor],
				''[Customer Refund Sequence Generator Reference ID type],
				''[Customer Refund Sequence Generator Reference ID],
				''[Journal Sequence Generator Reference Descriptor],
				''[Journal Sequence Generator Reference ID type],
				''[Journal Sequence Generator Reference ID],
				''[Requisition Sequence Generator Reference Descriptor],
				''[Requisition Sequence Generator Reference ID type],
				''[Requisition Sequence Generator Reference ID],
				''[Purchase Order Sequence Generator Reference Descriptor],
				''[Purchase Order Sequence Generator Reference ID type],
				''[Purchase Order Sequence Generator Reference ID],
				''[Purchase Order Acknowledgement Sequence Generator Reference Descriptor],
				''[Purchase Order Acknowledgement Sequence Generator Reference ID type],
				''[Purchase Order Acknowledgement Sequence Generator Reference ID],
				''[Advanced Ship Notice Sequence Generator Reference Descriptor],
				''[Advanced Ship Notice Sequence Generator Reference ID type],
				''[Advanced Ship Notice Sequence Generator Reference ID],
				''[Receipt Sequence Generator Reference Descriptor],
				''[Receipt Sequence Generator Reference ID type],
				''[Receipt Sequence Generator Reference ID],
				''[Spend Authorization Sequence Generator Reference Descriptor],
				''[Spend Authorization Sequence Generator Reference ID type],
				''[Spend Authorization Sequence Generator Reference ID],
				''[Expense Reports Sequence Generator Reference Descriptor],
				''[Expense Reports Sequence Generator Reference ID type],
				''[Expense Reports Sequence Generator Reference ID],
				''[Supplier Contracts Sequence Generator Reference Descriptor],
				''[Supplier Contracts Sequence Generator Reference ID type],
				''[Supplier Contracts Sequence Generator Reference ID],
				''[Settlement Run Sequence Generator Reference Descriptor],
				''[Settlement Run Sequence Generator Reference ID type],
				''[Settlement Run Sequence Generator Reference ID],
				''[Prenote Run Sequence Generator Reference Descriptor],
				''[Prenote Run Sequence Generator Reference ID type],
				''[Prenote Run Sequence Generator Reference ID],
				''[Receipt Accrual Sequence Generator Reference Descriptor],
				''[Receipt Accrual Sequence Generator Reference ID type],
				''[Receipt Accrual Sequence Generator Reference ID],
				''[Outsourced Payment Group Sequence Generator Reference Descriptor],
				''[Outsourced Payment Group Sequence Generator Reference ID type],
				''[Outsourced Payment Group Sequence Generator Reference ID],
				''[Procurement Card Transaction Verification Sequence Generator Reference Descriptor],
				''[Procurement Card Transaction Verification Sequence Generator Reference ID type],
				''[Procurement Card Transaction Verification Sequence Generator Reference ID],
				''[Ad Hoc Bank Transaction Sequence Generator Reference Descriptor],
				''[Ad Hoc Bank Transaction Sequence Generator Reference ID type],
				''[Ad Hoc Bank Transaction Sequence Generator Reference ID],
				''[Mandate Business Form Layout Reference Descriptor],
				''[Mandate Business Form Layout Reference ID type],
				''[Mandate Business Form Layout Reference ID],
				''[Inventory Stock Requests Generator Reference Descriptor],
				''[Inventory Stock Requests Generator Reference ID type],
				''[Inventory Stock Requests Generator Reference ID],
				''[Inventory Pick Lists Generator Reference Descriptor],
				''[Inventory Pick Lists Generator Reference ID type],
				''[Inventory Pick Lists Generator Reference ID],
				''[Inventory Ship Lists Generator Reference Descriptor],
				''[Inventory Ship Lists Generator Reference ID type],
				''[Inventory Ship Lists Generator Reference ID],
				''[Inventory Returns Generator Reference Descriptor],
				''[Inventory Returns Generator Reference ID type],
				''[Inventory Returns Generator Reference ID],
				''[Inventory Count Sheets Generator Reference Descriptor],
				''[Inventory Count Sheets Generator Reference ID type],
				''[Inventory Count Sheets Generator Reference ID],
				''[Inventory Par Counts Generator Reference Descriptor],
				''[Inventory Par Counts Generator Reference ID type],
				''[Inventory Par Counts Generator Reference ID],
				''[Inventory Goods Deliveries Generator Reference Descriptor],
				''[Inventory Goods Deliveries Generator Reference ID type],
				''[Inventory Goods Deliveries Generator Reference ID],
				''[Inventory Goods Delivery Runs Generator Reference Descriptor],
				''[Inventory Goods Delivery Runs Generator Reference ID type],
				''[Inventory Goods Delivery Runs Generator Reference ID]
		INTO WAVE_NM_COMPANY_DGW_COMPANY 
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo

		--select * from WAVE_NM_COMPANY_DGW_COMPANY 

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'ALTER TABLE [WAVE_NM_COMPANY_DGW_T001] ADD [DATA KEY] INT NULL;'

		UPDATE A1 SET
		   [DATA KEY]= A2.[DATA KEY]
		FROM [WAVE_NM_COMPANY_DGW_T001] A1 
		   LEFT JOIN (SELECT [Cocd], ROW_NUMBER() OVER(PARTITION BY [Cocd]  ORDER BY [Cocd]) [DATA KEY] fROM  [WAVE_NM_COMPANY_DGW_T001]) A2 
		     ON A1.[Cocd]=A2.[Cocd]

		--SELECT * FROM [WAVE_NM_COMPANY_DGW_T001] ORDER BY [sno], [Data Key]
 
--DGW for second tab Organization Container Ref
		select [SNo] [Company Key],
			   [Data Key][Organization Container Reference Key],
				''[Descriptor],
				'Organization_Reference_ID'[ID type],
				'CUSTOM_ORGANIZATION-6-251'[ID]
		INTO WAVE_NM_COMPANY_DGW_Organization_Container
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo
	--select * from WAVE_NM_COMPANY_DGW_Organization_Container
--DGW for third tab Address Data Ref
		 select [SNo] [Company Key],
				[data key][Address Data Key],
				''[Formatted Address],
				''[Address Format Type],
				''[Defaulted Business Site Address],
				''[Delete],
				''[Do Not Replace All],
				'1900-01-01'[Effective Date],
				''[Country Reference Descriptor],
				'ISO_3166-1_Alpha-3_Code'[Country Reference ID type],
				[Ctr][Country Reference ID],
				''[Last Modified],
				[Company Name][Municipality],
				''[Country City Reference Descriptor],
				'Country_Subregion_Internal_ID'[Country City Reference ID type],
				'BRA-SP-São Caetano do Sul '[Country City Reference ID],
				''[Country City Reference ID parent type],
				''[Country City Reference ID parent id],
				''[Country Region Reference Descriptor],
				'Country_Region_ID'[Country Region Reference ID type],
				[Ctr][Country Region Reference ID],
				''[Country Region Descriptor],
				'Postal Code'[Postal Code],
				'TRUE'[Public],
				'TRUE'[Primary],
				''[Type Reference Descriptor],
				'Communication_Usage_Type_ID'[Type Reference ID type],
				'BUSINESS'[Type Reference ID],
				''[Comments],
				''[Number of Days],
				''[Municipality Local],
				''[Address Reference Descriptor],
				''[Address Reference ID type],
				''[Address Reference ID],
				''[Address ID]
		INTO WAVE_NM_COMPANY_DGW_Address_Data
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo

		--DGW for fourth tab
				select [SNo] [Company Key],
				[DATA KEY][Address Data Key],
				''[Address Line Data Key],
				''[Address Line Data Descriptor],
				'ADDRESS_LINE_1'[Address Line Data Type],
				''[Address Line Data]
		INTO WAVE_NM_COMPANY_DGW_Address_LINE_Data
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo
 --select * from  WAVE_NM_COMPANY_DGW_Address_LINE_Data
 --DGW for fifth tab
		select [SNo] [Company Key], 
				[DATA KEY][Address Data Key],
				''[Submunicipality Data Key],
				''[Submunicipality Data Address Component Name],
				'CITY_SUBDIVISION_1'[Submunicipality Data Type],
				'ZONA INDUSTRIAL'[Submunicipality Data]
		INTO WAVE_NM_COMPANY_DGW_Submunicipality_Data
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo

 --DGW for six tab

		select [SNo] [Company Key], 
				[DATA KEY][Address Data Key],
				''[Subregion Data Key],
				''[Subregion Data Descriptor],
				'REGION_SUBDIVISION_1'[Subregion Data Type],
				isnull([city], '') [Subregion Data]
		INTO WAVE_NM_COMPANY_DGW_Subregion_Data
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo
		--select * from WAVE_NM_COMPANY_DGW_T001
		--select * from WAVE_NM_COMPANY_DGW_Subregion_Data
 --DGW for seventh tab

		select [SNo] [Company Key], 
					''[Tax ID Data Key],
					[Company Name][Tax ID Text],
					''[Tax ID Type Reference Descriptor],
					'Tax_ID_Type'[Tax ID Type Reference ID type],
					[Cocd][Tax ID Type Reference ID],
					''[Transaction Tax ID],
					''[Primary Tax ID]
		INTO WAVE_NM_COMPANY_DGW_TaxID_Data
		FROM WAVE_NM_COMPANY_DGW_T001 ORDER BY SNo
--select * from WAVE_NM_COMPANY_DGW_TaxID_Data
--select * from WAVE_NM_COMPANY_DGW_T001
END
