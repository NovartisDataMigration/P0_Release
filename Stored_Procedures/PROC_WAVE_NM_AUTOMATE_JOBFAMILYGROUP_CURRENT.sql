USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_JOBFAMILYGROUP]    Script Date: 4/30/2021 6:01:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_JOBFAMILYGROUP]
    @which_wavestage      AS NVARCHAR(50),
	@which_report         AS NVARCHAR(500),
	@which_date           AS NVARCHAR(50)
AS
BEGIN
--EXEC PROC_WAVE_NM_AUTOMATE_JOBFAMILYGROUP 'P0', 'Job Profile', '2021-03-10'
--SELECT * FROM WD_HR_TR_JobProfile ORDER BY [Spreadsheet Key*2]
--SELECT * FROM WD_HR_TR_JobKeyCode ORDER BY [JobProfile]
--SELECT * FROM WD_HR_TR_JobFamilyGroup ORDER BY CAST([Spreadsheet Key*2] AS INT)
--SELECT * FROM WD_HR_TR_JobFamily WHERE ID5 <> '' ORDER BY CAST([Spreadsheet Key*2] AS INT)
--SELECT * FROM WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION ORDER BY [Spreadsheet Key*]
--SELECT * fROM NOVARTIS_DATA_MIGRATION_JOB_PROFILE_VALIDATION ORDER BY [JOB CODE]

--SELECT * FROM WAVE_JOB_FAMILY
--SELECT * FROM WD_HR_TR_JobFamilyGroup WHERE SUBSTRING([Job Family*12], 2, 2)='BS'
--SELECT [JOB CODE], CAST(JFNUM AS VARCHAR(10))+[JOB FAMILY], [JOB SUB FAMILY] FROM WAVE_JOB_FAMILY ORDER BY [JOB FAMILY]
--SELECT * FROM WAVE_JOB_FAMILY WHERE SUBSTRING([JOB FAMILY SHORT TEXT], 1, 2) NOT IN ('US', 'PR', 'CA', 'XX') ORDER BY [JOB FAMILY]
--SELECT * FROM WAVE_JOB_FAMILY WHERE SUBSTRING([Job Code5], 1, 1) >= '2'  ORDER BY [JOB FAMILY]
--SELECT * FROM WAVE_JOB_FAMILY WHERE SUBSTRING([Job Code5], 2, LEN([Job Code5]))<>[JOB FAMILY SHORT TEXT] ORDER BY [JOB FAMILY]
--SELECT * FROM WAVE_JOB_FAMILY_GROUP ORDER BY [JOB FAMILY]

--DECLARE @which_date AS VARCHAR(20)='2021-03-10';
--SELECt * FROM (
--SELECT SHORT, OBJID, ROW_NUMBER() OVER(PARTITION BY SHORT ORDER BY OBJID) RNUM
--FROM P0_PA1000 
--  WHERE PLVAR='01' AND OTYPE='C' AND endda >=CAST(@which_date as date)	and begda <= CAST(@which_date as date)
--) A1 WHERE RNUM >= 2;

