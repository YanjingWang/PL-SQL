DROP PROCEDURE GKDW.GK_SLX_REFRESH_MV_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_slx_refresh_mv_proc
AS
   --=======================================================================
   -- Author Name:Sruthi Reddy
   -- Create date: 06/20/2017
   -- Description:Master stored procedure to refresh all the materialized view

   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      06/20/2017  Sruthi Reddy       Initial Version
   --========================================================================
   v_msg_body   LONG := NULL;
   v_count      NUMBER;
BEGIN
   v_msg_body :=
      '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
   v_msg_body :=
         v_msg_body
      || '<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
   v_msg_body :=
         v_msg_body
      || '<tr><td align=left>GK_SLX_REFRESH_MV_PROC Start Time: '
      || TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
      || '</td></tr>';
   v_msg_body :=
         v_msg_body
      || '<tr><td align=left>*********************************************************************************************</td></tr>';

 --  rms_link_set_proc;

   --dbms_output.put_line('Proc Start Time: '||to_char(sysdate,'hh24:mi:ss'));
   v_count := 10;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_portal_evxevticket_mv');
   DBMS_OUTPUT.put_line ('gk_portal_evxevticket_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 20;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_portal_evxenrollhx_mv');
   DBMS_OUTPUT.put_line ('gk_portal_evxenrollhx_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 20;
   DBMS_SNAPSHOT.REFRESH ('gkdw.FP_MASTER29_V');
   DBMS_OUTPUT.put_line ('FP_MASTER29_V complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      v_msg_body :=
            v_msg_body
         || '<tr><td align=left>'
         || 'Error located at: '
         || v_count
         || '</td></tr>';
      v_msg_body :=
         v_msg_body || '<tr><td align=left>' || SQLERRM || '</td></tr>';
      v_msg_body := v_msg_body || '</table></body></html>';
      send_mail ('DW.Automation@globalknowledge.com',
                 'DW.Automation@globalknowledge.com',
                 'gk_slx_refresh_mv_proc FAILED',
                 v_msg_body);
END;
/


