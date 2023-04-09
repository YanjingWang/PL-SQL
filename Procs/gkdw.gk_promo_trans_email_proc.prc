DROP PROCEDURE GKDW.GK_PROMO_TRANS_EMAIL_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_promo_trans_email_proc as

cursor c1 is
select p.evxevenrollid,p.event_id,p.cust_id,initcap(p.first_name) firstname,initcap(p.last_name) lastname,p.cust_dim_email,p.keycode,pp.promoname,ed.end_date,
       ed.end_date+90-trunc(sysdate) days_to_expire,h.hvxuserid,
       gk_conf_hdr_func() conf_hdr,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="#CE9900" size=5>Completing Your Promo Just Got Easier.</font></th></tr>' trans_hdr,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>Finalizing your qualification process and providing delivery details for your Global Knowledge '||pp.promoname||' promotion now lives in MyGK! On the last day of class, you can now complete, manage and view the status of your current and past promos.</td></tr>' trans_para1,
       '<tr><td colspan=2 align=left><b>You have '||to_char(ed.end_date+90-trunc(sysdate))||' days to complete the steps in MyGK that are required to confirm your participation and claim your '||pp.promoname||' promo.</b></td></tr>' trans_para2,
       '<tr><td colspan=2 align=left>Click the link below to visit MyGK and view your promos. Once you'||chr(39)||'re logged in, select the Promo tile on the home page of MyGK.</td></tr>' trans_para3,
       case when h.hvxuserid is null then '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2><font size=5><font color="#1776D5"><a href=https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||p.cust_id||'>Access Your Promo in MyGK</a></font></font></th></tr>' 
            else '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2><font size=5><font color="#1776D5"><a href=https://mygk.globalknowledge.com>Access Your Promo in MyGK</a></font></font></th></tr>' 
       end mygk_hdr,
       case when h.hvxuserid is null then '<tr><td colspan=2 align=center><b>Copy/paste link: </b>https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||p.cust_id||'</td></tr>' 
            else '<tr><td colspan=2 align=center><b>Copy/paste link: </b>https://mygk.globalknowledge.com</td></tr>'
       end mygk_link,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>If you have not activated your MyGK account, you will be prompted to complete the activation process (about a 10-minute process). If you have an activated account, use your MyGK credentials to access the home page.</td></tr>' trans_para4,
       gk_conf_cust_serv_func(p.event_id,'NONE') cust_serv,
       gk_conf_tech_asst_func(p.event_id,'NONE') quest_tech_asst
  from gk_promo_audit_v p,
       pvxpromo@gkhub pp, 
       event_dim ed,
       hvxuser@gkhub h
 where p.keycode = pp.keycode
   and p.event_id = ed.event_id
   and p.cust_id = h.contactid (+)
   and tile_response is null
   and expiration_date is null
   and fulfilled_status is null
   and cust_dim_email is not null
   and (ed.end_date+90-trunc(sysdate)) in (60,30,15,5);

v_msg_body long;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop

/******* PROMO TO MYGK TRANSITION EMAIL ********/
  v_msg_body := r1.conf_hdr;
  v_msg_body := v_msg_body||r1.trans_hdr;
  v_msg_body := v_msg_body||r1.trans_para1;
  v_msg_body := v_msg_body||r1.trans_para2;
  v_msg_body := v_msg_body||r1.trans_para3;
  v_msg_body := v_msg_body||r1.mygk_hdr;
  v_msg_body := v_msg_body||r1.mygk_link;
  v_msg_body := v_msg_body||r1.trans_para4;
  v_msg_body := v_msg_body||r1.cust_serv;
  v_msg_body := v_msg_body||r1.quest_tech_asst;
  v_msg_body := v_msg_body||v_html_end;  
  
  send_mail('ipadpromo@globalknowledge.com',r1.cust_dim_email,'Important information about your Global Knowledge training purchase',v_msg_body);

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_PROMO_TRANS_EMAIL_PROC Failed',SQLERRM);

end;
/


