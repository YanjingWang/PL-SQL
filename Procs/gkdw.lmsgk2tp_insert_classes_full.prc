DROP PROCEDURE GKDW.LMSGK2TP_INSERT_CLASSES_FULL;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_insert_classes_full  as 

  P_TABLENAME_IN VARCHAR2(200);
 last_run_date_out date;
  
cursor c1 is 
    select 
        ed.COURSE_ID COURSE_NO_GK ,
        ed.LOCATION_ID FACILITY_NO_GK,
        ed.EVENT_ID EVENT_NO,
        ed.STATUS STATUS ,  
        ed.COURSE_CODE CODE,
        ed.EVENT_TYPE TYPE ,
        ed.START_DATE STARTDATE, ed.END_DATE ENDDATE , 
        ed.START_TIME STARTTIME, ed.END_TIME ENDTIME ,
        substr(ed.COURSE_CODE, -1, 1) MODALITY,     
        ed.FACILITY_REGION_METRO METROCODE,
        ed.COUNTRY COUNTRY,
        null ORG_NO,
        ed.CAPACITY maxseats, ee.MINENROLLMENT MINSEATS,
        ed.MEETING_DAYS NOOFDAYS,
        ee.CURRENROLLMENT NOOFENROLLMENTS,
        ee.WAITENROLLMENT NOOFWAITLISTED,
        ee.AVAILENROLLMENT AVAILSEATS ,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from event_dim ed
    join evxevent ee on ed.EVENT_ID = ee.EVXEVENTID
    join course_dim cd on cd.COURSE_id = ed.COURSE_ID and cd.COUNTRY = ed.OPS_COUNTRY 
    where -- cd.INACTIVE_FLAG = 'F'  and /*** Inactive Flag commented out - 02/04/2013   
    substr(ed.COURSE_CODE, -1, 1) in ( 'A','C', 'G', 'L','U', 'W', 'Z')
    and ed.START_DATE >= '01-JUL-2017'
    and ed.COUNTRY in ( 'CANADA', 'USA')
    and ed.event_id not in ('Q6UJ9A07TIVF')
union
    select distinct
        ed.COURSE_ID COURSE_NO_GK ,
        ed.LOCATION_ID FACILITY_NO_GK,
        ed.EVENT_ID EVENT_NO,
        ed.STATUS STATUS , 
        ed.COURSE_CODE CODE,
        ed.EVENT_TYPE TYPE ,
        ed.START_DATE STARTDATE, ed.END_DATE ENDDATE , 
        ed.START_TIME STARTTIME, ed.END_TIME ENDTIME ,
        substr(ed.COURSE_CODE, -1, 1) MODALITY, 
        ed.FACILITY_REGION_METRO METROCODE,
        ed.COUNTRY COUNTRY,
        gof.SOLDTOACCOUNTID ORG_NO,
        ed.CAPACITY maxseats,ee.MINENROLLMENT MINSEATS,
        ed.MEETING_DAYS NOOFDAYS,
        ee.CURRENROLLMENT NOOFENROLLMENTS,
        ee.WAITENROLLMENT NOOFWAITLISTED,
        ee.AVAILENROLLMENT AVAILSEATS ,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from event_dim ed
    join evxevent ee on ed.EVENT_ID = ee.EVXEVENTID
    join course_dim cd on cd.COURSE_id = ed.COURSE_ID and cd.COUNTRY = ed.OPS_COUNTRY
    join slxdw.EVXCOURSEFEE cf on cd.COURSE_ID = cf.evxcourseid and cd.COUNTRY = upper(cf.PRICELIST)
    left join slxdw.GK_ONSITEREQ_COURSES goc on ed.EVENT_ID = goc.EVXEVENTID
    left join slxdw.GK_ONSITEREQ_FDC gof on goc.GK_ONSITEREQ_FDCID = gof.GK_ONSITEREQ_FDCID
    join LMSGK2TP_ACCOUNTS la on gof.SOLDTOACCOUNTID = la.ACCT_ID 
    where --cd.INACTIVE_FLAG = 'F'   and /*** Inactive Flag commented out - 02/04/2013   
    cf.FEEALLOWUSE = 'T' 
    and cf."FEEAVAILABLE" = 'T'
    and replace(cf.FEETYPE, ' ') = 'Ons-Individual' 
    and substr(ed.COURSE_CODE, -1, 1) = 'V'
    and ed.START_DATE >= '01-JUL-2017' 
    and ed.COUNTRY in ( 'USA', 'CANADA')
union
    select distinct
        ed.COURSE_ID COURSE_NO_GK ,
        ed.LOCATION_ID FACILITY_NO_GK,
        ed.EVENT_ID EVENT_NO,
        ed.STATUS STATUS , 
        ed.COURSE_CODE CODE,
        ed.EVENT_TYPE TYPE ,
        ed.START_DATE STARTDATE, ed.END_DATE ENDDATE , 
        ed.START_TIME STARTTIME, ed.END_TIME ENDTIME ,
        substr(ed.COURSE_CODE, -1, 1) MODALITY, 
        ed.FACILITY_REGION_METRO METROCODE,
        ed.COUNTRY COUNTRY,
        gof.SOLDTOACCOUNTID ORG_NO,
        ed.CAPACITY maxseats, ee.MINENROLLMENT MINSEATS,
        ed.MEETING_DAYS NOOFDAYS,
        ee.CURRENROLLMENT NOOFENROLLMENTS,
        ee.WAITENROLLMENT NOOFWAITLISTED,
        ee.AVAILENROLLMENT AVAILSEATS ,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from event_dim ed
    join evxevent ee on ed.EVENT_ID = ee.EVXEVENTID
    join course_dim cd on cd.COURSE_id = ed.COURSE_ID and cd.COUNTRY = ed.OPS_COUNTRY
    left join slxdw.GK_ONSITEREQ_COURSES goc on ed.EVENT_ID = goc.EVXEVENTID
    left join slxdw.GK_ONSITEREQ_FDC gof on goc.GK_ONSITEREQ_FDCID = gof.GK_ONSITEREQ_FDCID
    join LMSGK2TP_ACCOUNTS la on gof.SOLDTOACCOUNTID = la.ACCT_ID
    join LMSGK2TP_Course_Fee_v cf on substr(cd.COURSE_CODE, 1,4) = cf.course_code and cd.COUNTRY = cf.country
    where -- cd.INACTIVE_FLAG = 'F'   and /*** Inactive Flag commented out - 02/04/2013   
    substr(ed.COURSE_CODE, -1, 1) in ( 'N', 'H', 'I', 'J')
    and ed.START_DATE >= '01-JUL-2017'
    and (ed.COUNTRY in ( 'USA', 'CANADA') or ED.FACILITY_REGION_METRO = 'ONS')
    and ed.LOCATION_ID not in ('Q6UJ9A06YM9P', 'Q6UJ9A04KSHK', 'Q6UJ9A04KSG9', 'Q6UJ9A09PAQB') ;


r1 c1%rowtype;
tmpVar NUMBER;

begin

    tmpVar := 0;

    P_TABLENAME_IN := 'LMSGK2TP_classes@dx_prod';
    LAST_RUN_DATE_OUT := NULL;
    
    select nvl(trunc(last_run_date), '01-JAN-2013') into last_run_date_out from LMSGK2TP_TIMESTAMP@dx_prod ;
 
   DBMS_OUTPUT.Put_Line('LAST_RUN_DATE_OUT = ' || LAST_RUN_DATE_OUT);

    delete LMSGK2TP_Classes@dx_prod;
    commit;

    open c1; 
    loop
  
    fetch c1 into r1; 
    exit when c1%NOTFOUND;
   
    insert into LMSGK2TP_Classes@dx_prod
            (COURSE_NO_GK, FACILITY_NO_GK, EVENT_NO, STATUS, CODE, TYPE, 
            STARTDATE, ENDDATE, STARTTIME,ENDTIME, MODALITY, METROCODE, COUNTRY, ORG_NO, MAXSEATS, MINSEATS, NOOFDAYS, 
            NOOFENROLLMENTS, NOOFWAITLISTED, AVAILSEATS, 
            CREATEDBY, MODIFIEDBY, DATECREATED, DATEMODIFIED)
    values  (r1.COURSE_NO_GK, r1.FACILITY_NO_GK, r1.EVENT_NO, r1.STATUS, r1.CODE, r1.TYPE, 
            r1.STARTDATE, r1.ENDDATE, r1.STARTTIME,r1.ENDTIME, r1.MODALITY, r1.METROCODE, r1.COUNTRY, r1.ORG_NO, r1.MAXSEATS, r1.MINSEATS, r1.NOOFDAYS,
            r1.NOOFENROLLMENTS, r1.NOOFWAITLISTED, r1.AVAILSEATS, 
            r1.CREATEDBY, r1.MODIFIEDBY, r1.DATECREATED, r1.DATEMODIFIED
            );    
            
   DBMS_OUTPUT.Put_Line('EVENT_ID = ' || r1.event_no);

--   commit; 
end loop;
close c1;

dbms_output.put_line('LMSGK2TP_CLASSES has been loaded... .');

commit;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE(' No data for  LMSGK2TP_CLASSES ...' ) ;
       RAISE;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_CLASSES ...' ) ;
       RAISE;
       
end;
/


