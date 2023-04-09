DROP PROCEDURE GKDW.GK_CANCEL_REENROLL_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_cancel_reenroll_proc as
cursor c1 is
select orig_enroll_id,min(transfer_enroll_id) transfer_enroll_id
  from gk_reenroll_v
 where cancelled_date >= trunc(sysdate)-30
 group by orig_enroll_id;

begin
for r1 in c1 loop
  update order_fact
     set transfer_enroll_id = r1.transfer_enroll_id
   where enroll_id = r1.orig_enroll_id
     and book_amt < 0;

  update order_fact
     set orig_enroll_id = r1.orig_enroll_id
   where enroll_id = r1.transfer_enroll_id
     and book_amt > 0;
end loop;
commit;
end;
/


