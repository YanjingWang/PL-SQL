DROP VIEW GKDW.GK_MTM_MSFT_COURSE_V;

/* Formatted on 29/01/2021 11:32:49 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MTM_MSFT_COURSE_V
(
   MSFT_TYPE,
   COURSE_ID,
   COURSE_CODE,
   COURSE_NAME,
   SHORT_NAME
)
AS
   SELECT   'MOC' msft_type,
            course_id,
            course_code,
            course_name,
            short_name
     FROM   course_dim
    WHERE   pl_num = '02' AND SUBSTR (short_name, 1, 2) BETWEEN 'M0' AND 'M9'
   UNION
   SELECT   'MOC-GK',
            course_id,
            course_code,
            course_name,
            short_name
     FROM   course_dim
    WHERE   pl_num = '02' AND short_name LIKE '%7055%'
   UNION
   SELECT   'GK',
            course_id,
            course_code,
            course_name,
            short_name
     FROM   course_dim
    WHERE       pl_num = '02'
            AND SUBSTR (short_name, 1, 2) NOT BETWEEN 'M0' AND 'M9'
            AND short_name NOT LIKE '%7055%';


