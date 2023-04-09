DROP PROCEDURE GKDW.GK_AUTO_SCHED_CREATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_auto_sched_create_proc(p_country varchar2,p_fiscal_year number) as

cursor c1 is
select td.fiscal_year,
       lpad(td.fiscal_quarter,2,'0') fiscal_qtr,
       lpad(td.fiscal_week,2,'0') fiscal_week,
       td.dim_year,
       lpad(td.dim_quarter,2,'0') dim_qtr,
       lpad(td.dim_week,2,'0') dim_week,
       min(dim_date) start_date,
       min(dim_date)+6 end_date,
       f.ops_country,
       f.facility_region_metro,
       f.internal_rooms,
       case when sched_total_rooms is not null then sched_total_rooms
            when f.internal_rooms < 3 then 10
            else round(f.internal_rooms*2)
       end total_rooms,
       nvl(f.comp_rooms,0) internal_comp,
       nvl(f.sched_comp_rooms,0) sched_comp,
       nvl(f.soft_rooms,0) internal_soft,
       nvl(f.sched_soft_rooms,0) sched_soft
  from time_dim td,
       gk_int_facility_rooms f
 where fiscal_year = p_fiscal_year
   and f.ops_country = p_country
   and dim_day = 'Monday'
 group by td.fiscal_year,lpad(td.fiscal_quarter,2,'0'),lpad(td.fiscal_week,2,'0'),td.dim_year,lpad(td.dim_quarter,2,'0'),lpad(td.dim_week,2,'0'),f.ops_country,f.facility_region_metro,f.internal_rooms,
          case when sched_total_rooms is not null then sched_total_rooms
            when f.internal_rooms < 3 then 10
            else round(f.internal_rooms*2)
          end,
          nvl(f.comp_rooms,0),nvl(f.soft_rooms,0),nvl(f.sched_comp_rooms,0),nvl(f.sched_soft_rooms,0)
 order by fiscal_year,fiscal_week,facility_region_metro;

cursor c2 is
select distinct country,nvl(duration_days,5) course_dur
  from gk_auto_sched_freq_v
 where country = p_country
 order by 2 desc;

cursor c3_btb is
select distinct s.country,s.course_pl,s.course_id,s.course_code,s.short_name,s.metro,s.course_type,
       s.year_dist,s.year_freq,s.last_week,
       case when to_number(s.last_week)+s.year_freq <= 52 then
            case when to_number(s.last_week)+(2*s.year_freq) <= 52 then
                 case when to_number(s.last_week)+(3*s.year_freq) <= 52 then 1
                      else case when to_number(s.last_week)+(3*s.year_freq) <= 52 then to_number(s.last_week)+(3*s.year_freq)
                                else to_number(s.last_week)+(3*s.year_freq)-52
                            end
                 end
                 else case when to_number(s.last_week)+(2*s.year_freq) <= 52 then to_number(s.last_week)+(2*s.year_freq)
                           else to_number(s.last_week)+(2*s.year_freq)-52
                      end
            end
            when to_number(s.last_week)+s.year_freq > 52 then to_number(s.last_week)+s.year_freq-52
            else to_number(s.last_week)+s.year_freq
       end start_week,
       cw.max_course_per_week,
       cw.max_pl_per_week,
       cw.max_type_per_week,
       mp.max_per_week max_metro_per_week,
       case when cd3.course_code is not null then 1
            else nvl(cc.course_priority,2)
       end priority,
       s.duration_days first_days,
       cd.duration_days sec_days,
       cd.course_code sec_course,
       cd.short_name sec_short,
       cd.course_pl sec_pl,
       cd.course_type sec_type,
       nvl(cd3.duration_days,0) third_days,
       s.duration_days+cd.duration_days+nvl(cd3.duration_days,0) total_days,
       cd3.course_code third_course,
       cd3.short_name third_short,
       cd3.course_pl third_pl,
       cd3.course_type third_type,
       case when s.course_pl = 'BUSINESS TRAINING' then 'Soft' else 'Technical' end skills_room_type
  from gk_auto_sched_freq_v s
       inner join gk_back_to_back_courses b on s.course_code = b.first_course
       inner join course_dim cd on b.second_course = cd.course_code and cd.country = s.country
       left outer join course_dim cd3 on b.third_course = cd3.course_code and cd3.country = s.country
       inner join gk_course_per_week_v cw on s.country = cw.country and s.course_code = cw.course_code
       inner join gk_course_metro_per_week_v mp on s.country = mp.country and s.metro = mp.metro
       left outer join gk_course_conflict cc on s.course_code = cc.base_course
 where s.country = p_country
 order by priority,s.year_freq,s.course_pl,s.course_code;

