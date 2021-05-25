USE [PROD_DATACLEAN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW]    Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.GetNonEnglishName') IS NOT NULL
  DROP FUNCTION GetNonEnglishName
GO

CREATE FUNCTION [dbo].[GetNonEnglishName](
   @Value_ENG        NVARCHAR(4000)
)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @KeepValues AS VARCHAR(500) = @Value_ENG;
	DECLARE @Value      AS NVARCHAR(500) = @Value_ENG;
	IF (@Value = @KeepValues) RETURN @Value;

	RETURN '';
END 
GO

IF OBJECT_ID('dbo.CheckAddressFormat') IS NOT NULL
  DROP FUNCTION CheckAddressFormat
GO

CREATE FUNCTION [dbo].[CheckAddressFormat](
   @validateopr VARCHAR(50)='Optional',
   @column_name VARCHAR(max),
   @column_value VARCHAR(max),
   @countrycode VARCHAR(max),
   @lkup VARCHAR(max)
)  
RETURNS varchar(500)
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	DECLARE @sql AS VARCHAR(MAX)='';
	DECLARE @value AS NVARCHAR(MAX)='';
	--SET @column_value=REPLACE(@column_value, ' ', ' ');

	--SET @sql='SELECT @validateopr=['+@column_name+'] FROM dbo.W4_ADDRESS_VALIDATION WHERE [Country Code]='''+@countrycode+'';
	--EXEC sp_executesql @sql, N'@validateopr NVARCHAR(1024) OUTPUT', @validateopr OUTPUT;
	IF (CHARINDEX('Not Accepted', @validateopr) >= 1)
	BEGIN
	   IF NOT(ISNULL(@column_value, '')='')
	   BEGIN
			SET @result=@column_name+': Value not allowed;';
	   END
	END
	IF (CHARINDEX('Required', @validateopr) >= 1)
	BEGIN
	   IF ISNULL(@column_value, '')=''
	   BEGIN
			SET @result=@column_name+': Value is mandatory;';
	   END
	   ELSE
	   BEGIN
	        SET @result='';
			
			IF (@column_name not like  '%Local%') 
			BEGIN
			    SET @value=IIF(LTRIM(RTRIM(@column_value))<>'', dbo.CheckSplCharacters(@column_name, @column_value), '');
			    SET @result=@result+IIF(@value='', '', 'Special Character:'+ @value);
			END
			IF (CHARINDEX('[Postal Code]', @column_name) >= 1)
			BEGIN
			    SET @value=IIF(LTRIM(RTRIM(@column_value))<>'', dbo.CheckPostalCode(@column_name, @column_value, @validateopr), '');
				SET @result=@result+IIF(@value='', '', 'Format Error:'+ @value);
			END
	   END
	END
	IF (CHARINDEX('Optional', @validateopr) >= 1)
	BEGIN
		IF ISNULL(@column_value, '')<>''
		BEGIN
		    SET @result=''; 
			IF (@column_name not like  '%Local%') 
			BEGIN
			    SET @value=IIF(LTRIM(RTRIM(@column_value))<>'', dbo.CheckSplCharacters(@column_name, @column_value), '');
			    SET @result=@result+IIF(@value='', '', 'Special Character:'+ @value);
			END
			IF (CHARINDEX('[Postal Code]', @column_name) >= 1)
			BEGIN
			    SET @value=IIF(LTRIM(RTRIM(@column_value))<>'', dbo.CheckPostalCode(@column_name, @column_value, @validateopr), '');
				SET @result=@result+IIF(@value='', '', 'Format Error:'+ @value);
			END
		END
	END
   
    RETURN (@result)  
END
GO

IF OBJECT_ID('dbo.CheckSplCharacters') IS NOT NULL
  DROP FUNCTION CheckSplCharacters
GO
CREATE FUNCTION [dbo].[CheckSplCharacters](
   @column_name VARCHAR(max),
   @column_value VARCHAR(max)
)  
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';
	DECLARE @Position AS INT=0;
	SET @column_value=REPLACE(REPLACE(@column_value, char(39), ''), ' ', '');
	SELECT @Position = PATINDEX('%[^a-zA-Z0-9 "&\/,.;#()+:-_\-]%', RTRIM(LTRIM(@column_value)));
	IF (@Position >= 1) SET @result= @column_name+': Contains "special" character at '+CAST(@Position AS VARCHAR(30))+'('+@column_value+');';
   
    RETURN (@result)  
END
GO

IF OBJECT_ID('dbo.CheckPostalCode') IS NOT NULL
  DROP FUNCTION CheckPostalCode
GO

