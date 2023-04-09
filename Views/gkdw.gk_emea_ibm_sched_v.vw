DROP VIEW GKDW.GK_EMEA_IBM_SCHED_V;

/* Formatted on 29/01/2021 11:37:50 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EMEA_IBM_SCHED_V
(
   COURSECODE,
   CLASSNUM,
   IBMGLOBALCOURSECODE,
   CLASSSTARTDATE,
   CLASSSTARTTIME,
   CLASSENDDATE,
   CLASSENDTIME,
   STATE,
   CITY,
   ISOCTRY,
   COURSEURL,
   CLASSLANGUAGE,
   MODALITY,
   TIMEZONE,
   EVENTTYPE,
   STATUS,
   GUARANTEED
)
AS
   SELECT   "COURSECODE",
            "CLASSNUM",
            "IBMGLOBALCOURSECODE",
            "CLASSSTARTDATE",
            "CLASSSTARTTIME",
            "CLASSENDDATE",
            "CLASSENDTIME",
            "STATE",
            "CITY",
            "ISOCTRY",
            "COURSEURL",
            "CLASSLANGUAGE",
            "MODALITY",
            "TIMEZONE",
            "EVENTTYPE",
            "STATUS",
            "GUARANTEED"
     FROM   XMLTABLE ('/channel/item' PASSING xmltype (BFILENAME ('EMEA_RSS'
                      , 'IBMPartnerPortalEMEA.xml'), NLS_CHARSET_ID (
                      'CHAR_CS')) COLUMNS coursecode VARCHAR2 (25) PATH
                      'courseCode', classnum VARCHAR2 (25) PATH 'classNum', --                        coursename varchar2(250) path 'courseName',
                      ibmglobalcoursecode VARCHAR2 (25) PATH
                      'IBMGlobalCourseCode', classstartdate VARCHAR2 (25)
                      PATH 'classStartDate', classstarttime VARCHAR2 (25)
                      PATH 'classStartTime', classenddate VARCHAR2 (25) PATH
                      'classEndDate', classendtime VARCHAR2 (25) PATH
                      'classEndTime', state VARCHAR2 (250) PATH 'state',
                      city VARCHAR2 (250) PATH 'city', isoctry VARCHAR2 (250
                      ) PATH 'ISOCtry', courseurl VARCHAR2 (500) PATH
                      'CourseUrl', classlanguage VARCHAR2 (250) PATH
                      'classLanguage', modality VARCHAR2 (25) PATH
                      'Modality', timezone VARCHAR2 (25) PATH 'TimeZone',
                      eventtype VARCHAR2 (25) PATH 'EventType', status
                      NUMBER PATH 'classStatus', guaranteed NUMBER PATH
                      'Guaranteed');


