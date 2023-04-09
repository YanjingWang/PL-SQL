DROP PROCEDURE GKDW.GK_STAT_ALLOCATION_GEN;

CREATE OR REPLACE PROCEDURE GKDW.gk_stat_allocation_gen(pname varchar2 default null) as
cursor c2(v_pname varchar2) is
  select td.dim_period_name||chr(9)||
         case when ed.ops_country = 'USA' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else cd.le_num 
         end||chr(9)||'145'||chr(9)||'67405'||chr(9)||
         cd.ch_num||chr(9)||cd.md_num||chr(9)||cd.pl_num||chr(9)||cd.act_num||chr(9)||
         nvl(d.cc_num,'210')||chr(9)||'000'||chr(9)||to_char(ed.meeting_days)||chr(9)||ed.event_id||chr(9)||
         ed.start_date||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.course_code||chr(9)||
         ed.facility_code||chr(9)||ed.facility_region_metro||chr(9)||to_char(ed.meeting_days*gk_get_event_hours(ed.event_id)*nvl(d.audit_rate,0))||chr(9)||
         ed.adj_meeting_days stat_line
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join time_dim td on ed.start_date = td.dim_date
         left outer join gk_facility_cc_dim d on ed.facility_code = d.facility_code
   where cd.md_num in ('10','20')
     and cd.course_code not in (select nested_course_code from gk_nested_courses)
     and cd.course_code not in ('3163N', '3164N', '3188N', '3189N')
     and ed.status not in ('Cancelled')
     and ed.internalfacility = 'T'
     and td.fiscal_period_name = v_pname
  union
    select td.dim_period_name||chr(9)||
         case when ed.ops_country = 'USA' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else cd.le_num 
         end||chr(9)||'145'||chr(9)||'66150'||chr(9)||
         cd.ch_num||chr(9)||cd.md_num||chr(9)||cd.pl_num||chr(9)||cd.act_num||chr(9)||
         nvl(d.cc_num,'210')||chr(9)||'000'||chr(9)||to_char(ed.meeting_days)||chr(9)||ed.event_id||chr(9)||
         ed.start_date||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.course_code||chr(9)||
         ed.facility_code||chr(9)||ed.facility_region_metro||chr(9)||to_char(ed.meeting_days*gk_get_event_hours(ed.event_id)*nvl(d.dep_alloc,0))||chr(9)||
         ed.adj_meeting_days stat_line
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join time_dim td on ed.start_date = td.dim_date
         inner join gk_facility_cc_dim d on ed.facility_code = d.facility_code and d.dep_alloc > 0 
   where cd.md_num in ('10','20')
     and cd.course_code not in (select nested_course_code from gk_nested_courses)
     and cd.course_code not in ('3163N', '3164N', '3188N', '3189N')
     and ed.status not in ('Cancelled')
     and ed.internalfacility = 'T'
     and td.fiscal_period_name = v_pname;
     
