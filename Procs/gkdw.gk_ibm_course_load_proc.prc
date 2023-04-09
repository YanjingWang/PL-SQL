DROP PROCEDURE GKDW.GK_IBM_COURSE_LOAD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_course_load_proc as
cursor c1 is
select short_title,course_code,course_name,product_line,
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
       lob,mtm_name,
       product_manager,
              case when product_manager = 'Cynthia.Kain' then 48
            when product_manager = 'Kimberly Freeman' then 12
            when product_manager = 'Katherine.Milan' then 47
            else 28
       end product_manager_id,
       mfg_course_code,duration_days,min_enroll,max_enroll,hard_cap,student_pc_ratio,
       start_time||':00' start_time,end_time||':00' end_time,lab_type,'IBM' remote_lab_provider,
       case when upper(lab_type) != 'NO LAB REQUIRED' then 'no' else 'yes' end lab_request,
       case when pc_provider = 'GK' then 'Global' else pc_provider end pc_provider,
       case when pc_provider is not null then 'Minimum of 256 MB of memory - Windows XP, Vista or Seven (32-bit or 63 bits edition) -  Internet Explorer 6 through 9 or Firefox 1.x through 5.x  (recommend to use the 32 bits editions) - 128-bit encryption - Citrix Receiver' 
            else 'None' 
       end pc_requirements,
       'yes' internet_access,
       internet_access internet_type,
       us_primary_fee,gsa_primary_fee,
       case when us_ons_base_fee is null then us_primary_fee*12*.7 else us_ons_base_fee end us_ons_base_fee,
       ca_primary_fee,
       case when ca_ons_base_fee is null then ca_primary_fee*12*.7 else ca_ons_base_fee end ca_ons_base_fee,
       case when c_mod like 'Y%' then 'yes' else 'no' end c_mod,
       case when l_mod like 'Y%' then 'yes' else 'no' end l_mod,
       case when n_mod like 'Y%' then 'yes' else 'no' end n_mod,
       case when v_mod like 'Y%' then 'yes' else 'no' end v_mod,
       28 product_line_area
  from ibm_course_load_mv c
 where not exists (select 1 from "product"@rms_prod p where c.course_code = p."us_code");

r1 c1%rowtype;
v_prod_id number;
v_prod_country_id number;

begin

delete from "gk_prod_mod_stud_pc_ratio"@rms_prod;
commit;

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;


