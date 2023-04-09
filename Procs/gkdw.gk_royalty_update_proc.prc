DROP PROCEDURE GKDW.GK_ROYALTY_UPDATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_royalty_update_proc as

begin

delete from gk_royalty_lookup_bkp;

insert into gk_royalty_lookup_bkp
select * from gk_royalty_lookup;

delete from gk_royalty_lookup;

insert into gk_royalty_lookup
select ll.vendor,ll.course_code,
ll.us_fee,
ll.ca_fee,
--       to_number(replace(replace(ll.us_fee,'"',''),',','')) us_fee,
--       to_number(replace(replace(ll.ca_fee,'"',''),',','')) ca_fee,
       to_date(substr(ll.active_date,1,instr(ll.active_date,' ')-1),'mm/dd/yyyy') active_date,
       to_date(substr(ll.inactive_date,1,instr(ll.inactive_date,' ')-1),'mm/dd/yyyy') inactive_date
from GK_ROYALTY_LOOKUP_LOAD ll
     where exists (select 1 from gk_partner_royalty pr where ll.vendor = pr.vendor_code);

commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_ROYALTY_UPDATE_PROC FAILED',SQLERRM);


end;
/


