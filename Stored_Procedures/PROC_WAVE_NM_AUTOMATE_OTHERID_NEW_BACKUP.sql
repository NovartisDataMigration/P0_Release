USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID]    Script Date: 26/09/2019 11:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:<Subramanian.C>
-- =============================================
-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_CONFIGURATION', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_CONFIGURATION;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_CONFIGURATION]
AS
BEGIN
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] SET [CASE SENSITIVE] = 'Y', [MIN LENGTH]=99, [MAX LENGTH]=99
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='any characters allowed'
	WHERE FORMAT IS NULL OR FORMAT='any characters allowed'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[a-zA-Z0-9]%', [MIN LENGTH]=11, [MAX LENGTH]=11
	WHERE FORMAT='11 characters, may include numbers or upper-case letters in any position'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[a-zA-Z0-9]%', [MIN LENGTH]=6, [MAX LENGTH]=20
	WHERE FORMAT='6-20 characters'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[a-zA-Z0-9]%', [MIN LENGTH]=8, [MAX LENGTH]=20
	WHERE FORMAT='8-20 characters'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[a-zA-Z0-9]%', [MIN LENGTH]=7, [MAX LENGTH]=20
	WHERE FORMAT='7-20 characters allowed'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[0-9]%', [MIN LENGTH]=6, [MAX LENGTH]=20
	WHERE FORMAT='6-8 digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='%[0-9.\]%', [MIN LENGTH]=6, [MAX LENGTH]=24
	WHERE FORMAT='6-24 in length, may contain numbers, periods, or forward slashes'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z],
					[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z]' 
	WHERE FORMAT='2 upper-case letters followed by 5 digits and 2 upper-case letters OR 2 upper-case letters followed by 7 digits OR 7 digits followed by 2 upper-case letters'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='six digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='seven digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='eight digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='seven or eight digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
	SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='nine digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='ten digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='19[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],20[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					20[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],20[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='ten digits only, first two digits must be ''19'' or ''20'''
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='nine or ten digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='eleven digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
						[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='ten or eleven digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='eleven digits only, first digit must be ''0'''
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	WHERE FORMAT='twelve digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='12 or 13 digits allowed'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	WHERE FORMAT='11 or 12 digits allowed'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='thirteen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
						[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='thirteen or seventeen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='fourteen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
						[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
						[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='12-14 digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='fifteen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='sixteen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	WHERE FORMAT='seventeen digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='one upper-case ''C'' followed by ten digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='one upper-case letter followed by eight digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='one upper-case letter followed by nine digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='one upper-case letter followed by nine digits and ending with an upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='one upper-case letter followed by six digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='one upper-case letter or digit followed by thirteen digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='seven digits followed by an upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9]WT,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9]WX,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9]TX,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9]W,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9]T,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9]X'
		WHERE FORMAT='seven digits followed by one or two upper-case letters (if two then the second letter must be W, T, or X)'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='seven digits, may be preceded by a single letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='three upper-case letters followed by 5 digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][A-Z],
					[0-9][0-9][0-9][0-9][0-9][0-9]+[0-9][0-9][0-9][A-Z], 
					[0-9][0-9][0-9][0-9][0-9][0-9]A[0-9][0-9][0-9][A-Z],
					[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9]+[0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9]A[0-9][0-9][0-9][0-9]'
		WHERE FORMAT='six digits followed by a dash ( or ''+'' or ''A''), 3 digits and one upper-case letter or a digit'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][A-Z][0-9][0-9][A-Z][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='six letters followed by two digits, a letter and two digits, a letter and three digits, and a letter (all letters upper-case)'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='three upper-case letters followed by 5 digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='three upper-case letters followed by six digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='two characters followed by eight digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='two characters followed by seven digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='two upper-case letters followed by seven digits only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='two upper-case letters followed by six digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='two letters followed by six digits and one letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='two characters (digits or upper-case letters) followed by seven digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]1'
		WHERE FORMAT='twelve digits, first number must be ''1'''
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]1,
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]2'
		WHERE FORMAT='twelve digits, first number must be ''1'' or ''2'''
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9]-+[0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='six digits followed by a dash ( or ''+'' or ''A''), 3 digits and one upper-case letter or a digit'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='8 or 9 numeric characters with no spaces or symbols'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT]
		SET PATTERN='SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					SG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					OG[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='''SG'' or ''OG'' followed by 7 to 12 digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='one upper-case letter followed by 12 digits and then a final digit or letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z],
					[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][0-9][0-9],
					[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][0-9],
					[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][0-9]'
		WHERE FORMAT='four upper-case letters (or space), followed by 6 digits and ending in 3 alphanumeric characters'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],
					[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],
					[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],
					[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='either a 12-digit number or a string containing one upper-case letter (or number) followed by 7 or 8 digits and ending in one upper-case letter (or number)'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='nine digits followed by an upper-case letter' OR FORMAT='nine digits followed by one upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='nineteen digits followed by a single upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='nine digits followed by an upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='five upper-case letters followed by four digits and a single upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9]'
		WHERE FORMAT='four letters followed by six digits, six letters, and two digits (all letters upper-case)'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='eighteen characters: one upper case letter, eight digits, three upper case letters, six digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z]'
		WHERE FORMAT='eleven characters only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z]'
		WHERE FORMAT='ten characters only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET [Pattern]='%[a-zA-Z0-9]%', [MIN LENGTH]=9, [MAX LENGTH]=10
		WHERE FORMAT='9-10 characters only'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z]'
		WHERE FORMAT='nine characters allowed'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]X,[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='15 digits, 18 digits, or 17 digits followed by ''X'''
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='784[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='''784'', followed by twelve digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='a letter followed by 7 digits and a letter (all letters upper-case)'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],[a-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z],[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='a letter or number followed by 7 digits and an upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='a single upper-case letter followed by six digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='K[0-9][0-9][0-9][0-9][0-9][0-9]'
		WHERE FORMAT='eight digits followed by a single ''K'' or a number'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][0-9][0-9][0-9]'
		WHERE FORMAT='eight digits followed by a single upper-case letter and three additional digits'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='eight digits followed by an upper-case letter'
	UPDATE [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		SET PATTERN='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]'
		WHERE FORMAT='eight digits optionally followed by a single upper-case letter'

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern00 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern01 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern02 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern03 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern04 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern05 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern06 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern07 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern08 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern09 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern10 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern11 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern12 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern13 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern14 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern15 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern16 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern17 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern18 NVARCHAR(500) NULL;
	ALTER TABLE [WAVE_NATIONAL_ID_TYPE_FORMAT] ADD Pattern19 NVARCHAR(500) NULL;
	';

/*
    DECLARE cursor_group CURSOR FOR 
		SELECT DISTINCT @Pattern=LTRIM(RTRIM([PATTERN]))
			FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] 
			WHERE [FORMAT] IS NOT NULL AND [FORMAT] <> 'any characters allowed'

	IF (ISNULL(@Pattern, '') <> '')
	BEGIN
		SET @result = 'NoMatch';

		DECLARE cursor_item CURSOR FOR 
		       SELECT RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(item, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''))) FROM DBO.fnSplitNVARCHAR(@Pattern, ',');
		OPEN cursor_item;
		FETCH NEXT FROM cursor_item INTO @PatternItem;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'Pattern :'+LTRIM(RTRIM(@PatternItem));
			IF (PATINDEX(LTRIM(RTRIM(@PatternItem)), LTRIM(RTRIM(@NATI)))=1)
			BEGIN
				SET @result = 'Matched';
			END

			FETCH NEXT FROM cursor_item INTO @PatternItem;
		END
		CLOSE cursor_item; 
		DEALLOCATE cursor_item;
	END */

  SELECT DISTINCT FORMAT FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] WHERe ISNULL(PATTERN, '') = ''
END
GO

/* If the function('dbo.RemoveNonAlphaNumericCharacters') already exist */
IF OBJECT_ID('dbo.RemoveNonAlphaNumericCharacters') IS NOT NULL
  DROP FUNCTION RemoveNonAlphaNumericCharacters
GO

CREATE FUNCTION [dbo].[RemoveNonAlphaNumericCharacters](@Temp VarChar(1000))
RETURNS VARCHAR(1000)
AS
BEGIN

    DECLARE @KeepValues AS VARCHAR(50)
    SET @KeepValues = '%[^a-zA-Z0-9]%'
    WHILE PATINDEX(@KeepValues, @Temp) > 0
        SET @Temp = STUFF(@Temp, PATINDEX(@KeepValues, @Temp), 1, '')

    RETURN @Temp
END
GO

/* If the function('dbo.RemoveNonNumeric') already exist */
IF OBJECT_ID('dbo.RemoveNonNumeric') IS NOT NULL
  DROP FUNCTION RemoveNonNumeric
GO

CREATE FUNCTION [dbo].[RemoveNonNumeric](@Temp VarChar(1000))
RETURNS VARCHAR(1000)
AS
BEGIN

    DECLARE @KeepValues AS VARCHAR(50)
    SET @KeepValues = '%[^0-9]%'
    WHILE PATINDEX(@KeepValues, @Temp) > 0
        SET @Temp = STUFF(@Temp, PATINDEX(@KeepValues, @Temp), 1, '')

    RETURN @Temp
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_TESTING', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_TESTING;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_TESTING] (
    @NATI               AS NVARCHAR(100),
    @NATIID             AS NVARCHAR(200),
	@CC                 AS NVARCHAR(30),
	@WAVE               AS NVARCHAR(30)
)
AS
BEGIN
    IF (ISNULL(@NATIID, '')<>'')
	BEGIN

		DECLARE @result         AS NVARCHAR(500)='';
		DECLARE @resultitem     AS NVARCHAR(500)='';
		DECLARE @Format         AS NVARCHAR(4000)='';
		DECLARE @Pattern        AS NVARCHAR(4000)='';
		DECLARE @PatternItem    AS NVARCHAR(4000)='';
		DECLARE @CaseSensitive  AS NVARCHAR(400)=''; 
		DECLARE @MinLength      AS INT=0; 
		DECLARE @MaxLength      AS INT=0; 
		DECLARE @PatternWave    AS NVARCHAR(500)=(CASE 
													WHEN @WAVE='W1' THEN 'WAVE 1'
													WHEN @WAVE='W2' THEN 'WAVE 2'
													WHEN @WAVE='W3' THEN 'WAVE 3'
													WHEN @WAVE='W4' THEN 'WAVE 4'
												END);

		SELECT DISTINCT @Format=LTRIM(RTRIM([FORMAT])), @Pattern=LTRIM(RTRIM([PATTERN])), 
						@CaseSensitive=[CASE SENSITIVE], @MinLength=[MIN LENGTH], 
						@MaxLength=[MAX LENGTH]
			FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] 
			WHERE [National ID Type Code]=@NATIID --AND WAVE=@PatternWave AND [Country2 Code] = @CC;

		IF (ISNULL(@Pattern, '') <> '')
		BEGIN
			SET @result = 'NoMatch';

			DECLARE cursor_item CURSOR FOR SELECT RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(item, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''))) FROM DBO.fnSplitNVARCHAR(@Pattern, ',');
			OPEN cursor_item;
			FETCH NEXT FROM cursor_item INTO @PatternItem;
			WHILE @@FETCH_STATUS = 0
			BEGIN
			    PRINT 'Pattern :'+LTRIM(RTRIM(@PatternItem));
				IF (PATINDEX(LTRIM(RTRIM(@PatternItem)), LTRIM(RTRIM(@NATI)))=1)
				BEGIN
					SET @result = 'Matched';
				END

				FETCH NEXT FROM cursor_item INTO @PatternItem;
			END
			CLOSE cursor_item; 
			DEALLOCATE cursor_item;
		END

		IF (@result = 'Matched' OR @result = '' OR @result='any characters allowed') RETURN '';

		PRINT IIF(@Format='any characters allowed','', @Format+' -> '+@NATIID+'( '+@NATI+' )');
	END
END 
GO
--'SG' or 'OG' followed by 7 to 12 digits -> MYS-TN( SG026023866100 )
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_FORMAT_TESTING 'SG026023866100', 'UKR-INT', 'UA', 'W4'
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W3_GOLD' AND [Report Name]='Other ID' ORDER BY [Employee ID]
--SELECt * FROM WAVE_OTHERID_LKUP WHERE COUNTRY_CODE='BEL'
--SELECT AHVNR FROM W4_P2_PA0021 WHERE ISNULL(AHVNR, '')<>''
--SELECT * FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] WHERE [National ID Type Code] IN ('ESP-NIF', 'ESP-DNI')
--SELECT * FROm W4_P2_PA0105 WHERe PERNR like '04%' AND SUBTY='9004'
--SELECT * FROm W4_P2_PA0002 WHERe PERNR like '04%'

/* If the function('dbo.fnSplitIndex') already exist */
IF OBJECT_ID('dbo.fnSplitIndex') IS NOT NULL
  DROP FUNCTION fnSplitIndex
GO
CREATE FUNCTION [dbo].[fnSplitIndex](
    @sInputList NVARCHAR(MAX) -- List of delimited items
  , @sDelimiter NVARCHAR(MAX) = ',' -- delimiter that separates items
) RETURNS @List TABLE (ind int, item NVARCHAR(MAX))

BEGIN
	DECLARE @sItem NVARCHAR(MAX);
	DECLARE @Index INT=1;

	WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
	BEGIN
		SELECT
			@sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
			@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
		IF LEN(@sItem) > 0
		BEGIN
			INSERT INTO @List SELECT @Index, @sItem;
			SET @Index=@Index+1;
		END
	END

	IF LEN(@sInputList) > 0
		INSERT INTO @List SELECT @Index, @sInputList -- Put the last item in

	RETURN
END
GO

/* If the function('dbo.CheckNationalTypeFormat') already exist */
IF OBJECT_ID('dbo.CheckNationalTypeFormat') IS NOT NULL
  DROP FUNCTION CheckNationalTypeFormat
GO
CREATE FUNCTION CheckNationalTypeFormat (
    @NATI               AS NVARCHAR(100),
    @NATIID             AS NVARCHAR(200),
	@CC                 AS NVARCHAR(30),
	@WAVE               AS NVARCHAR(30)
)
RETURNS NVARCHAR(500)  
BEGIN  
    IF (ISNULL(@NATIID, '')='') RETURN '';

    DECLARE @result         AS NVARCHAR(500)='';
	DECLARE @resultitem     AS NVARCHAR(500)='';
	DECLARE @Format         AS NVARCHAR(2000)='';
	DECLARE @Pattern        AS NVARCHAR(2000)='';
	DECLARE @PatternItem    AS NVARCHAR(2000)='';
	DECLARE @CaseSensitive  AS NVARCHAR(2000)=''; 
	DECLARE @MinLength      AS INT=0; 
	DECLARE @MaxLength      AS INT=0; 
	DECLARE @PatternWave    AS NVARCHAR(500)=(CASE 
	                                            WHEN @WAVE='W1' THEN 'WAVE 1'
												WHEN @WAVE='W2' THEN 'WAVE 2'
												WHEN @WAVE='W3' THEN 'WAVE 3'
												WHEN @WAVE='W4' THEN 'WAVE 4'
											END);

	SELECT DISTINCT @Format=LTRIM(RTRIM([FORMAT])), @Pattern=LTRIM(RTRIM([PATTERN])), 
	                @CaseSensitive=[CASE SENSITIVE], @MinLength=[MIN LENGTH], 
					@MaxLength=[MAX LENGTH]
	    FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] 
		WHERE [National ID Type Code]=@NATIID --AND WAVE=@PatternWave AND [Country2 Code] = @CC;
	--SELECT * FROM [WAVE_NATIONAL_ID_TYPE_FORMAT] WHERE [COUNTRY2 CODE]='MY'

	IF (ISNULL(@Pattern, '') <> '')
	BEGIN
	    SET @result = 'NoMatch';

		DECLARE cursor_item CURSOR FOR SELECT RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(item, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''))) FROM DBO.fnSplitIndex(@Pattern, ',');
		OPEN cursor_item;
		FETCH NEXT FROM cursor_item INTO @PatternItem;
		WHILE @@FETCH_STATUS = 0
		BEGIN
            IF (PATINDEX(LTRIM(RTRIM(@PatternItem)), LTRIM(RTRIM(@NATI)))=1)
			BEGIN
				SET @result = 'Matched';
			END

			FETCH NEXT FROM cursor_item INTO @PatternItem;
		END
		CLOSE cursor_item; 
		DEALLOCATE cursor_item;
	END

	IF (@result = 'Matched' OR @result = '' OR @result='any characters allowed') RETURN '';

	RETURN IIF(@Format='any characters allowed','', @Format+' -> '+@NATIID+'( '+@NATI+' )');
END
GO
--PRINT DBO.CheckNationalTypeFormat('SG0087348', 'UKR-INT', 'CZ', 'W4')


/* If the function('dbo.CheckNationalTypeValidate') already exist */
IF OBJECT_ID('dbo.CheckNationalTypeValidate') IS NOT NULL
  DROP FUNCTION CheckNationalTypeValidate
