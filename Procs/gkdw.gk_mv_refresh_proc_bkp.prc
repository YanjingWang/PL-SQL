DROP PROCEDURE GKDW.GK_MV_REFRESH_PROC_BKP;

CREATE OR REPLACE PROCEDURE GKDW.gk_mv_refresh_proc_bkp
AS
   --=======================================================================
   -- Author Name:Sruthi Reddy
   -- Create date: 06/15/2016
   -- Description:Master stored procedure to refresh all the materialized view

   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      06/20/2016  John Dellomo       Initial Version
   --  1.1      06/21/2016  Sruthi Reddy       Added v_count to identify error
   --                                          location in case of issue
   -- 1.2       07/18/2016  Sruthi Reddy       Added master_ent_oe_booking_mv and
   --                                          master_prepay_mv  
   -- 1.3       08/05/2016  Sruthi Reddy       Added GK_ACCOUNT_SEGMENTS_MV for 
   --                                          daily refresh
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
      || '<tr><td align=left>GK_MV_REFRESH_PROC Start Time: '
      || TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
      || '</td></tr>';
   v_msg_body :=
         v_msg_body
      || '<tr><td align=left>*********************************************************************************************</td></tr>';

   rms_link_set_proc;

   --dbms_output.put_line('Proc Start Time: '||to_char(sysdate,'hh24:mi:ss'));
   v_count := 5;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_course_rev_dates_mv');
   DBMS_OUTPUT.put_line ('gk_course_rev_dates_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 10;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_all_event_instr_mv');
   DBMS_OUTPUT.put_line ('gk_all_event_instr_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 20;
   DBMS_SNAPSHOT.REFRESH ('gkdw.rms_inst_usage_mv');
   DBMS_OUTPUT.put_line ('rms_inst_usage_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 25;
   DBMS_SNAPSHOT.REFRESH ('gkdw.GK_ORACLE_ACCT_NUM_MV');
   DBMS_OUTPUT.put_line ('GK_ORACLE_ACCT_NUM_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 30;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_inst_unavailable_mv');
   DBMS_OUTPUT.put_line ('gk_inst_unavailable_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 40;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_inst_util_teach_mv');
   DBMS_OUTPUT.put_line ('gk_inst_util_teach_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 50;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_facility_region_mv');
   DBMS_OUTPUT.put_line ('gk_facility_region_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 60;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_course_quotes_mv');
   DBMS_OUTPUT.put_line ('gk_course_quotes_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 70;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_order_balance_mv');
   DBMS_OUTPUT.put_line ('gk_order_balance_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 80;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_enterprise_pipeline_mv');
   DBMS_OUTPUT.put_line ('gk_enterprise_pipeline_mv complete: '|| TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 90;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_course_to_watch_mv');
   DBMS_OUTPUT.put_line ('gk_course_to_watch_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 100;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_product_kbi_mv');
   DBMS_OUTPUT.put_line ('gk_product_kbi_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 110;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_booking_cube_mv');
   DBMS_OUTPUT.put_line ('gk_booking_cube_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 120;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_inst_util_poss_mv');
   DBMS_OUTPUT.put_line ('gk_inst_util_poss_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 130;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_open_enrollment_mv');
   DBMS_OUTPUT.put_line ('gk_open_enrollment_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 140;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_onsite_bookings_mv');
   DBMS_OUTPUT.put_line ('gk_onsite_bookings_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 150;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_enroll_cancellation_mv');
   DBMS_OUTPUT.put_line ('gk_enroll_cancellation_mv complete: '|| TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 160;
   DBMS_SNAPSHOT.refresh ('gk_smart_course_mv');
   DBMS_OUTPUT.put_line ('gk_smart_course_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 170;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_instructor_info_v');
   DBMS_OUTPUT.put_line ('gkdw.gk_instructor_info_v complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 180;
   DBMS_SNAPSHOT.REFRESH ('gkdw.GK_TERILLIAN_EVENTS_MV');
   DBMS_OUTPUT.put_line ('gkdw.gk_terillian_events_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 190;
   DBMS_SNAPSHOT.REFRESH ('gkdw.RMS_EVENT_POD_MV');
   DBMS_OUTPUT.put_line ('gkdw.RMS_EVENT_POD_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 200;
   DBMS_SNAPSHOT.REFRESH ('gkdw.RMS_POD_LABS_MV');
   DBMS_OUTPUT.put_line ('gkdw.RMS_POD_LABS_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 210;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_course_director_fees_mv');
   DBMS_OUTPUT.put_line ('gkdw.gk_course_director_fees_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 220;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_cisco_dw_mv');
   DBMS_OUTPUT.put_line ('gkdw.gk_cisco_dw_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 230;
   DBMS_SNAPSHOT.REFRESH ('gkdw.GK_CDW_CURR_AUTH_MV');
   DBMS_OUTPUT.put_line ('gkdw.GK_CDW_CURR_AUTH_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 240;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_course_url_mv');
   DBMS_OUTPUT.put_line ('gkdw.gk_course_url_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 260;
   DBMS_SNAPSHOT.REFRESH ('gk_account_segment_lookup_mv');
   DBMS_OUTPUT.put_line ('gk_account_segment_lookup_mv complete: '|| TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 265;
   DBMS_SNAPSHOT.REFRESH ('GK_ACCOUNT_SEGMENTS_MV');
   DBMS_OUTPUT.put_line ('GK_ACCOUNT_SEGMENTS_MV complete: '|| TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 270;
   DBMS_SNAPSHOT.REFRESH ('GK_QUOTE_REPORT_MV');
   DBMS_OUTPUT.put_line ('GK_QUOTE_REPORT_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 280;
   DBMS_SNAPSHOT.REFRESH ('GK_SPEND_REPORT_MV');
   DBMS_OUTPUT.put_line ('GK_SPEND_REPORT_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 290;
   DBMS_SNAPSHOT.REFRESH ('GK_PREPAY_REPORT_MV');
   DBMS_OUTPUT.put_line ('GK_PREPAY_REPORT_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 300;
   DBMS_SNAPSHOT.REFRESH ('GK_SALES_ACTIVITY_MV');
   DBMS_OUTPUT.put_line ('GK_SALES_ACTIVITY_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 305;
   DBMS_SNAPSHOT.REFRESH ('gkdw.ENT_TRANS_BOOKINGS_MV');
   DBMS_OUTPUT.put_line ('gkdw.ENT_TRANS_BOOKINGS_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 310;
   DBMS_SNAPSHOT.REFRESH ('MASTER_ENT_BOOKINGS_MV');
   DBMS_OUTPUT.put_line ('MASTER_ENT_BOOKINGS_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 320;
   DBMS_SNAPSHOT.REFRESH ('MASTER_OE_BOOKINGS_MV');
   DBMS_OUTPUT.put_line ('MASTER_OE_BOOKINGS_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 325;
   DBMS_SNAPSHOT.REFRESH ('gkdw.master_ent_oe_booking_mv');
   DBMS_OUTPUT.put_line ('master_ent_oe_booking_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));v_count := 330;
   v_count := 328;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_daily_sales_bookings_mv');
   DBMS_OUTPUT.put_line ('gk_daily_sales_bookings_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 330;
   DBMS_SNAPSHOT.REFRESH ('MASTER_ACTIVITY_MV');
   DBMS_OUTPUT.put_line ('MASTER_ACTIVITY_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 340;
   DBMS_SNAPSHOT.REFRESH ('MASTER_QUOTE_MV');
   DBMS_OUTPUT.put_line ('MASTER_QUOTE_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 350;
   DBMS_SNAPSHOT.refresh ('instructor_course_lookup_mv');
   DBMS_OUTPUT.put_line ('instructor_course_lookup_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 360;
   DBMS_SNAPSHOT.refresh ('instructor_course_sched_mv');
   DBMS_OUTPUT.put_line ('instructor_course_sched_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 370;
   DBMS_SNAPSHOT.refresh ('lab_course_lookup_mv');
   DBMS_OUTPUT.put_line ('lab_course_lookup_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 380;
   DBMS_SNAPSHOT.refresh ('lab_course_sched_mv');
   DBMS_OUTPUT.put_line ('lab_course_sched_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 390;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_all_orders_mv');
   DBMS_OUTPUT.put_line ('gk_all_orders_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 400;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_new_isdb_contacts_mv');
   DBMS_OUTPUT.put_line ('gkdw.gk_new_isdb_contacts_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 410;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_lead_conversion_mv');
   DBMS_OUTPUT.put_line ('gkdw.gk_lead_conversion_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 420;
   DBMS_SNAPSHOT.REFRESH ('gkdw.gk_product_list_mv');
   DBMS_OUTPUT.put_line ('gk_product_list_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
    v_count := 440;
   DBMS_SNAPSHOT.REFRESH ('gkdw.master_prepay_mv');
   DBMS_OUTPUT.put_line ('master_prepay_mv complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 450;
   DBMS_SNAPSHOT.REFRESH ('gkdw.MASTER_QUOTE_ENT_PIPLN_MV');
   DBMS_OUTPUT.put_line ('MASTER_QUOTE_ENT_PIPLN_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   v_count := 460;
   DBMS_SNAPSHOT.REFRESH ('gkdw.GK_ADDRESS_XREF_HEADER_MV');
   DBMS_OUTPUT.put_line ('GK_ADDRESS_XREF_HEADER_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
 
--   v_count := 470;
--   DBMS_SNAPSHOT.REFRESH ('gkdw.MASTER_ENT_BOOKINGS_MV_TEST2');
--   DBMS_OUTPUT.put_line ('MASTER_ENT_BOOKINGS_MV complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
--   v_count := 480;
--   DBMS_SNAPSHOT.REFRESH ('gkdw.MASTER_OE_BOOKINGS_MV_TEST2');
--   DBMS_OUTPUT.put_line ('MASTER_OE_BOOKINGS_MV_TEST2 complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
--   v_count := 490;
--   DBMS_SNAPSHOT.REFRESH ('gkdw.master_ent_oe_booking_mv_test2');
--   DBMS_OUTPUT.put_line ('master_ent_oe_booking_mv_test2 complete: ' || TO_CHAR (SYSDATE, 'hh24:mi:ss'));
   
   --DBMS_SNAPSHOT.REFRESH('gkdw.gk_tps_data_mv');
   --dbms_output.put_line('gkdw.gk_tps_data_mv complete: '||to_char(sysdate,'hh24:mi:ss'));
   --DBMS_SNAPSHOT.REFRESH('slxdw.outbound_mod_pl_mv');
   --dbms_output.put_line('slxdw.outbound_mod_pl_mv complete: '||to_char(sysdate,'hh24:mi:ss'));
   --DBMS_SNAPSHOT.REFRESH('gkdw.GK_ARRA_ACT_ORDERS_MV');
   --dbms_output.put_line('gk_arra_act_orders_mv complete: '||to_char(sysdate,'hh24:mi:ss'));
   --DBMS_SNAPSHOT.REFRESH('gkdw.gk_sched_temp_mv');
   --dbms_output.put_line('gk_sched_temp_mv complete: '||to_char(sysdate,'hh24:mi:ss'));

   COMMIT;
   send_mail ('DW.Automation@globalknowledge.com','Erin.Riley@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Rajesh.Jr@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Bindu.RaviKumar@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Keshia.Baker@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Tiffany.Taylor@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','katie.santos@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   
   send_mail ('DW.Automation@globalknowledge.com','Alan.frelich@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','sruthi.reddy@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
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
                 'GK_MV_REFRESH_PROC FAILED',
                 v_msg_body);
END;
/


