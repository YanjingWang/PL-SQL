DROP PROCEDURE GKDW.GK_COURSE_DIM_UPD;

CREATE OR REPLACE PROCEDURE GKDW.gk_course_dim_upd
as
cursor c1 is
select distinct substr(course_code,0,length(course_code)-1) course_code,pl.newnacoursecode,PROJECTACTUALFINISHDATE
from course_dim cd
inner join slxdw.gk_ppm_lookup pl
on substr(cd.course_code,0,length(cd.course_code)-1) = pl.newnacoursecode;

begin

for r1 in c1 loop
update course_dim
set PROJECT_FINISH_DATE = trunc(r1.PROJECTACTUALFINISHDATE)
where substr(course_code,0,length(course_code)-1) = r1.newnacoursecode;
end loop;
commit;

exception
when others then rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_course_dim_upd Failed',SQLERRM);
end;
/