GO
CREATE FUNCTION CheckNationalTypeValidate (
    @NationalIDNATI                  AS NVARCHAR(100),
	@NationalIDTypeNATI              AS NVARCHAR(100),
	@IssuedDateNATI                  AS NVARCHAR(100),
	@ExpirationDateNATI              AS NVARCHAR(100),
	@SeriesNATI                      AS NVARCHAR(100),
	@IssuingAgencyNATI               AS NVARCHAR(100)
)
RETURNS NVARCHAR(500)  
BEGIN  
    DECLARE @result               AS NVARCHAR(500)='';
	DECLARE @IssuedDate           AS NVARCHAR(500)='NA';
	DECLARE @ExpirationDate       AS NVARCHAR(500)='NA';
	DECLARE @Series               AS NVARCHAR(500)='NA';
	DECLARE @IssuingAgency        AS NVARCHAR(500)='NA';  

    SELECT DISTINCT @IssuedDate=[VAL_ISSDATE], @ExpirationDate=[VAL_EXPDATE], @Series=[VAL_SERIES], @IssuingAgency=[VAL_ISSAGY]
	    FROM [WAVE_OTHERID_LKUP] 
		WHERE [WD_VALUE]=@NationalIDTypeNATI;

    IF (@IssuedDate='Yes')
	BEGIN
	   SET @result=IIF(ISNULL(@IssuedDateNATI, '')='', 'Issue Date is required( '+@NationalIDTypeNATI+' );', '');
	END
    IF (@ExpirationDate='Yes')
	BEGIN
	   SET @result=IIF(ISNULL(@ExpirationDateNATI, '')='', 'Expire Date is required( '+@NationalIDTypeNATI+' );', '');
	END
    IF (@Series='Yes')
	BEGIN
	   SET @result=IIF(ISNULL(@SeriesNATI, '')='', 'Series is required( '+@NationalIDTypeNATI+' );', '');
	END
    IF (@IssuingAgency='Yes')
	BEGIN
	   SET @result=IIF(ISNULL(@IssuingAgencyNATI, '')='', 'Issuing Agency is required( '+@NationalIDTypeNATI+' );', '');
	END	

	RETURN @result;
END
GO


/* If the function('dbo.CheckNationalTypeRequired') already exist */
IF OBJECT_ID('dbo.CheckNationalTypeRequired') IS NOT NULL
  DROP FUNCTION CheckNationalTypeRequired
GO
CREATE FUNCTION CheckNationalTypeRequired (
    @NATI1               AS NVARCHAR(100),
	@NATI2               AS NVARCHAR(100),
	@NATI3               AS NVARCHAR(100),
	@NATI4               AS NVARCHAR(100),
	@NATI5               AS NVARCHAR(100),
	@COUNTRY_CODE        AS NVARCHAR(30)
)
RETURNS NVARCHAR(500)  
BEGIN  
    DECLARE @result         AS NVARCHAR(500)='';
	DECLARE @resultitem     AS NVARCHAR(500);
	DECLARE @Item           AS NVARCHAR(500);

	DECLARE cursor_item CURSOR FOR SELECT DISTINCT [WD_VALUE] 
	                                  FROM [WAVE_OTHERID_LKUP] 
									  WHERE [COUNTRY2_CODE]=@COUNTRY_CODE AND [VALIDATE]='Yes';
	OPEN cursor_item;
	FETCH NEXT FROM cursor_item INTO @Item;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @resultitem= (CASE 
		                     WHEN (@NATI1 = @Item) THEN 'NATI1'
							 WHEN (@NATI2 = @Item) THEN 'NATI2'
							 WHEN (@NATI3 = @Item) THEN 'NATI3'
							 WHEN (@NATI4 = @Item) THEN 'NATI4'
							 WHEN (@NATI5 = @Item) THEN 'NATI5'
							 ELSE 'NoMatch'
							END);
		IF (@resultitem='NoMatch')
		BEGIN
            SET @result = @result + @Item+': National ID type required;'
		END

	    FETCH NEXT FROM cursor_item INTO @Item;
	END
	CLOSE cursor_item; 
	DEALLOCATE cursor_item;

	RETURN @result;
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185]
    @Head       NVARCHAR(50),
	@which_date NVARCHAR(50),
	@pass_error NVARCHAR(50)
AS
BEGIN

	DECLARE @PA0185_INFO TABLE(
		[PERNR]            NVARCHAR(50),
		[ICTYP]            NVARCHAR(50),
		[ICNUM]            NVARCHAR(2000),
		[WD_VALUE]         NVARCHAR(2000),
		[ISCOT]            NVARCHAR(50), 
		[FPDAT]            NVARCHAR(50), 
		[EXPID]            NVARCHAR(50), 
		[VERDT]            NVARCHAR(50), 
		[AUTH1]            NVARCHAR(500),
		[DOCN1]            NVARCHAR(500),  
		[SHOW_FLAG]        NVARCHAR(50), 
		[INSERT_POSITION]  INT,
		[SHOW_WD_POSITION] INT,
		[FORMAT_ERROR]     NVARCHAR(2000)
	);
	--[ISCOT], [EXPID]
	--SELECT DISTINCT ICTYP, [AUTH1] FROM WAVE_NM_PA0185
	--SELECT DISTINCT PERNR FROM WAVE_NM_PA0185 WHERE ISCOT IS NULL
	--SELECT DISTINCT NATIO FROM WAVE_OTHERID_LKUP
	--SELECT * FROM WAVE_OTHERID_LKUP WHERE NATIO='Y'
	INSERT INTO @PA0185_INFO
	SELECT * FROM (
		SELECT PERNR, ICTYP, ICNUM, WD_VALUE, [ISCOT], [FPDAT], [EXPID], [VERDT], [AUTH1], [DOCN1], SHOW_FLAG, INSERT_POSITION,
				ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY CAST([INSERT_POSITION] AS INT), [WD_VALUE]) SHOW_WD_POSITION,
				IIF(@Head='NATI', dbo.CheckNationalTypeFormat(ISNULL([ICNUM], ''), ISNULL([WD_VALUE], ''), [Geo - Work Country], 'WAVE'), '') [FORMAT_ERROR]
		FROM (
			SELECT DISTINCT BASE.[emp - personnel number] PERNR, 
						RTRIM(LTRIM([ICNUM])) [ICNUM], 
						[ICTYP], 
						IIF(WD_TEXT='Pasaporte', 
						     ISNULL((SELECT TOP 1 [WD_VALUE] FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE] = ISNULL([ISCOT], '') AND WD_TEXT='Pasaporte'), ''), 
							 ISNULL([WDVALUE185], '')) [WD_VALUE],
						[SHOW_FLAG],
						ISNULL([DISP_SEQ], '0') [INSERT_POSITION],
						ISNULL((SELECT TOP 1 [ISO3] FROM COUNTRY_LKUP WHERE [ISO2] = ISNULL([ISCOT], (SELECT TOP 1 [GEO - WORK COUNTRY] 
																									    FROM [WAVE_NM_POSITION_MANAGEMENT_BASE] 
																										WHERE [Emp - Personnel Number]=IT0185.PERNR))), 'NONE') [ISCOT],
						ISNULL([FPDAT], N'00000000') [FPDAT],
						ISNULL([EXPID], N'00000000') [EXPID],
						ISNULL([VERDT], N'00000000') [VERDT],
						ISNULL([AUTH1], N'NONE') [AUTH1],
						ISNULL([DOCN1], N'NONE') [DOCN1],
						[Geo - Work Country]
			FROM WAVE_NM_PA0185 IT0185 
			    LEFT JOIN [WAVE_NM_POSITION_MANAGEMENT_BASE] BASE ON BASE.[Emp - Personnel Number]=IT0185.PERNR
				LEFT JOIN WAVE_OTHERID_LKUP LKUP ON LKUP.ID_TYPE=IT0185.ICTYP AND LKUP.COUNTRY2_CODE=BASE.[Geo - Work Country]
			WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE) AND 
			      ICNUM IS NOT NULL AND (WD_VALUE <> '' AND WD_VALUE <> 'NONE') AND LKUP.HEAD=@Head) RNK
	) RNK1 
	
	/* Set ICNUM is Migrated */
	UPDATE WAVE_NM_PA0185 SET WDASSIGNED='M'
	   FROM WAVE_NM_PA0185 A1 JOIN @PA0185_INFO A2 ON A1.PERNR=A2.PERNR AND A1.ICNUM=A2.ICNUM AND ISNULL(WDASSIGNED, '')<>'M'

	/* Removing SGP-NRIC if it duplicates with SGP-FIN */
	IF (@Head='NATI')
	BEGIN
	    --SELECT * INTO PA0185_INFO FROM @PA0185_INFO
		--SELECT PERNR, WD_VALUE, ICNUM FROM PA0185_INFO WHERE WD_VALUE='SGP-NRIC'
		--SELECT PERNR, WD_VALUE, ICNUM FROM PA0185_INFO WHERE WD_VALUE='SGP-FIN'
		DELETE FROM @PA0185_INFO WHERE PERNR IN (
			SELECT A1.PERNR FROM (
					(SELECT PERNR, WD_VALUE, ICNUM FROM @PA0185_INFO WHERE WD_VALUE='SGP-NRIC') A1
					  JOIN
					(SELECT PERNR, WD_VALUE, ICNUM FROM @PA0185_INFO WHERE WD_VALUE='SGP-FIN') A2
						ON A1.PERNR=A2.PERNR)
			   WHERE (A1.ICNUM=A2.ICNUM OR A1.ICNUM=('NI'+A2.ICNUM)) AND (SUBSTRING(A1.ICNUM, 1, 3)='NIG' OR SUBSTRING(A1.ICNUM, 1, 3)='NIF' OR SUBSTRING(A1.ICNUM, 1, 1)='G' OR SUBSTRING(A1.ICNUM, 1, 1)='F')
		) AND WD_VALUE='SGP-NRIC'
	END

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_INFO;';
	SELECT * INTO PA0185_INFO FROM @PA0185_INFO WHERE (@pass_error='Yes' OR [FORMAT_ERROR] ='')

	DECLARE @WORKERONALID_TRANSPOSED TABLE (
	   [PERNR]                               NVARCHAR(200),
	   [ISCOT1]                              NVARCHAR(200),
	   [ID1]                                 NVARCHAR(200),
	   [ID_Type1]                            NVARCHAR(200),
	   [ID_Type_ID1]                         NVARCHAR(200),
	   [Issued_Date1]                        NVARCHAR(200),
	   [Expiration_Date1]                    NVARCHAR(200),
	   [Verification_Date1]                  NVARCHAR(200),
	   [Series1]                             NVARCHAR(200),
	   [Issuing_Agency1]                     NVARCHAR(200),

	   [ISCOT2]                              NVARCHAR(200),
	   [ID2]                                 NVARCHAR(200),
	   [ID_Type2]                            NVARCHAR(200),
	   [ID_Type_ID2]                         NVARCHAR(200),
	   [Issued_Date2]                        NVARCHAR(200),
	   [Expiration_Date2]                    NVARCHAR(200),
	   [Verification_Date2]                  NVARCHAR(200),
	   [Series2]                             NVARCHAR(200),
	   [Issuing_Agency2]                     NVARCHAR(200),

	   [ISCOT3]                              NVARCHAR(200),
	   [ID3]                                 NVARCHAR(200),
	   [ID_Type3]                            NVARCHAR(200),
	   [ID_Type_ID3]                         NVARCHAR(200),
	   [Issued_Date3]                        NVARCHAR(200),
	   [Expiration_Date3]                    NVARCHAR(200),
	   [Verification_Date3]                  NVARCHAR(200),
	   [Series3]                             NVARCHAR(200),
	   [Issuing_Agency3]                     NVARCHAR(200),

	   [ISCOT4]                              NVARCHAR(200),
	   [ID4]                                 NVARCHAR(200),
	   [ID_Type4]                            NVARCHAR(200),
	   [ID_Type_ID4]                         NVARCHAR(200),
	   [Issued_Date4]                        NVARCHAR(200),
	   [Expiration_Date4]                    NVARCHAR(200),
	   [Verification_Date4]                  NVARCHAR(200),
	   [Series4]                             NVARCHAR(200),
	   [Issuing_Agency4]                     NVARCHAR(200),

	   [ISCOT5]                              NVARCHAR(200),
	   [ID5]                                 NVARCHAR(200),
	   [ID_Type5]                            NVARCHAR(200),
	   [ID_Type_ID5]                         NVARCHAR(200),
	   [Issued_Date5]                        NVARCHAR(200),
	   [Expiration_Date5]                    NVARCHAR(200),
	   [Verification_Date5]                  NVARCHAR(200),
	   [Series5]                             NVARCHAR(200),
	   [Issuing_Agency5]                     NVARCHAR(200)
	)

    ;WITH CTE_Rank AS
	(
		SELECT 
	         [PERNR]
			,[ISCOT]
	        ,[ICNUM] 
			,'' [WD_TYPE]
	        ,[WD_VALUE]
	        ,[FPDAT]
	        ,[EXPID] 
	        ,[VERDT] 
			,[DOCN1]
	        ,[AUTH1]
			,sISCOT='ISCOT' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sID='ID' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sID_Type='ID_Type' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sID_Type_ID='ID_Type_ID' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sIssued_Date='Issued_Date' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sExpiration_Date='Expiration_Date' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sVerification_Date='Verification_Date' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sSeries='Series' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
			,sIssuing_Agency='Issuing_Agency' + CAST(SHOW_WD_POSITION AS VARCHAR(200))
		FROM PA0185_INFO
	)
	INSERT INTO @WORKERONALID_TRANSPOSED
	SELECT PERNR

	      ,[ISCOT1] = MAX(ISNULL(ISCOT1, ''))
		  ,[ID1] = MAX(ISNULL(ID1, ''))
		  ,[ID_Type1] = MAX(ISNULL(ID_Type1, ''))
		  ,[ID_Type_ID1] = MAX(ISNULL(ID_Type_ID1, ''))
		  ,[Issued_Date1] = IIF(MAX(ISNULL(Issued_Date1, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Issued_Date1, '')) AS DATE)))
		  ,[Expiration_Date1] = IIF(MAX(ISNULL(Expiration_Date1, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Expiration_Date1, '')) AS DATE)))
		  ,[Verification_Date1] = IIF(MAX(ISNULL(Verification_Date1, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Verification_Date1, '')) AS DATE)))
		  ,[Series1] = IIF(MAX(ISNULL(Series1, ''))='NONE', '', MAX(ISNULL(Series1, '')))
		  ,[Issuing_Agency1] = IIF(MAX(ISNULL(Issuing_Agency1, ''))='NONE', '', MAX(ISNULL(Issuing_Agency1, '')))

		  ,[ISCOT2] = MAX(ISNULL(ISCOT2, ''))
		  ,[ID2] = MAX(ISNULL(ID2, ''))
		  ,[ID_Type2] = MAX(ISNULL(ID_Type2, ''))
		  ,[ID_Type_ID2] = MAX(ISNULL(ID_Type_ID2, ''))
		  ,[Issued_Date2] = IIF(MAX(ISNULL(Issued_Date2, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Issued_Date2, '')) AS DATE)))
		  ,[Expiration_Date2] = IIF(MAX(ISNULL(Expiration_Date2, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Expiration_Date2, '')) AS DATE)))
		  ,[Verification_Date2] = IIF(MAX(ISNULL(Verification_Date2, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Verification_Date2, '')) AS DATE)))
		  ,[Series2] = IIF(MAX(ISNULL(Series2, ''))='NONE', '', MAX(ISNULL(Series2, '')))
		  ,[Issuing_Agency2] = IIF(MAX(ISNULL(Issuing_Agency2, ''))='NONE', '', MAX(ISNULL(Issuing_Agency2, '')))

		  ,[ISCOT3] = MAX(ISNULL(ISCOT3, ''))
		  ,[ID3] = MAX(ISNULL(ID3, ''))
		  ,[ID_Type3] = MAX(ISNULL(ID_Type3, ''))
		  ,[ID_Type_ID3] = MAX(ISNULL(ID_Type_ID3, ''))
		  ,[Issued_Date3] = IIF(MAX(ISNULL(Issued_Date3, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Issued_Date3, '')) AS DATE)))
		  ,[Expiration_Date3] = IIF(MAX(ISNULL(Expiration_Date3, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Expiration_Date3, '')) AS DATE)))
		  ,[Verification_Date3] = IIF(MAX(ISNULL(Verification_Date3, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Verification_Date3, '')) AS DATE)))
		  ,[Series3] = IIF(MAX(ISNULL(Series3, ''))='NONE', '', MAX(ISNULL(Series3, '')))
		  ,[Issuing_Agency3] = IIF(MAX(ISNULL(Issuing_Agency3, ''))='NONE', '', MAX(ISNULL(Issuing_Agency3, '')))

		  ,[ISCOT4] = MAX(ISNULL(ISCOT4, ''))
		  ,[ID4] = MAX(ISNULL(ID4, ''))
		  ,[ID_Type4] = MAX(ISNULL(ID_Type4, ''))
		  ,[ID_Type_ID4] = MAX(ISNULL(ID_Type_ID4, ''))
		  ,[Issued_Date4] = IIF(MAX(ISNULL(Issued_Date4, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Issued_Date4, '')) AS DATE)))
		  ,[Expiration_Date4] = IIF(MAX(ISNULL(Expiration_Date4, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Expiration_Date4, '')) AS DATE)))
		  ,[Verification_Date4] = IIF(MAX(ISNULL(Verification_Date4, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Verification_Date4, '')) AS DATE)))
		  ,[Series4] = IIF(MAX(ISNULL(Series4, ''))='NONE', '', MAX(ISNULL(Series4, '')))
		  ,[Issuing_Agency4] = IIF(MAX(ISNULL(Issuing_Agency4, ''))='NONE', '', MAX(ISNULL(Issuing_Agency4, '')))

		  ,[ISCOT5] = MAX(ISNULL(ISCOT5, ''))
		  ,[ID5] = MAX(ISNULL(ID5, ''))
		  ,[ID_Type5] = MAX(ISNULL(ID_Type5, ''))
		  ,[ID_Type_ID5] = MAX(ISNULL(ID_Type_ID5, ''))
		  ,[Issued_Date5] = IIF(MAX(ISNULL(Issued_Date5, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Issued_Date5, '')) AS DATE)))
		  ,[Expiration_Date5] = IIF(MAX(ISNULL(Expiration_Date5, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Expiration_Date5, '')) AS DATE)))
		  ,[Verification_Date5] = IIF(MAX(ISNULL(Verification_Date5, '00000000'))='00000000', '', CONVERT(VARCHAR(20), CAST(MAX(ISNULL(Verification_Date5, '')) AS DATE)))
		  ,[Series5] = IIF(MAX(ISNULL(Series5, ''))='NONE', '', MAX(ISNULL(Series5, '')))
		  ,[Issuing_Agency5] = IIF(MAX(ISNULL(Issuing_Agency5, ''))='NONE', '', MAX(ISNULL(Issuing_Agency5, '')))

	FROM CTE_Rank AS R
		PIVOT(MAX(ISCOT) FOR sISCOT IN (
		       [ISCOT1], [ISCOT2], [ISCOT3], [ISCOT4], [ISCOT5])
		   ) ISCOT
		PIVOT(MAX(ICNUM) FOR sID IN (
		       [ID1], [ID2], [ID3], [ID4], [ID5])
		   ) ICNUM
		PIVOT(MAX([WD_VALUE]) FOR sID_Type IN (
		       [ID_Type1], [ID_Type2], [ID_Type3], [ID_Type4], [ID_Type5])
		   ) WD_TYPE
		PIVOT(MAX([WD_TYPE]) FOR sID_Type_ID IN (
		       [ID_Type_ID1], [ID_Type_ID2], [ID_Type_ID3], [ID_Type_ID4], [ID_Type_ID5])
		   ) WD_VALUE
		PIVOT(MAX([FPDAT]) FOR sIssued_Date IN (
		       [Issued_Date1], [Issued_Date2], [Issued_Date3], [Issued_Date4], [Issued_Date5])
		   ) FPDAT
		PIVOT(MAX([EXPID]) FOR sExpiration_Date IN (
		       [Expiration_Date1], [Expiration_Date2], [Expiration_Date3], [Expiration_Date4], [Expiration_Date5])
		   ) EXPID
		PIVOT(MAX([VERDT]) FOR sVerification_Date IN (
		       [Verification_Date1], [Verification_Date2], [Verification_Date3], [Verification_Date4], [Verification_Date5])
		   ) VERDT
		PIVOT(MAX([DOCN1]) FOR sSeries IN (
		       [Series1], [Series2], [Series3], [Series4], [Series5])
		   ) DOCN1
		PIVOT(MAX([AUTH1]) FOR sIssuing_Agency IN (
		       [Issuing_Agency1], [Issuing_Agency2], [Issuing_Agency3], [Issuing_Agency4], [Issuing_Agency5])
		   ) AUTH1
    GROUP BY PERNR

	IF (@Head='NATI')
	BEGIN		
		SELECT * INTO PA0185_NATI_INFO FROM @WORKERONALID_TRANSPOSED
		DECLARE @NATI_FORMAT_ERROR_TRANSPOSED TABLE (
			  PERNR             NVARCHAR(255),

			  NATI_FE_1         NVARCHAR(255),
			  NATI_FE_2         NVARCHAR(255),
			  NATI_FE_3         NVARCHAR(255),
			  NATI_FE_4         NVARCHAR(255),
			  NATI_FE_5         NVARCHAR(255)
		)

		;WITH CTE_Rank AS
		(
		SELECT [PERNR]
			  ,[FORMAT_ERROR]
			  ,sNATI_FE='NATI_FE_' + CAST(RANK_ID AS VARCHAR(200))
		FROM (SELECT [PERNR], [FORMAT_ERROR], ROW_NUMBER() OVER(PARTITION BY PERNR ORDER BY PERNR) RANK_ID FROM @PA0185_INFO) A1 WHERE FORMAT_ERROR<>''
		)
		INSERT INTO @NATI_FORMAT_ERROR_TRANSPOSED
		SELECT PERNR

			  ,NATI_FE_1 = MAX(ISNULL(NATI_FE_1, ''))
			  ,NATI_FE_2 = MAX(ISNULL(NATI_FE_2, ''))
			  ,NATI_FE_3 = MAX(ISNULL(NATI_FE_3, ''))
			  ,NATI_FE_4 = MAX(ISNULL(NATI_FE_4, ''))
			  ,NATI_FE_5 = MAX(ISNULL(NATI_FE_5, ''))
		FROM CTE_Rank AS R
			  PIVOT(MAX(FORMAT_ERROR) FOR sNATI_FE IN ([NATI_FE_1], [NATI_FE_2], [NATI_FE_3], [NATI_FE_4], [NATI_FE_5])) [FORMAT_ERROR]
		GROUP BY PERNR

		SELECT * INTO PA0185_NATI_ERROR FROM @NATI_FORMAT_ERROR_TRANSPOSED;
	END
	IF (@Head='GOVT')
	BEGIN		
		SELECT * INTO PA0185_GOVT_INFO FROM @WORKERONALID_TRANSPOSED
	END
	IF (@Head='LICE')
	BEGIN		
		SELECT * INTO PA0185_LICE_INFO FROM @WORKERONALID_TRANSPOSED
	END
	IF (@Head='VISA')
	BEGIN		
		SELECT * INTO PA0185_VISA_INFO FROM @WORKERONALID_TRANSPOSED
	END
