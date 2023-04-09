DROP PROCEDURE GKDW.GK_COURSWARE_TAX_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_coursware_tax_proc(v_tax_type varchar2) as

cursor c1 is
select trim(l.sold_to) sold_to,trim(l.transid) transid,trim(l.class_code) class_code,
       trim(l.po_num) po_num,upper(trim(l.part_num)) part_num,
       to_number(l.qty) qty,to_number(trim(replace(replace(l.unit_price,','),'$'))) unit_price,
       to_number(trim(replace(replace(replace(l.ext_value,'$'),','),'-'))) ext_value,
       to_number(trim(replace(replace(replace(l.sub_total,'$'),','),'-'))) sub_total,
       to_number(trim(replace(replace(replace(l.taxes,'$'),','),'-'))) taxes,
       to_number(trim(replace(replace(replace(l.freight_cost,'$'),','),'-'))) freight_cost,  
       to_number(trim(replace(replace(replace(l.order_total,'$'),','),'-'))) order_total,
       upper(trim(l.ship_company)) ship_company,upper(trim(l.address1)) address1,upper(trim(l.address2)) address2,
       substr(trim(l.postal_code),1,5) postal_code,upper(trim(l.city)) city,upper(trim(l.state)) state,
       upper(trim(replace(l.country,chr(13)))) country,b.cw_category tax_modality ,
       replace(upper(trim(l.ship_contact_name)),chr(13)) ship_contact_name,
       f.enroll_id,ed.event_id,
       '210' le_num,'130' fe_num,'62405' acct_num,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,'200' cc_num
  from gk_courseware_load l
       inner join cw_bom@evp b on upper(trim(part_num)) = upper(trim(b.kit_num))
       inner join mygk_po_line@evp pl on trim(substr(l.po_num, 1, instr(l.po_num, '_') -1)) = pl.po_num and upper(trim(l.part_num)) = upper(trim(pl.part_number))
       inner join order_fact f on trim(pl.evxevenrollid) = f.enroll_id and f.enroll_status != 'Cancelled'
       inner join cust_dim c on f.cust_id = c.cust_id and upper(c.first_name)||' '||upper(c.last_name) = replace(upper(trim(ship_contact_name)),chr(13))
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
where (upper(l.invoice_num) not like 'INVOICE%' or invoice_num is null)
  and upper(l.ext_value) not like 'TOTAL%'
  and substr(upper(trim(l.country)),1,2) = 'US'
  and upper(v_tax_type) = 'DIGITAL';

cursor c2 is
select trim(l.sold_to) sold_to,trim(l.transid) transid,trim(l.class_code) class_code,
       trim(l.po_num) po_num,upper(trim(l.part_num)) part_num,
       to_number(l.qty) qty,to_number(trim(replace(replace(l.unit_price,','),'$'))) unit_price,
       to_number(trim(replace(replace(replace(l.ext_value,'$'),','),'-'))) ext_value,
       to_number(trim(replace(replace(replace(l.sub_total,'$'),','),'-'))) sub_total,
       to_number(trim(replace(replace(replace(l.taxes,'$'),','),'-'))) taxes,
       to_number(trim(replace(replace(replace(l.freight_cost,'$'),','),'-'))) freight_cost,  
       to_number(trim(replace(replace(replace(l.order_total,'$'),','),'-'))) order_total,
       upper(trim(l.ship_company)) ship_company,upper(trim(l.address1)) address1,upper(trim(l.address2)) address2,
       substr(trim(l.postal_code),1,5) postal_code,upper(trim(l.city)) city,upper(trim(l.state)) state,
       upper(trim(replace(l.country,chr(13)))) country,
       replace(upper(trim(l.ship_contact_name)),chr(13)) ship_contact_name
  from gk_courseware_load l
where (upper(l.invoice_num) not like 'INVOICE%' or invoice_num is null)
  and upper(l.ext_value) not like 'TOTAL%'
  and upper(v_tax_type) in ('GILMORE','AVAYA','CANADA');

