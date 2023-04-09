DROP PROCEDURE GKDW.GK_MFG_COURSE_UPDATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_mfg_course_update_proc as

cursor c1 is
select evxcourseid,coursecode,mfgproduct 
from evxcourse@slx ec
inner join course_dim cd on ec.evxcourseid = cd.course_id and gkdw_source = 'SLXDW'
minus
select course_id,course_code,mfg_course_code from course_dim
where gkdw_source = 'SLXDW'
order by 3;

begin

for r1 in c1 loop
  update course_dim
     set mfg_course_code = r1.mfgproduct
   where course_id = r1.evxcourseid;
end loop;
commit;

end;
/