END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185 'NATI', '2020-10-11'

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_ERROR_REPORT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_ERROR_REPORT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_ERROR_REPORT]
    @which_wavestage    AS NVARCHAR(50),
	@which_report       AS NVARCHAR(500),
	@which_date         AS NVARCHAR(50)
AS
BEGIN
	/********* Validation ***********/
	PRINT 'VALIDATION'
	PRINT GETDATE()

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION;';
	SELECT DISTINCT 
	        Wave                 [Build Number] 
	       ,[Report Name]        [Report Name]
		   ,[Employee ID]        [Employee ID]
		   ,[Country]            [Country Name]
		   ,[ISO3]               [Country ISO3 Code]
		   ,[WD_EMP_TYPE]        [Employee Type]
		   ,[Emp - Group]        [Employee Group]
		   ,[Error Type]         [Error Type]
		   ,[ErrorText]          [Error Text]
	   INTO NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION 
	FROM (
		SELECT @which_wavestage Wave 
		      ,@which_report [Report Name]
			  ,[Employee ID]
			  ,ISNULL(A3.iso3, '') ISO3
			  ,ISNULL(A3.[Country], '') Country
			  ,a2.[WD_EMP_TYPE]
			  ,a2.[Emp - Group]
			  ,'National ID' [Error Type]
			  ,(
				IIF(([National ID NATI1] <> '' AND [National ID Type NATI1] = '') OR ([National ID NATI1] = '' AND [National ID Type NATI1] <> ''), 'National ID 1 required values are missing;', '') + 
				IIF(([National ID NATI2] <> '' AND [National ID Type NATI2] = '') OR ([National ID NATI2] = '' AND [National ID Type NATI2] <> ''), 'National ID 2 required values are missing;', '') + 
				IIF(([National ID NATI3] <> '' AND [National ID Type NATI3] = '') OR ([National ID NATI3] = '' AND [National ID Type NATI3] <> ''), 'National ID 3 required values are missing;', '') + 
				IIF(([National ID NATI4] <> '' AND [National ID Type NATI4] = '') OR ([National ID NATI4] = '' AND [National ID Type NATI4] <> ''), 'National ID 4 required values are missing;', '') + 
				IIF(([National ID NATI5] <> '' AND [National ID Type NATI5] = '') OR ([National ID NATI5] = '' AND [National ID Type NATI5] <> ''), 'National ID 5 required values are missing;', '') + 

				dbo.CheckNationalTypeRequired(ISNULL([National ID Type NATI1], ''), ISNULL([National ID Type NATI2], ''), 
				                              ISNULL([National ID Type NATI3], ''), ISNULL([National ID Type NATI4], ''), 
											  ISNULL([National ID Type NATI5], ''), a2.[Geo - Country (CC)]) +

			    dbo.CheckNationalTypeValidate([National ID NATI1], [National ID Type NATI1], [Issued_Date NATI1], [Expiration_Date NATI1], [Series NATI1], [Issuing_Agency NATI1])+
				dbo.CheckNationalTypeValidate([National ID NATI2], [National ID Type NATI2], [Issued_Date NATI2], [Expiration_Date NATI2], [Series NATI2], [Issuing_Agency NATI2])+
				dbo.CheckNationalTypeValidate([National ID NATI3], [National ID Type NATI3], [Issued_Date NATI3], [Expiration_Date NATI3], [Series NATI3], [Issuing_Agency NATI3])+
				dbo.CheckNationalTypeValidate([National ID NATI4], [National ID Type NATI4], [Issued_Date NATI4], [Expiration_Date NATI4], [Series NATI4], [Issuing_Agency NATI4])+
				dbo.CheckNationalTypeValidate([National ID NATI5], [National ID Type NATI5], [Issued_Date NATI5], [Expiration_Date NATI5], [Series NATI5], [Issuing_Agency NATI5])+

				IIF(ISNULL(NATI_FE_1, '')='', '', NATI_FE_1)+
				IIF(ISNULL(NATI_FE_2, '')='', '', NATI_FE_2)+
				IIF(ISNULL(NATI_FE_3, '')='', '', NATI_FE_3)+
				IIF(ISNULL(NATI_FE_4, '')='', '', NATI_FE_4)+
				IIF(ISNULL(NATI_FE_5, '')='', '', NATI_FE_5)
        ) ErrorText
		FROM WD_HR_TR_AUTOMATED_OTHERID a1
		  LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE a2 ON a1.[Personnel Number]=a2.[Emp - Personnel Number] 
		  LEFT JOIN COUNTRY_LKUP a3 ON a2.[Geo - Work Country]=a3.[ISO2]
		  LEFT JOIN PA0185_NATI_ERROR a4 ON a1.[Personnel Number]=a4.[PERNR]
	    UNION ALL
		SELECT @which_wavestage Wave 
		      ,@which_report [Report Name]
			  ,[Employee ID]
			  ,ISNULL(A3.iso3, '') ISO3
			  ,ISNULL(A3.[Country], '') Country
			  ,a2.[WD_EMP_TYPE]
			  ,a2.[Emp - Group]
			  ,'Goverment ID' [Error Type]
			  ,(
				IIF(([Government ID GOVT1] <> '' AND [Government ID Type GOVT1] = '') OR ([Government ID GOVT1] = '' AND [Government ID Type GOVT1] <> ''), 'Government ID 1 required values are missing;', '') + 
				IIF(([Government ID GOVT2] <> '' AND [Government ID Type GOVT2] = '') OR ([Government ID GOVT2] = '' AND [Government ID Type GOVT2] <> ''), 'Government ID 2 required values are missing;', '')
               ) ErrorText
		FROM WD_HR_TR_AUTOMATED_OTHERID a1
		  LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE a2 ON a1.[Personnel Number]=a2.[Emp - Personnel Number] 
		  LEFT JOIN COUNTRY_LKUP a3 ON a2.[Geo - Work Country]=a3.[ISO2]
	    UNION ALL
		SELECT @which_wavestage Wave 
		      ,@which_report [Report Name]
			  ,[Employee ID]
			  ,ISNULL(A3.iso3, '') ISO3
			  ,ISNULL(A3.[Country], '') Country
			  ,a2.[WD_EMP_TYPE]
			  ,a2.[Emp - Group]
			  ,'Visa ID' [Error Type]
			  ,(
			    IIF(([Visa ID VISA1] <> '' AND [Visa Type VISA1] = '') OR ([Visa ID VISA1] = '' AND [Visa Type VISA1] <> ''), 'VISA 1 required values are missing;', '') +
				IIF(([Visa ID VISA2] <> '' AND [Visa Type VISA2] = '') OR ([Visa ID VISA2] = '' AND [Visa Type VISA2] <> ''), 'VISA 2 required values are missing;', '') +
				IIF(([Visa ID VISA3] <> '' AND [Visa Type VISA3] = '') OR ([Visa ID VISA3] = '' AND [Visa Type VISA3] <> ''), 'VISA 3 required values are missing;', '')
               ) ErrorText
		FROM WD_HR_TR_AUTOMATED_OTHERID a1
		  LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE a2 ON a1.[Personnel Number]=a2.[Emp - Personnel Number] 
		  LEFT JOIN COUNTRY_LKUP a3 ON a2.[Geo - Work Country]=a3.[ISO2]
	    UNION ALL
		SELECT @which_wavestage Wave 
		      ,@which_report [Report Name]
			  ,[Employee ID]
			  ,ISNULL(A3.iso3, '') ISO3
			  ,ISNULL(A3.[Country], '') Country
			  ,a2.[WD_EMP_TYPE]
			  ,a2.[Emp - Group]
			  ,'License ID' [Error Type]
			  ,(
			   IIF(([License ID LICENSE1] <> '' AND [License Type LICENSE1] = '') OR ([License ID LICENSE1] = '' AND [License Type LICENSE1] <> ''), 'License ID required values are missing;', '')
               ) ErrorText
		FROM WD_HR_TR_AUTOMATED_OTHERID a1
		  LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE a2 ON a1.[Personnel Number]=a2.[Emp - Personnel Number] 
		  LEFT JOIN COUNTRY_LKUP a3 ON a2.[Geo - Work Country]=a3.[ISO2]
	) A1
	WHERE ErrorText <> ''
	PRINT GETDATE();

	/*
    -- Removing Ref IDs from DGW, If it is not in format
	DECLARE @REMOVE_WD_REF_ID_FROM_DGW TABLE (
	    PERNR                       NVARCHAR(200),
		NATI1                       NVARCHAR(200),
		NATI2                       NVARCHAR(200),
		NATI3                       NVARCHAR(200),
		NATI4                       NVARCHAR(200),
		NATI5                       NVARCHAR(200)
    );

	INSERT INTO @REMOVE_WD_REF_ID_FROM_DGW
	SELECT 
	     [Applicant_ID]
		,IIF(dbo.CheckNationalTypeFormat(ISNULL([National ID NATI1], ''), ISNULL([National ID Type NATI1], ''), 
											a2.[Geo - Work Country], SUBSTRING(@which_wavestage, 1, 2))='', 'No', 'Yes') NATI1
		,IIF(dbo.CheckNationalTypeFormat(ISNULL([National ID NATI2], ''), ISNULL([National ID Type NATI2], ''), 
											a2.[Geo - Work Country], SUBSTRING(@which_wavestage, 1, 2))='', 'No', 'Yes') NATI2
		,IIF(dbo.CheckNationalTypeFormat(ISNULL([National ID NATI3], ''), ISNULL([National ID Type NATI3], ''), 
											a2.[Geo - Work Country], SUBSTRING(@which_wavestage, 1, 2))='', 'No', 'Yes') NATI3
		,IIF(dbo.CheckNationalTypeFormat(ISNULL([National ID NATI4], ''), ISNULL([National ID Type NATI4], ''), 
											a2.[Geo - Work Country], SUBSTRING(@which_wavestage, 1, 2))='', 'No', 'Yes') NATI4
		,IIF(dbo.CheckNationalTypeFormat(ISNULL([National ID NATI5], ''), ISNULL([National ID Type NATI5], ''), 
											a2.[Geo - Work Country], SUBSTRING(@which_wavestage, 1, 2))='', 'No', 'Yes') NATI5
	FROM WD_HR_TR_AUTOMATED_OTHERID a1
		  LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE a2 ON a1.[Applicant_ID]=a2.[Emp - Personnel Number]

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists OTHERID_REMOVE_WD_REF_ID_FROM_DGW;';
	SELECT * INTO OTHERID_REMOVE_WD_REF_ID_FROM_DGW FROM @REMOVE_WD_REF_ID_FROM_DGW
    PRINT GETDATE()

    UPDATE A1 SET
	    [National ID NATI1]=IIF(A2.NATI1='Yes', '', A1.[National ID NATI1])
	   ,[National ID Type NATI1]=IIF(A2.NATI1='Yes', '', A1.[National ID Type NATI1])
	   ,[National ID Type ID NATI1]=IIF(A2.NATI1='Yes', '', A1.[National ID Type ID NATI1])
	   ,[Issued_Date NATI1]=IIF(A2.NATI1='Yes', '', A1.[Issued_Date NATI1])
	   ,[Expiration_Date NATI1]=IIF(A2.NATI1='Yes', '', A1.[Expiration_Date NATI1])
	   ,[Verification_Date NATI1]=IIF(A2.NATI1='Yes', '', A1.[Verification_Date NATI1])
	   ,[Series NATI1]=IIF(A2.NATI1='Yes', '', A1.[Series NATI1])
	   ,[Issuing_Agency NATI1]=IIF(A2.NATI1='Yes', '', A1.[Issuing_Agency NATI1])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 JOIN OTHERID_REMOVE_WD_REF_ID_FROM_DGW A2 ON A1.[Applicant_ID]=A2.[PERNR]
	PRINT GETDATE()

    UPDATE A1 SET
	    [National ID NATI2]=IIF(A2.NATI2='Yes', '', A1.[National ID NATI2])
	   ,[National ID Type NATI2]=IIF(A2.NATI2='Yes', '', A1.[National ID Type NATI2])
	   ,[National ID Type ID NATI2]=IIF(A2.NATI2='Yes', '', A1.[National ID Type ID NATI2])
	   ,[Issued_Date NATI2]=IIF(A2.NATI2='Yes', '', A1.[Issued_Date NATI2])
	   ,[Expiration_Date NATI2]=IIF(A2.NATI2='Yes', '', A1.[Expiration_Date NATI2])
	   ,[Verification_Date NATI2]=IIF(A2.NATI2='Yes', '', A1.[Verification_Date NATI2])
	   ,[Series NATI2]=IIF(A2.NATI2='Yes', '', A1.[Series NATI2])
	   ,[Issuing_Agency NATI2]=IIF(A2.NATI2='Yes', '', A1.[Issuing_Agency NATI2])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 JOIN OTHERID_REMOVE_WD_REF_ID_FROM_DGW A2 ON A1.[Applicant_ID]=A2.[PERNR]
	PRINT GETDATE()

    UPDATE A1 SET
	    [National ID NATI3]=IIF(A2.NATI3='Yes', '', A1.[National ID NATI3])
	   ,[National ID Type NATI3]=IIF(A2.NATI3='Yes', '', A1.[National ID Type NATI3])
	   ,[National ID Type ID NATI3]=IIF(A2.NATI3='Yes', '', A1.[National ID Type ID NATI3])
	   ,[Issued_Date NATI3]=IIF(A2.NATI3='Yes', '', A1.[Issued_Date NATI3])
	   ,[Expiration_Date NATI3]=IIF(A2.NATI3='Yes', '', A1.[Expiration_Date NATI3])
	   ,[Verification_Date NATI3]=IIF(A2.NATI3='Yes', '', A1.[Verification_Date NATI3])
	   ,[Series NATI3]=IIF(A2.NATI3='Yes', '', A1.[Series NATI3])
	   ,[Issuing_Agency NATI3]=IIF(A2.NATI3='Yes', '', A1.[Issuing_Agency NATI3])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 JOIN OTHERID_REMOVE_WD_REF_ID_FROM_DGW A2 ON A1.[Applicant_ID]=A2.[PERNR]

    UPDATE A1 SET
	    [National ID NATI4]=IIF(A2.NATI4='Yes', '', A1.[National ID NATI4])
	   ,[National ID Type NATI4]=IIF(A2.NATI4='Yes', '', A1.[National ID Type NATI4])
	   ,[National ID Type ID NATI4]=IIF(A2.NATI4='Yes', '', A1.[National ID Type ID NATI4])
	   ,[Issued_Date NATI4]=IIF(A2.NATI4='Yes', '', A1.[Issued_Date NATI4])
	   ,[Expiration_Date NATI4]=IIF(A2.NATI4='Yes', '', A1.[Expiration_Date NATI4])
	   ,[Verification_Date NATI4]=IIF(A2.NATI4='Yes', '', A1.[Verification_Date NATI4])
	   ,[Series NATI4]=IIF(A2.NATI4='Yes', '', A1.[Series NATI4])
	   ,[Issuing_Agency NATI4]=IIF(A2.NATI4='Yes', '', A1.[Issuing_Agency NATI4])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 JOIN OTHERID_REMOVE_WD_REF_ID_FROM_DGW A2 ON A1.[Applicant_ID]=A2.[PERNR]
	PRINT GETDATE()

	/**********Hide Values***********/
	UPDATE A1 SET 
			 [Issued_Date NATI1]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date NATI1])
			,[Expiration_Date NATI1]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date NATI1])
			,[Series NATI1]=IIF(VAL_SERIES='Hidden', '', [Series NATI1])
			,[Issuing_Agency NATI1]=IIF(VAL_ISSAGY='Hidden', '', [Issuing_Agency NATI1])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [National ID Type NATI1]=WD_VALUE

	UPDATE A1 SET 
			 [Issued_Date NATI2]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date NATI2])
			,[Expiration_Date NATI2]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date NATI2])
			,[Series NATI2]=IIF(VAL_SERIES='Hidden', '', [Series NATI2])
			,[Issuing_Agency NATI2]=IIF(VAL_ISSAGY='Hidden', '', [Issuing_Agency NATI2])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [National ID Type NATI2]=WD_VALUE

	UPDATE A1 SET 
			 [Issued_Date NATI3]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date NATI3])
			,[Expiration_Date NATI3]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date NATI3])
			,[Series NATI3]=IIF(VAL_SERIES='Hidden', '', [Series NATI3])
			,[Issuing_Agency NATI3]=IIF(VAL_ISSAGY='Hidden', '', [Issuing_Agency NATI3])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [National ID Type NATI3]=WD_VALUE

	UPDATE A1 SET 
			 [Issued_Date NATI4]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date NATI4])
			,[Expiration_Date NATI4]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date NATI4])
			,[Series NATI4]=IIF(VAL_SERIES='Hidden', '', [Series NATI4])
			,[Issuing_Agency NATI4]=IIF(VAL_ISSAGY='Hidden', '', [Issuing_Agency NATI4])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [National ID Type NATI4]=WD_VALUE

	UPDATE A1 SET 
			 [Issued_Date NATI5]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date NATI5])
			,[Expiration_Date NATI5]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date NATI5]) 
			,[Series NATI5]=IIF(VAL_SERIES='Hidden', '', [Series NATI5])
			,[Issuing_Agency NATI5]=IIF(VAL_ISSAGY='Hidden', '', [Issuing_Agency NATI5])
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [National ID Type NATI5]=WD_VALUE

	UPDATE A1 SET 
			 [Country_ISO Code GOVT1]=IIF(VAL_COUNTRYCODE='Hidden', '', [Country_ISO Code GOVT1]) 
			,[Issued_Date GOVT1]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date GOVT1])
			,[Expiration_Date GOVT1]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date GOVT1]) 
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [Government ID Type GOVT1]=WD_VALUE

	UPDATE A1 SET 
			 [Country_ISO Code GOVT2]=IIF(VAL_COUNTRYCODE='Hidden', '', [Country_ISO Code GOVT2]) 
			,[Issued_Date GOVT2]=IIF(VAL_ISSDATE='Hidden', '', [Issued_Date GOVT2])
			,[Expiration_Date GOVT2]=IIF(VAL_EXPDATE='Hidden', '', [Expiration_Date GOVT2]) 
	FROM WD_HR_TR_AUTOMATED_OTHERID A1 
	     LEFT JOIN (SELECT DISTINCT WD_VALUE, VAL_COUNTRYCODE, VAL_ISSDATE, VAL_EXPDATE, VAL_SERIES, VAL_ISSAGY FROM WAVE_OTHERID_LKUP) A2 
		     ON [Government ID Type GOVT2]=WD_VALUE

    PRINT GETDATE() 
	*/
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_HR_AND_WD_COUNTS', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_HR_AND_WD_COUNTS;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_HR_AND_WD_COUNTS]
      @which_date         AS NVARCHAR(50)
