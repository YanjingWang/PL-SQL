DROP PROCEDURE GKDW.GK_EVENT_COURSE_XML_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_event_course_xml_proc as
cursor c_events_us is
select  chr(9)||'<event>'||chr(10)||
chr(9)||chr(9)||'<eventid>'||substr(ed.ops_country,1,2)||'-'||ed.event_id||'</eventid>'||chr(10)||
chr(9)||chr(9)||'<code>'||cd.course_code||'</code>'||chr(10)||
chr(9)||chr(9)||'<eventlistprice>'||cd.list_price||'</eventlistprice>'||chr(10)||
--chr(9)||chr(9)||'<currency>'||case when substr(cd.country,1,2) = 'US' then 'USD' when substr(cd.country,1,2) = 'CA' then 'CAD' end||'</currency>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||ed.facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||ed.city||'</location>'||chr(10)||
chr(9)||chr(9)||'<startdate>'||to_char(ed.start_date,'YYYY-MM-DD')||'</startdate>'||chr(10)||
chr(9)||chr(9)||'<enddate>'||to_char(ed.end_date,'YYYY-MM-DD')||'</enddate>'||chr(10)||
chr(9)||chr(9)||'<duration>'||ed.meeting_days||'</duration>'||chr(10)||
chr(9)||chr(9)||'<modalitycode>'||substr(ed.course_code,-1,1)||'</modalitycode>'||chr(10)||
chr(9)||chr(9)||'<modality>'||plm."description"||'</modality>'||chr(10)||
chr(9)||'</event>'||chr(10) xml_line 
from event_dim ed
inner join course_dim cd
on ed.course_id = cd.course_id and ed.ops_country = cd.country
left outer join "product_line_mode"@rms_prod plm on substr(ed.course_code,-1,1) = plm."mode"
where  ed.start_date >= trunc(sysdate)
and ed.status <> 'Cancelled'
and cd.ch_num <> 20
and substr(upper(ed.ops_country),1,2) = 'US'; -- 20 is private events

cursor c_events_ca is
select  chr(9)||'<event>'||chr(10)||
chr(9)||chr(9)||'<eventid>'||substr(ed.ops_country,1,2)||'-'||ed.event_id||'</eventid>'||chr(10)||
chr(9)||chr(9)||'<code>'||cd.course_code||'</code>'||chr(10)||
chr(9)||chr(9)||'<eventlistprice>'||cd.list_price||'</eventlistprice>'||chr(10)||
--chr(9)||chr(9)||'<currency>'||case when substr(cd.country,1,2) = 'US' then 'USD' when substr(cd.country,1,2) = 'CA' then 'CAD' end||'</currency>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||ed.facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||ed.city||'</location>'||chr(10)||
chr(9)||chr(9)||'<startdate>'||to_char(ed.start_date,'YYYY-MM-DD')||'</startdate>'||chr(10)||
chr(9)||chr(9)||'<enddate>'||to_char(ed.end_date,'YYYY-MM-DD')||'</enddate>'||chr(10)||
chr(9)||chr(9)||'<duration>'||ed.meeting_days||'</duration>'||chr(10)||
chr(9)||chr(9)||'<modalitycode>'||substr(ed.course_code,-1,1)||'</modalitycode>'||chr(10)||
chr(9)||chr(9)||'<modality>'||plm."description"||'</modality>'||chr(10)||
chr(9)||'</event>'||chr(10) xml_line 
from event_dim ed
inner join course_dim cd
on ed.course_id = cd.course_id and ed.ops_country = cd.country
left outer join "product_line_mode"@rms_prod plm on substr(ed.course_code,-1,1) = plm."mode"
where  ed.start_date >= trunc(sysdate)
and ed.status <> 'Cancelled'
and cd.ch_num <> 20
and substr(upper(ed.ops_country),1,2) = 'CA'; -- 20 is private events

cursor c_locations_us is
select  chr(9)||'<address>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||city||'</location>'||chr(10)||
chr(9)||chr(9)||'<address1>'||address1||'</address1>'||chr(10)||
chr(9)||chr(9)||'<address2>'||address2||'</address2>'||chr(10)||
chr(9)||chr(9)||'<address3>'||address3||'</address3>'||chr(10)||
chr(9)||chr(9)||'<address4>'||state||'</address4>'||chr(10)||
chr(9)||chr(9)||'<address5>'||country||'</address5>'||chr(10)||
chr(9)||chr(9)||'<postcode>'||zipcode||'</postcode>'||chr(10)||
chr(9)||'</address>'||chr(10) xml_line 
from(SELECT DISTINCT facility_code,
                city,
                address1,
                address2,
                address3,
                state,
                country,
                zipcode
  FROM (SELECT UPPER (ed.facility_code) facility_code,
               UPPER (ed.city) city,
               UPPER (ed.address1) address1,
               UPPER (ed.address2) address2,
               ed.address3,
               ed.state,
               ed.country,
               ed.zipcode,
               ROW_NUMBER ()
               OVER (
                  PARTITION BY UPPER (ed.facility_code)
                  ORDER BY UPPER (ed.facility_code))
                  rn
          FROM course_dim cd
               INNER JOIN event_dim ed
                  ON     ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
         WHERE     ed.start_date >= TRUNC (SYSDATE)
               AND ed.status <> 'Cancelled'
               AND cd.ch_num <> 20
               AND ed.facility_code IS NOT NULL
               AND substr(upper(ed.ops_country),1,2) = 'US'
               )
 WHERE rn = 1);

