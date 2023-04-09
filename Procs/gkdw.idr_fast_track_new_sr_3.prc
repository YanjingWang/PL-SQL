DROP PROCEDURE GKDW.IDR_FAST_TRACK_NEW_SR_3;

CREATE OR REPLACE PROCEDURE GKDW.idr_fast_track_new_sr_3 (
   p_coursecode                VARCHAR2,
   p_country                   VARCHAR2,
   p_date                      VARCHAR2,
   p_gk_tc                     VARCHAR2 DEFAULT 'N',
   p_specific_request          VARCHAR2 DEFAULT 'N',
   p_no_travel                 VARCHAR2 DEFAULT 'N',
   p_sec_credit                VARCHAR2 DEFAULT 'N',
   p_gk_equip                  VARCHAR2 DEFAULT 'N',
   p_mod_comb                  VARCHAR2 DEFAULT 'N',
   p_federal                   VARCHAR2 DEFAULT 'N',
   p_student_cnt               NUMBER DEFAULT 12,
   p_state                     VARCHAR2 DEFAULT 'NA',
   p_city                      VARCHAR2 DEFAULT 'NOCITY',
   p_hardcopy                  VARCHAR2 DEFAULT 'N',
   p_custom_cw                 VARCHAR2 DEFAULT 'N',
   p_voucher                   VARCHAR2 DEFAULT 'N',
   p_proctor                   VARCHAR2 DEFAULT 'N',
   p_local_request             VARCHAR2 DEFAULT 'N',
   p_nonconsecutive_days       VARCHAR2 DEFAULT 'N',
   p_fast_tract            OUT IDR_FAST_TRACK_TAB)
AS
  -- v_fast_tract   IDR_FAST_TRACK_TAB := IDR_FAST_TRACK_TAB;

   CURSOR c0
   IS
      SELECT NVL (course_pl, 'NONE') course_pl
        FROM course_dim
       WHERE     course_code = p_coursecode
             AND SUBSTR (country, 1, 2) = p_country;

   r0             c0%ROWTYPE;
   v_pl           VARCHAR2 (50) := 'NONE';
   v_count        NUMBER;
