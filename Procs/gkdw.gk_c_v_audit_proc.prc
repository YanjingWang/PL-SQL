DROP PROCEDURE GKDW.GK_C_V_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_c_v_audit_proc as

cursor c1 is
select event_id,start_date,facility_region_metro metro,course_code,ops_country,v_us_event_id,
       sum(v_us_enroll_cnt) v_us_enroll_cnt,v_ca_event_id,sum(v_ca_enroll_cnt) v_ca_enroll_cnt,
       sum(c_enroll_cnt)+sum(v_us_enroll_cnt)+ sum(v_ca_enroll_cnt) total_enroll_cnt,
       sum(c_enroll_cnt) total_c_cnt,
       sum(v_us_enroll_cnt)+ sum(v_ca_enroll_cnt) total_v_cnt,
       case when sum(c_enroll_cnt) <= 2 then 'Y'
            when sum(c_enroll_cnt)+sum(v_us_enroll_cnt)+ sum(v_ca_enroll_cnt) > 16 then 'Y'
            else 'N'
       end attn_flag
  from (
select q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,q.v_us_cap,
       q.v_ca_course_code,q.v_ca_event_id,q.v_ca_cap,
       count(f1.enroll_id) c_enroll_cnt,
       sum(case when f1.book_amt = 0 then 1 else 0 end) c_guest_cnt,
       0 v_us_enroll_cnt,
       0 v_us_guest_cnt,
       0 v_ca_enroll_cnt,
       0 v_ca_guest_cnt
  from (
select ed1.event_id,ed1.start_date,ed1.facility_region_metro,ed1.course_code,ed1.ops_country,ed1.capacity c_cap,
       ed2.course_code v_us_course_code,ed2.event_id v_us_event_id,ed2.capacity v_us_cap,
       ed3.course_code v_ca_course_code,ed3.event_id v_ca_event_id,ed3.capacity v_ca_cap
from event_dim ed1
     inner join time_dim td1 on ed1.start_date = td1.dim_date
     inner join time_dim td2 on trunc(sysdate) = td2.dim_date
     left outer join event_dim ed2 on ed1.event_id = ed2.connected_v_to_c and ed2.ops_country = 'USA'
     left outer join event_dim ed3 on ed1.event_id = ed3.connected_v_to_c and ed3.ops_country = 'CANADA'
where ed1.status = 'Open'
and ed1.connected_c = 'Y'
and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week+1,2,'0') and td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
) q
left outer join order_fact f1 on q.event_id = f1.event_id and f1.enroll_status = 'Confirmed'
group by q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,v_us_cap,q.v_ca_course_code,q.v_ca_event_id,v_ca_cap
union all
select q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,q.v_us_cap,
       q.v_ca_course_code,q.v_ca_event_id,q.v_ca_cap,
       0,0,
       count(f1.enroll_id) v_us_enroll_cnt,
       sum(case when f1.book_amt = 0 then 1 else 0 end) v_us_guest_cnt,
       0,0
  from (
select ed1.event_id,ed1.start_date,ed1.facility_region_metro,ed1.course_code,ed1.ops_country,ed1.capacity c_cap,
       ed2.course_code v_us_course_code,ed2.event_id v_us_event_id,ed2.capacity v_us_cap,
       ed3.course_code v_ca_course_code,ed3.event_id v_ca_event_id,ed3.capacity v_ca_cap
from event_dim ed1
     inner join time_dim td1 on ed1.start_date = td1.dim_date
     inner join time_dim td2 on trunc(sysdate) = td2.dim_date
     left outer join event_dim ed2 on ed1.event_id = ed2.connected_v_to_c and ed2.ops_country = 'USA'
     left outer join event_dim ed3 on ed1.event_id = ed3.connected_v_to_c and ed3.ops_country = 'CANADA'
where ed1.status = 'Open'
and ed1.connected_c = 'Y'
and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week+1,2,'0') and td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
) q
left outer join order_fact f1 on q.v_us_event_id = f1.event_id and f1.enroll_status = 'Confirmed'
group by q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,v_us_cap,q.v_ca_course_code,q.v_ca_event_id,v_ca_cap
union all
select q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,q.v_us_cap,
       q.v_ca_course_code,q.v_ca_event_id,q.v_ca_cap,
       0,0,0,0,
       count(f1.enroll_id) v_ca_enroll_cnt,
       sum(case when f1.book_amt = 0 then 1 else 0 end) v_ca_guest_cnt
  from (
select ed1.event_id,ed1.start_date,ed1.facility_region_metro,ed1.course_code,ed1.ops_country,ed1.capacity c_cap,
       ed2.course_code v_us_course_code,ed2.event_id v_us_event_id,ed2.capacity v_us_cap,
       ed3.course_code v_ca_course_code,ed3.event_id v_ca_event_id,ed3.capacity v_ca_cap
from event_dim ed1
     inner join time_dim td1 on ed1.start_date = td1.dim_date
     inner join time_dim td2 on trunc(sysdate) = td2.dim_date
     inner join course_dim cd1 on ed1.course_id = cd1.course_id and ed1.ops_country = cd1.country
     left outer join event_dim ed2 on ed1.event_id = ed2.connected_v_to_c and ed2.ops_country = 'USA'
     left outer join event_dim ed3 on ed1.event_id = ed3.connected_v_to_c and ed3.ops_country = 'CANADA'
where ed1.status = 'Open'
and ed1.connected_c = 'Y'
and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week+1,2,'0') and td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
) q
left outer join order_fact f1 on q.v_ca_event_id = f1.event_id and f1.enroll_status = 'Confirmed'
group by q.event_id,q.start_date,q.facility_region_metro,q.course_code,q.ops_country,q.c_cap,q.v_us_course_code,q.v_us_event_id,v_us_cap,q.v_ca_course_code,q.v_ca_event_id,v_ca_cap
)
group by event_id,start_date,facility_region_metro,course_code,ops_country,c_cap,v_us_course_code,v_us_event_id,v_us_cap,v_ca_course_code,v_ca_event_id,v_ca_cap
order by attn_flag desc,start_date,facility_region_metro;

v_msg_body long;


begin

v_msg_body := '<html><head></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th>Start Date</th><th>Metro</th><th>"C" Course</th><th>Country</th><th>"C" Count</th><th>US "V"</th><th>CA "V"</th>';
v_msg_body := v_msg_body||'<th>Total Enroll</th><th>Attn Flag</th></tr>';


for r1 in c1 loop
  if r1.attn_flag = 'Y' then
    v_msg_body:= v_msg_body||'<tr align=right bgcolor=yellow>';
  else
    v_msg_body:= v_msg_body||'<tr align=right>';
  end if;

  v_msg_body := v_msg_body||'<td align=center>'||r1.start_date||'</td><td align=center>'||r1.metro||'</td><td align=center>'||r1.course_code||'</td>';
  v_msg_body := v_msg_body||'<td align=left>'||r1.ops_country||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.total_c_cnt||'</td><td>'||r1.v_us_enroll_cnt||'</td><td>'||r1.v_ca_enroll_cnt||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.total_enroll_cnt||'</td><td align=center>'||r1.attn_flag||'</td></tr>';

end loop;

v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';

send_mail('DW.Automation@globalknowledge.com','ben.harris@globalknowledge.com','C+V Daily Audit Report',v_msg_body);

end;
/


