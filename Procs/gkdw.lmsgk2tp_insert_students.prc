DROP PROCEDURE GKDW.LMSGK2TP_INSERT_STUDENTS;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_insert_Students as 

 P_TABLENAME_IN VARCHAR2(200);
  LAST_RUN_DATE_OUT DATE;

  
cursor c1 is 
    select  cd.CUST_ID STUDENT_NO_GK, 
        cd.ACCT_ID  ORG_NO_GK, qc.LEGACY_NO STUDENT_NO_TP, 
        c.FIRSTNAME FNAME, c.LASTNAME LNAME,  cd.TITLE TITLE,  
        cd.ADDRESS1 ADDRESS1, cd.ADDRESS2 ADDRESS2, 
        cd.CITY CITY, 
        case cd.COUNTRY
        when 'CAN'      
        then cd.PROVINCE
        when 'CANADA'
        then cd.PROVINCE
        else cd.STATE
        END STATE , 
        cd.ZIPCODE ZIPCODE, cd.COUNTRY COUNTRY, 
        cd.EMAIL EMAIL, cd.WORKPHONE PHONE, null PHONE_EXT, c.FAX FAX,   
        null ISMANAGER,  cd.EMPLOYEE_ID EMPLOYEE_NUMBER, null  COST_CENTER,  
        null MANAGEREMAIL, null MANAGERFIRSTNAME, null MANAGERLASTNAME,
        null ONLINEPASSWORD, null REGION, null SUPERVISOR_NO_GK,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY, sysdate DATECREATED, sysdate DATEMODIFIED    
    from cust_dim cd
    join contact c on cd.CUST_ID = c.CONTACTID
    join qg_contact qc on cd.CUST_ID = qc.CONTACTID
    join LMSGK2TP_ACCOUNTS la on cd.ACCT_ID = la.ACCT_ID 
    where nvl(c.IMPORTSOURCE, ' ') <> 'Salesforce'
--and (cd.CREATION_DATE >= '29-OCT-2010' or cd.LAST_UPDATE_DATE >= '29-OCT-2010') ;
    and (cd.CREATION_DATE >= LAST_RUN_DATE_OUT or cd.LAST_UPDATE_DATE >= LAST_RUN_DATE_OUT) ;


r1 c1%rowtype;
tmpVar NUMBER;

begin

    tmpVar := 0;

    P_TABLENAME_IN := 'LMSGK2TP_students@dx_prod';
    LAST_RUN_DATE_OUT := NULL;
    

   select trunc(last_run_date) into last_run_date_out from LMSGK2TP_TIMESTAMP@dx_prod ;
    
    DBMS_OUTPUT.Put_Line('LAST_RUN_DATE_OUT = ' || LAST_RUN_DATE_OUT);


  delete LMSGK2TP_STUDENTS@dx_prod;
    commit;

    open c1; 
    loop

  
    fetch c1 into r1; 
    exit when c1%NOTFOUND;


    insert into LMSGK2TP_STUDENTS@dx_prod
            (STUDENT_NO_GK, ORG_NO_GK, STUDENT_NO_TP, FNAME, LNAME, TITLE,
            ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, COUNTRY, 
            EMAIL, PHONE, PHONE_EXT, FAX,
            ISMANAGER, EMPLOYEE_NUMBER, 
            COST_CENTER, MANAGEREMAIL, MANAGERFIRSTNAME, MANAGERLASTNAME, ONLINEPASSWORD, REGION, SUPERVISOR_NO_GK, 
            CREATEDBY, MODIFIEDBY, DATECREATED, DATEMODIFIED
            )
    values (r1.STUDENT_NO_GK, r1.ORG_NO_GK, r1.STUDENT_NO_TP, r1.FNAME, r1.LNAME, r1.TITLE,
            r1.ADDRESS1, r1.ADDRESS2, r1.CITY, r1.STATE, r1.ZIPCODE, r1.COUNTRY, 
            r1.EMAIL, r1.PHONE, r1.PHONE_EXT, r1.FAX,
            r1.ISMANAGER, r1.EMPLOYEE_NUMBER, 
            r1.COST_CENTER, r1.MANAGEREMAIL, r1.MANAGERFIRSTNAME, r1.MANAGERLASTNAME, r1.ONLINEPASSWORD, r1.REGION, r1.SUPERVISOR_NO_GK, 
            r1.CREATEDBY, r1.MODIFIEDBY, r1.DATECREATED, r1.DATEMODIFIED
            );    
 
end loop;
close c1;

dbms_output.put_line('LMSGK2TP_STUDENTS has been loaded... .');

commit;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE(' No Data for LMSGK2TP_STUDENTS ...' ) ;
       RAISE;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_STUDENTS ...' ) ;
       RAISE;
       
end;
/


