DROP VIEW GKDW.GK_CITRIX_ONS_PRICE_V;

/* Formatted on 29/01/2021 11:40:46 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CITRIX_ONS_PRICE_V
(
   EVENT_ID,
   NUMSTUDENTS,
   CITRIX_LIST_PRICE
)
AS
   SELECT   ed.event_id,
            NVL (fdc.numstudents, ed.capacity) numstudents,
            20000 citrix_list_price    /** Requested change by John Nealis **/
     --       case when nvl(fdc.numstudents,ed.capacity) <= 10 then 21250
     --            else 25500
     --       end citrix_list_price
     FROM            event_dim ed
                  INNER JOIN
                     course_dim cd
                  ON ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
               LEFT OUTER JOIN
                  slxdw.gk_sales_opportunity so
               ON ed.opportunity_id = so.gk_sales_opportunityid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_fdc fdc
            ON so.current_idr = fdc.gk_onsitereq_idrid
               AND fdc.status NOT IN ('Rejected', 'Discarded')
    WHERE   cd.pl_num = '14' AND cd.ch_num = '20'
--select ed.event_id,
--       case when substr(cd.course_code,1,4) in ('8614','8615','8557','8558','8268') then 8
--            else 8
--       end numstudents,
--       case when substr(cd.course_code,1,4) = '8270' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 4995
--                    when substr(cd.course_code,1,4) = '8558' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 3195
--                    when substr(cd.course_code,1,4) = '8269' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 4995
--                    when substr(cd.course_code,1,4) = '8278' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 3195
--                    when substr(cd.course_code,1,4) = '8614' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 4995
--                    when substr(cd.course_code,1,4) = '8615' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 4995
--                    when substr(cd.course_code,1,4) = '8268' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 3995
--                    when substr(cd.course_code,1,4) = '8557' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 3195
--                    when substr(cd.course_code,1,4) = '8673' and ed.start_date < to_date('01/01/2012','mm/dd/yyyy') then 3195
--                    else cd2.list_price
--               end*case when substr(cd.course_code,1,4) in ('8614','8615','8557','8558','8268') then 8
--                        else 8
--                   end citrix_list_price
--  from event_dim ed
--       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
--       inner join course_dim cd2 on substr (cd.course_code, 1, 4) || 'C' = cd2.course_code and cd.country = cd2.country
-- where upper (cd.course_type) = 'CITRIX' and cd.ch_num = '20';;;