BEGIN
   OPEN c0;

   FETCH c0 INTO r0;

   IF c0%FOUND
   THEN
      v_pl := r0.course_pl;
   ELSE
      v_pl := 'NONE';
   END IF;

   SELECT COUNT (*)
     INTO v_count
     FROM (  SELECT SUBSTR (q.course_code, 1, LENGTH (q.course_code) - 1)
                       course_code,
                    SUBSTR (q.course_code, -1) modality,
                    TO_CHAR (dim_date, 'yyyy-mm-dd') request_date,
                    TO_CHAR (
                       get_bus_date (dim_date, cd.duration_days, p_country),
                       'yyyy-mm-dd')
                       request_end_date,
                    dim_year,
                    dim_week,
                    dim_day,
                    cd.duration_days,
                    CASE
                       WHEN holiday_flag = 'Y'
                       THEN
                          'EX|HOL'
                       WHEN p_local_request = 'Y'
                       THEN
                          'EX|LOCAL'
                       WHEN p_federal = 'Y'
                       THEN
                          'EX|FED'
                       WHEN p_custom_cw = 'Y'
                       THEN
                          'EX|CUST'
                       WHEN cd.pl_num = 19
                       THEN
                          'EX|IBM'
                       WHEN cd.md_num NOT IN ('10', '20')
                       THEN
                          'EX|PRTNR'
                       WHEN dim_date > TRUNC (SYSDATE) + 180
                       THEN
                          'AVAILABLE'
                       WHEN p_student_cnt > NVL (hc.hard_cap, 99)
                       THEN
                          'EX|HARDCAP'
                       WHEN p_mod_comb = 'Y'
                       THEN
                          'EX|MOD'
                       WHEN p_gk_equip = 'Y'
                       THEN
                          'EX|EQUIP'
                       WHEN p_sec_credit = 'Y'
                       THEN
                          'EX|SEC'
                       WHEN p_no_travel = 'Y'
                       THEN
                          'EX|TRAVEL'
                       WHEN p_hardcopy = 'Y'
                       THEN
                          'EX|HCOPY'
                       WHEN p_voucher = 'Y'
                       THEN
                          'EX|VOUC'
                       WHEN p_proctor = 'Y'
                       THEN
                          'EX|PRCT'
                       WHEN     p_specific_request = 'Y'
                            AND v_pl != 'MICROSOFT APPS'
                       THEN
                          'EX|SPECIFIC'
                       WHEN p_nonconsecutive_days = 'Y'
                       THEN
                          'EX|NONCONSEC'
                       WHEN p_gk_tc = 'Y'
                       THEN
                          'EX|GKTC'
                       WHEN dim_date < TRUNC (SYSDATE) + 21
                       THEN
                          'EX|START'
                       WHEN SUM (inst_status + lab_status) = 0
                       THEN
                          'AVAILABLE'
                       WHEN SUM (inst_status) = 1
                       THEN
                          'UN|INST'
                       WHEN SUM (lab_status) = 1
                       THEN
                          'UN|EQUIP'
                       WHEN SUM (inst_status) = 3
                       THEN
                          'EX|DUR'
                       ELSE
                          'EXCEPTION'
                    END
                       exception_code
               FROM (  SELECT td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              p_coursecode AS course_code,
                              SUBSTR (p_coursecode, -1) AS modality,
                              CASE
                                 WHEN    (    td2.us_holiday = 'Y'
                                          AND p_country = 'US')
                                      OR (    td2.ca_holiday = 'Y'
                                          AND p_country = 'CA')
                                 THEN
                                    'Y'
                                 ELSE
                                    'N'
                              END
                                 holiday_flag,
                              CASE
                                 WHEN     cl.course_dur >= 5
                                      AND td2.dim_day NOT IN ('Monday')
                                 THEN
                                    3
                                 WHEN     cl.course_dur = 4
                                      AND td2.dim_day NOT IN ('Monday', 'Tuesday')
                                 THEN
                                    3
                                 WHEN     cl.course_dur = 3
                                      AND td2.dim_day NOT IN ('Monday',
                                                              'Tuesday',
                                                              'Wednesday')
                                 THEN
                                    3
                                 WHEN     cl.course_dur = 2
                                      AND td2.dim_day NOT IN ('Monday',
                                                              'Tuesday',
                                                              'Wednesday',
                                                              'Thursday')
                                 THEN
                                    3
                                 WHEN 'US' = 'US' AND td2.us_holiday = 'Y'
                                 THEN
                                    2
                                 WHEN 'US' = 'CA' AND td2.ca_holiday = 'Y'
                                 THEN
                                    2
                                 WHEN CASE
                                         WHEN COUNT (DISTINCT cl.instructor_id) >
                                                 0
                                         THEN
                                              (  1
                                               - (  COUNT (
                                                       DISTINCT cs.instructor_id)
                                                  / COUNT (
                                                       DISTINCT cl.instructor_id)))
                                            * 100
                                         ELSE
                                            0
                                      END >=
                                         CASE
                                            WHEN COUNT (
                                                    DISTINCT cl.instructor_id) <=
                                                    5
                                            THEN
                                               101
                                            WHEN COUNT (
                                                    DISTINCT cl.instructor_id) <=
                                                    10
                                            THEN
                                               60
                                            WHEN COUNT (
                                                    DISTINCT cl.instructor_id) <=
                                                    20
                                            THEN
                                               50
                                            WHEN COUNT (
                                                    DISTINCT cl.instructor_id) <=
                                                    30
                                            THEN
                                               40
                                            ELSE
                                               30
                                         END
                                 THEN
                                    0
                                 ELSE
                                    1
                              END
                                 inst_status,
                              0 lab_status
                         FROM time_dim td1
                              LEFT OUTER JOIN time_dim td2
                                 ON     (   (    td1.dim_year = td2.dim_year
                                             AND td2.dim_week BETWEEN td1.dim_week
                                                                  AND   td1.dim_week
                                                                      + 5)
                                         OR (    td1.dim_week + 5 > 52
                                             AND td1.dim_year + 1 = td2.dim_year
                                             AND td2.dim_week BETWEEN   td1.dim_week
                                                                      - 52
                                                                  AND   td1.dim_week
                                                                      - 47))
                                    AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                              LEFT OUTER JOIN instructor_course_lookup_mv_qa cl
                                 ON cl.prod_code =
                                       SUBSTR (p_coursecode,
                                               1,
                                               LENGTH (p_coursecode) - 1)
                              LEFT OUTER JOIN instructor_course_sched_mv_qa cs
                                 ON     td2.dim_date = cs.dim_date
                                    AND cl.prod_code = cs.prod_code
                              LEFT OUTER JOIN course_dim cd
                                 ON     cl.course_code = cd.course_code
                                    AND SUBSTR (cd.country, 1, 2) = p_country
                                    AND cd.gkdw_source = 'SLXDW'
                        WHERE     td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                              AND v_pl != 'MICROSOFT APPS'
                     GROUP BY td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              cl.course_code,
                              cl.course_dur,
                              td2.us_holiday,
                              td2.ca_holiday,
                              cl.modality,
                              cd.course_pl
                     UNION
                       SELECT td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              cl.course_code,
                              cl.modality,
                              CASE
                                 WHEN    (    td2.us_holiday = 'Y'
                                          AND p_country = 'US')
                                      OR (    td2.ca_holiday = 'Y'
                                          AND p_country = 'CA')
                                 THEN
                                    'Y'
                                 ELSE
                                    'N'
                              END
                                 holiday_flag,
                              CASE
                                 WHEN SUM (CASE
                                              WHEN     get_distance (
                                                          gp1.latitude,
                                                          gp1.longitude,
                                                          gp2.latitude,
                                                          gp2.longitude) <= 25
                                                   AND cs.instructor_id IS NULL
                                              THEN
                                                 1
                                              ELSE
                                                 0
                                           END) >= 2
                                 THEN
                                    0
                                 ELSE
                                    1
                              END
                                 inst_status,
                              0 lab_status
                         FROM time_dim td1
                              LEFT OUTER JOIN time_dim td2
                                 ON     (   (    td1.dim_year = td2.dim_year
                                             AND td2.dim_week BETWEEN td1.dim_week
                                                                  AND   td1.dim_week
                                                                      + 5)
                                         OR (    td1.dim_week + 5 > 52
                                             AND td1.dim_year + 1 = td2.dim_year
                                             AND td2.dim_week BETWEEN   td1.dim_week
                                                                      - 52
                                                                  AND   td1.dim_week
                                                                      - 47))
                                    AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                              LEFT OUTER JOIN instructor_course_lookup_mv_qa cl
                                 ON cl.prod_code =
                                       SUBSTR (p_coursecode,
                                               1,
                                               LENGTH (p_coursecode) - 1)
                              LEFT OUTER JOIN instructor_course_sched_mv_qa cs
                                 ON     td2.dim_date = cs.dim_date
                                    AND cl.prod_code = cs.prod_code
                              LEFT OUTER JOIN geo_postal gp2
                                 ON CASE
                                       WHEN cl.country = p_country
                                       THEN
                                          SUBSTR (cl.zip_code, 1, 3)
                                       ELSE
                                          cl.zip_code
                                    END = gp2.postalcode
                              INNER JOIN geo_postal gp1
                                 ON gp1.postalcode =
                                       (SELECT MAX (postalcode)
                                          FROM geo_postal
                                         WHERE     city LIKE '%' || p_city || '%'
                                               AND state_abbrv = p_state)
                        WHERE     td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                              AND v_pl = 'MICROSOFT APPS'
                     GROUP BY td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              cl.course_code,
                              cl.course_dur,
                              td2.us_holiday,
                              td2.ca_holiday,
                              cl.modality
                     UNION
                       SELECT td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              cl.gk_course_code,
                              cl.modality,
                              CASE
                                 WHEN    (    td2.us_holiday = 'Y'
                                          AND p_country = 'US')
                                      OR (    td2.ca_holiday = 'Y'
                                          AND p_country = 'CA')
                                 THEN
                                    'Y'
                                 ELSE
                                    'N'
                              END
                                 holiday_flag,
                              0 inst_status,
                              CASE
                                 WHEN cl.remote_lab_provider IN ('TERILLIAN')
                                 THEN
                                    0
                                 WHEN cl.remote_lab_provider NOT IN ('GK',
                                                                     'GLOBAL KNOWLEDGE')
                                 THEN
                                    1
                                 WHEN   (  1
                                         -   (  NVL (cs.lab_ratio, 0)
                                              * COUNT (DISTINCT cs.lab_pod_id))
                                           / (  cl.lab_ratio
                                              * COUNT (DISTINCT cl.lab_pod_id)))
                                      * 100 > 40
                                 THEN
                                    0
                                 ELSE
                                    1
                              END
                                 lab_status
                         FROM time_dim td1
                              LEFT OUTER JOIN time_dim td2
                                 ON     (   (    td1.dim_year = td2.dim_year
                                             AND td2.dim_week BETWEEN td1.dim_week
                                                                  AND   td1.dim_week
                                                                      + 5)
                                         OR (    td1.dim_week + 5 > 52
                                             AND td1.dim_year + 1 = td2.dim_year
                                             AND td2.dim_week BETWEEN   td1.dim_week
                                                                      - 52
                                                                  AND   td1.dim_week
                                                                      - 47))
                                    AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                              LEFT OUTER JOIN lab_course_lookup_mv_qa cl
                                 ON cl.gk_course_code = p_coursecode
                              LEFT OUTER JOIN lab_course_sched_mv_qa cs
                                 ON     td2.dim_date = cs.dim_date
                                    AND cl.gk_course_code = cs.gk_course_code
                        WHERE td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                     GROUP BY td2.dim_year,
                              td2.dim_week,
                              td2.dim_date,
                              td2.dim_day,
                              cl.gk_course_code,
                              cl.lab_ratio,
                              cs.lab_ratio,
                              cl.remote_lab_provider,
                              cl.modality,
                              td2.us_holiday,
                              td2.ca_holiday) q
                    INNER JOIN course_dim cd
                       ON     q.course_code = cd.course_code
                          AND SUBSTR (cd.country, 1, 2) = p_country
                          AND cd.gkdw_source = 'SLXDW'
                    LEFT OUTER JOIN gk_course_hard_cap_v hc
                       ON cd.course_code = hc.gk_course_code
           GROUP BY dim_year,
                    dim_week,
                    dim_date,
                    dim_day,
                    holiday_flag,
                    q.course_code,
                    modality,
                    cd.pl_num,
                    cd.md_num,
                    hc.hard_cap,
                    cd.duration_days);

   IF v_count > 0
   THEN
      --OPEN v_fast_tract FOR
