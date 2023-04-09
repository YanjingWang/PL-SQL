DROP PROCEDURE GKDW.GK_ASSIGN_BTB_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_assign_btb_proc
(p_first_course varchar2,p_first_short varchar2,p_first_pl varchar2,p_first_type varchar2,p_first_days number,
 p_sec_course varchar2,p_sec_short varchar2,p_sec_pl varchar2,p_sec_type varchar2,p_sec_days number,
 p_third_course varchar2,p_third_short varchar2,p_third_pl varchar2,p_third_type varchar2,p_third_days number,
 p_fiscal_year number,p_fiscal_week varchar2,p_country varchar2,p_metro varchar2,p_avail_room number,p_start_day number,
 p_year_dist number,p_year_freq number) as
                
curr_day number;
v_start date;
v_year number;
v_week varchar2(2);

begin
curr_day := p_start_day;

select dim_date into v_start
  from time_dim td
 where fiscal_year = p_fiscal_year
   and fiscal_week = p_fiscal_week
   and dim_day = case when curr_day = 1 then 'Monday'
                      when curr_day = 2 then 'Tuesday'
                      when curr_day = 3 then 'Wednesday'
                      when curr_day = 4 then 'Thursday'
                      when curr_day = 5 then 'Friday'
                 end;

for j in 1..p_first_days loop
  if curr_day = 1 then
    update gk_auto_schedule
       set mon_course = p_first_course,
           mon_short = p_first_short,
           mon_pl = p_first_pl,
           mon_type = p_first_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 2 then
    update gk_auto_schedule
       set tue_course = p_first_course,
           tue_short = p_first_short,
           tue_pl = p_first_pl,
           tue_type = p_first_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 3 then
    update gk_auto_schedule
       set wed_course = p_first_course,
           wed_short = p_first_short,
           wed_pl = p_first_pl,
           wed_type = p_first_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 4 then
    update gk_auto_schedule
       set thu_course = p_first_course,
           thu_short = p_first_short,
           thu_pl = p_first_pl,
           thu_type = p_first_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 5 then
    update gk_auto_schedule
       set fri_course = p_first_course,
           fri_short = p_first_short,
           fri_pl = p_first_pl,
           fri_type = p_first_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  end if;
  curr_day := curr_day + 1;
end loop;

insert into gk_auto_schedule_output
  select dim_year,dim_week,p_fiscal_year,p_fiscal_week,p_country,p_metro,p_avail_room,p_first_course,p_first_short,p_first_pl,
         p_first_type,p_first_days,v_start,v_start+p_first_days-1,p_year_dist,p_year_freq,'Event Scheduled'
    from time_dim
   where fiscal_year = p_fiscal_year
     and fiscal_week = p_fiscal_week
     and p_first_days > 0
   group by dim_year,dim_week;

v_start := v_start+p_first_days;

for j in 1..p_sec_days loop
  if curr_day = 1 then
    update gk_auto_schedule
       set mon_course = p_sec_course,
           mon_short = p_sec_short,
           mon_pl = p_sec_pl,
           mon_type = p_sec_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 2 then
    update gk_auto_schedule
       set tue_course = p_sec_course,
           tue_short = p_sec_short,
           tue_pl = p_sec_pl,
           tue_type = p_sec_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 3 then
    update gk_auto_schedule
       set wed_course = p_sec_course,
           wed_short = p_sec_short,
           wed_pl = p_sec_pl,
           wed_type = p_sec_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 4 then
    update gk_auto_schedule
       set thu_course = p_sec_course,
           thu_short = p_sec_short,
           thu_pl = p_sec_pl,
           thu_type = p_sec_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 5 then
    update gk_auto_schedule
       set fri_course = p_sec_course,
           fri_short = p_sec_short,
           fri_pl = p_sec_pl,
           fri_type = p_sec_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  end if;
  curr_day := curr_day + 1;
end loop;

insert into gk_auto_schedule_output
  select dim_year,dim_week,p_fiscal_year,p_fiscal_week,p_country,p_metro,p_avail_room,p_sec_course,p_sec_short,p_sec_pl,
         p_sec_type,p_sec_days,v_start,v_start+p_sec_days-1,p_year_dist,p_year_freq,'Event Scheduled'
   from time_dim
   where fiscal_year = p_fiscal_year
     and fiscal_week = p_fiscal_week
     and p_sec_days > 0
   group by dim_year,dim_week;

v_start := v_start+p_sec_days;

for j in 1..p_third_days loop
  if curr_day = 1 then
    update gk_auto_schedule
       set mon_course = p_third_course,
           mon_short = p_third_short,
           mon_pl = p_third_pl,
           mon_type = p_third_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 2 then
    update gk_auto_schedule
       set tue_course = p_third_course,
           tue_short = p_third_short,
           tue_pl = p_third_pl,
           tue_type = p_third_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 3 then
    update gk_auto_schedule
       set wed_course = p_third_course,
           wed_short = p_third_short,
           wed_pl = p_third_pl,
           wed_type = p_third_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 4 then
    update gk_auto_schedule
       set thu_course = p_third_course,
           thu_short = p_third_short,
           thu_pl = p_third_pl,
           thu_type = p_third_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  elsif curr_day = 5 then
    update gk_auto_schedule
       set fri_course = p_third_course,
           fri_short = p_third_short,
           fri_pl = p_third_pl,
           fri_type = p_third_type
     where fiscal_year = p_fiscal_year
       and fiscal_week = p_fiscal_week
       and country = p_country
       and metro = p_metro
       and room = p_avail_room;
  end if;
  curr_day := curr_day + 1;
end loop;

insert into gk_auto_schedule_output
  select dim_year,dim_week,p_fiscal_year,p_fiscal_week,p_country,p_metro,p_avail_room,p_third_course,p_third_short,p_third_pl,
         p_third_type,p_third_days,v_start,v_start+p_third_days-1,p_year_dist,p_year_freq,'Event Scheduled'
    from time_dim
   where fiscal_year = p_fiscal_year
     and fiscal_week = p_fiscal_week
     and p_third_days > 0;

commit;

end;
/


