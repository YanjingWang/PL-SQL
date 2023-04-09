DROP PROCEDURE GKDW.LMSGK2TP_INSERT_FAC_FULL;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_insert_fac_full  as 

  P_TABLENAME_IN VARCHAR2(200);
  last_run_date_out date;

cursor c1 is 
    select ef.EVXFACILITYID FACILITY_NO_GK, ef.FACILITYNAME FACILITYNAME, ef.FACILITYCODE CODE, 
        a.ADDRESS1 ADDRESS1, a.address2 ADDRESS2, a.CITY CITY,
        a.STATE STATE, a.POSTALCODE ZIPCODE,
        ef.FACILITYCONTACT CONTACT,
        a.COUNTY USCOUNTY, a.COUNTRY COUNTRY,  
        c.EMAIL EMAIL, c.FAX FAX, c.WORKPHONE PHONE, 
        'SLMSGK2TP Export' CREATEDBY, 'SLMSGK2TP Export' MODIFIEDBY,        
        sysdate DATECREATED, sysdate DATEMODIFIED
        ,a."web" WEBURLLINK 
    from slxdw.evxfacility ef
    join slxdw.address a on ef.FACILITYADDRESSID = a.ADDRESSID
    join slxdw.contact c on ef.FACILITYCONTACTID = c.CONTACTID
    join "location_func"@rms_prod lf on ef.EVXFACILITYID = lf."slx_facility_id"
    join "metro_codes"@rms_prod mc on  lf."metro_code" = mc."id"
    join "person"@rms_prod p on p."id" = lf."person"
    join "address"@rms_prod a on a."id" = p."address"
    where --a.COUNTRY in (  'Canada', 'USA')
--and lf."global_center" = 'yes'
--and mc."name" <> 'ONS'
  -- and 
  ef.FACILITYSTATUS = 'Active'
   order by a.COUNTRY, a.STATE ;

r1 c1%rowtype;
tmpVar NUMBER;

begin
rms_link_set_proc;

    tmpVar := 0;

    P_TABLENAME_IN := 'LMSGK2TP_FACILITIES@dx_prod';
    LAST_RUN_DATE_OUT := null;

    
    select trunc(last_run_date) into last_run_date_out from LMSGK2TP_TIMESTAMP@dx_prod ;

    DBMS_OUTPUT.Put_Line('LAST_RUN_DATE_OUT = ' || LAST_RUN_DATE_OUT);


    delete LMSGK2TP_FACILITIES@dx_prod;
    commit;

open c1; 
loop

 
    fetch c1 into r1; 
    exit when c1%NOTFOUND;
   
    insert into LMSGK2TP_FACILITIES@dx_prod
            (FACILITY_NO_GK, FACILITYNAME, CODE, 
            ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, CONTACT, USCOUNTY, COUNTRY, EMAIL, FAX, PHONE,
            CREATEDBY, MODIFIEDBY, DATECREATED, DATEMODIFIED,WEBURLLINK
            )
    values (r1.FACILITY_NO_GK, r1.FACILITYNAME, r1.CODE, 
            r1.ADDRESS1, r1.ADDRESS2, r1.CITY, r1.STATE, r1.ZIPCODE, r1.CONTACT, r1.USCOUNTY, r1.COUNTRY, r1.EMAIL, r1.FAX, r1.PHONE,
            r1.CREATEDBY, r1.MODIFIEDBY, r1.DATECREATED, r1.DATEMODIFIED, r1.WEBURLLINK
            );    

    
end loop;
close c1;

dbms_output.put_line('LMSGK2TP_FACILITIES has been loaded... .');

commit;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('No Data for LMSGK2TP_FACILITIES ...' ) ;
       RAISE;
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_FACILITIES ...' ) ;
       RAISE;
       
end;
/


