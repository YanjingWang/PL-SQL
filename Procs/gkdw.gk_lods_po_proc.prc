DROP PROCEDURE GKDW.GK_LODS_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_lods_po_proc(p_test varchar2 default 'N') as
   --=======================================================================
   -- Author Name:Sruthi Reddy (Initially created by Jon Dellomo)
   -- Create date
   -- Description: This is to process the LODs PO. A new file will be sent once
   -- every week.
   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      07/8/2016  Sruthi Reddy      Enhanced the existing process to 
   --                                        look for the file and if it does 
   --                                        not exist, no file will be processed 
   --                                       and if exists,LODs file will be processed.
   -- 1.1       03/19/2018 Venkata Uma      Modified vendor site code from 'BIP' to 'NEW PORT RICHEY'
   --========================================================================
cursor c2 is
select ed.ops_country,ed.event_id,ed.course_code,ed.facility_region_metro,ed.start_date,ed.end_date,
       to_number(lb.unit_price) po_unit_price,
       to_number(lb.enroll_cnt) po_unit_cnt,
       to_number(lb.day_cnt) po_day_cnt,
       to_number(lb.enroll_cnt)*to_number(lb.day_cnt) po_unit_amt,
       125 cat_id,case when ed.ops_country = 'CANADA' then '220' else '210' end le,
       '140' fe,'64215' acct,cd.ch_num ch,cd.md_num md,cd.pl_num pl,cd.act_num act,'210' cc,
       'LODS PO-'||ed.course_code||'-'||to_char(ed.start_date,'yyyymmdd')||'-'||ed.facility_region_metro||'('||ed.event_id||')' po_line_desc,
       ed.ops_country||chr(9)||ed.event_id||chr(9)||cd.course_code||chr(9)||ed.facility_region_metro||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||
       lb.unit_price||chr(9)||lb.enroll_cnt||chr(9)||lb.day_cnt||chr(9)||
       to_char(to_number(lb.enroll_cnt)*to_number(lb.day_cnt)*to_number(lb.unit_price)) excel_line
  from event_dim ed
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join lods_billing_load lb on ed.event_id = lb.event_id
order by ed.ops_country,ed.start_date,ed.course_code,ed.facility_region_metro,ed.event_id;

cursor c3(v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id;

cursor c4(v_po_num varchar2) is
select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
       l.quantity qty_deliv,
       l.unit_meas_lookup_code,u.uom_code
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
 where h.segment1 = v_po_num;

v_sid varchar2(12) := 'R12PRD';
v_curr_po varchar2(25);
v_need_date date;
v_po_hdr varchar2(250);
v_line_num number;
v_vendor_id number;
v_vendor_site varchar2(250);
v_org_id number;
v_inv_org_id number;
v_agent_id number;
v_requestor number;
v_curr_code varchar2(25);
v_code_comb_id number;
l_req_id number;
loop_cnt number := 1;
r2 c2%rowtype;
r3 c3%rowtype;
v_rcv_header number;
v_rcv_interface number;
v_rcv_transaction number;
po_cnt number;
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
lb_file_exist      BOOLEAN; --1.0
ln_size            NUMBER;  --1.0
ln_block_size      NUMBER;  --1.0

begin

sys.UTL_FILE.fgetattr ('GDW_INTERFACE',              -- 1.0
                          'lods_billing_load.csv',
                          lb_file_exist,
                          ln_size,
                          ln_block_size);
                          
IF lb_file_exist THEN                   -- 1.0
open c2;fetch c2 into r2;
if c2%found then
  close c2;
  
  select 'lods_po_'||to_char(sysdate,'yyyy-mm-dd')||'.xls',
         '/usr/tmp/lods_po_'||to_char(sysdate,'yyyy-mm-dd')||'.xls'
    into v_file_name,v_file_name_full
    from dual;

  select 'Country'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Metro'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||
         'Unit Price'||chr(9)||'Enroll Cnt'||chr(9)||'Day Cnt'||chr(9)||'Total'||chr(9)||'PO Number'||chr(9)||'PO Line Num'
    into v_hdr
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

  utl_file.put_line(v_file,v_hdr);

--AGENT_ID 4770 HILLIARD, TAIT 
--REQUESTOR_ID 15619 AMANDA GIBSON
--03-19-2018 V Uma - modified vendor site code from 'BIP' to 'NEW PORT RICHEY'
  select gk_get_curr_po(84,v_sid),608002,'NEW PORT RICHEY',84,101,4770,15619,'USD'
    into v_curr_po,v_vendor_id,v_vendor_site,v_org_id,v_inv_org_id,v_agent_id,v_requestor,v_curr_code
    from dual;
  commit;
  
  select to_char(min(ed.start_date),'yyyymmdd')||'-'||to_char(max(ed.start_date),'yyyymmdd')
    into v_po_hdr
    from event_dim ed
         inner join lods_billing_load lb on ed.event_id = lb.event_id;

  gk_update_curr_po(84,v_sid);
  commit;

  v_need_date := trunc(sysdate)+1;
  v_line_num := 1;

  gkn_po_create_hdr_proc@r12prd(v_curr_po,v_vendor_id,v_vendor_site,v_org_id,v_agent_id,v_curr_code);

  for r2 in c2 loop
    v_code_comb_id := gkn_get_account@r12prd(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
    gkn_po_create_line_proc@r12prd(v_line_num,null,r2.po_line_desc,'EACH',r2.po_unit_amt,r2.po_unit_price,v_need_date,v_inv_org_id,v_org_id,
                                   v_code_comb_id,'CARY',v_requestor,r2.event_id,r2.cat_id);
    commit;

    utl_file.put_line(v_file,r2.excel_line||chr(9)||v_curr_po||chr(9)||v_line_num);

    v_line_num := v_line_num + 1;

  end loop;
  utl_file.fclose(v_file);

  send_mail_attach('DW.Automation@globalknowledge.com','arap@learnondemandsystems.com','Robert.Stanley@globalknowledge.com','','Hands on Learning Solutions Weekly PO File','Open Excel Attachment.',v_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','jean.gendebien@learnondemandsystems.com','','','Hands on Learning Solutions Weekly PO File','Open Excel Attachment.',v_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','Patti.Ammons@learnondemandsystems.com','','','Hands on Learning Solutions Weekly PO File','Open Excel Attachment.',v_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','','Hands on Learning Solutions Weekly PO File','Open Excel Attachment.',v_file_name_full);   
   
  fnd_global_apps_init@r12prd(1111,20707,201,'PO',86) ;
  l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

  while loop_cnt < 5 loop
    open c3(l_req_id);
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
  
  sys.system_run ('mv /mnt/nc10s038/GDW_Interface/lods_billing_load.csv /mnt/nc10s038/GDW_Interface/GDW_Interface_Archive');  -- 1.0
else
  close c2;
  sys.system_run ('mv /mnt/nc10s038/GDW_Interface/lods_billing_load.csv /mnt/nc10s038/GDW_Interface/GDW_Interface_Archive'); -- 1.0
  
end if;
   ELSE                                                                         -- 1.0
      send_mail ('DW.Automation@globalknowledge.com',
                 'DW.Automation@globalknowledge.com',
                 'GK_LODS_PO_PROC complete',
                 'No new lods_billing_load.csv file available.');
 END IF;
exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GKL_LODS_PO_PROC failed',SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','Robert.Stanley@globalknowledge.com','GKL_LODS_PO_PROC failed',SQLERRM);

end;
/


