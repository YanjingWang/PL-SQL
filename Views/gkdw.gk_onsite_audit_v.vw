DROP VIEW GKDW.GK_ONSITE_AUDIT_V;

/* Formatted on 29/01/2021 11:31:36 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ONSITE_AUDIT_V
(
   EVENT_ID,
   COURSE_CODE,
   COURSE_NAME,
   CREATION_DATE,
   START_DATE,
   END_DATE,
   STATUS,
   PROD_LINE,
   OPS_COUNTRY,
   OPP_DESC,
   ENROLL_ID,
   ENROLL_DATE,
   OPPORTUNITY_ID,
   FDC_COMPANY,
   FDC_BASE_PRICE,
   FDC_ADD_STUD,
   FDC_OTHER,
   ENROLL_CNT,
   BOOK_AMT
)
AS
     SELECT   ed.event_id,
              cd.course_code,
              cd.course_name,
              ed.creation_date,
              ed.start_date,
              ed.end_date,
              ed.status,
              course_pl prod_line,
              ed.ops_country,
              od.description opp_desc,
              f.enroll_id,
              f.enroll_date,
              f.opportunity_id,
              fd.sold_to_company fdc_company,
              fd.base_price fdc_base_price,
              fd.add_student fdc_add_stud,
              fd.other_fee fdc_other,
              COUNT (f.enroll_id) enroll_cnt,
              SUM (f.book_amt) book_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.country = cd.country
                          LEFT OUTER JOIN
                             order_fact f
                          ON ed.event_id = f.event_id AND f.book_amt != 0
                       LEFT OUTER JOIN
                          ons.idr@r12prd i
                       ON f.opportunity_id = i.slx_opp_id
                    LEFT OUTER JOIN
                       ons.customer_onsite@r12prd c
                    ON i.idr_num = c.idr_num AND status_code = 'A'
                 LEFT OUTER JOIN
                    ons.fdc@r12prd fd
                 ON c.onsite_id = fd.onsite_id
              LEFT OUTER JOIN
                 opportunity_dim od
              ON ed.opportunity_id = od.opportunity_id
      WHERE   SUBSTR (cd.course_code, 5, 1) IN ('N', 'V', 'H')
              AND ed.status IN ('Open', 'Verified')
   --and ed.creation_date >= to_date('7/17/2006','mm/dd/yyyy')
   GROUP BY   ed.event_id,
              ed.course_id,
              ed.creation_date,
              ed.start_date,
              ed.end_date,
              ed.status,
              cd.course_code,
              cd.course_name,
              course_pl,
              ed.ops_country,
              od.description,
              f.enroll_id,
              f.enroll_date,
              f.opportunity_id,
              fd.submit_date,
              fd.sold_to_company,
              fd.base_price,
              fd.add_student,
              fd.other_fee
   --having count(f.enroll_id) = 0
   ORDER BY   ed.ops_country, ed.start_date;