cursor c3(c_part_num varchar2,c_state varchar2,c_class_code varchar2,c_country varchar2) is
select '210' le_num,
       '130' fe_num,
       nvl(nvl(cd1.ch_num,cd2.ch_num),'10') ch_num,
       nvl(nvl(cd1.md_num,cd2.md_num),'10') md_num,
       nvl(nvl(cd1.pl_num,cd2.pl_num),'01') pl_num,
       nvl(nvl(cd1.act_num,cd2.act_num),'000000') act_num,
       ed.event_id,
       ts.taxable freight_taxable
from evp.cw_bom@gkprod cb
     inner join gk_freight_tax_state ts on upper(c_state) = ts.state_abbr
     left outer join event_dim ed on ed.event_id = c_class_code
     left outer join course_dim cd1 on ed.course_id = cd1.course_id and ed.ops_country = cd1.country
     left outer join course_dim cd2 on cd2.course_code = c_class_code and cd2.country = 'USA'
where cb.kit_num = c_part_num
  and c_country = 'US'
  and c_state not in ('AZ','CA','CO','MA','NC','KS','NY')
  and exists (select 1 from gk_tax_types t where t.line_desc = case when cb.kit_num is not null then 'Courseware' else c_part_num end and taxable = 'Y');

cursor c4 is
select t.*,freight_tax_amt+cw_tax_amt tax_amt,aa.gl_acct,
       case when v_tax_type = 'DIGITAL' then 'Digital Use Tax'
            when v_tax_type = 'GILMORE' then 'Gilmore Use Tax'
            when v_tax_type = 'AVAYA' then 'Avaya Use Tax'
       end reference4,
       case when v_tax_type = 'DIGITAL' then 'Digital Use Tax Accrual USD - Invoice: '||t.invoice_num
            when v_tax_type = 'GILMORE' then 'Gilmore Use Tax Accrual USD - Invoice: '||t.invoice_num
            when v_tax_type = 'AVAYA' then 'Avaya Use Tax Accrual USD - Invoice: '||t.invoice_num
       end reference5,
       t.invoice_num||'-'||t.state||'-'||t.class_code reference10,
       t.invoice_num||chr(9)||t.invoice_date||chr(9)||t.sold_to||chr(9)||t.transid||chr(9)||t.class_code||chr(9)||t.po_num||chr(9)||t.part_num||chr(9)||t.qty||chr(9)||t.unit_price||chr(9)||t.ext_value||chr(9)||
       t.sub_total||chr(9)||t.taxes||chr(9)||t.freight_cost||chr(9)||t.order_total||chr(9)||t.ship_company||chr(9)||t.address1||chr(9)||t.address2||chr(9)||t.postal_code||chr(9)||t.city||chr(9)||t.state||chr(9)||
       t.enroll_id||chr(9)||t.event_id||chr(9)||t.le_num||chr(9)||t.fe_num||chr(9)||t.acct_num||chr(9)||t.ch_num||chr(9)||t.md_num||chr(9)||t.pl_num||chr(9)||t.act_num||chr(9)||t.cc_num||chr(9)||t.country||chr(9)||
       t.tax_modality||chr(9)||t.tax_rate||chr(9)||t.tax_geocode||chr(9)||t.sub_total*t.tax_rate tax_line 
  from gk_courseware_tax_out t
       inner join gk_tax_accrual_acct aa on t.state = aa.state_abbr
 where upper(v_tax_type) in ('DIGITAL','GILMORE','AVAYA')
   and tax_rate > 0;

