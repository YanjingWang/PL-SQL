DROP PROCEDURE GKDW.SEND_ICAL_EMAIL;

CREATE OR REPLACE PROCEDURE GKDW.send_ical_email
( 
    p_from      IN VARCHAR2 
  , p_to        IN VARCHAR2 
  , p_subject   IN VARCHAR2 
  , p_body_html IN VARCHAR2 
  , p_body_ical IN VARCHAR2 
)
as
 
   l_connection UTL_SMTP.CONNECTION; 
   l_mail_serv  VARCHAR2(50);-- := 'corpmail.globalknowledge.com'; 
   l_mail_port  PLS_INTEGER := '25'; 
   l_lf         VARCHAR2(10) := utl_tcp.crlf; 
   l_msg_body   VARCHAR2(32767); 
  
begin

select mailserver into  l_mail_serv  from Mailserver_tbl where end_date is null;--Changed by SBaral 
 
  
    
   l_msg_body := 
         'Content-class: urn:content-classes:calendarmessage' || l_lf 
      || 'MIME-Version: 1.0' || l_lf 
      || 'Content-Type: multipart/alternative;' || l_lf 
      || '  boundary="----_=_NextPart"' || l_lf 
      || 'Subject: ' || p_subject || l_lf  
      || 'Date: ' || TO_CHAR(SYSDATE,'DAY, DD-MON-RR HH24:MI') || l_lf 
      || 'From: <' || p_from || '> ' || l_lf  
      || 'To: ' || p_to || l_lf  
--      || '------_=_NextPart' || l_lf 
--      || 'Content-Type: text/plain;' || l_lf 
--      || '  charset="iso-8859-1"' || l_lf 
--      || 'Content-Transfer-Encoding: quoted-printable' || l_lf 
--      || l_lf 
--      || 'You must have an HTML enabled client to view this message.' || l_lf 
--      || l_lf 
      || '------_=_NextPart' || l_lf 
      || 'Content-Type: text/html;' || l_lf 
--      || '  charset="iso-8859-1"' || l_lf 
--      || 'Content-Transfer-Encoding: quoted-printable' || l_lf 
      || l_lf 
      || p_body_html || l_lf 
      || l_lf 
      || '------_=_NextPart' || l_lf 
      || 'Content-class: urn:content-classes:calendarmessage' || l_lf 
      || 'Content-Type: text/calendar;'
      || '  method=REQUEST;'
      || '  name="meeting.ics"' || l_lf 
      || 'Content-Transfer-Encoding: 8bit' || l_lf 
      || l_lf 
      || p_body_ical || l_lf 
      || l_lf 
      || '------_=_NextPart--'; 
             
   l_connection := utl_smtp.open_connection(l_mail_serv, l_mail_port); 
   utl_smtp.helo(l_connection, l_mail_serv); 
   
  -- utl_smtp.command( l_connection, 'AUTH LOGIN'); 
  ---- utl_smtp.command( l_connection, 'c3Fsc2VydmljZQ=='); 
 --  utl_smtp.command( l_connection, 'R29QaXI4cw==' ); 
      
   utl_smtp.mail(l_connection, p_from); 
   utl_smtp.rcpt(l_connection, p_to); 
   utl_smtp.data(l_connection, l_msg_body); 
   utl_smtp.quit(l_connection); 
   
      EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
  
   utl_smtp.quit(l_connection);
      
end send_ical_email;
/


