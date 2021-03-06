USE [Prod_DataClean]
GO
/****** Object:  StoredProcedure [dbo].[PROC_WAVE_NM_AUTOMATE_SUP_ORG]    Script Date: 04/09/2021 9:53:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_WAVE_NM_AUTOMATE_SUP_ORG]
    @which_wavestage AS VARCHAR(50),
	@which_report AS VARCHAR(500),
	@which_date AS VARCHAR(50)
AS
BEGIN
	/****** Script to automate COST_CENTER(Novartis Migration)  ******/
	--EXEC [PROC_WAVE_NM_AUTOMATE_SUP_ORG] 'P0', 'Sup Org', '2021-03-10'
	PRINT @which_wavestage;
	PRINT @which_report;
	PRINT @which_date;

	BEGIN TRY 
	   
DECLARE @SQL AS VARCHAR(5000);





 DROP TABLE IF EXISTS WD_HR_TR_SUP_ORG
CREATE TABLE WD_HR_TR_SUP_ORG
([Supervisory Organization Key] int,
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
);


DROP TABLE IF EXISTS WD_HR_TR_SUP_ORG_FLAT;
SELECT * INTO WD_HR_TR_SUP_ORG_FLAT FROM WD_HR_TR_SUP_ORG where 1=2;

DROP TABLE IF EXISTS WD_HR_TR_CREATE_POSITION;

CREATE TABLE WD_HR_TR_CREATE_POSITION
([Create Position Key] int,
[Auto Complete] nvarchar(255),
[Run Now] nvarchar(255),
[Comment] nvarchar(255),
[Worker Reference Descriptor] nvarchar(255),
[Worker Reference ID type] nvarchar(255),
[Worker Reference ID] nvarchar(255),
[Supervisory Organization Reference Descriptor] nvarchar(255),
[Supervisory Organization Reference ID type] nvarchar(255),
[Supervisory Organization Reference ID] nvarchar(255),
[Position Request Reason Reference Descriptor] nvarchar(255),
[Position Request Reason Reference ID type] nvarchar(255),
[Position Request Reason Reference ID] nvarchar(255),
[Position ID] nvarchar(255),
[Job Posting Title] nvarchar(255),
[Job Description Summary] nvarchar(255),
[Job Description] nvarchar(255),
[Critical Job] nvarchar(255),
[Difficulty to Fill Reference Descriptor] nvarchar(255),
[Difficulty to Fill Reference ID type] nvarchar(255),
[Difficulty to Fill Reference ID] nvarchar(255),
[Responsibility Qualification Replacement - Delete] nvarchar(255),
[Work Experience Qualification Replacement - Delete] nvarchar(255),
[Education Qualification Replacement - Delete] nvarchar(255),
[Language Qualification Replacement - Delete] nvarchar(255),
[Competency Qualification Replacement - Delete] nvarchar(255),
[Certification Qualification Replacement - Delete] nvarchar(255),
[Training Qualification Replacement - Delete] nvarchar(255),
[Skill Qualification Replacement - Delete] nvarchar(255),
[Availability Date] nvarchar(255),
[Earliest Hire Date] nvarchar(255),
[Worker Type Reference Descriptor] nvarchar(255),
[Worker Type Reference ID type] nvarchar(255),
[Worker Type Reference ID] nvarchar(255),
[Time Type Reference Descriptor] nvarchar(255),
[Time Type Reference ID type] nvarchar(255),
[Time Type Reference ID] nvarchar(255),
[Edit Assign Organization Sub Process - Auto Complete Mutex - Auto Complete] nvarchar(255),
[Edit Assign Organization Sub Process - Auto Complete Mutex - Skip] nvarchar(255),
[Edit Assign Organization Sub Process - Business Process Comment Data - Comment] nvarchar(255),
[Edit Assign Organization Sub Process - Business Process Comment Data - Worker Reference Descriptor] nvarchar(255),
[Edit Assign Organization Sub Process - Business Process Comment Data - Worker Reference ID type] nvarchar(255),
[Edit Assign Organization Sub Process - Business Process Comment Data - Worker Reference ID] nvarchar(255),
[Request Default Compensation Sub Process - Auto Complete Mutex - Auto Complete] nvarchar(255),
[Request Default Compensation Sub Process - Auto Complete Mutex - Skip] nvarchar(255),
[Request Default Compensation Sub Process - Business Process Comment Data - Comment] nvarchar(255),
[Request Default Compensation Sub Process - Business Process Comment Data - Worker Reference Descriptor] nvarchar(255),
[Request Default Compensation Sub Process - Business Process Comment Data - Worker Reference ID type] nvarchar(255),
[Request Default Compensation Sub Process - Business Process Comment Data - Worker Reference ID] nvarchar(255),
[Primary Compensation Basis] nvarchar(255),
[Primary Compensation Basis Amount Change] nvarchar(255),
[Primary Compensation Basis Percent Change] nvarchar(255),
[Compensation Package Reference Descriptor] nvarchar(255),
[Compensation Package Reference ID type] nvarchar(255),
[Compensation Package Reference ID] nvarchar(255),
[Compensation Grade Reference Descriptor] nvarchar(255),
[Compensation Grade Reference ID type] nvarchar(255),
[Compensation Grade Reference ID] nvarchar(255),
[Compensation Grade Profile Reference Descriptor] nvarchar(255),
[Compensation Grade Profile Reference ID type] nvarchar(255),
[Compensation Grade Profile Reference ID] nvarchar(255),
[Compensation Step Reference Descriptor] nvarchar(255),
[Compensation Step Reference ID type] nvarchar(255),
[Compensation Step Reference ID] nvarchar(255),
[Pay Plan Data - Replace] nvarchar(255),
[Unit Salary Plan Data - Replace] nvarchar(255),
[Allowance Plan Non-Unit Based Data - Replace] nvarchar(255),
[Allowance Plan Unit Based Data - Replace] nvarchar(255),
[Bonus Plan Data - Replace] nvarchar(255),
[Merit Plan Data - Replace] nvarchar(255),
[Commission Plan Data - Replace] nvarchar(255),
[Stock Plan Data - Replace] nvarchar(255),
[Period Salary Plan Data - Replace] nvarchar(255),
[Calculated Plan Data - Replace] nvarchar(255),
[Assign Pay Group Sub Process - Auto Complete Mutex - Auto Complete] nvarchar(255),
[Assign Pay Group Sub Process - Auto Complete Mutex - Skip] nvarchar(255),
[Assign Pay Group Sub Process - Business Process Comment Data - Comment] nvarchar(255),
[Assign Pay Group Sub Process - Business Process Comment Data - Worker Reference Descriptor] nvarchar(255),
[Assign Pay Group Sub Process - Business Process Comment Data - Worker Reference ID type] nvarchar(255),
[Assign Pay Group Sub Process - Business Process Comment Data - Worker Reference ID] nvarchar(255),
[Pay Group Reference Descriptor] nvarchar(255),
[Pay Group Reference ID type] nvarchar(255),
[Pay Group Reference ID] nvarchar(255),
[Assign Costing Allocation Sub Process - Auto Complete Mutex - Auto Complete] nvarchar(255),
[Assign Costing Allocation Sub Process - Auto Complete Mutex - Skip] nvarchar(255),
[Assign Costing Allocation Sub Process - Business Process Comment Data - Comment] nvarchar(255),
[Assign Costing Allocation Sub Process - Business Process Comment Data - Worker Reference Descriptor] nvarchar(255),
[Assign Costing Allocation Sub Process - Business Process Comment Data - Worker Reference ID type] nvarchar(255),
[Assign Costing Allocation Sub Process - Business Process Comment Data - Worker Reference ID] nvarchar(255),
[Costing Allocation Level Reference Descriptor] nvarchar(255),
[Costing Allocation Level Reference ID type] nvarchar(255),
[Costing Allocation Level Reference ID] nvarchar(255),
[Costing Allocation Earning Reference Descriptor] nvarchar(255),
[Costing Allocation Earning Reference ID type] nvarchar(255),
[Costing Allocation Earning Reference ID] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
);

DROP TABLE IF EXISTS WD_HR_TR_JOB_PROFILE;

CREATE TABLE WD_HR_TR_JOB_PROFILE
(
[Create Position Key] nvarchar(255),
[Job Profile Reference Key] nvarchar(255),
[Descriptor] nvarchar(255),
[ID type] nvarchar(255),
[ID] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
);


DROP TABLE IF EXISTS WD_HR_TR_COMPANY_ASSIGNMENTS;

CREATE TABLE WD_HR_TR_COMPANY_ASSIGNMENTS
(
[Create Position Key] nvarchar(255),
[Company Assignments Reference Key] nvarchar(255),
[Descriptor] nvarchar(255),
[ID type] nvarchar(255),
[ID] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
);

DROP TABLE IF EXISTS WD_HR_TR_COST_CENTER_ASSIGNMENTS;

CREATE TABLE WD_HR_TR_COST_CENTER_ASSIGNMENTS
(
[Create Position Key] nvarchar(255),
[Cost Center Assignments Reference Key] nvarchar(255),
[Descriptor] nvarchar(255),
[ID type] nvarchar(255),
[ID] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
);



