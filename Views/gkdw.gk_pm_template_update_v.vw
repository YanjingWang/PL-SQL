DROP VIEW GKDW.GK_PM_TEMPLATE_UPDATE_V;

/* Formatted on 29/01/2021 11:30:24 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PM_TEMPLATE_UPDATE_V
(
   COUNTRY,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   DURATION_DAYS,
   SCHED_10,
   EV_10,
   EN_10,
   BOOK_10
)
AS
   SELECT   h.country,
            h.course_ch,
            h.course_mod,
            h.course_pl,
            h.course_type,
            h.course_id,
            h.course_code,
            h.short_name,
            h.duration_days,
            h.sched_10,
            h.ev_10,
            h.en_10,
            h.book_10
     --       case when h.sched_10 > 0 then nvl(p.sched_cnt_plan,0) else 0 end sched_cnt_plan,
     --       case when h.sched_10 > 0 then nvl(p.ev_cnt_plan,0) else 0 end ev_cnt_plan,
     --       case when h.sched_10 > 0 then nvl(p.en_cnt_plan,0) else 0 end en_cnt_plan,
     --       case when h.sched_10 > 0 then
     --            case when nvl(p.ev_cnt_plan,0) = 0 then 0 else p.en_cnt_plan/ev_cnt_plan end
     --            else 0
     --       end fill_plan
     FROM      gk_pm_course_hist_mv h
            LEFT OUTER JOIN
               gk_pm_course_plan_mv p
            ON h.course_id = p.course_id AND h.country = p.country
    WHERE   h.sched_10 > 0
   MINUS
   SELECT   country,
            course_ch,
            course_mod,
            course_pl,
            course_type,
            course_id,
            course_code,
            short_name,
            duration_days,
            sched_10,
            ev_10,
            en_10,
            book_10
     --       sched_cnt_plan,ev_cnt_plan,en_cnt_plan,fill_plan
     FROM   gk_pm_template;


