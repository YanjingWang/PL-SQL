DROP PROCEDURE GKDW.GK_CONF_ONSITE_LKP_INSERT;

CREATE OR REPLACE PROCEDURE GKDW.GK_CONF_ONSITE_LKP_INSERT (
   P_EVENT_ID               VARCHAR2,
   P_CHANNEL_PARTNER        VARCHAR2,
   P_CHANNEL_POC_EMAIL      VARCHAR2,
   P_GK_CC1_EMAIL           VARCHAR2,
   P_GK_CC2_EMAIL           VARCHAR2,
   P_CHANNEL_KEYCODE          VARCHAR2)
AS
--=======================================================================
-- Author Nam:Sruthi Reddy
-- Create date: 7/22/2016
-- Description: This stored procedure will supress the emails from goign
-- to the students and send them to a specific user
--=======================================================================
-- Change History
--=======================================================================
-- Version   Date        Author             Description    
--  1.0      07/22/2016  Sruthi Reddy       Initial Version
--========================================================================
BEGIN

   INSERT INTO GK_CONF_ONSITE_LOOKUP (EVXEVENTID,
                                      CHANNEL_PARTNER,
                                      CHANNEL_POC_EMAIL,
                                      GK_CC1_EMAIL,
                                      GK_CC2_EMAIL,
                                      CHANNEL_KEYCODE)
      SELECT P_EVENT_ID,
             P_CHANNEL_PARTNER,
             P_CHANNEL_POC_EMAIL,
             P_GK_CC1_EMAIL,
             P_GK_CC2_EMAIL,
             P_CHANNEL_KEYCODE
        FROM EVENT_DIM  ED
      WHERE ED.EVENT_ID = P_EVENT_ID AND
      NOT EXISTS (SELECT 1 FROM GK_CONF_ONSITE_LOOKUP COL WHERE COL.EVXEVENTID = ED.EVENT_ID );
commit;
EXCEPTION
WHEN OTHERS THEN NULL;
RAISE;
END;
/


