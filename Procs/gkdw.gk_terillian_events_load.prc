DROP PROCEDURE GKDW.GK_TERILLIAN_EVENTS_LOAD;

CREATE OR REPLACE PROCEDURE GKDW.gk_terillian_events_load as
   --=======================================================================
   -- Author Nam:Sruthi Reddy
   -- Create date
   -- Description: 
   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      10/5/2016  Sruthi Reddy      Modified cursor c1 - updated 
   --                                       trunc(sysdate)+90 to trunc(sysdate)+120
   --                                       to support BT extended virtual courses
   --                                       where the end date can go beyond 90
   --========================================================================
cursor c1 is
select nvl( GTE.TERILLIAN_COURSE_CODE, GTE.COURSE_CODE) course_code,class_id,replace(event_name,',') event_name,status,location_id, 
       company_id,maxseats,minseat,start_time,end_time,connected_c,connected_v_to_c, 
       start_date,end_date,tzgenericname,country
  from gk_terillian_events_v gte
 where trunc(gte.end_date) between trunc(sysdate)-1 and trunc(sysdate)+120 --or course_code = '9995V' -- SR ticket#6572
union
select nvl( GTE.TERILLIAN_COURSE_CODE, GTE.COURSE_CODE) course_code,class_id,replace(event_name,',') event_name,status,location_id, 
       company_id,maxseats,minseat,start_time,end_time,connected_c,connected_v_to_c, 
       start_date,end_date,tzgenericname,country
  from gk_terillian_events_v gte
  where md_num = 32 
 order by course_code, start_date, class_id;

/** ADDED CURSOR FOR EXTENDED VIRTUAL SESSION TIMES -- JD -- 5/8/14 **/ 
cursor c2 is
select ed.event_id||'|'||ed.session_date||'|'||ed.start_time||'|'||ed.session_date||'|'||ed.end_time session_line
  from gk_event_days_mv ed
       inner join gk_ext_events_v ee on ed.event_id = ee.event_id
 order by ed.event_id,ed.session_date,ed.start_time;
    

msg_body varchar2(5000);
v_error number;
v_error_msg varchar2(500);
v_audit_file varchar2(50);
v_sessions_file varchar2(50);
v_file utl_file.file_type;

begin

select 'Events.txt','Sessions.txt'
  into v_audit_file,v_sessions_file
  from dual;

v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');

utl_file.put_line(v_file,'COURSE_CODE'||'|'||'CLASS_ID'||'|'||'EVENT_NAME'||'|'||'STATUS'||'|'||'LOCATION_ID'||'|'||'COMPANY_ID'||'|'||
                         'MAXSEATS'||'|'||'MINSEAT'||'|'||'START_TIME'||'|'||'END_TIME'||'|'||'CONNECTED_C'||'|'||'CONNECTED_V_TO_C'||'|'||
                         'START_DATE'||'|'||'END_DATE'||'|'||'TZGENERICNAME'||'|'||'COUNTRY');
                        
for r1 in c1 loop 
  utl_file.put_line(v_file,r1.course_code||'|'||r1.class_id||'|'||r1.event_name||'|'||r1.status||'|'||r1.location_id||'|'||r1.company_id||'|'||
                           r1.maxseats||'|'||r1.minseat||'|'||r1.start_time||'|'||r1.end_time||'|'||r1.connected_c||'|'||r1.connected_v_to_c||'|'|| 
                           r1.start_date||'|'||r1.end_date||'|'||r1.tzgenericname||'|'||r1.country);
end loop;
utl_file.fclose(v_file);

v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_sessions_file,'w');

utl_file.put_line(v_file,'CLASS_ID'||'|'||'START_DATE'||'|'||'START_TIME'||'|'||'END_DATE'||'|'||'END_TIME');

for r2 in c2 loop
  utl_file.put_line(v_file,r2.session_line);
end loop;
utl_file.fclose(v_file);

exception
  when no_data_found then
    utl_file.fclose(v_file);

  when others then
    utl_file.fclose(v_file);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK Terillian Events Load Failed',SQLERRM);

end;
/


