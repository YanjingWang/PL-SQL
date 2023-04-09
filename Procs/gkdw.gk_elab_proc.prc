DROP PROCEDURE GKDW.GK_ELAB_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_elab_proc(vtest varchar2 default 'N') as
cursor c3 is /*** E-Lab E-Mail to Students ***/
  select distinct f.cust_id,c.cust_name,f.enroll_id,
         case when c.email like '%,%' then substr(c.email,1,instr(c.email,',')-1)
              when c.email like '%;%' then substr(c.email,1,instr(c.email,';')-1)
              else c.email
         end email,
         ec.elab_credits,
         ec.exp_days lab_days,
         'post-course e-Lab access' access_type,
         'after the last day of your class' access_start
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join gk_elab_courses ec on cd.course_code = ec.course_code and ec.active_flag = 'Y'
         inner join order_fact f on ed.event_id = f.event_id
         inner join cust_dim c on f.cust_id = c.cust_id
   where ed.status != 'Cancelled'
     and f.enroll_status != 'Cancelled'
     and trunc(ed.start_date) = trunc(sysdate-1)
     and ec.course_mod != 'SPeL WEB'
     and c.email is not null;

v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
begin
for r3 in c3 loop
  v_msg_body := '<html><head></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr align="left"><th>Thank you for choosing Global Knowledge as your training provider.</th></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>We are pleased to offer '||r3.access_type||', providing the opportunity for you to work with the same great hardware that is available in the classroom from the convenience of your home or office. An e-Lab account has been allocated to you including <b>'||r3.elab_credits||' E-Lab credits</b>. Each e-Lab credit gives you one hour of lab time, and the credits expire '||r3.lab_days||' days '||r3.access_start||'.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Ready to Get Started?</th></tr>';
  v_msg_body := v_msg_body||'<tr><td>To access your account, you will need the following information:<p>ID: '||r3.cust_id||'<br>Password: welcome<br>E-Lab Credits: '||r3.elab_credits||'</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Pre-Lab Connectivity Test</th></tr>';
  v_msg_body := v_msg_body||'<tr><td>Before taking an e-Lab, we recommend that you test your connectivity using the Firewall Wizard at <a href=https://www.remotelabs.com>https://www.remotelabs.com</a>. Simply click on the Firewall Wizard and follow the instructions provided.<p>If your system does not pass any of the port connectivity tests and the labs you are taking require those ports, you will need to request permission from your IT group to open the necessary ports, or you can take the labs from another location.<p>If you have technical questions, feel free to consult our technical support group for assistance at TechSupport@globalknowledge.com or 866-825-8555.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Taking Your e-Lab(s)</th></tr>';
  v_msg_body := v_msg_body||'<tr><td>Once you have passed the connectivity test:</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>1. Login to Global Knowledge Self-Paced e-Learning at <a href=https://www.remotelabs.com>https://www.remotelabs.com</a> using your ID and password listed above.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>2. From the default home page, choose "View and Choose Lab Documents".</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>3. A window titled "Available Labs" will appear, displaying a number of e-Labs. Read the lab descriptions and decide which lab(s) you would like to take. <b>NOTE:</b><i> Do not select an e-Lab until you are sure you want to take it. Once you have selected the lab, you have used a credit on it, and you may not use the credit for another lab.</i></td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>4. Click to select the e-Lab(s) you would like to take. The chosen lab(s) will now appear in your Available Labs list. When you are finished selecting your e-Lab(s), close the Available Labs window by clicking the X at the top right corner of the window.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>5. From the Available Labs page, select a lab to view the associated lab description document. This will enable you to familiarize yourself with the lab objectives and steps.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>6. You can take the e-Lab now (depending on pod availability), or schedule the lab for a future time.<p>&nbsp&nbsp&nbspTo take the lab now, choose <b>Lab Session</b>.<p>&nbsp&nbsp&nbspTo take it later, choose <b>Schedule</b>. Note that lab times are listed in Eastern Standard Time.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>7. <b>IMPORTANT FOR CISCO SECURITY LABS CUSTOMERS:</b><br>Please click on the link "Using the Lab" to be taken to a tutorial that describes the process for accessing the Global Knowledge Remote Lab Environment.  The Global Knowledge Remote Lab Environment provides you with access to several PC system desktops and the console ports of the network devices that you will use in this course.</td></tr>';
  v_msg_body := v_msg_body||'<tr><td>&nbsp</td></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>We hope you enjoy your Global Knowledge e-Lab experience!</th></tr>';
  v_msg_body := v_msg_body||'</table></html>';
  if vtest = 'N' then
    send_mail('TechSupport@globalknowledge.com',r3.email,'Global Knowledge E-Labs Introduction',v_msg_body);
  else
    send_mail('TechSupport@globalknowledge.com','DW.Automation@globalknowledge.com','Global Knowledge E-Labs Introduction',v_msg_body);
  end if;
end loop;

exception
  when others then
    send_mail('ciscolabs.us@globalknowledge.com','DW.Automation@globalknowledge.com','Cisco Prework Procedure Failed',SQLERRM);
end;
/