DROP TABLE IF EXISTS WD_HR_TR_HIRE_EMPLOYEES;
CREATE TABLE WD_HR_TR_HIRE_EMPLOYEES
(
[Implementation Employee Data Key] nvarchar(255),
[Employee ID] nvarchar(255),
[Hire Date] nvarchar(255),
[Continuous Service Date] nvarchar(255),
[Probation Start Date] nvarchar(255),
[Probation End Date] nvarchar(255),
[End Employment Date] nvarchar(255),
[Position Start Date for Conversion] nvarchar(255),
[Job Profile Start Date for Conversion] nvarchar(255),
[Benefits Service Date] nvarchar(255),
[Company Service Date] nvarchar(255),
[Create Payroll Extract] nvarchar(255),
[Applicant Reference Descriptor] nvarchar(255),
[Applicant Reference ID type] nvarchar(255),
[Applicant Reference ID] nvarchar(255),
[Employee Type Reference Descriptor] nvarchar(255),
[Employee Type Reference ID type] nvarchar(255),
[Employee Type Reference ID] nvarchar(255),
[Hire Reason Reference Descriptor] nvarchar(255),
[Hire Reason Reference ID type] nvarchar(255),
[Hire Reason Reference ID] nvarchar(255),
[Position ID] nvarchar(255),
[Position Title] nvarchar(255),
[Business Title] nvarchar(255),
[Default Weekly Hours] nvarchar(255),
[Scheduled Weekly Hours] nvarchar(255),
[Working Time Value] nvarchar(255),
[Organization Reference Descriptor] nvarchar(255),
[Organization Reference ID type] nvarchar(255),
[Organization Reference ID] nvarchar(255),
[Position Reference Descriptor] nvarchar(255),
[Position Reference ID type] nvarchar(255),
[Position Reference ID] nvarchar(255),
[Job Profile Reference Descriptor] nvarchar(255),
[Job Profile Reference ID type] nvarchar(255),
[Job Profile Reference ID] nvarchar(255),
[Location Reference Descriptor] nvarchar(255),
[Location Reference ID type] nvarchar(255),
[Location Reference ID] nvarchar(255),
[Work Space Reference Descriptor] nvarchar(255),
[Work Space Reference ID type] nvarchar(255),
[Work Space Reference ID] nvarchar(255),
[Position Time Type Reference Descriptor] nvarchar(255),
[Position Time Type Reference ID type] nvarchar(255),
[Position Time Type Reference ID] nvarchar(255),
[Work Shift Reference Descriptor] nvarchar(255),
[Work Shift Reference ID type] nvarchar(255),
[Work Shift Reference ID] nvarchar(255),
[Work Hours Profile Reference Descriptor] nvarchar(255),
[Work Hours Profile Reference ID type] nvarchar(255),
[Work Hours Profile Reference ID] nvarchar(255),
[Working Time Frequency Reference Descriptor] nvarchar(255),
[Working Time Frequency Reference ID type] nvarchar(255),
[Working Time Frequency Reference ID] nvarchar(255),
[Working Time Unit Reference Descriptor] nvarchar(255),
[Working Time Unit Reference ID type] nvarchar(255),
[Working Time Unit Reference ID] nvarchar(255),
[Pay Rate Type Reference Descriptor] nvarchar(255),
[Pay Rate Type Reference ID type] nvarchar(255),
[Pay Rate Type Reference ID] nvarchar(255),
[Annual Work Period Reference Descriptor] nvarchar(255),
[Annual Work Period Reference ID type] nvarchar(255),
[Annual Work Period Reference ID] nvarchar(255),
[Disbursement Plan Period Reference Descriptor] nvarchar(255),
[Disbursement Plan Period Reference ID type] nvarchar(255),
[Disbursement Plan Period Reference ID] nvarchar(255),
[Workers  Compensation Code Override Reference Descriptor] nvarchar(255),
[Workers  Compensation Code Override Reference ID type] nvarchar(255),
[Workers  Compensation Code Override Reference ID] nvarchar(255),
[Primary Compensation Basis] nvarchar(255),
[Compensation Package Name] nvarchar(255),
[Compensation Grade Name] nvarchar(255),
[Compensation Profile Name] nvarchar(255),
[Compensation Grade Profile Reference - Compensation Grade Reference - Compensation Grade Name] nvarchar(255),
[Compensation Step Name] nvarchar(255),
[Progression Start Date] nvarchar(255),
[Payroll File Number] nvarchar(255),
[Employee Type] nvarchar(255),
[Frequency Name] nvarchar(255),
[Pay Group ID] nvarchar(255),
[Payroll Entity ID] nvarchar(255),
[User Name] nvarchar(255),
[Session Timeout Minutes] nvarchar(255),
[Account Disabled] nvarchar(255),
[Account Expiration Date] nvarchar(255),
[Account Locked] nvarchar(255),
[Required New Password At Next Login] nvarchar(255),
[Show User Name in Browser Window] nvarchar(255),
[Display XML Icon on Reports] nvarchar(255),
[Enable Workbox] nvarchar(255),
[Allow Mixed-Language Transactions] nvarchar(255),
[Exempt from Delegated Authentication] nvarchar(255),
[Passcode Exempt] nvarchar(255),
[Passcode Grace Period Enabled] nvarchar(255),
[Passcode Grace Period Login Remaining Count] nvarchar(255),
[OpenID Identifier] nvarchar(255),
[OpenID Internal Identifier] nvarchar(255),
[OpenID Connect Internal Identifier] nvarchar(255),
[Simplified View] nvarchar(255),
[Locale Reference Descriptor] nvarchar(255),
[Locale Reference ID type] nvarchar(255),
[Locale Reference ID] nvarchar(255),
[User Language Reference Descriptor] nvarchar(255),
[User Language Reference ID type] nvarchar(255),
[User Language Reference ID] nvarchar(255),
[Preferred Search Scope Reference Descriptor] nvarchar(255),
[Preferred Search Scope Reference ID type] nvarchar(255),
[Preferred Search Scope Reference ID] nvarchar(255),
[Delegated Authentication Integration System Reference Descriptor] nvarchar(255),
[Delegated Authentication Integration System Reference ID type] nvarchar(255),
[Delegated Authentication Integration System Reference ID] nvarchar(255),
[Password] nvarchar(255),
[Generate Random Password] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
)

DROP TABLE IF EXISTS WD_HR_TR_CONTRACT_CONTINGENT_WORKER;
CREATE TABLE WD_HR_TR_CONTRACT_CONTINGENT_WORKER
([Contingent Worker Data Key] nvarchar(255),
[Contingent Worker ID] nvarchar(255),
[Contract Begin Date] nvarchar(255),
[Contract End Date] nvarchar(255),
[Position Start Date for Conversion] nvarchar(255),
[Applicant Reference Descriptor] nvarchar(255),
[Applicant Reference ID type] nvarchar(255),
[Applicant Reference ID] nvarchar(255),
[Supplier Reference Descriptor] nvarchar(255),
[Supplier Reference ID type] nvarchar(255),
[Supplier Reference ID] nvarchar(255),
[Contingent Worker Type Reference Descriptor] nvarchar(255),
[Contingent Worker Type Reference ID type] nvarchar(255),
[Contingent Worker Type Reference ID] nvarchar(255),
[Contract Worker Reason Reference Descriptor] nvarchar(255),
[Contract Worker Reason Reference ID type] nvarchar(255),
[Contract Worker Reason Reference ID] nvarchar(255),
[Position ID] nvarchar(255),
[Position Title] nvarchar(255),
[Business Title] nvarchar(255),
[Default Weekly Hours] nvarchar(255),
[Scheduled Weekly Hours] nvarchar(255),
[Working Time Value] nvarchar(255),
[Organization Reference Descriptor] nvarchar(255),
[Organization Reference ID type] nvarchar(255),
[Organization Reference ID] nvarchar(255),
[Position Reference Descriptor] nvarchar(255),
[Position Reference ID type] nvarchar(255),
[Position Reference ID] nvarchar(255),
[Job Profile Reference Descriptor] nvarchar(255),
[Job Profile Reference ID type] nvarchar(255),
[Job Profile Reference ID] nvarchar(255),
[Location Reference Descriptor] nvarchar(255),
[Location Reference ID type] nvarchar(255),
[Location Reference ID] nvarchar(255),
[Work Space Reference Descriptor] nvarchar(255),
[Work Space Reference ID type] nvarchar(255),
[Work Space Reference ID] nvarchar(255),
[Position Time Type Reference Descriptor] nvarchar(255),
[Position Time Type Reference ID type] nvarchar(255),
[Position Time Type Reference ID] nvarchar(255),
[Work Shift Reference Descriptor] nvarchar(255),
[Work Shift Reference ID type] nvarchar(255),
[Work Shift Reference ID] nvarchar(255),
[Work Hours Profile Reference Descriptor] nvarchar(255),
[Work Hours Profile Reference ID type] nvarchar(255),
[Work Hours Profile Reference ID] nvarchar(255),
[Working Time Frequency Reference Descriptor] nvarchar(255),
[Working Time Frequency Reference ID type] nvarchar(255),
[Working Time Frequency Reference ID] nvarchar(255),
[Working Time Unit Reference Descriptor] nvarchar(255),
[Working Time Unit Reference ID type] nvarchar(255),
[Working Time Unit Reference ID] nvarchar(255),
[Pay Rate Type Reference Descriptor] nvarchar(255),
[Pay Rate Type Reference ID type] nvarchar(255),
[Pay Rate Type Reference ID] nvarchar(255),
[Annual Work Period Reference Descriptor] nvarchar(255),
[Annual Work Period Reference ID type] nvarchar(255),
[Annual Work Period Reference ID] nvarchar(255),
[Disbursement Plan Period Reference Descriptor] nvarchar(255),
[Disbursement Plan Period Reference ID type] nvarchar(255),
[Disbursement Plan Period Reference ID] nvarchar(255),
[Workers  Compensation Code Override Reference Descriptor] nvarchar(255),
[Workers  Compensation Code Override Reference ID type] nvarchar(255),
[Workers  Compensation Code Override Reference ID] nvarchar(255),
[Contract Pay Rate] nvarchar(255),
[Contract Assignment Details] nvarchar(255),
[Currency Reference Descriptor] nvarchar(255),
[Currency Reference ID type] nvarchar(255),
[Currency Reference ID] nvarchar(255),
[Frequency Reference Descriptor] nvarchar(255),
[Frequency Reference ID type] nvarchar(255),
[Frequency Reference ID] nvarchar(255),
[User Name] nvarchar(255),
[Session Timeout Minutes] nvarchar(255),
[Account Disabled] nvarchar(255),
[Account Expiration Date] nvarchar(255),
[Account Locked] nvarchar(255),
[Required New Password At Next Login] nvarchar(255),
[Show User Name in Browser Window] nvarchar(255),
[Display XML Icon on Reports] nvarchar(255),
[Enable Workbox] nvarchar(255),
[Allow Mixed-Language Transactions] nvarchar(255),
[Exempt from Delegated Authentication] nvarchar(255),
[Passcode Exempt] nvarchar(255),
[Passcode Grace Period Enabled] nvarchar(255),
[Passcode Grace Period Login Remaining Count] nvarchar(255),
[OpenID Identifier] nvarchar(255),
[OpenID Internal Identifier] nvarchar(255),
[OpenID Connect Internal Identifier] nvarchar(255),
[Simplified View] nvarchar(255),
[Locale Reference Descriptor] nvarchar(255),
[Locale Reference ID type] nvarchar(255),
[Locale Reference ID] nvarchar(255),
[User Language Reference Descriptor] nvarchar(255),
[User Language Reference ID type] nvarchar(255),
[User Language Reference ID] nvarchar(255),
[Preferred Search Scope Reference Descriptor] nvarchar(255),
[Preferred Search Scope Reference ID type] nvarchar(255),
[Preferred Search Scope Reference ID] nvarchar(255),
[Delegated Authentication Integration System Reference Descriptor] nvarchar(255),
[Delegated Authentication Integration System Reference ID type] nvarchar(255),
[Delegated Authentication Integration System Reference ID] nvarchar(255),
[Password] nvarchar(255),
[Generate Random Password] nvarchar(255)
--,[EMPGROUP] nvarchar(255)
)


 drop table if exists WD_HR_TR_POSITIONS_ORGANIZATION_ASSIGNMENT;
