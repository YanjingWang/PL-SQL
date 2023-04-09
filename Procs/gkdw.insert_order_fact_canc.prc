DROP PROCEDURE GKDW.INSERT_ORDER_FACT_CANC;

CREATE OR REPLACE PROCEDURE GKDW.insert_order_fact_canc IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       insert_order_fact_canc
   PURPOSE:    Create Dummy rows in ORDER_FACT for any cancellations that may not have been netted out, 
                  by a separate cancellation entry in SLX. 
*****************************************************************************/
BEGIN
/********** INSERTS FOR SLXDW CANCELLATIONS ***********************/

INSERT INTO ORDER_FACT(
   ENROLL_ID, EVENT_ID, CUST_ID, 
   ENROLL_DATE, KEYCODE, BOOK_DATE, 
   REV_DATE, SHIP_DATE, ENROLL_SOURCE, 
   QUANTITY, BOOK_AMT, CURR_CODE, 
   CONV_RATE, SALESPERSON, PROMO_CODE, 
   OPPORTUNITY_ID, ORACLE_TRX_ID, ORACLE_TRX_NUM, 
   GKDW_SOURCE, 
   ZIP_CODE, METRO_AREA, COUNTRY, 
   DISTRICT, TERRITORY, REGION, 
   SALES_REP, REGION_REP, CREATION_DATE, 
   LAST_UPDATE_DATE, ENROLL_STATUS, TRX_TYPE, 
   TXFEE_ID, BILL_DATE, BILL_STATUS, 
   ENROLL_STATUS_DESC, FEE_TYPE, ENROLL_STATUS_DATE, 
   PP_SALES_ORDER_ID, SOURCE, BAL_DUE, 
   LIST_PRICE,
   PPCARD_ID,
   REG_CODE )     
select    ENROLL_ID, EVENT_ID, CUST_ID, 
   ENROLL_DATE, KEYCODE, 
   decode(book_date, null, null, trunc(ENROLL_STATUS_DATE)) "BOOK_DATE" ,
   case 
   when rev_date is null 
   then null
   when rev_date > trunc(o.ENROLL_STATUS_DATE) 
   then rev_date
   else trunc(o.ENROLL_STATUS_DATE)
   end  "REV_DATE", 
   SHIP_DATE, ENROLL_SOURCE, 
   QUANTITY, (-1) * BOOK_AMT "BOOK_AMT", 
   CURR_CODE, 
   CONV_RATE, SALESPERSON, PROMO_CODE, 
   OPPORTUNITY_ID, ORACLE_TRX_ID, ORACLE_TRX_NUM, 
   'DATA_FIX' "GKDW_SOURCE", 
   ZIP_CODE, METRO_AREA, COUNTRY, 
   DISTRICT, TERRITORY, REGION, 
   SALES_REP, REGION_REP, 
   o.ENROLL_STATUS_DATE "CREATION_DATE", 
   o.ENROLL_STATUS_DATE "LAST_UPDATE_DATE", 
   ENROLL_STATUS, TRX_TYPE, 
   o.txfee_ID || '-CAN' "TXFEE_ID", 
   decode(bill_date, null, null, trunc(ENROLL_STATUS_DATE))"BILL_DATE", 
   BILL_STATUS, 
   ENROLL_STATUS_DESC, FEE_TYPE, ENROLL_STATUS_DATE, 
   PP_SALES_ORDER_ID, SOURCE, 
   (-1) * BAL_DUE "BAL_DUE", 
   LIST_PRICE,
   PPCARD_ID, 
   REG_CODE
from order_fact o
where --o.creation_date >= to_date('08/05/2017','mm/dd/yyyy') and -- SR: 09/21/2017 After SF stabilization
o.enroll_id in 
      ( 
       select enroll_id  
      from ORDER_FACT f
      where enroll_status = 'Cancelled'
      and gkdw_source like 'SLXDW'
      group by enroll_id
      having sum(book_amt) <> 0
      and count(enroll_id) = 1    
      )
