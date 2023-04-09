DROP VIEW GKDW.GK_INSTRUCTOR_RATE_PL_V;

/* Formatted on 29/01/2021 11:34:22 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INSTRUCTOR_RATE_PL_V
(
   CUST_ID,
   CUST_NAME,
   ACCT_NAME,
   COUNTRY,
   COURSE_PL,
   RATE_PLAN,
   RATE,
   VAR_EXEMPT,
   THIRD_PARTY_VENDOR,
   PAY_CURR_CODE,
   FIRST_NAME,
   LAST_NAME,
   SPEC_INST
)
AS
     SELECT   i.cust_id,
              i.cust_name,
              i.acct_name,
              UPPER (i.country) country,
              cd.course_pl,
              c.rate_plan,
              c.rate,
              ii.var_exempt,
              ii.third_party_vendor,
              ii.pay_curr_code,
              c.first_name,
              c.last_name,
              ii.spec_inst
       FROM                        event_dim ed
                                INNER JOIN
                                   course_dim cd
                                ON ed.course_id = cd.course_id
                                   AND ed.ops_country = cd.country
                             INNER JOIN
                                instructor_event_v ie
                             ON ed.event_id = ie.evxeventid
                          INNER JOIN
                             instructor_dim i
                          ON ie.contactid = i.cust_id
                       INNER JOIN
                          cust_dim c
                       ON ie.contactid = c.cust_id
                    INNER JOIN
                       gk_inst_course_rate_mv c
                    ON i.cust_id = c.instructor_id
                       AND cd.course_id = c.evxcourseid
                 INNER JOIN
                    rmsdw.rms_instructor ri
                 ON i.cust_id = ri.slx_contact_id AND ri.status = 'yes'
              INNER JOIN
                 inst_instructor@gkprod ii
              ON ie.contactid = ii.instructor_id
      WHERE   c.end_date >= TRUNC (SYSDATE)
   GROUP BY   i.cust_id,
              i.cust_name,
              i.acct_name,
              cd.course_pl,
              c.rate_plan,
              c.rate,
              UPPER (i.country),
              ii.var_exempt,
              ii.third_party_vendor,
              ii.pay_curr_code,
              c.first_name,
              c.last_name,
              ii.spec_inst
   ORDER BY   country,
              cust_id,
              course_pl,
              rate_plan;