create table WD_HR_TR_POSITIONS_ORGANIZATION_ASSIGNMENT
([Position Organization Assignment Key] nvarchar(255),
[Effective As Of] nvarchar(255),
[Position Reference Descriptor] nvarchar(255),
[Position Reference ID type] nvarchar(255),
[Position Reference ID] nvarchar(255),
[Worker Reference Descriptor] nvarchar(255),
[Worker Reference ID type] nvarchar(255),
[Worker Reference ID] nvarchar(255)
);


drop table if exists WD_HR_TR_ASSIGN_ORGANIZATION_TO_POSITIONS;
create table WD_HR_TR_ASSIGN_ORGANIZATION_TO_POSITIONS
([Position Organization Assignment Key] nvarchar(255),
[Organization Reference Key] nvarchar(255),
[Descriptor] nvarchar(255),
[ID type] nvarchar(255),
[ID] nvarchar(255) 
);
	


	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists position_management_Error_report;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'create table position_management_Error_report
	                                         (
	                                           [Build Number] nvarchar(255),
												[Report Name] nvarchar(255),
												[Employee ID] nvarchar(20),
												[Country Name] nvarchar(255),
												[Country ISO3 Code] nvarchar(255),
												[Employee Type] nvarchar(255),
												[Employee Group] nvarchar(255),
												[Error Description] nvarchar(255),
												[Error Text] nvarchar(255)
	                                         );'


 

 
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists position_management_Prevalidation_report;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'create table position_management_Prevalidation_report
	                                         (
	                                             [Build Number] nvarchar(255),
												[Report Name] nvarchar(255),
												[Employee ID] nvarchar(20),
												[Country Name] nvarchar(255),
												[Country ISO3 Code] nvarchar(255),
												[Employee Type] nvarchar(255),
												[Employee Group] nvarchar(255),
												[Error Description] nvarchar(255),
												[Error Text] nvarchar(255)
	                                         );'

 

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



insert into position_management_Prevalidation_report
select  @which_wavestage,'Position Management/Sup org Prevalidation',persno [emp - personnel number],country,iso3,
case when empgroup in ('7','9') And empsubgroup = 'Z6' then 'External Sales Rep'
when empgroup in ('7','9') And empsubgroup = 'Z7' then 'Contractor'
when empgroup in ('7','9') And empsubgroup = 'Z9' then 'Service Providers'
else [WorkdayID] end,
empgroup [emp - group] ,'Removed from population as it is not in IT0001','Removed from population as it is not in IT0001' from p0_sup_org_source a
join p0_t001 b
on cocd = companycode
left join country_lkup c
on ctr = iso2
left join (select distinct [InstanceName],[WorkdayID],[HRCoreID] from [dbo].[Mapping_EmployeeType]) v
on empgroup= HRCOREID
where persno not in (Select distinct pernr from p0_pa0001);
 
delete from p0_sup_org_source
where persno not in (Select distinct pernr from p0_pa0001);


delete from p0_sup_org_source
where persno not in (Select distinct pernr from p0_pa0002);


 delete from p0_Sup_org_Source
 where empgroup='8';
 
  

 insert into position_management_Prevalidation_report
select  @which_wavestage,'Position Management/Sup org Prevalidation',persno [emp - personnel number],country,iso3,
case when empgroup in ('7','9') And empsubgroup = 'Z6' then 'External Sales Rep'
when empgroup in ('7','9') And empsubgroup = 'Z7' then 'Contractor'
when empgroup in ('7','9') And empsubgroup = 'Z9' then 'Service Providers'
else [WorkdayID] end,
empgroup [emp - group] ,'OPM Persno either missing or is 00000000','OPM Persno either missing or is 00000000' errortext from p0_sup_org_Source a
join p0_t001 b
on cocd = companycode
left join country_lkup c
on ctr = iso2
left join (select distinct [InstanceName],[WorkdayID],[HRCoreID] from [dbo].[Mapping_EmployeeType]) v
on empgroup= HRCOREID
where isnull(opmpersno,'') in ('','00000000');
 
update [p0_SUP_ORG_SOURCE] 
set flag = 'Y',
opmpersno = hrmpersno
where OPMPersNo in (
select distinct OPMPersNo as pers from [p0_SUP_ORG_SOURCE] 
except
select distinct Persno as pers from [p0_SUP_ORG_SOURCE] );
  

 select persno,cpmpersno + ' : is assigned as opmpersno,  as opmpersno is either blank or 00000000' 
  from p0_sup_org_source
  where isnull(opmpersno,'') in ('', '00000000')
 and isnull(cpmpersno,'') not in ('','00000000');


 update p0_sup_org_source
 set opmpersno = cpmpersno
 where isnull(opmpersno,'') in ('', '00000000')
 and isnull(cpmpersno,'') not in ('','00000000');

   
   
   delete from p0_sup_org_Source 
   where companycode in ('mx19', 'u339', 'ec06','PE05');


select persno,'manager is changed from 61001388  to 10040374 as emp group 4 data is not there in Infotype 0002'
From p0_sup_org_Source 
where opmpersno = '61001388';

 update p0_sup_org_Source
 set opmpersno = '10040374'
 where opmpersno = '61001388';


 select persno,'manager is changed to 10030204 pamela malone as orgunit is 00000000'
From p0_sup_org_Source
where orgunit = '00000000';

 update p0_sup_org_Source
  set flag = 'P2',
 opmpersno = '10030204'
 where orgunit = '00000000';


 
 select persno,'manager is changed to 10030204 pamela malone as both opmpersno and hrmpersno are 00000000'
From p0_sup_org_Source
where opmpersno = '00000000'
 and hrmpersno = '00000000';

 update p0_sup_org_Source
 set flag = 'P2',
 opmpersno = '10030204'
 where opmpersno = '00000000'
 and hrmpersno = '00000000';

  update p0_sup_org_Source
 set flag = 'P3',
 opmpersno = '10030204'
 where persno  in ( '85007480','85006068','04010220' );

 
  update p0_sup_org_Source
 set flag = 's1',
 opmpersno = '02110043'
 where persno  in ( '02001029');



 
drop table if exists p0_pa1000_multiple_position;
select objid 
into p0_pa1000_multiple_position
from (
select objid,count(*) cnt 
from p0_pa1000 
where plvar='01'
and OTYPE = 'S'
and convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
group by objid ) a
where cnt > 1;

drop table if exists p0_pa1000_position;

select * into p0_pa1000_position 
from (
select *,row_number() over(partition by objid order by convert(date,begda) desc) rnk 
from (
select * 
from p0_pa1000 
where plvar='01'
and OTYPE = 'S'
and convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
and objid not in (Select objid from p0_pa1000_multiple_position)

union
select *
from p0_pa1000 
where plvar='01'
and OTYPE = 'S'
and langu = 'E'
and convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
and objid   in (Select objid from p0_pa1000_multiple_position)  )   a ) b
where rnk = 1;



											 EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists position_management_country_Error_report;';
	EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'create table position_management_country_Error_report
	                                         (
	                                            
												 country nvarchar(50),									
	                                             errortext nvarchar(max),
												 errorcount nvarchar(max)
	                                         );'



drop table if exists p0_position_management;

select distinct persno [emp - personnel number]
	  ,personid_ext as [Emp - HRCGLPers. id]
	   ,personid_ext as [GlobalID]
	  ,j.[USRID]  [emp - gddb id]
	   ,k.[USRID] AS [Emp - FirstPort ID]
	  ,c.PERSG  as [Emp - Group]
	  ,c.PERSK as [Emp - subgroup]
	  ,MASSG as [Emp - Hire Type]
	  ,iif(CTEDT='00000000',NULL,CTEDT) as [Emp - Contr End Date]
	  ,iif(TERMN='00000000',NULL,TERMN) as [dt - expiryprobation]
	  ,g.BEGDA as [date - position entr]
	  ,intca as [geo - work country]
	  ,ctr as [geo - country (CC)] -- needs to be changed to t0001 logic
	  ,bukrs as [org - company code]
	  ,concat('C-',[cocd]) wd_Company
	  --,RCOMP
	  --,BEGDA
	  ,x.USRID_LONG [emp - email address]

	  , VORNA [emp - first name]
	   ,NACHN [emp - last name]
	   ,MIDNM [emp - middle name]
	   , '40' [emp - hours per week] -- should be WOSTD in p1
	  ,ORGEH [org - org unit]
	  --,[org unit desc]
	  , PLANS [org - position]
	  ,concat('P-',PLANS) wd_positionid
	  ,stext [Org - Position Text]
	  ,iif(isnull(Stext,'')='','Default Position',stext) wd_position_text
	  ,n.begda hrp1000_begda
	  ,o.short [job profile]
	  ,stell
	  --,[job code description (GJFA)]
	  --,[job code long description]
	  ,yysite as [geo - site code]
	  ,BTRTL as [org - pers. subarea]
	  ,TEILK as [emp - part time flag]
	  ,KOSTL as [org - cost center]
	  ,r.description as [org - cost center text]
	  --,WOSTD [Emp - Hours per Week]
	  --,WOSTD  [Nbr. of Hrs per Week]
	  ,SCHKZ [work schedule rule]
	  ,lga01 
	  ,persno persno_new
	  ,z.sobid opmpositionid
	  ,y.sobid [mgr - opm MD]
	  ,iso3 [geo - country (CC) iso3]
	  ,country [geo - country (CC) text]
	  ,case when C.PERSG in ('7','9') And C.PERSK = 'Z6' then 'External Sales Rep'
