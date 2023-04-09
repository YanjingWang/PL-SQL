DROP PROCEDURE GKDW.SEND_MAIL_ATTACH_SB;

CREATE OR REPLACE PROCEDURE GKDW.send_mail_attach_sb(
p_sender varchar2,
p_recip varchar2,
p_cc_recip varchar2,
p_bcc_recip varchar2,
p_subject varchar2,
p_body varchar2,
p_file_name varchar2
)
as

v_error number;
v_error_msg varchar2(500);

begin

v_error := sb_SendMailJPkg.SendMail(
           SMTPServerName => 'corpmail.globalknowledge.com',
           Sender    => p_sender,
           Recipient => p_recip,
           CcRecipient => p_cc_recip,
           BccRecipient => p_bcc_recip,
           Subject   => p_subject,
           Body => p_body,
           ErrorMessage => v_error_msg,
           Attachments  => sb_SendMailJPkg.ATTACHMENTS_LIST(p_file_name));

exception
  when others then
    send_mail_sb('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','SEND_MAIL_ATTACH ERROR',p_recip);

end;
/


