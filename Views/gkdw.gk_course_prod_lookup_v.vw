DROP VIEW GKDW.GK_COURSE_PROD_LOOKUP_V;

/* Formatted on 29/01/2021 11:39:24 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_PROD_LOOKUP_V
(
   CH_NUM,
   MD_NUM,
   PL_NUM,
   ACT_NUM,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE
)
AS
   SELECT   ch_num,
            md_num,
            pl_num,
            act_num,
            course_ch,
            course_mod,
            course_pl,
            course_type
     FROM   (SELECT   ch_num,
                      md_num,
                      pl_num,
                      act_num,
                      course_ch,
                      course_mod,
                      course_pl,
                      course_type
               FROM   course_dim c1
              WHERE   ROWID =
                         (SELECT   MAX (ROWID)
                            FROM   course_dim c2
                           WHERE       c1.ch_num = c2.ch_num
                                   AND c1.pl_num = c2.pl_num
                                   AND c1.md_num = c2.md_num
                                   AND c1.act_num = c2.act_num)
             UNION
             SELECT   ch_num,
                      md_num,
                      pl_num,
                      act_num,
                      prod_channel,
                      prod_modality,
                      prod_line,
                      prod_family
               FROM   product_dim p1
              WHERE   ROWID =
                         (SELECT   MAX (ROWID)
                            FROM   product_dim p2
                           WHERE       p1.ch_num = p2.ch_num
                                   AND p1.pl_num = p2.pl_num
                                   AND p1.md_num = p2.md_num
                                   AND p1.act_num = p2.act_num))
--select distinct short_name,course_type,ch_num,md_num,pl_num,act_num,course_ch,course_mod,course_pl
--  from course_dim
-- where gkdw_source = 'SLXDW'
-- and inactive_flag = 'F'
-- and substr(course_code,5,1) not in ('T','P')
-- and md_num not in ('31')
-- and course_id not in ('Q6UJ9A0A7QB7','Q6UJ9A3XY6J9','Q6UJ9A3UPOWH','Q6UJ9A3UPOWG','Q6UJ9A04KNC0','Q6UJ9A072GND')
-- and nvl(act_num,'000000') != '000000'
--union
--select distinct prod_name,prod_family,ch_num,md_num,pl_num,act_num,prod_channel,prod_modality,prod_line
--  from product_dim
-- where gkdw_source = 'SLXDW'
--   and status = 'Available'
--    and nvl(act_num,'000000') != '000000'
--   and product_id not in ('Y6UJ9A0005KA');;