when C.PERSG in ('7','9') And C.PERSK = 'Z7' then 'Contractor'
when C.PERSG in ('7','9') And C.PERSK = 'Z9' then 'Service Providers'
else [WorkdayID] end as wd_emp_type
	  into p0_position_management
from p0_Sup_Org_source a
left join 
(select * from p0_pa0709 
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
) b
on a.persno = b.pernr
left join 
(select * from p0_pa0001
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) ) c
on a.persno = c.pernr
left join 
(select * from p0_pa0000
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) ) d
on a.persno = d.pernr
left join 
(select * from p0_pa0016
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)) e
on a.persno = e.pernr
left join
(select distinct pernr,termn from p0_pa0019 -- duplicates happening
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
and SPRPS is null) f
on a.persno = f.pernr
left join 
(select * from p0_pa1001 
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and relat='008'
and otype = 'S'
and sclas='P'
) g
on a.persno = g.sobid
and plans = g.objid
left join 
(select * from p0_pa9008
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and sprps is null) h
on a.persno = h.pernr
left join 
(select * from p0_pa0007
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and sprps is null) i
on a.persno = i.pernr
left join 
(select distinct pernr,usrid from p0_pa0105
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and subty = '0001') j
on a.persno = j.pernr
left join 
(select  distinct pernr,usrid from p0_pa0105
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and subty = '9000') k
on a.persno = k.pernr
left join 
(select * from p0_pa0002
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and sprps is null) l
on a.persno = l.pernr
--left join p0_cskt_cost_Center_Text m
--on KOSTL = [cost ctr]
left join p0_pa1000_position n
on PLANS = n.objid
left join (select distinct objid,short from p0_pa1000
where plvar = '01'
and otype='C'
and convert(Date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) ) o
on o.objid = stell
left join 
(select * from p0_pa0008
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and sprps is null) p
on a.persno = p.pernr
left join [dbo].[P0_T001_source] q
on cocd = bukrs
left join 
(select distinct pernr,USRID_LONG from p0_pa0105
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date) 
and subty = '0010') x
on a.persno = x.pernr
left join (  select * from (
	  select *,row_number() over (partition by [cost ctr] order by convert(datetime,[to],103) desc) rnk
	  from P0_CSKT_COST_CENTER_Text ) a
	  where rnk = 1) r
	  on  KOSTL = [cost ctr]
left join (select * from p0_pa1001
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
and relat='002'
and otype = 'S'
and sclas='S'  
and RSIGN = 'A') z
on plans = z.objid
left join
(
SELECT * FROM (
select *,row_number() over( partition by objid order by CAST(BEGDA AS DATE) DESC) RNK from p0_pa1001
where convert(date,begda)<=cast(@which_date as date)
and convert(date,endda)>=cast(@which_date as date)
and relat='008'
and otype = 'S'
and sclas='P'
AND PLVAR = '01'
AND CAST(prozt AS FLOAT) >= 100) A
WHERE RNK = 1) y
on z.sobid= y.objid  
left join country_lkup w
on ctr = iso2
left join (select distinct [InstanceName],[WorkdayID],[HRCoreID] from [dbo].[Mapping_EmployeeType]) v
on C.PERSG= HRCOREID;



 delete from p0_position_management
 where [emp - group]='8';
EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH '

alter table p0_POSITION_MANAGEMENT
add
wd_FTE nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_job_code nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_job_profile_desc nvarchar(100);

alter table p0_POSITION_MANAGEMENT
add
wd_workshift nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_workshift_desc nvarchar(100);


alter table p0_POSITION_MANAGEMENT
add
wd_original_hire_Date date;


alter table p0_POSITION_MANAGEMENT
add
wd_latest_hire_Date date;


alter table p0_POSITION_MANAGEMENT
add
wd_position_entry_Date date;


alter table p0_POSITION_MANAGEMENT
add
wd_hrp1000_begda date;

alter table p0_POSITION_MANAGEMENT
add 
wd_continuous_service_date date;

alter table p0_POSITION_MANAGEMENT
add 
wd_prob_Expiry_date date;

alter table p0_POSITION_MANAGEMENT
add 
wd_Contract_end_date date;


alter table p0_POSITION_MANAGEMENT
add
wd_severance_Date date;

alter table p0_POSITION_MANAGEMENT
add
wd_benefits_service_Date date;

alter table p0_POSITION_MANAGEMENT
add
wd_Scheduled_work_hours nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_default_work_hours nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_timeoff_Service_Date date;
	
alter table p0_POSITION_MANAGEMENT  
add 
WD_PROB_START date;

--alter table p0_POSITION_MANAGEMENT
--add
--wd_emp_type nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_gddb_id nvarchar(25);

alter table  p0_POSITION_MANAGEMENT
add
[WD_SUPORG_ID] nvarchar(25),
[WD_SUPORG]  nvarchar(100),
[WD_SUPERIORORG_ID] nvarchar(25),
[WD_OPMID] nvarchar(100),
[WD_OPM_NAME] nvarchar(100);

alter table p0_POSITION_MANAGEMENT 
add 
WD_location nvarchar(255) ,
WD_location_id nvarchar(255) ;

alter table p0_POSITION_MANAGEMENT
add 
wd_CostCenter nvarchar(100);

alter table p0_POSITION_MANAGEMENT
add 
wd_CostCenter_id nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add 
wd_pay_type_id nvarchar(25);


alter table p0_POSITION_MANAGEMENT
add 
wd_matrix_manager nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add 
wd_supplier nvarchar(100);

alter table p0_POSITION_MANAGEMENT
add
wd_Working_FTE nvarchar(25);

alter table p0_POSITION_MANAGEMENT
add
wd_Working_FTE_percentage nvarchar(25);


alter table p0_POSITION_MANAGEMENT
add
wd_paid_FTE_percentage nvarchar(25);


--alter table p0_sup_org_Source
--add
--OPMpositionid nvarchar(25),
--CPMpositionid nvarchar(25),
--HRMpositionid nvarchar(25);

'

update a set a.[emp - gddb id]=b.[emp - gddb id] from
(select * From p0_position_management where [emp - group]='3' and [emp - gddb id] is null ) a
join (Select * From  p0_position_management where [emp - group]='4' and [emp - gddb id] is not null ) b
on a.[Emp - HRCGLPers. id] = b.[Emp - HRCGLPers. id] ;

update a set a.[emp - gddb id]=b.[emp - gddb id] from
(select * From p0_position_management where [emp - group]='3' and [emp - gddb id] is null ) a
join (Select * From  p0_position_management where [emp - group]='4' and [emp - gddb id] is not null ) b
on a.[Emp - HRCGLPers. id] = b.[Emp - HRCGLPers. id] ;
 
--select [emp - personnel number],[emp - group],'work country is missing' From p0_position_management
--where isnull([geo - work country],'')='';


update p0_position_management
set [geo - work country]=[geo - country (CC)]
where isnull([geo - work country],'')='';
 
update a
set wd_positionid = new_positionid 
from p0_position_management  a
join (
select *, concat('P-',[org - position],'_',row_number() over(partition by [org - position] order by globalid)) new_positionid
from p0_position_management
 where    [org - position] in (
 select [org - position] from (
 select [org - position],count(*) cnt from p0_position_management
 where [org - position] is not null
 group by [org - position]
 having count(*)>1) a )) b
 on a.[org - position] = b.[org - position]
 and a.globalID=b.globalID
 and a.[emp - group] = b.[emp - group]
 and a.[geo - country (CC)] = b.[geo - country (CC)]
  where a.[org - position] is not null;
 

  	 
  update p0_position_management
  set wd_positionid =  'P-20254287_2'
  where [emp - personnel number] = '03010227';

  
  update p0_position_management
  set wd_positionid =  'P-20254287_1'
  where [emp - personnel number] = '03008955';
   
   update a
   set positionid = wd_positionid 
   from p0_sup_org_source a
   join p0_position_management b
   on [emp - personnel number] = persno;
   
   

   
update  a
set a.opmpositionid = b.positionid
from [p0_SUP_ORG_SOURCE] a
full outer join 
[p0_SUP_ORG_SOURCE] b
on a.OPMPersNo = b.Persno;


update  a
set a.CPMPositionID = b.positionid
from [p0_SUP_ORG_SOURCE] a
full outer join 
[p0_SUP_ORG_SOURCE] b
on a.CPMPersNo = b.Persno;


update  a
set a.HRMPositionID = b.positionid
from [p0_SUP_ORG_SOURCE] a
full outer join 
[p0_SUP_ORG_SOURCE] b
on a.HRMPersNo = b.Persno;
 
   



	  
update a set a.persno_new=b.[emp - personnel number]
	from
	(
select  *
	from p0_POSITION_MANAGEMENT
	where [emp - group] in (4)) a
	 join 
	(select  *
	from p0_POSITION_MANAGEMENT
	where [emp - group] in (3)) b
	on a.[Emp - HRCGLPers. id] = b.[Emp - HRCGLPers. id];


	 
	   


EXEC PROC_EXECUTE_STRING_SQL_WITH_BATCH 'drop table if exists p0_SUP_ORG;'

select a.persno,a.companycode,a.name,a.PersArea,a.positionid,a.positiontext,a.opmpersno,a.opmpositionID as superior_position_id,a.opmname,b.persno as superior_persno,--b.opmpositionid as superior_opmposition_id ,
 b.name  as sup_org_manager_name,a.orgunit as 'old_org',a.OrgunitDesc as 'old_org_name',b.positiontext as superior_positiontext
, b.OrgUnit   as 'sup_org',
 b.OrgUnitdesc   as 'sup_org_name',
c.OrgUnit   as 'Superior_Org',c.persno as superior_opmpersno,a.flag ,
 b.flag as superior_flag,
 b.persno_new superior_persno_new,
