SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
    --EXEC [PROC_WAVE_NM_AUTOMATE_COMPANY_ADDRESS] 'P0', 'Company', '2021-03-10';
	--SELECT * FROM P0_COMPANY_ADDRESS ORDER BY SNo, [Address No]
	--SELECt * FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE WAVE='P0' AND [Report]='Company'

	DECLARE @SQL AS VARCHAR(4000)='DROP TABLE IF EXISTS P0_COMPANY_ADDRESS;
	                              drop table if exists P0_T001_source2;
								  drop table if exists P0_T001;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

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
	
	SELECT DISTINCT 
		A1.[Ctr] [ISO2], 
		A3.[Country Code] ISO3,
		A2.[Addr. No.] [Address No],
		A1.SNo,
		IIF(ISNULL([Street], '')='', ISNULL([House No.], ''), IIF(ISNULL([House No.], '')='', [Street], [Street]+','+[House No.])) [Address #1],
		ISNULL([Street 2], '') [Address #2],
		ISNULL([Street 4], '') [Address #3],
		IIF(A3.[Municipality(City)]='Required', IIF(ISNULL(A2.[City], '')='', IIF(ISNULL(A1.[City], '')='','Default', A1.[City]), A2.[City]), ISNULL(A2.[City], '')) [City],
		IIF(ISNULL([Postl Code], '')='', IIF(A3.[Postal Code]='Required', A3.[Postal Code Default Values], ''), ISNULL([Postl Code], ''))  [Postal Code],
		IIF(ISNULL([RG], '')='', IIF(A3.[Region(State)]='Required', 'NVS', ''), A3.[Country Code]+'-'+[RG])  [Region],
		IIF(A3.[City Subdivision]='Required', 'Default', '') [City Subdivision],
		IIF(A3.[Subregion(Country)]='Required', 'Default', '') [Sub Region]
	INTO P0_COMPANY_ADDRESS
	FROM P0_T001 A1 
		LEFT JOIN P0_ADRC A2 ON A1.ADDRESS=A2.[Addr. No.]
		LEFT JOIN WAVE_ADDRESS_VALIDATION A3 ON A1.Ctr=A3.[Country2 Code]
	WHERE A1.[Ctr] IS NOT NULL AND A2.[Addr. No.] IS NOT NULL

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
END
GO
