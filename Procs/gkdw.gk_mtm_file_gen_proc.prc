DROP PROCEDURE GKDW.GK_MTM_FILE_GEN_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_mtm_file_gen_proc(p_date date default null,p_test varchar2 default 'N') as
cursor c0(vv_date date) is
  select ops_country,
         'MTM_GK_'||substr(ops_country,1,2)||'_'||to_char(sysdate,'yyyy-mm-dd-hh24-mi')||'.xml' fname,
         case when substr(ops_country,1,2) = 'CA' then '608' else '614' end src_code
    from gk_mtm_data_mv
   where survey_date = vv_date
   group by ops_country;
   
cursor c1(t_date date,v_ops_country varchar2) is
  select distinct chr(9)||'<instructor xid="'||xml_instructor_id||'" fname="'||upper(firstname1)||
                '" lname="'||upper(lastname1)||'" email="'||
         case when email like '%,%' then substr(email,1,instr(email,',')-1)
            when email like '%;%' then substr(email,1,instr(email,';')-1)
            else email
         end||'" />' inst_xml_line
    from gk_mtm_data_mv
   where survey_date = t_date
     and email is not null
     and ops_country = v_ops_country;
     
cursor c2(t_date date,v_ops_country varchar2) is
  --select distinct chr(9)||'<course xid="'||xml_course_id||'" name="'|| --MTM update 20210209
   select distinct chr(9)||'<course xid="'||case when short_name is not null then short_name else xml_course_id end ||'" name="'||
         case
		    when short_name is not null then short_name --MTM update 20210209
            when course_mod in ('SPeL CD','RESELLER - SPeL') then course_name
            else trim(regexp_replace(replace(mtm_course_title,chr(38),chr(38)||'amp;'), '[^ -~]', '' ))
         end ||'" desc="'||
         case
            when course_mod in ('SPeL CD','RESELLER - SPeL') then course_name
            else trim(regexp_replace(replace(mtm_course_title,chr(38),chr(38)||'amp;'), '[^ -~]', '' ))
         end 
         || case when short_name is not null then '" mtmname="'||short_name else '' end  --Jones 2020-6-19
         ||'" ol="'||
         case when course_mod = 'V-LEARNING' then 'true'
              else 'false'
         end||'" />' course_xml_line
    from gk_mtm_data_mv
   where survey_date = t_date
     and ops_country = v_ops_country;
     
cursor c3(t_date date,v_ops_country varchar2) is
  select distinct chr(9)||'<location xid="'||xml_loc_id||'" name="'||
         replace(loc_desc,chr(38),chr(38)||'amp;')||'" to="'||nvl(tz.offsetfromutc,-5)||'" />' loc_xml_line
    from gk_mtm_data_mv m
         left outer join gk_facility_tz_v tz on m.location_id = tz.evxfacilityid
   where survey_date = t_date
     and xml_loc_id is not null
     and ops_country = v_ops_country;
     
