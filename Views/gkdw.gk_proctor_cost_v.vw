DROP VIEW GKDW.GK_PROCTOR_COST_V;

/* Formatted on 29/01/2021 11:29:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROCTOR_COST_V
(
   COURSE_CODE,
   EVENT_ID,
   TOTAL_PROCTOR,
   STUDENT_CNT
)
AS
     SELECT   course_code,
              event_id,
              SUM (total_proctor_fee) total_proctor,
              SUM (student_cnt) student_cnt
       FROM   (  SELECT   ed.course_code,
                          ed.event_id,
                          SUM (pl.unit_price * pl.quantity) total_proctor_fee,
                          0 student_cnt
                   FROM            po_lines_all@r12prd pl
                                INNER JOIN
                                   po_distributions_all@r12prd pd
                                ON pl.po_line_id = pd.po_line_id
                             INNER JOIN
                                gl_code_combinations@r12prd gcc
                             ON pd.code_combination_id = gcc.code_combination_id
                          INNER JOIN
                             event_dim ed
                          ON pd.attribute2 = ed.event_id
                  WHERE   pl.creation_date >= TRUNC (SYSDATE) - 365
                          AND gcc.segment3 = '62305'
               GROUP BY   ed.course_code, ed.event_id
               UNION ALL
                 SELECT   ed.course_code,
                          ed.event_id,
                          0,
                          COUNT (DISTINCT f.enroll_id)
                   FROM               po_lines_all@r12prd pl
                                   INNER JOIN
                                      po_distributions_all@r12prd pd
                                   ON pl.po_line_id = pd.po_line_id
                                INNER JOIN
                                   gl_code_combinations@r12prd gcc
                                ON pd.code_combination_id =
                                      gcc.code_combination_id
                             INNER JOIN
                                event_dim ed
                             ON pd.attribute2 = ed.event_id
                          INNER JOIN
                             order_fact f
                          ON ed.event_id = f.event_id
                             AND f.enroll_status = 'Attended'
                  WHERE   pl.creation_date >= TRUNC (SYSDATE) - 365
                          AND gcc.segment3 = '62305'
               GROUP BY   ed.course_code, ed.event_id)
   GROUP BY   course_code, event_id
     HAVING   SUM (student_cnt) > 0;


