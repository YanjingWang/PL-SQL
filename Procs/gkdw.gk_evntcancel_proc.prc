DROP PROCEDURE GKDW.GK_EVNTCANCEL_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_EvntCancel_proc(p_cancel_date varchar2 default null) as
/*************************************************************************************************
This is requested by Ben Harris. Created by SR 11/28/2017
*************************************************************************************************/
cursor c1(v_date date) is
SELECT T1.COURSE_CODE||chr(9)||
       T2.SHORT_NAME||chr(9)||
       T1.EVENT_ID||chr(9)||
       T1.START_DATE||chr(9)||
       T1.END_DATE||chr(9)||
       T1.START_TIME||chr(9)||
       T1.END_TIME||chr(9)||
       T1.LOCATION_NAME||chr(9)||
       T1.ADDRESS1||chr(9)||
       T1.FACILITY_REGION_METRO||chr(9)||
       T1.LOCATION_ID||chr(9)||
       T1.STATUS||chr(9)||
       T1.STATUS_DATE||chr(9)||
       T1.CANCEL_DATE||chr(9)||
       T1.LAST_UPDATE_DATE v_line
  FROM EVENT_DIM T1
       INNER JOIN COURSE_DIM T2
          ON T1.COURSE_ID = T2.COURSE_ID AND T1.OPS_COUNTRY = T2.COUNTRY
 WHERE T1.STATUS = 'Cancelled' AND T1.CANCEL_DATE = v_date;
   
v_file_name varchar2(50);
v_file_full varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_msg_body varchar2(2000);
v_error number;
v_error_msg varchar2(500);
v_cancel_date date;
begin
if p_cancel_date is null then
  v_cancel_date := trunc(sysdate)-1;
else
  v_cancel_date := to_date(p_cancel_date,'mm/dd/yyyy');
end if;
v_file_name := 'Event_Cancellations_'||to_char(trunc(sysdate)-1,'yyyymmdd')||'.xls';
v_file_full := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
v_hdr := 'Course code'||chr(9)||'short Name'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Start Time'||chr(9)||'End Time'||chr(9)||'Location Time'||chr(9)||'Address1'||chr(9)||'Metro';
v_hdr := v_hdr||chr(9)||'Location ID'||chr(9)||'Status'||chr(9)||'Status Date'||chr(9)||'Cancel Date'||chr(9)||'Last Update Date';

utl_file.put_line(v_file,v_hdr);
for r1 in c1(v_cancel_date) loop
  utl_file.put_line(v_file,r1.v_line);
end loop;
utl_file.fclose(v_file);

v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'DW.Automation@globalknowledge.com',
          Recipient => 'Chris.Pichler@globalknowledge.com',
          CcRecipient => '',
          BccRecipient => '',
          Subject   => 'Event Cancellation Report-'||v_cancel_date,
          Body => 'Open Attachment',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
       
end;
/


