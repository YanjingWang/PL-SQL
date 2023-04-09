DROP PROCEDURE GKDW.GK_IBM_MFG_COURSE_LOAD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_mfg_course_load_proc as

cursor c1 is
select distinct cd.course_id,cd.course_code,cd.mfg_course_code,c.ibm_course_code
from gk_ibm_gk_course_load c
inner join course_dim cd on c.gk_course_code = cd.course_code
inner join "product_modality_mode"@rms_prod pmm on cd.course_id = pmm."slx_id"
where nvl(cd.mfg_course_code,'NONE') <> c.ibm_course_code
and cd.course_id = 'Q6UJ9AD8NFRQ'
order by 2;

r1 c1%rowtype;
curr_date varchar2(25);

begin
rms_link_set_proc;

curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;
  
  update "product_modality_mode"@rms_prod
     set "mfg_course_code" = r1.ibm_course_code,
         "changed" = curr_date
   where "slx_id" = r1.course_id;
end loop;
commit;

end;
/