SELECT IDR_FAST_TRACK_OBJ (course_code,
                           modality,
                           request_date,
                           request_end_date,
                           dim_year,
                           dim_week,
                           dim_day,
                           duration_days,
                           exception_code)
           BULK COLLECT INTO p_fast_tract
           FROM (SELECT SUBSTR (q.course_code, 1, LENGTH (q.course_code) - 1)
                     course_code,
                  SUBSTR (q.course_code, -1) modality,
                  TO_CHAR (dim_date, 'yyyy-mm-dd') request_date,
                  TO_CHAR (
                     get_bus_date (dim_date, cd.duration_days, p_country),
                     'yyyy-mm-dd')
                     request_end_date,
                  dim_year,
                  dim_week,
                  dim_day,
                  cd.duration_days,
                  CASE
                     WHEN holiday_flag = 'Y'
                     THEN
                        'EX|HOL'
                     WHEN p_local_request = 'Y'
                     THEN
                        'EX|LOCAL'
                     WHEN p_federal = 'Y'
                     THEN
                        'EX|FED'
                     WHEN p_custom_cw = 'Y'
                     THEN
                        'EX|CUST'
                     WHEN cd.pl_num = 19
                     THEN
                        'EX|IBM'
                     WHEN cd.md_num NOT IN ('10', '20')
                     THEN
                        'EX|PRTNR'
                     WHEN dim_date > TRUNC (SYSDATE) + 180
                     THEN
                        'AVAILABLE'
                     WHEN p_student_cnt > NVL (hc.hard_cap, 99)
                     THEN
                        'EX|HARDCAP'
                     WHEN p_mod_comb = 'Y'
                     THEN
                        'EX|MOD'
                     WHEN p_gk_equip = 'Y'
                     THEN
                        'EX|EQUIP'
                     WHEN p_sec_credit = 'Y'
                     THEN
                        'EX|SEC'
                     WHEN p_no_travel = 'Y'
                     THEN
                        'EX|TRAVEL'
                     WHEN p_hardcopy = 'Y'
                     THEN
                        'EX|HCOPY'
                     WHEN p_voucher = 'Y'
                     THEN
                        'EX|VOUC'
                     WHEN p_proctor = 'Y'
                     THEN
                        'EX|PRCT'
                     WHEN p_specific_request = 'Y' AND v_pl != 'MICROSOFT APPS'
                     THEN
                        'EX|SPECIFIC'
                     WHEN p_nonconsecutive_days = 'Y'
                     THEN
                        'EX|NONCONSEC'
                     WHEN p_gk_tc = 'Y'
                     THEN
                        'EX|GKTC'
                     WHEN dim_date < TRUNC (SYSDATE) + 21
                     THEN
                        'EX|START'
                     WHEN SUM (inst_status + lab_status) = 0
                     THEN
                        'AVAILABLE'
                     WHEN SUM (inst_status) = 1
                     THEN
                        'UN|INST'
                     WHEN SUM (lab_status) = 1
                     THEN
                        'UN|EQUIP'
                     WHEN SUM (inst_status) = 3
                     THEN
                        'EX|DUR'
                     ELSE
                        'EXCEPTION'
                  END
                     exception_code
             FROM (  SELECT td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            p_coursecode AS course_code,
                            SUBSTR (p_coursecode, -1) AS modality,
                            CASE
                               WHEN    (td2.us_holiday = 'Y' AND p_country = 'US')
                                    OR (td2.ca_holiday = 'Y' AND p_country = 'CA')
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END
                               holiday_flag,
                            CASE
                               WHEN     cl.course_dur >= 5
                                    AND td2.dim_day NOT IN ('Monday')
                               THEN
                                  3
                               WHEN     cl.course_dur = 4
                                    AND td2.dim_day NOT IN ('Monday', 'Tuesday')
                               THEN
                                  3
                               WHEN     cl.course_dur = 3
                                    AND td2.dim_day NOT IN ('Monday',
                                                            'Tuesday',
                                                            'Wednesday')
                               THEN
                                  3
                               WHEN     cl.course_dur = 2
                                    AND td2.dim_day NOT IN ('Monday',
                                                            'Tuesday',
                                                            'Wednesday',
                                                            'Thursday')
                               THEN
                                  3
                               WHEN 'US' = 'US' AND td2.us_holiday = 'Y'
                               THEN
                                  2
                               WHEN 'US' = 'CA' AND td2.ca_holiday = 'Y'
                               THEN
                                  2
                               WHEN CASE
                                       WHEN COUNT (DISTINCT cl.instructor_id) > 0
                                       THEN
                                            (  1
                                             - (  COUNT (
                                                     DISTINCT cs.instructor_id)
                                                / COUNT (
                                                     DISTINCT cl.instructor_id)))
                                          * 100
                                       ELSE
                                          0
                                    END >=
                                       CASE
                                          WHEN COUNT (DISTINCT cl.instructor_id) <=
                                                  5
                                          THEN
                                             101
                                          WHEN COUNT (DISTINCT cl.instructor_id) <=
                                                  10
                                          THEN
                                             60
                                          WHEN COUNT (DISTINCT cl.instructor_id) <=
                                                  20
                                          THEN
                                             50
                                          WHEN COUNT (DISTINCT cl.instructor_id) <=
                                                  30
                                          THEN
                                             40
                                          ELSE
                                             30
                                       END
                               THEN
                                  0
                               ELSE
                                  1
                            END
                               inst_status,
                            0 lab_status
                       FROM time_dim td1
                            LEFT OUTER JOIN time_dim td2
                               ON     (   (    td1.dim_year = td2.dim_year
                                           AND td2.dim_week BETWEEN td1.dim_week
                                                                AND   td1.dim_week
                                                                    + 5)
                                       OR (    td1.dim_week + 5 > 52
                                           AND td1.dim_year + 1 = td2.dim_year
                                           AND td2.dim_week BETWEEN   td1.dim_week
                                                                    - 52
                                                                AND   td1.dim_week
                                                                    - 47))
                                  AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                            LEFT OUTER JOIN instructor_course_lookup_mv_qa cl
                               ON cl.prod_code =
                                     SUBSTR (p_coursecode,
                                             1,
                                             LENGTH (p_coursecode) - 1)
                            LEFT OUTER JOIN instructor_course_sched_mv_qa cs
                               ON     td2.dim_date = cs.dim_date
                                  AND cl.prod_code = cs.prod_code
                            LEFT OUTER JOIN course_dim cd
                               ON     cl.course_code = cd.course_code
                                  AND SUBSTR (cd.country, 1, 2) = p_country
                                  AND cd.gkdw_source = 'SLXDW'
                      WHERE     td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                            AND v_pl != 'MICROSOFT APPS'
                   GROUP BY td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            cl.course_code,
                            cl.course_dur,
                            td2.us_holiday,
                            td2.ca_holiday,
                            cl.modality,
                            cd.course_pl
                   UNION
                     SELECT td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            cl.course_code,
                            cl.modality,
                            CASE
                               WHEN    (td2.us_holiday = 'Y' AND p_country = 'US')
                                    OR (td2.ca_holiday = 'Y' AND p_country = 'CA')
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END
                               holiday_flag,
                            CASE
                               WHEN SUM (
                                       CASE
                                          WHEN     get_distance (gp1.latitude,
                                                                 gp1.longitude,
                                                                 gp2.latitude,
                                                                 gp2.longitude) <=
                                                      25
                                               AND cs.instructor_id IS NULL
                                          THEN
                                             1
                                          ELSE
                                             0
                                       END) >= 2
                               THEN
                                  0
                               ELSE
                                  1
                            END
                               inst_status,
                            0 lab_status
                       FROM time_dim td1
                            LEFT OUTER JOIN time_dim td2
                               ON     (   (    td1.dim_year = td2.dim_year
                                           AND td2.dim_week BETWEEN td1.dim_week
                                                                AND   td1.dim_week
                                                                    + 5)
                                       OR (    td1.dim_week + 5 > 52
                                           AND td1.dim_year + 1 = td2.dim_year
                                           AND td2.dim_week BETWEEN   td1.dim_week
                                                                    - 52
                                                                AND   td1.dim_week
                                                                    - 47))
                                  AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                            LEFT OUTER JOIN instructor_course_lookup_mv_qa cl
                               ON cl.prod_code =
                                     SUBSTR (p_coursecode,
                                             1,
                                             LENGTH (p_coursecode) - 1)
                            LEFT OUTER JOIN instructor_course_sched_mv_qa cs
                               ON     td2.dim_date = cs.dim_date
                                  AND cl.prod_code = cs.prod_code
                            LEFT OUTER JOIN geo_postal gp2
                               ON CASE
                                     WHEN cl.country = p_country
                                     THEN
                                        SUBSTR (cl.zip_code, 1, 3)
                                     ELSE
                                        cl.zip_code
                                  END = gp2.postalcode
                            INNER JOIN geo_postal gp1
                               ON gp1.postalcode =
                                     (SELECT MAX (postalcode)
                                        FROM geo_postal
                                       WHERE     city LIKE '%' || p_city || '%'
                                             AND state_abbrv = p_state)
                      WHERE     td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                            AND v_pl = 'MICROSOFT APPS'
                   GROUP BY td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            cl.course_code,
                            cl.course_dur,
                            td2.us_holiday,
                            td2.ca_holiday,
                            cl.modality
                   UNION
                     SELECT td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            cl.gk_course_code,
                            cl.modality,
                            CASE
                               WHEN    (td2.us_holiday = 'Y' AND p_country = 'US')
                                    OR (td2.ca_holiday = 'Y' AND p_country = 'CA')
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END
                               holiday_flag,
                            0 inst_status,
                            CASE
                               WHEN cl.remote_lab_provider IN ('TERILLIAN')
                               THEN
                                  0
                               WHEN cl.remote_lab_provider NOT IN ('GK',
                                                                   'GLOBAL KNOWLEDGE')
                               THEN
                                  1
                               WHEN   (  1
                                       -   (  NVL (cs.lab_ratio, 0)
                                            * COUNT (DISTINCT cs.lab_pod_id))
                                         / (  cl.lab_ratio
                                            * COUNT (DISTINCT cl.lab_pod_id)))
                                    * 100 > 40
                               THEN
                                  0
                               ELSE
                                  1
                            END
                               lab_status
                       FROM time_dim td1
                            LEFT OUTER JOIN time_dim td2
                               ON     (   (    td1.dim_year = td2.dim_year
                                           AND td2.dim_week BETWEEN td1.dim_week
                                                                AND   td1.dim_week
                                                                    + 5)
                                       OR (    td1.dim_week + 5 > 52
                                           AND td1.dim_year + 1 = td2.dim_year
                                           AND td2.dim_week BETWEEN   td1.dim_week
                                                                    - 52
                                                                AND   td1.dim_week
                                                                    - 47))
                                  AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                            LEFT OUTER JOIN lab_course_lookup_mv_qa cl
                               ON cl.gk_course_code = p_coursecode
                            LEFT OUTER JOIN lab_course_sched_mv_qa cs
                               ON     td2.dim_date = cs.dim_date
                                  AND cl.gk_course_code = cs.gk_course_code
                      WHERE td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
                   GROUP BY td2.dim_year,
                            td2.dim_week,
                            td2.dim_date,
                            td2.dim_day,
                            cl.gk_course_code,
                            cl.lab_ratio,
                            cs.lab_ratio,
                            cl.remote_lab_provider,
                            cl.modality,
                            td2.us_holiday,
                            td2.ca_holiday) q
                  INNER JOIN course_dim cd
                     ON     q.course_code = cd.course_code
                        AND SUBSTR (cd.country, 1, 2) = p_country
                        AND cd.gkdw_source = 'SLXDW'
                  LEFT OUTER JOIN gk_course_hard_cap_v hc
                     ON cd.course_code = hc.gk_course_code
         GROUP BY dim_year,
                  dim_week,
                  dim_date,
                  dim_day,
                  holiday_flag,
                  q.course_code,
                  modality,
                  cd.pl_num,
                  cd.md_num,
                  hc.hard_cap,
                  cd.duration_days
         ORDER BY dim_date);
   ELSE
     -- OPEN v_fast_tract FOR
     SELECT IDR_FAST_TRACK_OBJ (course_code,
                           modality,
                           request_date,
                           request_end_date,
                           dim_year,
                           dim_week,
                           dim_day,
                           duration_days,
                           exception_code)
          BULK COLLECT INTO p_fast_tract
       FROM   ( SELECT SUBSTR (cd.course_code, 1, LENGTH (cd.course_code) - 1) course_code,
                  SUBSTR (cd.course_code, -1) modality,
                  TO_CHAR (td2.dim_date, 'yyyy-mm-dd') request_date,
                  TO_CHAR (
                     get_bus_date (td2.dim_date, cd.duration_days, p_country),
                     'yyyy-mm-dd') request_end_date,
                  td2.dim_year,
                  td2.dim_week,
                  td2.dim_day,
                  cd.duration_days,
                  CASE
                     WHEN    (td2.us_holiday = 'Y' AND p_country = 'US')
                          OR (td2.ca_holiday = 'Y' AND p_country = 'CA')
                     THEN
                        'EX|HOL'
                     WHEN p_federal = 'Y'
                     THEN
                        'EX|FED'
                     WHEN p_mod_comb = 'Y'
                     THEN
                        'EX|MOD'
                     WHEN p_gk_equip = 'Y'
                     THEN
                        'EX|EQUIP'
                     WHEN p_sec_credit = 'Y'
                     THEN
                        'EX|SEC'
                     WHEN p_no_travel = 'Y'
                     THEN
                        'EX|TRAVEL'
                     WHEN p_specific_request = 'Y'
                     THEN
                        'EX|INST'
                     WHEN p_local_request = 'Y'
                     THEN
                        'EX|LOCAL'
                     WHEN p_nonconsecutive_days = 'Y'
                     THEN
                        'EX|NONCONSEC'
                     WHEN p_hardcopy = 'Y'
                     THEN
                        'EX|HCOPY'
                     WHEN p_custom_cw = 'Y'
                     THEN
                        'EX|CUST'
                     WHEN p_voucher = 'Y'
                     THEN
                        'EX|VOUC'
                     WHEN p_proctor = 'Y'
                     THEN
                        'EX|PRCT'
                     WHEN p_gk_tc = 'Y'
                     THEN
                        'EX|GKTC'
                     ELSE
                        'EX|NORES'
                  END exception_code
             FROM time_dim td1
                  LEFT OUTER JOIN time_dim td2
                     ON     (   (    td1.dim_year = td2.dim_year
                                 AND td2.dim_week BETWEEN td1.dim_week
                                                      AND td1.dim_week + 5)
                             OR (    td1.dim_week + 5 > 52
                                 AND td1.dim_year + 1 = td2.dim_year
                                 AND td2.dim_week BETWEEN td1.dim_week - 52
                                                      AND td1.dim_week - 47))
                        AND td2.dim_day NOT IN ('Saturday', 'Sunday')
                  INNER JOIN course_dim cd
                     ON     cd.course_code = p_coursecode
                        AND SUBSTR (cd.country, 1, 2) = 'US'
            WHERE td1.dim_date = TO_DATE (p_date, 'yyyy-mm-dd')
         ORDER BY td2.dim_date);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
      RAISE;
END;
/