b.persarea as superior_persarea
, a.persno_new, 
cast(null as nvarchar(10)) as dup_flag  
into p0_SUP_ORG
from [p0_SUP_ORG_SOURCE] a
left outer join 
[p0_SUP_ORG_SOURCE] b
on a.OPMpositionid = b.positionid
left outer join 
[p0_SUP_ORG_SOURCE] c
on b.OPMpositionID = c.positionID;



update aa
set aa.superior_org = bb.superior_org,
aa.sup_org_manager_name = bb.sup_org_manager_name,
aa.superior_persno =bb.superior_persno,
aa.superior_position_id = bb.superior_position_id,
aa.superior_persno_new = bb.superior_persno_new
 from 
(select * from p0_Sup_org
where superior_org = sup_org ) aa
join
(
select a.* from p0_Sup_org a
join 
(select distinct sup_org,superior_org,superior_persno,superior_position_id from p0_Sup_org
where superior_org = sup_org  ) b
on a.sup_org = b.superior_org
where a.persno = b.superior_persno )bb
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



select distinct z.persno,z.sup_Org + ' has more than one sup org name , so only one is assigned'
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

	
--			update a
--		set wd_emp_type = case when [emp - group] in ('7','9') And [emp - subgroup] = 'Z6' then 'External Sales Rep'
--when [emp - group] in ('7','9') And [emp - subgroup] = 'Z7' then 'Contractor'
--when [emp - group] in ('7','9') And [emp - subgroup] = 'Z9' then 'Service Providers'
--else [WorkdayID] end
--		from [dbo].p0_POSITION_MANAGEMENT  a
--			join (select distinct [InstanceName],[WorkdayID],[HRCoreID] from [dbo].[Mapping_EmployeeType]) b
--                        on a.[Emp - Group] = [HRCoreID];



insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text],
[geo - country (CC)],wd_emp_type,[emp - group],'Persno new not changed for inpat',globalid +' : Persno new not changed for inpat'
 from p0_position_management
