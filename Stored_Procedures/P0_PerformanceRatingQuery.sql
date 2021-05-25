

		select persno_new,wd_opmid,period_start_date,period_End_date,sixth,seventh,performance_rating From (
	select  distinct  isnull(a.persno_new,'') persno_new
	 ,isnull(a.wd_opmid,'') wd_opmid,[emp - group],
	IIF(ISNULL(begda, '')='', '', CONVERT(varchar(10), CAST(begda as date), 101))  as period_Start_date,
	IIF(ISNULL(endda, '')='', '', CONVERT(varchar(10), CAST(endda as date), 101))  as period_End_Date
	,'' as sixth,'' as seventh,isnull(yperfrat,'') as performance_rating,year(endda) as end_year,
	row_number() over(partition by persno_new,year(endda) order by endda)  as rnk
	 from p0_position_management a
	join 	
	( select distinct pernr,begda,endda, yperfrat from [dbo].P0_PA9002
	where begda>='2017-01-01') b 
--and endda<='2019-12-31') b
	on pernr=[emp - personnel number]
	
	) v
	where rnk=1 
and [emp - group] not in ('7','9')
        and isnull(performance_rating,'')<>''
	order by 1,3;

---validation
select * from p0_position_management a
	join 	
	( select distinct pernr,begda,endda, yperfrat from [dbo].P0_PA9002
	where begda>='2017-01-01' ) b
	on pernr=[emp - personnel number]
where isnull(yperfrat ,'') ='';



