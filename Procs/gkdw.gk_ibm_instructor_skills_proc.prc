DROP PROCEDURE GKDW.GK_IBM_INSTRUCTOR_SKILLS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_instructor_skills_proc as

cursor c1 is
select distinct pmv."id" product_modality_version,
                f."id" instructor,'certready' status
  from gk_ibm_instructor_skills_v@slx ii,
       "person"@rms_prod p,
       "instructor_func"@rms_prod f,
       "product_modality_mode"@rms_prod pmm,
       "product_modality_version"@rms_prod pmv,
       "product_line_mode"@rms_prod plm,
       "product_line_category"@rms_prod plc
 where upper(ii.email) = upper(p."mail")
   and p."id" = f."person"
   and ii.ibm_ww_code = pmm."mfg_course_code"
   and pmm."product" = pmv."product"
   and pmm."product_line_mode" = plm."id"
   and pmv."product_line_category" = plc."id"
   and ii.teach = 'Y'
   and plc."category" = 'C-LEARNING'
minus
select "product_modality_version",
       "instructor",
       case when "status" like 'certready%' then 'certready'
            else "status"
       end status
  from "instructor_producte"@rms_prod ip
 order by 2,1;
 
cursor c2 is
select distinct pmv."id" product_modality_version,
                f."id" instructor,'certready' status
  from gk_ibm_instructor_skills_v@slx ii,
       "person"@rms_prod p,
       "instructor_func"@rms_prod f,
       "product_modality_mode"@rms_prod pmm,
       "product_modality_version"@rms_prod pmv,
       "product_line_mode"@rms_prod plm,
       "product_line_category"@rms_prod plc
 where upper(ii.email) = upper(p."mail")
   and p."id" = f."person"
   and ii.ibm_ww_code = pmm."mfg_course_code"
   and pmm."product" = pmv."product"
   and pmm."product_line_mode" = plm."id"
   and pmv."product_line_category" = plc."id"
   and ii.virtual_certified = 'Y'
   and ii.teach = 'Y'
   and plc."category" = 'V-LEARNING'
minus
select "product_modality_version",
       "instructor",
       case when "status" like 'certready%' then 'certready'
            else "status"
       end status
  from "instructor_producte"@rms_prod ip
 order by 2,1;

cursor c3 is
select distinct pmv."id" product_modality_version,
                f."id" instructor,'interested' status
  from gk_ibm_instructor_skills_v@slx ii,
       "person"@rms_prod p,
       "instructor_func"@rms_prod f,
       "product_modality_mode"@rms_prod pmm,
       "product_modality_version"@rms_prod pmv,
       "product_line_mode"@rms_prod plm,
       "product_line_category"@rms_prod plc
 where upper(ii.email) = upper(p."mail")
   and p."id" = f."person"
   and ii.ibm_ww_code = pmm."mfg_course_code"
   and pmm."product" = pmv."product"
   and pmm."product_line_mode" = plm."id"
   and pmv."product_line_category" = plc."id"
   and ii."AUDIT" = 'Y'
   and ii.teach = 'N'
   and plc."category" = 'C-LEARNING'
minus
select "product_modality_version",
       "instructor",
       case when "status" like 'interested%' then 'interested'
            when "status" like 'certready%' then 'interested'
            else "status"
       end status
  from "instructor_producte"@rms_prod ip
 order by 2,1;
 
cursor c4 is
select distinct pmv."id" product_modality_version,
                f."id" instructor,'interested' status
  from gk_ibm_instructor_skills_v@slx ii,
       "person"@rms_prod p,
       "instructor_func"@rms_prod f,
       "product_modality_mode"@rms_prod pmm,
       "product_modality_version"@rms_prod pmv,
       "product_line_mode"@rms_prod plm,
       "product_line_category"@rms_prod plc
 where upper(ii.email) = upper(p."mail")
   and p."id" = f."person"
   and ii.ibm_ww_code = pmm."mfg_course_code"
   and pmm."product" = pmv."product"
   and pmm."product_line_mode" = plm."id"
   and pmv."product_line_category" = plc."id"
   and ii."AUDIT" = 'Y'
   and ii.teach = 'N'
   and ii.virtual_certified = 'Y'
   and plc."category" = 'V-LEARNING'
minus
select "product_modality_version",
       "instructor",
       case when "status" like 'interested%' then 'interested'
            when "status" like 'certready%' then 'interested'
            else "status"
       end status
  from "instructor_producte"@rms_prod ip
 order by 2,1;
 
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;
r4 c4%rowtype;
v_msg_body long := null;
v_c_teach_cnt number := 0;
v_l_teach_cnt number := 0;
v_c_interest_cnt number := 0;
v_l_interest_cnt number := 0;

begin
rms_link_set_proc;

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><td align=left>IBM Instructor Skills Integration Begin: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
v_msg_body := v_msg_body||'<tr><td align=left>****************************************************************</td></tr>';

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;
  
  insert into "instructor_producte"@rms_prod("product_modality_version","instructor","status")
  values (r1.product_modality_version,r1.instructor,'certready');
  v_c_teach_cnt := v_c_teach_cnt + 1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>C-Learning Teaching Skills Added: '||v_c_teach_cnt||'</td></tr>';

open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;
  
  insert into "instructor_producte"@rms_prod("product_modality_version","instructor","status")
  values (r2.product_modality_version,r2.instructor,'certready');
  v_l_teach_cnt := v_l_teach_cnt + 1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>V-Learning Teaching Skills Added: '||v_l_teach_cnt||'</td></tr>';

open c3;
loop
  fetch c3 into r3;
  exit when c3%notfound;
  
  insert into "instructor_producte"@rms_prod("product_modality_version","instructor","status")
  values (r3.product_modality_version,r3.instructor,'interested');
  v_c_interest_cnt := v_c_interest_cnt + 1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>C-Learning Interest Skills Added: '||v_c_interest_cnt||'</td></tr>';

open c4;
loop
  fetch c4 into r4;
  exit when c4%notfound;
  
  insert into "instructor_producte"@rms_prod("product_modality_version","instructor","status")
  values (r4.product_modality_version,r4.instructor,'interested');
  v_l_interest_cnt := v_l_interest_cnt + 1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>V-Learning Interest Skills Added: '||v_l_interest_cnt||'</td></tr>';

v_msg_body := v_msg_body||'<tr><td align=left>****************************************************************</td></tr>';
v_msg_body := v_msg_body||'<tr><td align=left>IBM Instructor Skills Integration Complete: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
v_msg_body := v_msg_body||'</table></body></html>';


send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','IBM Instructor Skills Integration - Audit Email',v_msg_body);

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','IBM Instructor Skills Integration Failed',SQLERRM);

end;
/