where persno_new = [emp - personnel number]
and [emp - group] = '4';



 
  

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Global ID is missing','Global ID is missing' errortext From p0_position_management
where isnull(Globalid,'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'CC country is missing','CC country is missing' errortext From p0_position_management
where isnull([geo - country (CC)],'')='';


insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Email ID is missing','Email ID is missing' errortext From p0_position_management
where isnull([emp - email address],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'[emp - group]  is missing','[emp - group]  is missing' errortext From p0_position_management
where isnull([emp - group],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'GDDB ID  is missing','GDDB ID  is missing' errortext From p0_position_management
where isnull([emp - gddb id],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Firstport ID  is missing','Firstport ID  is missing' errortext From p0_position_management
where isnull([emp - firstport id],'')=''
and [emp - group] not in ('7','9');

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Position ID  is missing','Position ID  is missing' errortext From p0_position_management
where isnull([org - position],'')='';



insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Position text  is missing','Position text  is missing' errortext From p0_position_management
where isnull([org - position text],'')='';



insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text],
[geo - country (CC)],wd_emp_type,[emp - group],'Companycode  is missing','Companycode  is missing' errortext From p0_position_management
where isnull([org - company code],'')='';



insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Site Code  is missing','Site Code  is missing' errortext
 From p0_position_management
where isnull([geo - site code],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Cost Center  is missing','Cost Center  is missing' errortext
 From p0_position_management
where isnull([org - cost center],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Pers Sub Area  is missing','Pers Sub Area  is missing' errortext
 From p0_position_management
where isnull([org - pers. subarea],'')='';

insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'Job Profile  is missing','Job Profile  is missing' errortext
 From p0_position_management
where isnull([job profile],'')=''
and [emp - group] not in ('7','9');







insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'CPM Persno either missing or is 00000000','CPM Persno either missing or is 00000000' errortext from p0_sup_org_Source
join p0_position_management b
on persno = [emp - personnel number]
where isnull(cpmpersno,'') in ('','00000000');


insert into position_management_Prevalidation_report
select @which_wavestage,'Position Management/Sup org Prevalidation',[emp - personnel number],[geo - country (CC) text]
,[geo - country (CC)],wd_emp_type,[emp - group],'HRM Persno either missing or is 00000000','HRM Persno either missing or is 00000000' errortext from p0_sup_org_Source
join p0_position_management b
on persno = [emp - personnel number]
where isnull(hrmpersno,'') in ('','00000000');

/*
update a
set a.[emp - email address] = USRID_LONG
 From p0_POSITION_MANAGEMENT a
LEFT JOIN
(select distinct pernr,endda,USRID_LONG,row_number() over(partition by pernr order by cast(Endda as date) desc) as rnk 
from p0_pa0105
where subty = '0010') x
on a.[emp - personnel number] = x.pernr
where rnk = 1
and isnull([emp - email address],'')=''; 
*/
	update p0_POSITION_MANAGEMENT
	set
	wd_original_hire_Date =null,
	wd_latest_hire_Date = convert(Date,'2021-03-10'),
	wd_continuous_Service_date = null;


	update p0_POSITION_MANAGEMENT
	set   
	wd_CostCenter_id = iif(isnull([org - cost center],'')='','CC-Dummy',[org - cost center]),
	wd_CostCenter = iif(isnull([org - cost center text],'')='','Missing Cost Center',[org - cost center text]);


			/*update  p0_POSITION_MANAGEMENT
			set wd_Emp_type = 'apprentice'
			where [emp - subgroup] in ('0N','9N','DM')
			and [geo - country (CC)] = 'DE';*/

 

			update  p0_POSITION_MANAGEMENT
	set wd_position_entry_date =iif(isnull([date - position entr],'')='','2021-03-10',[date - position entr]);


	

			update  p0_POSITION_MANAGEMENT
	set wd_hrp1000_begda =iif(isnull(hrp1000_begda,'')='','2021-01-01',hrp1000_begda);


	


	--update  p0_POSITION_MANAGEMENT
	--set wd_position_entry_date = wd_latest_hire_Date
	--where wd_position_entry_Date  is  null;


	
	--insert into position_management_error_report
	--select [emp - personnel number],[geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,' latest Hire Date is earlier than original hire date' From p0_POSITION_MANAGEMENT
	--where wd_latest_hire_Date <wd_original_hire_date;

	--update  p0_POSITION_MANAGEMENT
	--set wd_original_hire_date = wd_latest_hire_Date,
	--wd_latest_hire_Date = wd_original_hire_date
	--where wd_latest_hire_Date <wd_original_hire_date;



	--update p0_POSITION_MANAGEMENT
	--set wd_continuous_service_date = wd_latest_hire_date;

	
	update p0_POSITION_MANAGEMENT
	set wd_default_work_hours = '40',
	wd_scheduled_work_hours = '40';



	update p0_POSITION_MANAGEMENT
	set wd_prob_expiry_Date = [dt - expiryprobation];

	UPDATE p0_POSITION_MANAGEMENT  Set WD_PROB_START = WD_latest_hire_date
		WHERE wd_prob_Expiry_date IS NOT NULL ;

				--update p0_POSITION_MANAGEMENT
				--set wd_contract_End_Date = [Emp - Contr End Date];

--update p0_POSITION_MANAGEMENT
--set wd_position_entry_date =hrp1000_begda;

					update p0_POSITION_MANAGEMENT
	set wd_Contract_end_date = '2021-12-31'
	where  [emp - group]  in ('2','7','9')--need to be updated for p1
	and wd_Contract_end_date is  null;
	 
	 

		update p0_POSITION_MANAGEMENT
		set wd_Contract_end_date = NULL
		where [emp - group] not in ('2','7','9');


		update p0_POSITION_MANAGEMENT
		set [emp - email address] = lower(ltrim(rtrim([emp - email address])));

		UPDATE A
		 SET [WD_SUPORG_ID] = b.[Sup_Org]
			,[WD_SUPORG] = b.[Sup_org_name]
			,[WD_SUPERIORORG_ID] = b.[Superior_Org]
			,[WD_OPMID] = b.[Superior_persno_new]
			,[WD_OPM_NAME] = b.[Sup_Org_Manager_name]
		FROM  [dbo].p0_POSITION_MANAGEMENT A
		INNER JOIN  [dbo].p0_SUP_ORG b
		on  a.[Emp - Personnel Number] = b.[PersNo];


		insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],' Cost Center is not available ',' Cost Center is not available ' From p0_POSITION_MANAGEMENT
	where wd_Costcenter_id is null;

	
		insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
	' Cost Center is matching with one of the  Company ref ID ' ,' Cost Center is matching with one of the  Company ref ID ' 
from p0_position_management
where   wd_costcenter_id 
in (select distinct [id] from p0_dgw_company );


	
		insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)]
	,wd_emp_type,[emp - group],' Job Profile is not available and defaulted to 00000000',' Job Profile is not available and defaulted to 00000000' From p0_POSITION_MANAGEMENT
	where isnull([job profile],'')=''
	and [emp - group] not in ('7','9');


	update a
	set wd_job_code = 'Default'--iif(isnull([job profile],'')='','00000000',[job profile])
	from p0_POSITION_MANAGEMENT   a;
	
	update a  
	set-- WD_location = b.workdayvalue,
	WD_location_id = LTRIM(RTRIM(([geo - site code])))
	from p0_POSITION_MANAGEMENT   a;



	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Location ID is blank in HR core, it was defaulted to main location of the country in Workday','Location ID is blank in HR core, it was defaulted to main location of the country in Workday'
	 from p0_position_management
	where wd_location_id is null;

	drop table if exists p0_Country_main_locations;
  select * into p0_Country_main_locations
  from 
  (select [geo - country (CC)],wd_location_id,cnt,row_number() over(partition by [geo - country (CC)] order by cnt desc) rnk
   from (


  select wd_location_id,[geo - country (CC)],count(*) cnt
  from p0_position_management 
  where wd_location_id is not null
  group by wd_location_id,[geo - country (CC)]) a
  ) b
  where rnk = 1;



  update a
  set a.wd_location_id = b.wd_location_id 
  from p0_position_management a
  join p0_Country_main_locations b
  on a.[geo - country (CC)] = b.[geo - country (CC)]
  where a.wd_location_id is null;



  
  update a
  set a.wd_location_id = b.wd_location_id 
  from p0_position_management a
  join p0_Country_main_locations b
  on a.[geo - country (CC)] = b.[geo - country (CC)]
  where a.wd_location_id  in ( 
   select wd_location_id from p0_position_management
   except
   select [location id] from [dbo].[WD_HR_TR_AUTOMATED_LOCATIONS]);


	update p0_POSITION_MANAGEMENT
	set [Emp - Part Time Flag] = NULL;

	update p0_POSITION_MANAGEMENT
	set wd_pay_type_id = iif(isnull(lga01,'')='1003','Hourly','Salary');

	--update a 
	--set [Emp - Part Time Flag] = IIF(B.parttimeflag='Yes','Y','N')
	--From p0_POSITION_MANAGEMENT a
	--join p0_SUP_ORG_SOURCE b
	--on a.[emp - personnel number] = b.persno;


	--insert into position_management_Error_report
	--select [emp - personnel number], [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,concat([org - cost center]
	--, ' :  cost center is missing in configuration')
	--from p0_POSITION_MANAGEMENT
	--where wd_costcenter_id is null;

 


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Location is empty','Location is empty ' from p0_POSITION_MANAGEMENT
	where wd_location_id is null;

	 



	
	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'GDDB ID username is blank','GDDB ID username is blank' from p0_POSITION_MANAGEMENT 
	where [emp - gddb id]  is null;
	--and a.persno_new not in (Select workerid from WD_HR_TR_UserAccounts);

	-- insert into Position_management_error_Report
	--select a.[emp - personnel number],  [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end, wd_gddb_id + ' User ID duplicated from previous waves'
	-- From p0_POSITION_MANAGEMENT  a
	--join w4_Gold_Prev_position_management b
	--on wd_gddb_id = b.[emp - gddb id]
	-- where wd_gddb_id is not null 
	

--insert into Position_management_error_Report
--select [emp - personnel number],  [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end, locationid + ':' + country + 'location and country does not match' 
--From w4_location_mapping a
--join p0_POSITION_MANAGEMENT b
--on locationid = WD_location_id
--and country <> [geo - country (CC)];



	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Latest Hire Date is blank','Latest Hire Date is blank' from p0_POSITION_MANAGEMENT
	where wd_latest_hire_date is null;


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'contract end date is earlier than  Latest Hire Date ','contract end date is earlier than  Latest Hire Date ' from p0_POSITION_MANAGEMENT
	where wd_latest_hire_date > wd_Contract_end_date;


	insert into Position_management_error_Report

	 select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group]
	 ,' location missing in location master data',[geo - site code] + ' location missing in location master data' from p0_position_management
 where wd_location_id in (
 select distinct wd_location_id From p0_position_management
 except
select distinct [location id] from WD_HR_TR_AUTOMATED_locations );


	insert into Position_management_error_Report

	 select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group]
	 ,'costcenter missing in mapping sheet' ,'costcenter missing in mapping sheet' from p0_position_management
 where [org - cost center] in (
select distinct [org - cost center] From p0_position_management
except
select distinct [id] from WD_HR_TR_AUTOMATED_COST_CENTER 
   );




	--insert into Position_management_error_Report
	--select [emp - personnel number],  [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,'Continuous Service Date is blank' from p0_POSITION_MANAGEMENT
	--where wd_continuous_service_date is null;


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Position Entry date is blank','Position Entry date is blank' from p0_POSITION_MANAGEMENT
	where wd_position_entry_date is null;


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Supervisory Org is blank','Supervisory Org is blank' from p0_POSITION_MANAGEMENT
	where wd_suporg_id is null;


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Job profile code is blank' ,'Job profile code is blank' from p0_POSITION_MANAGEMENT
	where wd_job_code  is null;





	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Default Weekly hours is blank','Default Weekly hours is blank' from p0_POSITION_MANAGEMENT
	where wd_default_work_hours is null;


	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Scheduled Weekly hours is blank','Scheduled Weekly hours is blank' from p0_POSITION_MANAGEMENT
	where wd_scheduled_work_hours is null;

	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Scheduled Weekly hours is zero','Scheduled Weekly hours is zero' from p0_POSITION_MANAGEMENT
	where wd_scheduled_work_hours='0';

	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],	'Paytype is null', 
	'Paytype is null'
	 from p0_POSITION_MANAGEMENT
	where wd_pay_type_id  is null;


	 
		 
		  

	insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group], 
	'Positon Entry Date is earlier than latest Hire Date','Positon Entry Date is earlier than latest Hire Date' From p0_POSITION_MANAGEMENT
	where wd_latest_hire_Date >wd_position_entry_date;




	

		
	--insert into position_management_error_report
	--select [emp - personnel number],  [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,' continuous service date is earlier than original hire date' From p0_POSITION_MANAGEMENT
	--where wd_Continuous_Service_date <wd_original_hire_date;

		 






	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group], 
		'Company is blank','Company is blank'
	 from p0_POSITION_MANAGEMENT
	where wd_company  is null;


	insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group]
	,'Multiple employees sitting in same Position ID',concat('Multiple employees sitting in same Position ID :',cnt,' employees : HR Core Position ID: ',a.[org - position])
	from p0_POSITION_MANAGEMENT a
	join(
	select [org - position],count(*) as cnt from 
	p0_POSITION_MANAGEMENT
	group by [org - position]
	having count(*) > 1) b
	on a.[org - position] = b.[org - position];




	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group], 
	'Employment end date should be  blank for non-fixed term/non external employee','Employment end date should be  blank for non-fixed term/non external employee'
	from  p0_POSITION_MANAGEMENT
	where [emp - group] not in (/*'2','6',*/'7','9')
	and wd_Contract_end_date is not null;

	 
	 
	 insert into Position_management_error_Report
 select @which_wavestage,'Position Management',a.[emp - personnel number],a.[geo - country (CC) text],a.[geo - country (CC)],wd_emp_type,a.[emp - group], 
 ' Global ID duplicated ',	a.Globalid + ' Global ID duplicated '
	 From p0_position_management a
 join ( select [emp - personnel number],globalid,
 row_number() over(partition by globalid order by [emp - personnel number]) rnk
  From p0_position_management 
  where [emp - group] not in ('3','4')) b
  on  a.globalid = b.globalid
  where rnk >1
  order by a.Globalid;

  	 insert into Position_management_error_Report
 select @which_wavestage,'Position Management',a.[emp - personnel number],a.[geo - country (CC) text],a.[geo - country (CC)],wd_emp_type,a.[emp - group], 
	' Email ID duplicated ',a.[emp - email address] + ' Email ID duplicated '
	 From p0_position_management a
 join ( select [emp - personnel number],[emp - email address],
 row_number() over(partition by [emp - email address] order by [emp - personnel number]) rnk
  From p0_position_management 
  where [emp - group] not in ('3','4')) b
  on  a.[emp - email address] = b.[emp - email address]
  where rnk >1
  order by a.[emp - email address];

  insert into Position_management_error_Report
 select @which_wavestage,'Position Management',a.[emp - personnel number],a.[geo - country (CC) text],a.[geo - country (CC)],a.wd_emp_type,a.[emp - group], 
 ' GDDB id duplicated', a.[emp - gddb id] + ' GDDB id duplicated' From p0_position_management a
 join ( select [emp - personnel number],[emp - gddb id],
 row_number() over(partition by [emp - gddb id] order by [emp - personnel number]) rnk
  From p0_position_management 
  where [emp - group] not in ('3','4')) b
  on a.[emp - gddb id] = b.[emp - gddb id]
  where rnk >1
  order by a.[emp - gddb id];
   

	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group], 
	'Part time FTE >=1','Part time FTE >=1'
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'Y'
	 and convert(float,wd_scheduled_work_hours)/convert(float,wd_default_work_hours)>=1;

	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group], 
	'Full-Time  FTE <1','Full-Time  FTE <1'
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'N'
	and convert(float,wd_scheduled_work_hours)/convert(float,wd_default_work_hours)<1;


	insert into position_management_country_Error_report
	select [geo - country (CC)],'Part time FTE >=1',count(*)   
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'Y'
	 and convert(float,wd_scheduled_work_hours)/convert(float,wd_default_work_hours)>=1
	 group by  [geo - country (CC)];

	 insert into position_management_country_Error_report
	 select   [geo - country (CC)] ,'Full-Time  FTE <1',count(*)
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'N'
	and convert(float,wd_scheduled_work_hours)/convert(float,wd_default_work_hours)<1
	group by [geo - country (CC)];


	insert into position_management_error_report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
		'Default hours less than scheduled hours','Default hours less than scheduled hours'
	 from p0_POSITION_MANAGEMENT
	where wd_default_work_hours<
	wd_scheduled_work_hours;





	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
	,[geo - country (CC)],wd_emp_type,[emp - group],'Cost Center empty',concat('Issue Cost Center empty: HR core value : ', [ORG - COST CENTER]) from p0_POSITION_MANAGEMENT a
	join p0_SUP_ORG_SOURCE b
	on a.[emp - personnel number] = b.persno
	and wd_costcenter_id is null;

 


	--update  p0_POSITION_MANAGEMENT 
	--set wd_emp_type ='Regular'
	--where wd_emp_type in ('Expat','Inpat');

	--update p0_POSITION_MANAGEMENT
	--set wd_default_work_hours = wd_scheduled_work_hours
	--where convert(float,wd_default_work_hours) <  convert(float,wd_scheduled_work_hours);
	
	--update p0_POSITION_MANAGEMENT
	--set wd_scheduled_work_hours=wd_default_work_hours 
	--where isnull(wd_scheduled_work_hours,'0')='0';


	
	--	update p0_position_management
	--set wd_default_work_hours=wd_scheduled_work_hours
	--where [emp - subgroup] in ('0N','9N','DM');


	
--	update p0_position_management
--set [emp - first name] = [dbo].[MakeCamelCase]([emp - first name])  
--where [emp - first name] = upper([emp - first name]) COLLATE SQL_Latin1_General_CP1_CS_AS;


--update p0_position_management
--set [emp - middle name] = [dbo].[MakeCamelCase]([emp - middle name])   
--where [emp - middle name] = upper([emp - middle name]) COLLATE SQL_Latin1_General_CP1_CS_AS;

