DROP PROCEDURE GKDW.GK_EVENT_LOCATION_XML_PROC;

CREATE OR REPLACE PROCEDURE GKDW.GK_EVENT_LOCATION_XML_PROC AS 
BEGIN
gk_us_location_xml_proc;
DBMS_LOCK.SLEEP(60);
gk_us_event_xml_proc;
DBMS_LOCK.SLEEP(60);
gk_ca_event_xml_proc;
DBMS_LOCK.SLEEP(60);
gk_ca_location_xml_proc;
DBMS_LOCK.SLEEP(60);
END;
/


