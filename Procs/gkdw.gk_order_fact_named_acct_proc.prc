DROP PROCEDURE GKDW.GK_ORDER_FACT_NAMED_ACCT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_order_fact_named_acct_proc as
-- This is no longer being used due to performance issue. Created a new procedure gk_order_fact_named_acct. This is just a back up
cursor c0 is
select o.cust_id,o.ob_national_rep_id,o.ob_national_rep_name,o.ob_national_terr_num,
       ui.userid ob_nat_user_id,ui.username ob_nat_user,
       case when ui.division is null then c.ob_national_terr_num else ui.division end ob_nat_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ob_national_rep_id = ui.userid and ui.region != 'Retired'
where book_date >= trunc(sysdate)-90 -- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90
--and (
--(o.ob_national_rep_id != ui.userid or o.ob_national_rep_id is null)
--or (o.ob_national_terr_num != case when ui.division is null then c.ob_national_terr_num else ui.division end or o.ob_national_terr_num is null)
--)
order by 4;

cursor c1 is
select o.cust_id,o.ob_rep_id,o.ob_rep_name,o.ob_terr_num,
       ui.userid ob_user_id,ui.username ob_user,
       case when ui.division is null then c.ob_terr_num else ui.division end ob_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ob_rep_id = ui.userid and ui.region != 'Retired'
where book_date >= trunc(sysdate)-90 -- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90
--and (
--(o.ob_rep_id != ui.userid or o.ob_rep_id is null)
--or (o.ob_terr_num != case when ui.division is null then c.ob_terr_num else ui.division end or o.ob_terr_num is null)
--)
order by 4;

cursor c2 is
select o.cust_id,o.ent_national_rep_id,o.ent_national_rep_name,o.ent_national_terr_num,
       ui.userid ent_nat_user_id,ui.username ent_nat_user,
       case when ui.division is null then c.ent_national_terr_num else ui.division end ent_nat_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ent_national_rep_id = ui.userid and ui.region != 'Retired'
where book_date >= trunc(sysdate)-90 -- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90
--  and (
--      (o.ent_national_rep_id != ui.userid or o.ent_national_rep_id is null)
--      or (o.ent_national_terr_num != case when ui.division is null then c.ent_national_terr_num else ui.division end or o.ent_national_terr_num is null)
--      )
 order by 4;

begin
update order_fact
set ob_national_rep_id = null,
    ob_national_rep_name = null,
    ob_national_terr_num = null,
    ob_rep_id = null,
    ob_rep_name = null,
    ob_terr_num = null,
    ent_national_rep_id = null,
    ent_national_rep_name = null,
    ent_national_terr_num = null
where book_date >= trunc(sysdate)-90;-- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90;
commit;

for r0 in c0 loop
  update order_fact
     set ob_national_rep_id = r0.ob_nat_user_id,
         ob_national_rep_name = r0.ob_nat_user,
         ob_national_terr_num = r0.ob_nat_div
   where cust_id = r0.cust_id
   and book_date >= trunc(sysdate)-90;
end loop;
commit;

for r1 in c1 loop
  update order_fact
     set ob_rep_id = r1.ob_user_id,
         ob_rep_name = r1.ob_user,
         ob_terr_num = r1.ob_div
   where cust_id = r1.cust_id
   and book_date >= trunc(sysdate)-90;
end loop;
commit;

for r2 in c2 loop
  update order_fact
     set ent_national_rep_id = r2.ent_nat_user_id,
         ent_national_rep_name = r2.ent_nat_user,
         ent_national_terr_num = r2.ent_nat_div
   where cust_id = r2.cust_id
   and book_date >= trunc(sysdate)-90;
end loop;
commit;
exception
when others then 
rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_order_fact_named_acct_proc FAILED',SQLERRM);
end;
/


