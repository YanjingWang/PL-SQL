DROP PROCEDURE GKDW.LMSGK2TP_INSERT_COURSES_FULL;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_insert_courses_full  as 

 P_TABLENAME_IN VARCHAR2(200);
  last_run_date_out date;
  
cursor c1 is
/********** C COurses ****************************/ 
    select 
        cd.COURSE_ID COURSE_NO_GK,
        initcap(cd.COURSE_NAME)  course_name,
        cd.COURSE_CODE CODE,
        null CREDITHOURS,
        null CREDITS, 
        null AVAILABLEONLINE,
        null WEBVISIBLE,
        null ISCLP,
        cd.LIST_PRICE LIST_PRICE,
        null ORG_NO,
        null VILT,
        cd.COURSE_ID EQUIV_NO ,
        cd.DURATION_DAYS LENGTHDAYS, 'Days' LENGTHDESC,
        null LENGTHHOURS, 
        cd.CAPACITY MAXSEATS,
        null MINPASSSCORE,
        null MINSEATS,
        cd.VENDOR_CODE VENDOR_NO,
        cd.COUNTRY,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from course_dim cd
    where --cd.INACTIVE_FLAG = 'F'    and /*** Inactive Flag commented out - 02/04/2013   
    cd.COUNTRY in ('CANADA', 'USA') 
    and substr(cd.COURSE_CODE, -1, 1) in ( 'A','C', 'G', 'L','U', 'W','Z' )  -- Z added on 7/10/2015
/*and cd.MD_NUM = '10' -- C courses 
and cd.CH_NUM = '10' -- OE
*/
union all 
/*********************** V COURSES ***********************/
    select  
        cd.COURSE_ID COURSE_NO_GK,
        initcap(cd.COURSE_NAME)  course_name,
        cd.COURSE_CODE CODE,
        null CREDITHOURS,
        null CREDITS, 
        null AVAILABLEONLINE,
        null WEBVISIBLE,
        null ISCLP,
        cf.AMOUNT LIST_PRICE,
        null ORG_NO,
        null VILT,
        cd.COURSE_ID EQUIV_NO ,
        cd.DURATION_DAYS LENGTHDAYS,'Days' LENGTHDESC,
        null LENGTHHOURS, 
        cd.CAPACITY MAXSEATS,
        null MINPASSSCORE,
        null MINSEATS,
        cd.VENDOR_CODE VENDOR_NO,
        cd.COUNTRY,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from course_dim cd
    join slxdw.EVXCOURSEFEE cf on cd.COURSE_ID = cf.evxcourseid and cd.COUNTRY = upper(cf.PRICELIST)
    where  --cd.INACTIVE_FLAG = 'F'    and /*** Inactive Flag commented out - 02/04/2013    
    cf.FEEALLOWUSE = 'T' 
    and cf."FEEAVAILABLE" = 'T'
    and replace(cf.FEETYPE, ' ') = 'Ons-Individual' 
    and cd.COUNTRY in ( 'USA', 'CANADA') 
    and substr(cd.COURSE_CODE, -1, 1) = 'V'
--and (cd.CREATION_DATE >= '18-JAN-2011' or cd.LAST_UPDATE_DATE >= '18-JAN-2011') 
union all/*********************** N COURSES ***********************/
    select 
        cd.COURSE_ID COURSE_NO_GK,
        initcap(cd.COURSE_NAME)  course_name,
        cd.COURSE_CODE CODE,
        null CREDITHOURS,
        null CREDITS, 
        null AVAILABLEONLINE,
        null WEBVISIBLE,
        null ISCLP,
        nvl(cf.OE_FEES, cf.ONS_ADDL)  LIST_PRICE,
        null ORG_NO,
        null VILT,
        cd.COURSE_ID EQUIV_NO ,
        cd.DURATION_DAYS LENGTHDAYS,'Days' LENGTHDESC,
        null LENGTHHOURS, 
        cd.CAPACITY MAXSEATS,
        null MINPASSSCORE,
        null MINSEATS,
        cd.VENDOR_CODE VENDOR_NO,
        cd.COUNTRY,
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,
        sysdate DATECREATED, sysdate DATEMODIFIED
    from course_dim cd
    join LMSGK2TP_Course_Fee_v cf on substr(cd.COURSE_CODE, 1,4) = cf.course_code and cd.COUNTRY = cf.country
    where --cd.INACTIVE_FLAG = 'F'    and /*** Inactive Flag commented out - 02/04/2013   
    cd.COUNTRY in ( 'USA', 'CANADA') 
    and substr(cd.COURSE_CODE, -1, 1) in ( 'N', 'H', 'I', 'J') -- I, J Modalities added on 7/10/2015
--and (cd.CREATION_DATE >= '24-FEB-2011' or cd.LAST_UPDATE_DATE >= '24-FEB-2011') 
order by COURSE_NO_GK ;

r1 c1%rowtype;
tmpVar NUMBER;

begin

tmpVar := 0;

    P_TABLENAME_IN := 'LMSGK2TP_Courses@dx_prod';
    last_run_date_out := null ; 
    
    select trunc(last_run_date) into last_run_date_out from LMSGK2TP_TIMESTAMP@dx_prod ;

    delete LMSGK2TP_Courses@dx_prod;
    commit;
    
    dbms_output.put_line('LAST_RUN_DATE.. .'|| LAST_RUN_DATE_OUT);

open c1; 
loop
  
    fetch c1 into r1; 
    exit when c1%NOTFOUND;
   
   insert into LMSGK2TP_Courses@dx_prod
    (COURSE_NO_GK ,COURSENAME ,CODE ,CREDITHOURS ,CREDITS ,AVAILABLEONLINE ,WEBVISIBLE ,ISCLP ,LISTPRICE ,ORG_NO
      ,VILT ,EQUIV_NO ,LENGTHDAYS ,LENGTHDESC ,LENGTHHOURS ,MAXSEATS ,MINPASSSCORE ,MINSEATS
      ,VENDOR_NO ,COUNTRY ,CREATEDBY ,MODIFIEDBY ,DATECREATED, DATEMODIFIED
    ) 
    values (r1.COURSE_NO_GK, r1.course_name, r1.CODE,
            r1.CREDITHOURS, r1.CREDITS, r1.AVAILABLEONLINE, r1.WEBVISIBLE, r1.ISCLP, r1.LIST_PRICE, r1.ORG_NO, r1.VILT, r1.EQUIV_NO ,
            r1.LENGTHDAYS, r1.LENGTHDESC, r1.LENGTHHOURS, r1.MAXSEATS, r1.MINPASSSCORE, r1.MINSEATS, r1.VENDOR_NO,r1.COUNTRY,
            r1.CREATEDBY, r1.MODIFIEDBY, r1.DATECREATED, r1.DATEMODIFIED
            );    

    
end loop;
close c1;

dbms_output.put_line('LMSGK2TP_COURSES has been loaded... .');

commit;
/*
update  LMSGK2TP_TIMESTAMP@dx_prod
set last_run_date = sysdate;
commit;
*/

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE(' NO data for LMSGK2TP_COURSES ...' ) ;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_COURSES ...' ) ;
       RAISE;
       
end;
/


