DROP PROCEDURE GKDW.GK_COURSE_PRICE_CHANGE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_course_price_change_proc as

cursor c0 is
select cp.course_code,substr(cp.course_code,1,4) prod_code,substr(cp.course_code,5,1) prod_mod,cp.country,
       p."id" product_id,
       pc."id" product_country,cp.fee_type,cp.fee_price,case when cp.country = 'USA' then 'USD' else 'CAD' end currency,
       to_char(sysdate,'yyyy-mm-dd') valid_from,null slx_id,
       case when substr(cp.course_code,-1) = 'C' then 1
            when substr(cp.course_code,-1) = 'N' then 2
            when substr(cp.course_code,-1) = 'L' then 3
            when substr(cp.course_code,-1) = 'V' then 4
            when substr(cp.course_code,-1) = 'Z' then 15
            when substr(cp.course_code,-1) = 'W' then 9
            when substr(cp.course_code,-1) = 'H' then 7
            when substr(cp.course_code,-1) = 'Y' then 14
            when substr(cp.course_code,-1) = 'U' then 8
            when substr(cp.course_code,-1) = 'G' then 6
       end product_line_mode,
       case when cp.fee_type = 'Primary' and upper(country) = 'USA' then 12
            when cp.fee_type = 'Primary' and upper(country) = 'CANADA' then 14
            when cp.fee_type = 'Ons - Base' and upper(country) = 'USA' then 34
            when cp.fee_type = 'Ons - Base' and upper(country) = 'CANADA' then 35
            when cp.fee_type = 'Ons-Additional' and upper(country) = 'USA' then 26
            when cp.fee_type = 'Ons - Additional' and upper(country) = 'CANADA' then 46
       end price_type,nvl(base_cnt,0) price_comment,
       pcp."slx_id" pcp_slx_id,pcp."id" pcp_id,pcp."price" old_fee_price
  from course_price_change cp,
       "product"@rms_prod p,
       "product_country"@rms_prod pc,
       "product_country_price"@rms_prod pcp
 where substr(cp.course_code,1,length(cp.course_code)-1) = p."us_code"
   and p."id" = pc."product"
   and upper(substr(cp.country,1,2)) = pc."country"
   and pc."id" = pcp."product_country"
   and case when substr(cp.course_code,-1) = 'C' then 1
            when substr(cp.course_code,-1) = 'N' then 2
            when substr(cp.course_code,-1) = 'L' then 3
            when substr(cp.course_code,-1) = 'V' then 4
            when substr(cp.course_code,-1) = 'Z' then 15
            when substr(cp.course_code,-1) = 'W' then 9
            when substr(cp.course_code,-1) = 'H' then 7
            when substr(cp.course_code,-1) = 'Y' then 14
            when substr(cp.course_code,-1) = 'U' then 8
            when substr(cp.course_code,-1) = 'G' then 6
       end = pcp."product_line_mode"
   and case when cp.fee_type = 'Primary' and upper(country) = 'USA' then 12
            when cp.fee_type = 'Primary' and upper(country) = 'CANADA' then 14
            when cp.fee_type = 'Ons - Base' and upper(country) = 'USA' then 34
            when cp.fee_type = 'Ons - Base' and upper(country) = 'CANADA' then 35
            when cp.fee_type = 'Ons-Additional' and upper(country) = 'USA' then 26
            when cp.fee_type = 'Ons - Additional' and upper(country) = 'CANADA' then 46
       end = pcp."price_type"
   and pcp."slx_id" is not null
 order by 1,2;

v_modify_date varchar2(50);
r0 c0%rowtype;

begin

insert into course_price_change_audit
select cp.course_code,cp.country,p."id" product_id,pc."id" product_country,
       case when substr(cp.course_code,-1) = 'C' then 1
            when substr(cp.course_code,-1) = 'N' then 2
            when substr(cp.course_code,-1) = 'L' then 3
            when substr(cp.course_code,-1) = 'V' then 4
            when substr(cp.course_code,-1) = 'Z' then 15
            when substr(cp.course_code,-1) = 'W' then 9
            when substr(cp.course_code,-1) = 'H' then 7
            when substr(cp.course_code,-1) = 'Y' then 14
            when substr(cp.course_code,-1) = 'U' then 8
            when substr(cp.course_code,-1) = 'G' then 6
       end product_line_mode,
       case when cp.fee_type = 'Primary' and country = 'USA' then 12
            when cp.fee_type = 'Primary' and country = 'CANADA' then 14
            when cp.fee_type = 'Ons - Base' and country = 'USA' then 34
            when cp.fee_type = 'Ons - Base' and country = 'CANADA' then 35
            when cp.fee_type = 'Ons-Additional' and country = 'USA' then 26
            when cp.fee_type = 'Ons - Additional' and country = 'CANADA' then 46
       end price_type,
       pcp."id" pcp_id,pcp."slx_id" pcp_slx_id,pcp."price" old_fee_price,
       cp.fee_price,cp.fee_type,case when cp.country = 'USA' then 'USD' else 'CAD' end currency,
       sysdate     
  from course_price_change cp,
       "product"@rms_prod p,
       "product_country"@rms_prod pc,
       "product_country_price"@rms_prod pcp
 where substr(cp.course_code,1,length(cp.course_code)-1) = p."us_code"
   and p."id" = pc."product"
   and substr(cp.country,1,2) = pc."country"
   and pc."id" = pcp."product_country"
   and case when substr(cp.course_code,-1) = 'C' then 1
            when substr(cp.course_code,-1) = 'N' then 2
            when substr(cp.course_code,-1) = 'L' then 3
            when substr(cp.course_code,-1) = 'V' then 4
            when substr(cp.course_code,-1) = 'Z' then 15
            when substr(cp.course_code,-1) = 'W' then 9
            when substr(cp.course_code,-1) = 'H' then 7
            when substr(cp.course_code,-1) = 'Y' then 14
            when substr(cp.course_code,-1) = 'U' then 8
            when substr(cp.course_code,-1) = 'G' then 6
       end = pcp."product_line_mode"
   and case when cp.fee_type = 'Primary' and country = 'USA' then 12
            when cp.fee_type = 'Primary' and country = 'CANADA' then 14
            when cp.fee_type = 'Ons - Base' and country = 'USA' then 34
            when cp.fee_type = 'Ons - Base' and country = 'CANADA' then 35
            when cp.fee_type = 'Ons-Additional' and country = 'USA' then 26
            when cp.fee_type = 'Ons - Additional' and country = 'CANADA' then 46
       end = pcp."price_type"
   and pcp."slx_id" is not null
 order by 1,2;
commit;
 
open c0; loop
  fetch c0 into r0; exit when c0%NOTFOUND;
  
  select to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') into v_modify_date from dual;
  
  update "product_country_price"@rms_prod
     set "valid_from" = r0.valid_from,
         "price" = r0.fee_price,
         "price_comment" = r0.price_comment,
         "changed" = v_modify_date
   where "id" = r0.pcp_id;
   
   dbms_output.put_line('Course Code: '||r0.course_code||'('||r0.country||')-'||r0.fee_type||' updated from '||r0.old_fee_price||' to '||r0.fee_price);
end loop;
close c0;
commit;

open c0; loop
  fetch c0 into r0; exit when c0%NOTFOUND;
  
  select to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') into v_modify_date from dual;
  
  update evxcoursefee@slx
     set amount = r0.fee_price,
         modifydate = v_modify_date
   where evxcoursefeeid = r0.pcp_slx_id;
end loop;
close c0;
commit;

end;
/