/****** CREATE PRODUCT ********/
  insert into "product"@rms_prod
  ("vendor","us_code","create_user","product_manager","description","visible_value","product_code","lab_count","show_schedule","active_course_master","testing",
   "oracle_code","customized","mtm","qualifications","proctor","itbt","line_of_business")
  values  (30,r1.course_code,2,28,r1.course_name,'yes',r1.short_title,1,'no','yes','no',r1.course_code,'no',r1.mtm_name,'N/A','no','no',r1.lob);
  
  commit;
  
  select "id" into v_prod_id from "product"@rms_prod where "us_code" = r1.course_code;

  dbms_output.put_line(v_prod_id);
    
  insert into "product_product_line_area"@rms_prod("product","product_line_area","valid_from","use_vendor_area")
  values (v_prod_id,r1.product_line_area,'2040-01-01','no');
  
  insert into "product_product_manager"@rms_prod("product","product_manager","valid_from")
  values (v_prod_id,r1.product_manager_id,'2040-01-01');
  
  commit;

  if r1.c_mod = 'yes' or r1.n_mod = 'yes' then   
    insert into "product_modality_category"@rms_prod("product","category","hard_cap","internet_access","internet_type","pc_provider","pc_requirements","student_pc_ratio")
    values (v_prod_id,1,r1.hard_cap,r1.internet_access,r1.internet_type,r1.pc_provider,r1.pc_requirements,r1.student_pc_ratio);
    
    insert into "product_modality_duration"@rms_prod("product","product_line_category","valid_from","duration","duration_unit")
    values (v_prod_id,1,'2040-01-01',r1.duration_days,'day');
    
    insert into "product_modality_version"@rms_prod("product","product_line_category","valid_from","version")
    values (v_prod_id,1,'2006-01-01','x');
    
    insert into "product_modality_lab_request"@rms_prod("product","product_line_category","valid_from","lab_request")
    values (v_prod_id,1,'2040-01-01',r1.lab_type);  
    
    insert into "product_modality_start_end"@rms_prod("product","product_line_category","valid_from","start_time","end_time")
    values (v_prod_id,1,'2040-01-01','08:30:00','16:30:00'); 
        
    insert into "gk_prod_mod_stud_pc_ratio"@rms_prod("product","product_line_category","valid_from","student_pc_ratio")
    values (v_prod_id,1,'2013-04-01',r1.student_pc_ratio);
    
    insert into "product_modality_students"@rms_prod("product","product_line_category","valid_from","min_student","max_student")
    values (v_prod_id,1,'2040-01-01',r1.min_enroll,r1.max_enroll);
  end if;
  
  if r1.l_mod = 'yes' or r1.v_mod = 'yes' then
    insert into "product_modality_category"@rms_prod("product","category","hard_cap","internet_access","internet_type","pc_provider","pc_requirements","student_pc_ratio")
    values (v_prod_id,2,r1.hard_cap,r1.internet_access,r1.internet_type,'Customer',r1.pc_requirements,1);
    
    insert into "product_modality_duration"@rms_prod("product","product_line_category","valid_from","duration","duration_unit")
    values (v_prod_id,2,'2040-01-01',r1.duration_days,'day');

    insert into "product_modality_version"@rms_prod("product","product_line_category","valid_from","version")
    values (v_prod_id,2,'2006-01-01','x');
    
    insert into "product_modality_lab_request"@rms_prod("product","product_line_category","valid_from","lab_request")
    values (v_prod_id,2,'2040-01-01',r1.lab_type);
    
    insert into "product_modality_start_end"@rms_prod("product","product_line_category","valid_from","start_time","end_time")
    values (v_prod_id,2,'2040-01-01','08:30:00','16:30:00'); 
    
    insert into "product_modality_students"@rms_prod("product","product_line_category","valid_from","min_student","max_student")
    values (v_prod_id,2,'2040-01-01',r1.min_enroll,r1.max_enroll);
  end if; 
  
  if r1.c_mod = 'yes' then
    insert into "product_modality_mode"@rms_prod("product","product_line_mode","instructor","lab_request","active","internet_access","discount_flag","mfg_course_code","backlogged")
    values (v_prod_id,1,'yes',r1.lab_request,'yes',r1.internet_access,'N',r1.mfg_course_code,'Y');
    
        
    if upper(r1.lab_type) != 'NO LAB REQUIRED' then
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,1,null,null,r1.remote_lab_provider);
    end if;
  end if;
  
  if r1.n_mod = 'yes' then
    insert into "product_modality_mode"@rms_prod("product","product_line_mode","instructor","lab_request","active","internet_access","discount_flag","mfg_course_code","backlogged")
    values (v_prod_id,2,'yes',r1.lab_request,'yes',r1.internet_access,'N',r1.mfg_course_code,'Y');
    
    if upper(r1.lab_type) != 'NO LAB REQUIRED' then
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,2,null,null,r1.remote_lab_provider);
    end if;
  end if; 

  if r1.l_mod = 'yes' then
    insert into "product_modality_mode"@rms_prod("product","product_line_mode","instructor","lab_request","active","internet_access","discount_flag","mfg_course_code","backlogged")
    values (v_prod_id,3,'yes',r1.lab_request,'yes',r1.internet_access,'N',r1.mfg_course_code,'Y');
    
    if upper(r1.lab_type) != 'NO LAB REQUIRED' then
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,3,'VOIP+Phone','Adobe Connect',r1.remote_lab_provider);
    else
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,3,'VOIP+Phone','Adobe Connect',null);    
    end if;
    
  end if;
  
  if r1.v_mod = 'yes' then
    insert into "product_modality_mode"@rms_prod("product","product_line_mode","instructor","lab_request","active","internet_access","discount_flag","mfg_course_code","backlogged")
    values (v_prod_id,4,'yes',r1.lab_request,'yes',r1.internet_access,'N',r1.mfg_course_code,'Y');

    if upper(r1.lab_type) != 'NO LAB REQUIRED' then
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,4,'VOIP+Phone','Adobe Connect',r1.remote_lab_provider);
    else
      insert into "room_req_additional_fields"@rms_prod("product","mode_id","audio_option","virtual_platform","remote_lab_provider")
      values (v_prod_id,4,'VOIP+Phone','Adobe Connect',null);    
    end if;
    
  end if; 
  
  commit; 

