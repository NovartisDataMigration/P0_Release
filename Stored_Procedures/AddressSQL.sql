			SELECT [Geo - Country (CC)],
			   [EmployeeID],
			   'Address' [ApplicantID],
			   (
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #1], ''), '[Address Line #1]', [HomeAddress15Data_AddressLine1], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #2], ''), '[Address Line #2]', [HomeAddress15Data_AddressLine2], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #3], ''), '[Address Line #3]', [HomeAddress15Data_AddressLine3], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #4], ''), '[Address Line #4]', [HomeAddress15Data_AddressLine4], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #5], ''), '[Address Line #5]', [HomeAddress15Data_AddressLine5], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #6], ''), '[Address Line #6]', [HomeAddress15Data_AddressLine6], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #7], ''), '[Address Line #7]', [HomeAddress15Data_AddressLine7], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #8], ''), '[Address Line #8]', [HomeAddress15Data_AddressLine8], [HomeAddress15Data_CountryISOCode], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #9], ''), '[Address Line #9]', [HomeAddress15Data_AddressLine9], [HomeAddress15Data_CountryISOCode], '')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN (SELECT [Emp - Personnel Number], [Geo - Country (CC)] FROM WAVE_POSITION_MANAGEMENT) T2 ON T1.[Emp - Personnel Number]=T2.[Emp - Personnel Number]
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress15Data_CountryISOCode]=A1.[Country Code]
			   UNION ALL
			SELECT [Geo - Country (CC)],
			   [EmployeeID],
			   'Local Address' [ApplicantID],
			   (
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #1 - Local], ''), 'Local 1:[Address Line #1]', [Home_Address_Local15Data_ADDRESS_LINE_1], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #2 - Local], ''), 'Local 2:[Address Line #2]', [Home_Address_Local15Data_ADDRESS_LINE_2], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #4 - Local], ''), 'Local 4:[Address Line #4]', [Home_Address_Local15Data_ADDRESS_LINE_4], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #5 - Local], ''), 'Local 5:[Address Line #5]', [Home_Address_Local15Data_ADDRESS_LINE_5], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #6 - Local], ''), 'Local 6:[Address Line #6]', [Home_Address_Local15Data_ADDRESS_LINE_6], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #7 - Local], ''), 'Local 7:[Address Line #7]', [Home_Address_Local15Data_ADDRESS_LINE_7], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #8 - Local], ''), 'Local 8:[Address Line #8]', [Home_Address_Local15Data_ADDRESS_LINE_8], [Home_Address_Local15Data_ISO_Code], '') +
				   dbo.CheckAddressFormat(':'+ISNULL(A1.[Address Line #9 - Local], ''), 'Local 9:[Address Line #9]', [Home_Address_Local15Data_ADDRESS_LINE_9], [Home_Address_Local15Data_ISO_Code], '') 

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN (SELECT [Emp - Personnel Number], [Geo - Country (CC)] FROM WAVE_POSITION_MANAGEMENT) T2 ON T1.[Emp - Personnel Number]=T2.[Emp - Personnel Number]
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local15Data_ISO_Code]=A1.[Country Code]
