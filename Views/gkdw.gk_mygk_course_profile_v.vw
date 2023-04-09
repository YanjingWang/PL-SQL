DROP VIEW GKDW.GK_MYGK_COURSE_PROFILE_V;

/* Formatted on 29/01/2021 11:32:41 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MYGK_COURSE_PROFILE_V
(
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   MYGK_PROFILE,
   DMOC,
   ADOBE_CONNECT
)
AS
   SELECT   DISTINCT
            cp.evxcourseid course_id,
            cd.course_code,
            cd.short_name,
            cd.course_ch,
            cd.course_mod,
            cd.course_pl,
            dp.code mygk_profile,
            CASE WHEN sp.template = 'Custom' THEN 'Y' ELSE 'N' END dmoc,
            CASE WHEN cp.modality IN ('V', 'L') THEN 'Y' ELSE 'N' END
               adobe_connect
     FROM               dvxcourseprofile@gkhub cp
                     INNER JOIN
                        dvxprofile@gkhub dp
                     ON cp.dvxprofileid = dp.dvxprofileid
                  INNER JOIN
                     dvxprofilemember@gkhub pm
                  ON dp.dvxprofileid = pm.dvxprofileid
               INNER JOIN
                  dvxsystemprofile@gkhub sp
               ON pm.dvxsystemprofileid = sp.dvxsystemprofileid
                  AND sp.TYPE = 'Courseware'
            INNER JOIN
               course_dim cd
            ON cp.evxcourseid = cd.course_id AND cd.gkdw_source = 'SLXDW'
    WHERE   cp.terminationdate IS NULL
   UNION
   SELECT   DISTINCT
            cp.evxcourseid course_id,
            cd.course_code,
            cd.short_name,
            cd.course_ch,
            cd.course_mod,
            cd.course_pl,
            dp.code mygk_profile,
            'N' dmoc,
            CASE WHEN cp.modality IN ('V', 'L') THEN 'Y' ELSE 'N' END
               adobe_connect
     FROM         dvxcourseprofile@gkhub cp
               INNER JOIN
                  dvxprofile@gkhub dp
               ON cp.dvxprofileid = dp.dvxprofileid
            INNER JOIN
               course_dim cd
            ON cp.evxcourseid = cd.course_id AND cd.gkdw_source = 'SLXDW'
    WHERE   cp.terminationdate IS NULL
            AND NOT EXISTS
                  (SELECT   1
                     FROM      dvxprofilemember@gkhub pm
                            INNER JOIN
                               dvxsystemprofile@gkhub sp
                            ON pm.dvxsystemprofileid = sp.dvxsystemprofileid
                    WHERE   dp.dvxprofileid = pm.dvxprofileid
                            AND sp.TYPE = 'Courseware');