cursor c4(t_date date,v_ops_country varchar2) is
   select distinct chr(9)||'<class xid="'||
                case
                    when course_mod in ('SPeL CD','RESELLER - SPeL') then xml_course_id
                    else event_id
                end||'" sd="'||to_char(start_date,'mm/dd/yyyy')||
                '" ed="'||to_char(end_date,'mm/dd/yyyy')||'" xloc="'||xml_loc_id||
              --  '" xcourse="'||xml_course_id||'" lm="'|| --MTM update 20210209
			  '" xcourse="'|| case when short_name is not null then short_name else xml_course_id end ||'" lm="'||		 
                case
                    when course_mod = 'V-LEARNING' then 4
                    when course_mod in ('SPeL CD','RESELLER - SPeL') then 2
                    else 1 end||'" headcount= "'||enroll_cnt||'">'||chr(10)||chr(9)||chr(9)||
                '<classInstructor xid="'||xml_instructor_id||'" lead="1" />'||chr(10)||chr(9)||chr(9)||
                '<survey sid="'||md.ka_survey_id||'" />'||chr(10)||chr(9)||chr(9)||
                '<survey sid="'||
                case
                    when course_pl = 'AVAYA' then '14106'
                    when course_pl = 'MICROSOFT' then '2579'
                    when course_mod in ('SPeL CD','RESELLER - SPeL','VIRTUAL') then '18866'
                    else '42907'
                end||'" />'||
                case --SR 10/24/2016
                    when ml.ka_followup_survey_id is not null then chr(10)||chr(9)||chr(9)|| 
                '<survey sid="'||ml.ka_followup_survey_id||'" />'
                    else null
                end
                class_xml_line, 
                event_id,md.course_pl,--ml.pl_desc,md.course_mod,ml.md_desc,
                md.ka_survey_id,ml.ka_followup_survey_id
    from gk_mtm_data_mv md
    left outer join (SELECT fl.survey_id, -- SR 10/24/2016
       fl.pl_desc,
       fl.pl_type,
       fl.md_desc,
       fl.loc_type,
       ml.ka_survey_id,
       fl.ka_survey_id ka_followup_survey_id
  FROM gk_mtm_followup_lookup fl
       INNER JOIN gk_mtm_lookup ml
          ON fl.pl_desc = ml.pl_desc AND fl.md_desc = ml.md_desc
and fl.loc_type = ml.loc_type) ml
    on md.ka_survey_id = ml.ka_survey_id
   where survey_date = t_date
     and course_mod in ('C-LEARNING', 'V-LEARNING')
     and ops_country = v_ops_country
  union
    select distinct chr(9)||'<class xid="'||
                case
                    when course_mod in ('SPeL CD','RESELLER - SPeL') then xml_course_id
                    else event_id
                end||'" sd="" ed="" xloc="" xcourse="'||xml_course_id||'" lm="'||
                case
                    when course_mod = 'V-LEARNING' then 4
                    when course_mod in ('SPeL CD','RESELLER - SPeL') then 2
                    else 1 end||'" headcount= "'||enroll_cnt||'">'||chr(10)||chr(9)||chr(9)||
                --'<classInstructor xid="" lead="1" />'||chr(10)||chr(9)||chr(9)||
                '<survey sid="'||md.ka_survey_id||'" />'||chr(10)||chr(9)||chr(9)||
                '<survey sid="'||
                case
                    when course_pl = 'AVAYA' then '14106'
                    when course_pl = 'MICROSOFT' then '2579'
                    when course_mod in ('SPeL CD','RESELLER - SPeL','VIRTUAL') then '18866'
                    else '42907'
                end||'" />'||
                case  --SR 10/24/2016
                    when ml.ka_followup_survey_id is not null then chr(10)||chr(9)||chr(9)|| 
                '<survey sid="'||ml.ka_followup_survey_id||'" />'
                    else null
                end class_xml_line,
         event_id,md.course_pl,--ml.pl_desc,md.course_mod,ml.md_desc,
                md.ka_survey_id,ml.ka_followup_survey_id
    from gk_mtm_data_mv md
    left outer join (SELECT fl.survey_id,  --SR 10/24/2016
       fl.pl_desc,
       fl.pl_type,
       fl.md_desc,
       fl.loc_type,
       ml.ka_survey_id,
       fl.ka_survey_id ka_followup_survey_id
  FROM gk_mtm_followup_lookup fl
       INNER JOIN gk_mtm_lookup ml
          ON fl.pl_desc = ml.pl_desc AND fl.md_desc = ml.md_desc
and fl.loc_type = ml.loc_type) ml
   on md.ka_survey_id = ml.ka_survey_id
   where course_mod in ('SPeL CD','RESELLER - SPeL')
     and ops_country = v_ops_country;
     
     
cursor c5(v_event_id varchar2) is
  select chr(9)||chr(9)||'<student xid="'||f.cust_id||'" email="'||
         case when cd.email like '%,%' then substr(cd.email,1,instr(cd.email,',')-1)
            when cd.email like '%;%' then substr(cd.email,1,instr(cd.email,';')-1)
            else cd.email
         end||
         '" company="'||
         trim(regexp_replace(replace(replace(replace(replace(replace(replace(substr(replace(cd.acct_name,'"',''),1,50),chr(38),chr(38)||'amp;'),chr(201),chr(69)),chr(191),''), chr(158)), chr(148)), chr(153)), '[^ -~]', ' ' )) ||'" jt="8" />' stud_xml_line
    from gk_mtm_data_mv dm
         inner join order_fact f on dm.event_id = f.event_id
         inner join cust_dim cd on f.cust_id = cd.cust_id
   where dm.event_id = v_event_id
     and enroll_status != 'Cancelled'
     and f.fee_type != 'Ons - Base' -- Added by SS 10/03/14
     and dm.status = 'Open'
     and cd.acct_id not in (select acct_id from mtm_client_exclude)
     and cd.email is not null
--     and (course_ch = 'INDIVIDUAL/PUBLIC'
--      or (course_mod = 'V-LEARNING' and course_ch = 'ENTERPRISE/PRIVATE'))
  union
  select chr(9)||chr(9)||'<student xid="'||f.cust_id||'" email="'||
         case when cd.email like '%,%' then substr(cd.email,1,instr(cd.email,',')-1)
            when cd.email like '%;%' then substr(cd.email,1,instr(cd.email,';')-1)
            else cd.email
         end||
         '" company="'||
        trim(regexp_replace(replace(replace(replace(replace(replace(replace(substr(replace(cd.acct_name,'"',''),1,50),chr(38),chr(38)||'amp;'),chr(201),chr(69)),chr(191),''), chr(158)), chr(148)), chr(153)), '[^ -~]', ' ' )) ||'" jt="8" />' stud_xml_line
    from gk_mtm_data_mv dm
         inner join order_fact f on dm.event_id = f.event_id
         inner join cust_dim cd on f.cust_id = cd.cust_id
   where dm.event_id = v_event_id
     and enroll_status = 'Attended'
     and f.fee_type != 'Ons - Base' -- Added SS 10/03/14
     and dm.status = 'Verified'
     and cd.acct_id not in (select acct_id from mtm_client_exclude)
     and cd.email is not null