cursor c3(v_days number) is
select distinct s.country,s.course_pl,s.course_id,s.course_code,s.short_name,s.metro,s.course_type,
       s.year_dist,s.year_freq,s.last_week,
       case when to_number(s.last_week)+s.year_freq <= 52 then
            case when to_number(s.last_week)+(2*s.year_freq) <= 52 then
                 case when to_number(s.last_week)+(3*s.year_freq) <= 52 then 1
                      else case when to_number(s.last_week)+(3*s.year_freq) <= 52 then to_number(s.last_week)+(3*s.year_freq)
                                else to_number(s.last_week)+(3*s.year_freq)-52
                            end
                 end
                 else case when to_number(s.last_week)+(2*s.year_freq) <= 52 then to_number(s.last_week)+(2*s.year_freq)
                           else to_number(s.last_week)+(2*s.year_freq)-52
                      end
            end
            when to_number(s.last_week)+s.year_freq > 52 then to_number(s.last_week)+s.year_freq-52
            else to_number(s.last_week)+s.year_freq
       end start_week,
       cw.max_course_per_week,
       cw.max_pl_per_week,
       cw.max_type_per_week,
       mp.max_per_week max_metro_per_week,
       nvl(cc.course_priority,2) priority,
       case when s.course_pl = 'BUSINESS TRAINING' then 'Soft' else 'Technical' end skills_room_type
  from gk_auto_sched_freq_v s
       inner join gk_course_per_week_v cw on s.country = cw.country and s.course_code = cw.course_code
       inner join gk_course_metro_per_week_v mp on s.country = mp.country and s.metro = mp.metro
       left outer join gk_course_conflict cc on s.course_code = cc.base_course
 where s.country = p_country
   and s.duration_days = v_days
   and not exists (select 1 from gk_back_to_back_courses b where s.course_code = b.first_course or s.course_code = b.second_course or s.course_code = nvl(b.third_course,'NONE'))
   and not exists (select 1 from gk_nested_courses n where s.course_id = n.nested_course_id)
 order by priority,s.year_freq,s.course_pl,s.course_code;