cursor c5(v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id;

cursor c6 is
select l.transid,'INV '||l.invoice_num inv_num,l.invoice_date,'GILMORE',l.po_num,l.class_code,
       round(f.freight_qty,2) freight_qty,
       sum(case when part_num = 'GK201-1' then 0 else qty end) total_qty,
       round(sum(case when part_num = 'GK201-1' then 0 else qty end)*f.freight_qty,2) debit,
       case when l.country = 'CA' then '220' else '210' end le,
       '130' fe,
       '62405' acct,
       nvl(nvl(cd.ch_num,l.ch_num),'10') ch,
       nvl(nvl(cd.md_num,l.md_num),'10') md,
       nvl(nvl(cd.pl_num,l.pl_num),'01') pl,
       nvl(nvl(cd.act_num,l.act_num),'000000') act,
       '200' cc,
       '000' fut,
       l.transid||chr(9)||'INV '||l.invoice_num||chr(9)||l.invoice_date||chr(9)||'GILMORE'||chr(9)||l.po_num||chr(9)||l.class_code||chr(9)||
       round(f.freight_qty,2)||chr(9)||sum(case when part_num = 'GK201-1' then 0 else qty end)||chr(9)||
       round(sum(case when part_num = 'GK201-1' then 0 else qty end)*f.freight_qty,2)||chr(9)||
       case when l.country = 'CA' then '220' else '210' end||chr(9)||'130'||chr(9)||'62405'||chr(9)||
       nvl(nvl(cd.ch_num,l.ch_num),'10')||chr(9)||
       nvl(nvl(cd.md_num,l.md_num),'10')||chr(9)||
       nvl(nvl(cd.pl_num,l.pl_num),'01')||chr(9)||
       nvl(nvl(cd.act_num,l.act_num),'000000')||chr(9)||
       '200'||chr(9)||'000' v_line
  from gk_courseware_tax_out l
       inner join gk_cw_freight_v f on l.address1 = f.address1 and l.city = f.city and l.state = f.state
       left outer join course_dim cd on l.class_code = cd.course_code and cd.country = case when l.country = 'CA' then 'CANADA' else 'USA' end
                                     and cd.gkdw_source = 'SLXDW' and cd.inactive_flag = 'F'
 where upper(part_num) not like 'DUTY%BROKERAGE'
   and upper(part_num) not like 'ORDER%MANAGE%'
   and upper(v_tax_type) in ('GILMORE','AVAYA','CANADA')
 group by l.transid,l.invoice_num,l.invoice_date,l.po_num,l.class_code,f.freight_qty,
          case when l.country = 'CA' then '220' else '210' end,nvl(nvl(cd.ch_num,l.ch_num),'10'),nvl(nvl(cd.md_num,l.md_num),'10'),
          nvl(nvl(cd.pl_num,l.pl_num),'01'),nvl(nvl(cd.act_num,l.act_num),'000000')
 order by l.class_code;
   
vrate number;
vgeo varchar2(250);
v_inv_num varchar2(250) := null;
v_inv_date date := null;
v_name varchar2(25);
v_gl_date date;
v_import_num varchar2(25);
l_req_id number;
v_file utl_file.file_type;
v_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_file_name varchar2(500);
v_file_name_full varchar2(500);
r5 c5%rowtype;
loop_cnt number := 0;
v_sold_to varchar2(250);
v_transid varchar2(250);
v_class_code varchar2(250);
v_po_num varchar2(250);
v_part_num varchar2(250);
v_qty number;
v_unit_price number;
v_ext_value number;
v_sub_total number;
v_taxes number;
v_freight_cost number;
v_order_total number;
v_ship_company varchar2(250);
v_address1 varchar2(250);
v_address2 varchar2(250);
v_postal_code varchar2(250);
v_city varchar2(250);
v_state varchar2(250);
v_country varchar2(250);
v_ship_contact_name varchar2(250);
v_le_num varchar2(25);
v_fe_num varchar2(25);
v_ch_num varchar2(25);
v_md_num varchar2(25);
v_pl_num varchar2(25);
v_acct_num varchar2(25);
v_act_num varchar2(25);
v_event_id varchar2(25);
v_freight_taxable varchar2(25);
v_freight_email varchar2(1) := 'N';
v_state_cnt number := 0;

begin

delete from gk_courseware_tax_out;
commit;

select distinct invoice_num,to_date(invoice_date,'mm/dd/yyyy') into v_inv_num,v_inv_date from gk_courseware_load where invoice_num is not null and upper(invoice_num) not like 'INVOICE%';

for r1 in c1 loop

  vrate := gk_calc_us_salestax_func@vertex('84',r1.city,r1.state,r1.postal_code,null,r1.tax_modality);
  
    dbms_output.put_line(r1.city||'|'||r1.state||'|'||r1.postal_code||'|'||r1.country);
    
  vgeo :=  gk_calc_us_geocode_func@vertex('84',r1.city,r1.state,r1.postal_code,null,r1.tax_modality);
  
  --dbms_output.put_line(r1.transid||'|'||r1.part_num||'|'||r1.state||'|'||r1.class_code||'|'||r1.country||'|'||vrate);
  
  insert into gk_courseware_tax_out(invoice_num,invoice_date,sold_to,transid,class_code,po_num,part_num,qty,unit_price,ext_value,sub_total,taxes,freight_cost,order_total,ship_company,address1,address2,
                                    postal_code,city,state,enroll_id,event_id,le_num,fe_num,acct_num,ch_num,md_num,pl_num,act_num,cc_num,country,tax_modality,tax_rate,tax_geocode,freight_tax_amt,cw_tax_amt)
                            values (v_inv_num,v_inv_date,r1.sold_to,r1.transid,r1.class_code,r1.po_num,r1.part_num,r1.qty,r1.unit_price,r1.ext_value,r1.sub_total,r1.taxes,r1.freight_cost,r1.order_total,
                                    r1.ship_company,r1.address1,r1.address2,r1.postal_code,r1.city,r1.state,r1.enroll_id,r1.event_id,r1.le_num,r1.fe_num,r1.acct_num,r1.ch_num,r1.md_num,r1.pl_num,
                                    r1.act_num,r1.cc_num,r1.country,r1.tax_modality,nvl(vrate,0),vgeo,0,nvl(vrate,0)*r1.sub_total);
end loop;
commit;

for r2 in c2 loop
  v_sold_to := nvl(r2.sold_to,v_sold_to);
  v_transid := nvl(r2.transid,v_transid);
  v_class_code := nvl(r2.class_code,v_class_code);
  v_po_num := nvl(r2.po_num,v_po_num);
  v_part_num := r2.part_num;
  v_qty := nvl(r2.qty,0);
  v_unit_price := nvl(r2.unit_price,0);
  v_ext_value := nvl(r2.ext_value,0);
  v_sub_total := nvl(r2.sub_total,0);
  v_taxes := nvl(r2.taxes,0);
  v_freight_cost := nvl(r2.freight_cost,0);
  v_order_total := nvl(r2.order_total,0);
  v_ship_company := nvl(r2.ship_company,v_ship_company);
  v_address1 := nvl(r2.address1,v_address1);
  v_address2 := nvl(r2.address2,v_address2);
  v_postal_code := nvl(r2.postal_code,v_postal_code);
  v_city := nvl(r2.city,v_city);
  v_state := nvl(r2.state,v_state);
  v_country := nvl(r2.country,v_country);
  v_ship_contact_name := nvl (r2.ship_contact_name,v_ship_contact_name);

  select count(*) into v_state_cnt from gk_freight_tax_state where state_abbr = v_state;
  
  if v_state_cnt > 0 then 
    vrate := gk_calc_us_salestax_func@vertex('84',v_city,v_state,v_postal_code,null,'PC');
    
     dbms_output.put_line(v_city||'|'||v_state||'|'||v_postal_code||'|'||v_country);
     
    vgeo :=  gk_calc_us_geocode_func@vertex('84',v_city,v_state,v_postal_code,null,'PC');
  else
    vrate := 0;
    vgeo := null;
  end if;
  
  v_le_num := '210';
  v_fe_num := '130';
  v_ch_num := '10';
  v_md_num := '10';
  v_pl_num := '01';
  v_acct_num := '62405';
  v_act_num := '000000';
  
  dbms_output.put_line(v_transid||'|'||v_part_num||'|'||v_state||'|'||v_class_code||'|'||v_country);
  
  for r3 in c3(v_part_num,v_state,v_class_code,v_country) loop
    v_le_num := r3.le_num;
    v_fe_num := r3.fe_num;
    v_ch_num := r3.ch_num;
    v_md_num := r3.md_num;
    v_pl_num := r3.pl_num;
    v_acct_num := '62405';
    v_act_num := r3.act_num;
    v_event_id := r3.event_id;
    v_freight_taxable := r3.freight_taxable;
  end loop;

  insert into gk_courseware_tax_out(invoice_num,invoice_date,sold_to,transid,class_code,po_num,part_num,qty,unit_price,ext_value,sub_total,taxes,freight_cost,order_total,ship_company,address1,address2,
                                    postal_code,city,state,enroll_id,event_id,le_num,fe_num,acct_num,ch_num,md_num,pl_num,act_num,cc_num,country,tax_modality,tax_rate,tax_geocode,freight_taxable,
                                    freight_tax_amt,cw_tax_amt)
                            values (v_inv_num,v_inv_date,v_sold_to,v_transid,v_class_code,v_po_num,v_part_num,v_qty,v_unit_price,v_ext_value,v_sub_total,v_taxes,v_freight_cost,v_order_total,
                                    v_ship_company,v_address1,v_address2,v_postal_code,v_city,v_state,null,v_event_id,v_le_num,v_fe_num,v_acct_num,v_ch_num,v_md_num,v_pl_num,v_act_num,'200',
                                    v_country,'PC',vrate,vgeo,v_freight_taxable,v_freight_cost*vrate,v_sub_total*vrate);
    
end loop;
commit;

select period_name,trunc(sysdate) 
  into v_name,v_gl_date
  from gl_periods@r12prd
 where trunc(sysdate) between start_date and end_date 
   and period_set_name = 'GKNET ACCTG'
   and period_name not like 'ADJ%';

v_file_name := v_inv_num||'_tax_out.xls';
v_file_name_full := '/usr/tmp/'||v_inv_num||'_tax_out.xls';
   
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

v_hdr := 'Invoice Num'||chr(9)||'Invoice Date'||chr(9)||'Sold To'||chr(9)||'Trans ID'||chr(9)||'Class Code'||chr(9)||'PO Num'||chr(9)||'Part ID'||chr(9)||'Qty'||chr(9)||'Unit Price'||chr(9)||'Ext Value'||chr(9)||'Sub Total'||chr(9)||'Taxes'||chr(9)||'Freight Cost'||chr(9)||'Order Total'||chr(9)||'Ship Company'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'Postal Code'||chr(9)||'City'||chr(9)||'State'||chr(9)||
         'Enroll ID'||chr(9)||'Event ID'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'Country'||chr(9)||'Tax Modality'||chr(9)||'Tax Rate'||chr(9)||'Tax GeoCode'||chr(9)||'Tax Amt';

utl_file.put_line(v_file,v_hdr);
 
for r4 in c4 loop
  utl_file.put_line(v_file,r4.tax_line);
  
  insert into gl_interface@r12prd
    (status,ledger_id,accounting_date,currency_code,date_created,created_by,
     actual_flag,user_je_category_name,user_je_source_name,segment1,segment2,segment3,
     segment4,segment5,segment6,segment7,segment8,segment9,entered_dr,entered_cr,reference4,reference5,reference10,
     set_of_books_id)
  values
    ('NEW',2,v_gl_date,'USD',sysdate,0,'A','Accrual','Other',r4.le_num,r4.fe_num,r4.acct_num,r4.ch_num,r4.md_num,r4.pl_num,r4.act_num,r4.cc_num,'000',
     r4.tax_amt,0,r4.reference4,r4.reference5,r4.reference10,2);

  insert into gl_interface@r12prd
    (status,ledger_id,accounting_date,currency_code,date_created,created_by,
     actual_flag,user_je_category_name,user_je_source_name,segment1,segment2,segment3,
     segment4,segment5,segment6,segment7,segment8,segment9,entered_dr,entered_cr,reference4,reference5,reference10,
     set_of_books_id)
  values
    ('NEW',2,v_gl_date,'USD',sysdate,0,'A','Accrual','Other',r4.le_num,'000',r4.gl_acct,'00','00','00','000000','000','000',
     0,r4.tax_amt,r4.reference4,r4.reference5,r4.reference10,2);

end loop;
commit;

utl_file.fclose(v_file);

if upper(v_tax_type) in ('DIGITAL','GILMORE','AVAYA') then 

v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'smaranika.baral@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

          
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'sheila.jacobs@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'tax.nam@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'jennifer.parker@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
             
 v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'Mayuri.NV@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
             
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'Pallavi.Govindraj@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));                          
 
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'Angela.Styons@globalknowledge.com',
             CcRecipient => 'DW.Automation@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
           
  select gl.gl_journal_import_s.nextval@r12prd into v_import_num from dual;

  insert into gl_interface_control@r12prd(je_source_name,status,interface_run_id,set_of_books_id)
  values
  ('Other','S',v_import_num,'2');

  fnd_global_apps_init@r12prd(1111,50227,101,'GL',84) ;  --GK US GENERAL LEDGER SUPER USER

  l_req_id := fnd_request.submit_request@r12prd('SQLGL','GLLEZL','Journal Import','',FALSE,
              v_import_num,'2','N',NULL,NULL,'N','W','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

  while loop_cnt < 5 loop
    open c5(l_req_id);
    fetch c5 into r5;
    if r5.phase_code = 'C' then
      loop_cnt := 5;
      dbms_lock.sleep(30);
    else
      loop_cnt := loop_cnt+1;
      dbms_lock.sleep(30);
    end if;
    close c5;
  end loop;
end if;
commit;

v_file := utl_file.fopen('/usr/tmp',v_inv_num||'_freight_alloc.xls','w');

v_hdr := 'Trans ID'||chr(9)||'Inv Num'||chr(9)||'Inv Date'||chr(9)||'Vendor'||chr(9)||'PO Num'||chr(9)||'Class Code'||chr(9)||
         'Freight/Kit'||chr(9)||'Qty'||chr(9)||'Freight Alloc'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||
         'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'FUT';

utl_file.put_line(v_file,v_hdr);

for r6 in c6 loop
  utl_file.put_line(v_file,r6.v_line);
  v_freight_email := 'Y';
end loop;

utl_file.fclose(v_file);

if v_freight_email = 'Y' then 
           
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'sheila.jacobs@globalknowledge.com',
             CcRecipient => 'jennifer.parker@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Freight Allocation File - '||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST('/usr/tmp/'||v_inv_num||'_freight_alloc.xls'));
             
   v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'sheila.jacobs@globalknowledge.com',
             CcRecipient => 'Pallavi.Govindraj@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Freight Allocation File - '||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST('/usr/tmp/'||v_inv_num||'_freight_alloc.xls')); 
             
             
    v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'sheila.jacobs@globalknowledge.com',
             CcRecipient => 'Mayuri.NV@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Freight Allocation File - '||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST('/usr/tmp/'||v_inv_num||'_freight_alloc.xls'));
                                 
             
   v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'smaranika.baral@globalknowledge.com',
             CcRecipient => 'DW.Automation@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Courseware Tax File-'||v_tax_type||'-'||v_inv_num,
             Body => 'Open Attached File',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));          
end if;
commit;

exception
  when others then
    rollback;
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_COURSEWARE_TAX_PROC Failed',SQLERRM);

end;
/