--SELECT * FROM p0_job_family
--SELECT DISTINCT [Global Job Code] FROM p0_job_family

	DECLARE @SQL AS VARCHAR(1000)='drop table if exists WD_HR_TR_JobFamilyGroup;
	                               drop table if exists WD_HR_TR_JobFamily  
	                               drop table if exists p0_job_family;
								   drop table if exists WAVE_JOB_FAMILY;
								   drop table if exists WAVE_JOB_FAMILY_GROUP;
								   drop table if exists WD_HR_TR_JobProfile;
	                               drop table if exists WD_HR_TR_JobKeyCode;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SET @SQL='drop table if exists WAVE_NM_HRP1000;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	SET @SQL='SELECT DISTINCT * INTO WAVE_NM_HRP1000 FROM '+@which_wavestage+'_HRP1000 WHERE CAST(endda AS DATE) >=CAST('''+@which_date+''' as date)	and CAST(begda AS DATE) <= CAST('''+@which_date+''' as date);;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL;
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'alter table WAVE_NM_HRP1000 add SHOW_LANGU nvarchar(255);';
	UPDATE WAVE_NM_HRP1000 SET SHOW_LANGU=IIF(LANGU='E', 'E', 'F');

	/* Removing duplicate rows */
	WITH cte AS (
		SELECT  *, ROW_NUMBER() OVER( PARTITION BY OBJID, MC_SHORT ORDER BY OBJID, MC_SHORT, SHOW_LANGU) RNUM FROM WAVE_NM_HRP1000
	) 
	DELETE FROM cte WHERE [RNUM] > 1;
	   
	select distinct 
	 a.objid [local job code]
	,cast(null as nvarchar(255)) as [Local Job Family]
	,cast(null as nvarchar(255)) as [Local Job sub family]
	,cast(null as nvarchar(255)) as [local job short text]
	,cast(null as nvarchar(255)) as [local job medium text]
	,ISNULL(b.sobid, '') [global job code]
	,cast(null as nvarchar(255)) as [global job family]
	,cast(null as nvarchar(255)) as [global job sub family]
	,cast(null as nvarchar(255)) as [global job sub family short text]
	,cast(null as nvarchar(255)) as [global job sub family medium text]
	,ISNULL(c.stext, '') [global job medium text]
	,ISNULL(c.mc_Short, '') [global job short text] 
	,cast(null as nvarchar(255)) as [job family text]
	,cast(null as nvarchar(255)) as [job family summary]
	into p0_job_family
	from 
	(select distinct objid 
	from WAVE_NM_HRP1000
	where substring(short,1,2) in ('US','PR','CA')
	--and pernr in (select [emp - personnel number] from p0_position_management)
	and convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='C'
	and plvar='01' ) a
	left join (select distinct * From p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and rsign = 'A'
	and otype='C'
	and plvar='01'
	and relat='041') b
	on a.objid = b.objid
	left join (select distinct * 
	from WAVE_NM_HRP1000
	where convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='C'
	and plvar='01'
	and langu='E') c
	on b.sobid = c.objid;

	insert into p0_job_family
	select distinct '','','','','',objid as [global org job],'','','','',stext [global job medium text],mc_short [global job short text], '' [job family text], '' [job family summary]--,substring(mc_short,3,2) [global Job Family], substring(mc_short,5,2) [Job sub family]--, * 
	from WAVE_NM_HRP1000
	where substring(short,1,2) not in ('US','PR','CA')
	--and pernr in (select [emp - personnel number] from p0_position_management)
	and convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='C'
	and plvar='01';

	--update z set
	--  [job family text]=stext
	--from 
	--p0_job_family z
	--left join
	--(select distinct *
	--from WAVE_NM_HRP1000
	--where 
	--convert(date,begda)<='2021-03-10'
	--and convert(date,endda)>='2021-03-10'
	--and otype='FN'
	--and plvar='01'
	--and langu='E') a
	--on substring(z.[global job family], 1, 2) = substring(a.MC_SHORT, 4, 2)

	update z set
	  [local job short text]=a.MC_SHORT,
	  [local job medium text]=a.STEXT
	from 
	p0_job_family z
	left join
	(select distinct *
	from WAVE_NM_HRP1000
	where 
	convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='C'
	and plvar='01'
	and langu='E') a
	on z.[local job code] = a.objid

	update z
	set 
	[global job sub family short text] = b.mc_short ,
	[global job sub family medium text]  = b.stext 
	from p0_job_family z	
	join
	(
	select distinct * From p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and rsign = 'A'
	and otype='C'
	and plvar='01'
	and relat='450') a
	on z.[global job code] = a.objid
	join (
	select distinct *
	from WAVE_NM_HRP1000
	where convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='JF'
	and plvar='01'
	and langu='E'
	) b
	on a.sobid = b.objid

	update z
	set 
	[global job sub family short text] = b.mc_short ,
	[global job sub family medium text]  = b.stext 
	from p0_job_family z	
	join
	(
	select distinct * From p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and rsign = 'A'
	and otype='C'
	and plvar='01'
	and relat='450') a
	on z.[local job code] = a.objid
	join (
	select distinct *
	from WAVE_NM_HRP1000
	where convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='JF'
	and plvar='01'
	and langu='E'
	) b
	on a.sobid = b.objid

	update z
	set 
	[global job family] = ISNULL(b.sobid, ''),
	[global job sub family] = ISNULL(a.sobid, ''),
	--[Local Job Family]=ISNULL(b.sobid, ''),
	--[Local Job sub Family]=ISNULL(a.sobid, ''),
	[job family summary] = c.mc_short, 	
	[job family text]=c.stext

	--[global job medium text] = ISNULL(c.stext, ''),
	--[global job short text]  = ISNULL(c.mc_short, ''),
	--[Job Family Text]=ISNULL(a.mc_short, ''),
	--[global job sub family short text] = c.mc_short,
	--[global job sub family medium text]  = c.stext 
	from p0_job_family z
	join
	(select distinct * From p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and rsign = 'A'
	and otype='C'
	and plvar='01'
	and relat='450') a
	on z.[global job code] = a.objid
	join (
	select distinct *
	from p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and otype='JF'
	and plvar='01'
	and rsign = 'A'
	and relat = '450'
	) b
	on a.sobid = b.objid
	join (select distinct * 
	from WAVE_NM_HRP1000
	where convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='FN'
	and plvar='01'
	and langu='E') c
	on b.sobid = c.objid;

	update z
	set 
	[global job family] = ISNULL(b.sobid, ''),
	[global job sub family] = ISNULL(a.sobid, ''),
	--[Local Job Family]=ISNULL(b.sobid, ''),
	--[Local Job sub Family]=ISNULL(a.sobid, ''),
	[job family summary] = c.mc_short, 	
	[job family text]=c.stext

	--[global job medium text] = ISNULL(c.stext, ''),
	--[global job short text]  = ISNULL(c.mc_short, ''),
	--[Job Family Text]=ISNULL(a.mc_short, ''),
	--[global job sub family short text] = c.mc_short,
	--[global job sub family medium text]  = c.stext 
	from p0_job_family z
	join
	(select distinct * From p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and rsign = 'A'
	and otype='C'
	and plvar='01'
	and relat='450') a
	on z.[local job code] = a.objid
	join (
	select distinct *
	from p0_hrp1001
	where convert(date,REPLACE(begda, '.', '-'), 103)<=CAST('2021-03-10' AS DATE)
	and convert(date,REPLACE(endda, '.', '-'), 103)>=CAST('2021-03-10' AS DATE)
	and otype='JF'
	and plvar='01'
	and rsign = 'A'
	and relat = '450'
	) b
	on a.sobid = b.objid
	join (select distinct * 
	from WAVE_NM_HRP1000
	where convert(date,begda)<='2021-03-10'
	and convert(date,endda)>='2021-03-10'
	and otype='FN'
	and plvar='01'
	and langu='E') c
	on b.sobid = c.objid;
 
	--update p0_job_family set 
	--	[global job family]=IIF(substring([global job short text], 1, 2)='XX', substring([global job short text], 3, 3), [global job short text]),
	--	[global job sub family]=IIF(substring([global job short text], 1, 2)='XX', substring([global job short text], 6, 3), [global job short text])
	--SELECT * FROM p0_job_family

    --SELECT *, ROW_NUMBER() OVER(ORDER BY [JOB FAMILY], [JOB SUB FAMILY]) JFNUM INTO WAVE_JOB_FAMILY_GROUP FROM (	
	--	SELECT DISTINCT 'Local' [FIELD], [LOCAL JOB FAMILY] [JOB FAMILY], [LOCAL JOB SUB FAMILY] [JOB SUB FAMILY] FROM P0_JOB_FAMILY
	--	UNION ALL
	--	SELECT DISTINCT 'Global', [GLOBAL JOB FAMILY], [GLOBAL JOB SUB FAMILY] FROM P0_JOB_FAMILY
	--) A1 WHERE [JOB FAMILY] <> ''

	/* Data Source for Job Family Group */
    SELECT *, ROW_NUMBER() OVER( PARTITION BY [JOB FAMILY] ORDER BY [JOB SUB FAMILY]) JFNUM INTO WAVE_JOB_FAMILY_GROUP FROM (	
	    --SELECT DISTINCT 'Local' [FIELD], [LOCAL JOB FAMILY] [JOB FAMILY], [LOCAL JOB SUB FAMILY] [JOB SUB FAMILY] FROM P0_JOB_FAMILY
		--UNION ALL
		SELECT DISTINCT '' [FIELD], [GLOBAL JOB FAMILY] [JOB FAMILY], [GLOBAL JOB SUB FAMILY] [JOB SUB FAMILY] ,
		[global job sub family short text], [global job sub family medium text] FROM P0_JOB_FAMILY
	) A1 WHERE [JOB FAMILY] <> ''

	/* Data Source for Job Family */
	SELECT A1.*, A1.[JOB CODE] [OBJID], DENSE_RANK() OVER( PARTITION BY [JOB FAMILY] ORDER BY [JOB SUB FAMILY]) JFNUM INTO WAVE_JOB_FAMILY FROM (
	    SELECT *, ROW_NUMBER() OVER(PARTITION BY [JOB CODE] ORDER BY [JOB SHORT TEXT]) RNUM FROM (
			--SELECT 'Local' [FIELD], [LOCAL JOB CODE] [JOB CODE], [GLOBAL JOB FAMILY] [JOB FAMILY], [GLOBAL JOB SUB FAMILY] [JOB SUB FAMILY],
			--	   [LOCAL JOB SHORT TEXT] [JOB SHORT TEXT], [LOCAL JOB MEDIUM TEXT] [JOB MEDIUM TEXT], [JOB FAMILY TEXT], [job family summary],
			--	   '' [global job sub family short text], '' [global job sub family medium text]
			--	   FROM P0_JOB_FAMILY
			--UNION ALL
			SELECT 'Global' [FIELD], [GLOBAL JOB CODE] [JOB CODE], [GLOBAL JOB FAMILY] [JOB FAMILY], [GLOBAL JOB SUB FAMILY] [JOB SUB FAMILY], 
			       [GLOBAL JOB SHORT TEXT] [JOB SHORT TEXT], [GLOBAL JOB MEDIUM TEXT] [JOB MEDIUM TEXT], [JOB FAMILY TEXT], [job family summary],
			       [global job sub family short text], [global job sub family medium text]
				   FROM P0_JOB_FAMILY
		) A0
	) A1 --LEFT JOIN WD_HR_TR_JobProfile A2 ON A1.[JOB CODE]=A2.[JOB CODE5]
	WHERE [JOB FAMILY] <> '' AND ISNULL(A1.[JOB CODE], '')<> '' AND RNUM = 1

	--SELECT * FROM P0_JOB_FAMILY WHERE [Local Job Code]='30042342'
	--SELECT * FROM WAVE_JOB_FAMILY ORDER BY [JOB CODE] 
	--SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily WHERE [Job Profile12] NOT IN (SELECT DISTINCT [Job Code5] FROM WD_HR_TR_JobProfile)
	--SELECT DISTINCT [Job Code5] FROM WD_HR_TR_JobProfile WHERE [Job Code5] NOT IN (SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily)

	SELECT 
		 CAST(ROW_NUMBER() OVER(PARTITION BY [JOB SHORT TEXT] ORDER BY OBJID) AS VARCHAR(10))+[JOB SHORT TEXT] [Fields1]
		,ROW_NUMBER() OVER(ORDER BY [JOB CODE]) [Spreadsheet Key*2]
		,'' [Add Only3]
		,'' [Job Profile4]
		--,CAST(ROW_NUMBER() OVER(PARTITION BY MC_SHORT ORDER BY OBJID) AS VARCHAR(10))+MC_SHORT [Job Code5]
		,ISNULL([JOB CODE], '') [Job Code5]
		,'1900-01-01' [Effective Date6]
		,'' [Inactive7]
		,ISNULL([JOB MEDIUM TEXT], '') [Job Title8]
		,'' [Include Job Code in Name9]
		,'' [Job Profile Private Title10]
		,'' [Job Profile Summary11]
		,'' [Job Description12]
		,'' [Additional Job Description13]
		,'' [Work Shift Required14]
		,'' [Public Job15]
		,'' [Management Level16]
		,'' [Job Category17]
		,'' [Job Level18]
		,'' [Row ID*19]
		,'' [Delete20]
		,'' [Job Family*21]
		,'' [Row ID*22]
		,'' [Delete23]
		,'' [Company Insider Type*24]
		,'' [Referral Payment Plan25]
		,'' [Critical Job26]
		,'' [Difficulty to Fill27]
		,'' [Restrict to Country+28]
		,'' [Row ID*29]
		,'' [Delete30]
		,'' [Job Classifications*31]
		,'' [Row ID*32]
		,'' [Delete33]
		,'' [Country*34]
		,'' [Pay Rate Type35]
		,'' [Row ID*36]
		,'' [Delete37]
		,'' [Location Context*38]
		,'' [ISO 3166 1 Alpha 2 Code39]
		,'' [Job Exempt40]
		,'' [Row ID*41]
		,'' [Workers Compensation Code42]
		,'' [Delete43]
		,'' [Row ID*44]
		,'' [Responsibility Description*45]
		,'' [Required46]
		,'' [Delete47]
		,'' [Row ID*48]
		,'' [Worker Experience*49]
		,'' [Work Experience Rating50]
		,'' [Required51]
		,'' [Delete52]
		,'' [Row ID*53]
		,'' [Degree54]
		,'' [Field Of Study55]
		,'' [Required56]
		,'' [Delete57]
		,'' [Row ID*58]
		,'' [Language*59]
		,'' [Row ID*60]
		,'' [Language Ability Type*61]
		,'' [Language Proficiency62]
		,'' [Required63]
		,'' [Delete64]
		,'' [Row ID*65]
		,'' [Competency*66]
		,'' [Proficiency Rating67]
		,'' [Required68]
		,'' [Delete69]
		,'' [Row ID*70]
		,'' [Country71]
		,'' [Certification72]
		,'' [Name73]
		,'' [Issuer74]
		,'' [Required75]
		,'' [Row ID*76]
		,'' [Specialty77]
		,'' [Subspecialty+78]
		,'' [Delete79]
		,'' [Row ID*80]
		,'' [Training Name81]
		,'' [Description82]
		,'' [Training Type83]
		,'' [Required84]
		,'' [Delete85]
		,'' [Row ID*86]
		,'' [Skill87]
		,'' [Name88]
		,'' [Required89]
		,'' [Row ID*90]
		,'' [Field91]
		,'' [Integration Document Name92]
		,'' [Value93]
		,'' [Compensation Grade94]
		,'' [Compensation Grade Profile+95]
		,'' [Requirement Option96]
		,'' [Union+97]
		,'' [Requirement Option98]
		,'' [Allowed Student Award Sources+99]
      INTO WD_HR_TR_JobProfile
	  FROM WAVE_JOB_FAMILY;
    
	/* Job Key Code DGW */
	SELECT 
		 ISNULL([JOB CODE], '') [JobProfile]
		,CAST(ROW_NUMBER() OVER(PARTITION BY [JOB SHORT TEXT] ORDER BY OBJID) AS VARCHAR(10))+[JOB SHORT TEXT] [JobKeyCode] 
      INTO WD_HR_TR_JobKeyCode
	  FROM WAVE_JOB_FAMILY;


	/* Populating data in final table(Job Family Group) */
	--Add JFG in the end with Space
	SELECT 
		 [FIELD] [Fields1]
		,CAST(DENSE_RANK() OVER(ORDER BY [JOB SUB FAMILY]) AS VARCHAR(10))  [Spreadsheet Key*2]
		,'' [Add Only3]
		,'' [Job Family Group4]
		,ISNULL([JOB SUB FAMILY], '') [ID5]
		,'1900-01-01' [Effective Date6]
		,ISNULL([global job sub family medium text], '') [Name7]
		,ISNULL([global job sub family short text], '') [Summary8]
		,'' [Inactive9]
		,CAST(ROW_NUMBER() OVER(PARTITION BY [JOB SUB FAMILY] ORDER BY [JOB SUB FAMILY], [JOB FAMILY]) AS VARCHAR(10)) [Row ID*10]
		,'' [Delete11]
		,IIF(ISNULL([JOB FAMILY], '') <> '', CAST(JFNUM AS VARCHAR(20))+ISNULL([JOB FAMILY], ''), '') [Job Family*12]
		,'' [Job Family Name13]
		,'' [Job Family Summary14]
		,'' [Inactive15]
		,'' [Row ID*16]
		,'' [Job Profile17]
		,'' [Job Profile Name18]
		,'' [Management Level19]
		,'' [Job Category20]
		,'' [Job Family+21]
		,'' [Work Shift Required23]
		,'' [Row ID*24]
		,'' [Delete25]
		,'' [Location Context*26]
		,'' [ISO 3166 1 Alpha 2 Code27]
		,'' [Job Exempt28]
		,'' [Critical Job29]
		,'' [Difficulty to Fill30]
      INTO WD_HR_TR_JobFamilyGroup
	 FROM WAVE_JOB_FAMILY_GROUP

	/* Populating data in final table(Job Family) */
	SELECT 
		 [FIELD] [Fields1]
		,CAST(DENSE_RANK() OVER(ORDER BY [JOB FAMILY], [JOB SUB FAMILY]) AS VARCHAR(10)) [Spreadsheet Key*2]
		,'' [Add Only3]
		,'' [Job Family4]
		,IIF(ISNULL([JOB FAMILY], '') <> '', CAST(JFNUM AS VARCHAR(20))+ISNULL([JOB FAMILY], ''), '') [ID5]
		,'1900-01-01' [Effective Date6]
		,ISNULL([JOB FAMILY TEXT], '') [Name7]
		,ISNULL([job family summary], '') [Summary8]
		,'' [Inactive9]
		,CAST(ROW_NUMBER() OVER(PARTITION BY [JOB FAMILY], [JOB SUB FAMILY] ORDER BY [JOB FAMILY], [JOB SUB FAMILY]) AS VARCHAR(10)) [Row ID*10]
		,'' [Delete11]
		,[OBJID] [Job Profile12]
		,'' [Row ID*13]
		,'' [Field14]
		,'' [Integration Document Name15]
		,'' [Value16]
      INTO WD_HR_TR_JobFamily
	  FROM WAVE_JOB_FAMILY

	  /* Job profile Edit Position */
	  EXEC PROC_WAVE_NM_AUTOMATE_JOB_PROFILE_EDIT_POSITION 'P0', 'Job Profilev Edit Position', '2021-03-10'

	  /* Job Profile, Family Group and Family */
	  DECLARE @JOB_PROFILE_ERROR_LIST TABLE (
	       [JOB CODE]                VARCHAR(100),
		   [ERROR TYPE]              VARCHAR(100), 
		   [ERROR STRING]            NVARCHAR(2000)
	  );
	  INSERT INTO @JOB_PROFILE_ERROR_LIST
	  SELECT DISTINCT [Job Profile12], 'Job Family disparity' [Error Type], 'Job family not present in Job Profile' [Error String] 
	      FROM WD_HR_TR_JobFamily WHERE [Job Profile12] NOT IN (SELECT DISTINCT [Job Code5] FROM WD_HR_TR_JobProfile)
	  UNION ALL
	  SELECT DISTINCT [Job Code5], 'Job Family disparity' [Error Type], 'Job Profile not present in Job Family' [Error String] 
	     FROM WD_HR_TR_JobProfile WHERE [Job Code5] NOT IN (SELECT DISTINCT [Job Profile12] FROM WD_HR_TR_JobFamily)
	  UNION ALL
	  SELECT DISTINCT [Job Profile], 'Job Profile disparity' [Error Type], 'Job Profile not present in Edit Position' [Error String] 
	     FROM WD_HR_TR_AUTOMATED_JOB_PROFILE_EDIT_POSITION WHERE [Job Profile] NOT IN (SELECT DISTINCT [Job Code5] FROM WD_HR_TR_JobProfile)

	  EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists NOVARTIS_DATA_MIGRATION_JOB_PROFILE_VALIDATION;';
	  SELECT 
		'P0'                                  Wave
		,'Job Profile'                        [Report Name]
		,[JOB CODE]                           [Job Code]
		,[ERROR TYPE]                         [Error Type]
		,[ERROR STRING]                       [Error Text]
	  INTO NOVARTIS_DATA_MIGRATION_JOB_PROFILE_VALIDATION 
	  FROM @JOB_PROFILE_ERROR_LIST
END