cursor c4_gt_6(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,
       min(s1.room) avail_room
  from gk_auto_schedule s1
       inner join gk_auto_schedule s2 on s1.metro = s2.metro and s1.room = s2.room and s2.fiscal_week = s1.fiscal_week+1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and s2.mon_course is null
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by s1.fiscal_week asc,avail_room asc;

cursor c4_eq_5(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week  = s1.fiscal_week 
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by s1.fiscal_week asc,avail_room asc;

cursor c4_eq_4(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,'1-MON' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and s1.tue_course is null
   and s1.wed_course is null
   and s1.thu_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'2-TUE' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.tue_course is null
   and s1.wed_course is null
   and s1.thu_course is null
   and s1.fri_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.tue_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.tue_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.tue_pl = p_pl
           and s5.tue_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.tue_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by 1 asc,2 asc;

cursor c4_eq_3(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,'1-MON' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and s1.tue_course is null
   and s1.wed_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'2-TUE' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.tue_course is null
   and s1.wed_course is null
   and s1.thu_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.tue_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.tue_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.tue_pl = p_pl
           and s5.tue_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.tue_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'3-WED' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.wed_course is null
   and s1.thu_course is null
   and s1.fri_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.wed_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.wed_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.wed_pl = p_pl
           and s5.wed_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.wed_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by 1 asc,2 asc;

cursor c4_eq_2(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,'1-MON' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and s1.tue_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'2-TUE' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.tue_course is null
   and s1.wed_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.tue_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.tue_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.tue_pl = p_pl
           and s5.tue_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.tue_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'3-WED' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.wed_course is null
   and s1.thu_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.wed_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.wed_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.wed_pl = p_pl
           and s5.wed_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.wed_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'4-THU' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.thu_course is null
   and s1.fri_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.thu_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.thu_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.thu_pl = p_pl
           and s5.thu_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.thu_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by 1 asc,2 asc;

cursor c4_eq_1(p_course varchar2,p_metro varchar2,p_pl varchar2,p_type varchar2,p_min_week varchar2,p_max_course number,
               p_max_pl number,p_max_type number,p_max_metro number,p_skills_room_type varchar2) is
select s1.fiscal_week,'1-MON' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.mon_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.mon_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.mon_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.mon_pl = p_pl
           and s5.mon_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.mon_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'2-TUE' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.tue_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.tue_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.tue_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.tue_pl = p_pl
           and s5.tue_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.tue_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'3-WED' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.wed_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.wed_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.wed_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.wed_pl = p_pl
           and s5.wed_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.wed_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'4-THU' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.thu_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.thu_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.thu_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.thu_pl = p_pl
           and s5.thu_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.thu_course is not null) <= p_max_metro
 group by s1.fiscal_week
union
select s1.fiscal_week,'5-FRI' start_day,
       min(s1.room) avail_room
  from gk_auto_schedule s1
 where s1.country = p_country
   and s1.metro = p_metro
   and s1.fiscal_week >= p_min_week
   and s1.fri_course is null
   and nvl(s1.room_skill_type,p_skills_room_type) = p_skills_room_type
   and (select count(*) from gk_auto_schedule s3
         where s3.country = p_country
           and s3.fiscal_week = s1.fiscal_week
           and s3.fri_course = p_course) <= p_max_course
   and (select count(*) from gk_auto_schedule s4
         where s4.country = p_country
           and s4.fiscal_week = s1.fiscal_week
           and s4.fri_pl = p_pl) <= p_max_pl
   and (select count(*) from gk_auto_schedule s5
         where s5.country = p_country
           and s5.fiscal_week = s1.fiscal_week
           and s5.fri_pl = p_pl
           and s5.fri_type = p_type) <= p_max_type
   and (select count(*) from gk_auto_schedule s6
         where s6.country = p_country
           and s6.fiscal_week = s1.fiscal_week
           and s6.metro = s1.metro
           and s6.fri_course is not null) <= p_max_metro
 group by s1.fiscal_week
 order by 1 asc,2 asc;

valid_week varchar2(1) := 'N';
v_start date;
v_end date;
curr_day number;
curr_week varchar2(10);
curr_room varchar2(10);
r4_gt_6 c4_gt_6%rowtype;
r4_eq_5 c4_eq_5%rowtype;
r4_eq_4 c4_eq_4%rowtype;
r4_eq_3 c4_eq_3%rowtype;
r4_eq_2 c4_eq_2%rowtype;
r4_eq_1 c4_eq_1%rowtype;

begin
delete from gk_auto_schedule where country = p_country;
delete from gk_auto_schedule_output where country = p_country and fiscal_year = p_fiscal_year;
commit;

for r1 in c1 loop
  if r1.internal_comp > 0 then
    for i in 1..r1.internal_comp loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'Internal','Technical');
    end loop;

    for i in r1.internal_comp+1..r1.sched_comp loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'External','Technical');
    end loop;

    for i in r1.sched_comp+1..r1.sched_comp+r1.internal_soft loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'Internal','Soft');
    end loop;

    for i in r1.sched_comp+r1.internal_soft+1..r1.total_rooms loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'External','Soft');
    end loop;
  elsif r1.ops_country = 'CANADA' then
    for i in 1..trunc(r1.total_rooms/2) loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'External','Technical');
    end loop;

    for i in trunc(r1.total_rooms/2)+1..r1.total_rooms loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type,room_skill_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'External','Soft');
    end loop;    
  else
    for i in 1..r1.internal_rooms loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'Internal');
    end loop;

    for i in r1.internal_rooms+1..r1.total_rooms loop
      insert into gk_auto_schedule(dim_year,dim_qtr,dim_week,fiscal_year,fiscal_qtr,fiscal_week,start_date,country,metro,room,room_type)
      values
      (r1.dim_year,r1.dim_qtr,r1.dim_week,r1.fiscal_year,r1.fiscal_qtr,r1.fiscal_week,r1.start_date,r1.ops_country,r1.facility_region_metro,i,'External');
    end loop;
  end if;
end loop;
commit;

