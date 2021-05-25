USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT] Script Date: 5/13/2021 11:57:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS WD_HR_TR_SUP_ORG;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '
	CREATE TABLE WD_HR_TR_SUP_ORG
	(
		[Supervisory Organization Key] int,
		[Add Only] nvarchar(255),
		[Supervisory Organization Reference Descriptor] nvarchar(255),
		[Supervisory Organization Reference ID type] nvarchar(255),
		[Supervisory Organization Reference ID] nvarchar(255),
		[Effective Date] nvarchar(255),
		[ID] nvarchar(255),
		[Include Organization ID in Name] nvarchar(255),
		[Organization Name] nvarchar(255),
		[Phonetic Name] nvarchar(255),
		[Organization Code] nvarchar(255),
		[Include Organization Code in Name] nvarchar(255),
		[Organization Active] nvarchar(255),
		[Availability Date] nvarchar(255),
		[Organization Visibility Reference Descriptor] nvarchar(255),
		[Organization Visibility Reference ID type] nvarchar(255),
		[Organization Visibility Reference ID] nvarchar(255),
		[External URL Reference Descriptor] nvarchar(255),
		[External URL Reference ID type] nvarchar(255),
		[External URL Reference ID] nvarchar(255),
		[Organization Subtype Reference Descriptor] nvarchar(255),
		[Organization Subtype Reference ID type] nvarchar(255),
		[Organization Subtype Reference ID] nvarchar(255),
		[Supervisory Organization Superior Reference Descriptor] nvarchar(255),
		[Supervisory Organization Superior Reference ID type] nvarchar(255),
		[Supervisory Organization Superior Reference ID] nvarchar(255),
		[Include Leader in Name] nvarchar(255),
		[Job Management Enabled] nvarchar(255),
		[Position Management Enabled] nvarchar(255),
		[Hiring Freeze] nvarchar(255),
		[Primary Location Reference Descriptor] nvarchar(255),
		[Primary Location Reference ID type] nvarchar(255),
		[Primary Location Reference ID] nvarchar(255)
	);';

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS WD_HR_TR_SUP_ORG_FLAT;';
	SELECT * INTO WD_HR_TR_SUP_ORG_FLAT FROM WD_HR_TR_SUP_ORG where 1=2;

	DECLARE @SQL AS VARCHAR(5000);
	SET @SQL='drop table if exists p0_sup_org_source;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL

	SET @SQL='select *,cast(null as  nvarchar(20)) opmpositionid,
	cast(null as  nvarchar(20))   cpmpositionid,
	cast(null as  nvarchar(20))   hrmpositionid ,
	cast(null as  nvarchar(8))   persno_new , 
	cast(null as  nvarchar(20))   flag 
	into p0_sup_org_source From adhocquery
				 where empstatus in (''1'', ''3'')
				  and empgroup not in (''5'')  /*  remove this for p1 */
				 and isnull(companycode,'''') not in (''IRP0'',''IRS0'') ;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH @SQL
	--SELECT * FROM adhocquery

	insert into p0_sup_org_Source
	values
	('','25002781','Khan Shazli',
	'3','Active','SG04','Novartis (S) Pte Ltd'
	,'SG21','SG PH Commercial','0010','Mapletree Busin',
	'3','Expat','ZM','LTA - Mgr. - home'
	,'S1','SG Payroll Area 1',
	'10061181','Global Employment Company',
	'20838622','Expat_VN_Franchise Head, Ophthalmology'
	,'30014558','Franchise/BU Management Band 4'
	,'8.00','5.00','160.00','100.00'
	,'No','25004753','Deepak, Priya','','','','','','','','','','','','','','','','','','','','','');

	/* Remove population not PA0001, PA0002 and Empgroup 8 */
	delete from p0_sup_org_source where persno not in (Select distinct pernr from p0_pa0001);
    delete from p0_sup_org_source where persno not in (Select distinct pernr from p0_pa0002);
    delete from p0_Sup_org_Source where empgroup='8';


USE Prod_DataClean
GO
	
DECLARE @which_date AS VARCHAR(20)='2021-03-10';
EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'DROP TABLE IF EXISTS HRM_INFO_LKUP;';
SELECT * INTO HRM_INFO_LKUP FROM (
	SELECT HRM_ORGUNIT.OBJID POSITION, HRM_ORGUNIT.SOBID ORGUNIT, HRM_POSITION.SOBID [HRM POSITION], HRM_PERSON.SOBID [HRM PERSON] FROM
	(
	SELECT OBJID, SOBID FROM P0_HRP1001 A1
		 WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			   CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			   OTYPE = 'S' AND
			   RSIGN = 'A' AND
			   SCLAS = 'O' AND 
			   RELAT = '003' AND
			   PLVAR = '01'
	) 
	HRM_ORGUNIT LEFT JOIN
	(
	SELECT OBJID, SOBID FROM P0_HRP1001 A1
		 WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			   CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			   OTYPE = 'O' AND
			   RSIGN = 'A' AND
			   SCLAS = 'S' AND 
			   RELAT = 'Z12' AND
			   PLVAR = '01'
	)
	HRM_POSITION ON HRM_ORGUNIT.SOBID=HRM_POSITION.OBJID
	LEFT JOIN
	(
	SELECT OBJID, SOBID FROM P0_HRP1001 A1
		 WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
			   CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
			   OTYPE = 'S' AND
			   RSIGN = 'A' AND
			   SCLAS = 'P' AND 
			   RELAT = '008' AND
			   PLVAR = '01'
	)
	HRM_PERSON ON HRM_POSITION.SOBID=HRM_PERSON.OBJID
) A1;

WITH CTE AS (
    SELECT ORGUNIT, ORGUNIT [NEXT LEVEL ORGUNIT], CAST(NULL AS NVARCHAR(255)) [HRM POSITION] FROM HRM_INFO_LKUP WHERE [HRM POSITION] IS NULL
	UNION ALL
	SELECT A2.ORGUNIT, A1.SOBID [NEXT LEVEL ORGUNIT], NULL [HRM POSITION] 
	     FROM (SELECT OBJID, SOBID FROM P0_HRP1001
		          WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
					   CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
					   OTYPE = 'O' AND
					   RSIGN = 'A' AND
					   SCLAS = 'O' AND 
					   RELAT = '002' AND 
					   PLVAR = '01'
		   ) A1
	       INNER JOIN CTE A2 ON A1.OBJID=A2.[NEXT LEVEL ORGUNIT]
		   --INNER JOIN (SELECT OBJID, SOBID FROM P0_HRP1001
					--	 WHERE CONVERT(DATE, REPLACE(BEGDA,'.','/'), 103) <= CAST(@which_date AS DATE) AND
					--		   CONVERT(date,replace(ENDDA,'.','/'),103) >= CAST(@which_date AS DATE) AND
					--		   OTYPE = 'O' AND
					--		   RSIGN = 'A' AND
					--		   SCLAS = 'S' AND 
					--		   RELAT = 'Z12' AND
					--		   PLVAR = '01'
		   --) A3 ON A3.OBJID=A1.[SOBID]
)
SELECT DISTINCT ORGUNIT FROM CTE;

--SELECT * FROM HRM_INFO_LKUP




--https://haughtcodeworks.com/blog/software-development/recursive-sql-queries-using-ctes/

	update [p0_SUP_ORG_SOURCE] 
	set flag = 'Y',
	opmpersno = hrmpersno
	where OPMPersNo in (
	select distinct OPMPersNo as pers from [p0_SUP_ORG_SOURCE] 
	except
	select distinct Persno as pers from [p0_SUP_ORG_SOURCE] );
  
	/* Assigning Company personnel number to Operational personnel number, If OPM not exists */ 
	update p0_sup_org_source
	set opmpersno = cpmpersno
	where isnull(opmpersno,'') in ('', '00000000')
	and isnull(cpmpersno,'') not in ('','00000000');  
   
    /* Delete said company code population */ 
	delete from p0_sup_org_Source where companycode in ('mx19', 'u339', 'ec06','PE05');

	/*
	select persno,'manager is changed from 61001388  to 10040374 as emp group 4 data is not there in Infotype 0002'
	From p0_sup_org_Source 
	where opmpersno = '61001388';
	*/
	 update p0_sup_org_Source set opmpersno = '10040374' where opmpersno = '61001388';

	 /*
	 select persno,'manager is changed to 10030204 pamela malone as orgunit is 00000000'
	From p0_sup_org_Source
	where orgunit = '00000000';
	*/
	 update p0_sup_org_Source set flag = 'P2', opmpersno = '10030204' where orgunit = '00000000';
 
	-- select persno,'manager is changed to 10030204 pamela malone as both opmpersno and hrmpersno are 00000000'
	--From p0_sup_org_Source
	--where opmpersno = '00000000'
	-- and hrmpersno = '00000000';
	update p0_sup_org_Source set flag = 'P2', opmpersno = '10030204' where opmpersno = '00000000' and hrmpersno = '00000000';
	update p0_sup_org_Source set flag = 'P3', opmpersno = '10030204' where persno  in ( '85007480','85006068','04010220' );

 
	update p0_sup_org_Source set flag = 's1', opmpersno = '02110043' where persno  in ( '02001029');
 
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists p0_hrp1000_multiple_position;
	                                         drop table if exists p0_hrp1000_position;';
	select objid 
	into p0_hrp1000_multiple_position
	from (
	select objid,count(*) cnt 
	from p0_hrp1000 
	where plvar='01'
	and OTYPE = 'S'
	and convert(date,begda)<=cast(@which_date as date)
	and convert(date,endda)>=cast(@which_date as date)
	group by objid ) a
	where cnt > 1;	

	select * into p0_hrp1000_position 
	from (
	select *,row_number() over(partition by objid order by convert(date,begda) desc) rnk 
	from (
	select * 
	from p0_hrp1000 
	where plvar='01'
	and OTYPE = 'S'
	and convert(date,begda)<=cast(@which_date as date)
	and convert(date,endda)>=cast(@which_date as date)
	and objid not in (Select objid from p0_hrp1000_multiple_position)
	union
	select *
	from p0_hrp1000 
	where plvar='01'
	and OTYPE = 'S'
	and langu = 'E'
	and convert(date,begda)<=cast(@which_date as date)
	and convert(date,endda)>=cast(@which_date as date)
	and objid   in (Select objid from p0_hrp1000_multiple_position)  )   a ) b
	where rnk = 1;

	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists P0_SUP_ORG;';

	/* Assigning Supervisory and Superior orgunit */
    select a.persno,
	       a.companycode,
		   a.name,
		   a.PersArea,
		   a.positionid,
		   a.positiontext,
		   a.opmpersno,
		   a.opmpositionID as superior_position_id,
		   a.opmname,
		   b.persno as superior_persno,
           b.name  as sup_org_manager_name,
		   a.orgunit as 'old_org',
		   a.OrgunitDesc as 'old_org_name',
		   b.positiontext as superior_positiontext,
           b.OrgUnit   as 'sup_org',
           b.OrgUnitdesc   as 'sup_org_name',
           c.OrgUnit as 'Superior_Org',
		   c.persno as superior_opmpersno,
		   a.flag,
           b.flag as superior_flag,
           b.persno_new superior_persno_new,
           b.persarea as superior_persarea,
           a.persno_new, 
           cast(null as nvarchar(10)) as dup_flag  
   into p0_SUP_ORG
   from [p0_SUP_ORG_SOURCE] a
      left outer join [p0_SUP_ORG_SOURCE] b on a.OPMpositionid = b.positionid
      left outer join [p0_SUP_ORG_SOURCE] c on b.OPMpositionID = c.positionID;

update aa
set 
aa.superior_org = bb.superior_org,
aa.sup_org_manager_name = bb.sup_org_manager_name,
aa.superior_persno = bb.superior_persno,
aa.superior_position_id = bb.superior_position_id,
aa.superior_persno_new = bb.superior_persno_new
 from 
(select * from p0_Sup_org where superior_org = sup_org ) aa
  join
(select a.* from p0_Sup_org a 
   join 
(select distinct sup_org,superior_org,superior_persno,superior_position_id from p0_Sup_org
where superior_org = sup_org) b
on a.sup_org = b.superior_org
where a.persno = b.superior_persno ) bb
on aa.superior_persno= bb.persno ;

 
 
	update z
	set z.sup_org =new_org	,
	z.sup_org_name = new_sup_org_name
	 from p0_sup_org z
	 join
	 (
	select  persno,33330000+dense_rank() over( order by a.sup_org,a.superior_org,a.sup_org_manager_name) new_org,
	b.superior_positiontext new_sup_org_name 
  From p0_sup_org a
	join (
	select distinct  a.sup_org,a.superior_org,a.sup_org_manager_name,a.superior_positiontext,
	DENSE_RANK() over(partition by a.sup_org  order by a.superior_org,a.sup_org_manager_name) rnk
	 from p0_sup_org a
	join (
	select sup_org,
	count(distinct concat(superior_org,sup_org_manager_name)) cnt 
	From 
	(select distinct sup_org,superior_org,sup_org_manager_name 
	from p0_sup_org) a
	group by sup_org
	having count(distinct concat(superior_org,sup_org_manager_name)) >1 ) b
	on a.sup_org = b.sup_org  ) b
	on a.sup_org = b.sup_org
	and a.superior_org = b.superior_org
	and a.sup_org_manager_name = b.sup_org_manager_name
	where rnk > 1 ) c
	on z.persno = c.persno;

	update p0_Sup_org
	set superior_persno = '',
	superior_persno_new = '',
	superior_org = '',
	superior_position_id = '',
	sup_org = '99999901',
	sup_org_name = 'Top node'
	where persno = '02105401';


	update p0_Sup_org
	set superior_persno = '02105401',
	superior_position_id = '20002609',
	superior_positiontext='Chief Executive Officer of Novartis',
	superior_persno_new = '02105401',
	superior_org = '99999901'
	where superior_persno = '02105401';



select distinct z.persno,z.sup_Org + ' has more than one sup org name, so only one is assigned'
	from  p0_sup_org z
 join
 ( select distinct sup_Org,sup_org_name from (
  select   sup_org,sup_org_name,dense_rank() over(partition by sup_org order by sup_org_name) rnk
    from p0_sup_org ) a
	where rnk > 1) a
	on a.sup_org = z.sup_org
	and a.sup_org_name = z.sup_org_name;


select persno,'Sup_org ' + sup_org + ' created to avoid one to many issues '
From p0_sup_org where sup_org like '333%';

 update z
 set z.sup_org_name = b.sup_org_name 
 from  p0_sup_org z
 join
 ( select distinct sup_Org,sup_org_name from (
  select   sup_org,sup_org_name,dense_rank() over(partition by sup_org order by sup_org_name) rnk
    from p0_sup_org ) a
	where rnk > 1) a
	on a.sup_org = z.sup_org
	and a.sup_org_name = z.sup_org_name
	join
  (select distinct sup_org,sup_org_name from (
  select   sup_org,sup_org_name,dense_rank() over(partition by sup_org order by sup_org_name) rnk
    from p0_sup_org ) a
	where rnk = 1) b
	on a.sup_org = b.sup_org ;





END 
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT', 'P' ) IS NOT NULL   
    DROP PROCEDURE PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT;  
GO
CREATE PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_SUPORG_POSITION_MANAGEMENT]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate Sup Org and Position Management(Novartis Migration)  ******/

	--EXEC [PROC_WAVE_NM_AUTOMATE_SUP_ORG] 'P0', 'Sup Org', '2021-03-10'
	PRINT @which_wavestage;
	PRINT @which_report;
	PRINT @which_date;

	BEGIN TRY 
		DECLARE @SQL AS VARCHAR(5000);

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
