DROP PROCEDURE GKDW.GK_ORDER_FACT_INV_NUM_UPD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_order_fact_inv_num_upd_proc
as
begin
update order_fact 
set oracle_trx_num = GET_ORA_TRX_NUM(txfee_id),
last_update_date = sysdate
where trunc(last_update_date) >= trunc(sysdate) -7
and oracle_trx_num is null;
commit;
end;
/


