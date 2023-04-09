DROP PROCEDURE GKDW.GK_CUST_PREPAY_REPORT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_cust_prepay_report_proc(p_accountid varchar2 default null,p_test varchar2 default 'N') is

cursor c0 is
  select ep.cardtype,t.region,t.salesrep,t.region_mgr,c.accountid,c.account,
         nvl(ec.new_contactid,c.contactid) contactid,
         nvl(ec.new_contact,c.firstname||' '||c.lastname) contact_name,
         case when ec.new_email is not null then ec.new_email
              when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1)
              when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1)
              else c.email
         end contact_email,
         verify_email(case when ec.new_email is not null then ec.new_email
              when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1)
              when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1)
              else c.email
         end) verify_email_val,
         ec.add_email,ep.evxppcardid,ep.cardshortcode,ep.expiresondate,
         to_char(valuepurchasedbase,'$999,990.00') valuepurchasedtotal,
         to_char(valueredeemedbase,'$999,990.00') valueredeemedtotal,
         to_char(valuebalancebase,'$999,990.00') valuebalancetotal,
         eventpasscounttotal,eventpasscountredeemed,eventpasscountavailable,
         '<tr bgcolor="#FFFFFF"><th align=right>Company:</th><td>'||c.account||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Contact:</th><td>'||nvl(ec.new_contact,c.firstname||' '||c.lastname)||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Email:</th><td>'||case when ec.new_email is not null then ec.new_email when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1) when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1) else c.email end||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Contact us:</th><td>800-COURSES</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Prepay Card ID:</th><td>'||ep.evxppcardid||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Expires:</th><td>'||ep.expiresondate||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Value Card Total:</th><td>'||to_char(valuepurchasedbase,'$999,990.00')||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Redeemed Amount:</th><td>'||to_char(valueredeemedbase,'$999,990.00')||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Available Balance:</th><td>'||to_char(valuebalancebase,'$999,990.00')||'</td></tr>' v_table_rows
    from slxdw.evxppcard ep
         inner join slxdw.evxso es on ep.evxsoid = es.evxsoid
         inner join slxdw.contact c on ep.issuedtocontactid = c.contactid
         inner join slxdw.address a on c.addressid = a.addressid
         inner join gk_territory t on a.postalcode between t.zip_start and t.zip_end and territory_type = 'OB'
         left outer join gk_cust_email_correction ec on ep.evxppcardid = ec.evxppcardid
   where cardtype = 'ValueCard'
     and cardstatus = 'Valid'
     and c.email is not null
     and c.email != 'IBMinfo.NAM@GlobalKnowledge.com'
     and (c.accountid = p_accountid or p_accountid is null)
     and ep.issueddate >= to_date('5/26/2007','mm/dd/yyyy')
     and nvl(ep.expiresondate,trunc(sysdate)+1) >= trunc(sysdate)
     and ep.evxtppcardid not in ('Q6UJ905362H1','Q6UJ905362GQ')
     and not exists (select 1 from gk_cust_prepay_report_exclude re where re.evxppcardid = ep.evxppcardid)
  union
    select ep.cardtype,t.region,t.salesrep,t.region_mgr,c.accountid,c.account,
         nvl(ec.new_contactid,c.contactid) contactid,
         nvl(ec.new_contact,c.firstname||' '||c.lastname) contact_name,
         case when ec.new_email is not null then ec.new_email
              when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1)
              when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1)
              else c.email
         end contact_email,
         verify_email(case when ec.new_email is not null then ec.new_email
              when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1)
              when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1)
              else c.email
         end) verify_email_val,
         ec.add_email,ep.evxppcardid,ep.cardshortcode,ep.expiresondate,
         to_char(valuepurchasedbase,'$999,990.00') valuepurchasedtotal,
         to_char(valueredeemedbase,'$999,990.00') valueredeemedtotal,
         to_char(valuebalancebase,'$999,990.00') valuebalancetotal,
         eventpasscounttotal,eventpasscountredeemed,eventpasscountavailable,
         '<tr bgcolor="#FFFFFF"><th align=right>Company:</th><td>'||c.account||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Contact:</th><td>'||nvl(ec.new_contact,c.firstname||' '||c.lastname)||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Email:</th><td>'||case when ec.new_email is not null then ec.new_email when instr(c.email,',') > 0 then substr(c.email,1,instr(c.email,',')-1) when instr(c.email,';') > 0 then substr(c.email,1,instr(c.email,';')-1) else c.email end||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Contact us:</th><td>800-COURSES</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Prepay Card ID:</th><td>'||ep.evxppcardid||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Expires:</th><td>'||ep.expiresondate||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Total Passes:</th><td>'||eventpasscounttotal||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Redeemed Passes:</th><td>'||eventpasscountredeemed||'</td></tr>'||
         '<tr bgcolor="#FFFFFF"><th align=right>Available Passes:</th><td>'||eventpasscountavailable||'</td></tr>' v_table_rows
    from slxdw.evxppcard ep
         inner join slxdw.evxso es on ep.evxsoid = es.evxsoid
         inner join slxdw.contact c on ep.issuedtocontactid = c.contactid
         inner join slxdw.address a on c.addressid = a.addressid
         inner join gk_territory t on a.postalcode between t.zip_start and t.zip_end and territory_type = 'OB'
         left outer join gk_cust_email_correction ec on ep.evxppcardid = ec.evxppcardid
   where cardtype = 'EventCard'
     and cardstatus = 'Valid'
     and eventpasscountavailable > 0
     and c.email is not null
     and c.email != 'IBMinfo.NAM@GlobalKnowledge.com'
     and (c.accountid = p_accountid or p_accountid is null)
     and ep.issueddate >= to_date('5/26/2007','mm/dd/yyyy')
     and nvl(ep.expiresondate,trunc(sysdate)+1) >= trunc(sysdate)
     and ep.evxtppcardid not in ('Q6UJ905362H1','Q6UJ905362GQ')
     and not exists (select 1 from gk_cust_prepay_report_exclude re where re.evxppcardid = ep.evxppcardid)
   order by region,cardtype,account,contact_name;
   
