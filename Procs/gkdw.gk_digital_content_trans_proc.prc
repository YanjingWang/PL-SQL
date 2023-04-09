DROP PROCEDURE GKDW.GK_DIGITAL_CONTENT_TRANS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_digital_content_trans_proc as

cursor c1 is
select distinct c.email,c.cust_id,c.first_name,c.last_name,cd.course_pl,
       h.hvxuserid
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id
       left outer join hvxuser@gkhub h on c.cust_id = h.contactid
 where ed.start_date > trunc(sysdate)
   and f.enroll_status = 'Confirmed'
   and c.email is not null
   and cd.ch_num = '10'
   and cd.md_num in ('10','20')
   and substr(cd.course_code,1,4) in ('5976','5691','1085','5198','5764','5776','5559','5560','5324','5558','5563','5561','5562','5323',
                                      '5805','5330','5335','5340','5374','5372','5375','5373','5358','5377','5590','5589','5591','0917',
                                      '0554','5326','5362','5363','5376','2165','1632')
   and not exists (select 1 from mygk_event_conf_exclude mc where ed.event_id = mc.event_id)
   and not exists (select 1 from gk_channel_partner_conf p where f.keycode = p.channel_keycode)
   and not exists (select 1 from gk_digital_trans_email t where c.cust_id = t.contactid and cd.course_pl = t.trans_pl);

v_msg_body long;

begin

for r1 in c1 loop
  v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 10pt;font-family:verdana" width=300>';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/Header_LOGO.jpg" alt="Global Knowledge IT Training" border=0></td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/FOOTER.jpg" border=0></td></tr>';
  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=2 align=left><font color="CE9900" size=4>Course Notification</font></th></tr>';
  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';

  v_msg_body := v_msg_body||'<tr align=left><td colspan=2>Global Knowledge is pleased to announce that your Cisco courseware is now provided digitally. With digital courseware, you gain access to features that make learning easier including:</td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><ul>';
  v_msg_body := v_msg_body||'<li>Advanced search functions.</li>';
  v_msg_body := v_msg_body||'<li>Automatic content updates.</li>';
  v_msg_body := v_msg_body||'<li>Highlighting text and making notes.</li>';
  v_msg_body := v_msg_body||'<li>Creating bookmarks.</li>';
  v_msg_body := v_msg_body||'<li>Review your courseware anytime, anywhere.</li>';
  v_msg_body := v_msg_body||'<li>Lifetime access to your courseware.</li></ul></td></tr>';

  v_msg_body := v_msg_body||'<tr align=left><td colspan=2>For an optimal course experience, we suggest you provide your own reader device (laptop or tablet) to access the digital training materials. Printed materials will not be provided.</td></tr>';

  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left><b>Prior to the first day of class, </b>create your Cisco Connection Online (CCO) account to access your digital courseware. Directions are provided inside MyGK under your course Training Materials.</td></tr>';

  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
  
  if r1.hvxuserid is null then
    v_msg_body := v_msg_body||'<tr><th colspan=2><font size=4><a href="https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||r1.cust_id||'"><font color="#1776D5">Prepare Now</font></a></font></th></tr>';
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=center><font size=1><b>Copy/paste link: </b>https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||r1.cust_id||'</font></td></tr>';
  else
    v_msg_body := v_msg_body||'<tr><th colspan=2><font size=4><a href="https://mygk.globalknowledge.com"><font color="#1776D5">Prepare Now</font></a></font></th></tr>';
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=center><font size=1><b>Copy/paste link: </b>https://mygk.globalknowledge.com</font></td></tr>';
  end if;

  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>Your training partner,<br>Global Knowledge</td></tr><tr><td colspan=2 align=left>&nbsp</td></tr>';

  v_msg_body := v_msg_body||'</body></html>';

  insert into gk_digital_trans_email
  select r1.cust_id,r1.email,sysdate,r1.course_pl 
    from dual;
  commit;

  send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.email,'Global Knowledge and Cisco Digital Content',v_msg_body);

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_digital_content_trans_proc Failed',SQLERRM);
    
end;
/


