DROP PROCEDURE GKDW.GK_CD_FEE_RUN_PROC_SB;

CREATE OR REPLACE PROCEDURE GKDW.gk_cd_fee_run_proc_sb as

cursor c1 is
select dim_period_name,max(dim_date) dim_date
  from time_dim td
 where td.dim_date >= trunc(sysdate-7)
   and td.dim_day = 'Wednesday'
 group by dim_period_name
 order by 2;

r1 c1%rowtype;

begin
open c1; fetch c1 into r1;
  if c1%found and r1.dim_date = trunc(sysdate-7) then
    gk_cd_fee_proc_sb(r1.dim_period_name);
    dbms_output.put_line('GK_CD_FEE_PROC EXECUTED');
  else
    dbms_output.put_line('GK_CD_FEE_PROC - NOT LAST WEDNESDAY OF MONTH');
  end if;
close c1;
end;
/