/****** CREATE PRODUCT_COUNTRY FOR US ********/  
  insert into "product_country"@rms_prod
  ("product","country","showed","visible_value","submenu","on_request","mode_c","mode_n","mode_t","mode_l","mode_v","mode_g","mode_h","mode_u","mode_w","mode_r","mode_s","mode_d","mode_p","mode_y")
  values
  (v_prod_id,'US','yes','yes',r1.course_type,'no',r1.c_mod,r1.n_mod,'no',r1.l_mod,r1.v_mod,'no','no','no','no','no','no','no','no','no');
  
  commit;
  
  select "id" into v_prod_country_id from "product_country"@rms_prod where "product" = v_prod_id and "country" = 'US';


/****** CREATE PRODUCT_COUNTRY_MODE and PRODUCT_COUNTRY_PRICE FOR US ********/   
  if r1.c_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,1,'2013-04-01');
    
    if r1.us_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_primary_fee,'USD','2013-04-01',1,12,null);

      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'USD','2013-04-01',1,43,null);
      
    end if;
    
    if r1.gsa_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.gsa_primary_fee,'USD','2013-04-01',1,29,null);
    end if; 
  end if;
  
  if r1.n_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,2,'2013-04-01');
    
    if r1.us_ons_base_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_ons_base_fee,'USD','2013-04-01',2,34,r1.max_enroll);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_primary_fee*.7,'USD','2013-04-01',2,26,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'USD','2013-04-01',2,27,null);
    end if;
    
  end if;
  
  if r1.l_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,3,'2013-04-01');
    
    if r1.us_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_primary_fee,'USD','2013-04-01',3,12,null);

      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'USD','2013-04-01',3,43,null);
      
    end if;
    
    if r1.gsa_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.gsa_primary_fee,'USD','2013-04-01',3,29,null);
    end if; 

  end if;
  
  if r1.v_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,4,'2013-04-01');
    
    if r1.us_ons_base_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_ons_base_fee,'USD','2013-04-01',4,34,r1.max_enroll);

      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.us_primary_fee*.7,'USD','2013-04-01',4,26,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'USD','2013-04-01',4,27,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'USD','2013-04-01',4,43,null);
      
    end if;
    
  end if;
  
  commit;

/****** CREATE PRODUCT_COUNTRY FOR CA ********/    
  insert into "product_country"@rms_prod
  ("product","country","showed","visible_value","submenu","on_request","mode_c","mode_n","mode_t","mode_l","mode_v","mode_g","mode_h","mode_u","mode_w","mode_r","mode_s","mode_d","mode_p","mode_y")
  values
  (v_prod_id,'CA','yes','yes',r1.course_type,'no',r1.c_mod,r1.n_mod,'no',r1.l_mod,r1.v_mod,'no','no','no','no','no','no','no','no','no');
 
  commit;
  
  select "id" into v_prod_country_id from "product_country"@rms_prod where "product" = v_prod_id and "country" = 'CA';

/****** CREATE PRODUCT_COUNTRY_MODE and PRODUCT_COUNTRY_PRICE FOR CA ********/     
  if r1.c_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,1,'2013-04-01');
    
    if r1.ca_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_primary_fee,'CAD','2013-04-01',1,14,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'CAD','2013-04-01',1,44,null);
      
    end if;
  end if;
  
  if r1.n_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,2,'2013-04-01');
    
    if r1.ca_ons_base_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_ons_base_fee,'CAD','2013-04-01',2,35,r1.max_enroll);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_primary_fee*.7,'CAD','2013-04-01',2,46,null);

      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'CAD','2013-04-01',2,45,null);
            
    end if;
    
  end if;
  
  if r1.l_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,3,'2013-04-01');
    
    if r1.ca_primary_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_primary_fee,'CAD','2013-04-01',3,14,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'CAD','2013-04-01',3,44,null);
    end if;
  end if; 
  
  if r1.v_mod = 'yes' then
    insert into "product_country_mode"@rms_prod("product_country","product_line_mode","valid_from")
    values (v_prod_country_id,4,'2013-04-01');
    
    if r1.ca_ons_base_fee is not null then
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_ons_base_fee,'CAD','2013-04-01',4,35,r1.max_enroll);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,r1.ca_primary_fee*.7,'CAD','2013-04-01',4,46,null);

      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'CAD','2013-04-01',4,45,null);
      
      insert into "product_country_price"@rms_prod("product_country","price","currency","valid_from","product_line_mode","price_type","price_comment")
      values (v_prod_country_id,0,'CAD','2013-04-01',4,44,null);
      
    end if;
    
  end if;
  
  commit;
    
end loop;
close c1;

end;
/


