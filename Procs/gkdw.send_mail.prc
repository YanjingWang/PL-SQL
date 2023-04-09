DROP PROCEDURE GKDW.SEND_MAIL;

CREATE OR REPLACE PROCEDURE GKDW.send_mail (sender varchar2,
                                       recip varchar2,
                                       subject varchar2,
                                       message long) as

--mailhost varchar2(50) := 'corpmail.globalknowledge.com';
mailhost varchar2(50) ;--:= 'smtp.globalknowledge.com';
mail_conn utl_smtp.connection;
v_crlf varchar2(2) := CHR( 13 ) || CHR( 10 );
v_subj varchar2(250) := 'Subject: '|| subject ||v_crlf;
v_hdr varchar2(2000);
email_flag varchar2(1) := 'Y';
curr_email varchar2(2000);
email_str varchar2(2000);

begin
  email_str := replace(replace(recip,' '),',',';');
  
 select mailserver into  mailhost  from Mailserver_tbl where end_date is null;--Changed by SBaral 
   

  v_hdr := 'MIME-Version: 1.0'||CHR(13)||CHR(10)||'Content-type: text/html'||CHR(13)||CHR(10) || v_subj;

  while email_flag = 'Y' loop
    if instr(email_str,';') > 0 then
      curr_email := substr(email_str,1,instr(email_str,';')-1);
      email_str := substr(email_str,instr(email_str,';')+1);

      mail_conn := utl_smtp.open_connection(mailhost,25);
      utl_smtp.helo(mail_conn,mailhost);

--      utl_smtp.command( mail_conn, 'AUTH LOGIN'); 
--      utl_smtp.command( mail_conn, 'c3Fsc2VydmljZQ=='); 
--      utl_smtp.command( mail_conn, 'R29QaXI4cw==' ); 
      
      utl_smtp.mail(mail_conn,sender);
      utl_smtp.rcpt(mail_conn,curr_email);
      utl_smtp.open_data(mail_conn);
      utl_smtp.write_data (mail_conn,'FROM: '||sender||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,'TO: '||curr_email||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,v_hdr||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,message||utl_tcp.crlf);
      utl_smtp.close_data(mail_conn);
      utl_smtp.quit(mail_conn);
    else
      mail_conn := utl_smtp.open_connection(mailhost,25);
      utl_smtp.helo(mail_conn,mailhost);
      
--      utl_smtp.command( mail_conn, 'AUTH LOGIN'); 
--      utl_smtp.command( mail_conn, 'c3Fsc2VydmljZQ=='); 
--      utl_smtp.command( mail_conn, 'R29QaXI4cw==' ); 
      
      utl_smtp.mail(mail_conn,sender);
      utl_smtp.rcpt(mail_conn,email_str);
      utl_smtp.open_data(mail_conn);
      utl_smtp.write_data (mail_conn,'FROM: '||sender||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,'TO: '||email_str||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,v_hdr||utl_tcp.crlf);
      utl_smtp.write_data (mail_conn,message||utl_tcp.crlf);
      utl_smtp.close_data(mail_conn);
      utl_smtp.quit(mail_conn);
      email_flag := 'N';
    end if;
  end loop;
  
EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
     utl_smtp.quit(mail_conn);
  
end;
/


GRANT EXECUTE ON GKDW.SEND_MAIL TO RMSDW;

GRANT EXECUTE ON GKDW.SEND_MAIL TO SLXDW;

