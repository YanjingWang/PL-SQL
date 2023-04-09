DROP PROCEDURE GKDW.GK_REFRESH_COURSE_SCHED_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_refresh_course_sched_proc
AS
   --=======================================================================
   -- Author Name:Sruthi Reddy
   -- Create date: 10/30/2016
   -- Description:Master stored procedure to refresh all the course schedule  
   --             materialized view which will be used by PRIVATE_EVENT_AVAILABILITY

   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      10/30/2016  Sruthi Reddy      Initial Version
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
      || '<tr><td align=left>GK_REFRESH_COURSE_SCHED_PROC Start Time: '
      || TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
      || '</td></tr>';
   v_msg_body :=
         v_msg_body
      || '<tr><td align=left>*********************************************************************************************</td></tr>';

   rms_link_set_proc;
   
   v_count := 10;
   DBMS_SNAPSHOT.REFRESH ('gkdw.INSTRUCTOR_COURSE_LOOKUP_MV');
   DBMS_OUTPUT.put_line ('INSTRUCTOR_COURSE_LOOKUP_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 20;
   DBMS_SNAPSHOT.REFRESH ('gkdw.INSTRUCTOR_COURSE_SCHED_MV');
   DBMS_OUTPUT.put_line ('INSTRUCTOR_COURSE_SCHED_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 30;
   DBMS_SNAPSHOT.REFRESH ('gkdw.LAB_COURSE_LOOKUP_MV');
   DBMS_OUTPUT.put_line ('LAB_COURSE_LOOKUP_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 40;
   DBMS_SNAPSHOT.REFRESH ('gkdw.LAB_COURSE_SCHED_TOTAL_MV');
   DBMS_OUTPUT.put_line ('LAB_COURSE_SCHED_TOTAL_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   
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
                 'GK_REFRESH_COURSE_SCHED_PROC FAILED',
                 v_msg_body);
END;
/