AS
BEGIN
	PRINT 'ID type count with respct to country';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WD_HR_TR_AUTOMATED_OTHERID_COUNT';
	PRINT 'Drop table, If exists: WD_HR_TR_AUTOMATED_OTHERID_COUNT';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED';
	PRINT 'Drop table, If exists: WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED';

	DECLARE @IDTypeCount TABLE(
	   [COUNTRY]          NVARCHAR(200),
	   [COUNTRY2_CODE]    NVARCHAR(200), 
	   [HEAD]             NVARCHAR(200),
	   [HR_CORE_ID]       NVARCHAR(50),
	   [SUB TYPE]         NVARCHAR(500),
	   [ID_TYPE]          NVARCHAR(500),
	   [ID_TYPE_NAME]     NVARCHAR(500),
	   [INFO_TYPE]        NVARCHAR(500),
	   [HR_COUNT]         INT,
	   [ID_TYPE_COUNT]    INT,
	   [WD_TEXT]	      NVARCHAR(500),
	   [WD_VALUE_SHOW]	  NVARCHAR(500)
	);

	INSERT INTO @IDTypeCount
	SELECT MAX([COUNTRY]), MAX(COUNTRY2_CODE), MAX(HEAD), MAX(HR_CORE_ID), ID_TYPE, WD_VALUE, MAX(HR_CORE_NAME), INFO_TYPE, '0', MAX(WD_VALUE_COUNT), MAX(WD_TEXT), MAX(WD_VALUE_SHOW) FROM
	(SELECT COUNTRY_NAME+'( '+COUNTRY_CODE+' )' COUNTRY
	      ,COUNTRY2_CODE
	      ,(CASE 
		       WHEN HEAD = 'NATI' THEN 'National ID'
			   WHEN HEAD = 'GOVT' THEN 'Goverment ID'

			   WHEN HEAD = 'LICE' THEN 'Driving License'
			   WHEN HEAD = 'VISA' THEN 'Visa'
			   ELSE ''
			END) HEAD
		  ,HR_CORE_ID 
		  ,ID_TYPE
	      ,WD_VALUE
	      ,HR_CORE_NAME
		  ,A3.INFO_TYPE INFO_TYPE
		  ,(ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [National ID Type NATI1] = A3.WD_VALUE), 0) +
		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [National ID Type NATI2] = A3.WD_VALUE), 0) +  
		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [National ID Type NATI3] = A3.WD_VALUE), 0) +  
		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [National ID Type NATI4] = A3.WD_VALUE), 0) +  
		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [National ID Type NATI5] = A3.WD_VALUE), 0) +  

		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Government ID Type GOVT1] = A3.WD_VALUE), 0) +  
		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Government ID Type GOVT2] = A3.WD_VALUE), 0) +  

 		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Visa Type VISA1] = A3.WD_VALUE), 0) +  
			ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Visa Type VISA2] = A3.WD_VALUE), 0) +  
			ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Visa Type VISA3] = A3.WD_VALUE), 0) +  

		    ISNULL((SELECT COUNT(*) FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [License Type LICENSE1] = A3.WD_VALUE), 0)) WD_VALUE_COUNT
		   ,ISNULL(WD_TEXT , '') WD_TEXT
		   ,ISNULL(WD_VALUE_SHOW, '') [WD_VALUE_SHOW]
	FROM (SELECT DISTINCT HEAD, COUNTRY_NAME, COUNTRY_CODE, HR_CORE_NAME, ISNULL(WD_VALUE, '') [WD_VALUE_SHOW], IIF(WD_VALUE='', ID_TYPE+'_'+COUNTRY2_CODE, WD_VALUE) WD_VALUE, INFO_TYPE, ID_TYPE, HR_CORE_ID, COUNTRY2_CODE, WD_TEXT 
	         FROM WAVE_OTHERID_LKUP WHERE ISNULL(WD_VALUE, '')<>'') A3 JOIN [COUNTRY_LKUP] A4 ON A3.COUNTRY2_CODE = A4.[ISO2]
    ) b
	GROUP BY WD_VALUE, INFO_TYPE, ID_TYPE;
	PRINT GETDATE()

	UPDATE A3
	    SET [HR_COUNT]=ISNULL((SELECT COUNT(*) FROM 
		                        (SELECT DISTINCT A1.PERNR, A1.ICTYP, A2.[GEO - WORK COUNTRY] CC
								    FROM (SELECT DISTINCT * 
									          FROM WAVE_NM_PA0185 WHERE BEGDA <= CAST(@which_date AS DATE) AND ENDDA >= CAST(@which_date AS DATE) AND 
											  ICTYP IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP b WHERE b.WD_VALUE<>'' AND b.WD_VALUE=A3.ID_TYPE AND b.ID_TYPE=A3.[SUB TYPE] AND b.[COUNTRY2_CODE]=A3.[COUNTRY2_CODE] )) A1 
										 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
									WHERE A2.[GEO - WORK COUNTRY]=[COUNTRY2_CODE])
								 a), '0') 
    FROM @IDTypeCount A3
	PRINT GETDATE()

	PRINT 'PA036';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0036' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0036' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				LEFT JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE()

	PRINT 'PA0290';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0290' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0290' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				LEFT JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE()

	PRINT 'PA048';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0048' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0048' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				LEFT JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE()

	PRINT 'PA105';
	--SELECT * FROM WAVE_NM_PA0185 WHERE WCOUNC='SP'
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,IIF(([ICTYP]='9003' OR [ICTYP]='9004' OR [ICTYP]='9005'), '9004', [ICTYP])  HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0105' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0105' AND ICTYP IN ('9003', '9004', '9005', '9006')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.ICTYP, A1.INFO_TYPE) A3 
			  JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE();

	PRINT 'PA185';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0185' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0185' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE()

	PRINT 'PA149';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0149' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0149' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA465';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0185' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0465' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5
	PRINT GETDATE()


	PRINT 'PA012';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0012' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0012' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA013';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0013' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0013' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA0061';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0061' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0061' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA0108';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0108' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0108' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA0558';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,[ICTYP] HR_CORE_ID
			 ,[ICTYP] SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0558' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0558' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	PRINT 'PA539';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,'' HR_CORE_ID
			 ,'' SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0539' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT
			 ,'' WD_TEXT 
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0539' AND
										      ICTYP IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE) A3 
				JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5


	PRINT 'PA0002';
	INSERT INTO @IDTypeCount 
	   SELECT A5.COUNTRY+'( '+A5.[Country Code]+' )' COUNTRY
			 ,'' COUNTRY2_CODE
			 ,'' HEAD
			 ,'' HR_CORE_ID
			 ,'' SUB_TYPE
			 ,'' ID_TYPE
			 ,'' ID_TYPE_NAME
			 ,'PA0002' INFO_TYPE
			 ,CAST(HR_COUNT AS INT) [HR CORE COUNT]
             ,'0' WD_VALUE_COUNT 
			 ,'' WD_TEXT
			 ,'' WD_VALUE_SHOW 
	    FROM (SELECT DISTINCT * FROM (SELECT DISTINCT A2.[GEO - WORK COUNTRY] CC, ICTYP, COUNT(*) HR_COUNT
								FROM (SELECT * FROM WAVE_NM_PA0185 
								        WHERE CAST(BEGDA AS DATE) <= CAST(@which_date AS DATE) AND CAST(ENDDA AS DATE) >= CAST(@which_date AS DATE) AND
										      INFO_TYPE='PA0002' AND
										      ICTYP NOT IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERE [COUNTRY2_CODE]=[WCOUNC] AND ISNULL(WD_VALUE, '')<>'')) A1 
					                  JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[EMP - PERSONNEL NUMBER]
					            WHERE A1.PERNR IS NOT NULL AND A2.[EMP - PERSONNEL NUMBER] IS NOT NULL
					            GROUP BY A2.[GEO - WORK COUNTRY], A1.INFO_TYPE, A1.ICTYP) A3 
			 JOIN [WAVE_ADDRESS_VALIDATION] A4 ON A3.CC = A4.[Country2 Code]) A5

	/********* WD Value Count ***********/
	PRINT GETDATE();

	SELECT * INTO WD_HR_TR_AUTOMATED_OTHERID_COUNT FROM (
	SELECT *, ROW_NUMBER() 
	        OVER(PARTITION BY [INFO TYPE], [COUNTRY], [SUB TYPE] 
			     ORDER BY [INFO TYPE], [COUNTRY], [SUB TYPE], [WD VALUE] DESC) AS [ROW NUMBER] FROM (
		SELECT DISTINCT 
			[COUNTRY]
		   ,[HEAD] [ID TYPE]
		   ,ISNULL([HR_CORE_ID], '') [HR CORE ID]
		   ,[ID_TYPE_NAME] [USAGE] 
		   ,'' [HR CORE TEXT] 
		   ,ISNULL([WD_VALUE_SHOW], '') [WD VALUE] 
		   ,ISNULL([WD_TEXT], '') [WD TEXT]
		   ,[INFO_TYPE] [INFO TYPE]
		   ,[HR_COUNT] [HR CORE COUNT]
		   ,[ID_TYPE_COUNT] [DGW COUNT]
		   ,[SUB TYPE]
		 FROM @IDTypeCount 
		 WHERE ISNULL([COUNTRY], '') <> '') a
	 ) b WHERE [ROW NUMBER] = 1
	 ORDER BY [INFO TYPE], [WD VALUE]
	 --SELECT * FROM P0_T042ZT
	 --SELECT * FROM P0_T591S
	 UPDATE WD_HR_TR_AUTOMATED_OTHERID_COUNT SET [INFO TYPE]='Flat File' WHERE [HR CORE ID] ='' AND [INFO TYPE]='PA0185'

	/********* WD Value Count ***********/
	PRINT GETDATE()

	SELECT DISTINCT ISNULL(A2.Country, '') COUNTRY, 
	                ISNULL(A2.[ISO3], '') ISO3, 
					ISNULL(A4.NOT_COUNTED, '') NOT_COUNTED, 
					ISNULL(A3.COUNTED, '') COUNTED,
					ISNULL(A5.TOTAL_COUNT, '') TOTAL_COUNT
		INTO WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED
		FROM 
		    (
				SELECT DISTINCT [Geo - Work Country]
					FROM WAVE_NM_POSITION_MANAGEMENT_BASE 
					WHERE [Emp - Group] NOT IN ('7', '9')
			) A1 
			LEFT JOIN COUNTRY_LKUP A2 ON A1.[Geo - Work Country]=A2.[ISO2] 
			LEFT JOIN 
			(
				    SELECT WCOUNC, COUNT(*) COUNTED
		            FROM WAVE_NM_PA0185 
		            WHERE ISNULL(WDASSIGNED,'')='M' AND EMPGROUP NOT IN ('7', '9')
                    GROUP BY WCOUNC
			) A3 ON A1.[Geo - Work Country]=A3.WCOUNC
			LEFT JOIN 
			(
				    SELECT WCOUNC, COUNT(*) NOT_COUNTED
		            FROM WAVE_NM_PA0185 
		            WHERE ISNULL(WDASSIGNED,'')<>'M' AND EMPGROUP NOT IN ('7', '9')
                    GROUP BY WCOUNC
			) A4 ON A1.[Geo - Work Country]=A4.WCOUNC
			LEFT JOIN 
			(
				    SELECT WCOUNC, COUNT(*) TOTAL_COUNT
		            FROM WAVE_NM_PA0185 
		            WHERE EMPGROUP NOT IN ('7', '9')
                    GROUP BY WCOUNC
			) A5 ON A1.[Geo - Work Country]=A5.WCOUNC
		WHERE ISNULL(A2.ISO3, '') <> ''

    PRINT GETDATE()
END
GO
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_HR_AND_WD_COUNTS '2021-03-10'

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID_NEW', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID_NEW;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_NEW]
    @which_wavestage    AS NVARCHAR(50),
	@which_report       AS NVARCHAR(500),
	@which_date         AS NVARCHAR(50),
	@PrefixCopy         AS NVARCHAR(50),
	@Correction         AS NVARCHAR(50),
	@ErrorFlag          AS NVARCHAR(50)