cursor c3(v_pname varchar2) is
  select td.dim_period_name||chr(9)||
         case when ed.ops_country = 'USA' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else cd.le_num 
         end||chr(9)||'110'||chr(9)||'67405'||chr(9)||
         cd.ch_num||chr(9)||cd.md_num||chr(9)||cd.pl_num||chr(9)||cd.act_num||chr(9)||
         '000' ||chr(9)||'000'||chr(9)||to_char(ed.meeting_days)||chr(9)||ed.event_id||chr(9)||
         ed.start_date||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.course_code||chr(9)||ed.facility_code||chr(9)||
         ed.facility_region_metro||chr(9)||
         to_char(ed.meeting_days*gk_get_event_hours(ed.event_id)*nvl(rp.int_inst_rate,0))||chr(9)||
         ed.adj_meeting_days||chr(9)||c.first_name||' '||c.last_name stat_line
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join time_dim td on ed.start_date = td.dim_date
         inner join instructor_event_v ie on ed.event_id = ie.evxeventid
         inner join cust_dim c on ie.contactid = c.cust_id
         left outer join gk_int_inst_rate_pl rp on cd.pl_num = rp.pl_num
   where ed.ops_country = 'USA'
     and cd.md_num in ('10','20')
     and cd.course_code not in (select nested_course_code from gk_nested_courses)
     and not exists (select 1 from gk_connected_class_v c where ed.event_id = c.event_id and c.connected_v_to_c is not null)  /*** ADDED FOR C+V EXCLUSION OF VIRTUAL ***/
     and cd.course_code not in ('3163N', '3164N', '3188N', '3189N')
     and ed.status not in ('Cancelled')
     and ((substr(feecode,1,instr(feecode,'-')-2) in ('INS','SI','CT','SS','FA','AUD','TAUD'))
      or (feecode in ('INS','SI','CT','SS','FA','AUD','TAUD')))
     and (upper(account) like 'GLOBAL KNOW%'
      or  upper(account) like 'NEXIENT%')
     and td.fiscal_period_name = v_pname
  union
  select td.dim_period_name||chr(9)||
         case when ed.ops_country = 'USA' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else cd.le_num 
         end||chr(9)||'110'||chr(9)||'67405'||chr(9)||
         cd.ch_num||chr(9)||cd.md_num||chr(9)||cd.pl_num||chr(9)||cd.act_num||chr(9)||
         '000' ||chr(9)||'000'||chr(9)||to_char(ed.meeting_days)||chr(9)||ed.event_id||chr(9)||
         ed.start_date||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.course_code||chr(9)||ed.facility_code||chr(9)||
         ed.facility_region_metro||chr(9)||
         to_char(ed.meeting_days*gk_get_event_hours(ed.event_id)*nvl(rp.alloc_rate,0))||chr(9)||
         ed.adj_meeting_days||chr(9)||c.first_name||' '||c.last_name stat_line
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join time_dim td on ed.start_date = td.dim_date
         inner join instructor_event_v ie on ed.event_id = ie.evxeventid
         inner join cust_dim c on ie.contactid = c.cust_id
         left outer join gk_int_inst_rate_canada rp on ie.contactid = rp.instructor_id
   where ed.ops_country = 'CANADA'
     and cd.md_num in ('10','20')
     and cd.course_code not in (select nested_course_code from gk_nested_courses)
     and not exists (select 1 from gk_connected_class_v c where ed.event_id = c.event_id and c.connected_v_to_c is not null)  /*** ADDED FOR C+V EXCLUSION OF VIRTUAL ***/
     and cd.course_code not in ('3163N', '3164N', '3188N', '3189N')
     and ed.status not in ('Cancelled')
     and ((substr(feecode,1,instr(feecode,'-')-2) in ('INS','SI','CT','SS','FA','AUD','TAUD'))
      or (feecode in ('INS','SI','CT','SS','FA','AUD','TAUD')))
     and (upper(account) like 'GLOBAL KNOW%'
      or  upper(account) like 'NEXIENT%')
     and td.fiscal_period_name = v_pname;
     
per_name varchar2(20);
stat_file varchar2(50);
stat_file_gl varchar2(250);
stat_file_tc varchar2(250);
stat_file_inst varchar2(250);
stat_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
begin
if pname is null then
  select period_name into per_name from gl_periods@r12prd 
   where end_date = trunc(sysdate)-1 
     and start_date != trunc(sysdate)-1
     and period_set_name = 'GKNET ACCTG' 
     and period_name not like 'ADJ%';
else
  per_name := pname;
end if;
select 'Internal_TC_Allocation-'||per_name||'.xls','/usr/tmp/'||'Internal_TC_Allocation-'||per_name||'.xls'
   into stat_file,stat_file_tc
   from dual;
v_file := utl_file.fopen('/usr/tmp',stat_file,'w');
select 'Period Name'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||
         'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'FUT'||chr(9)||
         'Days'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||'Status'||chr(9)||'Location'||chr(9)||
         'Course Code'||chr(9)||'Facility Code'||chr(9)||'Metro Code Code'||chr(9)||'Alloc Amt'||chr(9)||'Adj Meeting Days'
   into stat_hdr
   from dual;
utl_file.put_line(v_file,stat_hdr);
for r2 in c2(per_name) loop
   utl_file.put_line(v_file,r2.stat_line);
end loop;
utl_file.fclose(v_file);
select 'Internal_Instructor_Allocation-'||per_name||'.xls','/usr/tmp/'||'Internal_Instructor_Allocation-'||per_name||'.xls'
   into stat_file,stat_file_inst
   from dual;
v_file := utl_file.fopen('/usr/tmp',stat_file,'w');
select 'Period Name'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||
         'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'FUT'||chr(9)||
         'Days'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||'Status'||chr(9)||'Location'||chr(9)||
         'Course Code'||chr(9)||'Facility Code'||chr(9)||'Metro Code Code'||chr(9)||'Alloc Amt'||chr(9)||'Adj Meeting Days'||chr(9)||
         'Instructor'
  into stat_hdr
  from dual;
utl_file.put_line(v_file,stat_hdr);
for r3 in c3(per_name) loop
   utl_file.put_line(v_file,r3.stat_line);
end loop;
utl_file.fclose(v_file);
v_mail_hdr := per_name||' Statistic Allocation Files';
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'Jennifer.Parker@globalknowledge.com',
                CcRecipient => 'connie.cook@globalknowledge.com',
                BccRecipient => 'christy.murdock@globalknowledge.com',
                Subject   => v_mail_hdr,
                Body => 'Monthly Statistic Allocation Files',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(stat_file_tc,stat_file_inst));
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'Al.Koltas@GLOBALKNOWLEDGE.COM',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Monthly Statistic Allocation Files',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(stat_file_tc,stat_file_inst));
                
             

exception
  when others then
    rollback;
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);
end;
/


