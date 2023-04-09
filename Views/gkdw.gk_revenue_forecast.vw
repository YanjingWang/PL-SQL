DROP VIEW GKDW.GK_REVENUE_FORECAST;

/* Formatted on 29/01/2021 11:27:52 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REVENUE_FORECAST
(
   EVENT_ID,
   EVENT_DESC,
   COURSE_ID,
   COURSE_CODE,
   START_DATE,
   END_DATE,
   FACILITY_CODE,
   METRO_AREA,
   ZIPCODE,
   OPS_COUNTRY,
   INTERNALFACILITY,
   CAPACITY,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   LE_NUM,
   FE_NUM,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   ACT_NUM,
   ENROLL_STATUS,
   ENROLL_CNT,
   BOOK_AMT
)
AS
     SELECT   ed.event_id,
                 ed.course_id
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (start_date, 'yymmdd')
                 event_desc,
              ed.course_id,
              ed.course_code,
              start_date,
              end_date,
              facility_code,
              facility_region_metro metro_area,
              ed.zipcode,
              ops_country,
              internalfacility,
              ed.capacity,
              cd.course_ch,
              cd.course_mod,
              cd.course_pl,
              le_num,
              fe_num,
              ch_num,
              md_num,
              pl_num,
              act_num,
              f.enroll_status,
              COUNT (enroll_id) enroll_cnt,
              SUM (book_amt) book_amt
       FROM         event_dim ed
                 LEFT OUTER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              LEFT OUTER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       ed.status != 'Cancelled'
              AND f.enroll_status != 'Cancelled'
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
   GROUP BY   ed.event_id,
                 ed.course_id
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (start_date, 'yymmdd'),
              ed.course_id,
              ed.course_code,
              start_date,
              end_date,
              facility_code,
              facility_region_metro,
              ed.zipcode,
              ops_country,
              internalfacility,
              ed.capacity,
              cd.course_ch,
              cd.course_mod,
              cd.course_pl,
              le_num,
              fe_num,
              ch_num,
              md_num,
              pl_num,
              act_num,
              f.enroll_status;