AS
BEGIN
    PRINT GETDATE()
    EXEC PROC_WAVE_NM_AUTOMATE_OTHERID @which_wavestage, @which_report, @which_date, @PrefixCopy, '', @Correction, 'Other ID Associates', @ErrorFlag
	PRINT GETDATE()
END
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_OTHERID', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_OTHERID;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID]
    @which_wavestage    AS NVARCHAR(50),
	@which_report       AS NVARCHAR(500),
	@which_date         AS NVARCHAR(50),
	@PrefixCheck        AS NVARCHAR(50),
	@PrefixCopy         AS NVARCHAR(50),
	@Correction         AS NVARCHAR(50), 
	@OtherIdFlag        AS NVARCHAR(50),
	@ErrorFlag          AS NVARCHAR(50)
AS
BEGIN

BEGIN TRY 
    --EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'P0', 'Other ID', '2021-03-10', 'P0_', 'P0', 'Yes'
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID ORDER BY [Employee ID]
	--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_ERROR_REPORT 'P0', 'Other ID', '2021-03-10'
	--SELECT * FROM NOVARTIS_DATA_MIGRATION_OTHERID_VALIDATION ORDER BY [Build Number], [Report Name], [Employee ID]
	--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_HR_AND_WD_COUNTS '2021-03-10'
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID ORDER BY [Employee ID]
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_DELTA ORDER BY [Employee ID]
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' AND (ISNULL([HR CORE COUNT], '0') <> '0' OR [DGW COUNT] <> '0') ORDER BY [INFO TYPE], [COUNTRY], [SUB TYPE], [ID TYPE]
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED ORDER BY [COUNTRY]
	--SELECT * FROM [NOVARTIS_DATA_MIGRATION_ERROR_LIST] WHERE Wave='P0' AND [Report]='Other ID' ORDER BY [Employee ID]
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Employee ID]='40914565'
	--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' AND RTRIM(LTRIM([WD VALUE]))='MEX-CURP' ORDER BY [INFO TYPE], [COUNTRY], [SUB TYPE], [ID TYPE]
	--SELECT * FROM WAVE_OTHERID_LKUP WHERE WD_VALUE='MEX-CURP'
	--SELECT * FROM WAVE_OTHERID_LKUP WHERE COUNTRY_CODE='MEX' ORDER BY INFO_TYPE
    PRINT @which_wavestage;
	PRINT @which_report;
	PRINT @which_date;
	PRINT @PrefixCheck;
	PRINT @PrefixCopy;
	PRINT @Correction;
	PRINT @OtherIdFlag;

	/* Required Info type table */
	DECLARE @SQL AS NVARCHAR(4000)='drop table if exists WAVE_NM_PA0002;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0002 FROM '+@which_wavestage+'_PA0002;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0002', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0012;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0012 FROM '+@which_wavestage+'_PA0012';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0012', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table WAVE_NM_PA0013;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0013 FROM '+@which_wavestage+'_PA0013';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0013', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0105;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0105 FROM '+@which_wavestage+'_PA0105;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0105', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0036;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0036 FROM '+@which_wavestage+'_PA0036;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0036', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0290;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0290 FROM '+@which_wavestage+'_PA0290;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0290', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0108;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0108 FROM '+@which_wavestage+'_PA0108;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0108', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0185;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0185 FROM '+@which_wavestage+'_PA0185;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0185', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0422;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0422 FROM '+@which_wavestage+'_PA0422;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0422', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0465;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0465 FROM '+@which_wavestage+'_PA0465;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0465', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0539;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0539 FROM '+@which_wavestage+'_PA0539;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0539', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0558;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0558 FROM '+@which_wavestage+'_PA0558;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0558', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0048;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0048 FROM '+@which_wavestage+'_PA0048;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0048', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0061;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0061 FROM '+@which_wavestage+'_PA0061;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0061', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_PA0149;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_PA0149 FROM '+@which_wavestage+'_PA0149;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_CHECK_TABLE_IN_DB 'PA0149', @PrefixCheck, @PrefixCopy

	SET @SQL='drop table if exists WAVE_NM_OPL;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT * INTO WAVE_NM_OPL FROM P0_YOMXX_OPLMAPPING;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	--EXEC PROC_CHECK_TABLE_IN_DB 'OPL', @PrefixCheck, @PrefixCopy
	
	PRINT 'Position Management Base';
	PRINT @OtherIdFlag;
	IF (@OtherIdFlag='Other ID Associates')
	BEGIN
		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		--SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
		--			 FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
		--					   FROM '+@which_wavestage+'_POSITION_MANAGEMENT) a
		--		  WHERE a.RNK>=1'
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE FROM '+@which_wavestage+'_POSITION_MANAGEMENT';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
        --SELECT Top 10 * FROM P0_POSITION_MANAGEMENT
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [Org - OpLevel 3] NVARCHAR(255);
												 alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [Org - OpLevel 2] NVARCHAR(255); 
												 alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [Org - OpLevel 1] NVARCHAR(255);
												 alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [Org - Funct Dep Code] NVARCHAR(255);
												 alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [CB - Payroll ref No.] NVARCHAR(255);
												 alter table WAVE_NM_POSITION_MANAGEMENT_BASE add [Emp-Prev PrsNo Legcy] NVARCHAR(255);'

	END
	IF (@OtherIdFlag='Other ID Associates Emp Group 4')
	BEGIN
		SET @SQL='drop table if exists WAVE_NM_POSITION_MANAGEMENT_BASE;';
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
		SET @SQL='SELECT * INTO WAVE_NM_POSITION_MANAGEMENT_BASE
					 FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSNO_NEW ORDER BY [emp - group], [emp - personnel number]) RNK    
							   FROM '+@which_wavestage+'_POSITION_MANAGEMENT WHERE [emp - group] IN (''3'', ''4'')) a
				  WHERE a.RNK=2'
		PRINT @SQL;
		--SELECT [Emp - Personnel Number], [PERSNO_NEW], [Emp - Group] FROM W3_GOLD_POSITION_MANAGEMENT WHERE [Emp - Group] in ('3', '4') ORDER BY PERSNO_NEW, [Emp - Group]
		EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	END

	/* Correction to PA0185 */
	PRINT 'Populating all Info type data';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_PA0185 add SHOW_FLAG NVARCHAR(255);
	                                         alter table WAVE_NM_PA0185 add INFO_TYPE NVARCHAR(255); 
	                                         alter table WAVE_NM_PA0185 add NATIO NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add EDATE NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add VERDT NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add WCOUNC NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add EMPGROUP NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add WDVALUE185 NVARCHAR(255);
											 alter table WAVE_NM_PA0185 add WDASSIGNED NVARCHAR(255);'
	UPDATE WAVE_NM_PA0185 SET [SHOW_FLAG]='N', [INFO_TYPE]='PA0185';


	 PRINT 'COUNC';
	 /* Sets Work Country if WCOUNC is null */
     UPDATE A2 SET 
	   WCOUNC=A1.[GEO - WORK COUNTRY]
	   FROM WAVE_NM_PA0185 A2 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A1 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		         A2.PERNR IS NOT NULL

    PRINT 'PA0036'; 
	--SELECT * FROM W4_P2_PA0036
	DECLARE @CHE_AVS TABLE (
		ID VARCHAR(50)
	)

	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [NAHVN], '361', '361', null, [BEGDA], [ENDDA], 'Y', 'PA0036' 
	      FROM WAVE_NM_PA0036 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date)
	   UNION ALL  
	   SELECT '200', [PERNR], [AHVNR], '361', '361', null, [BEGDA], [ENDDA], 'Y', 'PA0036' 
	      FROM WAVE_NM_PA0036 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date)  AND [PERNR] NOT IN (SELECT ID FROM @CHE_AVS)

    PRINT 'PA0061'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [NATSS], '300', '300', null, [BEGDA], [ENDDA], 'Y', 'PA0061' 
	      FROM WAVE_NM_PA0061 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date)

    PRINT 'PA0149'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [REFNO], 'TRN', 'TRN', null, [BEGDA], [ENDDA], 'Y', 'PA0149' 
	      FROM WAVE_NM_PA0149 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date)

	--SELECT * FROM WAVE_NM_PA0185 WHERE ICTYP='21' AND INFO_TYPE='PA0290'
	--SELECT DISTINCT [FPDAT] FROM WAVE_NM_PA0185 WHERE ICTYP='21' AND INFO_TYPE='PA0290' ORDER BY FPDAT
	--SELECT DISTINCT [EXPID] FROM WAVE_NM_PA0185 WHERE ICTYP='21' AND INFO_TYPE='PA0290' ORDER BY EXPID
	--SELECT DISTINCT [FPDAT] FROM WAVE_NM_PA0185 WHERE (FPDAT IS NULL OR FPDAT='0' OR FPDAT='00000' OR FPDAT='000000')
	--SELECT DISTINCT [EXPID] FROM WAVE_NM_PA0185 WHERE ([EXPID] IS NULL OR [EXPID]='0' OR [EXPID]='00000' OR [EXPID]='000000')
	--SELECT * FROM WAVE_NM_PA0185 WHERE ICTYP='802'
    PRINT 'PA0290'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [FPDAT], [EXPID], [AUTH1], [DOCN1], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [NOMER], '801', '801', null, [BEGDA], [ENDDA], [DATBG], [DATEN], [PASSL], [SERIA], 'Y', 'PA0290' 
	      FROM WAVE_NM_PA0290 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND SUBTY='801'
	   UNION ALL 
	   SELECT '200', [PERNR], [NOMER], '802', '802', null, [BEGDA], [ENDDA], [DATBG], [DATEN], [PASSL], [SERIA], 'Y', 'PA0290' 
	      FROM WAVE_NM_PA0290 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND SUBTY='802' 
	   UNION ALL 
	   SELECT '200', [PERNR], [NOMER], '21', '21', null, [BEGDA], [ENDDA], [DATBG], [DATEN], [PASSL], [SERIA], 'Y', 'PA0290' 
	      FROM WAVE_NM_PA0290 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND SUBTY='21' 
	   UNION ALL 
	   SELECT '200', [PERNR], [NOMER], 'RP', 'RP', null, [BEGDA], [ENDDA], [DATBG], [DATEN], [PASSL], [SERIA], 'Y', 'PA0290' 
	      FROM WAVE_NM_PA0290 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND SUBTY='RP'  
	   UNION ALL 
	   SELECT '200', [PERNR], [NOMER], '10', '10', null, [BEGDA], [ENDDA], [DATBG], [DATEN], [PASSL], [SERIA], 'Y', 'PA0290' 
	      FROM WAVE_NM_PA0290 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND SUBTY='10'  
	   

    PRINT 'PA0108 Missing'; 
	--INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	--   SELECT '200', [PERNR], [BEIDN], '400', '400', null, [BEGDA], [ENDDA], 'Y', 'PA0108' 
	--      FROM WAVE_NM_PA0108 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
	--	  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) 

    PRINT 'PA0558'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [PESEL], '558', '558', null, [BEGDA], [ENDDA], 'Y', 'PA0558' 
	      FROM WAVE_NM_PA0558 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) 

    PRINT 'PA0539'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [REGNO], '104', '104', null, [BEGDA], [ENDDA], 'Y', 'PA0539' 
	      FROM WAVE_NM_PA0539 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) 

	PRINT 'PA0422'; 
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [SSSNO], '99', '99', null, [BEGDA], [ENDDA], 'Y', 'PA0422'
	       FROM WAVE_NM_PA0422 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]                         /* PH SSSNO corrections */
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) 

	PRINT 'PA0465';
	--SELECT DISTINCT SUBTY FROM WAVE_NM_PA0465 WHERE INFO_TYPE='PA0465'
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [CPF_NR], '01', '01', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [CPF_NR] IS NOT NULL AND SUBTY='0001'
		UNION ALL
	   SELECT '200', [PERNR], [IDENT_NR], '02', '02', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [IDENT_NR] IS NOT NULL AND SUBTY='0002'
		UNION ALL
	   SELECT '200', [PERNR], [CTPS_NR], '03', '03', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [CTPS_NR] IS NOT NULL AND SUBTY='0003'
		UNION ALL
	   SELECT '200', [PERNR], [CREG_NR], '04', '04', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [CREG_NR] IS NOT NULL AND SUBTY='0004'
		UNION ALL
	   SELECT '200', [PERNR], [ELEC_NR], '05', '05', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [ELEC_NR] IS NOT NULL AND SUBTY='0005'
		UNION ALL
	   SELECT '200', [PERNR], [PIS_NR], '06', '06', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [PIS_NR] IS NOT NULL AND SUBTY='0006'
		UNION ALL
	   SELECT '200', [PERNR], [MIL_NR], '07', '07', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [MIL_NR] IS NOT NULL AND SUBTY='0007'
		UNION ALL
	   SELECT '200', [PERNR], [IDFOR_NR], '08', '08', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [IDFOR_NR] IS NOT NULL AND SUBTY='0008'
		UNION ALL
	   SELECT '200', [PERNR], [VISA_NR], '09', '09', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [VISA_NR] IS NOT NULL AND SUBTY='0009'
		UNION ALL
	   SELECT '200', [PERNR], [DRIVE_NR], '10', '10', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [DRIVE_NR] IS NOT NULL AND SUBTY='0010'
		UNION ALL
	   SELECT '200', [PERNR], [PASSP_NR], '11', '11', null, [BEGDA], [ENDDA], 'Y', 'PA0465' 
	      FROM WAVE_NM_PA0465 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [PASSP_NR] IS NOT NULL AND SUBTY='0011'


    PRINT 'PA0105'; 
	--SELECT * FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [geo - work country]='CA';
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   SELECT '200', [PERNR], [USRID_LONG], [SUBTY], [SUBTY], null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	      FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND 
		        A2.[Geo - Work Country] <> 'JP' AND A2.[Geo - Work Country] <> 'BE' AND A2.[Geo - Work Country] <> 'HU'
	   UNION ALL
	   SELECT '200', [PERNR], [USRID], [SUBTY], [SUBTY], null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	      FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [SUBTY]='9004' AND [USRID] IS NOT NULL AND 
		        A2.[Geo - Work Country] <> 'JP' AND A2.[Geo - Work Country] <> 'BE' AND A2.[Geo - Work Country] <> 'HU' AND A2.[Geo - Work Country] <> 'EG'
	   UNION ALL
	   SELECT '200', [PERNR], [USRID], [SUBTY], [SUBTY], null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	    FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [SUBTY]='9004' AND [USRID] IS NOT NULL AND 
		        A2.[Geo - Work Country] = 'BE'
	   UNION ALL
	   SELECT '200', [PERNR], [USRID_LONG], [SUBTY], [SUBTY], null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	      FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND 
		        A2.[Geo - Work Country] = 'BE'
	   UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID], 1, 2) IN ('NI'), SUBSTRING([USRID], 3, LEN([USRID])), [USRID]) ICNUM, 
									  IIF(SUBSTRING([USRID], 1, 2) IN ('NI'), SUBSTRING([USRID], 1, 2), '9004') ICTTY, 
									  IIF(SUBSTRING([USRID], 1, 2) IN ('NI'), SUBSTRING([USRID], 1, 2), '9004') SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9004' AND [USRID] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID], 1, 2) IN ('NI')
		   ) A1
	   ) A2 WHERE ROWNUM = 1
       UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID], 1, 2) IN ('TX'), SUBSTRING([USRID], 3, LEN([USRID])), [USRID]) ICNUM, 
									  'TX' ICTTY, 'TX' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9004' AND [USRID] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID], 1, 2) IN ('TX')
		   ) A1
	   ) A2 WHERE ROWNUM = 1
       UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID], 1, 2) IN ('SI'), SUBSTRING([USRID], 3, LEN([USRID])), [USRID]) ICNUM, 
									  'SI' ICTTY, 'SI' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9004' AND [USRID] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID], 1, 2) IN ('SI')
		   ) A1
	   ) A2 WHERE ROWNUM = 1
	   UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID_LONG], 1, 3) IN ('FC-'), SUBSTRING([USRID_LONG], 4, LEN([USRID_LONG])), [USRID_LONG]) ICNUM, 
									  'FC' ICTTY, 'FC' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID_LONG], 1, 3) IN ('FC-')
		   ) A1
	   ) A2 WHERE ROWNUM >= 1
	   UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID_LONG], 1, 3) IN ('SVO'), [USRID_LONG], '') ICNUM, 
									  'SVO' ICTTY, 'SVO' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID_LONG], 1, 3) IN ('SVO')
		   ) A1
	   ) A2 WHERE ROWNUM >= 1
	   UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID_LONG], 1, 3) IN ('SRO'), [USRID_LONG], '') ICNUM, 
									  'SRO' ICTTY, 'SRO' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID_LONG], 1, 3) IN ('SRO')
		   ) A1
	   ) A2 WHERE ROWNUM >= 1
	   UNION ALL
	   SELECT MANDT,PERNR, ICNUM, ICTTY, SUBTY, ISCOT, @which_date BEGDA, @which_date ENDDA, FLAG, INFO_TYPE FROM (
		   SELECT *, ROW_NUMBER() OVER(PARTITION BY PERNR, SUBTY ORDER BY BEGDA DESC) ROWNUM FROM (
			   SELECT '200' MANDT, [PERNR], IIF(SUBSTRING([USRID_LONG], 1, 3) IN ('SSO'), [USRID_LONG], '') ICNUM, 
									  'SSO' ICTTY, 'SSO' SUBTY, null ISCOT, [BEGDA], [ENDDA], 'Y' FLAG, 'PA0105' INFO_TYPE 
				  FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
				  WHERE [SUBTY]='9006' AND [USRID_LONG] IS NOT NULL AND A2.[Geo - Work Country] = 'HU' AND SUBSTRING([USRID_LONG], 1, 3) IN ('SSO')
		   ) A1
	   ) A2 WHERE ROWNUM >= 1
	   UNION ALL
	   SELECT '200', [PERNR], dbo.RemoveNonNumeric([USRID]), 
	                          '9004', '9004', null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	      FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND [SUBTY]='9004' AND [USRID] IS NOT NULL AND 
		        A2.[Geo - Work Country] = 'EG'
	   UNION ALL 
	   --SELECT * FROM WAVE_NM_PA0185 WHERE PERNR='80003440'
	   --fourteen digits only -> EGY-NID( IN27206090104038 )
	   SELECT '200', [PERNR], IIF(SUBSTRING([USRID], 1, 2)='PP', SUBSTRING([USRID], 2, LEN([USRID])), [USRID]), (CASE
	                                     WHEN SUBSTRING([USRID], 1, 2)='PP' THEN '9004'
										 WHEN SUBSTRING([USRID], 1, 2)='RC' THEN '9005'
										 WHEN SUBSTRING([USRID], 1, 2)='DL' THEN '9003'
										 ELSE [SUBTY] END), 
										 (CASE
	                                     WHEN SUBSTRING([USRID], 1, 2) NOT IN ('PP', 'RC', 'DL') THEN '9004'
										 WHEN SUBSTRING([USRID], 1, 2)='RC' THEN '9005'
										 WHEN SUBSTRING([USRID], 1, 2)='DL' THEN '9003'
										 ELSE [SUBTY] END), null, [BEGDA], [ENDDA], 'Y', 'PA0105' 
	      FROM WAVE_NM_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
		  WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date)  AND [SUBTY]='9004' AND (SUBSTRING(ISNULL([USRID], ''), 1, 2) NOT IN ('PP', 'RC', 'DL') OR 
		                                                                                                           SUBSTRING(ISNULL([USRID], ''), 1, 2) = 'RC' OR 
																												   SUBSTRING(ISNULL([USRID], ''), 1, 2) = 'DL') AND 
			    A2.[Geo - Work Country]='JP' AND [USRID] IS NOT NULL
	--SELECT * FROM WAVE_NM_PA0185 WHERE PERNR like '21%' AND ICTYP='9004'

	--SELECT * FROM WAVE_NM_PA0048 WHERE PASSN IS NOT NULL
	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [EXPID], [FPDAT], [AUTH1], [SHOW_FLAG], [INFO_TYPE])
		SELECT DISTINCT '200', A2.PERNR, A2.BEWNR, A2.SUBTY, A2.SUBTY, NULL AS ISCOT, [BEGDA], [ENDDA], [ABLAD], [AUSGD], [AUSBE], 'Y', 'PA0048'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0048 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL --AND
				 --A2.SUBTY IN (SELECT ID_TYPE FROM WAVE_OTHERID_LKUP WHERe [COUNTRY2_CODE]=A1.[GEO - WORK COUNTRY])
		--UNION ALL
		--SELECT DISTINCT '200', A2.PERNR, A2.PASSN, '101', '101', NULL AS ISCOT, [BEGDA], [ENDDA], [ABLAD], [AUSGD], [AUSBE], 'Y', 'PA0048'
		--   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0048 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		--   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND
		--		 A2.PASSN IS NOT NULL

	INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '204', '204', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='CZ'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '200', '200', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='DK'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '205', '205', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='FI'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '203', '203', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='FR'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '201', '201', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='IT'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '206', '206', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='NO'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '207', '207', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='RO'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '208', '208', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='SK'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '209', '209', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='ZA'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '210', '210', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='ES'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '1102', '1102', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='MX'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '1103', '1103', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='US'
        UNION ALL
		SELECT DISTINCT '200', A2.PERNR, A2.PERID, '1104', '1104', NULL AS ISCOT, [BEGDA], [ENDDA], 'Y', 'PA0002'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0002 A2 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.PERNR IS NOT NULL AND A1.[GEO - WORK COUNTRY]='CA'
			 
     PRINT 'DELETE RECORDS'
     DELETE FROM WAVE_NM_PA0185 WHERe [ICTYP]='9004' AND [INFO_TYPE]='PA0105' AND
	           PERNR IN (SELECT PERNR FROM WAVE_NM_PA0185 WHERE [ICTYP] IN ('01', '02') AND [INFO_TYPE]='PA0185' AND  WCOUNC='SG')
     DELETE FROM WAVE_NM_PA0185 WHERe [ICTYP]='9004' AND [INFO_TYPE]='PA0105' AND
	           PERNR IN (SELECT PERNR FROM WAVE_NM_PA0185 WHERE [ICTYP] IN ('01') AND [INFO_TYPE]='PA0185' AND  WCOUNC='MY')

    /* Singapore Employement Pass (Duplication) */
    INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [EXPID], [FPDAT], [AUTH1], [SHOW_FLAG], [INFO_TYPE]) 
		SELECT DISTINCT '200', A2.[PERNR], A2.[ICNUM], 'EP', 'EP', 'SG' AS ISCOT, CAST(@which_date as date), CAST(@which_date as date), 
		                [EXPID], [FPDAT], [AUTH1], 'Y', 'SGP_COR'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0185 A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.[PERNR] IS NOT NULL AND A2.[ICTYP] IN ('P1')

    /* Singapore Work Permit (Duplication) */
    INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [EXPID], [FPDAT], [AUTH1], [SHOW_FLAG], [INFO_TYPE]) 
		SELECT DISTINCT '200', A2.[PERNR], A2.[ICNUM], 'EP', 'EP', 'SG' AS ISCOT, CAST(@which_date as date), CAST(@which_date as date), 
		                [EXPID], [FPDAT], [AUTH1], 'Y', 'SGP_COR'
		   FROM WAVE_NM_POSITION_MANAGEMENT_BASE A1 LEFT JOIN WAVE_NM_PA0185 A2 ON A1.[Emp - Personnel Number]=A2.[PERNR]
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND A2.[PERNR] IS NOT NULL AND A2.[ICTYP] IN ('WP')

	/* Germany Correction */
	--SELECT * FROM W4_GOLD_PA0012
    PRINT 'DE_IT12 is missinng'; 
	--INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	  -- SELECT '200', A1.[Emp - Personnel Number], [Identification Number], '401', '401', null, CAST(@which_date as date), CAST(@which_date as date), 'Y', 'PA0012' 
	     -- FROM WAVE_NM_PA0012 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[Emp - Personnel Number]=A2.[Emp - Personnel Number]
	      --FROM WAVE_NM_DE_OtherID_CORRRECTION A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]

    PRINT 'DE_IT13 is missing'; 
	--SELECT * FROM W4_CATCHUP_PA0013
	--Drop TABLE WAVE_NM_PA0013
	--INSERT INTO WAVE_NM_PA0185 ([MANDT], [PERNR], [ICNUM], [ICTYP], [SUBTY], [ISCOT], [BEGDA], [ENDDA], [SHOW_FLAG], [INFO_TYPE])
	   --SELECT '200', A1.[Emp - Personnel Number], [Pension Insurance Number], '402', '402', null, CAST(@which_date as date), CAST(@which_date as date), 'Y', 'PA0013' 
	     -- FROM WAVE_NM_PA0013 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[Emp - Personnel Number]=A2.[Emp - Personnel Number]
	      --FROM WAVE_NM_DE_IT13 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERSNR=A2.[Emp - Personnel Number]

	 /* Sets Work Country if ISCOT is null */
     UPDATE A2 SET 
	   ISCOT=A1.[GEO - WORK COUNTRY]
	   FROM WAVE_NM_PA0185 A2 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A1 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		         A2.PERNR IS NOT NULL --AND A2.ISCOT IS NULL

	 /* Sets Work Country if WCOUNC is null */
     UPDATE A2 SET 
	    WCOUNC=A1.[GEO - WORK COUNTRY]
	   ,WDASSIGNED='N'
	   ,EMPGROUP=A1.[Emp - Group]
	   FROM WAVE_NM_PA0185 A2 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A1 ON A1.[Emp - Personnel Number]=A2.PERNR
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		         A2.PERNR IS NOT NULL

	 /* Sets Work Country if WCOUNC is null */
     UPDATE A2 SET 
	    WDVALUE185=A1.WD_VALUE
	   FROM WAVE_NM_PA0185 A2 LEFT JOIN WAVE_OTHERID_LKUP A1 ON A2.WCOUNC=A1.COUNTRY2_CODE AND A2.ICTYP=A1.ID_TYPE
		   WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		         A2.PERNR IS NOT NULL
     
	 /* Delete if ICNUM is null */
	 PRINT 'Deletes ICNUM is null';
	 DELETE FROM WAVE_NM_PA0185 WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		                              ISNULL(PERNR, '') <> '' AND ISNULL(ICNUM, '') = ''

     /* Remove Duplication Rows*/
	 PRINT 'Duplication Rows';
	 WITH cte AS (
		SELECT *, ROW_NUMBER() OVER(PARTITION BY [PERNR], [WDVALUE185], [SUBTY] ORDER BY [PERNR], [WDVALUE185] , [SUBTY], [ICNUM] DESC) AS [ROW NUMBER] 
			FROM WAVE_NM_PA0185 WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND ISNULL([WDVALUE185], '') <> '' 
	)
	DELETE FROM cte	WHERE [ROW NUMBER] > 1;

     /* Remove Emp Group 7 and 9*/
	 PRINT 'Remove Emp Group 7 and 9';
	 DELETE FROM WAVE_NM_PA0185 
	       WHERE endda >= CAST(@which_date as date) and begda <= CAST(@which_date as date) AND 
		        ISNULL(PERNR, '') IN (SELECT DISTINCT PERNR FROM WAVE_NM_PA0185 A1 
									    JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[emp - personnel number]
                                        WHERE endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND ISNULL([Emp - Group], '') IN ('7', '9'))

	--Set ROU-ID adjustment
	UPDATE WAVE_NM_PA0185
	   SET DOCN1=SUBSTRING(ICNUM, 1, 2), ICNUM=SUBSTRING(ICNUM, 4, len(ICNUM))
	   WHERE ICTYP='02' AND INFO_TYPE='PA0185' AND WDVALUE185='ROU-ID'

	UPDATE WAVE_NM_PA0185 SET [FPDAT]='00000000' WHERE ([FPDAT] IS NULL OR [FPDAT]='0' OR [FPDAT]='00000' OR [FPDAT]='000000' OR [FPDAT]='0000000' OR [FPDAT]='200');
	UPDATE WAVE_NM_PA0185 SET [EXPID]='00000000' WHERE ([EXPID] IS NULL OR [EXPID]='0' OR [EXPID]='00000' OR [EXPID]='000000' OR [EXPID]='0000000' OR [EXPID]='200');

    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_NATI_ERROR;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_NATI_INFO;';
    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_GOVT_INFO;';
    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_LICE_INFO;';
    EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH N'drop table if exists PA0185_VISA_INFO;';

	/* National ID head */
	PRINT 'National ID head';
	PRINT GETDATE();
    EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185] 'NATI', @which_date, @ErrorFlag;
	PRINT GETDATE()
	--SELECT * FROM PA0185_NATI_INFO

	/* Government ID head */
	PRINT 'Government ID head';
	PRINT GETDATE();
	EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185] 'GOVT', @which_date, @ErrorFlag;
	PRINT GETDATE();
    --SELECT * FROM PA0185_GOVT_INFO

	/* License ID head */
	PRINT 'License ID head';
	PRINT GETDATE();
    EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185] 'LICE', @which_date, @ErrorFlag;
	PRINT GETDATE();
	--SELECT * FROM PA0185_LICE_INFO

	/* Visa ID head */
	PRINT 'Visa ID head';
	PRINT GETDATE();
    EXEC [dbo].[PROC_WAVE_NM_AUTOMATE_OTHERID_PA0185] 'VISA', @which_date, @ErrorFlag;
	PRINT GETDATE();
	--SELECT * FROM PA0185_VISA_INFO --WHERE VISA_PERNR='04000021'

	/* Other ID Info */
	DECLARE @OTHERID_INFO TABLE(

	   [Legacy]                                   NVARCHAR(200),
	   [Employee ID]                              NVARCHAR(200),
	   [Applicant_ID]                             NVARCHAR(200),
	   [Worker Type]                              NVARCHAR(200),

	   [Visa ID VISA1]                            NVARCHAR(200),
	   [Visa Type VISA1]                          NVARCHAR(200),
	   [Country ISO Code VISA1]                   NVARCHAR(200),
	   [Issued Date VISA1]                        NVARCHAR(200),
	   [Expiration Date VISA1]                    NVARCHAR(200),
	   [Verification Date VISA1]                  NVARCHAR(200),

	   [Visa ID VISA2]                            NVARCHAR(200),
	   [Visa Type VISA2]                          NVARCHAR(200),
	   [Country ISO Code VISA2]                   NVARCHAR(200),
	   [Issued Date VISA2]                        NVARCHAR(200),
	   [Expiration Date VISA2]                    NVARCHAR(200),
	   [Verification Date VISA2]                  NVARCHAR(200),

	   [Visa ID VISA3]                            NVARCHAR(200),
	   [Visa Type VISA3]                          NVARCHAR(200),
	   [Country ISO Code VISA3]                   NVARCHAR(200),
	   [Issued Date VISA3]                        NVARCHAR(200),
	   [Expiration Date VISA3]                    NVARCHAR(200),
	   [Verification Date VISA3]                  NVARCHAR(200),

	   [Custom_ID]                                NVARCHAR(200),
	   [Custom_ID Type]                           NVARCHAR(200),
	   [Issued_Date Custom]                       NVARCHAR(200),
	   [Expiration_Date Custom]                   NVARCHAR(200),

	   [National ID NATI1]                        NVARCHAR(200),
	   [National ID Type NATI1]                   NVARCHAR(200),
	   [National ID Type ID NATI1]                NVARCHAR(200),
	   [Issued_Date NATI1]                        NVARCHAR(200),
	   [Expiration_Date NATI1]                    NVARCHAR(200),
	   [Verification_Date NATI1]                  NVARCHAR(200),
	   [Series NATI1]                             NVARCHAR(200),
	   [Issuing_Agency NATI1]                     NVARCHAR(200),

	   [National ID NATI2]                        NVARCHAR(200),
	   [National ID Type NATI2]                   NVARCHAR(200),
	   [National ID Type ID NATI2]                NVARCHAR(200),
	   [Issued_Date NATI2]                        NVARCHAR(200),
	   [Expiration_Date NATI2]                    NVARCHAR(200),
	   [Verification_Date NATI2]                  NVARCHAR(200),
	   [Series NATI2]                             NVARCHAR(200),
	   [Issuing_Agency NATI2]                     NVARCHAR(200),

	   [National ID NATI3]                        NVARCHAR(200),
	   [National ID Type NATI3]                   NVARCHAR(200),
	   [National ID Type ID NATI3]                NVARCHAR(200),
	   [Issued_Date NATI3]                        NVARCHAR(200),
	   [Expiration_Date NATI3]                    NVARCHAR(200),
	   [Verification_Date NATI3]                  NVARCHAR(200),
	   [Series NATI3]                             NVARCHAR(200),
	   [Issuing_Agency NATI3]                     NVARCHAR(200),

	   [National ID NATI4]                        NVARCHAR(200),
	   [National ID Type NATI4]                   NVARCHAR(200),
	   [National ID Type ID NATI4]                NVARCHAR(200),
	   [Issued_Date NATI4]                        NVARCHAR(200),
	   [Expiration_Date NATI4]                    NVARCHAR(200),
	   [Verification_Date NATI4]                  NVARCHAR(200),
	   [Series NATI4]                             NVARCHAR(200),
	   [Issuing_Agency NATI4]                     NVARCHAR(200),

	   [National ID NATI5]                        NVARCHAR(200),
	   [National ID Type NATI5]                   NVARCHAR(200),
	   [National ID Type ID NATI5]                NVARCHAR(200),
	   [Issued_Date NATI5]                        NVARCHAR(200),
	   [Expiration_Date NATI5]                    NVARCHAR(200),
	   [Verification_Date NATI5]                  NVARCHAR(200),
	   [Series NATI5]                             NVARCHAR(200),
	   [Issuing_Agency NATI5]                     NVARCHAR(200),

	   [Government ID GOVT1]                      NVARCHAR(200),
	   [Government ID Type GOVT1]                 NVARCHAR(200),
	   [Government ID Type ID GOVT1]              NVARCHAR(200),
	   [Country_ISO Code GOVT1]                   NVARCHAR(200),
	   [Issued_Date GOVT1]                        NVARCHAR(200),
	   [Expiration_Date GOVT1]                    NVARCHAR(200),
	   [Verification_Date GOVT1]                  NVARCHAR(200),

	   [Government ID GOVT2]                      NVARCHAR(200),
	   [Government ID Type GOVT2]                 NVARCHAR(200),
	   [Government ID Type ID GOVT2]              NVARCHAR(200),
	   [Country_ISO Code GOVT2]                   NVARCHAR(200),
	   [Issued_Date GOVT2]                        NVARCHAR(200),
	   [Expiration_Date GOVT2]                    NVARCHAR(200),
	   [Verification_Date GOVT2]                  NVARCHAR(200),

	   [Government ID GOVT3]                      NVARCHAR(200),
	   [Government ID Type GOVT3]                 NVARCHAR(200),
	   [Government ID Type ID GOVT3]              NVARCHAR(200),
	   [Country_ISO Code GOVT3]                   NVARCHAR(200),
	   [Issued_Date GOVT3]                        NVARCHAR(200),
	   [Expiration_Date GOVT3]                    NVARCHAR(200),
	   [Verification_Date GOVT3]                  NVARCHAR(200),

	   [Government ID GOVT4]                      NVARCHAR(200),
	   [Government ID Type GOVT4]                 NVARCHAR(200),
	   [Government ID Type ID GOVT4]              NVARCHAR(200),
	   [Country_ISO Code GOVT4]                   NVARCHAR(200),
	   [Issued_Date GOVT4]                        NVARCHAR(200),
	   [Expiration_Date GOVT4]                    NVARCHAR(200),
	   [Verification_Date GOVT4]                  NVARCHAR(200),

	   [Government ID GOVT5]                      NVARCHAR(200),
	   [Government ID Type GOVT5]                 NVARCHAR(200),
	   [Government ID Type ID GOVT5]              NVARCHAR(200),
	   [Country_ISO Code GOVT5]                   NVARCHAR(200),
	   [Issued_Date GOVT5]                        NVARCHAR(200),
	   [Expiration_Date GOVT5]                    NVARCHAR(200),
	   [Verification_Date GOVT5]                  NVARCHAR(200),

	   [License ID LICENSE1]                      NVARCHAR(200),
	   [License Ref ID LICENSE1]                  NVARCHAR(200),
	   [License Type LICENSE1]                    NVARCHAR(200),
	   [License Class LICENSE1]                   NVARCHAR(200),
	   [Issued Date LICENSE1]                     NVARCHAR(200),
	   [Expiration Date LICENSE1]                 NVARCHAR(200),
	   [Verification Date LICENSE1]               NVARCHAR(200),
	   [Country ISO Code LICENSE1]                NVARCHAR(200),
	   [Country Region LICENSE1]                  NVARCHAR(200),
	   [Authority Name LICENSE1]                  NVARCHAR(200),
	   [Authority ID LICENSE1]                    NVARCHAR(200),
		  
	   [Passport_Number]                          NVARCHAR(200),
	   [Passport_Type]                            NVARCHAR(200),
	   [Country_ISO Code4]                        NVARCHAR(200),
	   [Issued_Date10]                            NVARCHAR(200),
	   [Expiration_Date10]                        NVARCHAR(200),
	   [Verification_Date9]                       NVARCHAR(200),

	   [Custom_ID11]                              NVARCHAR(2000),
	   [Custom_ID1 Type]                          NVARCHAR(2000),
	   [Custom_ID21]                              NVARCHAR(2000),
	   [Custom_ID2 Type]                          NVARCHAR(2000),
	   [Custom_ID31]                              NVARCHAR(2000),
	   [Custom_ID3 Type]                          NVARCHAR(2000),
	   [Custom_ID4]                               NVARCHAR(2000),
	   [Custom_ID4 Type]                          NVARCHAR(2000),
	   [Custom_ID5]                               NVARCHAR(2000),
	   [Custom_ID5 Type]                          NVARCHAR(2000),

	   [Emp - Group]                              NVARCHAR(2000),
	   [Personnel Number]                         NVARCHAR(2000)
	);

    PRINT 'DGW starts';
	PRINT GETDATE()
	--SELECT DISTINCT [WD_emp_type] FROM WAVE_NM_POSITION_MANAGEMENT_BASE
	INSERT INTO @OTHERID_INFO
	SELECT DISTINCT ISNULL(base.[Emp - Personnel Number], '') [Legacy]
			,ISNULL(base.[Emp - Personnel Number], '') [Employee ID]
			,ISNULL(base.[Emp - Personnel Number], '') [Applicant_ID]			
			,ISNULL(base.[WD_emp_type], '') [Worker Type]

			,ISNULL(VISA.[ID1], '')                                  [Visa ID VISA1]
			,ISNULL(VISA.[ID_Type1], '')                             [Visa Type VISA1]
			,ISNULL(VISA.[ISCOT1], '')                               [Country ISO Code VISA1]
			,ISNULL(VISA.[Issued_Date1], '')                         [Issued Date VISA1]
			,ISNULL(VISA.[Expiration_Date1], '')                     [Expiration Date VISA1]
			,ISNULL(VISA.[Verification_Date1], '')                   [Verification Date VISA1]

			,ISNULL(VISA.[ID2], '')                                  [Visa ID VISA2]
			,ISNULL(VISA.[ID_Type2], '')                             [Visa Type VISA2]
			,ISNULL(VISA.[ISCOT2], '')                               [Country ISO Code VISA2]
			,ISNULL(VISA.[Issued_Date2], '')                         [Issued Date VISA2]
			,ISNULL(VISA.[Expiration_Date2], '')                     [Expiration Date VISA2]
			,ISNULL(VISA.[Verification_Date2], '')                   [Verification Date VISA2]

			,ISNULL(VISA.[ID3], '')                                  [Visa ID VISA3]
			,ISNULL(VISA.[ID_Type3], '')                             [Visa Type VISA3]
			,ISNULL(VISA.[ISCOT3], '')                               [Country ISO Code VISA3]
			,ISNULL(VISA.[Issued_Date3], '')                         [Issued Date VISA3]
			,ISNULL(VISA.[Expiration_Date3], '')                     [Expiration Date VISA3]
			,ISNULL(VISA.[Verification_Date3], '')                   [Verification Date VISA3]

			,'' [Custom_ID]
			,'' [Custom_ID Type]
			,'' [Issued_Date Custom]
			,'' [Expiration_Date Custom]

			,ISNULL(NATI.[ID1], '')                                  [National ID NATI1]
			,ISNULL(NATI.[ID_Type1], '')                             [National ID Type NATI1]
			,ISNULL(NATI.[ID_Type_ID1], '')                          [National ID Type ID NATI1]
			,ISNULL(NATI.[Issued_Date1], '')                         [Issued_Date NATI1]
			,ISNULL(NATI.[Expiration_Date1], '')                     [Expiration_Date NATI1]
			,ISNULL(NATI.[Verification_Date1], '')                   [Verification_Date NATI1]
			,ISNULL(NATI.[Series1], '')                              [Series NATI1]
			,ISNULL(NATI.[Issuing_Agency1], '')                      [Issuing_Agency NATI1]

			,ISNULL(NATI.[ID2], '')                                  [National ID NATI2]
		    ,ISNULL(NATI.[ID_Type2], '')                             [National ID Type NATI2]
			,ISNULL(NATI.[ID_Type_ID2], '')                          [National ID Type ID NATI2]
			,ISNULL(NATI.[Issued_Date2], '')                         [Issued_Date NATI2]
			,ISNULL(NATI.[Expiration_Date2], '')                     [Expiration_Date NATI2]
			,ISNULL(NATI.[Verification_Date2], '')                   [Verification_Date NATI2]
			,ISNULL(NATI.[Series2], '')                              [Series NATI2]
			,ISNULL(NATI.[Issuing_Agency2], '')                      [Issuing_Agency NATI2]

			,ISNULL(NATI.[ID3], '')                                  [National ID NATI3]
		    ,ISNULL(NATI.[ID_Type3], '')                             [National ID Type NATI3]
			,ISNULL(NATI.[ID_Type_ID3], '')                          [National ID Type ID NATI3]
			,ISNULL(NATI.[Issued_Date3], '')                         [Issued_Date NATI3]
			,ISNULL(NATI.[Expiration_Date3], '')                     [Expiration_Date NATI3]
			,ISNULL(NATI.[Verification_Date3], '')                   [Verification_Date NATI3]
			,ISNULL(NATI.[Series3], '')                              [Series NATI3]
			,ISNULL(NATI.[Issuing_Agency3], '')                      [Issuing_Agency NATI3]

			,ISNULL(NATI.[ID4], '')                                  [National ID NATI4]
			,ISNULL(NATI.[ID_Type4], '')                             [National ID Type NATI4]
			,ISNULL(NATI.[ID_Type_ID4], '')                          [National ID Type ID NATI4]
			,ISNULL(NATI.[Issued_Date4], '')                         [Issued_Date NATI4]
			,ISNULL(NATI.[Expiration_Date4], '')                     [Expiration_Date NATI4]
			,ISNULL(NATI.[Verification_Date4], '')                   [Verification_Date NATI4]
			,ISNULL(NATI.[Series4], '')                              [Series NATI4]
			,ISNULL(NATI.[Issuing_Agency4], '')                      [Issuing_Agency NATI4]

			,ISNULL(NATI.[ID5], '')                                  [National ID NATI5]
			,ISNULL(NATI.[ID_Type5], '')                             [National ID Type NATI5]
			,ISNULL(NATI.[ID_Type_ID5], '')                          [National ID Type ID NATI5]
			,ISNULL(NATI.[Issued_Date5], '')                         [Issued_Date NATI5]
			,ISNULL(NATI.[Expiration_Date5], '')                     [Expiration_Date NATI5]
			,ISNULL(NATI.[Verification_Date5], '')                   [Verification_Date NATI5]
			,ISNULL(NATI.[Series5], '')                              [Series NATI5]
			,ISNULL(NATI.[Issuing_Agency5], '')                      [Issuing_Agency NATI5]

			,ISNULL(GOVT.[ID1], '')                                  [Government_ID GOVT1]
			,ISNULL(GOVT.[ID_Type1], '')                             [Government_ID Type GOVT1]
			,ISNULL(GOVT.[ID_Type_ID1], '')                          [Government_ID Type ID GOVT1]
			,ISNULL(GOVT.[ISCOT1], '')                               [Country_ISO Code GOVT1]
			,ISNULL(GOVT.[Issued_Date1], '')                         [Issued_Date GOVT1]
			,ISNULL(GOVT.[Expiration_Date1], '')                     [Expiration_Date GOVT1]
			,ISNULL(GOVT.[Verification_Date1], '')                   [Verification_Date GOVT1]

			,ISNULL(GOVT.[ID2], '')                                  [Government_ID GOVT2]
			,ISNULL(GOVT.[ID_Type2], '')                             [Government_ID Type GOVT2]
			,ISNULL(GOVT.[ID_Type_ID2], '')                          [Government_ID Type ID GOVT2]
			,ISNULL(GOVT.[ISCOT2], '')                               [Country_ISO Code GOVT2]
			,ISNULL(GOVT.[Issued_Date2], '')                         [Issued_Date GOVT2]
			,ISNULL(GOVT.[Expiration_Date2], '')                     [Expiration_Date GOVT2]
			,ISNULL(GOVT.[Verification_Date2], '')                   [Verification_Date GOVT2]

			,ISNULL(GOVT.[ID3], '')                                  [Government_ID GOVT3]
			,ISNULL(GOVT.[ID_Type3], '')                             [Government_ID Type GOVT3]
			,ISNULL(GOVT.[ID_Type_ID3], '')                          [Government_ID Type ID GOVT3]
			,ISNULL(GOVT.[ISCOT3], '')                               [Country_ISO Code GOVT3]
			,ISNULL(GOVT.[Issued_Date3], '')                         [Issued_Date GOVT3]
			,ISNULL(GOVT.[Expiration_Date3], '')                     [Expiration_Date GOVT3]
			,ISNULL(GOVT.[Verification_Date3], '')                   [Verification_Date GOVT3]

			,ISNULL(GOVT.[ID4], '')                                  [Government_ID GOVT4]
			,ISNULL(GOVT.[ID_Type4], '')                             [Government_ID Type GOVT4]
			,ISNULL(GOVT.[ID_Type_ID4], '')                          [Government_ID Type ID GOVT4]
			,ISNULL(GOVT.[ISCOT4], '')                               [Country_ISO Code GOVT4]
			,ISNULL(GOVT.[Issued_Date4], '')                         [Issued_Date GOVT4]
			,ISNULL(GOVT.[Expiration_Date4], '')                     [Expiration_Date GOVT4]
			,ISNULL(GOVT.[Verification_Date4], '')                   [Verification_Date GOVT4]

			,ISNULL(GOVT.[ID5], '')                                  [Government_ID GOVT5]
			,ISNULL(GOVT.[ID_Type5], '')                             [Government_ID Type GOVT5]
			,ISNULL(GOVT.[ID_Type_ID5], '')                          [Government_ID Type ID GOVT5]
			,ISNULL(GOVT.[ISCOT5], '')                               [Country_ISO Code GOVT5]
			,ISNULL(GOVT.[Issued_Date5], '')                         [Issued_Date GOVT5]
			,ISNULL(GOVT.[Expiration_Date5], '')                     [Expiration_Date GOVT5]
			,ISNULL(GOVT.[Verification_Date5], '')                   [Verification_Date GOVT5]

			,ISNULL(LICE.[ID1], '')                                  [License ID LICENSE1]
			,ISNULL(LICE.[ID_Type1], '')                             [License Ref ID LICENSE1]
			,ISNULL(LICE.[ID_Type_ID1], '')                          [License Type LICENSE1]
			,''                                                      [License Class LICENSE1]
			,ISNULL(LICE.[Issued_Date1], '')                         [Issued Date LICENSE1]
			,ISNULL(LICE.[Expiration_Date1], '')                     [Expiration Date LICENSE1]
			,ISNULL(LICE.[Verification_Date1], '')                   [Verification Date LICENSE1]
			,ISNULL(LICE.[ISCOT1], '')                               [Country ISO Code LICENSE1]
			,''                                                      [Country Region LICENSE1]
			,''                                                      [Authority Name LICENSE1]
			,ISNULL(LICE.[Issuing_Agency1], '')                      [Authority ID LICENSE1]
		  
			,'' [Passport_Number]
			,'' [Passport_Type]
			,'' [Country_ISO Code4]
			,'' [Issued_Date10]
			,'' [Expiration_Date10]
			,'' [Verification_Date9]

			
			,[Emp - HRCGLPers. id] [Custom_ID11]
			,'Global ID' [Custom_ID1 Type]
			,IIF(ISNULL([emp - firstport id], '')='', '0', [emp - firstport id]) [Custom_ID21]
			,'FirstPort ID' [Custom_ID2 Type]
			,ISNULL([Org - OpLevel 3], '')+'|'+
			 ISNULL((SELECT TOP 1 RTRIM(LTRIM([OPL3 Text])) FROM WAVE_NM_OPL WHERE [OPL3 Code]=ISNULL([Org - OpLevel 3], '')), '')+'|'+
			 ISNULL([Org - OpLevel 2], '')+'|'+
			 ISNULL((SELECT TOP 1 RTRIM(LTRIM([OPL2 Text])) FROM WAVE_NM_OPL WHERE [OPL2 Code]=ISNULL([Org - OpLevel 2], '')), '')+'|'+
			 ISNULL([Org - OpLevel 1], '')+'|'+
			 ISNULL((SELECT TOP 1 RTRIM(LTRIM([OPL1 Text])) FROM WAVE_NM_OPL WHERE [OPL1 Code]=ISNULL([Org - OpLevel 1], '')), '')+'|'+
			 ISNULL([Org - Funct Dep Code], '')+'|' [Custom_ID31]
			,'Legacy OPL ID' [Custom_ID3 Type]
			,IIF(ISNULL([CB - Payroll ref No.], '')='', '', [CB - Payroll ref No.]) [Custom_ID4]
			,'Payroll Reference ID' [Custom_ID4 Type]
			,ISNULL([Emp-Prev PrsNo Legcy], '') [Custom_ID5]
			,'Previous/Legacy ID' [Custom_ID5 Type]

			,[Emp - Group]
			,ISNULL(base.[Emp - Personnel Number], '')		
	FROM (SELECT * FROM WAVE_NM_POSITION_MANAGEMENT_BASE) base
		LEFT JOIN PA0185_NATI_INFO NATI ON NATI.[PERNR]=base.[Emp - Personnel Number]
		LEFT JOIN PA0185_GOVT_INFO GOVT ON GOVT.[PERNR]=base.[Emp - Personnel Number]
		LEFT JOIN PA0185_VISA_INFO VISA ON VISA.[PERNR]=base.[Emp - Personnel Number]
		LEFT JOIN PA0185_LICE_INFO LICE ON LICE.[PERNR]=base.[Emp - Personnel Number]

    --SELECT DISTINCT [Emp - Group] FROM WAVE_NM_POSITION_MANAGEMENT_BASE
	--SELECT * FROM PA0185_NATI_INFO ORDER BY PERNR
	--SELECT * FROM PA0185_GOVT_INFO
	--SELECT * FROM PA0185_VISA_INFO

	/* MYS Passport Id corrections */
	UPDATE @OTHERID_INFO SET [Country_ISO Code GOVT1]='MYS' WHERE [Government ID Type GOVT1]='Government_ID_Type_MY_Pasaport_-_Foreigner';
	UPDATE @OTHERID_INFO SET [Country_ISO Code GOVT2]='MYS' WHERE [Government ID Type GOVT2]='Government_ID_Type_MY_Pasaport_-_Foreigner';
	UPDATE @OTHERID_INFO SET [Country ISO Code VISA1]='MYS' WHERE [Visa Type VISA1]='Visa_ID_MY_Employment_Pass';
	UPDATE @OTHERID_INFO SET [Visa ID VISA2]='', [Visa Type VISA2]='', [Country ISO Code VISA2]='' WHERE [Employee ID]='25003076'

	/* ID type count with respct to country */
	UPDATE @OTHERID_INFO
	    SET [National ID NATI1]=IIF([National ID Type NATI1]='SGP-NRIC', IIF(SUBSTRING([National ID NATI1], 1, 2)='NI', SUBSTRING([National ID NATI1], 3, LEN([National ID NATI1])), [National ID NATI1]), [National ID NATI1]),
		    [National ID NATI2]=IIF([National ID Type NATI2]='SGP-NRIC', IIF(SUBSTRING([National ID NATI2], 1, 2)='NI', SUBSTRING([National ID NATI2], 3, LEN([National ID NATI2])), [National ID NATI2]), [National ID NATI2]),
			[National ID NATI3]=IIF([National ID Type NATI3]='SGP-NRIC', IIF(SUBSTRING([National ID NATI3], 1, 2)='NI', SUBSTRING([National ID NATI3], 3, LEN([National ID NATI3])), [National ID NATI3]), [National ID NATI3]),
			[National ID NATI4]=IIF([National ID Type NATI4]='SGP-NRIC', IIF(SUBSTRING([National ID NATI4], 1, 2)='NI', SUBSTRING([National ID NATI4], 3, LEN([National ID NATI4])), [National ID NATI4]), [National ID NATI4]),
			[National ID NATI5]=IIF([National ID Type NATI5]='SGP-NRIC', IIF(SUBSTRING([National ID NATI5], 1, 2)='NI', SUBSTRING([National ID NATI5], 3, LEN([National ID NATI5])), [National ID NATI5]), [National ID NATI5])

    --SELECT * FROM @OTHERID_INFO			


	/********* Result Set ***********/
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WD_HR_TR_AUTOMATED_OTHERID;';
	PRINT 'Drop table, If exists: WD_HR_TR_AUTOMATED_OTHERID';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists WD_HR_TR_AUTOMATED_OTHERID_DELTA;';
	PRINT 'Drop table, If exists: WD_HR_TR_AUTOMATED_OTHERID_DELTA';

	SELECT DISTINCT * INTO WD_HR_TR_AUTOMATED_OTHERID FROM 
		(SELECT *, ROW_NUMBER() 
			OVER(PARTITION BY [Employee ID] 
					ORDER BY [Employee ID], [Emp - Group]) AS [ROW NUMBER] FROM @OTHERID_INFO) A1
	WHERE [ROW NUMBER]=1
    PRINT GETDATE()

	/********* Delta DGW ***********/
	DECLARE @DELTA_TABLE TABLE (
		 WD_VALUE      NVARCHAR(500)
	)

	--Delta 1 Insert statement
	-------------------------------------------
	--INSERT INTO @DELTA_TABLE SELECT 'UKR-INT'
	--INSERT INTO @DELTA_TABLE SELECT 'BEL-CI'
	--INSERT INTO @DELTA_TABLE SELECT 'BEL-NN'
	--INSERT INTO @DELTA_TABLE SELECT 'ESP-NIF'
	--INSERT INTO @DELTA_TABLE SELECT 'ESP-NSS'
	--INSERT INTO @DELTA_TABLE SELECT 'ESP-NIE'
	--INSERT INTO @DELTA_TABLE SELECT 'FIN-ID'
	--INSERT INTO @DELTA_TABLE SELECT 'POL-PESEL'
	--INSERT INTO @DELTA_TABLE SELECT 'POL-DO'
	--INSERT INTO @DELTA_TABLE SELECT 'TUR-TSGN'
	--INSERT INTO @DELTA_TABLE SELECT 'VISA_ID_CH_120 Days Permit'
	--INSERT INTO @DELTA_TABLE SELECT 'Residence Doc.-Settl.Permit-Empl.permit.'
	--INSERT INTO @DELTA_TABLE SELECT 'Residence Doc. - Residence Permit'
	--INSERT INTO @DELTA_TABLE SELECT 'Work Permit-EUR'
	--INSERT INTO @DELTA_TABLE SELECT 'Ext.pageSettl.Perm.(WithGain.Empl.)'
	--INSERT INTO @DELTA_TABLE SELECT 'Visa'
	--INSERT INTO @DELTA_TABLE SELECT 'EU Blue Card'
	--INSERT INTO @DELTA_TABLE SELECT 'Ext.pageResid.Card(WithoutGain.Empl.)'
	--INSERT INTO @DELTA_TABLE SELECT 'Ext.pageResid.Perm.(WithGain.Empl.)'
	--SELECT WD_VALUE FROM @DELTA_TABLE

	--Delta 2 Insert Statement
	--INSERT INTO @DELTA_TABLE SELECT 'DEU-SID'
	--INSERT INTO @DELTA_TABLE SELECT 'DEU-SVNR'
	--INSERT INTO @DELTA_TABLE SELECT 'TUR-TCKN'
	--INSERT INTO @DELTA_TABLE SELECT 'ROU-ID'
	--INSERT INTO @DELTA_TABLE SELECT 'CHE-AVS'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-YHH'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-INT'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-PIFC'
	--INSERT INTO @DELTA_TABLE SELECT 'GRC-AOM'
	--INSERT INTO @DELTA_TABLE SELECT 'UKR-IH'
	--INSERT INTO @DELTA_TABLE SELECT 'UKR-INT'
	--INSERT INTO @DELTA_TABLE SELECT 'Government_ID_Type_GR_National ID'
	--INSERT INTO @DELTA_TABLE SELECT 'Government_ID_Type_GR_DOY Identification'
	--INSERT INTO @DELTA_TABLE SELECT 'Visa_ID_RU_Work Permit'
	--INSERT INTO @DELTA_TABLE SELECT 'Visa_ID_RU_Work Visa'

	----Delta 3 Insert Statement
	--INSERT INTO @DELTA_TABLE SELECT 'HUN-SA'
	--INSERT INTO @DELTA_TABLE SELECT 'HUN-AK'
	--INSERT INTO @DELTA_TABLE SELECT 'HUN-TK'
	--INSERT INTO @DELTA_TABLE SELECT 'CZE-RC'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-YHH'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-INT'
	--INSERT INTO @DELTA_TABLE SELECT 'RUS-PIFC'
	--INSERT INTO @DELTA_TABLE SELECT 'EGY-NID'
	--INSERT INTO @DELTA_TABLE SELECT 'ROU-ID'
	--INSERT INTO @DELTA_TABLE SELECT 'ROU-CNP'
	--INSERT INTO @DELTA_TABLE SELECT 'Government_ID_Type_HU_FEOR kód'
	--INSERT INTO @DELTA_TABLE SELECT 'Government_ID_Type_HU_SZÉP alszámlaszámok'

	--W4 Gold Delta 1
	--INSERT INTO @DELTA_TABLE SELECT 'CHE-AVS'
	INSERT INTO @DELTA_TABLE SELECT 'VISA_ID_CH_Cross-border Commuter permit (G permit)'	 
    PRINT GETDATE()

	SELECT * 
	     INTO WD_HR_TR_AUTOMATED_OTHERID_DELTA 
		 FROM WD_HR_TR_AUTOMATED_OTHERID
		 WHERE ([National ID Type NATI1] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [National ID Type NATI2] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [National ID Type NATI3] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [National ID Type NATI4] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [National ID Type NATI5] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [Visa Type VISA1] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [Visa Type VISA2] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [Visa Type VISA3] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [Government ID Type GOVT1] IN (SELECT WD_VALUE FROM @DELTA_TABLE) OR
			   [Government ID Type GOVT2] IN (SELECT WD_VALUE FROM @DELTA_TABLE)) --AND
			   --[Applicant_ID] IN (SELECT ID FROM @CHE_AVS)

    PRINT GETDATE();

	/* Hides the Dummy column */
	UPDATE WD_HR_TR_AUTOMATED_OTHERID SET Applicant_ID=''
	UPDATE WD_HR_TR_AUTOMATED_OTHERID_DELTA SET Applicant_ID=''
		
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