update gk_auto_schedule
   set mon_course = null,
       mon_short = null,
       mon_pl = null,
       mon_type = null,
       tue_course = null,
       tue_short = null,
       tue_pl = null,
       tue_type = null,
       wed_course = null,
       wed_short = null,
       wed_pl = null,
       wed_type = null,
       thu_course = null,
       thu_short = null,
       thu_pl = null,
       thu_type = null,
       fri_course = null,
       fri_short = null,
       fri_pl = null,
       fri_type = null
where country = p_country
  and fiscal_year = p_fiscal_year;

if p_country = 'USA' then 
  update gk_auto_schedule
     set mon_course = 'TC CLOSED'
   where start_date in ('29-MAY-2017','04-SEP-2017')
     and country = 'USA';

  update gk_auto_schedule
     set thu_course = 'TC CLOSED',
         fri_course = 'TC CLOSED'
   where start_date = '21-NOV-2016'
     and country = 'USA';

  update gk_auto_schedule
     set mon_course = 'TC CLOSED',
         tue_course = 'TC CLOSED',
         wed_course = 'TC CLOSED',
         thu_course = 'TC CLOSED',
         fri_course = 'TC CLOSED'
   where start_date = '03-JUL-2017'
     and country = 'USA';

  update gk_auto_schedule
     set mon_course = 'TC CLOSED',
         tue_course = 'TC CLOSED',
         wed_course = 'TC CLOSED',
         thu_course = 'TC CLOSED',
         fri_course = 'TC CLOSED'
   where start_date in ('26-DEC-2016')
     and country = 'USA';

  update gk_auto_schedule
     set mon_course = 'TC CLOSED'
   where start_date in ('02-JAN-2017')
     and country = 'USA';
     
elsif p_country = 'CANADA' then
  update gk_auto_schedule
     set mon_course = 'TC CLOSED'
   where start_date in ('22-MAY-2017','31-JUL-2017','04-SEP-2017','10-OCT-2016')
     and country = 'CANADA';
     
  update gk_auto_schedule
     set fri_course = 'TC CLOSED'
   where start_date in ('26-JUN-2017');

  update gk_auto_schedule
     set mon_course = 'TC CLOSED',
         tue_course = 'TC CLOSED',
         wed_course = 'TC CLOSED',
         thu_course = 'TC CLOSED',
         fri_course = 'TC CLOSED'
   where start_date in ('19-DEC-2016','26-DEC-2016')
     and country = 'CANADA';
     
  update gk_auto_schedule
     set mon_course = 'TC CLOSED'
   where start_date in ('02-JAN-2017')
     and country = 'CANADA';

  update gk_auto_schedule
     set mon_course = 'TC CLOSED'
   where start_date = '14-FEB-2017'
     and metro in ('OTT','TOR','MSS','KIT','CHT','WIN','EDM','CAL','REG');

  update gk_auto_schedule
     set wed_course = 'TC CLOSED'
   where start_date = '26-JUN-2017'
     and metro in ('STF');

  update gk_auto_schedule
     set fri_course = 'TC CLOSED'
   where start_date = '07-NOV-2016'
     and metro not in ('MTL','QBC','OTT','TOR','MSS','KIT','CHT');

end if;
commit;

