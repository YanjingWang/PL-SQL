DROP VIEW GKDW.GK_COURSE_ATTRIBUTES_V;

/* Formatted on 29/01/2021 11:40:29 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_ATTRIBUTES_V
(
   COURSE_ID,
   COURSE_CODE,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   VENDOR_CODE,
   SHORT_NAME,
   DELIVERY_METHOD,
   DELIVERY_TYPE,
   SALES_CHANNEL,
   PRODUCT_LINE,
   BUSINESS_UNIT,
   VENDOR,
   PRODUCT_TYPE
)
AS
   SELECT   DISTINCT
            cd.course_id,
            cd.course_code,
            cd.course_ch,
            cd.course_mod,
            cd.course_pl,
            cd.course_type,
            cd.vendor_code,
            cd.short_name,
            CASE
               WHEN SUBSTR (cd.course_code, 5, 1) IN
                          ('C', 'N', 'G', 'H', 'T', 'D')
               THEN
                  'CLASSROOM'
               WHEN SUBSTR (cd.course_code, 5, 1) IN ('L', 'V', 'U', 'Y')
               THEN
                  'VIRTUAL'
               WHEN SUBSTR (cd.course_code, 5, 1) IN ('R')
               THEN
                  'RENTAL'
               WHEN cd.course_code LIKE '%W'
               THEN
                  'SUBSCRIPTION'
               WHEN cd.course_code LIKE '%P'
               THEN
                  'SUBSCRIPTION'
               WHEN cd.course_code LIKE '%S'
               THEN
                  'LEARNING PRODUCT'
            END
               delivery_method,
            CASE
               WHEN SUBSTR (cd.course_code, 5, 1) IN
                          ('C', 'N', 'L', 'V', 'R', 'T')
               THEN
                  'GK DIRECT'
               WHEN SUBSTR (cd.course_code, 5, 1) IN
                          ('G', 'H', 'U', 'Y', 'D')
               THEN
                  'PARTNER DELIVERED'
               WHEN cd.course_code LIKE '%W' AND vendor_code IS NULL
               THEN
                  'GK DIRECT'
               WHEN cd.course_code LIKE '%W' AND vendor_code IS NOT NULL
               THEN
                  'PARTNER DELIVERED'
               WHEN cd.course_code LIKE '%S' AND vendor_code IS NULL
               THEN
                  'GK DIRECT'
               WHEN cd.course_code LIKE '%P'
               THEN
                  'GK DIRECT'
               WHEN cd.course_code LIKE '%S' AND vendor_code IS NOT NULL
               THEN
                  'PARTNER DELIVERED'
            END
               delivery_type,
            CASE
               WHEN SUBSTR (cd.course_code, 5, 1) IN
                          ('C', 'L', 'G', 'U', 'T', 'R', 'D')
               THEN
                  'OPEN ENROLLMENT'
               WHEN SUBSTR (cd.course_code, 5, 1) IN ('N', 'V', 'H', 'Y')
               THEN
                  'ENTERPRISE'
               WHEN cd.course_code LIKE '%W'
               THEN
                  'OPEN ENROLLMENT'
               WHEN cd.course_code LIKE '%P'
               THEN
                  'OPEN ENROLLMENT'
               WHEN cd.course_code LIKE '%S'
               THEN
                  'OPEN ENROLLMENT'
            END
               sales_channel,
            CASE
               WHEN cd.course_pl = 'APPLICATION DEVELOPMENT'
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN
                             ('.NET', 'SHAREPOINT', 'OTHER')
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN cd.course_pl = 'CLOUDERA'
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN
                             ('SOFTWARE', 'SHAREPOINT', 'PROGRAMMING', '.NET')
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN cd.course_pl = 'NETWORKING'
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'CISCO'
                    AND UPPER (NVL (course_type, 'NONE')) IN
                             ('DATA CENTER',
                              'UNIFIED COMMUNICATIONS',
                              'OPTICAL NETWORKING',
                              'ROUTING AND SWITCHING',
                              'ROUTING & SWITCHING',
                              'WIRELESS',
                              'ELAB',
                              'NONE')
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN
                             ('EXCHANGE', 'UNIFIED COMMUNICATIONS')
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'AVAYA'
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'HP'
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'JUNIPER'
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN
                             ('ROUTING & SWITCHING',
                              'UNIFIED COMMUNICATIONS',
                              'OPTICAL NETWORKING',
                              'TELEPRESENCE',
                              'NETWORKING',
                              'VOIP AND TELEPHONY',
                              'NETWORK MANAGEMENT',
                              'NETWORK INFRASTRUCTURE',
                              'DATA CENTER',
                              'CLOUD')
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'BUSINESS TRAINING'
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'CISCO'
                    AND UPPER (course_type) IN
                             ('SALES TRAINING', 'BUSINESS ARCHITECTURE')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN
                             ('MS OFFICE', 'OFFICE', 'PROJECT MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN
                             ('BUSINESS OBJECTS',
                              'PROJECT MANAGEMENT',
                              'BUSINESS ANALYSIS',
                              'SIX SIGMA',
                              'SALES TRAINING',
                              'PROFESSIONAL SKILLS',
                              'ITIL',
                              'BUSINESS SERVICE MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'OPERATING SYSTEMS'
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN
                             ('MS MOC',
                              'BOOT CAMP',
                              'SQL',
                              'SERVER',
                              'WINDOWS 7',
                              'WINDOWS CLIENT',
                              'VISTA',
                              'XP',
                              'OPERATING SYSTEMS')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.course_pl = 'CISCO'
                    AND UPPER (course_type) IN ('DATABASE')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN
                             ('STORAGE',
                              'DATABASE',
                              'OPERATING SYSTEMS',
                              'SERVER')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.course_pl = 'OTHER' AND vendor_code = 'ACT'
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.course_pl = 'VMWare'
               THEN
                  'VIRTUALIZATION'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN ('VIRTUALIZATION')
               THEN
                  'VIRTUALIZATION'
               WHEN cd.course_pl = 'CITRIX'
               THEN
                  'VIRTUALIZATION'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN ('APP VIRTUALIZATION')
               THEN
                  'VIRTUALIZATION'
               WHEN cd.course_pl = 'CISCO'
                    AND UPPER (course_type) IN ('SECURITY')
               THEN
                  'SECURITY'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN ('SECURITY')
               THEN
                  'SECURITY'
               WHEN cd.course_pl = 'RSA'
               THEN
                  'SECURITY'
               WHEN cd.course_pl = 'OTHER - NEST; SECURITY-EMEA'
                    AND UPPER (NVL (course_type, 'NONE')) IN
                             ('OTHER', 'NONE')
               THEN
                  'SECURITY'
               WHEN UPPER (cd.course_type) IN ('SECURITY', 'SONICWALL')
               THEN
                  'SECURITY'
               WHEN cd.course_pl = 'CISCO'
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'MICROSOFT'
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.vendor_code = 'FISHNET'
               THEN
                  'SECURITY'
               WHEN cd.vendor_code IN ('CA', 'TELEMAN', 'AKIBIA')
               THEN
                  'NETWORKING'
               WHEN cd.vendor_code IN ('SUN', 'EMC')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN cd.vendor_code IN ('CITRIX')
               THEN
                  'VIRTUALIZATION'
               WHEN cd.vendor_code IN ('BAKER', 'MISTI')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.vendor_code IN ('WEST', 'TRIVERA', 'EXIT')
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN UPPER (cd.course_type) IN
                          ('UNIFIED COMMUNICATIONS', 'ROUTING & SWITCHING')
               THEN
                  'NETWORKING'
               WHEN cd.course_pl = 'OTHER' AND cd.vendor_code = 'IBM'
               THEN
                  'APPLICATION DEVELOPMENT'
               ELSE
                  'OTHER'
            END
               product_line,
            CASE
               WHEN cd.course_type = 'LBS'
               THEN
                  'LBS'
               WHEN cd.course_pl = 'BUSINESS TRAINING'
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'CISCO'
                    AND UPPER (course_type) IN
                             ('SALES TRAINING', 'BUSINESS ARCHITECTURE')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'MICROSOFT'
                    AND UPPER (course_type) IN
                             ('MS OFFICE', 'OFFICE', 'PROJECT MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.course_pl = 'OTHER'
                    AND UPPER (course_type) IN
                             ('BUSINESS OBJECTS',
                              'PROJECT MANAGEMENT',
                              'BUSINESS ANALYSIS',
                              'SIX SIGMA',
                              'SALES TRAINING',
                              'PROFESSIONAL SKILLS',
                              'ITIL',
                              'BUSINESS SERVICE MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN cd.vendor_code IN ('BAKER', 'MISTI')
               THEN
                  'BUSINESS TRAINING'
               ELSE
                  'INFORMATION TECHNOLOGY'
            END
               business_unit,
            CASE
               WHEN cd.course_pl = 'MICROSOFT'
               THEN
                  'MICROSOFT'
               WHEN cd.course_pl = 'CISCO'
               THEN
                  'CISCO'
               WHEN cd.course_pl = 'CLOUDERA'
               THEN
                  'CLOUDERA'
               WHEN cd.course_pl = 'AVAYA'
               THEN
                  'AVAYA'
               WHEN cd.course_pl = 'HP'
               THEN
                  'HP'
               WHEN cd.course_pl = 'JUNIPER'
               THEN
                  'JUNIPER'
               WHEN cd.course_pl = 'CITRIX'
               THEN
                  'CITRIX'
               WHEN cd.course_pl = 'VMWare'
               THEN
                  'VMWARE'
               WHEN cd.course_pl = 'RSA'
               THEN
                  'RSA'
               WHEN cd.vendor_code = 'CITRIX'
               THEN
                  'CITRIX'
               WHEN cd.vendor_code = 'HP'
               THEN
                  'HP'
               WHEN cd.vendor_code = 'EMC'
               THEN
                  'EMC'
               WHEN cd.vendor_code = 'RHAT'
               THEN
                  'RED HAT'
               WHEN UPPER (cd.course_type) IN ('APPLE')
               THEN
                  'APPLE'
               WHEN cd.vendor_code IN ('CISNDM', 'CISCOHOT')
               THEN
                  'CISCO'
               WHEN UPPER (cd.course_type) IN
                          ('.NET', 'MS APPLICATIONS', 'SHAREPOINT')
               THEN
                  'MICROSOFT'
               WHEN UPPER (cd.course_type) = 'ADOBE'
               THEN
                  'ADOBE'
               WHEN cd.vendor_code = 'SAP'
               THEN
                  'SAP'
               WHEN cd.vendor_code = 'IBM'
               THEN
                  'IBM'
               WHEN cd.vendor_code = '6SIG'
               THEN
                  'SIX SIGMA'
               WHEN cd.vendor_code = 'SONICWALL'
               THEN
                  'SONIC WALL'
               WHEN cd.vendor_code = 'AMA'
               THEN
                  'AMERICAN MANAGEMENT ASSOC'
            END
               vendor,
            UPPER (course_type) product_type
     FROM      course_dim cd
            INNER JOIN
               event_dim ed
            ON cd.course_id = ed.course_id AND cd.country = ed.ops_country
    WHERE   cd.gkdw_source = 'SLXDW' AND NVL (cd.ch_num, '00') > '00'
   UNION
   SELECT   DISTINCT
            pd.product_id,
            pd.prod_num,
            pd.prod_channel,
            pd.prod_modality,
            pd.prod_line,
            pd.prod_family,
            NULL vendor_code,
            pd.prod_name,
            CASE
               WHEN pd.md_num IN ('32', '44', '50') THEN 'SUBSCRIPTION'
               WHEN pd.md_num IN ('31', '43') THEN 'LEARNING PRODUCT'
            END
               delivery_method,
            CASE
               WHEN pd.md_num IN ('31', '32', '50') THEN 'GK DIRECT'
               WHEN pd.md_num IN ('43', '44') THEN 'PARTNER DELIVERED'
            END
               delivery_type,
            CASE
               WHEN pd.ch_num = '10' THEN 'OPEN ENROLLMENT'
               WHEN pd.ch_num = '20' THEN 'ENTERPRISE'
            END
               sales_channel,
            CASE
               WHEN pd.prod_line = 'APPLICATION DEVELOPMENT'
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN
                             ('.NET', 'SHAREPOINT', 'OTHER')
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN pd.prod_line = 'CLOUDERA'
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN
                             ('SOFTWARE', 'SHAREPOINT', 'PROGRAMMING', '.NET')
               THEN
                  'APPLICATION DEVELOPMENT'
               WHEN pd.prod_line = 'NETWORKING'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'CISCO'
                    AND UPPER (NVL (pd.prod_family, 'NONE')) IN
                             ('DATA CENTER',
                              'UNIFIED COMMUNICATIONS',
                              'OPTICAL NETWORKING',
                              'ROUTING AND SWITCHING',
                              'ROUTING & SWITCHING',
                              'WIRELESS',
                              'ELAB',
                              'NONE')
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN
                             ('EXCHANGE', 'UNIFIED COMMUNICATIONS')
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'AVAYA'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'HP'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'JUNIPER'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'NORTEL'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN
                             ('ROUTING & SWITCHING',
                              'UNIFIED COMMUNICATIONS',
                              'OPTICAL NETWORKING',
                              'TELEPRESENCE',
                              'NETWORKING',
                              'VOIP AND TELEPHONY',
                              'NETWORK MANAGEMENT',
                              'NETWORK INFRASTRUCTURE',
                              'DATA CENTER',
                              'CLOUD')
               THEN
                  'NETWORKING'
               WHEN pd.prod_line IN
                          ('BUSINESS TRAINING', 'PROFESSIONAL SKILLS')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'CISCO'
                    AND UPPER (pd.prod_family) IN
                             ('SALES TRAINING', 'BUSINESS ARCHITECTURE')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN
                             ('MS OFFICE', 'OFFICE', 'PROJECT MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN
                             ('BUSINESS OBJECTS',
                              'PROJECT MANAGEMENT',
                              'BUSINESS ANALYSIS',
                              'SIX SIGMA',
                              'SALES TRAINING',
                              'PROFESSIONAL SKILLS',
                              'ITIL',
                              'BUSINESS SERVICE MANAGEMENT',
                              'THD')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'OPERATING SYSTEMS'
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN
                             ('MS MOC',
                              'BOOT CAMP',
                              'SQL',
                              'SERVER',
                              'WINDOWS 7',
                              'WINDOWS CLIENT',
                              'VISTA',
                              'XP',
                              'OPERATING SYSTEMS')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN pd.prod_line = 'CISCO'
                    AND UPPER (pd.prod_family) IN ('DATABASE')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN
                             ('STORAGE',
                              'DATABASE',
                              'OPERATING SYSTEMS',
                              'SERVER')
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN pd.prod_line = 'VMWare'
               THEN
                  'VIRTUALIZATION'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN ('VIRTUALIZATION')
               THEN
                  'VIRTUALIZATION'
               WHEN pd.prod_line = 'CITRIX'
               THEN
                  'VIRTUALIZATION'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN ('APP VIRTUALIZATION')
               THEN
                  'VIRTUALIZATION'
               WHEN pd.prod_line = 'CISCO'
                    AND UPPER (pd.prod_family) IN ('SECURITY')
               THEN
                  'SECURITY'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN ('SECURITY')
               THEN
                  'SECURITY'
               WHEN pd.prod_line = 'RSA'
               THEN
                  'SECURITY'
               WHEN pd.prod_line = 'OTHER - NEST; SECURITY-EMEA'
                    AND UPPER (NVL (pd.prod_family, 'NONE')) IN
                             ('OTHER', 'NONE')
               THEN
                  'SECURITY'
               WHEN UPPER (pd.prod_family) IN ('SECURITY', 'SONICWALL')
               THEN
                  'SECURITY'
               WHEN pd.prod_line = 'CISCO'
               THEN
                  'NETWORKING'
               WHEN pd.prod_line = 'MICROSOFT'
               THEN
                  'OPERATING SYSTEMS/DATABASE'
               WHEN UPPER (pd.prod_family) IN
                          ('UNIFIED COMMUNICATIONS', 'ROUTING & SWITCHING')
               THEN
                  'NETWORKING'
               ELSE
                  'OTHER'
            END
               product_line,
            CASE
               WHEN pd.prod_family = 'LBS'
               THEN
                  'LBS'
               WHEN pd.prod_line IN
                          ('BUSINESS TRAINING', 'PROFESSIONAL SKILLS')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'CISCO'
                    AND UPPER (pd.prod_family) IN
                             ('SALES TRAINING', 'BUSINESS ARCHITECTURE')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'MICROSOFT'
                    AND UPPER (pd.prod_family) IN
                             ('MS OFFICE', 'OFFICE', 'PROJECT MANAGEMENT')
               THEN
                  'BUSINESS TRAINING'
               WHEN pd.prod_line = 'OTHER'
                    AND UPPER (pd.prod_family) IN
                             ('BUSINESS OBJECTS',
                              'PROJECT MANAGEMENT',
                              'BUSINESS ANALYSIS',
                              'SIX SIGMA',
                              'SALES TRAINING',
                              'PROFESSIONAL SKILLS',
                              'ITIL',
                              'BUSINESS SERVICE MANAGEMENT',
                              'THD')
               THEN
                  'BUSINESS TRAINING'
               ELSE
                  'INFORMATION TECHNOLOGY'
            END
               business_unit,
            CASE
               WHEN pd.prod_line = 'MICROSOFT'
               THEN
                  'MICROSOFT'
               WHEN pd.prod_line = 'CISCO'
               THEN
                  'CISCO'
               WHEN pd.prod_line = 'CLOUDERA'
               THEN
                  'CLOUDERA'
               WHEN pd.prod_line = 'AVAYA'
               THEN
                  'AVAYA'
               WHEN pd.prod_line = 'HP'
               THEN
                  'HP'
               WHEN pd.prod_line = 'JUNIPER'
               THEN
                  'JUNIPER'
               WHEN pd.prod_line = 'CITRIX'
               THEN
                  'CITRIX'
               WHEN pd.prod_line = 'VMWare'
               THEN
                  'VMWARE'
               WHEN pd.prod_line = 'RSA'
               THEN
                  'RSA'
               WHEN pd.prod_line = 'NORTEL'
               THEN
                  'AVAYA'
               WHEN UPPER (pd.prod_family) IN ('APPLE')
               THEN
                  'APPLE'
               WHEN UPPER (pd.prod_family) IN
                          ('.NET', 'MS APPLICATIONS', 'SHAREPOINT')
               THEN
                  'MICROSOFT'
               WHEN UPPER (pd.prod_family) = 'ADOBE'
               THEN
                  'ADOBE'
               WHEN UPPER (pd.prod_family) = 'ORACLE'
               THEN
                  'ORACLE'
            END
               vendor,
            UPPER (pd.prod_family) product_type
     FROM      product_dim pd
            INNER JOIN
               sales_order_fact sf
            ON pd.product_id = sf.product_id
    WHERE   pd.gkdw_source = 'SLXDW' AND NVL (pd.ch_num, '00') > '00'
   ORDER BY   product_line, course_code;


