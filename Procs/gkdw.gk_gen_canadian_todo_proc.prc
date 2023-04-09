DROP PROCEDURE GKDW.GK_GEN_CANADIAN_TODO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_gen_canadian_todo_proc as

cursor c1 is
select distinct t1.contactid||chr(9)||t1.salesrep||chr(9)||to_char(trunc(sysdate+7),'mm/dd/yyyy')||chr(9)||'HIGH'||chr(9)||'GONOGO'||chr(9)||
       'QUOTE/'||t1.coursecode||'.'||ed.facility_region_metro||'.'||to_char(ed.start_date,'mm-dd')||'/IN JEOPARDY'||chr(9)||
       'NOTES'||chr(9)||to_char(trunc(sysdate),'mm/dd/yyyy')||chr(9)||ui.userid v_line
 from gk_outbound_mod_pl_v t1
      inner join slxdw.userinfo ui on t1.salesrep = ui.username
      inner join course_dim cd on t1.coursecode = cd.course_code and cd.country = 'CANADA'
      inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
      inner join time_dim td1 on ed.start_date = td1.dim_date
      inner join time_dim td2 on td2.dim_date = trunc(sysdate)
      inner join gk_rms_color_coding_v cc on ed.event_id = cc.event_id
 where upper(t1.country) = 'CANADA'
   and ed.status = 'Open'
   and t1.status = 'Open'
   and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between case when td2.dim_week > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0')
                                                                else td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                                           end
                                                       and case when td2.dim_week+8 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+8-52,2,'0')
                                                                else td2.dim_year||'-'||lpad(td2.dim_week+8,2,'0')
                                                           end
   and t1.createdate between td2.dim_date-49 and td2.dim_date-28
   and cc.margin between -.5 and .2
   and (
        t1.productline in ('CISCO','VMWare','NETWORKING')
        or t1.coursecode in ('6185C','6121C','6183C','6076C','6123C','6211C','6186C','6262C','6246C',
                             '6182C','6131C','6256C','2975C','2919C','2964C','2686C',
                             '6185L','6121L','6183L','6076L','6123L','6211L','6186L','6262L','6246L',
                             '6182L','6131L','6256L','2975L','2919L','2964L','2686L')
       )
   and not exists (select 1 from gk_canadian_todo ct where t1.contactid = ct.contactid
                      and 'QUOTE/'||t1.coursecode||'.'||ed.facility_region_metro||'.'||to_char(ed.start_date,'mm-dd')||'/IN JEOPARDY' = ct.regarding);

v_file utl_file.file_type;
v_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

v_file := utl_file.fopen('/usr/tmp','gk_canadian_todo_'||to_char(sysdate,'yyyymmdd')||'.xls','w');

v_hdr := 'CONTACTID'||chr(9)||'SALESREP'||chr(9)||'DUE_DATE'||chr(9)||'PRIORITY'||chr(9)||'CATEGORY'||chr(9)||'REGARDING'||chr(9)||
         'NOTES'||chr(9)||'LISTDATE'||chr(9)||'USERID';

utl_file.put_line(v_file,v_hdr);

for r1 in c1 loop
  utl_file.put_line(v_file,r1.v_line);
end loop;
utl_file.fclose(v_file);

insert into gk_canadian_todo
select distinct t1.contactid,t1.salesrep,trunc(sysdate)+7 due_date,'HIGH' priority,'GONOGO' category,
       'QUOTE/'||t1.coursecode||'.'||ed.facility_region_metro||'.'||to_char(ed.start_date,'mm-dd')||'/IN JEOPARDY' regarding,
       'NOTES' notes,trunc(sysdate) listdate,ui.userid
 from gk_outbound_mod_pl_v t1
      inner join slxdw.userinfo ui on t1.salesrep = ui.username
      inner join course_dim cd on t1.coursecode = cd.course_code and cd.country = 'CANADA'
      inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
      inner join time_dim td1 on ed.start_date = td1.dim_date
      inner join time_dim td2 on td2.dim_date = trunc(sysdate)
      inner join gk_rms_color_coding_v cc on ed.event_id = cc.event_id
 where upper(t1.country) = 'CANADA'
   and ed.status = 'Open'
   and t1.status = 'Open'
   and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between case when td2.dim_week > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0')
                                                                else td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                                           end
                                                       and case when td2.dim_week+8 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+8-52,2,'0')
                                                                else td2.dim_year||'-'||lpad(td2.dim_week+8,2,'0')
                                                           end
   and t1.createdate between ed.start_date-49 and ed.start_date-28
   and cc.margin between -.5 and .2
   and (
        t1.productline in ('CISCO','VMWare','NETWORKING')
        or t1.coursecode in ('6185C','6121C','6183C','6076C','6123C','6211C','6186C','6262C','6246C',
                             '6182C','6131C','6256C','2975C','2919C','2964C','2686C',
                             '6185L','6121L','6183L','6076L','6123L','6211L','6186L','6262L','6246L',
                             '6182L','6131L','6256L','2975L','2919L','2964L','2686L')
       )
   and not exists (select 1 from gk_canadian_todo ct where t1.contactid = ct.contactid
                      and 'QUOTE/'||t1.coursecode||'.'||ed.facility_region_metro||'.'||to_char(ed.start_date,'mm-dd')||'/IN JEOPARDY' = ct.regarding);
commit;
          
v_error := SendMailJPkg.SendMail(
           SMTPServerName => 'corpmail.globalknowledge.com',
           Sender    => 'DW.Automation@globalknowledge.com',
           Recipient => 'krissi.fields@globalknowledge.com',
           CcRecipient => '',
           BccRecipient => '',
           Subject   => 'Canadian ToDo Entries - '||to_char(sysdate,'yyyymmdd'),
           Body => 'Open Attached File',
           ErrorMessage => v_error_msg,
           Attachments  => SendMailJPkg.ATTACHMENTS_LIST('/usr/tmp/gk_canadian_todo_'||to_char(sysdate,'yyyymmdd')||'.xls'));

end;
/


