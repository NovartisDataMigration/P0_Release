USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS]    Script Date: 5/3/2021 6:33:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS', 'P' ) IS NOT NULL   
    DROP PROCEDURE [PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS];  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
    --EXEC [PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS] 'P0', 'Company', '2021-03-10';
	--SELECT * FROM P0_COMPANY_ADDRESS ORDER BY SNo, [Address No]
	--SELECt * FROM NOVARTIS_DATA_MIGRATION_COMPANY_ERROR_LIST ORDER BY [Address No]

	--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_LC

	DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS P0_COMPANY_ADDRESS;
	                              drop table if exists P0_T001_source2;
								  drop table if exists P0_T001;
								  drop table if exists NOVARTIS_DATA_MIGRATION_COMPANY_ERROR_LIST';
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

	select * into P0_T001_source2
	from P0_T001_source
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
     
	select ROW_NUMBER() over(order by [CoCd]) SNo, * into p0_t001 from P0_T001_source2
	update p0_t001 set [company name] = 'Novartis Tech. Ops. (NTO)' where COcd = 'BE13'

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
	INTO P0_COMPANY_ADDRESS
	FROM P0_T001 A1 
		LEFT JOIN P0_ADRC A2 ON A1.ADDRESS=A2.[Addr. No.]
		LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.Ctr=A3.[Country2 Code];
	--WHERE A1.[Ctr] IS NOT NULL AND A2.[Addr. No.] IS NOT NULL;  /* commented for p0*/


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
		FROM P0_COMPANY_ADDRESS A1 
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
		FROM P0_COMPANY_ADDRESS A1 
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
		FROM P0_COMPANY_ADDRESS A1 
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
		FROM P0_COMPANY_ADDRESS A1 
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
		FROM P0_COMPANY_ADDRESS A1 
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
		FROM P0_COMPANY_ADDRESS A1 
        LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
		) c WHERE ErrorText <> '';

