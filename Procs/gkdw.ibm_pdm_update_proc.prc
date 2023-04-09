DROP PROCEDURE GKDW.IBM_PDM_UPDATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.ibm_pdm_update_proc as 

cursor c1 is
select p."id" product_id,
       course_code,course_name,short_name product_code,
       case when course_type = 'Business Analytics' then 88
            when course_type = 'Industry Solutions' then 89
            when course_type = 'Information Management' then 90
            when course_type = 'Mainframe' then 91
            when course_type = 'ISSC' then 92
            when course_type = 'Modular' then 93
            when course_type = 'Tivoli' then 94
            when course_type = 'WebSphere' then 95
            when course_type = 'Websphere' then 95
            when course_type = 'Power' then 96
            when course_type = 'Rational' then 97
            when course_type = 'Security Systems' then 98
            when course_type = 'IBM Custom' then 99
            when course_type = 'Storage' then 9
            when course_type = 'Cloud & Smarter Infrastructure' then 104
            when course_type = 'IBM Collaboration Solution (ICS)' then 105
            when course_type = 'Security' then 7
            when course_type = 'Storage & Networking' then 106
            when course_type = 'System z' then 107
            when course_type = 'Systems Software' then 108
            else 0
       end course_type,
       lob,
       product_manager,
       case when product_manager = 'Cynthia.Kain' then 48
            when product_manager = 'Kimberly Freeman' then 12
            when product_manager = 'Katherine.Milan' then 47
       end product_manager_id,remote_lab_provider
  from ibm_pdm_update_load l,
       "product"@rms_prod p
  where l.course_code = p."us_code"
  order by course_type;

cursor c2 is
select pcp."id" pcp_id,l.us_ons_base
  from ibm_pdm_update_load l,
       "product"@rms_prod p,
       "product_country"@rms_prod pc,
       "product_country_price"@rms_prod pcp
  where l.course_code = p."us_code"
    and p."id" = pc."product"
    and pc."id" = pcp."product_country"
    and pc."country" = 'US'
    and pcp."price_type" = 34
    and l.us_ons_base <> pcp."price"
    and l.us_ons_base > 0;
    
cursor c3 is
 select pcp."id" pcp_id,l.ca_ons_base
  from ibm_pdm_update_load l,
       "product"@rms_prod p,
       "product_country"@rms_prod pc,
       "product_country_price"@rms_prod pcp
  where l.course_code = p."us_code"
    and p."id" = pc."product"
    and pc."id" = pcp."product_country"
    and pc."country" = 'CA'
    and pcp."price_type" = 35
    and l.ca_ons_base <> pcp."price"
    and l.ca_ons_base > 0;
    
curr_date varchar2(25);
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;

begin
curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

--open c1;
--loop
--  fetch c1 into r1;
--  exit when c1%notfound;
--  
--  update "product"@rms_prod
--     set "product_code" = r1.product_code,
--         "line_of_business" = r1.lob,
--         "product_manager" = r1.product_manager_id,
--         "changed" = curr_date
--   where "id" = r1.product_id;
--  
--  update "product_country"@rms_prod
--     set "submenu" = r1.course_type,
--         "changed" = curr_date
--   where "product" = r1.product_id;
--   
--  update "product_product_manager"@rms_prod
--     set "product_manager" = r1.product_manager_id
--   where "product" = r1.product_id;

--  update "product_modality_mode"@rms_prod
--     set "mfg_course_code" = r1.product_code,
--         "changed" = curr_date
--   where "product" = r1.product_id;   
--  
--  update "room_req_additional_fields"@rms_prod
--     set "remote_lab_provider" = 'IBM'
--   where "product" = r1.product_id; 
--end loop;
--commit;

curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;

  update "product_country_price"@rms_prod
     set "price" = r2.us_ons_base,
--         "price_comment" = r2.private_students,
         "changed" = curr_date
   where "id" = r2.pcp_id;
   
end loop;
commit;

curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
open c3;
loop
  fetch c3 into r3;
  exit when c3%notfound;

  update "product_country_price"@rms_prod
     set "price" = r3.ca_ons_base,
--         "price_comment" = r3.private_students,
         "changed" = curr_date
   where "id" = r3.pcp_id;
   
end loop;
commit;

end;
/