--     and (course_ch = 'INDIVIDUAL/PUBLIC'
--      or (course_mod = 'V-LEARNING' and course_ch = 'ENTERPRISE/PRIVATE'))
  union
  select chr(9)||chr(9)||'<student xid="'||so.cust_id||'" email="'||
         case when cd.email like '%,%' then substr(cd.email,1,instr(cd.email,',')-1)
            when cd.email like '%;%' then substr(cd.email,1,instr(cd.email,';')-1)
            else cd.email
         end||
         '" company="'||
         trim(regexp_replace(replace(replace(replace(replace(replace(replace(substr(replace(cd.acct_name,'"',''),1,50),chr(38),chr(38)||'amp;'),chr(201),chr(69)),chr(191),''), chr(158)), chr(148)), chr(153)), '[^ -~]', ' ' ))||'" jt="8" />' stud_xml_line
    from gk_mtm_data_mv dm
         inner join sales_order_fact so on dm.event_id = so.sales_order_id
         inner join cust_dim cd on so.cust_id = cd.cust_id
   where dm.event_id = v_event_id
     and dm.status = 'Shipped'
     and cd.acct_id not in (select acct_id from mtm_client_exclude)
     and cd.email is not null
     and course_mod in ('SPeL CD','RESELLER - SPeL');
     
v_date date;
v_cnt number := 0;
v_stud_line varchar2(500);
mtm_file varchar2(50);
mtm_file_full varchar2(250);
mtm_hdr varchar2(1000);
xml_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);

begin
dbms_snapshot.refresh('gkdw.gk_mtm_data_mv');
if p_date is null then
  select trunc(sysdate)
    into v_date
    from dual;
else
  v_date := p_date;
end if;

dbms_output.put_line(v_date) ;

for r0 in c0(v_date) loop
  select r0.fname,
         '/usr/tmp/'||r0.fname
    into mtm_file,mtm_file_full
    from dual;
  xml_file := utl_file.fopen('/usr/tmp',mtm_file,'w');
  select '<?xml version="1.0" encoding="UTF-8" ?>'||chr(10)||
         '<import date="'||sysdate||'" src="'||r0.src_code||'">'
    into mtm_hdr
    from dual;
  utl_file.put_line(xml_file,mtm_hdr);
  /****************************************************/
  /***** INSTRUCTOR MTM DATA LOADED INTO XML FILE *****/
  /****************************************************/
  utl_file.put_line(xml_file,'<instructors>');
  for r1 in c1(v_date,r0.ops_country) loop
    utl_file.put_line(xml_file,r1.inst_xml_line);
  end loop;
  utl_file.put_line(xml_file,'</instructors>');
  /****************************************************/
  /***** COURSE MTM DATA LOADED INTO XML FILE *********/
  /****************************************************/
  utl_file.put_line(xml_file,'<courses>'||chr(10));
  for r2 in c2(v_date,r0.ops_country) loop
    utl_file.put_line(xml_file,r2.course_xml_line);
  end loop;
  utl_file.put_line(xml_file,'</courses>'||chr(10));
  /****************************************************/
  /***** LOCATION MTM DATA LOADED INTO XML FILE *********/
  /****************************************************/
  utl_file.put_line(xml_file,'<locations>');
  for r3 in c3(v_date,r0.ops_country) loop
    utl_file.put_line(xml_file,r3.loc_xml_line);
  end loop;
  utl_file.put_line(xml_file,'</locations>');
  /****************************************************/
  /***** CLASS MTM DATA LOADED INTO XML FILE **********/
  /****************************************************/
  utl_file.put_line(xml_file,'<classes>');
  for r4 in c4(v_date,r0.ops_country) loop
    utl_file.put_line(xml_file,r4.class_xml_line);
    for r5 in c5(r4.event_id) loop
      utl_file.put_line(xml_file,r5.stud_xml_line);
    end loop;
    utl_file.put_line(xml_file,chr(9)||'</class>');
  end loop;
  utl_file.put_line(xml_file,'</classes>');
  utl_file.put_line(xml_file,'</import>');
  utl_file.fclose(xml_file);
if p_test = 'Y' then
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'alan.frelich@globalknowledge.com',
            Recipient => 'alan.frelich@globalknowledge.com',
            CcRecipient => 'Smaranika.Baral@globalknowledge.com',
            BccRecipient => 'JAMAAL.JONES@GLOBALKNOWLEDGE.COM',
            Subject   => r0.fname,
            Body => 'MTM XML File is Attached.',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(mtm_file_full));
else
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'alan.frelich@globalknowledge.com',
            Recipient => 'Chris.Hanes@globalknowledge.com',
            CcRecipient => 'Smaranika.Baral@globalknowledge.com',
            BccRecipient => 'DW.Automation@globalknowledge.com',
            Subject   => r0.fname,
            Body => 'MTM XML File is Attached.',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(mtm_file_full));
            
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'alan.frelich@globalknowledge.com',
            Recipient => 'alan.frelich@globalknowledge.com',
            CcRecipient => 'Kevin.Addington@globalknowledge.net',
            BccRecipient => 'eledonne@explorance.com',
            Subject   => r0.fname,
            Body => 'MTM XML File is Attached.',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(mtm_file_full));

end if;
end loop;
end;
/