--update p0_position_management
--set [emp - last name] = [dbo].[MakeCamelCase]([emp - last name])   
--where [emp - last name] = upper([emp - last name]) COLLATE SQL_Latin1_General_CP1_CS_AS;




	
	insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],'Supplier Empty : ','Supplier Empty : ' from p0_POSITION_MANAGEMENT
	where wd_supplier is null
	and [emp - group] in ('7','9');


		insert into Position_management_error_Report
	select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],'Position Text Empty : ','Position Text Empty : ' from p0_POSITION_MANAGEMENT
	where [org - position text] is null;

	/*

	update p0_POSITION_MANAGEMENT
	set [emp - empTargWorkhrs] = [emp - cmpTargWorkhrs] 
	where [emp - empTargWorkhrs] is null
	and [emp - group] in ('7','9');


	update p0_POSITION_MANAGEMENT
	set [emp - cmpTargWorkhrs] = '40'
	where [emp - cmpTargWorkhrs] < [emp - empTargWorkhrs]
	and [geo - work country]='US';


	update p0_POSITION_MANAGEMENT
	set [emp - cmpTargWorkhrs] = '40'
	where [emp - cmpTargWorkhrs]  is null;

	*/



	/*
	update p0_POSITION_MANAGEMENT
set wd_original_hire_date=IIF(ISNULL(wd_original_hire_date, '')='', '', CONVERT(varchar(10), CAST(wd_original_hire_date as date), 101))
,wd_latest_hire_date=IIF(ISNULL(wd_latest_hire_date, '')='', '', CONVERT(varchar(10), CAST(wd_latest_hire_date as date), 101))
,wd_continuous_Service_date=IIF(ISNULL(wd_continuous_Service_date, '')='', '', CONVERT(varchar(10), CAST(wd_continuous_Service_date as date), 101))
,wd_prob_Start=IIF(ISNULL(wd_prob_Start, '')='', '', CONVERT(varchar(10), CAST(wd_prob_Start as date), 101))
,wd_position_entry_date=IIF(ISNULL(wd_position_entry_date, '')='', '', CONVERT(varchar(10), CAST(wd_position_entry_date as date), 101))
,wd_prob_expiry_date=IIF(ISNULL(wd_prob_expiry_date, '')='', '', CONVERT(varchar(10), CAST(wd_prob_expiry_date as date), 101))
,wd_contract_End_date=IIF(ISNULL(wd_contract_End_date, '')='', '', CONVERT(varchar(10), CAST(wd_contract_End_date as date), 101));*/


	/*
	insert into Position_management_error_Report
	select [emp - personnel number], [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end, 
	'This error persists after data correction : Part time FTE >=1'
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'Y'
	and convert(float,[emp - empTargWorkhrs])/convert(float,[emp - cmpTargWorkhrs])>=1;

	insert into Position_management_error_Report
	select [emp - personnel number], [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end, 
	'This error persists after data correction :  Full-Time  FTE <1'
	 from p0_POSITION_MANAGEMENT
	where [Emp - Part Time Flag]  = 'N'
	and convert(float,[emp - empTargWorkhrs])/convert(float,[emp - cmpTargWorkhrs])<1;
	*/

	--insert into position_management_error_report
	--select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
	--'This error persists after data correction :   Default hours less than scheduled hours'
	-- from p0_POSITION_MANAGEMENT
	--where convert(float,wd_default_work_hours) < convert(float,wd_scheduled_work_hours);

	--insert into position_management_error_report
	--select [emp - personnel number],
	-- [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
	--'OPMID is null'
	-- from p0_POSITION_MANAGEMENT
	--where wd_OPMID is null;

--	select [emp - personnel number], [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
--'job profile not from catalog' From (Select distinct [emp - personnel number], [geo - country (CC)],[org - company code],[emp - group],wd_job_code from p0_position_management) a
--left join (Select distinct [job code] from w4_gold_job_catalog) b
--on wd_job_code = [job code]
--where [job code] is null;

--insert into position_management_error_report
--select [emp - personnel number], [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
--'job profile not from catalog' From (Select distinct [emp - personnel number], [geo - country (CC)],[org - company code],[emp - group],wd_job_code from p0_position_management) a
--left join (Select distinct [job code] from w4_gold_job_catalog) b
--on wd_job_code = [job code]
--where [job code] is null;


	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
  'Cost Center Missing','Cost Center Missing'
  From p0_POSITION_MANAGEMENT 
Where wd_Costcenter_id like '%CC-Dummy%';

 

	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
 ' employee has replacement character ? as part of positiontext', ' employee has replacement character ? as part of positiontext'
  From p0_POSITION_MANAGEMENT 
Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, [org - position text]) > 0;


--	insert into position_management_error_report
-- Select [emp - personnel number],
--	 [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
-- ' manager name has replacement character ?'
--  From p0_POSITION_MANAGEMENT 
--Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, [WD_OPM_NAME]) > 0;



--	insert into position_management_error_report
-- Select [emp - personnel number],
--	 [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
-- ' sup org name has replacement character ?'
--  From p0_POSITION_MANAGEMENT 
--Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, wd_suporg) > 0;





	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
 ' cost center text has replacement character ?', ' cost center text has replacement character ?'
  From p0_POSITION_MANAGEMENT 
Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, wd_CostCenter) > 0;

	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
 ' cost center id has replacement character ?', ' cost center id has replacement character ?'
  From p0_POSITION_MANAGEMENT 
Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, wd_CostCenter_id) > 0;


	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text],[geo - country (CC)],wd_emp_type,[emp - group],
 ' email id has replacement character ?',' email id has replacement character ?'
  From p0_POSITION_MANAGEMENT 
Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, [Emp - Email Address]) > 0;





--	insert into position_management_error_report
-- Select [emp - personnel number],
--	 [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
-- ' job profile desc has replacement character ?'
--  From p0_POSITION_MANAGEMENT 
--Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, wd_job_profile_desc) > 0;

	insert into position_management_error_report
 Select @which_wavestage,'Position Management',[emp - personnel number],[geo - country (CC) text]
 ,[geo - country (CC)],wd_emp_type,[emp - group],
 ' job profile code has replacement character ?', ' job profile code has replacement character ?'
  From p0_POSITION_MANAGEMENT 
Where CharIndex(nchar(65533) COLLATE Latin1_General_BIN2, wd_job_Code) > 0;




 



	
	--	insert into position_management_error_report
	--select [emp - personnel number],
	-- [geo - country (CC)],[org - company code],case when [emp - group] in ('7','9') then 'Contingent' else 'Internal' end,
	--'matrix manager not from the population'
	-- from p0_POSITION_MANAGEMENT
	--where wd_matrix_manager is not null
	--and wd_matrix_manager not in ( select distinct [emp - personnel number] from p0_POSITION_MANAGEMENT union select distinct [emp - personnel number] from w2_gold_position_management);




DELETE FROM WD_HR_TR_SUP_ORG;
INSERT INTO WD_HR_TR_SUP_ORG
select ROW_NUMBER() over(order by sup_org )
       ,'FALSE'
	   ,''
	   ,'Organization_Reference_ID'
	   ,isnull(sup_org,'')
	   ,'1900-01-01'
	   ,isnull(sup_org,'')
	   ,'FALSE'
	   ,isnull(sup_org_name,'')
	   ,''
	   ,''
	   ,'FALSE'
	   ,'TRUE'
	   ,'1900-01-01'
	   ,''
	   ,'WID'
	   ,'9c875610c4fc496499e39741b6541dbc'
	   ,''
	   ,''
	   ,''
	   ,''
	   ,'Organization_Subtype_ID'
	   ,'Supervisory'
	   ,''
	   ,'Organization_Reference_ID'
	   ,isnull(superior_org,'')
	   ,'TRUE'
	   ,'FALSE'
	   ,'TRUE'
	   ,'FALSE'
	   ,''
	   ,'Location_ID'
	   ,iif(sup_org = '99999901','CHBS',wd_location_id) Locationid
 From (select distinct sup_org,superior_persno,sup_org_name,superior_org from p0_sup_org) a
 left join (Select [emp - personnel number],wd_location_id from p0_position_management ) b
 on a.superior_persno = [emp - personnel number];


 
DELETE FROM WD_HR_TR_SUP_ORG_FLAT;
INSERT INTO WD_HR_TR_SUP_ORG_FLAT
select ROW_NUMBER() over(order by sup_org )
       ,'TRUE'
	   ,''
	   ,''
	   ,''
	   ,'1900-01-01'
	   ,isnull(sup_org,'')
	   ,'FALSE'
	   ,isnull(sup_org_name,'')
	   ,''
	   ,''
	   ,'FALSE'
	   ,'TRUE'
	   ,'1900-01-01'
	   ,''
	   ,'WID'
	   ,'9c875610c4fc496499e39741b6541dbc'
	   ,''
	   ,''
	   ,''
	   ,''
	   ,'Organization_Subtype_ID'
	   ,'Supervisory'
	   ,''
	   ,''
	   ,''
	   ,'TRUE'
	   ,'FALSE'
	   ,'TRUE'
	   ,'FALSE'
	   ,''
	   ,'Location_ID'
	   ,iif(sup_org = '99999901','CHBS',wd_location_id) Locationid
 From (select distinct sup_org,superior_persno,sup_org_name,superior_org from p0_sup_org) a
 left join (Select [emp - personnel number],wd_location_id from p0_position_management ) b
 on a.superior_persno = [emp - personnel number];

 
