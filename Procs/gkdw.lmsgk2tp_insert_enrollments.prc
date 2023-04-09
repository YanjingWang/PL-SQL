DROP PROCEDURE GKDW.LMSGK2TP_INSERT_ENROLLMENTS;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_insert_enrollments  as 

  P_TABLENAME_IN VARCHAR2(200);
  last_run_date_out date;
   
cursor c1 is 
    select distinct
        f.ENROLL_ID ENROLL_NO_GK, ge.ORDERID ENROLL_NO_TP, f.EVENT_ID event_no_gk, ed.COURSE_ID COURSE_NO_GK,
        ed.START_DATE EVENTDATE,
        null CLPACCESS, 
        null CUSTOMER_NO,
        null APPROVER_EMAIL,
        null OCC_COSTCENTER ,
        null ORDER_NO,
        null PROMOCODE,
        f.ENROLL_STATUS ENROLLSTATUS_NO_GK,
        cd.ACCT_ID ORG_NO_GK ,
        f.CUST_ID STUDENT_NO_GK,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from order_Fact f
    join event_dim ed on f.EVENT_ID = ed.EVENT_ID
    join cust_dim cd on f.CUST_ID = cd.CUST_ID
    --join LMSGK2TP_ACCOUNTS la on cd.ACCT_ID = la.ACCT_ID 
    join slxdw.GK_ENROLLMENT ge on ge.EVXEVENROLLID = f.ENROLL_ID
    where  substr(ed.COURSE_CODE, -1, 1) in ( 'A','C', 'G','T','W','U') 
    and ed.COUNTRY in ( 'CANADA', 'USA')
    and ed.START_DATE >= '01-JUL-2017' 
    and ge.source = 'GK Portal'
--and (f.CREATION_DATE >= '01-NOV-2010' or f.LAST_UPDATE_DATE >= '01-NOV-2010');
    and (f.CREATION_DATE >= LAST_RUN_DATE_OUT or f.LAST_UPDATE_DATE >= LAST_RUN_DATE_OUT)  
    union
    select distinct
        f.ENROLL_ID ENROLL_NO_GK, ge.ORDERID ENROLL_NO_TP, f.EVENT_ID event_no_gk, ed.COURSE_ID COURSE_NO_GK,
        ed.START_DATE EVENTDATE,
        null CLPACCESS,
        null CUSTOMER_NO,
        null APPROVER_EMAIL,
        null OCC_COSTCENTER ,
        null ORDER_NO,
        null PROMOCODE,
        f.ENROLL_STATUS ENROLLSTATUS_NO_GK,
        cd.ACCT_ID ORG_NO_GK ,
        f.CUST_ID STUDENT_NO_GK,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from order_Fact f
    join event_dim ed on f.EVENT_ID = ed.EVENT_ID
    join slxdw.EVXCOURSEFEE cf on ed.COURSE_ID = cf.evxcourseid and ed.OPS_COUNTRY = upper(cf.PRICELIST)
    join cust_dim cd on f.CUST_ID = cd.CUST_ID
    --join LMSGK2TP_ACCOUNTS la on cd.ACCT_ID = la.ACCT_ID 
    join slxdw.GK_ENROLLMENT ge on ge.EVXEVENROLLID = f.ENROLL_ID
    where  cf.FEEALLOWUSE = 'T' 
        and cf."FEEAVAILABLE" = 'T'
        and replace(cf.FEETYPE, ' ') = 'Ons-Individual' 
        and substr(ed.COURSE_CODE, -1, 1) in ('L','V','Z' )
        and ed.COUNTRY in ('USA', 'CANADA')
        and ed.START_DATE >= '01-JUL-2017' 
        and ge.source = 'GK Portal'
