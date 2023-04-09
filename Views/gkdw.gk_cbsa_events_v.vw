DROP VIEW GKDW.GK_CBSA_EVENTS_V;

/* Formatted on 29/01/2021 11:41:51 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CBSA_EVENTS_V
(
   CBSA_CODE,
   CBSA_NAME,
   EV_06,
   EV_07,
   EV_08,
   EV_09,
   EV_10
)
AS
     SELECT   cbsa_code,
              cbsa_name,
              SUM (events_06) ev_06,
              SUM (events_07) ev_07,
              SUM (events_08) ev_08,
              SUM (events_09) ev_09,
              SUM (events_10) ev_10
       FROM   (  SELECT   cbsa_code,
                          cbsa_name,
                          COUNT (DISTINCT ed.event_id) events_06,
                          0 events_07,
                          0 events_08,
                          0 events_09,
                          0 events_10
                   FROM         gk_cbsa c
                             INNER JOIN
                                event_dim ed
                             ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
                          INNER JOIN
                             course_dim cd
                          ON     ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                             AND cd.md_num IN ('10', '41')
                  WHERE   ed.start_date BETWEEN '01-DEC-2006' AND '31-DEC-2006'
               GROUP BY   cbsa_code, cbsa_name
               UNION ALL
                 SELECT   cbsa_code,
                          cbsa_name,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          0,
                          0,
                          0
                   FROM         gk_cbsa c
                             INNER JOIN
                                event_dim ed
                             ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
                          INNER JOIN
                             course_dim cd
                          ON     ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                             AND cd.md_num IN ('10', '41')
                  WHERE   ed.start_date BETWEEN '01-DEC-2007' AND '31-DEC-2007'
               GROUP BY   cbsa_code, cbsa_name
               UNION ALL
                 SELECT   cbsa_code,
                          cbsa_name,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          0,
                          0
                   FROM         gk_cbsa c
                             INNER JOIN
                                event_dim ed
                             ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
                          INNER JOIN
                             course_dim cd
                          ON     ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                             AND cd.md_num IN ('10', '41')
                  WHERE   ed.start_date BETWEEN '01-DEC-2008' AND '31-DEC-2008'
               GROUP BY   cbsa_code, cbsa_name
               UNION ALL
                 SELECT   cbsa_code,
                          cbsa_name,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          0
                   FROM         gk_cbsa c
                             INNER JOIN
                                event_dim ed
                             ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
                          INNER JOIN
                             course_dim cd
                          ON     ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                             AND cd.md_num IN ('10', '41')
                  WHERE   ed.start_date BETWEEN '01-DEC-2009' AND '31-DEC-2009'
               GROUP BY   cbsa_code, cbsa_name
               UNION ALL
                 SELECT   cbsa_code,
                          cbsa_name,
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id)
                   FROM         gk_cbsa c
                             INNER JOIN
                                event_dim ed
                             ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
                          INNER JOIN
                             course_dim cd
                          ON     ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                             AND cd.md_num IN ('10', '41')
                  WHERE   ed.start_date BETWEEN '01-DEC-2010' AND '31-DEC-2010'
               GROUP BY   cbsa_code, cbsa_name)
   GROUP BY   cbsa_code, cbsa_name;