/****** SCHEDULE ALL BTB CLASSES FIRST *******/
for r3_btb in c3_btb loop
  if lpad(r3_btb.start_week,2,'0') = '01' then
    curr_week := '02';
  else
    curr_week := lpad(r3_btb.start_week,2,'0');
  end if;
    
  for i in 1..r3_btb.year_dist loop
  
    if r3_btb.total_days >= 4 then
      open c4_eq_5(r3_btb.course_code,r3_btb.metro,r3_btb.course_pl,r3_btb.course_type,curr_week,r3_btb.max_course_per_week,
                  r3_btb.max_pl_per_week,r3_btb.max_type_per_week,r3_btb.max_metro_per_week,r3_btb.skills_room_type);
      fetch c4_eq_5 into r4_eq_5;

      if c4_eq_5%found then

        curr_day := 1;
        gk_assign_btb_proc(r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,r3_btb.first_days,
                           r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,r3_btb.sec_days,
                           r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,r3_btb.third_days,p_fiscal_year,
                           r4_eq_5.fiscal_week,r3_btb.country,r3_btb.metro,r4_eq_5.avail_room,curr_day,r3_btb.year_dist,r3_btb.year_freq);
      else
        dbms_output.put_line('EVENT NOT SCHEDULED: '||r3_btb.metro||' - '||r3_btb.course_code||'('||r3_btb.short_name||') - '||curr_week);

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,
                 r3_btb.first_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.first_days > 0
           group by dim_year,dim_week;

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,
                 r3_btb.sec_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.sec_days > 0
           group by dim_year,dim_week;

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,
                 r3_btb.third_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.third_days > 0
           group by dim_year,dim_week;
             
      end if;
      close c4_eq_5;
    elsif r3_btb.total_days = 3 then
      open c4_eq_3(r3_btb.course_code,r3_btb.metro,r3_btb.course_pl,r3_btb.course_type,curr_week,r3_btb.max_course_per_week,
                   r3_btb.max_pl_per_week,r3_btb.max_type_per_week,r3_btb.max_metro_per_week,r3_btb.skills_room_type);
      fetch c4_eq_3 into r4_eq_3;

      if c4_eq_3%found then
        if r4_eq_3.start_day = '1-MON' then
          curr_day := 1;
        elsif r4_eq_3.start_day = '2-TUE' then
          curr_day := 2;
        elsif r4_eq_3.start_day = '3-WED' then
          curr_day := 3;
        end if;

        gk_assign_btb_proc(r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,r3_btb.first_days,
                           r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,r3_btb.sec_days,
                           r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,r3_btb.third_days,p_fiscal_year,
                           r4_eq_3.fiscal_week,r3_btb.country,r3_btb.metro,r4_eq_3.avail_room,curr_day,r3_btb.year_dist,r3_btb.year_freq);
      else
        dbms_output.put_line('EVENT NOT SCHEDULED: '||r3_btb.metro||' - '||r3_btb.course_code||'('||r3_btb.short_name||') - '||curr_week);

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,
                 r3_btb.first_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.first_days > 0
           group by dim_year,dim_week;

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,
                 r3_btb.sec_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.sec_days > 0
           group by dim_year,dim_week;

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,
                 r3_btb.third_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.third_days > 0
           group by dim_year,dim_week;
      end if;
      close c4_eq_3;
    elsif r3_btb.total_days = 2 then
    
      open c4_eq_2(r3_btb.course_code,r3_btb.metro,r3_btb.course_pl,r3_btb.course_type,curr_week,r3_btb.max_course_per_week,
                   r3_btb.max_pl_per_week,r3_btb.max_type_per_week,r3_btb.max_metro_per_week,r3_btb.skills_room_type);
      fetch c4_eq_2 into r4_eq_2;    

      if c4_eq_2%found then

        if r4_eq_2.start_day = '1-MON' then
          curr_day := 1;
        elsif r4_eq_2.start_day = '2-TUE' then
          curr_day := 2;
        elsif r4_eq_2.start_day = '3-WED' then
          curr_day := 3;
        elsif r4_eq_2.start_day = '4-THU' then
          curr_day := 4;
        end if;

        gk_assign_btb_proc(r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,r3_btb.first_days,
                           r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,r3_btb.sec_days,
                           r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,r3_btb.third_days,p_fiscal_year,
                           r4_eq_2.fiscal_week,r3_btb.country,r3_btb.metro,r4_eq_2.avail_room,curr_day,r3_btb.year_dist,r3_btb.year_freq);
      else
        dbms_output.put_line('EVENT NOT SCHEDULED: '||r3_btb.metro||' - '||r3_btb.course_code||'('||r3_btb.short_name||') - '||curr_week);

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.course_code,r3_btb.short_name,r3_btb.course_pl,r3_btb.course_type,
                 r3_btb.first_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.first_days > 0
           group by dim_year,dim_week;

        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.sec_course,r3_btb.sec_short,r3_btb.sec_pl,r3_btb.sec_type,
                 r3_btb.sec_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.sec_days > 0
           group by dim_year,dim_week;
             
        insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3_btb.metro,null,r3_btb.third_course,r3_btb.third_short,r3_btb.third_pl,r3_btb.third_type,
                 r3_btb.third_days,null,null,r3_btb.year_dist,r3_btb.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
             and r3_btb.third_days > 0
           group by dim_year,dim_week;
      end if;
      close c4_eq_2;
    end if;
    commit;
    if curr_week+r3_btb.year_freq > 51 then 
      curr_week := '02';
    else 
      curr_week := lpad(curr_week+r3_btb.year_freq,2,'0');
    end if;
  end loop;