v_msg_body long;
v_rep_file_name varchar2(250);
v_rep_file_full varchar2(250);
v_rep_file utl_file.file_type;
v_error number;
v_error_msg varchar2(500);
v_hdr varchar2(250) := 'Region'||chr(9)||'Account'||chr(9)||'AccountID'||chr(9)||'Contact'||chr(9)||'ContactID'||chr(9)||'Contact E-mail'||chr(9)||'Prepay Card ID'||chr(9)||'Short Code'||chr(9)||'Total'||chr(9)||'Redeemed'||chr(9)||'Available'||chr(9)||'Expiration';
v_line varchar2(250);
v_curr_email varchar2(250);

begin
select 'PrepayReport_Summary.xls',
       '/usr/tmp/PrepayReport_Summary.xls'
  into v_rep_file_name,v_rep_file_full
  from dual;
v_rep_file := utl_file.fopen('/usr/tmp',v_rep_file_name,'w');
utl_file.put_line(v_rep_file,v_hdr);

for r0 in c0 loop
  v_curr_email := r0.contact_email;
  v_msg_body := '';
  v_msg_body := v_msg_body||'<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><td><img src="http://images.globalknowledge.com/wwwimages/gk_logo.gif" alt="Global Knowledge IT Training" width=165 height=90 border=0></td></tr>';
  v_msg_body := v_msg_body||'<tr><th>Prepay Account Summary:</th></tr>';
  v_msg_body := v_msg_body||'</table>';
  v_msg_body := v_msg_body||'<table cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana;background-color: #58595B;border-width: .5px;border-color: #58595B">';
  v_msg_body := v_msg_body||r0.v_table_rows;
  v_msg_body := v_msg_body||'</table><p>';
  v_msg_body := v_msg_body||'</body></html>';
  if r0.verify_email_val <> 252 then
    send_mail('Prepay.NAM@globalknowledge.com','DW.Automation@globalknowledge.com','Invalid Customer Email Address',r0.contact_email||'-'||r0.verify_email_val);
  elsif p_test = 'N' then
    send_mail('Prepay.NAM@globalknowledge.com',r0.contact_email,'Global Knowledge Prepay Summary Report',v_msg_body);
    if r0.add_email is not null then
      send_mail('Prepay.NAM@globalknowledge.com',r0.add_email,'Global Knowledge Prepay Summary Report',v_msg_body);
    end if;
  else
    send_mail('Prepay.NAM@globalknowledge.com','DW.Automation@globalknowledge.com','Global Knowledge Prepay Summary Report',v_msg_body);
  end if;
  if r0.cardtype = 'EventCard' then
    v_line := r0.region||chr(9)||r0.account||chr(9)||r0.accountid||chr(9)||r0.contact_name||chr(9)||r0.contactid||chr(9)||r0.contact_email||chr(9)||r0.evxppcardid||chr(9)||r0.cardshortcode||chr(9)||r0.eventpasscounttotal||chr(9)||r0.eventpasscountredeemed||chr(9)||r0.eventpasscountavailable||chr(9)||r0.expiresondate;
  else
    v_line := r0.region||chr(9)||r0.account||chr(9)||r0.accountid||chr(9)||r0.contact_name||chr(9)||r0.contactid||chr(9)||r0.contact_email||chr(9)||r0.evxppcardid||chr(9)||r0.cardshortcode||chr(9)||r0.valuepurchasedtotal||chr(9)||r0.valueredeemedtotal||chr(9)||r0.valuebalancetotal||chr(9)||r0.expiresondate;
  end if;
  utl_file.put_line(v_rep_file,v_line);
end loop;
utl_file.fclose(v_rep_file);
if p_test = 'N' then

  send_mail_attach('Prepay.NAM@globalknowledge.com','krissi.fields@globalknowledge.com',
                   'jeanette.ragland@globalknowledge.com','sruthi.reddy@globalknowledge.com','Global Knowledge Rep Prepay Card Summary Report',
                   'Open Attachment to View Summary Report',v_rep_file_full);
                   
else
  send_mail_attach('Prepay.NAM@globalknowledge.com','DW.Automation@globalknowledge.com',
                   null,null,'Global Knowledge Rep Prepay Card Summary Report',
                   'Open Attachment to View Summary Report',v_rep_file_full);
end if;
exception
  when others then
    utl_file.fclose(v_rep_file);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','Customer Prepay Failed - '||v_curr_email,SQLERRM);
end;
/


