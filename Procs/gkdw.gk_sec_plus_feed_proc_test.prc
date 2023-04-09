DROP PROCEDURE GKDW.GK_SEC_PLUS_FEED_PROC_TEST;

CREATE OR REPLACE PROCEDURE GKDW.gk_sec_plus_feed_proc_test as

cursor c1 is
select enroll_id,event_id,start_date,cust_id,first_name,last_name,email,course_code,
       69312 vendor_id,'MINNEAPOLIS' vendor_site_code,84 org_id,101 inv_org_id,264 agent_id,10470 requestor_id,
       'USD' currency,unit_price,
       case when ops_country = 'CANADA' then '220' 
            when ch_num = '20' and country = 'CANADA' then '220'
            else '210' 
       end le_num,
       '130' fe_num,'62405' acct_num,ch_num,md_num,pl_num,act_num,'200' cc_num,
       course_code||'-'||to_char(start_date,'mm/dd/yyyy')||'-'||first_name||' '||last_name po_hdr,
       cust_id||','||first_name||','||last_name||','||email||','||course_code v_line1,
       enroll_id||','||event_id||','||to_char(start_date,'mm/dd/yyyy') v_line2
  from gk_gg_enrollment_v@slx
 where event_id not in ('Q6UJ9AS5YL26','Q6UJ9AS5YEJ6','Q6UJ9AD8N8T5','Q6UJ9AD8NBL7','Q6UJ9APXZG2J','Q6UJ9APXZG2I',
                        'Q6UJ9APY06PE','Q6UJ9APY0FR5','Q6UJ9APY0GAQ');
  

v_file utl_file.file_type;
v_file_name varchar2(100);
v_file_name_full varchar2(250);
v_ons_line varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_curr_po varchar2(250);
v_sid varchar2(20);
vcode_comb_id number;
l_req_id number;
v_oe_email varchar2(1) := 'N';
v_ent_email varchar2(1) := 'N';
v_ncftp_cmd varchar2(500);
x varchar2(1000);
r1 c1%rowtype;

begin

open c1;fetch c1 into r1;
if c1%found then
  close c1;

  select 'sec_plus_oe_'||to_char(sysdate,'yyyymmddhh24miss')||'.csv',
         '/usr/tmp/sec_plus_oe_'||to_char(sysdate,'yyyymmddhh24miss')||'.csv'
    into v_file_name,v_file_name_full
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

  for r1 in c1 loop
  dbms_output.put_line(r1.enroll_id);
--    select gk_get_curr_po(r1.org_id,v_sid) into v_curr_po from dual;
--    gk_update_curr_po(r1.org_id,v_sid);
--    commit;
--
--    gkn_po_create_hdr_proc@r12prd(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.currency,r1.po_hdr);
--    vcode_comb_id := gkn_get_account@r12prd(r1.le_num,r1.fe_num,r1.acct_num,r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,r1.cc_num);
--    gkn_po_create_line_proc@r12prd(1,null,r1.po_hdr,'EACH',1,r1.unit_price,r1.start_date,r1.inv_org_id,r1.org_id,
--                                   vcode_comb_id,'CARY',r1.requestor_id,r1.event_id,126);
--    commit;

    utl_file.put_line(v_file,r1.v_line1||','||r1.v_line2);

--    insert into gk_sec_plus_user_info
--      select r1.enroll_id,r1.event_id,r1.course_code,r1.cust_id,r1.first_name,r1.last_name,r1.email,
--             null,null,sysdate,v_curr_po,1,1
--        from dual;
--    commit;
  end loop;

  utl_file.fclose(v_file);
  
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'DW.Automation@globalknowledge.com',
            Recipient => 'DW.Automation@globalknowledge.com',
            CcRecipient => 'DW.Automation@globalknowledge.com',
            BccRecipient => '',
            Subject   => 'Sec Plus File - Open Enrollment',
            Body => 'Sec Plus File - Open Enrollment',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

--  v_ncftp_cmd := '/home/oracle/ncftp-3.2.5/bin/ncftpput -P 2121 -u globalknowledge -p t8swEYAmeguc 192.69.78.7 / '||v_file_name_full;
--  
--  dbms_output.put_line(v_ncftp_cmd);
--
--  x := OSCommand_Run(v_ncftp_cmd);
else 
  close c1;
end if;

--fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;  -- US REQUEST
--
--l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
--            NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
--commit;

--dbms_lock.sleep(30);
--gk_auto_receive_po_proc;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_SEC_PLUS_FEED_PROC_TEST',SQLERRM);


end;
/


