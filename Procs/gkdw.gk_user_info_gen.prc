DROP PROCEDURE GKDW.GK_USER_INFO_GEN;

CREATE OR REPLACE PROCEDURE GKDW.gk_user_info_gen(p_date date default null) as
cursor c1(pp_date date) is
  select chr(9)||'<person recstatus="2" isinternal="false">'||chr(10)||
       chr(9)||chr(9)||'<sitename>gk_train</sitename>'||chr(10)||
       chr(9)||chr(9)||'<userid>'||c.cust_id||'</userid>'||chr(10)||
       chr(9)||chr(9)||'<nickname></nickname>'||chr(10)||
       chr(9)||chr(9)||'<email>'||
       case when email like '%,%' then substr(email,1,instr(email,',')-1)
            when email like '%;%' then substr(email,1,instr(email,';')-1)
            else trim(email)
       end||'</email>'||chr(10)||
       chr(9)||chr(9)||'<address1></address1>'||chr(10)||
       chr(9)||chr(9)||'<address2></address2>'||chr(10)||
       chr(9)||chr(9)||'<locality></locality>'||chr(10)||
       chr(9)||chr(9)||'<region></region>'||chr(10)||
       chr(9)||chr(9)||'<pcode></pcode>'||chr(10)||
       chr(9)||chr(9)||'<country></country>'||chr(10)||
       chr(9)||chr(9)||'<JobRole></JobRole>'||chr(10)||
       chr(9)||chr(9)||'<Account_Password>welcome</Account_Password>'||chr(10)||
       chr(9)||chr(9)||'<UserGroup>'||ip.course_code||'</UserGroup>'||chr(10)||
       chr(9)||chr(9)||'<StartDate>'||to_char(f.enroll_date,'YYYY-MM-DD HH24:MI:SS')||'.0'||'</StartDate>'||chr(10)||
       chr(9)||chr(9)||'<EndDate>'||to_char(ed.end_date+7,'YYYY-MM-DD')||'</EndDate>'||chr(10)||
       chr(9)||chr(9)||'<firstName>'||c.first_name||'</firstName>'||chr(10)||
       chr(9)||chr(9)||'<lastName>'||c.last_name||'</lastName>'||chr(10)||
       chr(9)||chr(9)||'<phoneNumber></phoneNumber>'||chr(10)||
       chr(9)||chr(9)||'<userOrg>'||ip.user_org||'</userOrg>'||chr(10)||
       chr(9)||chr(9)||'<managerUsername></managerUsername>'||chr(10)||
       chr(9)||chr(9)||'<externalId>'||c.cust_id||'</externalId>'||chr(10)||
       chr(9)||chr(9)||'<externalSrc>SalesLogix</externalSrc>'||chr(10)||
       chr(9)||chr(9)||'<allowUpdate>N</allowUpdate>'||chr(10)||
       chr(9)||chr(9)||'<passwordChallenge></passwordChallenge>'||chr(10)||
       chr(9)||chr(9)||'<passwordResponse></passwordResponse>'||chr(10)||
       chr(9)||chr(9)||'<extraInfo></extraInfo>'||chr(10)||
       chr(9)||chr(9)||'<CusAttr name="Saleslogix_Student_ID" value="'||c.cust_id||'"/>'||chr(10)||
--       chr(9)||chr(9)||'<CusAttr name="CCNA_Course_Code" value="'||ip.course_code||'"/>'||chr(10)||
       chr(9)||chr(9)||'<CusAttr name="Bootcamp_Class_Start_Date" value="'||to_char(ed.start_date,'YYYY-MM-DD')||'"/>'||chr(10)||
       chr(9)||chr(9)||'<CusAttr name="Company" value="'||replace(c.acct_name,'&','')||'"/>'||chr(10)||
      chr(9)||'</person>'  v_xml_line
  from event_dim ed
       inner join lms_import_param ip on ed.course_code = ip.course_code and ip.user_group in ('CCNA Bootcamp','CUCMBC Bootcamp','CISCO Spel Web','7203S')
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id
 where trunc(f.enroll_date) = pp_date
   and f.enroll_status = 'Confirmed'
   and f.fee_type not in ('Ons - Base','Ons-Additional')
