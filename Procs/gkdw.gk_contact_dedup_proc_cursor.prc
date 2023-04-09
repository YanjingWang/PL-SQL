DROP PROCEDURE GKDW.GK_CONTACT_DEDUP_PROC_CURSOR;

CREATE OR REPLACE PROCEDURE GKDW.gk_contact_dedup_proc_cursor as


CURSOR c1 IS
SELECT contactid 
    from contact_merge@slx_imp
where wh_complete is null ;


  r1 c1%ROWTYPE;
  
begin


      

open c1; 
loop
  
    fetch c1 into r1; 
    exit when c1%NOTFOUND;
   
 
  DBMS_OUTPUT.PUT_LINE(' GK_CONTACT_DEDUP_PROC...'|| r1.contactid ) ;
  
  --- slxdw  dELETES ------------
    delete slxdw.contact  
    where contactid  = r1.contactid ;

    delete slxdw.qg_contact  
    where contactid  = r1.contactid ;

    delete slxdw.GK_ENT_OPP_CONTACT  
    where contactid  = r1.contactid ;

   --- gkdw dELETES ------------
    delete gkdw.cust_dim 
    where cust_id  = r1.contactid ;

    delete gkdw.instructor_dim 
    where cust_id  = r1.contactid ;

   --- slxdw11g dELETES ------------
    delete contact@slxdw11g
    where contactid  = r1.contactid ;

    delete qg_contact@slxdw11g  
    where contactid  = r1.contactid ;

    delete GK_ENT_OPP_CONTACT@slxdw11g 
    where contactid  = r1.contactid ;

   --- Update SLX When done ------------
    update contact_merge@slx_imp
    set wh_complete = 'T'
    where contactid = r1.contactid ;

     
end loop;
close c1;

 
  
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


