DROP PROCEDURE GKDW.GK_ORDER_FACT_NAMED_ACCT;

CREATE OR REPLACE PROCEDURE GKDW.gk_order_fact_named_acct as

cursor c0 is
select o.cust_id,o.ob_national_rep_id,o.ob_national_rep_name,o.ob_national_terr_num,
       ui.userid ob_nat_user_id,ui.username ob_nat_user,
       case when ui.division is null then c.ob_national_terr_num else ui.division end ob_nat_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ob_national_rep_id = ui.userid and ui.region != 'Retired'
where trunc(book_date) >= trunc(sysdate)-30
and (o.ob_national_rep_id != ui.userid
or o.ob_national_rep_name != ui.username
or o.ob_national_terr_num != case when ui.division is null then c.ob_national_terr_num else ui.division end); -- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90

cursor c1 is
select o.cust_id cust_id,o.ob_rep_id ob_rep_id,o.ob_rep_name ob_rep_name,o.ob_terr_num ob_terr_num,
       ui.userid ob_user_id,ui.username ob_user,
       case when ui.division is null then c.ob_terr_num else ui.division end ob_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ob_rep_id = ui.userid and ui.region != 'Retired'
where trunc(book_date) >= trunc(sysdate)-30
and (o.ob_rep_id != ui.userid
or o.ob_rep_name != ui.username
or o.ob_terr_num != case when ui.division is null then c.ob_terr_num else ui.division end); -- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90

cursor c2 is
select o.cust_id,o.ent_national_rep_id,o.ent_national_rep_name,o.ent_national_terr_num,
       ui.userid ent_nat_user_id,ui.username ent_nat_user,
       case when ui.division is null then c.ent_national_terr_num else ui.division end ent_nat_div
from order_fact o
    inner join qg_contact@slx c on o.cust_id = c.contactid
    inner join slxdw.userinfo ui on c.ent_national_rep_id = ui.userid and ui.region != 'Retired'
where trunc(book_date) >= trunc(sysdate)-30 
and (o.ent_national_rep_id != ui.userid
or o.ent_national_rep_name != ui.username
or o.ent_national_terr_num != case when ui.division is null then c.ob_national_terr_num else ui.division end);-- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90

type of_cust_id is table of varchar2(50);
type of_ob_national_rep_id is table of varchar2(12);
type of_ob_national_rep_name is table of VARCHAR2 (64 Byte);
type of_ob_national_terr_num is table of VARCHAR2 (25 Byte);
type of_ob_nat_user_id is table of varchar2(12);
type of_ob_nat_user is table of varchar2(64);
type of_ob_nat_div is table of varchar2(50);

type of_cust_id_1 is table of varchar2(50);
type of_ob_rep_id is table of varchar2(12);
type of_ob_rep_name is table of VARCHAR2 (64 Byte);
type of_ob_terr_num is table of VARCHAR2 (25 Byte);
type of_ob_user_id is table of varchar2(12);
type of_ob_user is table of varchar2(64);
type of_ob_div is table of varchar2(50);

type of_cust_id_2 is table of varchar2(50);
type of_ent_national_rep_id is table of varchar2(12);
type of_ent_national_rep_name is table of VARCHAR2 (64 Byte);
type of_ent_national_terr_num is table of VARCHAR2 (25 Byte);
type of_ent_nat_user_id is table of varchar2(12);
type of_ent_nat_user is table of varchar2(64);
type of_ent_nat_div is table of varchar2(50);

p_of_cust_id of_cust_id;
p_of_ob_national_rep_id of_ob_national_rep_id;
p_of_ob_national_rep_name of_ob_national_rep_name;
p_of_ob_national_terr_num of_ob_national_terr_num;
p_of_ob_nat_user_id of_ob_nat_user_id;
p_of_ob_nat_user of_ob_nat_user;
p_of_ob_nat_div of_ob_nat_div;

p_of_cust_id_1 of_cust_id_1;
p_of_ob_rep_id of_ob_rep_id;
p_of_ob_rep_name of_ob_rep_name;
p_of_ob_terr_num of_ob_terr_num;
p_of_ob_user_id of_ob_user_id;
p_of_ob_user of_ob_user;
p_of_ob_div of_ob_div;