--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'P0', 'Other ID', '2021-03-10', 'P0_', 'P0'
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' ORDER BY [INFO TYPE], [COUNTRY], [ID TYPE]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED ORDER BY [COUNTRY]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='P0' AND [Report Name]='Other ID' ORDER BY [Employee ID]


--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE [HR CORE ID] ='' AND [INFO TYPE]='PA0185'
--nine or ten digits only -> SVK-RC( 8555186398 )
--SELECT * INTO WD_HR_TR_AUTOMATED_OTHERID_WD_COUNT FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT
-- -> FIN-ID( 270967-0076 )
--'784', followed by twelve digits -> ARE-ID( 748197953962863 )

--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'W3_GOLD', 'Other ID', '2020-10-02', 'W3_GOLD_', 'W3_GOLD'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'W4_P2', 'Other ID', '2020-10-02', 'W4_P2_', 'W4_P2'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'W4_GOLD', 'Other ID', '2021-02-14', 'W4_GOLD_', 'W4_GOLD'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID_NEW 'W4_CATCHUP', 'Other ID', '2021-02-14', 'W4_CATCHUP_', 'W4_CATCHUP'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID @which_wavestage, @which_report, @which_date, @PrefixCopy, '', @Correction, 'Other ID Associates Emp Group 4'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID 'W3_GOLD', 'Other ID', '2020-10-02', 'W3_GOLD_', '', 'W3_GOLD', 'Other ID Associates Emp Group 4'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID 'W3_GOLD', 'Other ID', '2020-10-02', 'W3_GOLD_', '', 'W3_GOLD', 'Other ID Associates'
--EXEC PROC_WAVE_NM_AUTOMATE_OTHERID 'W4_P2', 'Other ID', '2020-10-02', 'W4_P2_', '', 'W4_P2', 'Other ID Associates'
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' ORDER BY [INFO TYPE], [COUNTRY], [ID TYPE]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' ORDER BY [INFO TYPE], [COUNTRY], [ID TYPE]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_NOT_COUNTED ORDER BY [COUNTRY]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Employee ID] IN (SELECT [Employee ID] FROM WD_HR_TR_AUTOMATED_OTHERID_EMPGROUP_04) ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [Employee ID] IN (SELECT [Emp - Personnel Number] FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [Geo - Work Country]='ES') ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_EMPGROUP_04 ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_DELTA ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_CATCHUP' AND [Report Name]='Other ID' ORDER BY [Employee ID]
--SELECT * FROM [ALCON_MIGRATION_ERROR_LIST] WHERE Wave='W4_GOLD' AND [COUNTRY Code]='CH' AND [Report Name]='Other ID' ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID A1 LEFT JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[Employee ID]=A2.[Emp - Personnel Number] WHERE [Geo - Work Country] IN ('SP') ORDER BY [Employee ID]
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_DELTA ORDER BY [Employee ID]
--SELECT DISTINCT [Worker Type] FROM WD_HR_TR_AUTOMATED_OTHERI77D
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID_COUNT WHERE ISNULL([COUNTRY], '') <> '' ORDER BY [INFO TYPE], [COUNTRY], [ID TYPE]
--SELECT WCOUNC, ICTYP, MAX(INFO_TYPE), COUNT(*) FROM WAVE_NM_PA0185 WHERE WDASSIGNED='N' AND WCOUNC IS NOT NULL GROUP BY WCOUNC, ICTYP
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [EMPLOYEE ID]='21000413' ORDER BY [Employee ID]
--SELECT * FROM WAVE_NM_POSITION_MANAGEMENT_BASE WHERE [Emp - Personnel Number]='21000413'
--SELECT * FROM WD_HR_TR_AUTOMATED_OTHERID WHERE [EMPLOYEE ID] IN ('02041199') ORDER BY [Employee ID]
--SELECT * FROM WAVE_NM_PA0036 WHERE PERNR='02041199'
--PRINT N'ΤΕΑΥΦΕ'

