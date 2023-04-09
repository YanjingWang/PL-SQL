DROP PROCEDURE GKDW.GK_TOTAL_PIPELINE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_total_pipeline_proc as

cursor c1 is
  select dim_date
    from gk_total_pipeline_dates_v
   where dim_date = trunc(sysdate)-1;

r1 c1%rowtype;

begin
open c1;fetch c1 into r1;

if c1%found then
  insert into gk_total_pipeline_history
    select td.dim_year,
           case when td.dim_year is null then null
                else td.dim_year||'-'||lpad(td.dim_quarter,2,'0')
           end dim_quarter,
           case when td.dim_year is null then null
                else td.dim_year||'-'||lpad(td.dim_month_num,2,'0')
           end dim_month_num,
           td.dim_period_name,
           case when td.dim_year is null then null
                else td.dim_year||'-'||lpad(td.dim_week,2,'0')
           end dim_week,
           trunc(o.estimatedclose) close_date,
           ui1.username,um.username user_manager,
           ui1.department,ui1.region sales_group,ui1.division sales_team,
           'Total Pipeline' activity_desc,ac.account,o.opportunityid,o.stage,
           case when qo.ent_potential_amount is null then nvl(o.salespotential,0)
                when qo.ent_potential_amount = 0 then nvl(o.salespotential,0)
                else qo.ent_potential_amount
           end gross_pipeline,
           o.actualclose,
           ui1.userid
      from slxdw.opportunity o
           inner join slxdw.qg_opportunity qo on o.opportunityid = qo.opportunityid
           inner join slxdw.userinfo ui1 on o.accountmanagerid = ui1.userid
           inner join slxdw.usersecurity us on ui1.userid = us.userid
           inner join slxdw.userinfo um on us.managerid = um.userid
           inner join slxdw.account ac on o.accountid = ac.accountid
           inner join slxdw.qg_account qa on ac.accountid = qa.accountid
           left outer join time_dim td on td.dim_date = r1.dim_date
           left outer join slxdw.salesprocesses sp on o.opportunityid = sp.entityid
           left outer join slxdw.salesprocessaudit spa on sp.salesprocessesid = spa.salesprocessid and o.stage = spa.stageorder||'-'||spa.stagename and spa.processtype = 'STAGE'
     where o.status = 'Open'
       and trunc(o.estimatedclose) >= trunc(sysdate)-30
--       and (o.status = 'Open' or trunc(o.actualclose) > r1.dim_date)
--       and trunc(o.createdate) <= r1.dim_date
       and lpad(nvl(spa.stageorder,'99'),2,'0') not in ('01','99')
       and upper(ui1.department) like '%ENTERPRISE%';
  commit;
end if;
close c1;
end;
/