DELETE FROM 	  WD_HR_TR_HIRE_EMPLOYEES;
INSERT INTO   WD_HR_TR_HIRE_EMPLOYEES
select  ROW_NUMBER() over(order by [emp - personnel number] )
		,isnull(a.[emp - personnel number],'')
		,'2021-01-01'
		,''
		,''
		,''
		,IIF(ISNULL(wd_contract_end_date, '')='', '', CONVERT(varchar(10), CAST(wd_contract_end_date as date), 23))
		,IIF(ISNULL(wd_position_Entry_Date, '')='', '', CONVERT(varchar(10), CAST(wd_position_Entry_Date as date), 23))
		,''
		,''
		,''
		,''
		,''
		,'Applicant_ID'
		,iif(isnull(a.[emp - personnel number],'')<>'',concat('A',[emp - personnel number]),'')
		,''
		,'Employee_Type_ID'
		,isnull(wd_emp_type,'')
		,''
		,'Event_Classification_Subcategory_ID'
		,'Hire_Employee_Hire_Employee_Conversion'
		,''
		,isnull(wd_position_Text,'')
		,isnull(wd_position_Text,'')
		,'40'
		,'40'
		,''
		,''
		,'Organization_Reference_ID'
		,isnull(sup_org,'')
		,''
		,'Position_ID'
		,isnull(wd_positionid,'')
		,''
		,'Job_Profile_ID'
		,'Default'--isnull(wd_job_code,'')
		,''
		,'Location_ID'
		,isnull(WD_location_id,'')
		,''
		,''
		,''
		,''
		,'Position_Time_Type_ID'
		,'Full_Time'
		,''
		,'Work_Shift_ID'
		,'Default'--isnull([work schedule rule],'')
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,'Pay_Rate_Type_ID'
		,iif(isnull(lga01,'')='1003','Hourly','Salary')
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		--,[EMP - GROUP]
 From p0_position_management a
 join p0_sup_Org b
 on a. [emp - personnel number] = b.persno
 where isnull(a.[emp - group],'') not in ('7','9');




 DELETE FROM WD_HR_TR_CONTRACT_CONTINGENT_WORKER;

 insert into WD_HR_TR_CONTRACT_CONTINGENT_WORKER
 select ROW_NUMBER() over(order by [emp - personnel number] )
        ,isnull(a.[emp - personnel number],'')
		,'2021-01-01'
		,'2021-12-31'
		,IIF(ISNULL(wd_position_Entry_Date, '')='', '', CONVERT(varchar(10), CAST(wd_position_Entry_Date as date), 23))
		,''
		,'Applicant_ID'
		,iif(isnull(a.[emp - personnel number],'')<>'',concat('A',[emp - personnel number]),'')
		,''
		,''
		,''
		,''
		,'Contingent_Worker_Type_ID'
		,isnull(wd_emp_type,'')
		,''
		,''
		,''
		,''
		,isnull(wd_position_Text,'')
		,''
		,'40'
		,'40'
		,''
		,''
		,'Organization_Reference_ID'
		,isnull(sup_org,'')
		,''
		,'Position_ID'
		,isnull(wd_positionid,'')
		,''
		,'Job_Profile_ID'
		,'Default'--isnull(wd_job_code,'')
		,''
		,'Location_ID'
		,isnull(wd_location_ID,'')
		,''
		,''
		,''
		,''
		,'Position_Time_Type_ID'
		,'Full_Time'
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		--,[EMP - GROUP]
  from p0_position_management a
 join p0_sup_Org b
 on a. [emp - personnel number] = b.persno
 where isnull(a.[emp - group],'')   in ('7','9');



 DELETE FROM WD_HR_TR_CREATE_POSITION;

 INSERT INTO WD_HR_TR_CREATE_POSITION
 select  ROW_NUMBER() over(order by [emp - personnel number] )
         ,'TRUE'
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,'Organization_Reference_ID'
		 ,isnull(sup_org,'')
		 ,''
		 ,''
		 ,''
		 ,isnull(wd_positionid,'')
		 ,isnull(wd_position_Text,'')
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,IIF(ISNULL(wd_hrp1000_begda, '')='', '', CONVERT(varchar(10), CAST(wd_hrp1000_begda as date), 23))
		 ,IIF(ISNULL(wd_hrp1000_begda, '')='', '', CONVERT(varchar(10), CAST(wd_hrp1000_begda as date), 23))
		 ,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		--,[EMP - GROUP]
  from p0_position_management a
 join p0_sup_Org b
 on a. [emp - personnel number] = b.persno;


  delete from WD_HR_TR_JOB_PROFILE;
 insert into WD_HR_TR_JOB_PROFILE
 select  ROW_NUMBER() over(order by [emp - personnel number] )
  ,DENSE_RANK() over(partition by [emp - personnel number] order by [wd_job_code] )
  ,''
  ,'Job_Profile_ID'
  ,[wd_job_code]
  --,[emp - group]
  from p0_position_management
  order by [wd_job_code];


  

 delete from WD_HR_TR_COMPANY_ASSIGNMENTS;
 insert into WD_HR_TR_COMPANY_ASSIGNMENTS
 select  ROW_NUMBER() over(order by [emp - personnel number] )
  ,DENSE_RANK() over(partition by [emp - personnel number] order by wd_Company )
  ,''
  ,'Company_Reference_ID'
  ,wd_Company
  --,[emp - group]
  from p0_position_management
  order by wd_Company;


   delete from WD_HR_TR_COST_CENTER_ASSIGNMENTS;
 insert into WD_HR_TR_COST_CENTER_ASSIGNMENTS
 select  ROW_NUMBER() over(order by [emp - personnel number] )
  ,DENSE_RANK() over(partition by [emp - personnel number] order by wd_costcenter_id )
  ,''
  ,'Cost_Center_Reference_ID'
  ,wd_costcenter_id
  --,[emp - group]
  from p0_position_management
  order by wd_costcenter_id;


   

   delete from WD_HR_TR_POSITIONS_ORGANIZATION_ASSIGNMENT;
insert into WD_HR_TR_POSITIONS_ORGANIZATION_ASSIGNMENT
select  ROW_NUMBER() over(order by [emp - personnel number] )
		,''
		,''
		,'Position_ID'
		,wd_positionid
		,''
		,''
		,'' 
 From p0_position_management;



 delete from WD_HR_TR_ASSIGN_ORGANIZATION_TO_POSITIONS;
insert into WD_HR_TR_ASSIGN_ORGANIZATION_TO_POSITIONS
select * from (select  ROW_NUMBER() over(order by [emp - personnel number] ) [Position Organization Assignment Key]
		,'1' [Organization Reference Key]
		,'' [Descriptor]
		,'Organization_Reference_ID' [ID type]
		,wd_company [ID]
 From p0_position_management
 union all
 select  ROW_NUMBER() over(order by [emp - personnel number] )
		,'2'
		,''
		,'Organization_Reference_ID'
		,wd_Costcenter_id
 From p0_position_management ) a
 order by 1,2;


 WITH rcte AS (
    --- Anchor: any row in #table could be an anchor
    --- in an infinite recursion.
    SELECT superior_position_id AS start_id,
           positionid,
           CAST(positionid AS varchar(max)) AS [path]
    FROM p0_sup_org

    UNION ALL

    --- Find children. Keep this up until we circle back
    --- to the anchor row, which we keep in the "start_id"
    --- column.
    SELECT rcte.start_id,
           t.positionid,
           CAST(rcte.[path]+' -> '+t.persno AS varchar(max)) AS [path]
    FROM rcte
    INNER JOIN p0_sup_org AS t ON
        t.superior_position_id=rcte.positionid
    WHERE rcte.start_id!=rcte.positionid)

--INSERT INTO @WAVE_SUP_ORG_VALIDATION
SELECT  start_id+' ('+[path]+')', 'Circular reference in parent & child relationship;'
FROM rcte
WHERE start_id=positionid
OPTION (MAXRECURSION 0); 



SELECT   persno, 
       IIF(ISNULL(sup_org, '')='', 'Supervisory org should not be empty or null;', '') +
  IIF(ISNULL(superior_org, '')='', 'Superior org should not be empty or null;', '') +
  IIF(ISNULL(superior_persno, '')='', 'Superior Personal No. should not be empty or null;', '') +   
  IIF(ISNULL(positionid, '')='', 'Supervisory Position No. should not be empty or null;', '') ErrorText 
   FROM p0_sup_org
   WHERE (ISNULL(sup_org, '')='' OR 
          ISNULL(SUPERIOR_ORG, '')='' OR
 ISNULL(POSITIONID, '')='' OR
          ISNULL(SUPERIOR_PERSNO, '')='' );



		  SELECT  --MAX(@which_wavestage) wave, @which_report report, 
      ISNULL((SELECT TOP 1 b.PERSNO from p0_sup_org b where b.sup_org=a.sup_org), 'OpenPosi'), 'One to many relationship between supervisory & superior org;('+sup_org+')' FROM (
SELECT DISTINCT sup_org,superior_org,sup_org_manager_name
 FROM p0_sup_org ) a
 GROUP BY sup_org
 HAVING COUNT(*)>1;


 SELECT --MAX(@which_wavestage) wave, @which_report report,
  MAX(PERSNO) PERSNO, 'Primary key voilation; ('+[positionid]+')'
FROM p0_sup_org
GROUP BY [positionid]
HAVING COUNT([positionid]) > 1;


select sup_org,'org unit duplicated',count(*) from
  ( select distinct sup_org,superior_org,sup_org_name,sup_org_manager_name from p0_sup_org) a
  group by sup_org
  having count(*)>1


 /*



 select [org - position],count(*) cnt from p0_position_management
 where [org - position] is not null
 and [org - position] = '20254287'
 group by [org - position]
 having count(*)>1



 
select *, concat('P-',[org - position],'_',row_number() over(partition by [org - position] order by globalid)) new_positionid
from p0_position_management
 where    [org - position] in (
 select [org - position] from (
 select [org - position],count(*) cnt from p0_position_management
 where [org - position] is not null
 and [org - position] = '20254287'
 group by [org - position]


 
 having count(*)>1) a )

  
  */ 


--select * from WD_HR_TR_SUP_ORG order by 1
--select * from WD_HR_TR_SUP_ORG_FLAT order by 1
-- select * From WD_HR_TR_CREATE_POSITION order by 1;
--select * From WD_HR_TR_HIRE_EMPLOYEES order by 1;;
--select * From WD_HR_TR_CONTRACT_CONTINGENT_WORKER order by 1;
--select * From WD_HR_TR_JOB_PROFILE order by cast([create position key] as numeric);
--select * From WD_HR_TR_COMPANY_ASSIGNMENTS  order by  cast([create position key] as numeric);

--EXEC [PROC_WAVE_NM_AUTOMATE_SUP_ORG] 'P0', 'Sup Org', '2021-03-10'

--ERROR REPORTS
--select * from position_management_Prevalidation_report;
--select * from position_management_Error_report;

--comment1
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

  
 

  

  
   


   