end loop;

/**** SCHEDULE NON-BTB CLASSES ******/

for r2 in c2 loop
  for r3 in c3(r2.course_dur) loop
    curr_week := lpad(r3.start_week,2,'0');

    for i in 1..r3.year_dist loop
/****** IF CONDITION FOR ALL COURSES WITH DURATION GT SIX DAYS *******/
      if r2.course_dur > 6 then
        open c4_gt_6(r3.country,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_gt_6 into r4_gt_6;
        if c4_gt_6%found then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type,
                 tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type,
                 fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_gt_6.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_gt_6.avail_room;

          insert into gk_auto_schedule_output
          select td.dim_year,td.dim_week,p_fiscal_year,r4_gt_6.fiscal_week,p_country,r3.metro,r4_gt_6.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 case when r2.course_dur = 12 then 12
                      when r2.course_dur between 8 and 10 then r2.course_dur+2
                      else r2.course_dur
                 end,td.dim_date,
                 td.dim_date+case when r2.course_dur = 12 then 12
                                  when r2.course_dur between 8 and 10 then r2.course_dur+2
                                  else r2.course_dur
                             end-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_gt_6.fiscal_week
             and dim_day = 'Monday';

          if r2.course_dur in (10,12) then
            update gk_auto_schedule
               set mon_course = r3.course_code,
                   mon_short = r3.short_name,
                   mon_pl = r3.course_pl,
                   mon_type = r3.course_type,
                   tue_course = r3.course_code,
                   tue_short = r3.short_name,
                   tue_pl = r3.course_pl,
                   tue_type = r3.course_type,
                   wed_course = r3.course_code,
                   wed_short = r3.short_name,
                   wed_pl = r3.course_pl,
                   wed_type = r3.course_type,
                   thu_course = r3.course_code,
                   thu_short = r3.short_name,
                   thu_pl = r3.course_pl,
                   thu_type = r3.course_type,
                   fri_course = r3.course_code,
                   fri_short = r3.short_name,
                   fri_pl = r3.course_pl,
                   fri_type = r3.course_type
             where fiscal_week = lpad(r4_gt_6.fiscal_week+1,2,'0')
               and country = r3.country
               and metro = r3.metro
               and room = r4_gt_6.avail_room;
          elsif r2.course_dur = 9 then
            update gk_auto_schedule
               set mon_course = r3.course_code,
                   mon_short = r3.short_name,
                   mon_pl = r3.course_pl,
                   mon_type = r3.course_type,
                   tue_course = r3.course_code,
                   tue_short = r3.short_name,
                   tue_pl = r3.course_pl,
                   tue_type = r3.course_type,
                   wed_course = r3.course_code,
                   wed_short = r3.short_name,
                   wed_pl = r3.course_pl,
                   wed_type = r3.course_type,
                   thu_course = r3.course_code,
                   thu_short = r3.short_name,
                   thu_pl = r3.course_pl,
                   thu_type = r3.course_type
             where fiscal_week = lpad(r4_gt_6.fiscal_week+1,2,'0')
               and country = r3.country
               and metro = r3.metro
               and room = r4_gt_6.avail_room;
          elsif r2.course_dur = 8 then
            update gk_auto_schedule
               set mon_course = r3.course_code,
                   mon_short = r3.short_name,
                   mon_pl = r3.course_pl,
                   mon_type = r3.course_type,
                   tue_course = r3.course_code,
                   tue_short = r3.short_name,
                   tue_pl = r3.course_pl,
                   tue_type = r3.course_type,
                   wed_course = r3.course_code,
                   wed_short = r3.short_name,
                   wed_pl = r3.course_pl,
                   wed_type = r3.course_type
             where fiscal_week = lpad(r4_gt_6.fiscal_week+1,2,'0')
               and country = r3.country
               and metro = r3.metro
               and room = r4_gt_6.avail_room;
          end if;
          commit;
        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
           group by dim_year,dim_week;

        end if;
        close c4_gt_6;
/****** IF CONDITION FOR ALL COURSES WITH DURATION EQ FIVE DAYS *******/
      elsif r2.course_dur = 5 then
        open c4_eq_5(r3.course_code,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_eq_5 into r4_eq_5;
        if c4_eq_5%found then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type,
                 tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type,
                 fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_eq_5.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_5.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_5.fiscal_week,p_country,r3.metro,r4_eq_5.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_5.fiscal_week
             and dim_day = 'Monday';

        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
           group by dim_year,dim_week;

        end if;
        close c4_eq_5;
        commit;
/****** IF CONDITION FOR ALL COURSES WITH DURATION EQ FOUR DAYS *******/
      elsif r2.course_dur = 4 then
        open c4_eq_4(r3.course_code,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_eq_4 into r4_eq_4;
        if c4_eq_4%found and r4_eq_4.start_day = '1-MON' then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type,
                 tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type
           where fiscal_week = lpad(r4_eq_4.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_4.avail_room;

          insert into gk_auto_schedule_output
          select td.dim_year,td.dim_week,p_fiscal_year,r4_eq_4.fiscal_week,p_country,r3.metro,r4_eq_4.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_4.fiscal_week
             and dim_day = 'Monday';

        elsif c4_eq_4%found and r4_eq_4.start_day = '2-TUE' then
          update gk_auto_schedule
             set tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type,
                 fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_eq_4.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_4.avail_room;

          insert into gk_auto_schedule_output
          select td.dim_year,td.dim_week,p_fiscal_year,r4_eq_4.fiscal_week,p_country,r3.metro,r4_eq_4.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_4.fiscal_week
             and dim_day = 'Tuesday';
        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
            group by dim_year,dim_week;

        end if;
        close c4_eq_4;
        commit;
/****** IF CONDITION FOR ALL COURSES WITH DURATION EQ THREE DAYS *******/
      elsif r2.course_dur = 3 then
        open c4_eq_3(r3.course_code,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_eq_3 into r4_eq_3;
        if c4_eq_3%found and r4_eq_3.start_day = '1-MON' then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type,
                 tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type
           where fiscal_week = lpad(r4_eq_3.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_3.avail_room;

          insert into gk_auto_schedule_output
          select td.dim_year,td.dim_week,p_fiscal_year,r4_eq_3.fiscal_week,p_country,r3.metro,r4_eq_3.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_3.fiscal_week
             and dim_day = 'Monday';

        elsif c4_eq_3%found and r4_eq_3.start_day = '2-TUE' then
          update gk_auto_schedule
             set tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type
           where fiscal_week = lpad(r4_eq_3.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_3.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_3.fiscal_week,p_country,r3.metro,r4_eq_3.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_3.fiscal_week
             and dim_day = 'Tuesday';

        elsif c4_eq_3%found and r4_eq_3.start_day = '3-WED' then
          update gk_auto_schedule
             set wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type,
                 fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_eq_3.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_3.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_3.fiscal_week,p_country,r3.metro,r4_eq_3.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_3.fiscal_week
             and dim_day = 'Wednesday';
        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
           group by dim_year,dim_week;

        end if;
        close c4_eq_3;
        commit;
/****** IF CONDITION FOR ALL COURSES WITH DURATION EQ TWO DAYS *******/
      elsif r2.course_dur = 2 then
        open c4_eq_2(r3.course_code,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_eq_2 into r4_eq_2;
        if c4_eq_2%found and r4_eq_2.start_day = '1-MON' then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type,
                 tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type
           where fiscal_week = lpad(r4_eq_2.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_2.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_2.fiscal_week,p_country,r3.metro,r4_eq_2.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_2.fiscal_week
             and dim_day = 'Monday';

        elsif c4_eq_2%found and r4_eq_2.start_day = '2-TUE' then
          update gk_auto_schedule
             set tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type,
                 wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type
           where fiscal_week = lpad(r4_eq_2.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_2.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_2.fiscal_week,p_country,r3.metro,r4_eq_2.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_2.fiscal_week
             and dim_day = 'Tuesday';

        elsif c4_eq_2%found and r4_eq_2.start_day = '3-WED' then
          update gk_auto_schedule
             set wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type,
                 thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type
           where fiscal_week = lpad(r4_eq_2.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_2.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_2.fiscal_week,p_country,r3.metro,r4_eq_2.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_2.fiscal_week
             and dim_day = 'Wednesday';

        elsif c4_eq_2%found and r4_eq_2.start_day = '4-THU' then
          update gk_auto_schedule
             set thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type,
                 fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_eq_2.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_2.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_2.fiscal_week,p_country,r3.metro,r4_eq_2.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_2.fiscal_week
             and dim_day = 'Thursday';

        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
           group by dim_year,dim_week;

        end if;
        close c4_eq_2;
        commit;
/****** IF CONDITION FOR ALL COURSES WITH DURATION EQ ONE DAYS *******/
      elsif r2.course_dur = 1 then
        open c4_eq_1(r3.course_code,r3.metro,r3.course_pl,r3.course_type,curr_week,r3.max_course_per_week,r3.max_pl_per_week,
                     r3.max_type_per_week,r3.max_metro_per_week,r3.skills_room_type);
        fetch c4_eq_1 into r4_eq_1;
        if c4_eq_1%found and r4_eq_1.start_day = '1-MON' then
          update gk_auto_schedule
             set mon_course = r3.course_code,
                 mon_short = r3.short_name,
                 mon_pl = r3.course_pl,
                 mon_type = r3.course_type
           where fiscal_week = lpad(r4_eq_1.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_1.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_1.fiscal_week,p_country,r3.metro,r4_eq_1.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_1.fiscal_week
             and dim_day = 'Monday';

        elsif c4_eq_1%found and r4_eq_1.start_day = '2-TUE' then
          update gk_auto_schedule
             set tue_course = r3.course_code,
                 tue_short = r3.short_name,
                 tue_pl = r3.course_pl,
                 tue_type = r3.course_type
           where fiscal_week = lpad(r4_eq_1.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_1.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_1.fiscal_week,p_country,r3.metro,r4_eq_1.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_1.fiscal_week
             and dim_day = 'Tuesday';

        elsif c4_eq_1%found and r4_eq_1.start_day = '3-WED' then
          update gk_auto_schedule
             set wed_course = r3.course_code,
                 wed_short = r3.short_name,
                 wed_pl = r3.course_pl,
                 wed_type = r3.course_type
           where fiscal_week = lpad(r4_eq_1.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_1.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_1.fiscal_week,p_country,r3.metro,r4_eq_1.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_1.fiscal_week
             and dim_day = 'Wednesday';

        elsif c4_eq_1%found and r4_eq_1.start_day = '4-THU' then
          update gk_auto_schedule
             set thu_course = r3.course_code,
                 thu_short = r3.short_name,
                 thu_pl = r3.course_pl,
                 thu_type = r3.course_type
           where fiscal_week = lpad(r4_eq_1.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_1.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_1.fiscal_week,p_country,r3.metro,r4_eq_1.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_1.fiscal_week
             and dim_day = 'Thursday';

        elsif c4_eq_1%found and r4_eq_1.start_day = '5-FRI' then
          update gk_auto_schedule
             set fri_course = r3.course_code,
                 fri_short = r3.short_name,
                 fri_pl = r3.course_pl,
                 fri_type = r3.course_type
           where fiscal_week = lpad(r4_eq_1.fiscal_week,2,'0')
             and country = r3.country
             and metro = r3.metro
             and room = r4_eq_1.avail_room;

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,r4_eq_1.fiscal_week,p_country,r3.metro,r4_eq_1.avail_room,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,td.dim_date,td.dim_date+r2.course_dur-1,
                 r3.year_dist,r3.year_freq,'Event Scheduled'
            from time_dim td
           where fiscal_year = p_fiscal_year
             and fiscal_week = r4_eq_1.fiscal_week
             and dim_day = 'Friday';

        else
          dbms_output.put_line('EVENT NOT SCHEDULED: '||r3.metro||' - '||r3.course_code||'('||r3.short_name||') - '||curr_week);

          insert into gk_auto_schedule_output
          select dim_year,dim_week,p_fiscal_year,curr_week,p_country,r3.metro,null,r3.course_code,r3.short_name,r3.course_pl,r3.course_type,
                 r2.course_dur,null,null,r3.year_dist,r3.year_freq,'Rejected - Event Not Scheduled'
            from time_dim
           where fiscal_year = p_fiscal_year
             and fiscal_week = curr_week
           group by dim_year,dim_week;

        end if;
        close c4_eq_1;
        commit;
      end if;
      if curr_week+r3.year_freq > 51 then
        curr_week := '02';
      else 
        curr_week := lpad(curr_week+r3.year_freq,2,'0');
      end if;
    end loop;
  end loop;
end loop;
commit;

end;
/