--SELECT DISTINCT A1.* 
--    FROM W4_P2_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number] 
--    WHERE [Geo - Country (CC)] IN ('AE') AND SUBTY='01' AND ICNUM IS NOT NULL AND 
--	      CAST(BEGDA AS DATE) <= CAST('2020-10-02' AS DATE) AND CAST(ENDDA AS DATE) >= CAST('2020-10-02' AS DATE)
--	ORDER BY PERNR
--SELECT DISTINCT A1.* 
--    FROM W4_P2_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number] 
--    WHERE [Geo - Country (CC)] IN ('HU') AND SUBTY='9006' AND USRID_LONG IS NOT NULL
--	ORDER BY PERNR

--SELECT DISTINCT A1.* 
--    FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number] 
--    WHERE [Geo - Country (CC)] IN ('AE') AND SUBTY='01' AND ICNUM IS NOT NULL AND 
--	      CAST(BEGDA AS DATE) <= CAST('2020-10-02' AS DATE) AND CAST(ENDDA AS DATE) >= CAST('2020-10-02' AS DATE)
--	ORDER BY PERNR

--SELECT DISTINCT A1.* 
--    FROM W4_GOLD_PA0048 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number] 
--    WHERE [Geo - Country (CC)] IN ('CH')  AND 
--	      CAST(BEGDA AS DATE) <= CAST('2021-02-14' AS DATE) AND CAST(ENDDA AS DATE) >= CAST('2021-02-14' AS DATE)
--	ORDER BY PERNR