cursor c_locations_ca is
select  chr(9)||'<address>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||city||'</location>'||chr(10)||
chr(9)||chr(9)||'<address1>'||address1||'</address1>'||chr(10)||
chr(9)||chr(9)||'<address2>'||address2||'</address2>'||chr(10)||
chr(9)||chr(9)||'<address3>'||address3||'</address3>'||chr(10)||
chr(9)||chr(9)||'<address4>'||state||'</address4>'||chr(10)||
chr(9)||chr(9)||'<address5>'||country||'</address5>'||chr(10)||
chr(9)||chr(9)||'<postcode>'||zipcode||'</postcode>'||chr(10)||
chr(9)||'</address>'||chr(10) xml_line 
from(SELECT DISTINCT facility_code,
                city,
                address1,
                address2,
                address3,
                state,
                country,
                zipcode
  FROM (SELECT UPPER (ed.facility_code) facility_code,
               UPPER (ed.city) city,
               UPPER (ed.address1) address1,
               UPPER (ed.address2) address2,
               ed.address3,
               ed.state,
               ed.country,
               ed.zipcode,
               ROW_NUMBER ()
               OVER (
                  PARTITION BY UPPER (ed.facility_code)
                  ORDER BY UPPER (ed.facility_code))
                  rn
          FROM course_dim cd
               INNER JOIN event_dim ed
                  ON     ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
         WHERE     ed.start_date >= TRUNC (SYSDATE)
               AND ed.status <> 'Cancelled'
               AND cd.ch_num <> 20
               AND ed.facility_code IS NOT NULL
               AND substr(upper(ed.ops_country),1,2) = 'CA'
               )
 WHERE rn = 1);
 
--v_text varchar2(50);
v_file utl_file.file_type;
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file_name_1 varchar2(50);
v_file_name_full_1 varchar2(250);
v_loc_file_name varchar2(50);
v_loc_file_name_full varchar2(250);
v_loc_file_name_1 varchar2(50);
v_loc_file_name_full_1 varchar2(250);
v_error_msg varchar2(500);
v_error number;
event_new_flag varchar2(1) := 'N';
loc_new_flag varchar2(1) := 'N';

begin

  select 'gk_events_feed_us.xml',
         '/usr/tmp/gk_events_feed_us.xml','gk_events_feed_ca.xml',
         '/usr/tmp/gk_events_feed_ca.xml','gk_locations_feed_us.xml','/usr/tmp/gk_locations_feed_us.xml','gk_locations_feed_ca.xml','/usr/tmp/gk_locations_feed_ca.xml'
    into v_file_name,v_file_name_full,v_file_name_1,v_file_name_full_1,v_loc_file_name,v_loc_file_name_full,v_loc_file_name_1,v_loc_file_name_full_1
    from dual;
-- generate US events file
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_file,'<events>'||chr(10));
for r_events_us in c_events_us loop
  utl_file.put_line(v_file,r_events_us.xml_line);
  event_new_flag := 'Y';
end loop;
utl_file.put_line(v_file,'</events>'||chr(10));
 commit;
 utl_file.fclose(v_file);

-- Generate CA events file 
v_file := utl_file.fopen('/usr/tmp',v_file_name_1,'w');

utl_file.put_line(v_file,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_file,'<events>'||chr(10));
for r_events_ca in c_events_ca loop
  utl_file.put_line(v_file,r_events_ca.xml_line);
  event_new_flag := 'Y';
end loop;
utl_file.put_line(v_file,'</events>'||chr(10));
 commit;
 utl_file.fclose(v_file);

-- Generate US locations file
v_file := utl_file.fopen('/usr/tmp',v_loc_file_name,'w');

utl_file.put_line(v_file,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_file,'<locations>'||chr(10));
for r_locations_us in c_locations_us loop
  utl_file.put_line(v_file,r_locations_us.xml_line);
  loc_new_flag := 'Y';
end loop;
utl_file.put_line(v_file,'</locations>'||chr(10));
 commit;
 utl_file.fclose(v_file);

-- Generate CA locations file
v_file := utl_file.fopen('/usr/tmp',v_loc_file_name_1,'w');

utl_file.put_line(v_file,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_file,'<locations>'||chr(10));
for r_locations_ca in c_locations_ca loop
  utl_file.put_line(v_file,r_locations_ca.xml_line);
  loc_new_flag := 'Y';
end loop;
utl_file.put_line(v_file,'</locations>'||chr(10));
 commit;
 utl_file.fclose(v_file);

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'sruthi.reddy@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'GK EVENTS and LOCATIONS FEED XML file',
             Body => 'GK EVENTS and LOCATIONS FEED XML Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_file_name_full_1,v_loc_file_name_full,v_loc_file_name_full_1));

-- v_error := SendMailJPkg.SendMail(
--             SMTPServerName => 'corpmail.globalknowledge.com',
--             Sender    => 'DW.Automation@globalknowledge.com',
--             Recipient => 'sruthi.reddy@globalknowledge.com',
--             CcRecipient => '',
--             BccRecipient => '',
--             Subject   => 'GK EVENT LOCATION FEED XML file',
--             Body => 'GK EVENT LOCATION FEED XML Complete',
--             ErrorMessage => v_error_msg,
--             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_loc_file_name_full));
             

             
exception
when others then rollback;
  send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK EVENT LOCATION FEED XML Failed',SQLERRM);
end;
/


