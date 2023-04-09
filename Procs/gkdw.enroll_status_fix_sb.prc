DROP PROCEDURE GKDW.ENROLL_STATUS_FIX_SB;

CREATE OR REPLACE PROCEDURE GKDW.Enroll_status_fix_sb as


cursor C1 is
select od.enroll_id,ev.enrollstatus 
from order_fact od , evxenrollhx@SLX.REGRESS.RDBMS.DEV.US.ORACLE.COM  ev
where od.enroll_id=ev.evxevenrollid
and od.enroll_status <> ev.enrollstatus;
--and ev.enrollstatus='Cancelled';

counter number :=0;

begin

for R1 in C1 loop

update order_fact 
set enroll_status=R1.enrollstatus
where enroll_id=R1.enroll_id;

update slxdw.evxenrollhx 
set enrollstatus=R1.enrollstatus
where evxevenrollid=R1.enroll_id;

end loop;

commit;

end;
/