and not exists 
    (
    select of1.enroll_id 
    from ORDER_FACT of1 
    where of1.enroll_id = o.enroll_id 
    and gkdw_source = 'DATA_FIX' 
    );


/******** INSERTS FOR  SMDW (SCRIPT) CANCELLATIONS  ****************************/

INSERT INTO ORDER_FACT(
   ENROLL_ID, EVENT_ID, CUST_ID, 
   ENROLL_DATE, KEYCODE, BOOK_DATE, 
   REV_DATE, SHIP_DATE, ENROLL_SOURCE, 
   QUANTITY, BOOK_AMT, CURR_CODE, 
   CONV_RATE, SALESPERSON, PROMO_CODE, 
   OPPORTUNITY_ID, ORACLE_TRX_ID, ORACLE_TRX_NUM, 
   GKDW_SOURCE, 
   ZIP_CODE, METRO_AREA, COUNTRY, 
   DISTRICT, TERRITORY, REGION, 
   SALES_REP, REGION_REP, CREATION_DATE, 
   LAST_UPDATE_DATE, ENROLL_STATUS, TRX_TYPE, 
   TXFEE_ID, BILL_DATE, BILL_STATUS, 
   ENROLL_STATUS_DESC, FEE_TYPE, ENROLL_STATUS_DATE, 
   PP_SALES_ORDER_ID, SOURCE, BAL_DUE, 
   LIST_PRICE)       
select  ENROLL_ID, EVENT_ID, CUST_ID, 
   ENROLL_DATE,    KEYCODE, 
   BOOK_DATE "BOOK_DATE", 
   REV_DATE "REV_DATE", 
   SHIP_DATE, ENROLL_SOURCE, 
   QUANTITY, (-1) * BOOK_AMT "BOOK_AMT", 
   CURR_CODE, 
   CONV_RATE, SALESPERSON, PROMO_CODE, 
   OPPORTUNITY_ID, ORACLE_TRX_ID, ORACLE_TRX_NUM, 
   'DATA_FIX' "GKDW_SOURCE", 
   ZIP_CODE, METRO_AREA, COUNTRY, 
   DISTRICT, TERRITORY, REGION, 
   SALES_REP, REGION_REP, 
   CREATION_DATE , 
   LAST_UPDATE_DATE, 
   ENROLL_STATUS, TRX_TYPE, 
   o.txfee_ID || '-CAN' "TXFEE_ID", 
   BILL_DATE, 
   BILL_STATUS, 
   ENROLL_STATUS_DESC, FEE_TYPE, ENROLL_STATUS_DATE, 
   PP_SALES_ORDER_ID, SOURCE, 
   (-1) * BAL_DUE "BAL_DUE", 
   o.LIST_PRICE 
from order_fact o
where o.enroll_id in 
      (  
      select enroll_id  
      from ORDER_FACT f
      where enroll_status = 'Cancelled'
      and gkdw_source = 'SCRIPT'
      group by enroll_id
      having sum(book_amt) <> 0
      and count(enroll_id) = 1      
      )
and not exists 
    (
    select of1.enroll_id 
    from ORDER_FACT of1 
    where of1.enroll_id = o.enroll_id 
    and gkdw_source = 'DATA_FIX' 
    );

update order_fact o   --JJones set book date for cancellations that are missing them 
   set 
    o.book_date = trunc(sysdate)
    /*( select case when trunc(o.book_date) is null then nc.book_date else trunc(o.enroll_status_date)  end                     
        from 
              order_fact nc 
        where  
              o.ENROLL_ID = nc.enroll_id  
          and nc.book_date is not null 
          and o.txfee_id like '%-CAN'
          and o.book_date is null
          )*/
   ,o.modify_user = 'DBA' 
         
where exists ( select nc.enroll_id
        from 
              order_fact nc 
        where  
              o.ENROLL_ID = nc.enroll_id  
          and nc.book_date is not null 
          and o.txfee_id like '%-CAN'
          and o.book_date is null
   
      ) 
      
   
;






    commit;
    
/************** END of FIX *****************/    
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END insert_order_fact_canc;
/