p_of_cust_id_2 of_cust_id_2;
p_of_ent_national_rep_id of_ent_national_rep_id;
p_of_ent_national_rep_name of_ent_national_rep_name;
p_of_ent_national_terr_num of_ent_national_terr_num;
p_of_ent_nat_user_id of_ent_nat_user_id;
p_of_ent_nat_user of_ent_nat_user;
p_of_ent_nat_div of_ent_nat_div;
--type p_nat_rep is table of c0%rowtype;
--l_p_nat_rep p_nat_rep;

begin
--update order_fact
--set ob_national_rep_id = null,
--    ob_national_rep_name = null,
--    ob_national_terr_num = null,
--    ob_rep_id = null,
--    ob_rep_name = null,
--    ob_terr_num = null
--  --  ent_national_rep_id = null,
-- --   ent_national_rep_name = null,
--  --  ent_national_terr_num = null
--where book_date >= trunc(sysdate)-90;-- SR 01/20/2016 changed from 02/01/2016 to trunc(sysdate)-90;
--commit;

open c0;
loop
fetch c0 bulk collect into p_of_cust_id,p_of_ob_national_rep_id,p_of_ob_national_rep_name,p_of_ob_national_terr_num,p_of_ob_nat_user_id,p_of_ob_nat_user,p_of_ob_nat_div limit 10000;
exit when p_of_cust_id.count() = 0;
dbms_output.put_line('p_of_cust_id - '||p_of_cust_id.count());
forall i in p_of_cust_id.first..p_of_cust_id.last 
update order_fact
set ob_national_rep_id = p_of_ob_nat_user_id(i),
         ob_national_rep_name = p_of_ob_nat_user(i),
         ob_national_terr_num = p_of_ob_nat_div(i)
   where cust_id = p_of_cust_id(i)
   and trunc(creation_date) >= trunc(sysdate)-30
   and (ob_national_rep_id != p_of_ob_nat_user_id(i)
        or ob_national_rep_name != p_of_ob_nat_user(i)
         or ob_national_terr_num != p_of_ob_nat_div(i));
end loop;
close c0;
commit;

open c1;
loop
fetch c1 bulk collect into p_of_cust_id_1,p_of_ob_rep_id,p_of_ob_rep_name,p_of_ob_terr_num,p_of_ob_user_id,p_of_ob_user,p_of_ob_div limit 10000;
exit when p_of_cust_id_1.count() = 0;
   dbms_output.put_line('p_of_cust_id_1 - '||p_of_cust_id_1.count());
forall i in p_of_cust_id_1.first..p_of_cust_id_1.last 
update order_fact
     set ob_rep_id = p_of_ob_user_id(i),
         ob_rep_name = p_of_ob_user(i),
         ob_terr_num = p_of_ob_div(i)
   where cust_id = p_of_cust_id_1(i)
   and trunc(creation_date) >= trunc(sysdate)-30
   and (ob_rep_id != p_of_ob_user_id(i)
   or ob_rep_name != p_of_ob_user(i)
   or ob_terr_num = p_of_ob_div(i));
end loop;
close c1;
commit;

open c2;
loop
fetch c2 bulk collect into p_of_cust_id_2,p_of_ent_national_rep_id,p_of_ent_national_rep_name,p_of_ent_national_terr_num,p_of_ent_nat_user_id,p_of_ent_nat_user,p_of_ent_nat_div limit 10000;
exit when p_of_cust_id_2.count() = 0;
dbms_output.put_line('p_of_cust_id_2 - '||p_of_cust_id_2.count());
forall i in p_of_cust_id_2.first..p_of_cust_id_2.last 
update order_fact
set ent_national_rep_id = p_of_ent_nat_user_id(i),
         ent_national_rep_name = p_of_ent_nat_user(i),
         ent_national_terr_num = p_of_ent_nat_div(i)
   where cust_id = p_of_cust_id_2(i)
   and trunc(creation_date) >= trunc(sysdate)-30
   and (ent_national_rep_id != p_of_ent_nat_user_id(i)
        or ent_national_rep_name != p_of_ent_nat_user(i)
         or ent_national_terr_num != p_of_ent_nat_div(i));
end loop;
close c2;
commit;

exception
when others then 
rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_order_fact_named_acct FAILED',SQLERRM);
end;
/


