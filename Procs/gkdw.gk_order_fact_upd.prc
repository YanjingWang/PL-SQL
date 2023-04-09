DROP PROCEDURE GKDW.GK_ORDER_FACT_UPD;

CREATE OR REPLACE PROCEDURE GKDW.gk_order_fact_upd
as
cursor c1 is
select f.enroll_id,et.createdate,et.evxev_txfeeid from order_fact f
inner join slxdw.evxev_txfee et
on f.enroll_id = et.evxevenrollid
and f.txfee_id = et.EVXEV_TXFEEID
where book_date is null
and enroll_status = 'Cancelled'
and et.billingdate is null;

cursor c2 is
 select enroll_id,enroll_status,enroll_status_desc,last_update_date,et.evxevenrollid,et.enrollstatus,et.enrollstatusdesc,et.modifydate 
from order_fact f1
inner join evxenrollhx et
on f1.enroll_id = et.evxevenrollid
where f1.enroll_status !=et.enrollstatus;

cursor c3 is
select distinct f.acct_name,f.order_header_label,e.evxevenrollid,
et.attendeeaccount,et.registrationcode from order_fact f
inner join evxenrollhx e
on f.enroll_id = e.evxevenrollid
inner join evxevticket et
on e.evxevticketid = et.evxevticketid
where 
f.order_header_label = et.registrationcode
and trim(upper(f.acct_name)) != upper(trim(attendeeaccount))
and f.enroll_id not in ('QGKID09FLJEF')
and trunc(f.creation_date) >= to_date('10/30/2017','mm/dd/yyyy');

cursor c4 is
select f.enroll_id,eh.evxevenrollid,eh.evxevticketid,et.sfopportunityid
from order_fact f
inner join slxdw.evxenrollhx eh
on f.enroll_id = eh.evxevenrollid
inner join slxdw.qg_evticket et
on eh.evxevticketid = et.evxevticketid
where (trunc(f.creation_date) >= trunc(sysdate)-1 or trunc(f.last_update_DATE) >= trunc(sysdate)-1)
and et.sfopportunityid is not null;

r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;
r4 c4%rowtype;

begin
for r1 in c1 loop
update order_fact f
set book_date = r1.createdate
where enroll_id = r1.enroll_id
and txfee_id = r1.evxev_txfeeid
and f.book_date is null
and f.enroll_status = 'Cancelled'
and f.creation_date > trunc(sysdate)-60;
end loop;
commit;

for r2 in c2 loop
update order_fact f
set f.enroll_status = r2.enrollstatus,
f.enroll_status_desc = r2.enrollstatusdesc,
f.last_update_date = r2.modifydate
where f.enroll_id = r2.evxevenrollid
and f.enroll_status !=r2.enrollstatus
and trunc(f.creation_date) > to_date('10/28/2016','mm/dd/yyyy');
end loop;
commit;

for r3 in c3 loop
dbms_output.put_line(r3.evxevenrollid);
update order_fact f
set f.acct_name = r3.attendeeaccount
where f.enroll_id = r3.evxevenrollid and 
f.order_header_label = r3.registrationcode;
end loop;
commit;

for r4 in c4 loop
update order_fact f
set sf_opportunity_id = r4.sfopportunityid
where f.enroll_id = r4.enroll_id
and (trunc(f.creation_date) >= trunc(sysdate)-1 or trunc(f.last_update_DATE) >= trunc(sysdate)-1);
end loop;
commit;

exception
when others then 
rollback;
send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_ORDER_FACT_UPD FAILED',SQLERRM);

end;
/