CREATE FUNCTION [dbo].[CheckPostalCode](
   @column_name VARCHAR(max),
   @column_value VARCHAR(max),
   @postalformat VARCHAR(max)
)
RETURNS varchar(500)
BEGIN
    DECLARE @result AS VARCHAR(500)='';
	--DECLARE @postalformat AS VARCHAR(max)='';

	--SELECT TOP 1 @postalformat=item FROM [dbo].[fnSplit](@validateopr, ':');
    --SELECT DISTINCT [Country Code], [Postal Code Validations] FROM WAVE_ADDRESS_VALIDATION WHERE [Postal Code Validations] IS NOT NULL
    SET @column_value=UPPER(@column_value);
    IF (@postalformat='Postal code must be 1 letter followed by 4 digits and 3 letters The 3 letters at the end are optional')
	BEGIN
		IF NOT (@column_value LIKE '[A-Z][0-9][0-9][0-9][0-9]' OR
                @column_value LIKE '[A-Z][0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 1 letter followed by 4 digits and 3 letters The 3 letters at the end are optional';
		END
	END
    IF (LTRIM(RTRIM(@postalformat))='Postal code must be 4 digits')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 4 digits';
		END
	END
    IF (@postalformat='Postal code must be 4 digits followed by 2 letters. A space is allowed after the 4th digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9] [A-Z][A-Z]' OR
                @column_value LIKE '[0-9][0-9][0-9][0-9][A-Z][A-Z]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 4 digits followed by 2 letters. A space is allowed after the 4th digit';
		END
	END
    IF (@postalformat='Postal code must be 4 digits, may be proceeded by ''B-'' or ''S-''')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE 'B-[0-9][0-9][0-9][0-9]' OR
				@column_value LIKE 'S-[0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 4 digits, may be proceeded by ''B-'' or ''S-''';
		END
	END
    IF (@postalformat='Postal code must be 5 digits')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 digits';
		END
	END
    IF (@postalformat='Postal code must be 5 digits. A dash is allowed after the 2nd digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9]-[0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 digits. A dash is allowed after the 2nd digit';
		END
	END
    IF (@postalformat='Postal code must be 5 digits. A space is allowed after the 3rd digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9] [0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 digits. A space is allowed after the 3rd digit';
		END
	END
    IF (@postalformat='Postal code must be 5 digits, may be preceeded by ''LT''')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE 'LT[0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 digits, may be preceeded by ''LT''';
		END
	END
    IF (@postalformat='Postal code must be 5 digits or ZIP+4 format (#####-####)')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 digits or ZIP+4 format (#####-####)';
		END
	END
    IF (@postalformat='Postal code must be 5 or 7 digits')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 5 or 7 digits';
		END
	END
    IF (@postalformat='Postal code must be 6 digits')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 6 digits';
		END
    END
    IF (@postalformat='Postal code must be 6 digits, may be preceeded by ''LV''')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE 'LV[0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 6 digits, may be preceeded by ''LV''';
		END
    END
    IF (@postalformat='Postal code must be 6 digits. A dash is allowed after the 3rd digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 6 digits. A dash is allowed after the 3rd digit';
		END
	END
    IF (@postalformat='Postal code must be 6 digits. A space is allowed after the 3rd digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9] [0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 6 digits. A space is allowed after the 3rd digit';
		END
	END
    IF (@postalformat='Postal code must be 7 digits. A dash is allowed after the 3rd digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 7 digits. A dash is allowed after the 3rd digit';
		END
	END
    IF (@postalformat='Postal code must be 7 digits. A dash is allowed after the 4th digit')
	BEGIN
		IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]' OR
		        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		BEGIN
		    SET @result=@column_name+':'+'Postal code must be 7 digits. A dash is allowed after the 4th digit';
		END
	END
    IF (@postalformat='Postal code must be 5 digits or 8 digits')
        BEGIN
                IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
                        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
                BEGIN
                    SET @result=@column_name+':'+'Postal code must be 5 digits or 8 digits';
	        END
         END
     IF (@postalformat='Postal code must be 7 characters in the format (A#A #A#)')
        BEGIN
                IF NOT (@column_value LIKE '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]')
                BEGIN
                    SET @result=@column_name+':'+'Postal code must be 7 characters in the format (A#A #A#)';
                END
         END
	IF (@postalformat='Postal code must be 6 characters in the format (A#A #A#)')
        BEGIN
                IF NOT (@column_value LIKE '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]')
                BEGIN
                    SET @result=@column_name+':'+'Postal code must be 6 characters in the format (A#A #A#)';
                END
         END
	IF (@postalformat='Postal code must be 5 digits or 6 digits with an optional dash after the third')
        BEGIN
                IF NOT (@column_value LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
				        @column_value LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]' OR
						@column_value LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')
                BEGIN
                    SET @result=@column_name+':'+'Postal code must be 5 digits or 6 digits with an optional dash after the third';
                END
         END
	IF (@postalformat='Postal code must be 3 or 5 digits')
        BEGIN
                IF NOT (@column_value LIKE '[0-9][0-9][0-9]' OR
				        @column_value LIKE '[0-9][0-9][0-9][0-9][0-9]')
                BEGIN
                    SET @result=@column_name+':'+'Postal code must be 3 or 5 digits';
                END
         END

	RETURN(@result);
END
GO

--Address Error Report
IF OBJECT_ID ( 'PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT;  
GO
CREATE PROCEDURE [dbo].[PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT]
AS
BEGIN
--EXEC PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION WHERE [Employee ID]='10001103' ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION WHERE [Error Text] like '%Postal%' ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM wd_hr_tr_workeraddress WHERE [HomeAddress10Data_CountryISOCode] <> ''
--SELECT * FROM WAVE_PHONE_VALIDATION_FINAL

     DECLARE @ErrorList TABLE (
	     [CountryCC]        VARCHAR(MAX), 
		 [Employee Type]    VARCHAR(MAX),
		 [Employee Group]   VARCHAR(MAX),
         [EmployeeID]       VARCHAR(MAX), 
		 [Error Type]       VARCHAR(MAX),
		 [ErrorText]        VARCHAR(MAX)
	)

    DECLARE @DynamicTable TABLE (
		SNo                       NVARCHAR(200),
		Prefix                    NVARCHAR(200)
	);

    INSERT INTO @DynamicTable VALUES('1', 'primary');
    INSERT INTO @DynamicTable VALUES('2', 'secondary');
	INSERT INTO @DynamicTable VALUES('3', 'third');
    INSERT INTO @DynamicTable VALUES('4', 'fourth');
	INSERT INTO @DynamicTable VALUES('5', 'fifth');
	INSERT INTO @DynamicTable VALUES('6', 'sixth');
	INSERT INTO @DynamicTable VALUES('7', 'seventh');
	INSERT INTO @DynamicTable VALUES('8', 'eightth');
	INSERT INTO @DynamicTable VALUES('9', 'nineth');
	INSERT INTO @DynamicTable VALUES('10', 'tenth');
	INSERT INTO @DynamicTable VALUES('11', 'eleventh');
	INSERT INTO @DynamicTable VALUES('12', 'twelveth');
	INSERT INTO @DynamicTable VALUES('13', 'thirteenth');
	INSERT INTO @DynamicTable VALUES('14', 'fourteenth');
	INSERT INTO @DynamicTable VALUES('15', 'fifteenth');

    DECLARE @SNo                   AS VARCHAR(10)='';
    DECLARE @Prefix                AS VARCHAR(50)='';
	DECLARE @SQL                   AS VARCHAR(MAX)='';

	--SELECT * FROM WAVE_POSITION_MANAGEMENT

	DECLARE cursor_item CURSOR FOR SELECT * FROM @DynamicTable;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT 
			   [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Address'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line #1], ''''), ''[Address Line #1]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine1], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line #2], ''''), ''[Address Line #2]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine2], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line #3], ''''), ''[Address Line #3]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine3], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line #4], ''''), ''[Address Line #4]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine4], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 5], ''''), ''[Address Line #5]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine5], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 6], ''''), ''[Address Line #6]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine6], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 7], ''''), ''[Address Line #7]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine7], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 8], ''''), ''[Address Line #8]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine8], [HomeAddress'+@SNo+'Data_CountryISOCode], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 9], ''''), ''[Address Line #9]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_AddressLine9], [HomeAddress'+@SNo+'Data_CountryISOCode], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress'+@SNo+'Data_CountryISOCode]=A1.[Country Code]
		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Local Address'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 1 - Local], ''''), ''Local 1:[Address Line #1]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_1], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 2 - Local], ''''), ''Local 2:[Address Line #2]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_2], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 4 - Local], ''''), ''Local 4:[Address Line #4]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_4], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 5 - Local], ''''), ''Local 5:[Address Line #5]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_5], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 6 - Local], ''''), ''Local 6:[Address Line #6]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_6], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 7 - Local], ''''), ''Local 7:[Address Line #7]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_7], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 8 - Local], ''''), ''Local 8:[Address Line #8]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_8], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') +
				   dbo.CheckAddressFormat('':''+ISNULL(A1.[Address Line 9 - Local], ''''), ''Local 9:[Address Line #9]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_ADDRESS_LINE_9], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''') 

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local'+@SNo+'Data_ISO_Code]=A1.[Country Code]
		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Municipality(City)'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([Municipality(City)], ''''), ''[Municipality(City)]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_City(Municipality)], [HomeAddress'+@SNo+'Data_CountryISOCode], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress'+@SNo+'Data_CountryISOCode]=A1.[Country Code]
			   UNION ALL
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Local Municipality(City)'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([City - Local], ''''), ''Local :[Municipality(City)]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_CITY], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local'+@SNo+'Data_ISO_Code]=A1.[Country Code]
		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''City Subdivision'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([City Subdivision], ''''), ''[City Subdivision]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_SubMunicipalityType], [HomeAddress'+@SNo+'Data_CountryISOCode], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress'+@SNo+'Data_CountryISOCode]=A1.[Country Code]
			   UNION ALL
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Local City Subdivision'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([City Subdivision 1 - Local], ''''), ''Local 1:[City Subdivision]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', Home_Address_Local'+@SNo+'Data_CITY_SUBDIVISION_1, [Home_Address_Local'+@SNo+'Data_ISO_Code], '''')+
				   dbo.CheckAddressFormat('':''+ISNULL([City Subdivision 2 - Local], ''''), ''Local 2:[City Subdivision]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', Home_Address_Local'+@SNo+'Data_CITY_SUBDIVISION_2, [Home_Address_Local'+@SNo+'Data_ISO_Code], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local'+@SNo+'Data_ISO_Code]=A1.[Country Code]
		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Region(State)'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([Region(State)], ''''), ''[Region(State)]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_State(Region)], [HomeAddress'+@SNo+'Data_CountryISOCode], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress'+@SNo+'Data_CountryISOCode]=A1.[Country Code]
			   UNION ALL
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Local Region(State)'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat('':''+ISNULL([Region(State)], ''''), ''Local :[Region(State)]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_REGION_ID], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''')
			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local'+@SNo+'Data_ISO_Code]=A1.[Country Code]
		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

	    SET @SQL='
		SELECT DISTINCT * FROM (
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Postal Code'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat([Postal Code Validations]+'':''+ISNULL([Postal Code], ''''), ''[Postal Code]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [HomeAddress'+@SNo+'Data_PostalCode], [HomeAddress'+@SNo+'Data_CountryISOCode], '''')

			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[HomeAddress'+@SNo+'Data_CountryISOCode]=A1.[Country Code]
			   UNION ALL
			SELECT [Geo - Country (CC)],
			   [WD_EMP_TYPE],
			   [Emp - Group],
			   [EmployeeID],
			   ''Local Postal Code'' [ApplicantID],
			   (
				   dbo.CheckAddressFormat([Postal Code Validations]+'':''+ISNULL([Postal Code], ''''), ''Local :[Postal Code]( Home Address '+@SNo+'->''+'+@Prefix+'_SUBTY+'' )'', [Home_Address_Local'+@SNo+'Data_Postal_Code], [Home_Address_Local'+@SNo+'Data_ISO_Code], '''')
			   ) ErrorText
			   FROM wd_hr_tr_workeraddress T1
					 LEFT JOIN WAVE_ADDRESS_VALIDATION A1 ON T1.[Home_Address_Local'+@SNo+'Data_ISO_Code]=A1.[Country Code]

		) a WHERE ErrorText <> '''';'
		INSERT INTO @ErrorList EXEC(@SQL);

		FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	SET @SQL='drop table if exists NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL
	SELECT  'P0'                 [Build Number] 
	       ,'Address'            [Report Name]
		   ,[EmployeeID]         [Employee ID]
		   ,[Country]            [Country Name]
		   ,[Country Code]       [Country ISO3 Code]
		   ,[Employee Type]      [Employee Type]
		   ,[Employee Group]     [Employee Group]
		   ,[Error Type]         [Error Type]
		   ,[ErrorText]          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION 
	   FROM @ErrorList A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[CountryCC]=A2.[Country2 Code];

END
GO
--EXEC PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION WHERE [Employee ID]='37006057'  ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM P0_T591S WHERE ITYPE='0006'
--SELECT TOP 100 * FROM WAVE_NM_PA0006

--Region Mapping
IF OBJECT_ID ( 'PROC_AUTOMATE_WORKER_ADDRESS_REGION_MAPPING', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_AUTOMATE_WORKER_ADDRESS_REGION_MAPPING;  
GO
CREATE PROCEDURE [dbo].[PROC_AUTOMATE_WORKER_ADDRESS_REGION_MAPPING]
AS
BEGIN

	DECLARE @WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID TABLE (
	     SUBTY          NVARCHAR(10), 
	     ISO2           NVARCHAR(50),
		 ISO3           NVARCHAR(50),
		 REGION         NVARCHAR(500),
		 TYPE           NVARCHAR(100),
		 REFID          NVARCHAR(100)   
	);

	DECLARE @REGION_TABLE TABLE (
	     SUBTY          NVARCHAR(10), 
	     ISO2           NVARCHAR(50),
		 ISO3           NVARCHAR(50),
		 REGION         NVARCHAR(500),
		 TYPE           NVARCHAR(100),
		 REFID          NVARCHAR(100)   
	);

	INSERT INTO @REGION_TABLE 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, STATE REGION, 'STATE' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='1' AND STATE IS NOT NULL
	  UNION 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, STATE REGION, 'STATE' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='4' AND STATE IS NOT NULL
	  UNION 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, STATE REGION, 'STATE' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='5' AND STATE IS NOT NULL
	  UNION 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, ORT01 REGION, 'CITY' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='1' AND ORT01 IS NOT NULL
	  UNION 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, ORT01 REGION, 'CITY' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='4' AND ORT01 IS NOT NULL
	  UNION 
	  SELECT SUBTY, LAND1 ISO2, '' ISO3, ORT01 REGION, 'CITY' TYPE, '' REFID FROM WAVE_NM_PA0006 WHERE SUBTY='5' AND ORT01 IS NOT NULL

    UPDATE A1 
	   SET ISO3=[COUNTRY CODE]
	   FROM @REGION_TABLE A1 JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.ISO2=A2.[Country2 Code]

	--SELECT * FROM REGION_MAPPING_MASTER WHERE [alpha2code]='IT'
	--SELECT * FROM HRCORE_REGION_TEXT WHERE REGION='MI'
    UPDATE A1 
	     SET REFID=A2.referenceID
	  FROM @REGION_TABLE A1 JOIN (SELECT A1.Country, A1.Region, A2.referenceID 
	                                 FROM HRcore_Region_Text A1 
	                                 LEFT JOIN region_mapping_master A2 ON A1.Country=A2.alpha2code AND (A1.Description=A2.Name OR A1.Description=A2.Description)) A2
	          ON A1.ISO2=A2.Country AND A1.REGION=A2.Region
      WHERE TYPE='STATE'

    UPDATE A1 
	     SET REFID=A2.referenceID
	  FROM  @REGION_TABLE A1 JOIN (SELECT A1.Country, A1.Description, A2.referenceID 
	                                  FROM HRcore_Region_Text A1 
									  LEFT JOIN region_mapping_master A2 ON A1.Country=A2.alpha2code AND (A1.Description=A2.Name OR A1.Description=A2.Description)) A2
	          ON A1.ISO2=A2.Country AND A1.REGION=A2.Description
      WHERE TYPE='CITY'

    UPDATE A1 
	     SET REFID=A2.RegionID
	  FROM  @REGION_TABLE A1 JOIN WAVE_REGION_WORKDAY A2 ON A1.ISO3=A2.countrycode3 AND A1.REGION=A2.Region
    
	UPDATE @REGION_TABLE SET REFID= 'ITA-MI' WHERE ISO2='IT' AND REGION='MI' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-RM' WHERE ISO2='IT' AND REGION='RM' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-NA' WHERE ISO2='IT' AND REGION='NA' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-MA' WHERE ISO2='IT' AND REGION='MA' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-FI' WHERE ISO2='IT' AND REGION='FI' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-TO' WHERE ISO2='IT' AND REGION='TO' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-VE' WHERE ISO2='IT' AND REGION='VE' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-MB' WHERE ISO2='IT' AND REGION='MB' AND TYPE='STATE';
	UPDATE @REGION_TABLE SET REFID= 'ITA-CL' WHERE ISO2='IT' AND REGION='CL' AND TYPE='STATE';
	--Kyiv Oblast UA-32
	UPDATE @REGION_TABLE SET REFID= 'UKR-32' WHERE ISO2='UA' AND REGION='KIE' AND TYPE='STATE';

	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'El Giza','City','EGY-GZ');
    INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Eldaqahlya','City','EGY-DK');
    INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'El-Menoufia','City','EGY-MNF');
    INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'El-Menya','City','EGY-MNF');
    INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'New Cairo','City','EGY-C');
    INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'Київ','City','UKR-30');
    INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'м. Ірпінь','City','UKR-35');
    INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'м. Львів','City','UKR-46');
    INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'м. Харків','City','UKR-63');
    INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'с. Лушники, Шосткинського р-н,Сумської о','City','UKR-63');

	INSERT INTO @REGION_TABLE VALUES ('5','AE','ARE',N'AbuDhabi','City','ARE-AZ');
	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Alexanderia','City','EGY-ALX');
	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Tanta','City','EGY-GH');
	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Guiza','City','EGY-GZ');
	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Sohag','City','EGY-SHG');
	INSERT INTO @REGION_TABLE VALUES ('1','EG','EGY',N'Sohag','City','EGY-SHG');
	INSERT INTO @REGION_TABLE VALUES ('5','EG','EGY',N'Sharkiya','City','EGY-SHR');
	INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'MIK','State','UKR-48');
	INSERT INTO @REGION_TABLE VALUES ('1','UA','UKR',N'ODS','State','UKR-51');

	INSERT INTO @REGION_TABLE VALUES ('4','UA','UKR',N'Kyiv','City','UKR-35');
	INSERT INTO @REGION_TABLE VALUES ('4','IT','ITA',N'Legnano','City','ITA-MI');
	INSERT INTO @REGION_TABLE VALUES ('4','IT','ITA',N'Bergamo','City','ITA-BG');
	INSERT INTO @REGION_TABLE VALUES ('4','IT','ITA',N'Origgio','City','ITA-VA');
	INSERT INTO @REGION_TABLE VALUES ('4','IT','ITA',N'Azzate','City','ITA-VA');
	INSERT INTO @REGION_TABLE VALUES ('4','EG','EGY',N'Sharkiya','City','EGY-SHR');        --Sharkiya
	INSERT INTO @REGION_TABLE VALUES ('4','EG','EGY',N'Talkha- Dakahlia','City','EGY-DK');
    

--Sharkiya
--84000839
--ARE
--Casablanca
--(Hard Code COuntry to MAR) so we dont need Region for MAR

    --SELECT * FROM WAVE_REGION_MAPPING_ADDRESS WHERE TYPE='CITY' ORDEr BY ISO3
	
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_REGION_MAPPING_ADDRESS;';
	SELECT * INTO WAVE_REGION_MAPPING_ADDRESS FROM @REGION_TABLE WHERE ISNULL(REFID, '') <> '' ORDER BY ISO2

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID;';
    SELECT PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC 
	INTO WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID FROM WAVE_NM_PA0006
	WHERE PERNR IN (
			SELECT [EmployeeID]
			   FROM WD_HR_TR_WorkerAddress
			   WHERe ISNULL([HomeAddress1Data_CountryISOCode], '') <> '' AND ISNULL([HomeAddress1Data_State(Region)], '') = '' AND
							[HomeAddress1Data_CountryISOCode] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]='Required')) AND SUBTY='1'

	INSERT INTO WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
    SELECT PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC 
	FROM WAVE_NM_PA0006
	WHERE PERNR IN (
			SELECT [EmployeeID]
			   FROM WD_HR_TR_WorkerAddress
			   WHERe ISNULL([HomeAddress1Data_CountryISOCode], '') <> '' AND ISNULL([HomeAddress1Data_State(Region)], '') = '' AND
							[HomeAddress1Data_CountryISOCode] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]='Required')) AND SUBTY='4'

	INSERT INTO WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
	SELECT PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC FROM WAVE_NM_PA0006
	WHERE PERNR IN (
			SELECT [EmployeeID]
			   FROM WD_HR_TR_WorkerAddress
			   WHERe ISNULL([HomeAddress2Data_CountryISOCode], '') <> '' AND ISNULL([HomeAddress2Data_State(Region)], '') = '' AND
							[HomeAddress2Data_CountryISOCode] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]='Required')) AND SUBTY='5'

	INSERT INTO WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
	SELECT PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC FROM WAVE_NM_PA0006
	WHERE PERNR IN (
			SELECT [EmployeeID]
			   FROM WD_HR_TR_WorkerAddress
			   WHERe ISNULL([Home_Address_Local1Data_ISO_Code], '') <> '' AND ISNULL([Home_Address_Local1Data_REGION_ID], '') = '' AND
							[Home_Address_Local1Data_ISO_Code] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]='Required')) AND SUBTY='1'

	INSERT INTO WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
	SELECT PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC FROM WAVE_NM_PA0006
	WHERE PERNR IN (
			SELECT [EmployeeID]
			   FROM WD_HR_TR_WorkerAddress
			   WHERe ISNULL([Home_Address_Local2Data_ISO_Code], '') <> '' AND ISNULL([Home_Address_Local2Data_REGION_ID], '') = '' AND
							[Home_Address_Local2Data_ISO_Code] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]='Required')) AND SUBTY='5'

	--SELECT * FROM WAVE_REGION_MAPPING_ADDRESS WHERE REGION='Dubai' ORDER BY ISO2
	--SELECT * FROM WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID ORDER BY ISO2
	--SELECt * FROM HRCORE_REGION_TEXT WHERe COUNTRY='UA'
	--SELECT * FROM W2_P2_REGION_WORKDAY WHERE COUNTRYcode3 LIKE 'UKR%'
	--SELECT * FROM REGION_MAPPING_MASTER WHERE alpha3code='UKR'
	--SELECT * FROM REGION_MAPPING_MASTER WHERE ISNULL(Description, '') <> ''
	--Dnipropetrovs'ka, Dnipropetrovsk Oblast
	--Alexanderia
	--Dubai,AE,AE,Dubai,
	--SELECT * FROM WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
	--SELECT * FROM WAVE_REGION_MAPPING_ADDRESS_MISSING_REFID
	--SELECT DISTINCT SRC_MAP_FIELD FROM SET_ADDRESS_FIELD_MAPPING_DONE ORDER BY SRC_MAP_FIELD
	--SELECT DISTINCT * INTO SET_ADDRESS_FIELD_MAPPING_DONE_BACKUP_15APR FROM SET_ADDRESS_FIELD_MAPPING_DONE
	--SELECT DISTINCT * FROM SET_ADDRESS_FIELD_MAPPING_FINAL
	--SELECT DISTINCT * FROM SET_ADDRESS_FIELD_MAPPING_SUNEELA
	--SELECT * FROM WAVE_ADDRESS_VALIDATION WHERE [Flag]='Extended'
	--SELECT DISTINCT [Country2 Code], [Country Code], 'Basic' [Flag] INTO WAVE_ADDRESS_VALIDATION_FLAG FROM WAVE_ADDRESS_VALIDATION
	--SELECT * FROM WAVE_ADDRESS_VALIDATION_FLAG
	--SELECT DISTINCT * FROM SET_ADDRESS_FIELD_MAPPING_DONE WHERE [ISO2]='ID'
	--SELECT * FROM WAVE_ADDRESS_VALIDATION WHERE [Country2 Code]='ID'
	--SELECT DISTINCT ORT02 FROM P0_PA0006 WHERE LAND1='ID'
END
GO
--Sharkiya
--EXEC PROC_AUTOMATE_WORKER_ADDRESS_REGION_MAPPING
--SELECT * FROM REGION_MAPPING_LKUP

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT;  
GO
CREATE PROCEDURE [dbo].[PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT]
    @WhichDate                  VARCHAR(20),
	@SUBTY                      VARCHAR(20)
AS
BEGIN
	DECLARE @SQL AS NVARCHAR(MAX)='drop table if exists ADDRESS_PA0006;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

--SELECT * FROM [SET_ADDRESS_FIELD_MAPPING]
--SELECT * FROM W4_POLAND_DISTRICT_LKUP
--SELECT * FROM W4_ITALY_STREET_NUMBER_LKUP
    PRINT 'START ADDRESS_PA0006'
	SELECT DISTINCT
		A1.PERNR,
		SUBTY,	
		cast(ENDDA as nvarchar(255)) as EndDate,
		cast(BEGDA as nvarchar(255)) as StartDate,
		ANSSA,
		NAME2,
		STRAS,
		IIF((A1.ORT01 IS NULL AND A1.COUNC IS NOT NULL), A6.CITY, IIF(A1.ORT01 IS NOT NULL, A1.ORT01, '')) ORT01,
		ORT02,
		RCTVC,
		PSTLZ,
		LAND1,
		TELNR,
		WKWNG,
		BUSRT,
		LOCAT,
		ADR03,
		ADR04,
		NEIGN,
		NBHD,
		VILLA,
		NEIGH,
		MUNIC,
		TOWN,
		IIF(ISNULL((SELECT TOP 1 REFID FROM WAVE_REGION_MAPPING_ADDRESS A8 WHERE A8.ISO2=A1.LAND1 AND A8.REGION=ISNULL(A1.STATE,N'') AND A8.TYPE='STATE'),N'')=N'',
			ISNULL((SELECT TOP 1 REFID FROM WAVE_REGION_MAPPING_ADDRESS A8 WHERE A8.ISO2=A1.LAND1 AND A8.REGION=ISNULL(A1.ORT01,N'') AND A8.TYPE='CITY'),N''),
			ISNULL((SELECT TOP 1 REFID FROM WAVE_REGION_MAPPING_ADDRESS A8 WHERE A8.ISO2=A1.LAND1 AND A8.REGION=ISNULL(A1.STATE,N'') AND A8.TYPE='STATE'),N''))  STATE,
		HSNMR,
		POSTA,
		BLDNG,
		FLOOR,
		STRDS,
		COM01,
		NUM01,
		COM02,
		NUM02,
		COM03,
		NUM03,
		IIF(A1.COUNC IS NOT NULL, A6.CITY, '') COUNC,
		OR1KK,
		OR2KK,
		CONKK,
		A3.CTR,
		A3.CCD,
		A3.MC,
		A3.[DESCRIPTION] PL_DISTRICT,
		A4.CC,
		A4.CITY,
		A4.REG,
		A4.[STREETNUM] IT_STREETNUM,
		[FIELD_TYPE],
		[ROW_NUM],
		ISNULL(SHOW_SUBTY_TEXT, '') SHOW_SUBTY
    INTO ADDRESS_PA0006
    FROM [dbo].[WAVE_NM_PA0006] A1
	JOIN P0_SUP_ORG_SOURCE A2 ON A1.pernr = A2.persno
	LEFT JOIN COUNC_CITY_LKUP A6 ON A1.LAND1=A6.CC AND A1.COUNC=A6.COUNC
	LEFT JOIN WAVE_POLAND_DISTRICT_LKUP A3 ON A1.LAND1=A3.CTR AND A1.COUNC=A3.CCD AND A1.RCTVC=A3.MC
	LEFT JOIN (SELECT CC, CITY, REG, RG, STREETNUM FROM WAVE_ITALY_STREET_NUMBER_LKUP) A4 ON A1.LAND1=A4.CC AND A1.ORT01=A4.CITY AND A1.STATE=A4.RG	
	WHERE begDa<=CAST(@WhichDate as date) AND endda>=CAST(@WhichDate as date) AND ROW_NUM = @SUBTY AND 
	      LAND1 IN (SELECT DISTINCT ISO2 FROM [SET_ADDRESS_FIELD_MAPPING_DONE])
	PRINT 'END ADDRESS_PA0006'


	IF (@SUBTY='1')
	BEGIN
		SET @SQL='drop table if exists PRIMARY_ADDRESS_PA0006;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

        SELECT * INTO PRIMARY_ADDRESS_PA0006 FROM ADDRESS_PA0006
	END
	IF (@SUBTY='2')
	BEGIN
		SET @SQL='drop table if exists SECONDARY_ADDRESS_PA0006;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

        SELECT * INTO SECONDARY_ADDRESS_PA0006 FROM ADDRESS_PA0006
	END

    DECLARE @CC                  AS  VARCHAR(10);
	DECLARE @ISO2                AS  VARCHAR(10);
	DECLARE @SrcFields           AS  VARCHAR(100);
	DECLARE @SrcMapFields        AS  VARCHAR(100);
	DECLARE @DstMapFields        AS  VARCHAR(100);
	DECLARE @DstField            AS  VARCHAR(100);
	DECLARE @OPR                 AS  VARCHAR(100);
	DECLARE @SET                 AS  VARCHAR(MAX);
	DECLARE @ADR                 AS  VARCHAR(MAX);
	DECLARE @EMPTY               AS  VARCHAR(MAX);
	DECLARE @Field               AS  VARCHAR(100);

    DECLARE @MunicipalityCity    AS  VARCHAR(50);
	DECLARE @CitySubDivision     AS  VARCHAR(50);
	DECLARE @SubRegion           AS  VARCHAR(50);
	DECLARE @PostalCode          AS  VARCHAR(50);
	
	DECLARE cursor_iso2 CURSOR FOR 
	      SELECT DISTINCT ISO2 FROM [SET_ADDRESS_FIELD_MAPPING_DONE]
	OPEN cursor_iso2; 
	FETCH NEXT FROM cursor_iso2 INTO @CC;
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @SET=''; 
		SET @ADR='';
		SET @SQL='';
		DECLARE cursor_field CURSOR FOR 
			  SELECT ISO2, SRC_FIELD, SRC_MAP_FIELD, DST_FIELD, DST_MAP_FIELD, OPERATION FROM [SET_ADDRESS_FIELD_MAPPING_DONE] WHERE ISO2=@CC ORDER BY DST_MAP_FIELD, [INDEX];
		OPEN cursor_field; 
		FETCH NEXT FROM cursor_field INTO @ISO2, @SrcFields, @SrcMapFields, @DstField, @DstMapFields, @OPR;
 
		WHILE @@FETCH_STATUS = 0
		BEGIN
	        IF (ISNULL(@SrcMapFields, '') <> '')
			BEGIN
			    IF (ISNULL(@OPR, '') = 'ADD' OR ISNULL(@OPR, '') = 'ADD_MAPPING')
				BEGIN
					IF @ADR <> '' SET @ADR=@ADR+'+'':''+';
					SET @ADR=@ADR+' ISNULL('+@SrcMapFields+','''')';
					IF (ISNULL(@OPR, '') = 'ADD_MAPPING')
					BEGIN
						IF @SET <> '' SET @SET=@SET+', ';
						SET @SET=@SET+'A1.#FIELD_TYPE#'+@DstMapFields+' = REPLACE(REPLACE(REPLACE('+@ADR+', '':'', ''~:''), '':~'', ''''), ''~:'', '','')';
						SET @ADR='';
					END
				END
				ELSE
				BEGIN
					IF @SET <> '' SET @SET=@SET+', ';
					SET @SET=@SET+'A1.#FIELD_TYPE#'+@DstMapFields+' = '+@SrcMapFields+'';
				END
			END
			FETCH NEXT FROM cursor_field INTO @ISO2, @SrcFields, @SrcMapFields, @DstField, @DstMapFields, @OPR;
		END

		CLOSE cursor_field; 
		DEALLOCATE cursor_field;

		--Executes the created update statement
		PRINT @CC;
		SET @Field=(CASE 
		               WHEN (@SUBTY='1') THEN 'primary'
					   WHEN (@SUBTY='2') THEN 'secondary'
					   WHEN (@SUBTY='3') THEN 'third'
					   WHEN (@SUBTY='4') THEN 'fourth'
					   WHEN (@SUBTY='5') THEN 'fifth'
					   WHEN (@SUBTY='6') THEN 'sixth'
					   WHEN (@SUBTY='7') THEN 'seventh'
					   WHEN (@SUBTY='8') THEN 'eightth'
					   WHEN (@SUBTY='9') THEN 'nineth'
					   WHEN (@SUBTY='10') THEN 'tenth'
					   WHEN (@SUBTY='11') THEN 'eleventh'
					   WHEN (@SUBTY='12') THEN 'twelveth'
					   WHEN (@SUBTY='13') THEN 'thirteenth'
					   WHEN (@SUBTY='14') THEN 'fourteenth'
					   WHEN (@SUBTY='15') THEN 'fifteenth'

					   ELSE ''
					END);
		SET @SQL='UPDATE A1 SET '+@Field+'_SUBTY= A2.SHOW_SUBTY, '+@Field+'_effective_date=StartDate, '+@Field+'_country=LAND1, ' + REPLACE(@SET, '#FIELD_TYPE#', ''+@Field+'') +' 
		              FROM WAVE_NM_address_source_data A1 
					       JOIN ADDRESS_PA0006 A2 ON A1.PERSNO=A2.PERNR 
					  WHERE A2.ROW_NUM='+@SUBTY+' AND A2.LAND1='''+@CC+'''';
		BEGIN TRY
		    SET NOCOUNT ON
		    EXEC(@SQL);
			SET NOCOUNT OFF
		END TRY
		BEGIN CATCH
		    PRINT @SQL;
			SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;

		END CATCH
		--PRINT @SQL;
        --EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

		FETCH NEXT FROM cursor_iso2 INTO @CC;
	END

	CLOSE cursor_iso2; 
	DEALLOCATE cursor_iso2;
END
GO
--SELECT * FROM WAVE_NM_address_source
--SELECT * FROM WAVE_ADDRESS_VALIDATION
--SELECT * FROM WAVE_NM_address_source_data WHERE PERSNO='24000862'
--SELECT * FROM WAVE_NM_SUP_ORG_SOURCE WHERE PERSNO='24000862'
--SELECT * FROM [WAVE_NM_PA0006] WHERE PERNR='24000862'   
--SELECT * FROM [PRIMARY_ADDRESS_PA0006] WHERE PERNR='84000839'   
--SELECT * FROM [PRIMARY_ADDRESS_PA0006] WHERE LAND1='EG'   


-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_AUTOMATE_WORKER_ADDRESS_SET_SUB_TYPE_1AND5', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_AUTOMATE_WORKER_ADDRESS_SET_SUB_TYPE_1AND5;  
GO
CREATE PROCEDURE [dbo].[PROC_AUTOMATE_WORKER_ADDRESS_SET_SUB_TYPE_1AND5]
    @WhichDate      AS  VARCHAR(10)
AS
BEGIN
    /* Correction required before all the sub type */
	UPDATE A1 SET
	      A1.ORG_COMPANY=A2.[Org - Company Code],
	      A1.CC=A2.[Geo - Work Country],
		  A1.Emp_Group=A2.[Emp - Group]
	FROM WAVE_NM_PA0006 A1 JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]

	-- Moving LOCAT to STRAS, If STRAS is null and LOCAT is not null.
	UPDATE WAVE_NM_PA0006 SET STRAS=LOCAT WHERE (ISNULL(STRAS, '')='' AND ISNULL(LOCAT, '') <> '')
	UPDATE WAVE_NM_PA0006 SET LOCAT='' WHERE (ISNULL(STRAS, '')=ISNULL(LOCAT, ''))	

    --Delete all STRAS and LOCAT is null
	PRINT 'Delete all STRAS and LOCAT is null';
    DELETE FROM WAVE_NM_PA0006 WHERE (ISNULL(STRAS, '')='' AND ISNULL(LOCAT, '')='') AND ISNULL(LAND1, '') <> 'HU'
	
    -- Russia address suppression 
	UPDATE A1 SET
		ANSSA=null,
		NAME2=null,
		STRAS=null,
		ORT01=null,
		ORT02=null,
		RCTVC=null,
		PSTLZ=null,
		LAND1=null,
		TELNR=null,
		WKWNG=null,
		BUSRT=null,
		LOCAT=null,
		ADR03=null,
		ADR04=null,
		STATE=null,
		HSNMR=null,
		POSTA=null,
		BLDNG=null,
		FLOOR=null,
		STRDS=null,
		COM01=null,
		NUM01=null,
		COM02=null,
		NUM02=null,
		COM03=null,
		NUM03=null,
		COUNC=null,
		OR1KK=null,
		OR2KK=null,
		CONKK=null,
		NEIGN=null,
		NBHD=null,
		VILLA=null,
		NEIGH=null,
		MUNIC=null,
		TOWN=null
	 FROM WAVE_NM_PA0006 A1
	 WHERE LAND1='RU'

	 UPDATE A1 SET 
	     [ROW_NUM]=A2.[ROW],
		 [FIELD_TYPE]=(CASE
		                  WHEN A2.[ROW]=1 THEN 'primary'
						  WHEN A2.[ROW]=2 THEN 'secondary'
						  WHEN A2.[ROW]=3 THEN 'third'
						  WHEN A2.[ROW]=4 THEN 'fourth'
                          WHEN A2.[ROW]=5 THEN 'fifth'
                          WHEN A2.[ROW]=6 THEN 'sixth'
                          WHEN A2.[ROW]=7 THEN 'seventh'
                          WHEN A2.[ROW]=8 THEN 'eightth'
                          WHEN A2.[ROW]=9 THEN 'nineth'
                          WHEN A2.[ROW]=10 THEN 'tenth'
                          WHEN A2.[ROW]=11 THEN 'eleventh'
                          WHEN A2.[ROW]=12 THEN 'twelveth'
                          WHEN A2.[ROW]=13 THEN 'thirteenth'
                          WHEN A2.[ROW]=14 THEN 'fourteenth'
                          WHEN A2.[ROW]=15 THEN 'fifteenth'
					   ELSE ''
					   END), 
			[SHOW_SUBTY]=A1.SUBTY,
			[SHOW_SUBTY_TEXT]=A3.[NAME]
	 FROM WAVE_NM_PA0006 A1 
	      LEFT JOIN (SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY PERNR) AS [ROW] FROM WAVE_NM_PA0006) A2 ON A1.PERNR=A2.PERNR AND A1.SUBTY=A2.SUBTY AND A1.RNUM=A2.RNUM
		  LEFT JOIN P0_T591S A3 ON A1.SUBTY=A3.STYP AND ITYPE='0006'

     --INSERT INTO WAVE_NM_SUBTY VALUES('1', 'Permanent residence');
     --INSERT INTO WAVE_NM_SUBTY VALUES('2', 'Temporary residence');
     --INSERT INTO WAVE_NM_SUBTY VALUES('3', 'Home address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('4', 'Emergency address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('5', 'Mailing address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('7', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('9000', 'Permanent Residence Local Characters');
     --INSERT INTO WAVE_NM_SUBTY VALUES('9001', 'Work Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('9002', 'Official Registration Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('9003', 'Delivery Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('CH01', 'Weekly Residence Address (CH)');
     --INSERT INTO WAVE_NM_SUBTY VALUES('CH02', 'Spouse Address (CH)');
     --INSERT INTO WAVE_NM_SUBTY VALUES('CNHK', 'Hukou Address (CN)');
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZ01', 'Adres for delivery post coupon');
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZ02', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZ03', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZ04', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZ05', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('CZMV', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('FRRT', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('H1', 'HK Accomodation provided by employer');
     --INSERT INTO WAVE_NM_SUBTY VALUES('H2', 'HK Hotel Acco. provided by employer');
     --INSERT INTO WAVE_NM_SUBTY VALUES('HU01', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('HU02', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('J1', 'Official(tax) address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('J2', 'Guarantor');
     --INSERT INTO WAVE_NM_SUBTY VALUES('J3', 'Address during leave of absence');
     --INSERT INTO WAVE_NM_SUBTY VALUES('K2', 'Home Country Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('K3', 'Leave Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('MY01', 'Beneficiary Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('OM01', 'Arabic Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('QB', 'Beneficiary''s Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('RUBP', 'Birthplace');
     --INSERT INTO WAVE_NM_SUBTY VALUES('RUBR', 'Russian Passport Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('SK01', '');   
     --INSERT INTO WAVE_NM_SUBTY VALUES('SKMV', 'Work location');
     --INSERT INTO WAVE_NM_SUBTY VALUES('U1', 'Sales- Sample Storage / Shipping Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('U2', 'Sales - Literature Shipping Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('U3', 'Work Tax Address');
     --INSERT INTO WAVE_NM_SUBTY VALUES('V1', 'Address for PIT');


	--SELECT * FROM WAVE_NM_PA0006 WHERE PERNR='37006057'
	--SELECT * FROM WAVE_REGION_MAPPING_ADDRESS WHERE ISO2='BR' ORDER BY REGION
	--SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY PERNR) AS [ROW] FROM WAVE_NM_PA0006 WHERE PERNR='10001103'
	--SELECT * FROM WAVE_ADDRESS_VALIDATION WHERE []
	--SELECT * 

END
GO


IF OBJECT_ID('dbo.RemoveFLCommaCharacter') IS NOT NULL
  DROP FUNCTION RemoveFLCommaCharacter
GO
CREATE FUNCTION RemoveFLCommaCharacter(
   @Value            NVARCHAR(2000),
   @CamelCaseFlag    VARCHAR(20)
)  
RETURNS nvarchar(2000)  
BEGIN  
    DECLARE @result AS NVARCHAR(2000)='';

	SET @Value=RTRIM(LTRIM(ISNULL(@Value, '')));
	IF (@Value<>'')
	BEGIN
		SET @Value=IIF(SUBSTRING(@Value, 1, 1)=',', SUBSTRING(@Value, 2, LEN(@Value)), @Value);
		SET @Value=IIF(SUBSTRING(@Value, LEN(@Value), 1)=',', SUBSTRING(@Value, 1, LEN(@Value)-1), @Value);

		IF (@CamelCaseFlag='Y')
		BEGIN
			DECLARE @i INT;
			DECLARE @w INT;
			DECLARE @j NCHAR(1);

			SELECT @i=1, @w=0, @result = '';
			WHILE (@i <= LEN(@Value))
			BEGIN
			   SELECT @j=SUBSTRING(@Value,@i,1),@i=@i+1;
			   IF @j COLLATE Latin1_General_BIN like '[a-z]' SET @w=1;
			END

			IF (@w=0)
			BEGIN
				SELECT @i=1, @w=1, @result = '';
				WHILE (@i <= LEN(@Value))
				BEGIN
				   SELECT @j= SUBSTRING(@Value,@i,1),
				   @result = @result + CASE WHEN @w=1 THEN UPPER(@j) ELSE LOWER(@j) END,
				   @i = @i +1;
				   IF @j like '[ ]' SET @w=0;
				   SET @w = @w +1;
				END
			END
			ELSE SET @result=@Value;
		END
		ELSE SET @result=@Value;
	END

	RETURN @result;
END
GO
--PRINT dbo.RemoveFLCommaCharacter('TORRENT VALLBONA', 'Y');

--DECLARE @Value AS NVARCHAR(2000)='tORRENT VALLBONA';
--DECLARE @j AS NCHAR(1);
--SELECT @j=SUBSTRING(@Value,1,1);
--PRINT @j
--IF @j COLLATE Latin1_General_BIN like '[a-z]' PRINT 'Small letter'; ELSE PRINT 'CAPS letter';


IF OBJECT_ID('dbo.GetAddressLineInfo') IS NOT NULL
  DROP FUNCTION GetAddressLineInfo
GO
CREATE FUNCTION GetAddressLineInfo(
   @Houseno      NVARCHAR(250),
   @Apartment    NVARCHAR(250),
   @Floor        NVARCHAR(250),
   @AddressLine  NVARCHAR(250),
   @Building     NVARCHAR(250),
   @PostalCode   NVARCHAR(250)
)  
RETURNS varchar(500)  
BEGIN  
    DECLARE @result AS VARCHAR(500)='';

	SET @result=@result+IIF(@HouseNo<>'', ','+@HouseNo, '');
	SET @result=@result+IIF(@Apartment<>'', ','+@Apartment, '');
	SET @result=@result+IIF(@Floor<>'', ','+@Floor, '');
	SET @result=@result+IIF(@AddressLine<>'', ','+@AddressLine, '');
	SET @result=@result+IIF(@Building<>'', ','+@Building, '');
	SET @result=@result+IIF(@PostalCode<>'', ','+@PostalCode, '');

	SET @result=IIF(@result='', '', SUBSTRING(@result, 2, LEN(@result)));

	RETURN @result;
END
GO

--EXEC PROC_AUTOMATE_WORKER_ADDRESS_SET_SUB_TYPE_1AND5 '2020-10-11'

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW]
    @which_wavestage    AS VARCHAR(50),
	@which_report       AS VARCHAR(500),
	@which_date         AS VARCHAR(50)
AS
BEGIN
    EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS @which_wavestage, @which_report, @which_date;
END
GO

--Basic format(Dynamic String) SP
--SELECT * FROM WAVE_ADDRESS_VALIDATION
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING]
    @Flag                  AS VARCHAR(50)=''
AS
BEGIN
    PRINT @Flag;
    DECLARE @DynamicTable TABLE (
		SNo                       NVARCHAR(200),
		Prefix                    NVARCHAR(200)
	);

    INSERT INTO @DynamicTable VALUES('1', 'primary');
    INSERT INTO @DynamicTable VALUES('2', 'secondary');
	INSERT INTO @DynamicTable VALUES('3', 'third');
    INSERT INTO @DynamicTable VALUES('4', 'fourth');
	INSERT INTO @DynamicTable VALUES('5', 'fifth');
	INSERT INTO @DynamicTable VALUES('6', 'sixth');
	INSERT INTO @DynamicTable VALUES('7', 'seventh');
	INSERT INTO @DynamicTable VALUES('8', 'eightth');
	INSERT INTO @DynamicTable VALUES('9', 'nineth');
	INSERT INTO @DynamicTable VALUES('10', 'tenth');
	INSERT INTO @DynamicTable VALUES('11', 'eleventh');
	INSERT INTO @DynamicTable VALUES('12', 'twelveth');
	INSERT INTO @DynamicTable VALUES('13', 'thirteenth');
	INSERT INTO @DynamicTable VALUES('14', 'fourteenth');
	INSERT INTO @DynamicTable VALUES('15', 'fifteenth');

    DECLARE @SNo                   AS VARCHAR(10)='';
    DECLARE @Prefix                AS VARCHAR(50)='';
	DECLARE @SQL                   AS NVARCHAR(MAX)='';

	DECLARE cursor_item CURSOR FOR SELECT * FROM @DynamicTable;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF (@Flag='BASIC FORMAT')
		BEGIN
			exec('
			update WAVE_NM_address_source
			set '+@Prefix+'_city = null
			where '+@Prefix+'_country in 
			(
			SELECT  [Country2 Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Municipality(City)] IN (''Not Accepted'')
			)
			and '+@Prefix+'_city is not null;

			update WAVE_NM_address_source
			set '+@Prefix+'_Subregion = null
			where '+@Prefix+'_Country in 
			(
				SELECT  [Country2 Code] FROM WAVE_ADDRESS_VALIDATION WHERE [Region Subdivision 1] IN (''Not Accepted'')
			)
			and '+@Prefix+'_Subregion is not null;

			update WAVE_NM_address_source
			set '+@Prefix+'_city_subdivision = null
			where '+@Prefix+'_country in 
			(
				SELECT  [Country2 Code] FROM WAVE_ADDRESS_VALIDATION WHERE [City Subdivision] IN (''Not Accepted'')
			)
			and '+@Prefix+'_city_subdivision is not null;

			update WAVE_NM_address_source
			set '+@Prefix+'_postalcode = null
			where '+@Prefix+'_country = ''PA''
			and '+@Prefix+'_postalcode  is not null;

			update a
			set a.'+@Prefix+'_Country_Code = b.iso3
			from WAVE_NM_address_source a
			join COUNTRY_LKUP b
			on a.'+@Prefix+'_Country=b.iso2;
			');
		END

		IF (@Flag='SET LOCAL FLAG')
		BEGIN
			exec('
			update a 
			set Local'+@SNo+'_Flag = ''Y''
			from WAVE_NM_address a
			where dbo.GetNonEnglishName(concat(ISNULL('+@Prefix+'_addressline1, ''''),ISNULL('+@Prefix+'_Addressline2, ''''),ISNULL('+@Prefix+'_Addressline3, ''''),
											ISNULL('+@Prefix+'_Addressline4, ''''),ISNULL('+@Prefix+'_Addressline5, ''''),ISNULL('+@Prefix+'_Addressline6, ''''),
											ISNULL('+@Prefix+'_Addressline7, ''''),ISNULL('+@Prefix+'_Addressline8, ''''),ISNULL('+@Prefix+'_Addressline9, ''''),
											ISNULL('+@Prefix+'_city, ''''),ISNULL('+@Prefix+'_City_Subdivision, ''''),ISNULL('+@Prefix+'_subregion, ''''),
											ISNULL('+@Prefix+'_OR1KK, ''''),ISNULL('+@Prefix+'_OR2KK, ''''))) <> ''''
			and '+@Prefix+'_country_Code  in (''JPN'',''KOR'',''CHN'',''THA'',''TWN'',''RUS'',''UKR'',''GRC'',''EGY'');
			');
		END
		IF (@Flag='UPDATE REGION')
		BEGIN
		    exec('UPDATE WAVE_NM_address SET '+@Prefix+'_Region_referenceID='+@Prefix+'_region');
		END

	    FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;

	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	SELECT @SQL;
END
GO    

--Basic format(Dynamic String) Function
IF OBJECT_ID('dbo.GetDynamicStringInfo') IS NOT NULL
  DROP FUNCTION GetDynamicStringInfo
GO
CREATE FUNCTION GetDynamicStringInfo(
	@Flag                  AS VARCHAR(50)=''
)  
RETURNS NVARCHAR(MAX)  
BEGIN  
    DECLARE @DynamicTable TABLE (
		SNo                       NVARCHAR(200),
		Prefix                    NVARCHAR(200)
	);

    INSERT INTO @DynamicTable VALUES('1', 'primary');
    INSERT INTO @DynamicTable VALUES('2', 'secondary');
	INSERT INTO @DynamicTable VALUES('3', 'third');
    INSERT INTO @DynamicTable VALUES('4', 'fourth');
	INSERT INTO @DynamicTable VALUES('5', 'fifth');
	INSERT INTO @DynamicTable VALUES('6', 'sixth');
	INSERT INTO @DynamicTable VALUES('7', 'seventh');
	INSERT INTO @DynamicTable VALUES('8', 'eightth');
	INSERT INTO @DynamicTable VALUES('9', 'nineth');
	INSERT INTO @DynamicTable VALUES('10', 'tenth');
	INSERT INTO @DynamicTable VALUES('11', 'eleventh');
	INSERT INTO @DynamicTable VALUES('12', 'twelveth');
	INSERT INTO @DynamicTable VALUES('13', 'thirteenth');
	INSERT INTO @DynamicTable VALUES('14', 'fourteenth');
	INSERT INTO @DynamicTable VALUES('15', 'fifteenth');

    DECLARE @SNo                   AS VARCHAR(10)='';
    DECLARE @Prefix                AS VARCHAR(50)='';
	DECLARE @SQL                   AS VARCHAR(MAX)='';

	DECLARE cursor_item CURSOR FOR SELECT * FROM @DynamicTable;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF (@Flag='CREATE FIELDS')
		BEGIN
		   IF (@SQL<>'') SET @SQL=@SQL+',';
		   SET @SQL=@SQL+
		   'cast(null as nvarchar(255)) as '+@Prefix+'_effective_date,
			cast(null as nvarchar(255)) as '+@Prefix+'_country,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressLine1,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressLine2,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline3,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline4,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline5,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline6,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline7,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline8,
			cast(null as nvarchar(255)) as '+@Prefix+'_addressline9,
			cast(null as nvarchar(255)) as '+@Prefix+'_CareofName,
			cast(null as nvarchar(255)) as '+@Prefix+'_municipality,
			cast(null as nvarchar(255)) as '+@Prefix+'_city,
			cast(null as nvarchar(255)) as '+@Prefix+'_city_subdivision,
			cast(null as nvarchar(255)) as '+@Prefix+'_city_subdivision_1,
			cast(null as nvarchar(255)) as '+@Prefix+'_subregion,
			cast(null as nvarchar(255)) as '+@Prefix+'_region,
			cast(null as nvarchar(255)) as '+@Prefix+'_region_subdivision_1,
			cast(null as nvarchar(255)) as '+@Prefix+'_region_subdivision_2,
			cast(null as nvarchar(255)) as '+@Prefix+'_region_referenceid,
			cast(null as nvarchar(255)) as '+@Prefix+'_Country_code ,
			cast(null as nvarchar(255)) as '+@Prefix+'_postalcode,
			cast(null as nvarchar(255)) as '+@Prefix+'_prefecture,
			cast(null as nvarchar(255)) as '+@Prefix+'_OR1KK,
			cast(null as nvarchar(255)) as '+@Prefix+'_OR2KK,
			cast(null as nvarchar(255)) as '+@Prefix+'_CONKK,
			cast(null as nvarchar(500)) as '+@Prefix+'_SUBTY'
		END
		IF (@Flag='SELECT FIELDS')
		BEGIN
		   IF (@SQL<>'') SET @SQL=@SQL+',';
		   SET @SQL=@SQL+
		   '['+@Prefix+'_effective_date],
		    ['+@Prefix+'_country_code],
		    ['+@Prefix+'_addressLine1],
		    ['+@Prefix+'_addressLine2],
		    ['+@Prefix+'_addressLine3],
		    ['+@Prefix+'_addressLine4],
		    ['+@Prefix+'_addressLine5],
		    ['+@Prefix+'_addressLine6],
		    ['+@Prefix+'_addressLine7],
		    ['+@Prefix+'_addressLine8],
		    ['+@Prefix+'_addressLine9],
		    ['+@Prefix+'_city] ,
		    ['+@Prefix+'_city_subdivision],
		    ['+@Prefix+'_city_subdivision_1],
		    ['+@Prefix+'_subregion] ,
		    ['+@Prefix+'_region] ,
		    ['+@Prefix+'_region_subdivision_1],
		    ['+@Prefix+'_region_subdivision_2],
		    ['+@Prefix+'_Region_referenceID],
		    ['+@Prefix+'_postalcode], 
		    ['+@Prefix+'_OR1KK],
		    ['+@Prefix+'_OR2KK],
		    ['+@Prefix+'_CONKK],
		    ['+@Prefix+'_CareOfName],
		    case when ['+@Prefix+'_country_code] is not null then ''No''  end as '+@Prefix+'_public,
		    case when ['+@Prefix+'_country_code] is not null then ''permanent''  end as '+@Prefix+'_usage,
			['+@Prefix+'_SUBTY]'

		END

	    FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;

	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	RETURN @SQL;
END
GO    

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_REGION_ISSUE', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_REGION_ISSUE;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_REGION_ISSUE]
    @Flag           AS NVARCHAR(50)
AS
BEGIN
    DECLARE @DynamicTable TABLE (
		SNo                       NVARCHAR(200),
		Prefix                    NVARCHAR(200)
	);

    INSERT INTO @DynamicTable VALUES('1', 'primary');
    INSERT INTO @DynamicTable VALUES('2', 'secondary');
	INSERT INTO @DynamicTable VALUES('3', 'third');
    INSERT INTO @DynamicTable VALUES('4', 'fourth');
	INSERT INTO @DynamicTable VALUES('5', 'fifth');
	INSERT INTO @DynamicTable VALUES('6', 'sixth');
	INSERT INTO @DynamicTable VALUES('7', 'seventh');
	INSERT INTO @DynamicTable VALUES('8', 'eightth');
	INSERT INTO @DynamicTable VALUES('9', 'nineth');
	INSERT INTO @DynamicTable VALUES('10', 'tenth');
	INSERT INTO @DynamicTable VALUES('11', 'eleventh');
	INSERT INTO @DynamicTable VALUES('12', 'twelveth');
	INSERT INTO @DynamicTable VALUES('13', 'thirteenth');
	INSERT INTO @DynamicTable VALUES('14', 'fourteenth');
	INSERT INTO @DynamicTable VALUES('15', 'fifteenth');

    DECLARE @SNo                                    AS VARCHAR(10)='';
    DECLARE @Prefix                                 AS VARCHAR(50)='';
	DECLARE @NSQL_Region_Country_Mismatch           AS NVARCHAR(MAX)='';
	DECLARE @NSQL_Region_Country_Mismatch_Local     AS NVARCHAR(MAX)='';
	DECLARE @NSQL_Region_Blank_Value                AS NVARCHAR(MAX)='';
	DECLARE @NSQL_Region_Blank_Value_Local          AS NVARCHAR(MAX)='';

	DECLARE cursor_item CURSOR FOR SELECT * FROM @DynamicTable;
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @NSQL_Region_Country_Mismatch<>'' SET @NSQL_Region_Country_Mismatch=@NSQL_Region_Country_Mismatch+'UNION ALL';
	    SET @NSQL_Region_Country_Mismatch=@NSQL_Region_Country_Mismatch+'
		SELECT [EmployeeID] [Employee ID Region(Primary) Mismatch with country code], [HomeAddress'+@SNo+'Data_CountryISOCode], [HomeAddress'+@SNo+'Data_State(Region)] 
		   FROM WD_HR_TR_WorkerAddress
		   WHERe ISNULL([HomeAddress'+@SNo+'Data_CountryISOCode], '''') <> '''' AND ISNULL([HomeAddress'+@SNo+'Data_State(Region)], '''') <> '''' AND
						[HomeAddress'+@SNo+'Data_CountryISOCode]<>SUBSTRING([HomeAddress'+@SNo+'Data_State(Region)], 1, 3)
		';

	    IF @NSQL_Region_Country_Mismatch_Local<>'' SET @NSQL_Region_Country_Mismatch_Local=@NSQL_Region_Country_Mismatch_Local+'UNION ALL';
	    SET @NSQL_Region_Country_Mismatch_Local=@NSQL_Region_Country_Mismatch_Local+'
		SELECT [EmployeeID] [Employee ID Region(Local 1) Mismatch with country code], [Home_Address_Local'+@SNo+'Data_ISO_Code], [Home_Address_Local'+@SNo+'Data_REGION_ID]
		   FROM WD_HR_TR_WorkerAddress
		   WHERe ISNULL([Home_Address_Local'+@SNo+'Data_ISO_Code], '''') <> '''' AND ISNULL([Home_Address_Local'+@SNo+'Data_REGION_ID], '''') <> '''' AND
						[Home_Address_Local'+@SNo+'Data_ISO_Code]<>SUBSTRING([Home_Address_Local'+@SNo+'Data_REGION_ID], 1, 3)
		';

		IF @NSQL_Region_Blank_Value<>'' SET @NSQL_Region_Blank_Value=@NSQL_Region_Blank_Value+'UNION ALL';
		SET @NSQL_Region_Blank_Value=@NSQL_Region_Blank_Value+'
		SELECT [EmployeeID] [Employee ID Region(Primary) with blank value], [HomeAddress'+@SNo+'Data_CountryISOCode], [HomeAddress'+@SNo+'Data_State(Region)] 
		   FROM WD_HR_TR_WorkerAddress
		   WHERe ISNULL([HomeAddress'+@SNo+'Data_CountryISOCode], '''') <> '''' AND ISNULL([HomeAddress'+@SNo+'Data_State(Region)], '''') = '''' AND
						[HomeAddress'+@SNo+'Data_CountryISOCode] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]=''Required'')
		';

		IF @NSQL_Region_Blank_Value_Local<>'' SET @NSQL_Region_Blank_Value_Local=@NSQL_Region_Blank_Value_Local+'UNION ALL';
		SET @NSQL_Region_Blank_Value_Local=@NSQL_Region_Blank_Value_Local+'
		SELECT [EmployeeID] [Employee ID Region(Local 1) with blank value], [Home_Address_Local'+@SNo+'Data_ISO_Code], [Home_Address_Local'+@SNo+'Data_REGION_ID] 
		   FROM WD_HR_TR_WorkerAddress
		   WHERe ISNULL([Home_Address_Local'+@SNo+'Data_ISO_Code], '''') <> '''' AND ISNULL([Home_Address_Local'+@SNo+'Data_REGION_ID], '''') = '''' AND
						[Home_Address_Local'+@SNo+'Data_ISO_Code] IN (SELECT [COUNTRY CODE] FROM WAVE_ADDRESS_VALIDATION WHERE [Region(State)]=''Required'')
		';
		
		FETCH NEXT FROM cursor_item INTO @SNo, @Prefix;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	IF @NSQL_Region_Country_Mismatch<>'' EXEC(@NSQL_Region_Country_Mismatch);
	PRINT @NSQL_Region_Country_Mismatch;
	IF @NSQL_Region_Country_Mismatch_Local<>'' EXEC(@NSQL_Region_Country_Mismatch_Local);
	IF @NSQL_Region_Blank_Value<>'' EXEC(@NSQL_Region_Blank_Value);
	IF @NSQL_Region_Blank_Value_Local<>'' EXEC(@NSQL_Region_Blank_Value_Local);
  
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_MAPPING_TABLE', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_MAPPING_TABLE;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_MAPPING_TABLE]
AS
BEGIN
	DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_ADDRESS_MAPPING_TABLE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

    SELECT DISTINCT A1.[MAP_ISO2], A1.[MAP_COUNT], A1.[MAP_SOURCE_FIELD] INTO WAVE_NM_ADDRESS_MAPPING_TABLE FROM (
		  SELECT LAND1 [MAP_ISO2], COUNT(STRAS) [MAP_COUNT], 'STRAS' [MAP_SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(LOCAT) [COUNT], 'LOCAT' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(STATE) [COUNT], 'STATE' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(COUNC) [COUNT], 'COUNC' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(ORT01) [COUNT], 'ORT01' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(ORT02) [COUNT], 'ORT02' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(POSTA) [COUNT], 'POSTA' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(RCTVC) [COUNT], 'RCTVC' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		   UNION ALL
		  SELECT LAND1 [ISO2], COUNT(ADR03) [COUNT], 'ADR03' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(ADR04) [COUNT], 'ADR04' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(OR1KK) [COUNT], 'OR1KK' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(OR2KK) [COUNT], 'OR2KK' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(CONKK) [COUNT], 'CONKK' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(WKWNG) [COUNT], 'WKWNG' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(BUSRT) [COUNT], 'BUSRT' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(HSNMR) [COUNT], 'HSNMR' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(BLDNG) [COUNT], 'BLDNG' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(FLOOR) [COUNT], 'FLOOR' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
		  UNION ALL
		  SELECT LAND1 [ISO2], COUNT(PSTLZ) [COUNT], 'PSTLZ' [SOURCE_FIELD]
		  FROM P0_PA0006
		  WHERE begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
		  GROUP BY LAND1
	) A1 LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A2.[COUNTRY2 CODE]=A1.[MAP_ISO2]
	WHERE A2.[COUNTRY2 CODE] IS NOT NULL AND [MAP_COUNT] >= 1

	--SELECT TOP 1 * FROM P0_PA0006

	/*
	SELECT * 
	   FROM WAVE_NM_ADDRESS_MAPPING_TABLE A1 FULL JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.MAP_ISO2=A2.ISO2 AND A1.MAP_SOURCE_FIELD=A2.SRC_MAP_FIELD
	ORDER BY [MAP_ISO2], [MAP_SOURCE_FIELD]

	SELECT * 
	   FROM WAVE_NM_ADDRESS_MAPPING_TABLE A1 FULL JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.MAP_ISO2=A2.ISO2 AND A1.MAP_SOURCE_FIELD=A2.SRC_MAP_FIELD
	   WHERE A1.MAP_ISO2 IS NULL
	ORDER BY [MAP_ISO2], [MAP_SOURCE_FIELD]
	*/

	SELECT * 
	   FROM WAVE_NM_ADDRESS_MAPPING_TABLE A1 FULL JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.MAP_ISO2=A2.ISO2 AND A1.MAP_SOURCE_FIELD=A2.SRC_MAP_FIELD
	   WHERE ISO2 IS NULL AND MAP_ISO2 IS NOT NULL
	ORDER BY [MAP_ISO2], [MAP_SOURCE_FIELD]

	--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_FINAL WHERE ISO2='TW' ORDER BY DST_MAP_FIELD
	--SELECT * FROM WAVE_ADDRESS_VALIDATION_FLAG WHERE ISO2='BE'

	SELECT DISTINCT ISO, '' SEC_FIELD, '' SRC_MAP_FIELD, [Field] DST_FIELD, [Field] DST_MAP_FIELD, '1' [INDEX], 'MAPPING' [OPERATION], 'Basic' FLAG, [VALIDATION] FROM (
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #1' [Field], A1.[Address Line #1] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine1'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line #1]='Required' OR A1.[Address Line #1]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #2' [Field], A1.[Address Line #2] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine2'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line #2]='Required' OR A1.[Address Line #2]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #3' [Field], A1.[Address Line #3] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine3'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line #3]='Required' OR A1.[Address Line #3]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #4' [Field], A1.[Address Line #4] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine4'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line #4]='Required' OR A1.[Address Line #4]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #5' [Field], A1.[Address Line 5] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine5'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line 5]='Required' OR A1.[Address Line 5]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #6' [Field], A1.[Address Line 6] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine6'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line 6]='Required' OR A1.[Address Line 6]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #7' [Field], A1.[Address Line 7] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine7'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line 7]='Required' OR A1.[Address Line 7]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Address Line #8' [Field], A1.[Address Line 8] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_addressLine8'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Address Line 8]='Required' OR A1.[Address Line 8]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Municipality(City)' [Field], A1.[Municipality(City)] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_city'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Municipality(City)]='Required' OR A1.[Municipality(City)]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'City Subdivision' [Field], A1.[City Subdivision] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_city_subdivision'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[City Subdivision]='Required' OR A1.[City Subdivision]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'City Subdivision 2' [Field], A1.[City Subdivision 2] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_city_subdivision_1'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[City Subdivision 2]='Required' OR A1.[City Subdivision 2]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Postal Code' [Field], A1.[Postal Code] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_postalcode'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Postal Code]='Required' OR A1.[Postal Code]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Region(State)' [Field], A1.[Region(State)] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_Region'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Region(State)]='Required' OR A1.[Region(State)]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Region Subdivision 1' [Field], A1.[Region Subdivision 1] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_region_subdivision_1'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Region Subdivision 1]='Required' OR A1.[Region Subdivision 1]='Optional')
	UNION ALL
	SELECT DISTINCT A1.[Country2 Code] [ISO], A2.[ISO2], 'Region Subdivision 2' [Field], A1.[Region Subdivision 2] [Validation] 
	   FROM WAVE_ADDRESS_VALIDATION A1 LEFT JOIN SET_ADDRESS_FIELD_MAPPING_DONE A2 ON A1.[Country2 Code]=A2.ISO2 AND A2.DST_MAP_FIELD ='_region_subdivision_2'
	   WHERE A2.DST_MAP_FIELD IS NULL AND (A1.[Region Subdivision 2]='Required' OR A1.[Region Subdivision 2]='Optional')
	) A1

END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW 'P0', 'Worker Address', '2021-03-10'
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_MAPPING_TABLE
--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_FINAL WHERE ISO2='GB' ORDER BY DST_MAP_FIELD
--SELECT DISTINCT DST_MAP_FIELD FROM SET_ADDRESS_FIELD_MAPPING_DONE
--SELECT DISTINCT HSNMR FROM WAVE_NM_PA0006 WHERE LAND1='CA' AND begDa<=CAST('2021-03-10' as date) and endda>=CAST('2021-03-10' as date)
--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_FINAL WHERE ISO2='BE' ORDER BY DST_MAP_FIELD
--SELECT * FROM WAVE_ADDRESS_VALIDATION

--AU,AZ,BD,BS,CA,CL,CM,CN,CY,CZ,DZ,ET,FR,GB,GH,HK,HU,IE,IN,IT,KH,LI,LU,MK,MX,MY,NE,NP,NZ,OM,PS,RS,RU,RW,SI,TH,TN,TW,US,ZA

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS]
    @which_wavestage      AS NVARCHAR(50),
	@which_report         AS NVARCHAR(500),
	@which_date           AS NVARCHAR(50)
AS
BEGIN

--04010629
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW 'P0', 'Worker Address', '2021-03-10'
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [EmployeeID]='37006057' ORDER BY [EmployeeID]
--SELECT * FROM P0_PA0006 WHERE PERNR='37006057'
--SELECT * FROM WAVE_NM_PA0006 WHERE PERNR='37006057'
--SELECT DISTINCT SUBTY FROM WAVE_NM_PA0006 WHERE PERNR='37006057'
--EXEC PROC_AUTOMATE_WORKER_ADDRESS_ERROR_REPORT
--SELECT * FROM NOVARTIS_DATA_MIGRATION_ADDRESS_VALIDATION  ORDER BY [Build Number], [Report Name], [Employee ID]
--SELECT * FROM T591S
--GH,HK,HU,IN,KR,RS,TW,ZA

--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_REGION_ISSUE 'ISSUE'
--EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_NEW 'W4_P2', 'Emergency Contact', '2020-10-02'
--SELECT * FROM WD_HR_TR_WorkerAddress ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [PrimaryHomeAddressData_State(Region)] <> ''-- ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [PRIMARYHOMEADDRESSDATA_STATE(REGION)] <> '' ORDER BY [EmployeeID]
--SELECT * FROM ALCON_MIGRATION_ERROR_LIST WHERE Wave='W4_P2' AND [Report Name]='Worker Address' ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [EmployeeID] ='04010629' ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [PrimaryHomeAddressData_State(Region)] <> '' OR [HomeAddress2Data_State(Region)]<>'' ORDER BY [EmployeeID]
--SELECT * FROM WAVE_ADDRESS_VALIDATION
--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_DONE ORDER BY ISO2, DST_MAP_FIELD, [INDEX]
--SELECT DISTINCT * FROM SET_ADDRESS_FIELD_MAPPING_DONE WHERE ISO2='BS' ORDER BY ISO2, DST_MAP_FIELD, [INDEX]
--SELECT * FROM P0_POSITION_MANAGEMENT
--SELECT DISTINCt TOWN FROM P0_PA0006 WHERE LAND1='TW'
--BS, EE, TW

	update [HRcore_Region_Text]
	set region = concat('0',region)
	where region like '[0-9]'
	and len(region) = 1;

	DECLARE @SQL AS VARCHAR(4000)='drop table if exists WAVE_NM_address_phone_source;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT FROM '+@which_wavestage+'_POSITION_MANAGEMENT WHERE [Org - Company Code] <> ''RU08''';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	SET @SQL='drop table if exists WAVE_NM_SUP_ORG_SOURCE;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_SUP_ORG_SOURCE FROM '+SUBSTRING(@which_wavestage, 1, 2)+'_SUP_ORG_SOURCE';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	/* Required Info type table */
	--SELECT TOP 10 * FROM P0_PA0006
	SET @SQL='drop table if exists WAVE_NM_PA0006;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY PERNR) RNUM INTO WAVE_NM_PA0006 
	               FROM '+@which_wavestage+'_PA0006 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='alter table WAVE_NM_PA0006 add SHOW_SUBTY nvarchar(255);
	          alter table WAVE_NM_PA0006 add SHOW_SUBTY_TEXT nvarchar(255); 
	          alter table WAVE_NM_PA0006 add TOWN nvarchar(255);
	          alter table WAVE_NM_PA0006 add NEIGN nvarchar(255);
	          alter table WAVE_NM_PA0006 add NEIGH nvarchar(255); 
			  alter table WAVE_NM_PA0006 add MUNIC nvarchar(255);
	          alter table WAVE_NM_PA0006 add VILLA nvarchar(255);
			  alter table WAVE_NM_PA0006 add NBHD nvarchar(255);
	          alter table WAVE_NM_PA0006 add ORG_COMPANY nvarchar(255);
	          alter table WAVE_NM_PA0006 add CC nvarchar(255);
			  alter table WAVE_NM_PA0006 add Emp_Group nvarchar(255);
			  alter table WAVE_NM_PA0006 add FIELD_TYPE nvarchar(255);
			  alter table WAVE_NM_PA0006 add ROW_NUM INT;'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	SET @SQL='drop table WAVE_NM_PA0352;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0352 FROM '+@which_wavestage+'_PA0352 WHERE endda >=CAST('''+@which_date+''' as date)	and begda <= CAST('''+@which_date+''' as date);;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	UPDATE A1 SET 
	    VILLA=V2.VILLA,
		NEIGH=V2.NEIGH,
		TOWN=V2.TOWN
	FROM WAVE_NM_PA0006 A1 JOIN WAVE_NM_PA0352 A2 ON A1.PERNR=A2.PERNR
	--SELECT PERNR, BEGDA, ENDDA, VILLA, NEIGH, TOWN FROM P0_PA0352

	-- Set Address Validation table
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WAVE_ADDRESS_VALIDATION;';
	SELECT DISTINCT A1.* INTO WAVE_ADDRESS_VALIDATION 
	  FROM WAVE_ADDRESS_VALIDATION_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[Country2 Code]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]

	--Set Field Mapping table
	--UPDATE SET_ADDRESS_FIELD_MAPPING_FINAL SET FLAG='Basic'
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists SET_ADDRESS_FIELD_MAPPING_DONE;';
	SELECT DISTINCT A1.* INTO SET_ADDRESS_FIELD_MAPPING_DONE 
	  FROM SET_ADDRESS_FIELD_MAPPING_FINAL A1 JOIN WAVE_ADDRESS_VALIDATION_FLAG A2 ON A1.[ISO2]=A2.[Country2 Code] AND A1.[Flag]=A2.[Flag]
	  WHERE ISNULL(SRC_MAP_FIELD, '') <> '' AND ISNULL(DST_MAP_FIELD, '') <> ''
	DELETE FROM SET_ADDRESS_FIELD_MAPPING_DONE WHERE ISNULL(ISO2, '') = ''
	
	-- If both STRAS and LOCAT is null then Move primary to secondary
	EXEC PROC_AUTOMATE_WORKER_ADDRESS_SET_SUB_TYPE_1AND5 @which_date

	SET @SQL='drop table if exists WAVE_NM_address_source_data;
	          drop table if exists WAVE_NM_address_source;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	DECLARE @NSQL NVARCHAR(MAX)=dbo.GetDynamicStringInfo('CREATE FIELDS');
	EXEC(N'
	select persno,
	'+@NSQL+'
	into WAVE_NM_address_source_data
    FROM [dbo].[WAVE_NM_PA0006] A1
	JOIN WAVE_NM_SUP_ORG_SOURCE A2 ON A1.pernr = A2.persno
	');
	--SELECT * FROM WAVE_NM_address_source_data

    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '1';
	EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '2';
	EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '3';
	EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '4';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '5';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '6';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '7';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '8';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '9';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '10';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '11';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '12';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '13';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '14';
    EXEC [PROC_AUTOMATE_WORKER_ADDRESS_EXECUTE_EXT_FORMAT] @which_date, '15';

    --SELECT * FROM WAVE_NM_address_source where primary_addressline2 is not null
	SELECT * INTO WAVE_NM_address_source FROM (
		SELECT *, ROW_NUMBER() OVER(PARTITION BY PERSNO ORDER BY PERSNO) ROW_NUM FROM WAVE_NM_address_source_data
	) A1 WHERE ROW_NUM=1
    
    -- Not accepted data movement
    EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING 'BASIC FORMAT';

	SET @SQL='drop table if exists WAVE_NM_address;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SET @NSQL=dbo.GetDynamicStringInfo('SELECT FIELDS');
	PRINT @NSQL
	EXEC('
	select
	    [persno] ,
		[persno] [PERSNO_NEW],
	    [Emp - Personnel Number],
	    '+@NSQL+',
		[Emp - Group],
		[WD_EMP_TYPE],
		[Geo - Country (CC)]
		into WAVE_NM_address
	FROM WAVE_NM_address_source a
	join WAVE_NM_position_management b
	on a.persno =b.[emp - personnel number];
	');
	--SELECT * FROM WAVE_NM_address
    
	/* Region Mapping */
	EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING 'UPDATE REGION';

    /* Local Name Flag */
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_address
                                             add  Local1_Flag nvarchar(25),  
											      Local2_Flag nvarchar(25),
												  Local3_Flag nvarchar(25),
												  Local4_Flag nvarchar(25),
                                                  Local5_Flag nvarchar(25),
                                                  Local6_Flag nvarchar(25),
                                                  Local7_Flag nvarchar(25),
                                                  Local8_Flag nvarchar(25),
                                                  Local9_Flag nvarchar(25),
                                                  Local10_Flag nvarchar(25),
                                                  Local11_Flag nvarchar(25),
                                                  Local12_Flag nvarchar(25),
                                                  Local13_Flag nvarchar(25),
                                                  Local14_Flag nvarchar(25),
                                                  Local15_Flag nvarchar(25);';

    --Set Local names flag
    EXEC PROC_WAVE_NM_AUTOMATE_WORKER_ADDRESS_DYNAMIC_STRING 'SET LOCAL FLAG';

	SET @SQL='drop table if exists WAVE_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_POSITION_MANAGEMENT FROM WAVE_NM_POSITION_MANAGEMENT;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;

	/* Populating data in final table */
    SET @SQL='drop table if exists WD_HR_TR_WorkerAddress;
	          drop table if exists WD_HR_TR_WORKERADDRESS_EMPGROUP_04;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

    SELECT ISNULL(PERSNO, '') [LegacySystemID] 
            ,ISNULL(PERSNO, '') [EmployeeID]
            ,ISNULL([persno_new], '')  [ApplicantID]

			-------------------------------------------
            ,'' [HomeAddress1Data_Row]
            ,IIF(Local1_Flag is null,IIF(ISNULL(primary_effective_date, '')='', '', CONVERT(varchar(10), CAST(primary_effective_date as date), 101)),'')  [HomeAddress1Data_EffectiveDate]
            ,IIF(Local1_Flag is null,ISNULL(primary_country_code, ''),'')  [HomeAddress1Data_CountryISOCode]
            ,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline1, 'Y'), ''),'')  [HomeAddress1Data_AddressLine1]
            ,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline2, 'Y'), ''),'')  [HomeAddress1Data_AddressLine2]
            ,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline3, 'Y'), ''),'') [HomeAddress1Data_AddressLine3]
            ,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline4, 'Y'), ''),'')  [HomeAddress1Data_AddressLine4]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline5, 'Y'), ''),'')  [HomeAddress1Data_AddressLine5]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline6, 'Y'), ''),'')  [HomeAddress1Data_AddressLine6]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline7, 'Y'), ''),'')  [HomeAddress1Data_AddressLine7]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline8, 'Y'), ''),'')  [HomeAddress1Data_AddressLine8]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline9, 'Y'), ''),'')  [HomeAddress1Data_AddressLine9]
            ,IIF(Local1_Flag is null,ISNULL(primary_city, ''),'')  [HomeAddress1Data_City(Municipality)]
            ,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_city_subdivision, 'N'), ''),'')  [HomeAddress1Data_SubMunicipalityType]
			,IIF(Local1_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(primary_city_subdivision_1, 'N'), ''),'')  [HomeAddress1Data_CitySubdivision_1]
            ,''[HomeAddress1Data_SubMunicipality]
            ,IIF(Local1_Flag is null,ISNULL(primary_Region_ReferenceID, '') ,'') [HomeAddress1Data_State(Region)]
            ,''[HomeAddress1Data_SubregionDescriptor]
            ,''[HomeAddress1Data_SubregionType]
            ,IIF(Local1_Flag is null,ISNULL(primary_subregion, ''),'')  [HomeAddress1Data_Subregion(County)]
			,IIF(Local1_Flag is null,ISNULL(primary_region_subdivision_1, ''),'')  [HomeAddress1Data_RegionSubdivision_1]
			,IIF(Local1_Flag is null,ISNULL(primary_region_subdivision_2, ''),'')  [HomeAddress1Data_RegionSubdivision_2]
            ,IIF(Local1_Flag is null,IIF(primary_country_code='CHN' AND ISNULL(primary_postalcode, '')='', '000000', ISNULL(primary_postalcode, '')) ,'') [HomeAddress1Data_PostalCode]
            ,IIF(Local1_Flag is null,ISNULL(primary_public, ''),'') [HomeAddress1Data_Public]
            ,IIF(Local1_Flag is null,ISNULL(primary_usage, '') ,'') [HomeAddress1Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress2Data_Row]
            ,IIF(Local2_Flag is null,IIF(ISNULL(secondary_effective_date, '')='', '', CONVERT(varchar(10), CAST(secondary_effective_date as date), 101)),'')  [HomeAddress2Data_EffectiveDate]
            ,IIF(Local2_Flag is null,ISNULL(secondary_country_code, ''),'')  [HomeAddress2Data_CountryISOCode]
            ,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline1, 'Y'), ''),'')  [HomeAddress2Data_AddressLine1]
            ,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline2, 'Y'), ''),'')  [HomeAddress2Data_AddressLine2]
            ,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline3, 'Y'), ''),'') [HomeAddress2Data_AddressLine3]
            ,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline4, 'Y'), ''),'')  [HomeAddress2Data_AddressLine4]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline5, 'Y'), ''),'')  [HomeAddress2Data_AddressLine5]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline6, 'Y'), ''),'')  [HomeAddress2Data_AddressLine6]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline7, 'Y'), ''),'')  [HomeAddress2Data_AddressLine7]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline8, 'Y'), ''),'')  [HomeAddress2Data_AddressLine8]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_addressline9, 'Y'), ''),'')  [HomeAddress2Data_AddressLine9]
            ,IIF(Local2_Flag is null,ISNULL(secondary_city, ''),'')  [HomeAddress2Data_City(Municipality)]
            ,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_city_subdivision, 'N'), ''),'')  [HomeAddress2Data_SubMunicipalityType]
			,IIF(Local2_Flag is null, ISNULL(dbo.RemoveFLCommaCharacter(secondary_city_subdivision_1, 'N'), ''),'')  [HomeAddress2Data_CitySubdivision_1]
            ,''[HomeAddress2Data_SubMunicipality]
            ,IIF(Local2_Flag is null,ISNULL(secondary_Region_ReferenceID, '') ,'') [HomeAddress2Data_State(Region)]
            ,''[HomeAddress2Data_SubregionDescriptor]
            ,''[HomeAddress2Data_SubregionType]
            ,IIF(Local2_Flag is null,ISNULL(secondary_subregion, ''),'')  [HomeAddress2Data_Subregion(County)]
			,IIF(Local2_Flag is null,ISNULL(secondary_region_subdivision_1, ''),'')  [HomeAddress2Data_RegionSubdivision_1]
			,IIF(Local2_Flag is null,ISNULL(secondary_region_subdivision_2, ''),'')  [HomeAddress2Data_RegionSubdivision_2]
            ,IIF(Local2_Flag is null,IIF(secondary_country_code='CHN' AND ISNULL(secondary_postalcode, '')='', '000000', ISNULL(secondary_postalcode, '')) ,'') [HomeAddress2Data_PostalCode]
            ,IIF(Local2_Flag is null,ISNULL(secondary_public, ''),'') [HomeAddress2Data_Public]
            ,IIF(Local2_Flag is null,ISNULL(secondary_usage, '') ,'') [HomeAddress2Data_Usage]

			
			-------------------------------------------
            ,'' [HomeAddress3Data_Row]
            ,IIF(local3_Flag is null,IIF(ISNULL(third_effective_date, '')='', '', CONVERT(varchar(10), CAST(third_effective_date as date), 101)),'')  [HomeAddress3Data_EffectiveDate]
            ,IIF(local3_Flag is null,ISNULL(third_country_code, ''),'')  [HomeAddress3Data_CountryISOCode]
            ,IIF(local3_Flag is null,ISNULL(third_addressline1, ''),'')  [HomeAddress3Data_AddressLine1]
            ,IIF(local3_Flag is null,ISNULL(third_addressline2, ''),'')  [HomeAddress3Data_AddressLine2]
            ,IIF(local3_Flag is null,ISNULL(third_addressline3, '') ,'') [HomeAddress3Data_AddressLine3]
            ,IIF(local3_Flag is null,ISNULL(third_addressline4, ''),'')  [HomeAddress3Data_AddressLine4]
			,IIF(local3_Flag is null,ISNULL(third_addressline5, ''),'')  [HomeAddress3Data_AddressLine5]
			,IIF(local3_Flag is null,ISNULL(third_addressline6, ''),'')  [HomeAddress3Data_AddressLine6]
			,IIF(local3_Flag is null,ISNULL(third_addressline7, ''),'')  [HomeAddress3Data_AddressLine7]
			,IIF(local3_Flag is null,ISNULL(third_addressline8, ''),'')  [HomeAddress3Data_AddressLine8]
			,IIF(local3_Flag is null,ISNULL(third_addressline9, ''),'')  [HomeAddress3Data_AddressLine9]
            ,IIF(local3_Flag is null,ISNULL(third_city, ''),'')  [HomeAddress3Data_City(Municipality)]
            ,IIF(local3_Flag is null,ISNULL(third_city_subdivision, ''),'')  [HomeAddress3Data_SubMunicipalityType]
			,IIF(local3_Flag is null,ISNULL(third_city_subdivision_1, ''),'')  [HomeAddress3Data_CitySubdivision_1]
            ,''[HomeAddress3Data_SubMunicipality]
            ,IIF(local3_Flag is null,ISNULL(third_Region_ReferenceID, '') ,'') [HomeAddress3Data_State(Region)]
            ,''[HomeAddress3Data_SubregionDescriptor]
            ,''[HomeAddress3Data_SubregionType]
            ,IIF(local3_Flag is null,ISNULL(third_subregion, ''),'')  [HomeAddress3Data_Subregion(County)]
			,IIF(local3_Flag is null,ISNULL(third_region_subdivision_1, ''),'')  [HomeAddress3Data_RegionSubdivision_1]
			,IIF(local3_Flag is null,ISNULL(third_region_subdivision_2, ''),'')  [HomeAddress3Data_RegionSubdivision_2]
            ,IIF(local3_Flag is null,IIF(third_country_code='CHN' AND ISNULL(third_postalcode, '')='', '000000', ISNULL(third_postalcode, '')) ,'') [HomeAddress3Data_PostalCode]
            ,IIF(local3_Flag is null,ISNULL(third_public, ''),'') [HomeAddress3Data_Public]
            ,IIF(local3_Flag is null,ISNULL(third_usage, '') ,'') [HomeAddress3Data_Usage]

			-------------------------------------------
            ,'' [HomeAddress4Data_Row]
            ,IIF(local4_Flag is null,IIF(ISNULL(fourth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fourth_effective_date as date), 101)),'')  [HomeAddress4Data_EffectiveDate]
            ,IIF(local4_Flag is null,ISNULL(fourth_country_code, ''),'')  [HomeAddress4Data_CountryISOCode]
            ,IIF(local4_Flag is null,ISNULL(fourth_addressline1, ''),'')  [HomeAddress4Data_AddressLine1]
            ,IIF(local4_Flag is null,ISNULL(fourth_addressline2, ''),'')  [HomeAddress4Data_AddressLine2]
            ,IIF(local4_Flag is null,ISNULL(fourth_addressline3, '') ,'') [HomeAddress4Data_AddressLine3]
            ,IIF(local4_Flag is null,ISNULL(fourth_addressline4, ''),'')  [HomeAddress4Data_AddressLine4]
			,IIF(local4_Flag is null,ISNULL(fourth_addressline5, ''),'')  [HomeAddress4Data_AddressLine5]
			,IIF(local4_Flag is null,ISNULL(fourth_addressline6, ''),'')  [HomeAddress4Data_AddressLine6]
			,IIF(local4_Flag is null,ISNULL(fourth_addressline7, ''),'')  [HomeAddress4Data_AddressLine7]
			,IIF(local4_Flag is null,ISNULL(fourth_addressline8, ''),'')  [HomeAddress4Data_AddressLine8]
			,IIF(local4_Flag is null,ISNULL(fourth_addressline9, ''),'')  [HomeAddress4Data_AddressLine9]
            ,IIF(local4_Flag is null,ISNULL(fourth_city, ''),'')  [HomeAddress4Data_City(Municipality)]
            ,IIF(local4_Flag is null,ISNULL(fourth_city_subdivision, ''),'')  [HomeAddress4Data_SubMunicipalityType]
			,IIF(local4_Flag is null,ISNULL(fourth_city_subdivision_1, ''),'')  [HomeAddress4Data_CitySubdivision_1]
            ,''[HomeAddress4Data_SubMunicipality]
            ,IIF(local4_Flag is null,ISNULL(fourth_Region_ReferenceID, '') ,'') [HomeAddress4Data_State(Region)]
            ,''[HomeAddress4Data_SubregionDescriptor]
            ,''[HomeAddress4Data_SubregionType]
            ,IIF(local4_Flag is null,ISNULL(fourth_subregion, ''),'')  [HomeAddress4Data_Subregion(County)]
			,IIF(local4_Flag is null,ISNULL(fourth_region_subdivision_1, ''),'')  [HomeAddress4Data_RegionSubdivision_1]
			,IIF(local4_Flag is null,ISNULL(fourth_region_subdivision_2, ''),'')  [HomeAddress4Data_RegionSubdivision_2]
            ,IIF(local4_Flag is null,IIF(fourth_country_code='CHN' AND ISNULL(fourth_postalcode, '')='', '000000', ISNULL(fourth_postalcode, '')) ,'') [HomeAddress4Data_PostalCode]
            ,IIF(local4_Flag is null,ISNULL(fourth_public, ''),'') [HomeAddress4Data_Public]
            ,IIF(local4_Flag is null,ISNULL(fourth_usage, '') ,'') [HomeAddress4Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress5Data_Row]
            ,IIF(local5_Flag is null,IIF(ISNULL(fifth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fifth_effective_date as date), 101)),'')  [HomeAddress5Data_EffectiveDate]
            ,IIF(local5_Flag is null,ISNULL(fifth_country_code, ''),'')  [HomeAddress5Data_CountryISOCode]
            ,IIF(local5_Flag is null,ISNULL(fifth_addressline1, ''),'')  [HomeAddress5Data_AddressLine1]
            ,IIF(local5_Flag is null,ISNULL(fifth_addressline2, ''),'')  [HomeAddress5Data_AddressLine2]
            ,IIF(local5_Flag is null,ISNULL(fifth_addressline3, '') ,'') [HomeAddress5Data_AddressLine3]
            ,IIF(local5_Flag is null,ISNULL(fifth_addressline4, ''),'')  [HomeAddress5Data_AddressLine4]
			,IIF(local5_Flag is null,ISNULL(fifth_addressline5, ''),'')  [HomeAddress5Data_AddressLine5]
			,IIF(local5_Flag is null,ISNULL(fifth_addressline6, ''),'')  [HomeAddress5Data_AddressLine6]
			,IIF(local5_Flag is null,ISNULL(fifth_addressline7, ''),'')  [HomeAddress5Data_AddressLine7]
			,IIF(local5_Flag is null,ISNULL(fifth_addressline8, ''),'')  [HomeAddress5Data_AddressLine8]
			,IIF(local5_Flag is null,ISNULL(fifth_addressline9, ''),'')  [HomeAddress5Data_AddressLine9]
            ,IIF(local5_Flag is null,ISNULL(fifth_city, ''),'')  [HomeAddress5Data_City(Municipality)]
            ,IIF(local5_Flag is null,ISNULL(fifth_city_subdivision, ''),'')  [HomeAddress5Data_SubMunicipalityType]
			,IIF(local5_Flag is null,ISNULL(fifth_city_subdivision_1, ''),'')  [HomeAddress5Data_CitySubdivision_1]
            ,''[HomeAddress5Data_SubMunicipality]
            ,IIF(local5_Flag is null,ISNULL(fifth_Region_ReferenceID, '') ,'') [HomeAddress5Data_State(Region)]
            ,''[HomeAddress5Data_SubregionDescriptor]
            ,''[HomeAddress5Data_SubregionType]
            ,IIF(local5_Flag is null,ISNULL(fifth_subregion, ''),'')  [HomeAddress5Data_Subregion(County)]
			,IIF(local5_Flag is null,ISNULL(fifth_region_subdivision_1, ''),'')  [HomeAddress5Data_RegionSubdivision_1]
			,IIF(local5_Flag is null,ISNULL(fifth_region_subdivision_2, ''),'')  [HomeAddress5Data_RegionSubdivision_2]
            ,IIF(local5_Flag is null,IIF(fifth_country_code='CHN' AND ISNULL(fifth_postalcode, '')='', '000000', ISNULL(fifth_postalcode, '')) ,'') [HomeAddress5Data_PostalCode]
            ,IIF(local5_Flag is null,ISNULL(fifth_public, ''),'') [HomeAddress5Data_Public]
            ,IIF(local5_Flag is null,ISNULL(fifth_usage, '') ,'') [HomeAddress5Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress6Data_Row]
            ,IIF(local6_Flag is null,IIF(ISNULL(sixth_effective_date, '')='', '', CONVERT(varchar(10), CAST(sixth_effective_date as date), 101)),'')  [HomeAddress6Data_EffectiveDate]
            ,IIF(local6_Flag is null,ISNULL(sixth_country_code, ''),'')  [HomeAddress6Data_CountryISOCode]
            ,IIF(local6_Flag is null,ISNULL(sixth_addressline1, ''),'')  [HomeAddress6Data_AddressLine1]
            ,IIF(local6_Flag is null,ISNULL(sixth_addressline2, ''),'')  [HomeAddress6Data_AddressLine2]
            ,IIF(local6_Flag is null,ISNULL(sixth_addressline3, '') ,'') [HomeAddress6Data_AddressLine3]
            ,IIF(local6_Flag is null,ISNULL(sixth_addressline4, ''),'')  [HomeAddress6Data_AddressLine4]
			,IIF(local6_Flag is null,ISNULL(sixth_addressline5, ''),'')  [HomeAddress6Data_AddressLine5]
			,IIF(local6_Flag is null,ISNULL(sixth_addressline6, ''),'')  [HomeAddress6Data_AddressLine6]
			,IIF(local6_Flag is null,ISNULL(sixth_addressline7, ''),'')  [HomeAddress6Data_AddressLine7]
			,IIF(local6_Flag is null,ISNULL(sixth_addressline8, ''),'')  [HomeAddress6Data_AddressLine8]
			,IIF(local6_Flag is null,ISNULL(sixth_addressline9, ''),'')  [HomeAddress6Data_AddressLine9]
            ,IIF(local6_Flag is null,ISNULL(sixth_city, ''),'')  [HomeAddress6Data_City(Municipality)]
            ,IIF(local6_Flag is null,ISNULL(sixth_city_subdivision, ''),'')  [HomeAddress6Data_SubMunicipalityType]
			,IIF(local6_Flag is null,ISNULL(sixth_city_subdivision_1, ''),'')  [HomeAddress6Data_CitySubdivision_1]
            ,''[HomeAddress6Data_SubMunicipality]
            ,IIF(local6_Flag is null,ISNULL(sixth_Region_ReferenceID, '') ,'') [HomeAddress6Data_State(Region)]
            ,''[HomeAddress6Data_SubregionDescriptor]
            ,''[HomeAddress6Data_SubregionType]
            ,IIF(local6_Flag is null,ISNULL(sixth_subregion, ''),'')  [HomeAddress6Data_Subregion(County)]
			,IIF(local6_Flag is null,ISNULL(sixth_region_subdivision_1, ''),'')  [HomeAddress6Data_RegionSubdivision_1]
			,IIF(local6_Flag is null,ISNULL(sixth_region_subdivision_2, ''),'')  [HomeAddress6Data_RegionSubdivision_2]
            ,IIF(local6_Flag is null,IIF(sixth_country_code='CHN' AND ISNULL(sixth_postalcode, '')='', '000000', ISNULL(sixth_postalcode, '')) ,'') [HomeAddress6Data_PostalCode]
            ,IIF(local6_Flag is null,ISNULL(sixth_public, ''),'') [HomeAddress6Data_Public]
            ,IIF(local6_Flag is null,ISNULL(sixth_usage, '') ,'') [HomeAddress6Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress7Data_Row]
            ,IIF(local7_Flag is null,IIF(ISNULL(seventh_effective_date, '')='', '', CONVERT(varchar(10), CAST(seventh_effective_date as date), 101)),'')  [HomeAddress7Data_EffectiveDate]
            ,IIF(local7_Flag is null,ISNULL(seventh_country_code, ''),'')  [HomeAddress7Data_CountryISOCode]
            ,IIF(local7_Flag is null,ISNULL(seventh_addressline1, ''),'')  [HomeAddress7Data_AddressLine1]
            ,IIF(local7_Flag is null,ISNULL(seventh_addressline2, ''),'')  [HomeAddress7Data_AddressLine2]
            ,IIF(local7_Flag is null,ISNULL(seventh_addressline3, '') ,'') [HomeAddress7Data_AddressLine3]
            ,IIF(local7_Flag is null,ISNULL(seventh_addressline4, ''),'')  [HomeAddress7Data_AddressLine4]
			,IIF(local7_Flag is null,ISNULL(seventh_addressline5, ''),'')  [HomeAddress7Data_AddressLine5]
			,IIF(local7_Flag is null,ISNULL(seventh_addressline6, ''),'')  [HomeAddress7Data_AddressLine6]
			,IIF(local7_Flag is null,ISNULL(seventh_addressline7, ''),'')  [HomeAddress7Data_AddressLine7]
			,IIF(local7_Flag is null,ISNULL(seventh_addressline8, ''),'')  [HomeAddress7Data_AddressLine8]
			,IIF(local7_Flag is null,ISNULL(seventh_addressline9, ''),'')  [HomeAddress7Data_AddressLine9]
            ,IIF(local7_Flag is null,ISNULL(seventh_city, ''),'')  [HomeAddress7Data_City(Municipality)]
            ,IIF(local7_Flag is null,ISNULL(seventh_city_subdivision, ''),'')  [HomeAddress7Data_SubMunicipalityType]
			,IIF(local7_Flag is null,ISNULL(seventh_city_subdivision_1, ''),'')  [HomeAddress7Data_CitySubdivision_1]
            ,''[HomeAddress7Data_SubMunicipality]
            ,IIF(local7_Flag is null,ISNULL(seventh_Region_ReferenceID, '') ,'') [HomeAddress7Data_State(Region)]
            ,''[HomeAddress7Data_SubregionDescriptor]
            ,''[HomeAddress7Data_SubregionType]
            ,IIF(local7_Flag is null,ISNULL(seventh_subregion, ''),'')  [HomeAddress7Data_Subregion(County)]
			,IIF(local7_Flag is null,ISNULL(seventh_region_subdivision_1, ''),'')  [HomeAddress7Data_RegionSubdivision_1]
			,IIF(local7_Flag is null,ISNULL(seventh_region_subdivision_2, ''),'')  [HomeAddress7Data_RegionSubdivision_2]
            ,IIF(local7_Flag is null,IIF(seventh_country_code='CHN' AND ISNULL(seventh_postalcode, '')='', '000000', ISNULL(seventh_postalcode, '')) ,'') [HomeAddress7Data_PostalCode]
            ,IIF(local7_Flag is null,ISNULL(seventh_public, ''),'') [HomeAddress7Data_Public]
            ,IIF(local7_Flag is null,ISNULL(seventh_usage, '') ,'') [HomeAddress7Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress8Data_Row]
            ,IIF(local8_Flag is null,IIF(ISNULL(eightth_effective_date, '')='', '', CONVERT(varchar(10), CAST(eightth_effective_date as date), 101)),'')  [HomeAddress8Data_EffectiveDate]
            ,IIF(local8_Flag is null,ISNULL(eightth_country_code, ''),'')  [HomeAddress8Data_CountryISOCode]
            ,IIF(local8_Flag is null,ISNULL(eightth_addressline1, ''),'')  [HomeAddress8Data_AddressLine1]
            ,IIF(local8_Flag is null,ISNULL(eightth_addressline2, ''),'')  [HomeAddress8Data_AddressLine2]
            ,IIF(local8_Flag is null,ISNULL(eightth_addressline3, '') ,'') [HomeAddress8Data_AddressLine3]
            ,IIF(local8_Flag is null,ISNULL(eightth_addressline4, ''),'')  [HomeAddress8Data_AddressLine4]
			,IIF(local8_Flag is null,ISNULL(eightth_addressline5, ''),'')  [HomeAddress8Data_AddressLine5]
			,IIF(local8_Flag is null,ISNULL(eightth_addressline6, ''),'')  [HomeAddress8Data_AddressLine6]
			,IIF(local8_Flag is null,ISNULL(eightth_addressline7, ''),'')  [HomeAddress8Data_AddressLine7]
			,IIF(local8_Flag is null,ISNULL(eightth_addressline8, ''),'')  [HomeAddress8Data_AddressLine8]
			,IIF(local8_Flag is null,ISNULL(eightth_addressline9, ''),'')  [HomeAddress8Data_AddressLine9]
            ,IIF(local8_Flag is null,ISNULL(eightth_city, ''),'')  [HomeAddress8Data_City(Municipality)]
            ,IIF(local8_Flag is null,ISNULL(eightth_city_subdivision, ''),'')  [HomeAddress8Data_SubMunicipalityType]
			,IIF(local8_Flag is null,ISNULL(eightth_city_subdivision_1, ''),'')  [HomeAddress8Data_CitySubdivision_1]
            ,''[HomeAddress8Data_SubMunicipality]
            ,IIF(local8_Flag is null,ISNULL(eightth_Region_ReferenceID, '') ,'') [HomeAddress8Data_State(Region)]
            ,''[HomeAddress8Data_SubregionDescriptor]
            ,''[HomeAddress8Data_SubregionType]
            ,IIF(local8_Flag is null,ISNULL(eightth_subregion, ''),'')  [HomeAddress8Data_Subregion(County)]
			,IIF(local8_Flag is null,ISNULL(eightth_region_subdivision_1, ''),'')  [HomeAddress8Data_RegionSubdivision_1]
			,IIF(local8_Flag is null,ISNULL(eightth_region_subdivision_2, ''),'')  [HomeAddress8Data_RegionSubdivision_2]
            ,IIF(local8_Flag is null,IIF(eightth_country_code='CHN' AND ISNULL(eightth_postalcode, '')='', '000000', ISNULL(eightth_postalcode, '')) ,'') [HomeAddress8Data_PostalCode]
            ,IIF(local8_Flag is null,ISNULL(eightth_public, ''),'') [HomeAddress8Data_Public]
            ,IIF(local8_Flag is null,ISNULL(eightth_usage, '') ,'') [HomeAddress8Data_Usage]


			-------------------------------------------
            ,'' [HomeAddress9Data_Row]
            ,IIF(local9_Flag is null,IIF(ISNULL(nineth_effective_date, '')='', '', CONVERT(varchar(10), CAST(nineth_effective_date as date), 101)),'')  [HomeAddress9Data_EffectiveDate]
            ,IIF(local9_Flag is null,ISNULL(nineth_country_code, ''),'')  [HomeAddress9Data_CountryISOCode]
            ,IIF(local9_Flag is null,ISNULL(nineth_addressline1, ''),'')  [HomeAddress9Data_AddressLine1]
            ,IIF(local9_Flag is null,ISNULL(nineth_addressline2, ''),'')  [HomeAddress9Data_AddressLine2]
            ,IIF(local9_Flag is null,ISNULL(nineth_addressline3, '') ,'') [HomeAddress9Data_AddressLine3]
            ,IIF(local9_Flag is null,ISNULL(nineth_addressline4, ''),'')  [HomeAddress9Data_AddressLine4]
			,IIF(local9_Flag is null,ISNULL(nineth_addressline5, ''),'')  [HomeAddress9Data_AddressLine5]
			,IIF(local9_Flag is null,ISNULL(nineth_addressline6, ''),'')  [HomeAddress9Data_AddressLine6]
			,IIF(local9_Flag is null,ISNULL(nineth_addressline7, ''),'')  [HomeAddress9Data_AddressLine7]
			,IIF(local9_Flag is null,ISNULL(nineth_addressline8, ''),'')  [HomeAddress9Data_AddressLine8]
			,IIF(local9_Flag is null,ISNULL(nineth_addressline9, ''),'')  [HomeAddress9Data_AddressLine9]
            ,IIF(local9_Flag is null,ISNULL(nineth_city, ''),'')  [HomeAddress9Data_City(Municipality)]
            ,IIF(local9_Flag is null,ISNULL(nineth_city_subdivision, ''),'')  [HomeAddress9Data_SubMunicipalityType]
			,IIF(local9_Flag is null,ISNULL(nineth_city_subdivision_1, ''),'')  [HomeAddress9Data_CitySubdivision_1]
            ,''[HomeAddress9Data_SubMunicipality]
            ,IIF(local9_Flag is null,ISNULL(nineth_Region_ReferenceID, '') ,'') [HomeAddress9Data_State(Region)]
            ,''[HomeAddress9Data_SubregionDescriptor]
            ,''[HomeAddress9Data_SubregionType]
            ,IIF(local9_Flag is null,ISNULL(nineth_subregion, ''),'')  [HomeAddress9Data_Subregion(County)]
			,IIF(local9_Flag is null,ISNULL(nineth_region_subdivision_1, ''),'')  [HomeAddress9Data_RegionSubdivision_1]
			,IIF(local9_Flag is null,ISNULL(nineth_region_subdivision_2, ''),'')  [HomeAddress9Data_RegionSubdivision_2]
            ,IIF(local9_Flag is null,IIF(nineth_country_code='CHN' AND ISNULL(nineth_postalcode, '')='', '000000', ISNULL(nineth_postalcode, '')) ,'') [HomeAddress9Data_PostalCode]
            ,IIF(local9_Flag is null,ISNULL(nineth_public, ''),'') [HomeAddress9Data_Public]
            ,IIF(local9_Flag is null,ISNULL(nineth_usage, '') ,'') [HomeAddress9Data_Usage]
			
						
			-------------------------------------------
            ,'' [HomeAddress10Data_Row]
            ,IIF(local10_Flag is null,IIF(ISNULL(tenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(tenth_effective_date as date), 101)),'')  [HomeAddress10Data_EffectiveDate]
            ,IIF(local10_Flag is null,ISNULL(tenth_country_code, ''),'')  [HomeAddress10Data_CountryISOCode]
            ,IIF(local10_Flag is null,ISNULL(tenth_addressline1, ''),'')  [HomeAddress10Data_AddressLine1]
            ,IIF(local10_Flag is null,ISNULL(tenth_addressline2, ''),'')  [HomeAddress10Data_AddressLine2]
            ,IIF(local10_Flag is null,ISNULL(tenth_addressline3, '') ,'') [HomeAddress10Data_AddressLine3]
            ,IIF(local10_Flag is null,ISNULL(tenth_addressline4, ''),'')  [HomeAddress10Data_AddressLine4]
			,IIF(local10_Flag is null,ISNULL(tenth_addressline5, ''),'')  [HomeAddress10Data_AddressLine5]
			,IIF(local10_Flag is null,ISNULL(tenth_addressline6, ''),'')  [HomeAddress10Data_AddressLine6]
			,IIF(local10_Flag is null,ISNULL(tenth_addressline7, ''),'')  [HomeAddress10Data_AddressLine7]
			,IIF(local10_Flag is null,ISNULL(tenth_addressline8, ''),'')  [HomeAddress10Data_AddressLine8]
			,IIF(local10_Flag is null,ISNULL(tenth_addressline9, ''),'')  [HomeAddress10Data_AddressLine9]
            ,IIF(local10_Flag is null,ISNULL(tenth_city, ''),'')  [HomeAddress10Data_City(Municipality)]
            ,IIF(local10_Flag is null,ISNULL(tenth_city_subdivision, ''),'')  [HomeAddress10Data_SubMunicipalityType]
			,IIF(local10_Flag is null,ISNULL(tenth_city_subdivision_1, ''),'')  [HomeAddress10Data_CitySubdivision_1]
            ,''[HomeAddress10Data_SubMunicipality]
            ,IIF(local10_Flag is null,ISNULL(tenth_Region_ReferenceID, '') ,'') [HomeAddress10Data_State(Region)]
            ,''[HomeAddress10Data_SubregionDescriptor]
            ,''[HomeAddress10Data_SubregionType]
            ,IIF(local10_Flag is null,ISNULL(tenth_subregion, ''),'')  [HomeAddress10Data_Subregion(County)]
			,IIF(local10_Flag is null,ISNULL(tenth_region_subdivision_1, ''),'')  [HomeAddress10Data_RegionSubdivision_1]
			,IIF(local10_Flag is null,ISNULL(tenth_region_subdivision_2, ''),'')  [HomeAddress10Data_RegionSubdivision_2]
            ,IIF(local10_Flag is null,IIF(tenth_country_code='CHN' AND ISNULL(tenth_postalcode, '')='', '000000', ISNULL(tenth_postalcode, '')) ,'') [HomeAddress10Data_PostalCode]
            ,IIF(local10_Flag is null,ISNULL(tenth_public, ''),'') [HomeAddress10Data_Public]
            ,IIF(local10_Flag is null,ISNULL(tenth_usage, '') ,'') [HomeAddress10Data_Usage]
			
			
			-------------------------------------------
            ,'' [HomeAddress11Data_Row]
            ,IIF(local11_Flag is null,IIF(ISNULL(eleventh_effective_date, '')='', '', CONVERT(varchar(10), CAST(eleventh_effective_date as date), 101)),'')  [HomeAddress11Data_EffectiveDate]
            ,IIF(local11_Flag is null,ISNULL(eleventh_country_code, ''),'')  [HomeAddress11Data_CountryISOCode]
            ,IIF(local11_Flag is null,ISNULL(eleventh_addressline1, ''),'')  [HomeAddress11Data_AddressLine1]
            ,IIF(local11_Flag is null,ISNULL(eleventh_addressline2, ''),'')  [HomeAddress11Data_AddressLine2]
            ,IIF(local11_Flag is null,ISNULL(eleventh_addressline3, '') ,'') [HomeAddress11Data_AddressLine3]
            ,IIF(local11_Flag is null,ISNULL(eleventh_addressline4, ''),'')  [HomeAddress11Data_AddressLine4]
			,IIF(local11_Flag is null,ISNULL(eleventh_addressline5, ''),'')  [HomeAddress11Data_AddressLine5]
			,IIF(local11_Flag is null,ISNULL(eleventh_addressline6, ''),'')  [HomeAddress11Data_AddressLine6]
			,IIF(local11_Flag is null,ISNULL(eleventh_addressline7, ''),'')  [HomeAddress11Data_AddressLine7]
			,IIF(local11_Flag is null,ISNULL(eleventh_addressline8, ''),'')  [HomeAddress11Data_AddressLine8]
			,IIF(local11_Flag is null,ISNULL(eleventh_addressline9, ''),'')  [HomeAddress11Data_AddressLine9]
            ,IIF(local11_Flag is null,ISNULL(eleventh_city, ''),'')  [HomeAddress11Data_City(Municipality)]
            ,IIF(local11_Flag is null,ISNULL(eleventh_city_subdivision, ''),'')  [HomeAddress11Data_SubMunicipalityType]
			,IIF(local11_Flag is null,ISNULL(eleventh_city_subdivision_1, ''),'')  [HomeAddress11Data_CitySubdivision_1]
            ,''[HomeAddress11Data_SubMunicipality]
            ,IIF(local11_Flag is null,ISNULL(eleventh_Region_ReferenceID, '') ,'') [HomeAddress11Data_State(Region)]
            ,''[HomeAddress11Data_SubregionDescriptor]
            ,''[HomeAddress11Data_SubregionType]
            ,IIF(local11_Flag is null,ISNULL(eleventh_subregion, ''),'')  [HomeAddress11Data_Subregion(County)]
			,IIF(local11_Flag is null,ISNULL(eleventh_region_subdivision_1, ''),'')  [HomeAddress11Data_RegionSubdivision_1]
			,IIF(local11_Flag is null,ISNULL(eleventh_region_subdivision_2, ''),'')  [HomeAddress11Data_RegionSubdivision_2]
            ,IIF(local11_Flag is null,IIF(eleventh_country_code='CHN' AND ISNULL(eleventh_postalcode, '')='', '000000', ISNULL(eleventh_postalcode, '')) ,'') [HomeAddress11Data_PostalCode]
            ,IIF(local11_Flag is null,ISNULL(eleventh_public, ''),'') [HomeAddress11Data_Public]
            ,IIF(local11_Flag is null,ISNULL(eleventh_usage, '') ,'') [HomeAddress11Data_Usage]
			

			-------------------------------------------
            ,'' [HomeAddress12Data_Row]
            ,IIF(local12_Flag is null,IIF(ISNULL(twelveth_effective_date, '')='', '', CONVERT(varchar(10), CAST(twelveth_effective_date as date), 101)),'')  [HomeAddress12Data_EffectiveDate]
            ,IIF(local12_Flag is null,ISNULL(twelveth_country_code, ''),'')  [HomeAddress12Data_CountryISOCode]
            ,IIF(local12_Flag is null,ISNULL(twelveth_addressline1, ''),'')  [HomeAddress12Data_AddressLine1]
            ,IIF(local12_Flag is null,ISNULL(twelveth_addressline2, ''),'')  [HomeAddress12Data_AddressLine2]
            ,IIF(local12_Flag is null,ISNULL(twelveth_addressline3, '') ,'') [HomeAddress12Data_AddressLine3]
            ,IIF(local12_Flag is null,ISNULL(twelveth_addressline4, ''),'')  [HomeAddress12Data_AddressLine4]
			,IIF(local12_Flag is null,ISNULL(twelveth_addressline5, ''),'')  [HomeAddress12Data_AddressLine5]
			,IIF(local12_Flag is null,ISNULL(twelveth_addressline6, ''),'')  [HomeAddress12Data_AddressLine6]
			,IIF(local12_Flag is null,ISNULL(twelveth_addressline7, ''),'')  [HomeAddress12Data_AddressLine7]
			,IIF(local12_Flag is null,ISNULL(twelveth_addressline8, ''),'')  [HomeAddress12Data_AddressLine8]
			,IIF(local12_Flag is null,ISNULL(twelveth_addressline9, ''),'')  [HomeAddress12Data_AddressLine9]
            ,IIF(local12_Flag is null,ISNULL(twelveth_city, ''),'')  [HomeAddress12Data_City(Municipality)]
            ,IIF(local12_Flag is null,ISNULL(twelveth_city_subdivision, ''),'')  [HomeAddress12Data_SubMunicipalityType]
			,IIF(local12_Flag is null,ISNULL(twelveth_city_subdivision_1, ''),'')  [HomeAddress12Data_CitySubdivision_1]
            ,''[HomeAddress12Data_SubMunicipality]
            ,IIF(local12_Flag is null,ISNULL(twelveth_Region_ReferenceID, '') ,'') [HomeAddress12Data_State(Region)]
            ,''[HomeAddress12Data_SubregionDescriptor]
            ,''[HomeAddress12Data_SubregionType]
            ,IIF(local12_Flag is null,ISNULL(twelveth_subregion, ''),'')  [HomeAddress12Data_Subregion(County)]
			,IIF(local12_Flag is null,ISNULL(twelveth_region_subdivision_1, ''),'')  [HomeAddress12Data_RegionSubdivision_1]
			,IIF(local12_Flag is null,ISNULL(twelveth_region_subdivision_2, ''),'')  [HomeAddress12Data_RegionSubdivision_2]
            ,IIF(local12_Flag is null,IIF(twelveth_country_code='CHN' AND ISNULL(twelveth_postalcode, '')='', '000000', ISNULL(twelveth_postalcode, '')) ,'') [HomeAddress12Data_PostalCode]
            ,IIF(local12_Flag is null,ISNULL(twelveth_public, ''),'') [HomeAddress12Data_Public]
            ,IIF(local12_Flag is null,ISNULL(twelveth_usage, '') ,'') [HomeAddress12Data_Usage]
			

			-------------------------------------------
            ,'' [HomeAddress13Data_Row]
            ,IIF(local13_Flag is null,IIF(ISNULL(thirteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(thirteenth_effective_date as date), 101)),'')  [HomeAddress13Data_EffectiveDate]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_country_code, ''),'')  [HomeAddress13Data_CountryISOCode]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_addressline1, ''),'')  [HomeAddress13Data_AddressLine1]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_addressline2, ''),'')  [HomeAddress13Data_AddressLine2]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_addressline3, '') ,'') [HomeAddress13Data_AddressLine3]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_addressline4, ''),'')  [HomeAddress13Data_AddressLine4]
			,IIF(local13_Flag is null,ISNULL(thirteenth_addressline5, ''),'')  [HomeAddress13Data_AddressLine5]
			,IIF(local13_Flag is null,ISNULL(thirteenth_addressline6, ''),'')  [HomeAddress13Data_AddressLine6]
			,IIF(local13_Flag is null,ISNULL(thirteenth_addressline7, ''),'')  [HomeAddress13Data_AddressLine7]
			,IIF(local13_Flag is null,ISNULL(thirteenth_addressline8, ''),'')  [HomeAddress13Data_AddressLine8]
			,IIF(local13_Flag is null,ISNULL(thirteenth_addressline9, ''),'')  [HomeAddress13Data_AddressLine9]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_city, ''),'')  [HomeAddress13Data_City(Municipality)]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_city_subdivision, ''),'')  [HomeAddress13Data_SubMunicipalityType]
			,IIF(local13_Flag is null,ISNULL(thirteenth_city_subdivision_1, ''),'')  [HomeAddress13Data_CitySubdivision_1]
            ,''[HomeAddress13Data_SubMunicipality]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_Region_ReferenceID, '') ,'') [HomeAddress13Data_State(Region)]
            ,''[HomeAddress13Data_SubregionDescriptor]
            ,''[HomeAddress13Data_SubregionType]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_subregion, ''),'')  [HomeAddress13Data_Subregion(County)]
			,IIF(local13_Flag is null,ISNULL(thirteenth_region_subdivision_1, ''),'')  [HomeAddress13Data_RegionSubdivision_1]
			,IIF(local13_Flag is null,ISNULL(thirteenth_region_subdivision_2, ''),'')  [HomeAddress13Data_RegionSubdivision_2]
            ,IIF(local13_Flag is null,IIF(thirteenth_country_code='CHN' AND ISNULL(thirteenth_postalcode, '')='', '000000', ISNULL(thirteenth_postalcode, '')) ,'') [HomeAddress13Data_PostalCode]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_public, ''),'') [HomeAddress13Data_Public]
            ,IIF(local13_Flag is null,ISNULL(thirteenth_usage, '') ,'') [HomeAddress13Data_Usage]
			

			-------------------------------------------
            ,'' [HomeAddress14Data_Row]
            ,IIF(local14_Flag is null,IIF(ISNULL(fourteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fourteenth_effective_date as date), 101)),'')  [HomeAddress14Data_EffectiveDate]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_country_code, ''),'')  [HomeAddress14Data_CountryISOCode]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_addressline1, ''),'')  [HomeAddress14Data_AddressLine1]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_addressline2, ''),'')  [HomeAddress14Data_AddressLine2]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_addressline3, '') ,'') [HomeAddress14Data_AddressLine3]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_addressline4, ''),'')  [HomeAddress14Data_AddressLine4]
			,IIF(local14_Flag is null,ISNULL(fourteenth_addressline5, ''),'')  [HomeAddress14Data_AddressLine5]
			,IIF(local14_Flag is null,ISNULL(fourteenth_addressline6, ''),'')  [HomeAddress14Data_AddressLine6]
			,IIF(local14_Flag is null,ISNULL(fourteenth_addressline7, ''),'')  [HomeAddress14Data_AddressLine7]
			,IIF(local14_Flag is null,ISNULL(fourteenth_addressline8, ''),'')  [HomeAddress14Data_AddressLine8]
			,IIF(local14_Flag is null,ISNULL(fourteenth_addressline9, ''),'')  [HomeAddress14Data_AddressLine9]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_city, ''),'')  [HomeAddress14Data_City(Municipality)]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_city_subdivision, ''),'')  [HomeAddress14Data_SubMunicipalityType]
			,IIF(local14_Flag is null,ISNULL(fourteenth_city_subdivision_1, ''),'')  [HomeAddress14Data_CitySubdivision_1]
            ,''[HomeAddress14Data_SubMunicipality]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_Region_ReferenceID, '') ,'') [HomeAddress14Data_State(Region)]
            ,''[HomeAddress14Data_SubregionDescriptor]
            ,''[HomeAddress14Data_SubregionType]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_subregion, ''),'')  [HomeAddress14Data_Subregion(County)]
			,IIF(local14_Flag is null,ISNULL(fourteenth_region_subdivision_1, ''),'')  [HomeAddress14Data_RegionSubdivision_1]
			,IIF(local14_Flag is null,ISNULL(fourteenth_region_subdivision_2, ''),'')  [HomeAddress14Data_RegionSubdivision_2]
            ,IIF(local14_Flag is null,IIF(fourteenth_country_code='CHN' AND ISNULL(fourteenth_postalcode, '')='', '000000', ISNULL(fourteenth_postalcode, '')) ,'') [HomeAddress14Data_PostalCode]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_public, ''),'') [HomeAddress14Data_Public]
            ,IIF(local14_Flag is null,ISNULL(fourteenth_usage, '') ,'') [HomeAddress14Data_Usage]
			

			-------------------------------------------
            ,'' [HomeAddress15Data_Row]
            ,IIF(local15_Flag is null,IIF(ISNULL(fifteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fifteenth_effective_date as date), 101)),'')  [HomeAddress15Data_EffectiveDate]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_country_code, ''),'')  [HomeAddress15Data_CountryISOCode]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_addressline1, ''),'')  [HomeAddress15Data_AddressLine1]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_addressline2, ''),'')  [HomeAddress15Data_AddressLine2]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_addressline3, '') ,'') [HomeAddress15Data_AddressLine3]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_addressline4, ''),'')  [HomeAddress15Data_AddressLine4]
			,IIF(local15_Flag is null,ISNULL(fifteenth_addressline5, ''),'')  [HomeAddress15Data_AddressLine5]
			,IIF(local15_Flag is null,ISNULL(fifteenth_addressline6, ''),'')  [HomeAddress15Data_AddressLine6]
			,IIF(local15_Flag is null,ISNULL(fifteenth_addressline7, ''),'')  [HomeAddress15Data_AddressLine7]
			,IIF(local15_Flag is null,ISNULL(fifteenth_addressline8, ''),'')  [HomeAddress15Data_AddressLine8]
			,IIF(local15_Flag is null,ISNULL(fifteenth_addressline9, ''),'')  [HomeAddress15Data_AddressLine9]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_city, ''),'')  [HomeAddress15Data_City(Municipality)]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_city_subdivision, ''),'')  [HomeAddress15Data_SubMunicipalityType]
			,IIF(local15_Flag is null,ISNULL(fifteenth_city_subdivision_1, ''),'')  [HomeAddress15Data_CitySubdivision_1]
            ,''[HomeAddress15Data_SubMunicipality]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_Region_ReferenceID, '') ,'') [HomeAddress15Data_State(Region)]
            ,''[HomeAddress15Data_SubregionDescriptor]
            ,''[HomeAddress15Data_SubregionType]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_subregion, ''),'')  [HomeAddress15Data_Subregion(County)]
			,IIF(local15_Flag is null,ISNULL(fifteenth_region_subdivision_1, ''),'')  [HomeAddress15Data_RegionSubdivision_1]
			,IIF(local15_Flag is null,ISNULL(fifteenth_region_subdivision_2, ''),'')  [HomeAddress15Data_RegionSubdivision_2]
            ,IIF(local15_Flag is null,IIF(fifteenth_country_code='CHN' AND ISNULL(fifteenth_postalcode, '')='', '000000', ISNULL(fifteenth_postalcode, '')) ,'') [HomeAddress15Data_PostalCode]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_public, ''),'') [HomeAddress15Data_Public]
            ,IIF(local15_Flag is null,ISNULL(fifteenth_usage, '') ,'') [HomeAddress15Data_Usage]
			
            ---------------------------------------------
            ,'' Home_Address_Local1Data_Row
            ,IIF(Local1_Flag='Y',IIF(ISNULL(primary_effective_date, '')='', '', CONVERT(varchar(10), CAST(primary_effective_date as date), 101)),'') Home_Address_Local1Data_Effective_Date
            ,IIF(Local1_Flag='Y',ISNULL(primary_country_code, ''),'')  Home_Address_Local1Data_ISO_Code
            ,IIF(Local1_Flag='Y',ISNULL(primary_city, ''),'') Home_Address_Local1Data_CITY
            ,IIF(Local1_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline1, 'N'), ''),'') Home_Address_Local1Data_ADDRESS_LINE_1
            ,IIF(Local1_Flag='Y',(CASE
                    WHEN ISNULL(primary_country_code, '') in ('CHN','KOR','THA','TWN','RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(dbo.RemoveFLCommaCharacter(primary_addressLine2, 'N'))
					ELSE ''	  END),'') Home_Address_Local1Data_ADDRESS_LINE_2
            ,IIF(Local1_Flag='Y',IIF(ISNULL(primary_country_code, '') = 'JPN', primary_OR1KK, ''),'') Home_Address_Local1Data_ADDRESS_LINE_4
            ,IIF(Local1_Flag='Y',IIF(ISNULL(primary_country_code, '') = 'JPN', dbo.RemoveFLCommaCharacter(primary_addressLine2, 'N'), ''),'') Home_Address_Local1Data_ADDRESS_LINE_5
            ,IIF(Local1_Flag='Y',IIF(ISNULL(primary_country_code, '') = 'JPN', primary_OR2KK, ''),'') Home_Address_Local1Data_ADDRESS_LINE_6
			,IIF(Local1_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline7, 'N'), ''),'') Home_Address_Local1Data_ADDRESS_LINE_7
			,IIF(Local1_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline8, 'N'), ''),'') Home_Address_Local1Data_ADDRESS_LINE_8
			,IIF(Local1_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(primary_addressline9, 'N'), ''),'') Home_Address_Local1Data_ADDRESS_LINE_9

            ,IIF(Local1_Flag='Y',ISNULL(primary_city_subdivision, ''),'') Home_Address_Local1Data_CITY_SUBDIVISION_1
			,IIF(Local1_Flag='Y',ISNULL(primary_city_subdivision_1, ''),'') Home_Address_Local1Data_CITY_SUBDIVISION_2
            ,IIF(Local1_Flag='Y',ISNULL(primary_Region_referenceID, ''),'') Home_Address_Local1Data_REGION_ID
			,'' Home_Address_Local1Data_Descriptor
            ,'' Home_Address_Local1Data_Subregion
            ,IIF(Local1_Flag='Y',ISNULL(primary_region_subdivision_1, ''),'')  Home_Address_Local1Data_REGION_SUBDIVISION_1
			,IIF(Local1_Flag='Y',ISNULL(primary_region_subdivision_2, ''),'') Home_Address_Local1Data_REGION_SUBDIVISION_2
            ,IIF(Local1_Flag='Y',IIF(primary_country_code='CHN' AND ISNULL(primary_postalcode, '')='', '000000', ISNULL(primary_postalcode, '')),'') Home_Address_Local1Data_Postal_Code
            ,'' Home_Address_Local1Data_Public
            ,'' Home_Address_Local1Data_Usage

			-----------------------------------------
            ,'' Home_Address_Local2Data_Row
            ,IIF(Local2_Flag='Y',IIF(ISNULL(secondary_effective_date, '')='', '', CONVERT(varchar(10), CAST(secondary_effective_date as date), 101)),'') Home_Address_Local2Data_Effective_Date
            ,IIF(Local2_Flag='Y',ISNULL(secondary_country_code, ''),'')  Home_Address_Local2Data_ISO_Code
            ,IIF(Local2_Flag='Y',ISNULL(Secondary_city, ''),'') Home_Address_Local2Data_CITY
            ,IIF(Local2_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(Secondary_addressline1, 'N'), ''),'') Home_Address_Local2Data_ADDRESS_LINE_1
            ,IIF(Local2_Flag='Y',(CASE
                    WHEN ISNULL(Secondary_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(dbo.RemoveFLCommaCharacter(Secondary_addressLine2, 'N'))
					ELSE ''	  END),'') Home_Address_Local2Data_ADDRESS_LINE_2
            ,IIF(Local2_Flag='Y',IIF(ISNULL(Secondary_country_code, '') = 'JPN', Secondary_OR1KK, ''),'') Home_Address_Local2Data_ADDRESS_LINE_4
            ,IIF(Local2_Flag='Y',IIF(ISNULL(Secondary_country_code, '') = 'JPN', dbo.RemoveFLCommaCharacter(Secondary_addressLine2, 'N'), ''),'') Home_Address_Local2Data_ADDRESS_LINE_5
            ,IIF(Local2_Flag='Y',IIF(ISNULL(Secondary_country_code, '') = 'JPN', Secondary_OR2KK, ''),'') Home_Address_Local2Data_ADDRESS_LINE_6
			,IIF(Local2_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(Secondary_addressline7, 'N'), ''),'') Home_Address_Local2Data_ADDRESS_LINE_7
			,IIF(Local2_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(Secondary_addressline8, 'N'), ''),'') Home_Address_Local2Data_ADDRESS_LINE_8
			,IIF(Local2_Flag='Y',ISNULL(dbo.RemoveFLCommaCharacter(Secondary_addressline9, 'N'), ''),'') Home_Address_Local2Data_ADDRESS_LINE_9

            ,IIF(Local2_Flag='Y',ISNULL(Secondary_city_subdivision, ''),'') Home_Address_Local2Data_CITY_SUBDIVISION_1
			,IIF(Local2_Flag='Y',ISNULL(Secondary_city_subdivision_1, ''),'') Home_Address_Local2Data_CITY_SUBDIVISION_2
            ,IIF(Local2_Flag='Y',ISNULL(Secondary_Region_referenceID, ''),'') Home_Address_Local2Data_REGION_ID
			,'' Home_Address_Local2Data_Descriptor
            ,'' Home_Address_Local2Data_Subregion
            ,IIF(Local2_Flag='Y',ISNULL(secondary_region_subdivision_1, ''),'')  Home_Address_Local2Data_REGION_SUBDIVISION_1
			,IIF(Local2_Flag='Y',ISNULL(secondary_region_subdivision_2, ''),'')  Home_Address_Local2Data_REGION_SUBDIVISION_2
            ,IIF(Local2_Flag='Y',IIF(secondary_country_code='CHN' AND ISNULL(Secondary_postalcode, '')='', '000000', ISNULL(Secondary_postalcode, '')),'') Home_Address_Local2Data_Postal_Code
            ,'' Home_Address_Local2Data_Public
            ,'' Home_Address_Local2Data_Usage		
			
			-----------------------------------------
            ,'' Home_Address_local3Data_Row
            ,IIF(local3_Flag='Y',IIF(ISNULL(third_effective_date, '')='', '', CONVERT(varchar(10), CAST(third_effective_date as date), 101)),'') Home_Address_local3Data_Effective_Date
            ,IIF(local3_Flag='Y',ISNULL(third_country_code, ''),'')  Home_Address_local3Data_ISO_Code
            ,IIF(local3_Flag='Y',ISNULL(third_city, ''),'') Home_Address_local3Data_CITY
            ,IIF(local3_Flag='Y',ISNULL(third_addressline1, ''),'') Home_Address_local3Data_ADDRESS_LINE_1
            ,IIF(local3_Flag='Y',(CASE
                    WHEN ISNULL(third_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(third_addressLine2)
					ELSE ''	  END),'') Home_Address_local3Data_ADDRESS_LINE_2
            ,IIF(local3_Flag='Y',IIF(ISNULL(third_country_code, '') = 'JPN', third_OR1KK, ''),'') Home_Address_local3Data_ADDRESS_LINE_4
            ,IIF(local3_Flag='Y',IIF(ISNULL(third_country_code, '') = 'JPN', third_addressLine2, ''),'') Home_Address_local3Data_ADDRESS_LINE_5
            ,IIF(local3_Flag='Y',IIF(ISNULL(third_country_code, '') = 'JPN', third_OR2KK, ''),'') Home_Address_local3Data_ADDRESS_LINE_6
			,IIF(local3_Flag='Y',ISNULL(third_addressline7, ''),'') Home_Address_local3Data_ADDRESS_LINE_7
			,IIF(local3_Flag='Y',ISNULL(third_addressline8, ''),'') Home_Address_local3Data_ADDRESS_LINE_8
			,IIF(local3_Flag='Y',ISNULL(third_addressline9, ''),'') Home_Address_local3Data_ADDRESS_LINE_9

            ,IIF(local3_Flag='Y',ISNULL(third_city_subdivision, ''),'') Home_Address_local3Data_CITY_SUBDIVISION_1
			,IIF(local3_Flag='Y',ISNULL(third_city_subdivision_1, ''),'') Home_Address_local3Data_CITY_SUBDIVISION_2
            ,IIF(local3_Flag='Y',ISNULL(third_Region_referenceID, ''),'') Home_Address_local3Data_REGION_ID
			,'' Home_Address_local3Data_Descriptor
            ,'' Home_Address_local3Data_Subregion
            ,IIF(local3_Flag='Y',ISNULL(third_region_subdivision_1, ''),'')  Home_Address_local3Data_REGION_SUBDIVISION_1
			,IIF(local3_Flag='Y',ISNULL(third_region_subdivision_2, ''),'')  Home_Address_local3Data_REGION_SUBDIVISION_2
            ,IIF(local3_Flag='Y',IIF(third_country_code='CHN' AND ISNULL(third_postalcode, '')='', '000000', ISNULL(third_postalcode, '')),'') Home_Address_local3Data_Postal_Code
            ,'' Home_Address_local3Data_Public
            ,'' Home_Address_local3Data_Usage	
			
			-----------------------------------------
            ,'' Home_Address_local4Data_Row
            ,IIF(local4_Flag='Y',IIF(ISNULL(fourth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fourth_effective_date as date), 101)),'') Home_Address_local4Data_Effective_Date
            ,IIF(local4_Flag='Y',ISNULL(fourth_country_code, ''),'')  Home_Address_local4Data_ISO_Code
            ,IIF(local4_Flag='Y',ISNULL(fourth_city, ''),'') Home_Address_local4Data_CITY
            ,IIF(local4_Flag='Y',ISNULL(fourth_addressline1, ''),'') Home_Address_local4Data_ADDRESS_LINE_1
            ,IIF(local4_Flag='Y',(CASE
                    WHEN ISNULL(fourth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(fourth_addressLine2)
					ELSE ''	  END),'') Home_Address_local4Data_ADDRESS_LINE_2
            ,IIF(local4_Flag='Y',IIF(ISNULL(fourth_country_code, '') = 'JPN', fourth_OR1KK, ''),'') Home_Address_local4Data_ADDRESS_LINE_4
            ,IIF(local4_Flag='Y',IIF(ISNULL(fourth_country_code, '') = 'JPN', fourth_addressLine2, ''),'') Home_Address_local4Data_ADDRESS_LINE_5
            ,IIF(local4_Flag='Y',IIF(ISNULL(fourth_country_code, '') = 'JPN', fourth_OR2KK, ''),'') Home_Address_local4Data_ADDRESS_LINE_6
			,IIF(local4_Flag='Y',ISNULL(fourth_addressline7, ''),'') Home_Address_local4Data_ADDRESS_LINE_7
			,IIF(local4_Flag='Y',ISNULL(fourth_addressline8, ''),'') Home_Address_local4Data_ADDRESS_LINE_8
			,IIF(local4_Flag='Y',ISNULL(fourth_addressline9, ''),'') Home_Address_local4Data_ADDRESS_LINE_9

            ,IIF(local4_Flag='Y',ISNULL(fourth_city_subdivision, ''),'') Home_Address_local4Data_CITY_SUBDIVISION_1
			,IIF(local4_Flag='Y',ISNULL(fourth_city_subdivision_1, ''),'') Home_Address_local4Data_CITY_SUBDIVISION_2
            ,IIF(local4_Flag='Y',ISNULL(fourth_Region_referenceID, ''),'') Home_Address_local4Data_REGION_ID
			,'' Home_Address_local4Data_Descriptor
            ,'' Home_Address_local4Data_Subregion
            ,IIF(local4_Flag='Y',ISNULL(fourth_region_subdivision_1, ''),'')  Home_Address_local4Data_REGION_SUBDIVISION_1
			,IIF(local4_Flag='Y',ISNULL(fourth_region_subdivision_2, ''),'')  Home_Address_local4Data_REGION_SUBDIVISION_2
            ,IIF(local4_Flag='Y',IIF(fourth_country_code='CHN' AND ISNULL(fourth_postalcode, '')='', '000000', ISNULL(fourth_postalcode, '')),'') Home_Address_local4Data_Postal_Code
            ,'' Home_Address_local4Data_Public
            ,'' Home_Address_local4Data_Usage					

			-----------------------------------------
            ,'' Home_Address_local5Data_Row
            ,IIF(local5_Flag='Y',IIF(ISNULL(fifth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fifth_effective_date as date), 101)),'') Home_Address_local5Data_Effective_Date
            ,IIF(local5_Flag='Y',ISNULL(fifth_country_code, ''),'')  Home_Address_local5Data_ISO_Code
            ,IIF(local5_Flag='Y',ISNULL(fifth_city, ''),'') Home_Address_local5Data_CITY
            ,IIF(local5_Flag='Y',ISNULL(fifth_addressline1, ''),'') Home_Address_local5Data_ADDRESS_LINE_1
            ,IIF(local5_Flag='Y',(CASE
                    WHEN ISNULL(fifth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(fifth_addressLine2)
					ELSE ''	  END),'') Home_Address_local5Data_ADDRESS_LINE_2
            ,IIF(local5_Flag='Y',IIF(ISNULL(fifth_country_code, '') = 'JPN', fifth_OR1KK, ''),'') Home_Address_local5Data_ADDRESS_LINE_4
            ,IIF(local5_Flag='Y',IIF(ISNULL(fifth_country_code, '') = 'JPN', fifth_addressLine2, ''),'') Home_Address_local5Data_ADDRESS_LINE_5
            ,IIF(local5_Flag='Y',IIF(ISNULL(fifth_country_code, '') = 'JPN', fifth_OR2KK, ''),'') Home_Address_local5Data_ADDRESS_LINE_6
			,IIF(local5_Flag='Y',ISNULL(fifth_addressline7, ''),'') Home_Address_local5Data_ADDRESS_LINE_7
			,IIF(local5_Flag='Y',ISNULL(fifth_addressline8, ''),'') Home_Address_local5Data_ADDRESS_LINE_8
			,IIF(local5_Flag='Y',ISNULL(fifth_addressline9, ''),'') Home_Address_local5Data_ADDRESS_LINE_9

            ,IIF(local5_Flag='Y',ISNULL(fifth_city_subdivision, ''),'') Home_Address_local5Data_CITY_SUBDIVISION_1
			,IIF(local5_Flag='Y',ISNULL(fifth_city_subdivision_1, ''),'') Home_Address_local5Data_CITY_SUBDIVISION_2
            ,IIF(local5_Flag='Y',ISNULL(fifth_Region_referenceID, ''),'') Home_Address_local5Data_REGION_ID
			,'' Home_Address_local5Data_Descriptor
            ,'' Home_Address_local5Data_Subregion
            ,IIF(local5_Flag='Y',ISNULL(fifth_region_subdivision_1, ''),'')  Home_Address_local5Data_REGION_SUBDIVISION_1
			,IIF(local5_Flag='Y',ISNULL(fifth_region_subdivision_2, ''),'')  Home_Address_local5Data_REGION_SUBDIVISION_2
            ,IIF(local5_Flag='Y',IIF(fifth_country_code='CHN' AND ISNULL(fifth_postalcode, '')='', '000000', ISNULL(fifth_postalcode, '')),'') Home_Address_local5Data_Postal_Code
            ,'' Home_Address_local5Data_Public
            ,'' Home_Address_local5Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local6Data_Row
            ,IIF(local6_Flag='Y',IIF(ISNULL(sixth_effective_date, '')='', '', CONVERT(varchar(10), CAST(sixth_effective_date as date), 101)),'') Home_Address_local6Data_Effective_Date
            ,IIF(local6_Flag='Y',ISNULL(sixth_country_code, ''),'')  Home_Address_local6Data_ISO_Code
            ,IIF(local6_Flag='Y',ISNULL(sixth_city, ''),'') Home_Address_local6Data_CITY
            ,IIF(local6_Flag='Y',ISNULL(sixth_addressline1, ''),'') Home_Address_local6Data_ADDRESS_LINE_1
            ,IIF(local6_Flag='Y',(CASE
                    WHEN ISNULL(sixth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(sixth_addressLine2)
					ELSE ''	  END),'') Home_Address_local6Data_ADDRESS_LINE_2
            ,IIF(local6_Flag='Y',IIF(ISNULL(sixth_country_code, '') = 'JPN', sixth_OR1KK, ''),'') Home_Address_local6Data_ADDRESS_LINE_4
            ,IIF(local6_Flag='Y',IIF(ISNULL(sixth_country_code, '') = 'JPN', sixth_addressLine2, ''),'') Home_Address_local6Data_ADDRESS_LINE_5
            ,IIF(local6_Flag='Y',IIF(ISNULL(sixth_country_code, '') = 'JPN', sixth_OR2KK, ''),'') Home_Address_local6Data_ADDRESS_LINE_6
			,IIF(local6_Flag='Y',ISNULL(sixth_addressline7, ''),'') Home_Address_local6Data_ADDRESS_LINE_7
			,IIF(local6_Flag='Y',ISNULL(sixth_addressline8, ''),'') Home_Address_local6Data_ADDRESS_LINE_8
			,IIF(local6_Flag='Y',ISNULL(sixth_addressline9, ''),'') Home_Address_local6Data_ADDRESS_LINE_9

            ,IIF(local6_Flag='Y',ISNULL(sixth_city_subdivision, ''),'') Home_Address_local6Data_CITY_SUBDIVISION_1
			,IIF(local6_Flag='Y',ISNULL(sixth_city_subdivision_1, ''),'') Home_Address_local6Data_CITY_SUBDIVISION_2
            ,IIF(local6_Flag='Y',ISNULL(sixth_Region_referenceID, ''),'') Home_Address_local6Data_REGION_ID
			,'' Home_Address_local6Data_Descriptor
            ,'' Home_Address_local6Data_Subregion
            ,IIF(local6_Flag='Y',ISNULL(sixth_region_subdivision_1, ''),'')  Home_Address_local6Data_REGION_SUBDIVISION_1
			,IIF(local6_Flag='Y',ISNULL(sixth_region_subdivision_2, ''),'')  Home_Address_local6Data_REGION_SUBDIVISION_2
            ,IIF(local6_Flag='Y',IIF(sixth_country_code='CHN' AND ISNULL(sixth_postalcode, '')='', '000000', ISNULL(sixth_postalcode, '')),'') Home_Address_local6Data_Postal_Code
            ,'' Home_Address_local6Data_Public
            ,'' Home_Address_local6Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local7Data_Row
            ,IIF(local7_Flag='Y',IIF(ISNULL(seventh_effective_date, '')='', '', CONVERT(varchar(10), CAST(seventh_effective_date as date), 101)),'') Home_Address_local7Data_Effective_Date
            ,IIF(local7_Flag='Y',ISNULL(seventh_country_code, ''),'')  Home_Address_local7Data_ISO_Code
            ,IIF(local7_Flag='Y',ISNULL(seventh_city, ''),'') Home_Address_local7Data_CITY
            ,IIF(local7_Flag='Y',ISNULL(seventh_addressline1, ''),'') Home_Address_local7Data_ADDRESS_LINE_1
            ,IIF(local7_Flag='Y',(CASE
                    WHEN ISNULL(seventh_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(seventh_addressLine2)
					ELSE ''	  END),'') Home_Address_local7Data_ADDRESS_LINE_2
            ,IIF(local7_Flag='Y',IIF(ISNULL(seventh_country_code, '') = 'JPN', seventh_OR1KK, ''),'') Home_Address_local7Data_ADDRESS_LINE_4
            ,IIF(local7_Flag='Y',IIF(ISNULL(seventh_country_code, '') = 'JPN', seventh_addressLine2, ''),'') Home_Address_local7Data_ADDRESS_LINE_5
            ,IIF(local7_Flag='Y',IIF(ISNULL(seventh_country_code, '') = 'JPN', seventh_OR2KK, ''),'') Home_Address_local7Data_ADDRESS_LINE_6
			,IIF(local7_Flag='Y',ISNULL(seventh_addressline7, ''),'') Home_Address_local7Data_ADDRESS_LINE_7
			,IIF(local7_Flag='Y',ISNULL(seventh_addressline8, ''),'') Home_Address_local7Data_ADDRESS_LINE_8
			,IIF(local7_Flag='Y',ISNULL(seventh_addressline9, ''),'') Home_Address_local7Data_ADDRESS_LINE_9

            ,IIF(local7_Flag='Y',ISNULL(seventh_city_subdivision, ''),'') Home_Address_local7Data_CITY_SUBDIVISION_1
			,IIF(local7_Flag='Y',ISNULL(seventh_city_subdivision_1, ''),'') Home_Address_local7Data_CITY_SUBDIVISION_2
            ,IIF(local7_Flag='Y',ISNULL(seventh_Region_referenceID, ''),'') Home_Address_local7Data_REGION_ID
			,'' Home_Address_local7Data_Descriptor
            ,'' Home_Address_local7Data_Subregion
            ,IIF(local7_Flag='Y',ISNULL(seventh_region_subdivision_1, ''),'')  Home_Address_local7Data_REGION_SUBDIVISION_1
			,IIF(local7_Flag='Y',ISNULL(seventh_region_subdivision_2, ''),'')  Home_Address_local7Data_REGION_SUBDIVISION_2
            ,IIF(local7_Flag='Y',IIF(seventh_country_code='CHN' AND ISNULL(seventh_postalcode, '')='', '000000', ISNULL(seventh_postalcode, '')),'') Home_Address_local7Data_Postal_Code
            ,'' Home_Address_local7Data_Public
            ,'' Home_Address_local7Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local8Data_Row
            ,IIF(local8_Flag='Y',IIF(ISNULL(eightth_effective_date, '')='', '', CONVERT(varchar(10), CAST(eightth_effective_date as date), 101)),'') Home_Address_local8Data_Effective_Date
            ,IIF(local8_Flag='Y',ISNULL(eightth_country_code, ''),'')  Home_Address_local8Data_ISO_Code
            ,IIF(local8_Flag='Y',ISNULL(eightth_city, ''),'') Home_Address_local8Data_CITY
            ,IIF(local8_Flag='Y',ISNULL(eightth_addressline1, ''),'') Home_Address_local8Data_ADDRESS_LINE_1
            ,IIF(local8_Flag='Y',(CASE
                    WHEN ISNULL(eightth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(eightth_addressLine2)
					ELSE ''	  END),'') Home_Address_local8Data_ADDRESS_LINE_2
            ,IIF(local8_Flag='Y',IIF(ISNULL(eightth_country_code, '') = 'JPN', eightth_OR1KK, ''),'') Home_Address_local8Data_ADDRESS_LINE_4
            ,IIF(local8_Flag='Y',IIF(ISNULL(eightth_country_code, '') = 'JPN', eightth_addressLine2, ''),'') Home_Address_local8Data_ADDRESS_LINE_5
            ,IIF(local8_Flag='Y',IIF(ISNULL(eightth_country_code, '') = 'JPN', eightth_OR2KK, ''),'') Home_Address_local8Data_ADDRESS_LINE_6
			,IIF(local8_Flag='Y',ISNULL(eightth_addressline7, ''),'') Home_Address_local8Data_ADDRESS_LINE_7
			,IIF(local8_Flag='Y',ISNULL(eightth_addressline8, ''),'') Home_Address_local8Data_ADDRESS_LINE_8
			,IIF(local8_Flag='Y',ISNULL(eightth_addressline9, ''),'') Home_Address_local8Data_ADDRESS_LINE_9

            ,IIF(local8_Flag='Y',ISNULL(eightth_city_subdivision, ''),'') Home_Address_local8Data_CITY_SUBDIVISION_1
			,IIF(local8_Flag='Y',ISNULL(eightth_city_subdivision_1, ''),'') Home_Address_local8Data_CITY_SUBDIVISION_2
            ,IIF(local8_Flag='Y',ISNULL(eightth_Region_referenceID, ''),'') Home_Address_local8Data_REGION_ID
			,'' Home_Address_local8Data_Descriptor
            ,'' Home_Address_local8Data_Subregion
            ,IIF(local8_Flag='Y',ISNULL(eightth_region_subdivision_1, ''),'')  Home_Address_local8Data_REGION_SUBDIVISION_1
			,IIF(local8_Flag='Y',ISNULL(eightth_region_subdivision_2, ''),'')  Home_Address_local8Data_REGION_SUBDIVISION_2
            ,IIF(local8_Flag='Y',IIF(eightth_country_code='CHN' AND ISNULL(eightth_postalcode, '')='', '000000', ISNULL(eightth_postalcode, '')),'') Home_Address_local8Data_Postal_Code
            ,'' Home_Address_local8Data_Public
            ,'' Home_Address_local8Data_Usage					
			
			-----------------------------------------
            ,'' Home_Address_local9Data_Row
            ,IIF(local9_Flag='Y',IIF(ISNULL(nineth_effective_date, '')='', '', CONVERT(varchar(10), CAST(nineth_effective_date as date), 101)),'') Home_Address_local9Data_Effective_Date
            ,IIF(local9_Flag='Y',ISNULL(nineth_country_code, ''),'')  Home_Address_local9Data_ISO_Code
            ,IIF(local9_Flag='Y',ISNULL(nineth_city, ''),'') Home_Address_local9Data_CITY
            ,IIF(local9_Flag='Y',ISNULL(nineth_addressline1, ''),'') Home_Address_local9Data_ADDRESS_LINE_1
            ,IIF(local9_Flag='Y',(CASE
                    WHEN ISNULL(nineth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(nineth_addressLine2)
					ELSE ''	  END),'') Home_Address_local9Data_ADDRESS_LINE_2
            ,IIF(local9_Flag='Y',IIF(ISNULL(nineth_country_code, '') = 'JPN', nineth_OR1KK, ''),'') Home_Address_local9Data_ADDRESS_LINE_4
            ,IIF(local9_Flag='Y',IIF(ISNULL(nineth_country_code, '') = 'JPN', nineth_addressLine2, ''),'') Home_Address_local9Data_ADDRESS_LINE_5
            ,IIF(local9_Flag='Y',IIF(ISNULL(nineth_country_code, '') = 'JPN', nineth_OR2KK, ''),'') Home_Address_local9Data_ADDRESS_LINE_6
			,IIF(local9_Flag='Y',ISNULL(nineth_addressline7, ''),'') Home_Address_local9Data_ADDRESS_LINE_7
			,IIF(local9_Flag='Y',ISNULL(nineth_addressline8, ''),'') Home_Address_local9Data_ADDRESS_LINE_8
			,IIF(local9_Flag='Y',ISNULL(nineth_addressline9, ''),'') Home_Address_local9Data_ADDRESS_LINE_9

            ,IIF(local9_Flag='Y',ISNULL(nineth_city_subdivision, ''),'') Home_Address_local9Data_CITY_SUBDIVISION_1
			,IIF(local9_Flag='Y',ISNULL(nineth_city_subdivision_1, ''),'') Home_Address_local9Data_CITY_SUBDIVISION_2
            ,IIF(local9_Flag='Y',ISNULL(nineth_Region_referenceID, ''),'') Home_Address_local9Data_REGION_ID
			,'' Home_Address_local9Data_Descriptor
            ,'' Home_Address_local9Data_Subregion
            ,IIF(local9_Flag='Y',ISNULL(nineth_region_subdivision_1, ''),'')  Home_Address_local9Data_REGION_SUBDIVISION_1
			,IIF(local9_Flag='Y',ISNULL(nineth_region_subdivision_2, ''),'')  Home_Address_local9Data_REGION_SUBDIVISION_2
            ,IIF(local9_Flag='Y',IIF(nineth_country_code='CHN' AND ISNULL(nineth_postalcode, '')='', '000000', ISNULL(nineth_postalcode, '')),'') Home_Address_local9Data_Postal_Code
            ,'' Home_Address_local9Data_Public
            ,'' Home_Address_local9Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local10Data_Row
            ,IIF(local10_Flag='Y',IIF(ISNULL(tenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(tenth_effective_date as date), 101)),'') Home_Address_local10Data_Effective_Date
            ,IIF(local10_Flag='Y',ISNULL(tenth_country_code, ''),'')  Home_Address_local10Data_ISO_Code
            ,IIF(local10_Flag='Y',ISNULL(tenth_city, ''),'') Home_Address_local10Data_CITY
            ,IIF(local10_Flag='Y',ISNULL(tenth_addressline1, ''),'') Home_Address_local10Data_ADDRESS_LINE_1
            ,IIF(local10_Flag='Y',(CASE
                    WHEN ISNULL(tenth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(tenth_addressLine2)
					ELSE ''	  END),'') Home_Address_local10Data_ADDRESS_LINE_2
            ,IIF(local10_Flag='Y',IIF(ISNULL(tenth_country_code, '') = 'JPN', tenth_OR1KK, ''),'') Home_Address_local10Data_ADDRESS_LINE_4
            ,IIF(local10_Flag='Y',IIF(ISNULL(tenth_country_code, '') = 'JPN', tenth_addressLine2, ''),'') Home_Address_local10Data_ADDRESS_LINE_5
            ,IIF(local10_Flag='Y',IIF(ISNULL(tenth_country_code, '') = 'JPN', tenth_OR2KK, ''),'') Home_Address_local10Data_ADDRESS_LINE_6
			,IIF(local10_Flag='Y',ISNULL(tenth_addressline7, ''),'') Home_Address_local10Data_ADDRESS_LINE_7
			,IIF(local10_Flag='Y',ISNULL(tenth_addressline8, ''),'') Home_Address_local10Data_ADDRESS_LINE_8
			,IIF(local10_Flag='Y',ISNULL(tenth_addressline9, ''),'') Home_Address_local10Data_ADDRESS_LINE_9

            ,IIF(local10_Flag='Y',ISNULL(tenth_city_subdivision, ''),'') Home_Address_local10Data_CITY_SUBDIVISION_1
			,IIF(local10_Flag='Y',ISNULL(tenth_city_subdivision_1, ''),'') Home_Address_local10Data_CITY_SUBDIVISION_2
            ,IIF(local10_Flag='Y',ISNULL(tenth_Region_referenceID, ''),'') Home_Address_local10Data_REGION_ID
			,'' Home_Address_local10Data_Descriptor
            ,'' Home_Address_local10Data_Subregion
            ,IIF(local10_Flag='Y',ISNULL(tenth_region_subdivision_1, ''),'')  Home_Address_local10Data_REGION_SUBDIVISION_1
			,IIF(local10_Flag='Y',ISNULL(tenth_region_subdivision_2, ''),'')  Home_Address_local10Data_REGION_SUBDIVISION_2
            ,IIF(local10_Flag='Y',IIF(tenth_country_code='CHN' AND ISNULL(tenth_postalcode, '')='', '000000', ISNULL(tenth_postalcode, '')),'') Home_Address_local10Data_Postal_Code
            ,'' Home_Address_local10Data_Public
            ,'' Home_Address_local10Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local11Data_Row
            ,IIF(local11_Flag='Y',IIF(ISNULL(eleventh_effective_date, '')='', '', CONVERT(varchar(10), CAST(eleventh_effective_date as date), 101)),'') Home_Address_local11Data_Effective_Date
            ,IIF(local11_Flag='Y',ISNULL(eleventh_country_code, ''),'')  Home_Address_local11Data_ISO_Code
            ,IIF(local11_Flag='Y',ISNULL(eleventh_city, ''),'') Home_Address_local11Data_CITY
            ,IIF(local11_Flag='Y',ISNULL(eleventh_addressline1, ''),'') Home_Address_local11Data_ADDRESS_LINE_1
            ,IIF(local11_Flag='Y',(CASE
                    WHEN ISNULL(eleventh_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(eleventh_addressLine2)
					ELSE ''	  END),'') Home_Address_local11Data_ADDRESS_LINE_2
            ,IIF(local11_Flag='Y',IIF(ISNULL(eleventh_country_code, '') = 'JPN', eleventh_OR1KK, ''),'') Home_Address_local11Data_ADDRESS_LINE_4
            ,IIF(local11_Flag='Y',IIF(ISNULL(eleventh_country_code, '') = 'JPN', eleventh_addressLine2, ''),'') Home_Address_local11Data_ADDRESS_LINE_5
            ,IIF(local11_Flag='Y',IIF(ISNULL(eleventh_country_code, '') = 'JPN', eleventh_OR2KK, ''),'') Home_Address_local11Data_ADDRESS_LINE_6
			,IIF(local11_Flag='Y',ISNULL(eleventh_addressline7, ''),'') Home_Address_local11Data_ADDRESS_LINE_7
			,IIF(local11_Flag='Y',ISNULL(eleventh_addressline8, ''),'') Home_Address_local11Data_ADDRESS_LINE_8
			,IIF(local11_Flag='Y',ISNULL(eleventh_addressline9, ''),'') Home_Address_local11Data_ADDRESS_LINE_9

            ,IIF(local11_Flag='Y',ISNULL(eleventh_city_subdivision, ''),'') Home_Address_local11Data_CITY_SUBDIVISION_1
			,IIF(local11_Flag='Y',ISNULL(eleventh_city_subdivision_1, ''),'') Home_Address_local11Data_CITY_SUBDIVISION_2
            ,IIF(local11_Flag='Y',ISNULL(eleventh_Region_referenceID, ''),'') Home_Address_local11Data_REGION_ID
			,'' Home_Address_local11Data_Descriptor
            ,'' Home_Address_local11Data_Subregion
            ,IIF(local11_Flag='Y',ISNULL(eleventh_region_subdivision_1, ''),'')  Home_Address_local11Data_REGION_SUBDIVISION_1
			,IIF(local11_Flag='Y',ISNULL(eleventh_region_subdivision_2, ''),'')  Home_Address_local11Data_REGION_SUBDIVISION_2
            ,IIF(local11_Flag='Y',IIF(eleventh_country_code='CHN' AND ISNULL(eleventh_postalcode, '')='', '000000', ISNULL(eleventh_postalcode, '')),'') Home_Address_local11Data_Postal_Code
            ,'' Home_Address_local11Data_Public
            ,'' Home_Address_local11Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local12Data_Row
            ,IIF(local12_Flag='Y',IIF(ISNULL(twelveth_effective_date, '')='', '', CONVERT(varchar(10), CAST(twelveth_effective_date as date), 101)),'') Home_Address_local12Data_Effective_Date
            ,IIF(local12_Flag='Y',ISNULL(twelveth_country_code, ''),'')  Home_Address_local12Data_ISO_Code
            ,IIF(local12_Flag='Y',ISNULL(twelveth_city, ''),'') Home_Address_local12Data_CITY
            ,IIF(local12_Flag='Y',ISNULL(twelveth_addressline1, ''),'') Home_Address_local12Data_ADDRESS_LINE_1
            ,IIF(local12_Flag='Y',(CASE
                    WHEN ISNULL(twelveth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(twelveth_addressLine2)
					ELSE ''	  END),'') Home_Address_local12Data_ADDRESS_LINE_2
            ,IIF(local12_Flag='Y',IIF(ISNULL(twelveth_country_code, '') = 'JPN', twelveth_OR1KK, ''),'') Home_Address_local12Data_ADDRESS_LINE_4
            ,IIF(local12_Flag='Y',IIF(ISNULL(twelveth_country_code, '') = 'JPN', twelveth_addressLine2, ''),'') Home_Address_local12Data_ADDRESS_LINE_5
            ,IIF(local12_Flag='Y',IIF(ISNULL(twelveth_country_code, '') = 'JPN', twelveth_OR2KK, ''),'') Home_Address_local12Data_ADDRESS_LINE_6
			,IIF(local12_Flag='Y',ISNULL(twelveth_addressline7, ''),'') Home_Address_local12Data_ADDRESS_LINE_7
			,IIF(local12_Flag='Y',ISNULL(twelveth_addressline8, ''),'') Home_Address_local12Data_ADDRESS_LINE_8
			,IIF(local12_Flag='Y',ISNULL(twelveth_addressline9, ''),'') Home_Address_local12Data_ADDRESS_LINE_9

            ,IIF(local12_Flag='Y',ISNULL(twelveth_city_subdivision, ''),'') Home_Address_local12Data_CITY_SUBDIVISION_1
			,IIF(local12_Flag='Y',ISNULL(twelveth_city_subdivision_1, ''),'') Home_Address_local12Data_CITY_SUBDIVISION_2
            ,IIF(local12_Flag='Y',ISNULL(twelveth_Region_referenceID, ''),'') Home_Address_local12Data_REGION_ID
			,'' Home_Address_local12Data_Descriptor
            ,'' Home_Address_local12Data_Subregion
            ,IIF(local12_Flag='Y',ISNULL(twelveth_region_subdivision_1, ''),'')  Home_Address_local12Data_REGION_SUBDIVISION_1
			,IIF(local12_Flag='Y',ISNULL(twelveth_region_subdivision_2, ''),'')  Home_Address_local12Data_REGION_SUBDIVISION_2
            ,IIF(local12_Flag='Y',IIF(twelveth_country_code='CHN' AND ISNULL(twelveth_postalcode, '')='', '000000', ISNULL(twelveth_postalcode, '')),'') Home_Address_local12Data_Postal_Code
            ,'' Home_Address_local12Data_Public
            ,'' Home_Address_local12Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local13Data_Row
            ,IIF(local13_Flag='Y',IIF(ISNULL(thirteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(thirteenth_effective_date as date), 101)),'') Home_Address_local13Data_Effective_Date
            ,IIF(local13_Flag='Y',ISNULL(thirteenth_country_code, ''),'')  Home_Address_local13Data_ISO_Code
            ,IIF(local13_Flag='Y',ISNULL(thirteenth_city, ''),'') Home_Address_local13Data_CITY
            ,IIF(local13_Flag='Y',ISNULL(thirteenth_addressline1, ''),'') Home_Address_local13Data_ADDRESS_LINE_1
            ,IIF(local13_Flag='Y',(CASE
                    WHEN ISNULL(thirteenth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(thirteenth_addressLine2)
					ELSE ''	  END),'') Home_Address_local13Data_ADDRESS_LINE_2
            ,IIF(local13_Flag='Y',IIF(ISNULL(thirteenth_country_code, '') = 'JPN', thirteenth_OR1KK, ''),'') Home_Address_local13Data_ADDRESS_LINE_4
            ,IIF(local13_Flag='Y',IIF(ISNULL(thirteenth_country_code, '') = 'JPN', thirteenth_addressLine2, ''),'') Home_Address_local13Data_ADDRESS_LINE_5
            ,IIF(local13_Flag='Y',IIF(ISNULL(thirteenth_country_code, '') = 'JPN', thirteenth_OR2KK, ''),'') Home_Address_local13Data_ADDRESS_LINE_6
			,IIF(local13_Flag='Y',ISNULL(thirteenth_addressline7, ''),'') Home_Address_local13Data_ADDRESS_LINE_7
			,IIF(local13_Flag='Y',ISNULL(thirteenth_addressline8, ''),'') Home_Address_local13Data_ADDRESS_LINE_8
			,IIF(local13_Flag='Y',ISNULL(thirteenth_addressline9, ''),'') Home_Address_local13Data_ADDRESS_LINE_9

            ,IIF(local13_Flag='Y',ISNULL(thirteenth_city_subdivision, ''),'') Home_Address_local13Data_CITY_SUBDIVISION_1
			,IIF(local13_Flag='Y',ISNULL(thirteenth_city_subdivision_1, ''),'') Home_Address_local13Data_CITY_SUBDIVISION_2
            ,IIF(local13_Flag='Y',ISNULL(thirteenth_Region_referenceID, ''),'') Home_Address_local13Data_REGION_ID
			,'' Home_Address_local13Data_Descriptor
            ,'' Home_Address_local13Data_Subregion
            ,IIF(local13_Flag='Y',ISNULL(thirteenth_region_subdivision_1, ''),'')  Home_Address_local13Data_REGION_SUBDIVISION_1
			,IIF(local13_Flag='Y',ISNULL(thirteenth_region_subdivision_2, ''),'')  Home_Address_local13Data_REGION_SUBDIVISION_2
            ,IIF(local13_Flag='Y',IIF(thirteenth_country_code='CHN' AND ISNULL(thirteenth_postalcode, '')='', '000000', ISNULL(thirteenth_postalcode, '')),'') Home_Address_local13Data_Postal_Code
            ,'' Home_Address_local13Data_Public
            ,'' Home_Address_local13Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local14Data_Row
            ,IIF(local14_Flag='Y',IIF(ISNULL(fourteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fourteenth_effective_date as date), 101)),'') Home_Address_local14Data_Effective_Date
            ,IIF(local14_Flag='Y',ISNULL(fourteenth_country_code, ''),'')  Home_Address_local14Data_ISO_Code
            ,IIF(local14_Flag='Y',ISNULL(fourteenth_city, ''),'') Home_Address_local14Data_CITY
            ,IIF(local14_Flag='Y',ISNULL(fourteenth_addressline1, ''),'') Home_Address_local14Data_ADDRESS_LINE_1
            ,IIF(local14_Flag='Y',(CASE
                    WHEN ISNULL(fourteenth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(fourteenth_addressLine2)
					ELSE ''	  END),'') Home_Address_local14Data_ADDRESS_LINE_2
            ,IIF(local14_Flag='Y',IIF(ISNULL(fourteenth_country_code, '') = 'JPN', fourteenth_OR1KK, ''),'') Home_Address_local14Data_ADDRESS_LINE_4
            ,IIF(local14_Flag='Y',IIF(ISNULL(fourteenth_country_code, '') = 'JPN', fourteenth_addressLine2, ''),'') Home_Address_local14Data_ADDRESS_LINE_5
            ,IIF(local14_Flag='Y',IIF(ISNULL(fourteenth_country_code, '') = 'JPN', fourteenth_OR2KK, ''),'') Home_Address_local14Data_ADDRESS_LINE_6
			,IIF(local14_Flag='Y',ISNULL(fourteenth_addressline7, ''),'') Home_Address_local14Data_ADDRESS_LINE_7
			,IIF(local14_Flag='Y',ISNULL(fourteenth_addressline8, ''),'') Home_Address_local14Data_ADDRESS_LINE_8
			,IIF(local14_Flag='Y',ISNULL(fourteenth_addressline9, ''),'') Home_Address_local14Data_ADDRESS_LINE_9

            ,IIF(local14_Flag='Y',ISNULL(fourteenth_city_subdivision, ''),'') Home_Address_local14Data_CITY_SUBDIVISION_1
			,IIF(local14_Flag='Y',ISNULL(fourteenth_city_subdivision_1, ''),'') Home_Address_local14Data_CITY_SUBDIVISION_2
            ,IIF(local14_Flag='Y',ISNULL(fourteenth_Region_referenceID, ''),'') Home_Address_local14Data_REGION_ID
			,'' Home_Address_local14Data_Descriptor
            ,'' Home_Address_local14Data_Subregion
            ,IIF(local14_Flag='Y',ISNULL(fourteenth_region_subdivision_1, ''),'')  Home_Address_local14Data_REGION_SUBDIVISION_1
			,IIF(local14_Flag='Y',ISNULL(fourteenth_region_subdivision_2, ''),'')  Home_Address_local14Data_REGION_SUBDIVISION_2
            ,IIF(local14_Flag='Y',IIF(fourteenth_country_code='CHN' AND ISNULL(fourteenth_postalcode, '')='', '000000', ISNULL(fourteenth_postalcode, '')),'') Home_Address_local14Data_Postal_Code
            ,'' Home_Address_local14Data_Public
            ,'' Home_Address_local14Data_Usage					
			

			-----------------------------------------
            ,'' Home_Address_local15Data_Row
            ,IIF(local15_Flag='Y',IIF(ISNULL(fifteenth_effective_date, '')='', '', CONVERT(varchar(10), CAST(fifteenth_effective_date as date), 101)),'') Home_Address_local15Data_Effective_Date
            ,IIF(local15_Flag='Y',ISNULL(fifteenth_country_code, ''),'')  Home_Address_local15Data_ISO_Code
            ,IIF(local15_Flag='Y',ISNULL(fifteenth_city, ''),'') Home_Address_local15Data_CITY
            ,IIF(local15_Flag='Y',ISNULL(fifteenth_addressline1, ''),'') Home_Address_local15Data_ADDRESS_LINE_1
            ,IIF(local15_Flag='Y',(CASE
                    WHEN ISNULL(fifteenth_country_code, '') in ('CHN','KOR','THA','TWN', 'RUS','UKR','GRC','EGY') THEN dbo.GetNonEnglishName(fifteenth_addressLine2)
					ELSE ''	  END),'') Home_Address_local15Data_ADDRESS_LINE_2
            ,IIF(local15_Flag='Y',IIF(ISNULL(fifteenth_country_code, '') = 'JPN', fifteenth_OR1KK, ''),'') Home_Address_local15Data_ADDRESS_LINE_4
            ,IIF(local15_Flag='Y',IIF(ISNULL(fifteenth_country_code, '') = 'JPN', fifteenth_addressLine2, ''),'') Home_Address_local15Data_ADDRESS_LINE_5
            ,IIF(local15_Flag='Y',IIF(ISNULL(fifteenth_country_code, '') = 'JPN', fifteenth_OR2KK, ''),'') Home_Address_local15Data_ADDRESS_LINE_6
			,IIF(local15_Flag='Y',ISNULL(fifteenth_addressline7, ''),'') Home_Address_local15Data_ADDRESS_LINE_7
			,IIF(local15_Flag='Y',ISNULL(fifteenth_addressline8, ''),'') Home_Address_local15Data_ADDRESS_LINE_8
			,IIF(local15_Flag='Y',ISNULL(fifteenth_addressline9, ''),'') Home_Address_local15Data_ADDRESS_LINE_9

            ,IIF(local15_Flag='Y',ISNULL(fifteenth_city_subdivision, ''),'') Home_Address_local15Data_CITY_SUBDIVISION_1
			,IIF(local15_Flag='Y',ISNULL(fifteenth_city_subdivision_1, ''),'') Home_Address_local15Data_CITY_SUBDIVISION_2
            ,IIF(local15_Flag='Y',ISNULL(fifteenth_Region_referenceID, ''),'') Home_Address_local15Data_REGION_ID
			,'' Home_Address_local15Data_Descriptor
            ,'' Home_Address_local15Data_Subregion
            ,IIF(local15_Flag='Y',ISNULL(fifteenth_region_subdivision_1, ''),'')  Home_Address_local15Data_REGION_SUBDIVISION_1
			,IIF(local15_Flag='Y',ISNULL(fifteenth_region_subdivision_2, ''),'')  Home_Address_local15Data_REGION_SUBDIVISION_2
            ,IIF(local15_Flag='Y',IIF(fifteenth_country_code='CHN' AND ISNULL(fifteenth_postalcode, '')='', '000000', ISNULL(fifteenth_postalcode, '')),'') Home_Address_local15Data_Postal_Code
            ,'' Home_Address_local15Data_Public
            ,'' Home_Address_local15Data_Usage					
				
			--------------------------------------------------------------------
            ,''[PrimaryWorkAddressData_Row]
            ,''[PrimaryWorkAddressData_EffectiveDate]
            ,''[PrimaryWorkAddressData_CountryISOCode]
            ,''[PrimaryWorkAddressData_AddressLine1]
            ,''[PrimaryWorkAddressData_AddressLine2]
            ,''[PrimaryWorkAddressData_City(Municipality)]
            ,''[PrimaryWorkAddressData_SubMunicipalityType]
            ,''[PrimaryWorkAddressData_SubMunicipality]
            ,''[PrimaryWorkAddressData_State(Region)]
            ,''[PrimaryWorkAddressData_SubregionDescriptor]
            ,''[PrimaryWorkAddressData_SubregionType]
            ,''[PrimaryWorkAddressData_Subregion(County)]
            ,''[PrimaryWorkAddressData_PostalCode]
            ,''[PrimaryWorkAddressData_Public]
            ,''[PrimaryWorkAddressData_Usage]

            ,''[WorkAddress2Data_Row]
            ,''[WorkAddress2Data_EffectiveDate]
            ,''[WorkAddress2Data_CountryISOCode]
            ,''[WorkAddress2Data_AddressLine1]
            ,''[WorkAddress2Data_AddressLine2]
            ,''[WorkAddress2Data_City(Municipality)]
            ,''[WorkAddress2Data_SubMunicipalityType]
            ,''[WorkAddress2Data_SubMunicipality]
            ,''[WorkAddress2Data_State(Region)]
            ,''[WorkAddress2Data_SubregionDescriptor]
            ,''[WorkAddress2Data_SubregionType]
            ,''[WorkAddress2Data_Subregion(County)]
            ,''[WorkAddress2Data_PostalCode]
            ,''[WorkAddress2Data_Public]
            ,''[WorkAddress2Data_Usage]

            ,primary_SUBTY
            ,secondary_SUBTY
	        ,third_SUBTY
            ,fourth_SUBTY
	        ,fifth_SUBTY
	        ,sixth_SUBTY
	        ,seventh_SUBTY
	        ,eightth_SUBTY
	        ,nineth_SUBTY
	        ,tenth_SUBTY
	        ,eleventh_SUBTY
	        ,twelveth_SUBTY
	        ,thirteenth_SUBTY
	        ,fourteenth_SUBTY
	        ,fifteenth_SUBTY

			,'Not Required' [PrimaryRegionValidate]
			,'Not Required' [PrimaryPostalCodeValidate]
			,[Emp - Group]
			,[WD_EMP_TYPE]
			,[Geo - Country (CC)]
			,[Emp - Personnel Number]
				
            INTO WD_HR_TR_WorkerAddress 
    FROM WAVE_NM_ADDRESS WHERE PRIMARY_COUNTRY_CODE<>'JPN'
	--SELECT * FROM WD_HR_TR_WorkerAddress

	/* Updation is for Emergency Contact */
	UPDATE A1 SET 
	    [PrimaryRegionValidate]=IIF(ISNULL(A2.[Region(State)], '')='Required', 'Required', 'Not Required'),
		[PrimaryPostalCodeValidate]=IIF(ISNULL(A2.[Postal Code], '')='Required', 'Required', 'Not Required')
	FROM WD_HR_TR_WorkerAddress A1 
	   LEFT JOIN WAVE_ADDRESS_VALIDATION A2 ON A1.[HomeAddress1Data_CountryISOCode]=A2.[Country Code] OR A1.[Home_Address_Local1Data_ISO_Code]=A2.[Country Code]

	/* For Thailand Local Address 2 need to be blank */
    UPDATE WD_HR_TR_WorkerAddress SET
		Home_Address_Local1Data_ADDRESS_LINE_1= ISNULL(Home_Address_Local1Data_ADDRESS_LINE_1, '') + ' ' + ISNULL(Home_Address_Local1Data_ADDRESS_LINE_2, ''),
		Home_Address_Local1Data_ADDRESS_LINE_2='',
		Home_Address_Local2Data_ADDRESS_LINE_1= ISNULL(Home_Address_Local2Data_ADDRESS_LINE_1, '') + ' ' + ISNULL(Home_Address_Local2Data_ADDRESS_LINE_2, ''),
		Home_Address_Local2Data_ADDRESS_LINE_2=''
	WHERE Home_Address_Local1Data_ISO_Code='THA'

	/*
	/* Worker Address Error List */
	DELETE FROM NOVARTIS_DATA_MIGRATION_ERROR_LIST WHERE Wave=@which_wavestage AND [Report]=@which_report;
	INSERT INTO NOVARTIS_DATA_MIGRATION_ERROR_LIST
	SELECT @which_wavestage, @which_report, EmployeeID, CountryCC, ErrorText FROM dbo.GetAddressFormat('Wave 4');
    */
END
GO


--EXEC PROC_W3_AUTOMATE_WORKER_ADDRESS_NEW 'W4_P2', 'Worker Address', '2020-10-02'
--EXEC PROC_W3_AUTOMATE_WORKER_ADDRESS_NEW 'W4_GOLD', 'Worker Address', '2021-02-14'
--PrimaryHomeAddressData:[Address Line #1]: Contains "special" character at 31(Apartment no.4, second floor ,‘Eid Salem Building ,15TH May);
--PrimaryHomeAddressData:[Address Line #1]: Contains "special" character at 21(3 said ben Amer st. – Suhag);
--SELECT * FROM WD_HR_TR_WorkerAddress ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE EmployeeID IN ('84000839', '02114255', '02116375', '02103634') ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [Home_Address_Local1Data_ISO_Code]='PAK' ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [Home_Address_Local1Data_ADDRESS_LINE_1]<>'' ORDER BY [EmployeeID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [Emp - Group] IN ('3', '4') ORDER BY [EmployeeID]
--SELECT * FROM REGION_MAPPING_LKUP WHERE PERNR IN ('84000194', '02103634')
--SELECT DISTINCT LOCAT, POSTA FROM PRIMARY_ADDRESS_PA0006 WHERE PERNR LIKE '06%'
--SELECT LAND1,CTR,COUNC,CCD,RCTVC,MC FROM PRIMARY_ADDRESS_PA0006 WHERE PERNR LIKE '15%'
--SELECT PERNR, LAND1, CC, ORT01, CITY, STATE, REG, IT_STREETNUM FROM PRIMARY_ADDRESS_PA0006 WHERE LAND1 IN ('TR', 'VN', 'PK', 'BD')
--SELECT * FROM W4_ITALY_STREET_NUMBER_LKUP
--SELECT * FROM W4_P2_PA0006
--DECLARE @Value AS NVARCHAR(2000)='KORTEJOKI,'
--SET @Value=IIF(SUBSTRING(@Value, LEN(@Value), 1)=',', SUBSTRING(@Value, 1, LEN(@Value)-1), @Value);
--PRINT @Value
--PrimaryHomeAddressData:[Address Line #1]: Contains "special" character at 31(Apartment no.4, second floor ,‘Eid Salem Building ,15TH May);
--PRINT SUBSTRING(@Value, LEN(@Value), 1)
--SELECT * FROM ALCON_MIGRATION_ERROR_LIST WHERE Wave='W4_P2' AND [Report Name]='Worker Address' ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_WorkerAddress WHERE [EmployeeID] IN ('84000368', '46001306', '02105801', '84000615')
--SELECT * FROM SET_ADDRESS_FIELD_MAPPING_DONE WHERE ISO2='RS'
--SELECT DISTINCt PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA FROM W4_P2_PA0006 WHERE begDa<=CAST('2020-10-02' as date) and endda>=CAST('2020-10-02' as date) AND SUBTY In (1, 5)
--SELECT DISTINCt PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA, RCTVC FROM W4_P2_PA0006 WHERE PERNR IN ('15501117', '46001306', '84000615', '02105801') AND begDa<=CAST('2020-10-02' as date) and endda>=CAST('2020-10-02' as date) AND SUBTY In ('1', '5')
--SELECT DISTINCt PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA FROM W4_P2_PA0006 WHERE PERNR like '15%' AND begDa<=CAST('2020-10-02' as date) and endda>=CAST('2020-10-02' as date) AND SUBTY In (1, 5)
--SELECT DISTINCt PERNR, SUBTY, STRAS, LOCAT, LAND1, STATE, COUNC, ORT01, PSTLZ, HSNMR, BLDNG, FLOOR, POSTA FROM W4_P2_PA0006 WHERE PERNR IN (SELECT [ApplicantID] FROM  WD_HR_TR_WORKERADDRESS_EMPGROUP_04) AND begDa<=CAST('2020-10-02' as date) and endda>=CAST('2020-10-02' as date) AND SUBTY In ('1', '5')
--SELECT * FROM  WD_HR_TR_WORKERADDRESS_EMPGROUP_04

--SELECT * FROM WAVE_ADDRESS_VALIDATION
--SELECT * FROM (
--SELECT *, 'All' Flag FROM WD_HR_TR_WorkerAddress WHERE ApplicantID IN (SELECT ApplicantID FROM WD_HR_TR_WORKERADDRESS_EMPGROUP_04)
--UNION ALL
--SELECT *, 'Region' Flag FROM WD_HR_TR_WorkerAddress WHERE 
--             ([PrimaryHomeAddressData_State(Region)] IN (SELECT DISTINCT [Region Code] FROM [W4_MISSING_REGION_MAPPING_FOR_ADDRESS]) OR
--			  [HomeAddress2Data_STATE(REGION)] IN (SELECT DISTINCT [Region Code] FROM [W4_MISSING_REGION_MAPPING_FOR_ADDRESS]) OR
--			  [Home_Address_Local1Data_REGION_ID] IN (SELECT DISTINCT [Region Code] FROM [W4_MISSING_REGION_MAPPING_FOR_ADDRESS]) OR
--			  [Home_Address_Local2Data_REGION_ID] IN (SELECT DISTINCT [Region Code] FROM [W4_MISSING_REGION_MAPPING_FOR_ADDRESS]))
--UNION ALL
--SELECT *, 'All' Flag FROM WD_HR_TR_WorkerAddress WHERE ApplicantID IN (SELECT [EmployeeID] FROM AddressLine3And4)
--) A1
--ORDER BY EMPLOYEEID

--SELECT [EmployeeID], 'Address' Flag INTO AddressLine3And4 FROM WD_HR_TR_WorkerAddress WHERE 
--             ([PrimaryHomeAddressData_CountryISOCode] IN ('SVK', 'NLD', 'DNK') OR
--			  [HomeAddress2Data_COUNTRYISOCODE] IN ('SVK', 'NLD', 'DNK') OR
--			  [Home_Address_Local1Data_ISO_Code] IN ('SVK', 'NLD', 'DNK') OR
--			  [Home_Address_Local2Data_ISO_Code] IN ('SVK', 'NLD', 'DNK')) AND
--			  (PrimaryHomeAddressData_AddressLine3 <> '' OR PrimaryHomeAddressData_AddressLine4 <> '')

--SELECT DISTINCT a.Persno, 
--(case when country_1 in ('DK','EE','FI','IL','MA','NL','NO','PL','RO','RU','SA','SK','UA') then houseno_1 end) primary_addressline3,
--(case when country_1 in ('NL','PL','RO','RU','SK','UA') then apartment_1 end) primary_addressline4,
--(case when country_2 in ('DK','EE','FI','IL','MA','NL','NO','PL','RO','RU','SA','SK','UA') then houseno_2 end) secondary_Addressline3,
--(case when country_2 in ('NL','PL','RO','RU','SK','UA') then apartment_2 end) secondary_Addressline4
--from WAVE_NM_address_source a
--join temp_transposed b
--on a.persno = b.persno
--WHERE ISNULL(primary_addressline3, '') <> '' OR ISNULL(primary_addressline4, '') <> '' OR ISNULL(secondary_Addressline3, '') <> '' OR ISNULL(secondary_Addressline4, '') <> ''

--SELECT * FROM [SET_ADDRESS_FIELD_MAPPING] WHERE ISO2 IN ('EG','SK') ORDER BY ISO2
--SELECT * FROM [SET_ADDRESS_FIELD_MAPPING_BASIC] WHERE ISO2 IN ('EG','SK') ORDER BY ISO2 

--SELECT ISO2, SRC_FIELD, SRC_MAP_FIELD, DST_FIELD, DST_MAP_FIELD, 
--		ROW_NUMBER() OVER(PARTITION BY ISO2, DST_MAP_FIELD ORDER BY ISO2, DST_MAP_FIELD) [INDEX] INTO [SET_ADDRESS_FIELD_MAPPING_CHECKING] FROM ( 
--	SELECT *, ROW_NUMBER() OVER(PARTITION BY ISO2, SRC_MAP_FIELD ORDER BY ISO2, SRC_MAP_FIELD) REPEAT_SRC FROM (
--		SELECT *, ROW_NUMBER() OVER(PARTITION BY ISO2, SRC_MAP_FIELD, DST_MAP_FIELD ORDER BY ISO2, SRC_MAP_FIELD, DST_MAP_FIELD, ORD DESC) REPEAT_ROW FROM (
--			SELECT *, 1 ORD FROM [SET_ADDRESS_FIELD_MAPPING]
--			UNION ALL
--			SELECT *, 2 ORD FROM [SET_ADDRESS_FIELD_MAPPING_BASIC]
--		) A1 WHERE ISNULL(SRC_MAP_FIELD, '') <> '' AND ISNULL(DST_MAP_FIELD, '') <> ''
--	) A2 WHERE REPEAT_ROW=1
--) A3 ORDER BY ISO2, SRC_MAP_FIELD, DST_MAP_FIELD

--UPDATE [SET_ADDRESS_FIELD_MAPPING_CHECKING] SET OPERATION='MAPPING'
--SELECT * INTO [SET_ADDRESS_FIELD_MAPPING_DONE] FROM [SET_ADDRESS_FIELD_MAPPING_CHECKING] 
--SELECT * FROM WAVE_ADDRESS_VALIDATION
--UPDATE WAVE_ADDRESS_VALIDATION SET [Flag Type]='B'

