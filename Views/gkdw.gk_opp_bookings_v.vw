DROP VIEW GKDW.GK_OPP_BOOKINGS_V;

/* Formatted on 29/01/2021 11:31:15 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OPP_BOOKINGS_V (OPPORTUNITYID, BOOK_AMT)
AS
     SELECT   o.opportunityid, SUM (book_amt) book_amt
       FROM               slxdw.opportunity o
                       INNER JOIN
                          qg_oppcourses@slx qo
                       ON o.opportunityid = qo.opportunityid
                    INNER JOIN
                       slxdw.gk_sales_opportunity so
                    ON qo.gk_sales_opportunityid = so.gk_sales_opportunityid
                 INNER JOIN
                    event_dim ed
                 ON so.gk_sales_opportunityid = ed.opportunity_id
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
   GROUP BY   o.opportunityid
   UNION
     SELECT   o.opportunityid, SUM (book_amt) book_amt
       FROM         slxdw.opportunity o
                 INNER JOIN
                    event_dim ed
                 ON o.opportunityid = ed.opportunity_id
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
   GROUP BY   o.opportunityid;