END
GO

	-- SELECT DISTINCT 
	--       A1.CTR [Country],
	--       A1.Address,
	--       ISNULL(A2.[Street], '') [Address #1],
	--	   ISNULL(A2.[Street 2], '') [Address #2],
	--	   ISNULL(A2.[Street 3], '') [Address #3],
	--	   ISNULL(A2.[Street 4], '') [Address #4],
	--	   ISNULL(A2.[Street 5], '') [Address #5],
	--       IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='','', A1.[City]), A2.[City]) [City],
	--       ISNULL(A2.[House No.], '') [House No.], 
	--	   ISNULL(A2.[Postl Code], '') [Postl Code],
	--	   IIF(ISNULL(A2.[RG], '')='', IIF(A3.[Region(State)]='Required', '', ''), A3.[Country Code]+'-'+[RG])  [Region],
	--	   '' [City Subdivision],
	--	   '' [Sub Region]
	--FROM P0_T001 A1 
	--	LEFT JOIN P0_ADRC A2 ON A1.ADDRESS=A2.[Addr. No.]
	--	LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.Ctr=A3.[Country2 Code]
	--WHERE ISNULL(A1.CTR, '') <> '';

	--SELECT DISTINCT 
	--	'CH' [ISO2], 
	--	'CHE' [ISO3],
	--	isnull(A2.[Addr. No.],'') [Address No],
	--	A1.SNo,
	--	'Forum 1' [Address #1] ,--IIF(ISNULL([Street], '')='', ISNULL([House No.], ''), IIF(ISNULL([House No.], '')='', [Street], [Street]+','+[House No.])) [Address #1],
	--	 cast('Novartis Campus' as nvarchar(255)) [Address #2],-- ISNULL([Street 2], '') [Address #2],
	--	'' [Address #3],--ISNULL([Street 4], '') [Address #3],
	--	'Basel'  [City],--IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='','Default', A1.[City]), A2.[City]), ISNULL(A2.[City], '')) [City],
	--	'4056' [Postal Code],--IIF(ISNULL([Postl Code], '')='', IIF(A3.[Postal Code]='Required', A3.[Postal Code Default Values], ''), ISNULL([Postl Code], ''))  [Postal Code],
	--	'CHE-BS' [Region],-- IIF(ISNULL([RG], '')='', IIF(A3.[Region(State)]='Required', 'NVS', ''), A3.[Country Code]+'-'+[RG])  [Region],
	--	''  [City Subdivision],--IIF(A3.[City Subdivision]='Required', 'Default', '') [City Subdivision],
	--	'' [Sub Region]--IIF(A3.[Subregion(Country)]='Required', 'Default', '') [Sub Region]
	--INTO P0_COMPANY_ADDRESS
	--FROM P0_T001 A1 
	--	LEFT JOIN P0_ADRC A2 ON A1.ADDRESS=A2.[Addr. No.]
	--	LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.Ctr=A3.[Country2 Code];
	----WHERE A1.[Ctr] IS NOT NULL AND A2.[Addr. No.] IS NOT NULL;  /* commented for p0*/

	

	/*commented for p0

	UPDATE A1
		SET [Address #1]=IIF(ISNULL([Address #1], '')='', IIF(A2.[Address Line #1]='Required', 'Default', ''), [Address #1])
	FROM P0_COMPANY_ADDRESS A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]

	UPDATE A1
		SET [Address #2]=IIF(ISNULL([Address #2], '')='', IIF(A2.[Address Line #2]='Required', 'Default', ''), [Address #2])
	FROM P0_COMPANY_ADDRESS A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]

	UPDATE A1
		SET [Address #2]=IIF(ISNULL([Address #2], '')='', ISNULL([Address #3], ''), [Address #2]+IIF(ISNULL([Address #3], '')='', '', ','+[Address #3])), [Address #3]=''
	FROM P0_COMPANY_ADDRESS A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
	WHERE A2.[Address Line #3]='Not Accepted'

	UPDATE A1
		SET [Address #2]=IIF(ISNULL([Address #2], '')='', ISNULL(A1.[Postal Code], ''), [Address #2]+IIF(ISNULL(A1.[Postal Code], '')='', '', ','+A1.[Postal Code])), [Postal Code]=''
	FROM P0_COMPANY_ADDRESS A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]
	WHERE A2.[Postal Code]='Not Accepted'


	 */


/* commented for p0
	/***** Company Address Validation Query Starts *****/
	DELETE FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE WAVE=@which_wavestage AND [Report]=@which_report
	INSERT INTO NOVARTIS_DATA_MIGRATION_ERROR_LIST
	SELECT * FROM (
	SELECT @which_wavestage Wave
			,@which_report Report
			,[Address No] [Employee ID]
			,A1.[ISO3] [Country Code]
			,(
				IIF(ISNULL(A1.[Address #1], '')='' AND ISNULL(A2.[Address Line #1], '')='Required', ' Address Line #1 is missing;', '')+
				IIF(ISNULL(A1.[Address #1], '')<>'' AND ISNULL(A2.[Address Line #1], '')='Not Accepted', ' Address Line #1 must be empty;', '')+
				IIF(ISNULL(A1.[Address #2], '')='' AND ISNULL(A2.[Address Line #2], '')='Required', ' Address Line #2 is missing;', '')+
				IIF(ISNULL(A1.[Address #2], '')<>'' AND ISNULL(A2.[Address Line #2], '')='Not Accepted', ' Address Line #2 must be empty;', '')+
				IIF(ISNULL(A1.[Address #3], '')='' AND ISNULL(A2.[Address Line #3], '')='Required', ' Address Line #3 is missing;', '')+
				IIF(ISNULL(A1.[Address #3], '')<>'' AND ISNULL(A2.[Address Line #3], '')='Not Accepted', ' Address Line #3 must be empty;', '')+
				IIF(ISNULL(A1.[City], '')='' AND ISNULL(A2.[Municipality(City)], '')='Required', ' Municipality(City) is missing;', '')+
				IIF(ISNULL(A1.[City], '')<>'' AND ISNULL(A2.[Municipality(City)], '')='Not Accepted', ' Municipality(City) must be empty;', '')+
				IIF(ISNULL(A1.[Postal Code], '')='' AND ISNULL(A2.[Postal Code], '')='Required', ' Postal Code is missing;', '')+
				IIF(ISNULL(A1.[Postal Code], '')<>'' AND ISNULL(A2.[Postal Code], '')='Not Accepted', ' Postal Code must be empty;', '')+
				IIF(ISNULL(A1.[Postal Code], '')<>'' AND (ISNULL(A2.[Postal Code], '')='Required' OR ISNULL(A2.[Postal Code], '')='Optional'), dbo.CheckPostalCode('', ISNULL(A1.[Postal Code], ''), ISNULL(A2.[Postal Code Validations], '')), '')
			) ErrorText
	FROM P0_COMPANY_ADDRESS A1 
	LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO3=A2.[Country Code]) c WHERE ErrorText <> '';

	*/
