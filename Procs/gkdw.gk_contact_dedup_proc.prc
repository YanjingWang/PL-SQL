DROP PROCEDURE GKDW.GK_CONTACT_DEDUP_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_contact_dedup_proc as


 
begin


   
 
  DBMS_OUTPUT.PUT_LINE(' GK_CONTACT_DEDUP_PROC...') ;
  
  --- slxdw  dELETES ------------
    delete slxdw.contact  
    where contactid in 
    (
    select contactid 
     from contact_merge@slx_dedup
    where wh_complete is null 
    );

    delete slxdw.qg_contact  
    where contactid  in 
    (
    select contactid 
     from contact_merge@slx_dedup
    where wh_complete is null 
    );
    
    delete slxdw.GK_ENT_OPP_CONTACT  
    where contactid in 
    (
    select contactid 
     from contact_merge@slx_dedup
    where wh_complete is null 
    );
    

   --- gkdw dELETES ------------
    delete gkdw.cust_dim 
    where cust_id in 
    (
    select contactid 
     from contact_merge@slx_dedup
    where wh_complete is null 
    );

    delete gkdw.instructor_dim 
    where cust_id  in 
    (
    select contactid 
     from contact_merge@slx_dedup
    where wh_complete is null 
    );

   --- slxdw11g dELETES ------------
--    delete contact@slxdw11g
--    where contactid in 
--    (
--    select contactid 
--     from contact_merge@slx_dedup
--    where wh_complete is null 
--    );
--
--    delete qg_contact@slxdw11g  
--    where contactid in 
--    (
--    select contactid 
--     from contact_merge@slx_dedup
--    where wh_complete is null 
--    );
--
--    delete GK_ENT_OPP_CONTACT@slxdw11g 
--    where contactid  in 
--    (
--    select contactid 
--     from contact_merge@slx_dedup
--    where wh_complete is null 
--    );
    
commit;

DBMS_OUTPUT.PUT_LINE('GDW Deletes Completed' ) ;

   --- Update SLX When done ------------
    update contact_merge@slx_dedup
    set wh_complete = 'T'
    where wh_complete is null ;

DBMS_OUTPUT.PUT_LINE('DEDUP Update Completed' ) ;
     
  
commit;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in GK_CONTACT_DEDUP_PROC...' ) ;
       rollback  ;
       RAISE;
end ;
/


