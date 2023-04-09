DROP PROCEDURE GKDW.GK_VENDOR_REVENUE;

CREATE OR REPLACE PROCEDURE GKDW.gk_vendor_revenue as

cursor c1 is
    select trunc(e.creation_date)||chr(9)||c.vendor_code||chr(9)||e.event_id||chr(9)||e.course_code||chr(9)||
        e.start_date||chr(9)||e.end_date||chr(9)||c.duration_days||chr(9)||e.status||chr(9)||c.course_name||chr(9)||
        c.capacity||chr(9)||e.event_prod_line||chr(9)||a.acct_name||chr(9)||a.city||chr(9)||a.state||chr(9)||
        sum(o.book_amt)||chr(9)||e.facility_region_metro||chr(9)||e.conf_enrollments c_line
    from gkdw.event_dim e
        inner join gkdw.course_dim c on e.course_id = c.course_id and e.ops_country = c.country
        left outer join gkdw.order_fact o on e.event_id = o.event_id
        left outer join gkdw.opportunity_dim od on e.opportunity_id = od.opportunity_id
        left outer join gkdw.account_dim a on od.account_id = a.acct_id
    where trunc(e.creation_date) = trunc(sysdate -1)
        and (e.course_code like '%H%' or e.course_code like '%Y%')
        --and c.country = 'USA'
        and e.status <> 'Cancelled'
    group by e.creation_date,c.vendor_code,e.event_id,e.course_code,e.start_date,e.end_date,
        c.duration_days,e.status,c.course_name,c.capacity,e.event_prod_line,a.acct_name,
        a.city,a.state,e.facility_region_metro,e.conf_enrollments
    order by e.creation_date,c.vendor_code,e.start_date;

rev_file varchar2(50);
rev_file_full varchar2(250);
rev_hdr varchar2(1000);
c_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

select 'VENDOR_REVENUE.xls','/usr/tmp/'||'VENDOR_REVENUE.xls'
    into rev_file,rev_file_full
    from dual;

c_file := utl_file.fopen('/usr/tmp',rev_file,'w');

select 'Create Date'||chr(9)||'Vendor Code'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||
        'End Date'||chr(9)||'Duration Days'||chr(9)||'Status'||chr(9)||'Course Name'||chr(9)||'Capacity'||chr(9)||
        'Event Prod Line'||chr(9)||'Acct Name'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Event Revenue'||chr(9)||
        'Facility Metro'||chr(9)||'Conf Enroll'
    into rev_hdr
    from dual;

utl_file.put_line(c_file,rev_hdr);

for r1 in c1 loop
   utl_file.put_line(c_file,r1.c_line);
end loop;

utl_file.fclose(c_file);

  v_mail_hdr := 'Vendor Revenue Report';

  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => 'PMPartnerPrograms@globalknowledge.com',
                CcRecipient => 'PartnerPrograms.CA@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Daily Onsite Vendor Revenue',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(rev_file_full));

exception
  when others then
    rollback;
    utl_file.fclose(c_file);
    send_mail('SQLService@globalknowledge.com','alan.frelich@globalknowledge.com','GK_VENDOR_REVENUE PROC FAILED',SQLERRM);

end;
/


