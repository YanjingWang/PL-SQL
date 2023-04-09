DROP PROCEDURE GKDW.ORDER_FACT_ORDER_HDR_UPD;

CREATE OR REPLACE PROCEDURE GKDW.ORDER_FACT_ORDER_HDR_UPD
AS
   CURSOR c1
   IS
        SELECT f.enroll_id, et.evxev_txfeeid, oh.sfdc_order_header_label
          FROM order_fact f
               INNER JOIN slxdw.EVXEV_TXFEE et
                  ON     f.enroll_id = et.evxevenrollid
                     AND f.txfee_id = et.EVXEV_TXFEEID
               INNER JOIN sfdc_order_enrollment@slx oe
                  ON oe.slx_enrollment_id = f.enroll_id
               INNER JOIN SFDC_ORDER_details@slx od
                  ON oe.sfdc_order_details_id = od.sfdc_order_details_id
               INNER JOIN SFDC_ORDER_HEADER@slx oh
                  ON od.sfdc_order_header_id = oh.sfdc_order_header_id
         WHERE oh.sfdc_order_header_label IS NOT NULL
      ORDER BY f.enroll_id;
BEGIN

for r1 in c1 loop
update order_fact 
set order_header_label = r1.sfdc_order_header_label
where enroll_id = r1.enroll_id
and txfee_id = r1.evxev_txfeeid
and order_header_label is null
and trunc(creation_date)>= to_date('10/30/2016','mm/dd/yyyy');
end loop;
commit;

exception
  when others then
    rollback;
     send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','ORDER_FACT_ORDER_HDR_UPD FAILED',SQLERRM);
   end;
/


