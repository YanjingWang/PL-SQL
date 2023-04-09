DROP PROCEDURE GKDW.GK_GILMORE_CISCO_PO_PROC_TEST;

CREATE OR REPLACE PROCEDURE GKDW.gk_gilmore_cisco_po_proc_test(p_test varchar2 default 'N') as

cursor c1(p_sid varchar2) is
select distinct --gk_get_curr_po(84,p_sid) curr_po,
f.enroll_id,
8150 vendor_id,'CISCO' vendor_site_code,84 org_id,101 inv_org_id,4770 agent_id,10690 requestor,'USD' curr_code
  from order_fact f  
  inner join event_dim ed on f.event_id = ed.event_id
       inner join gk_cisco_course_lookup cc on cc.course_code = ed.course_code
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where f.enroll_status not in ('Cancelled','Did Not Attend')
  and trunc(f.creation_date) >= trunc(sysdate)-6
     and f.book_amt > 0
     and not exists(select 1 from gk_gilmore_cisco_audit gc where gc.enroll_id = f.enroll_id)
   group by f.enroll_id,8150,'CISCO',84,101,4770,10690,'USD';

cursor c2(v_enroll_id varchar2) is
   select distinct ed.event_id, 
   f.enroll_id,
   cd.course_code,cd.course_name,cd.short_name,cd.course_ch,cd.course_mod,cd.course_pl,
       ed.start_date,--ed.facility_code,ed.facility_region_metro metro,ed.ops_country,
       cc.course_fee po_unit_price,
       case when upper(c.country) in ('CA','CANADA','CAN') then '220' else '210' end le,
       ' 000' fe,
       '41315' acct,
       cd.ch_num ch,
       '44' md,
       cd.pl_num pl,
       cd.act_num act,
       ' 000' cc,
       'GILMORE CISCO PO-'||ed.course_code||'-'||to_char(ed.start_date,'yyyymmdd')||'-'||f.enroll_id po_line_desc,
       '8150'||chr(9)||ed.event_id||chr(9)||f.enroll_id||chr(9)||cd.course_code||chr(9)||case when upper(c.country) in ('CA','CANADA','CAN') then '220' else '210' end||chr(9)||
       ' 000'||chr(9)||
       '41315'||chr(9)||
       cd.ch_num ||chr(9)||
       '44' ||chr(9)||
       cd.pl_num ||chr(9)||
       cd.act_num||chr(9)||
       ' 000' po_line
  from order_fact f  
  inner join event_dim ed on f.event_id = ed.event_id
  inner join cust_dim c on f.cust_id = c.cust_id
  inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_cisco_course_lookup cc on cc.course_code = ed.course_code
 where f.enroll_status not in ('Cancelled','Did Not Attend')
 and f.enroll_id = v_enroll_id
  and trunc(f.creation_date) >=trunc(sysdate)-6
   and f.book_amt > 0
    and not exists(select 1 from gk_gilmore_cisco_audit gc where gc.enroll_id = f.enroll_id)
 order by event_id;

cursor c3(p_sid varchar2,v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12dev
   where request_id = v_req_id
     and p_sid = 'R12DEV'
  union
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id
     and p_sid = 'R12PRD';

v_sid varchar2(10);
--curr_po varchar2(25);
vneed_date date;
vpo_hdr varchar2(250);
vline_num number;
--r1 c1%rowtype;
--v_msg_body long;
vcode_comb_id number;
l_req_id number;
v_error number;
v_error_msg varchar2(500);
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file utl_file.file_type;
v_hdr varchar2(2000);
v_curr_po varchar2(25);
--v_enroll_id varchar2(12);
loop_cnt number := 1;
r3 c3%rowtype;


begin

if p_test = 'Y' then
  v_sid := 'R12DEV';
else
  v_sid := 'R12PRD';
end if;

dbms_output.put_line(v_sid);

select 'gk_gilmore_cisco_po_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
       '/usr/tmp/gk_gilmore_cisco_po_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls'
  into v_file_name,v_file_name_full
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
v_hdr := 'Vendor ID'||chr(9)||'Event ID'||chr(9)||'Enroll ID'||chr(9)||'Course Code'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'PO NUM';

utl_file.put_line(v_file,v_hdr);

--open c1(v_sid);fetch c1 into r1;

--if c1%found then

for r1 in c1(v_sid) loop
  select gk_get_curr_po(84,v_sid) into v_curr_po from dual;
  gk_update_curr_po(84,v_sid);
  commit;

  vneed_date := trunc(sysdate)+1;
  vpo_hdr := 'GILMORE CISCO PO';


  if p_test = 'Y' then
    gkn_po_create_hdr_proc@r12dev(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  else
    gkn_po_create_hdr_proc@r12prd(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  end if;

 vline_num := 1;
  for r2 in c2(r1.enroll_id) loop
    if p_test = 'Y' then
      vcode_comb_id := gkn_get_account@r12dev(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
      gkn_po_create_line_proc@r12dev(vline_num,null,r2.po_line_desc,'EACH','1',r2.po_unit_price,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r2.event_id,125);                           
    else
      vcode_comb_id := gkn_get_account@r12prd(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
      --dbms_output.put_line(vcode_comb_id);
      gkn_po_create_line_proc@r12prd(vline_num,null,r2.po_line_desc,'EACH','1',r2.po_unit_price,vneed_date,r1.inv_org_id,r1.org_id,
                                  vcode_comb_id,'CARY',r1.requestor,r2.event_id,125);
                                  
                                   
    end if;
    commit;
     
     utl_file.put_line(v_file,r2.po_line||chr(9)||v_curr_po);
     
     if p_test = 'Y' then NULL ;
     else     
        insert into gk_gilmore_cisco_audit values(r1.enroll_id,'GILMORE CISCO',v_curr_po,sysdate,vline_num); 
   
    end if;
       commit;
     vline_num := vline_num + 1;


  end loop;



if p_test = 'Y' then -- SR 10/09/2018
    fnd_global_apps_init@r12dev(1111,20707,201,'PO',84) ;

    l_req_id := fnd_request.submit_request@r12dev('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
                NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  else
    fnd_global_apps_init@r12prd(1111,20707,201,'PO',86) ;

    l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
                NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  end if;
  commit;

  while loop_cnt < 5 loop -- SR 10/09/2018
    open c3(v_sid,l_req_id);
    fetch c3 into r3;
    if r3.phase_code = 'C' then
      loop_cnt := 5;
      dbms_lock.sleep(30);
      gk_receive_po_proc(v_curr_po,v_sid);
      gk_receive_request_proc(v_sid);
    else
      loop_cnt := loop_cnt+1;
      dbms_lock.sleep(30);
    end if;
    close c3;
  end loop;

end loop;

utl_file.fclose(v_file);

if p_test = 'Y' then
      v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'dw.automation@globalknowledge.com',
            Recipient => 'sruthi.reddy@globalknowledge.com',
            CcRecipient => 'accounts.Payable@globalknowledge.com',
            BccRecipient => '',
            Subject   => 'DO NOT DELETE',
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
  else

      v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'dw.automation@globalknowledge.com',
            Recipient => 'accounts.Payable@globalknowledge.com',
        --    CcRecipient => 'Fulfillment.US@globalknowledge.com',
            BccRecipient => 'sruthi.reddy@globalknowledge.com',
            Subject   => 'GILMORE CISCO '||to_char(sysdate,'dd-Mon-yy'),
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
  end if;


exception
  when others then
  rollback;
    send_mail('DW.Automation@globalknowledge.com','sruthi.reddy@globalknowledge.com','gk_gilmore_cisco_po_procedure TEST','TEST');

end;
/


