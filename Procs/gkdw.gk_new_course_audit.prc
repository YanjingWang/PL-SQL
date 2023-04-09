DROP PROCEDURE GKDW.GK_NEW_COURSE_AUDIT;

CREATE OR REPLACE PROCEDURE GKDW.gk_new_course_audit as
cursor c1 is
select c.evxcourseid||chr(9)||c.coursecode||chr(9)||c.coursename||chr(9)||to_char(c.createdate,'mm/dd/yyyy')||chr(9)||
       c.coursenumber||chr(9)||coursecategory||chr(9)||mfg||chr(9)||coursegroup||chr(9)||min(e.start_date) c_line
from slxdw.evxcourse c
     inner join event_dim e on e.course_id = c.evxcourseid and e.status != 'Cancelled' and e.start_date >= trunc(sysdate)-90
where inactivedate is null
and not exists (select 1 from mtl_system_items_b@r12prd m
                   where c.coursecode = m.attribute1
                   and invoiceable_item_flag = 'Y')
group by c.evxcourseid||chr(9)||c.coursecode||chr(9)||c.coursename||chr(9)||to_char(c.createdate,'mm/dd/yyyy')||chr(9)||
         c.coursenumber||chr(9)||coursecategory||chr(9)||mfg,coursegroup
order by min(e.start_date);
cursor c2 is
select segment2||'.'||segment1||'.'||segment3||'.'||segment4||'.'||segment5||chr(9)||
       to_char(creation_date,'mm/dd/yy')||chr(9)||organization_id||chr(9)||inventory_item_status_code c_line
 from mtl_system_items_b@r12prd
 where invoiceable_item_flag = 'Y'
and inventory_item_status_code = 'NEW'
and enabled_flag = 'Y';
cursor c3 is
select segment2||'.'||segment1||'.'||segment3||'.'||segment4||'.'||segment5||chr(9)||
       to_char(creation_date,'mm/dd/yy')||chr(9)||organization_id||chr(9)||inventory_item_status_code c_line
 from mtl_system_items_b@r12prd
 where purchasing_item_flag = 'Y'
and inventory_item_status_code = 'NEW'
and enabled_flag = 'Y';
cursor c4 is
select p.productid||chr(9)||actualid||chr(9)||p.product_name||chr(9)||
       to_char(createdate,'mm/dd/yyyy')||chr(9)||p.productgroup c_line
  from slxdw.product p
where status = 'Available'
and not exists (select 1 from mtl_system_items_b@r12prd m
                 where p.actualid = m.attribute1
				   and invoiceable_item_flag = 'Y')
and exists (select 1 from slxdw.evxsodetail e
                     inner join slxdw.evxso s on e.evxsoid = s.evxsoid
            where e.productid = p.productid
			and e.createdate >= to_date('1/1/2006','mm/dd/yyyy'))
and actualid not like '%PACK%'
and substr(actualid,1,1) between '0' and '9'
and substr(actualid,2,1) between '0' and '9'
order by p.createdate,p.actualid;
v_file_name varchar2(50);
v_file_full_1 varchar2(250);
v_file_full_2 varchar2(250);
v_file_full_3 varchar2(250);
v_file_full_4 varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_mail_hdr varchar2(500) := 'SLX Course Audit Files';
v_error number;
v_error_msg varchar2(500);
begin
v_file_name := 'NewSLXCoursesNotInOracle.xls';
v_file_full_1 := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
select 'Course ID'||chr(9)||'Course'||chr(9)||'Course Name'||chr(9)||'Created'||chr(9)||'SLX Course Num'||chr(9)||
       'Category'||chr(9)||'MFG'||chr(9)||'Group'||chr(9)||'Min Start Date'
  into v_hdr
  from dual;
utl_file.put_line(v_file,v_hdr);
for r1 in c1 loop
  utl_file.put_line(v_file,r1.c_line);
end loop;
utl_file.fclose(v_file);
v_file_name := 'NewOracleInvoiceItems.xls';
v_file_full_2 := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
select 'Item Number'||chr(9)||'Created'||chr(9)||'Org ID'||chr(9)||'Status'
  into v_hdr
  from dual;
utl_file.put_line(v_file,v_hdr);
for r2 in c2 loop
  utl_file.put_line(v_file,r2.c_line);
end loop;
utl_file.fclose(v_file);
v_file_name := 'NewOraclePurchaseItems.xls';
v_file_full_3 := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
select 'Item Number'||chr(9)||'Created'||chr(9)||'Org ID'||chr(9)||'Status'
  into v_hdr
  from dual;
utl_file.put_line(v_file,v_hdr);
for r3 in c3 loop
  utl_file.put_line(v_file,r3.c_line);
end loop;
utl_file.fclose(v_file);
v_file_name := 'NewSLXProductsNotInOracle.xls';
v_file_full_4 := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
select 'Product ID'||chr(9)||'Product Num'||chr(9)||'Product Name'||chr(9)||'Created'||chr(9)||'Group'
  into v_hdr
  from dual;
utl_file.put_line(v_file,v_hdr);
for r4 in c4 loop
  utl_file.put_line(v_file,r4.c_line);
end loop;
utl_file.fclose(v_file);
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'christy.murdock@globalknowledge.com',
                CcRecipient => 'sheila.jacobs@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'SLX New Course Audit File',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_1,v_file_full_2,v_file_full_3,v_file_full_4));
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'chris.barefoot@globalknowledge.com',
                CcRecipient => 'greg.rogers@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'SLX New Course Audit File',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_1,v_file_full_2,v_file_full_3,v_file_full_4));
end;
/