--SELECT DISTINCT ICTYP 
--    FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.[PERNR]=A2.[Emp - Personnel Number] 
--    WHERE [Geo - Country (CC)] IN ('CH')  AND 
--	      CAST(BEGDA AS DATE) <= CAST('2021-02-14' AS DATE) AND CAST(ENDDA AS DATE) >= CAST('2021-02-14' AS DATE)
--	ORDER BY PERNR
    
--SELECT WCOUNC, SUBTY, COUNT(*) FROM WAVE_NM_PA0185 
--WHERE WCOUNC IS NOT NULL
--GROUP BY WCOUNC, SUBTY
--SELECT * FROM W4_P1_POSITION_MANAGEMENT WHERE [GEO - WORK COUNTRY]='SP'

--SELECT * FROM W4_GOLD_PA0149
--SELECT * FROM COUNTRY_LKUP ORDER BY COUNTRY

--SELECT WD_VALUE+','+
--       HR_CORE_NAME+','+
--	   (CASE 
--	      WHEN HEAD='NATI' THEN 'National ID' 
--		  WHEN HEAD='GOVT' THEN 'Government ID'
--		  WHEN HEAD='VISA' THEN 'Visa ID'
--		  WHEN HEAD='LICE' THEN 'License ID'
--		  ELSE ''
--		END)+','+
--		INFO_TYPE+IIF(ISNULL(HR_CORE_ID, '') <> '','( '+HR_CORE_ID+' )', '')+','+
--		ID_TYPE+','+
--		COUNTRY_NAME 
--FROM WAVE_OTHERID_LKUP WHERE WD_VALUE <> ''

--SELECT  WD_VALUE [Work Day Value]
--       ,HR_CORE_NAME [HR Core Name]
--	   ,(CASE 
--	      WHEN HEAD='NATI' THEN 'National ID' 
--		  WHEN HEAD='GOVT' THEN 'Government ID'
--		  WHEN HEAD='VISA' THEN 'Visa ID'
--		  WHEN HEAD='LICE' THEN 'License ID'
--		  ELSE ''
--		 END) [ID Type]
--		,INFO_TYPE+IIF(ISNULL(HR_CORE_ID, '') <> '','( '+HR_CORE_ID+' )', '') [Info Type]
--		,ID_TYPE
--		,COUNTRY_NAME [Country Name]
--FROM WAVE_OTHERID_LKUP WHERE WD_VALUE <> '' ORDER BY HEAD, COUNTRY_NAME, INFO_TYPE, WD_VALUE
--SELECT * FROM WAVE_OTHERID_LKUP WHERE COUNTRY_NAME='Brazil'



--SELECT DISTINCT PERNR FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[emp - personnel number]
--    WHERE endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND ISNULL([Emp - Group], '') IN ('7', '9') 
--SELECT COUNT(*) FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT A2 ON A1.PERNR=A2.[emp - personnel number]
--    WHERE endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND ISNULL([Emp - Group], '') NOT IN ('7', '9') 

--SELECT * FROM WAVE_OTHERID_LKUP WHERE INFO_TYPE='PA0002'

--SELECT A1.* FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[Emp - Personnel Number]
--    WHERE endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND WDASSIGNED='N' AND ISNULL(WDVALUE185, '') <> ''

--SELECT [geo - work country], COUNT(*) [COUNT]
--    FROM P0_PA0105 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[emp - personnel number]
--    WHERE [EMP - GROUP] NOT IN ('7', '9') AND endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND SUBTY='9004'
--    GROUP BY [geo - work country]
--    ORDER BY [geo - work country], [COUNT]

--SELECT [geo - work country], COUNT(*) [COUNT]
--    FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[emp - personnel number]
--    WHERE [EMP - GROUP] NOT IN ('7', '9') AND endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND SUBTY='9004'
--    GROUP BY [geo - work country]
--    ORDER BY [geo - work country], [COUNT]

--SELECT PERNR, [EMP - GROUP], WCOUNC, ICNUM
--    FROM WAVE_NM_PA0185 A1 JOIN WAVE_NM_POSITION_MANAGEMENT_BASE A2 ON A1.PERNR=A2.[emp - personnel number] 
--    WHERE endda >= CAST('2021-03-10' as date) and begda <= CAST('2021-03-10' as date) AND WCOUNC='CA' --AND SUBTY='9006'

--select distinct * From p0_pa1001
--	where convert(date,begda)<='2021-03-10'
--	and convert(date,endda)>='2021-03-10'
--	and rsign = 'A'
--	and otype='C'
--	and plvar='01'
--	and relat='041'
--	and OBJID IN (SELECT DISTINCT [Fields1] FROM WD_HR_TR_JobProfile WHERE [Job Code5] NOT IN (SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily))
--	--and OBJID='30048654'
--	--and OBJID='30042342'
--	ORDER BY OBJID
--	PRINT CONVERT(date,'30-01-2015',103)

--select distinct * From p0_hrp1001
--	where convert(date,begda)<='2021-03-10'
--	and convert(date,endda)>='2021-03-10'
--	and rsign = 'A'
--	and otype='C'
--	and plvar='01'
--	and relat='041'
--	and OBJID IN (SELECT DISTINCT [Fields1] FROM WD_HR_TR_JobProfile WHERE [Job Code5] NOT IN (SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily))
--	--and OBJID='30048654'
--	--and OBJID='30042342'
--	ORDER BY OBJID


--	select distinct convert(date,REPLACE(begda, '.', '-'), 103), convert(date, REPLACE(endda, '.', '-'), 103) From p0_hrp1001


--select distinct * From p0_pa1001
--	where OBJID IN (SELECT DISTINCT [Fields1] FROM WD_HR_TR_JobProfile WHERE [Job Code5] IN (SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily))
--	convert(date,begda)<='2021-03-10'
--	and convert(date,endda)>='2021-03-10'
--	and OBJID='30048654'