--and (f.CREATION_DATE >= '18-JAN-2011' or f.LAST_UPDATE_DATE >= '18-JAN-2011');
    and (f.CREATION_DATE >= LAST_RUN_DATE_OUT or f.LAST_UPDATE_DATE >= LAST_RUN_DATE_OUT)
    union
    select distinct
        f.ENROLL_ID ENROLL_NO_GK, ge.ORDERID ENROLL_NO_TP, f.EVENT_ID event_no_gk, ed.COURSE_ID COURSE_NO_GK,
        ed.START_DATE EVENTDATE,
        null CLPACCESS,
        null CUSTOMER_NO,
        null APPROVER_EMAIL,
        null OCC_COSTCENTER ,
        null ORDER_NO,
        null PROMOCODE,
        f.ENROLL_STATUS ENROLLSTATUS_NO_GK,
        cd.ACCT_ID ORG_NO_GK ,
        f.CUST_ID STUDENT_NO_GK,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from order_Fact f
    join event_dim ed on f.EVENT_ID = ed.EVENT_ID
    join cust_dim cd on f.CUST_ID = cd.CUST_ID
    --join LMSGK2TP_ACCOUNTS la on cd.ACCT_ID = la.ACCT_ID 
    join slxdw.GK_ENROLLMENT ge on ge.EVXEVENROLLID = f.ENROLL_ID
    join LMSGK2TP_Course_Fee_v cf on substr(ed.COURSE_CODE, 1,4) = cf.course_code and ed.COUNTRY = cf.country
    where substr(ed.COURSE_CODE, -1, 1) in ( 'N', 'H','Y') 
        and ed.COUNTRY in ('USA', 'CANADA')
        and ed.START_DATE >= '01-JUL-2017'  
        and ge.source = 'GK Portal'
    --and (f.CREATION_DATE >= '24-FEB-2011' or f.LAST_UPDATE_DATE >= '24-FEB-2011');
        and (f.CREATION_DATE >= LAST_RUN_DATE_OUT or f.LAST_UPDATE_DATE >= LAST_RUN_DATE_OUT) ;
      

r1 c1%rowtype;
tmpVar NUMBER;

begin

    tmpVar := 0;

    P_TABLENAME_IN := 'LMSGK2TP_enrollments@dx_prod';
    LAST_RUN_DATE_OUT := NULL;


    select trunc(last_run_date) into last_run_date_out from LMSGK2TP_TIMESTAMP@dx_prod ;

 DBMS_OUTPUT.Put_Line('LAST_RUN_DATE_OUT = ' || LAST_RUN_DATE_OUT);
    
    
    delete LMSGK2TP_ENROLLMENTS@dx_prod;
    commit;
  
    open c1; 
    loop

        fetch c1 into r1; 
        exit when c1%NOTFOUND;
   
        insert into LMSGK2TP_ENROLLMENTS@dx_prod
            (ENROLL_NO_GK, ENROLL_NO_TP, EVENT_NO_GK, COURSE_NO_GK, EVENTDATE,
            CLPACCESS, CUSTOMER_NO, APPROVER_EMAIL, OCC_COSTCENTER, ORDER_NO, PROMOCODE, 
            ENROLLSTATUS_NO_GK, ORG_NO_GK, STUDENT_NO_GK, 
             CREATEDBY, MODIFIEDBY, DATECREATED, DATEMODIFIED
            )
        values (r1.ENROLL_NO_GK, r1.ENROLL_NO_TP, r1.EVENT_NO_GK, r1.COURSE_NO_GK, r1.EVENTDATE,
            r1.CLPACCESS, r1.CUSTOMER_NO, r1.APPROVER_EMAIL, r1.OCC_COSTCENTER, r1.ORDER_NO, r1.PROMOCODE, 
            r1.ENROLLSTATUS_NO_GK, r1.ORG_NO_GK, r1.STUDENT_NO_GK, 
            r1.CREATEDBY, r1.MODIFIEDBY, r1.DATECREATED, r1.DATEMODIFIED
            );    
    
    end loop;
    close c1;

dbms_output.put_line('LMSGK2TP_ENROLLMENTS has been loaded... .');

commit;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE(' No data for LMSGK2TP_ENROLLMENTS ...' ) ;
       RAISE;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_ENROLLMENTS ...' ) ;
       RAISE;
       
end;
/