union all
select chr(9)||'<person recstatus="2" isinternal="false">'||chr(10)||
       chr(9)||chr(9)||'<sitename>gk_train</sitename>'||chr(10)||
       chr(9)||chr(9)||'<userid>'||c.cust_id||'</userid>'||chr(10)||
       chr(9)||chr(9)||'<nickname></nickname>'||chr(10)||
       chr(9)||chr(9)||'<email>'||
       case when email like '%,%' then substr(c.email,1,instr(c.email,',')-1)
            when email like '%;%' then substr(c.email,1,instr(c.email,';')-1)
            else trim(c.email)
       end||'</email>'||chr(10)||
       chr(9)||chr(9)||'<address1></address1>'||chr(10)||
       chr(9)||chr(9)||'<address2></address2>'||chr(10)||
       chr(9)||chr(9)||'<locality></locality>'||chr(10)||
       chr(9)||chr(9)||'<region></region>'||chr(10)||
       chr(9)||chr(9)||'<pcode></pcode>'||chr(10)||
       chr(9)||chr(9)||'<country></country>'||chr(10)||
       chr(9)||chr(9)||'<JobRole></JobRole>'||chr(10)||
       chr(9)||chr(9)||'<Account_Password>welcome</Account_Password>'||chr(10)||
       chr(9)||chr(9)||'<UserGroup>'||ip.course_code||'</UserGroup>'||chr(10)||
       chr(9)||chr(9)||'<StartDate>'||to_char(max(trunc(s.creation_date)),'YYYY-MM-DD HH24:MI:SS')||'.0'||'</StartDate>'||chr(10)||
       chr(9)||chr(9)||'<EndDate>'||to_char(max(trunc(s.creation_date))+30,'YYYY-MM-DD')||'</EndDate>'||chr(10)||
       chr(9)||chr(9)||'<firstName>'||c.first_name||'</firstName>'||chr(10)||
       chr(9)||chr(9)||'<lastName>'||c.last_name||'</lastName>'||chr(10)||
       chr(9)||chr(9)||'<phoneNumber></phoneNumber>'||chr(10)||
       chr(9)||chr(9)||'<userOrg>'||ip.user_org||'</userOrg>'||chr(10)||
       chr(9)||chr(9)||'<managerUsername></managerUsername>'||chr(10)||
       chr(9)||chr(9)||'<externalId>'||c.cust_id||'</externalId>'||chr(10)||
       chr(9)||chr(9)||'<externalSrc>SalesLogix</externalSrc>'||chr(10)||
       chr(9)||chr(9)||'<allowUpdate>N</allowUpdate>'||chr(10)||
       chr(9)||chr(9)||'<passwordChallenge></passwordChallenge>'||chr(10)||
       chr(9)||chr(9)||'<passwordResponse></passwordResponse>'||chr(10)||
       chr(9)||chr(9)||'<extraInfo></extraInfo>'||chr(10)||
       chr(9)||chr(9)||'<CusAttr name="Saleslogix_Student_ID" value="'||c.cust_id||'"/>'||chr(10)||
       chr(9)||chr(9)||'<CusAttr name="Company" value="'||replace(c.acct_name,'&','')||'"/>'||chr(10)||
       chr(9)||'</person>'  v_xml_line
  from sales_order_fact s
       inner join lms_import_param ip on s.prod_num = ip.course_code and ip.user_group = 'CISCO SPEL'
       inner join cust_dim c on s.cust_id = c.cust_id
 where nvl(s.so_status,'1') != 'Cancelled'
   and trunc(s.creation_date) = pp_date
 group by c.cust_id,c.email,ip.course_code,c.first_name,c.last_name,ip.user_org,c.cust_id,c.acct_name;
xml_file utl_file.file_type;
xml_file_name varchar2(100);
xml_file_name_full varchar2(250);
v_xml_hdr varchar2(250);
v_error number;
v_error_msg varchar2(500);
r1 c1%rowtype;
v_date date;
begin
if p_date is null then
  v_date := trunc(sysdate)-1;
else
  v_date := p_date;
end if;
open c1(v_date); fetch c1 into r1;
if c1%found then
  close c1;
  select 'user_info.xml','/usr/tmp/user_info.xml'
      into xml_file_name,xml_file_name_full
      from dual;
  xml_file := utl_file.fopen('/usr/tmp',xml_file_name,'w');
  select '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
         '<users>'||chr(10)
    into v_xml_hdr
    from dual;
  utl_file.put_line(xml_file,v_xml_hdr);
  for r1 in c1(v_date) loop
    utl_file.put_line(xml_file,r1.v_xml_line);
  end loop;
  select '</users>'||chr(10)
    into v_xml_hdr
    from dual;
  utl_file.put_line(xml_file,v_xml_hdr);
  utl_file.fclose(xml_file);
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'DW.Automation@globalknowledge.com',
            Recipient => 'alan.frelich@globalknowledge.com',
            CcRecipient => '',
            BccRecipient => '',
            Subject   => 'User XML',
            Body => 'User XML',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));
end if;
end;
/


