DROP PROCEDURE GKDW.UPDATE_COURSE_DIM_RMS_COURSE;

CREATE OR REPLACE PROCEDURE GKDW.Update_Course_Dim_rms_course
as

        
cursor c1 is
select distinct rc.COURSE_DESC, rc.ITBT, rc.ROOT_CODE, rc.LINE_OF_BUSINESS, rc.MCMASTERS_ELIGIBLE, rc.MFG_COURSE_CODE, rc.product_manager
,RC.SLX_COURSE_ID,rc.us_farm,rc.ca_farm,rc.discount_flag,rc.gsa_eligible,rc.gsa_eligible_from,rc.gsa_eligible_to -- added us_farm and ca_farm 10/18 : SR
from rmsdw.rms_Course  rc;

cursor c2 is
select cd.course_id,e.evxcourseid,cd.course_code,e.coursecode,cd.INACTIVE_FLAG,e.isinactive from
course_dim cd
inner join slxdw.evxcourse e
on cd.course_id = e.evxcourseid
and cd.inactive_flag != e.isinactive
and gkdw_source = 'SLXDW';

begin

for r1 in c1 loop
DBMS_OUTPUT.PUT_LINE(r1.slx_course_id ) ;-- || ' ' || r1.country || r1.le ) ;;

    update course_dim cd
    set cd.COURSE_DESC = r1.course_desc
    , cd.ITBT = r1.itbt
    , cd.ROOT_CODE = r1.root_code
    , cd.LINE_OF_BUSINESS = r1.line_of_business
    , cd.MCMASTERS_ELIGIBLE = r1.mcmasters_eligible
    , cd.MFG_COURSE_CODE = r1.mfg_course_code
    ,cd.product_manager = r1.product_manager
    ,cd.us_farm = r1.us_farm --10/18 SR
    ,cd.ca_farm = r1.ca_farm --10/18 SR
    ,cd.discount_flag = r1.discount_flag -- 11/18 SR
    ,cd.gsa_eligible = r1.gsa_eligible -- 06/27/2017 SR
    ,cd.gsa_eligible_from = r1.gsa_eligible_from -- 06/27/2017 SR
    ,cd.gsa_eligible_to = r1.gsa_eligible_to -- 06/27/2017 SR
    where cd.course_id = r1.slx_course_id ;
   
 
commit;

end loop;

for r2 in c2 loop
update course_dim cd
set INACTIVE_FLAG = r2.isinactive
where course_id = r2.evxcourseid;
end loop;
commit;

	EXCEPTION
    		 WHEN OTHERS THEN
	    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','Update_Course_Dim_rms_course Failed',SQLERRM);

end;
/


