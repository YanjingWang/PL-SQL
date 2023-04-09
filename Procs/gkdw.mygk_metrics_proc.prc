DROP PROCEDURE GKDW.MYGK_METRICS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.mygk_metrics_proc(p_pl varchar2 default null) as

cursor c1 is
select dim_week,
       c_enroll_cnt,c_mygk_cnt,round(c_mygk_pct*100)||'%' c_mygk_pct,
       l_enroll_cnt,l_mygk_cnt,round(l_mygk_pct*100)||'%' l_mygk_pct,
       p_enroll_cnt,p_mygk_cnt,round(p_mygk_pct*100)||'%' p_mygk_pct,
       n_enroll_cnt,n_mygk_cnt,round(n_mygk_pct*100)||'%' n_mygk_pct,
       v_enroll_cnt,v_mygk_cnt,round(v_mygk_pct*100)||'%' v_mygk_pct,
       e_enroll_cnt,e_mygk_cnt,round(e_mygk_pct*100)||'%' e_mygk_pct,
       enroll_cnt,mygk_cnt,round(mygk_pct*100)||'%' mygk_pct
  from (
select td.dim_year||'-'||lpad(td.dim_week,2,'0') dim_week,
       sum(case when substr(ed.course_code,5,1) = 'C' then 1 else 0 end) c_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) = 'C' and h.createdate < ed.start_date then 1 else 0 end) c_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) = 'C' then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) = 'C' and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) = 'C' then 1 else 0 end)
            else 0
       end c_mygk_pct,
       sum(case when substr(ed.course_code,5,1) = 'N' then 1 else 0 end) n_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) = 'N' and h.createdate < ed.start_date then 1 else 0 end) n_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) = 'N' then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) = 'N' and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) = 'N' then 1 else 0 end)
            else 0
       end n_mygk_pct,
       sum(case when substr(ed.course_code,5,1) = 'L' then 1 else 0 end) l_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) = 'L' and h.createdate < ed.start_date then 1 else 0 end) l_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) = 'L' then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) = 'L' and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) = 'L' then 1 else 0 end)
            else 0
       end l_mygk_pct,
       sum(case when substr(ed.course_code,5,1) = 'V' then 1 else 0 end) v_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) = 'V' and h.createdate < ed.start_date then 1 else 0 end) v_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) = 'V' then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) = 'V' and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) = 'V' then 1 else 0 end)
            else 0
       end v_mygk_pct,
       sum(case when substr(ed.course_code,5,1) in ('C','L') then 1 else 0 end) p_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) in ('C','L') and h.createdate < ed.start_date then 1 else 0 end) p_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) in ('C','L') then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) in ('C','L') and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) in ('C','L') then 1 else 0 end)
            else 0
       end p_mygk_pct,
       sum(case when substr(ed.course_code,5,1) in ('N','V') then 1 else 0 end) e_enroll_cnt,
       sum(case when substr(ed.course_code,5,1) in ('N','V') and h.createdate < ed.start_date then 1 else 0 end) e_mygk_cnt,
       case when sum(case when substr(ed.course_code,5,1) in ('N','V') then 1 else 0 end) > 0
            then sum(case when substr(ed.course_code,5,1) in ('N','V') and h.createdate < ed.start_date then 1 else 0 end)/sum(case when substr(ed.course_code,5,1) in ('N','V') then 1 else 0 end)
            else 0
       end e_mygk_pct,
       count(*) enroll_cnt,
       sum(case when h.createdate < ed.start_date then 1 else 0 end) mygk_cnt,
       sum(case when h.createdate < ed.start_date then 1 else 0 end)/count(*) mygk_pct
  from gk_conf_email_audit ea
       inner join event_dim ed on ea.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td1 on td1.dim_date = trunc(sysdate)
       left outer join hvxuser@gkhub h on ea.contactid = h.contactid
where enrollstatus != 'Cancelled'
  and channel_flag = 'N'
  and (cd.course_pl = p_pl or p_pl is null)
  and td.dim_year||'-'||lpad(td.dim_week,2,'0') >= td1.dim_year||'-'||lpad(td1.dim_week-2,2,'0')
  and ed.start_date <= trunc(sysdate)+60
group by td.dim_year||'-'||lpad(td.dim_week,2,'0')
)
order by 1;

cursor c2 is
select sum(mygk_accounts) mygk_accounts,sum(curr_wk_login) curr_wk_login,sum(curr_wk_created) curr_wk_created,
       sum(event_cnt) mygk_curr_wk_events,sum(enroll_cnt) mygk_curr_wk_students
  from (
select count(*) mygk_accounts,
       sum(case when td1.dim_year = td3.dim_year and td1.dim_week = td3.dim_week then 1 else 0 end) curr_wk_login,
       sum(case when td2.dim_year = td3.dim_year and td2.dim_week = td3.dim_week then 1 else 0 end) curr_wk_created,
       0 event_cnt,0 enroll_cnt
  from hvxuser@gkhub h
       inner join time_dim td1 on td1.dim_date = trunc(h.lastlogindate)
       inner join time_dim td2 on td2.dim_date = trunc(h.createdate)
       inner join time_dim td3 on td3.dim_date = trunc(sysdate) 
union all       
select 0,0,0,count(distinct ed.event_id) event_cnt,count(f.enroll_id) enroll_cnt 
  from hvxuser@gkhub h
       inner join order_fact f on h.contactid = f.cust_id
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
 where f.enroll_status != 'Cancelled'
--   and (cd.course_pl = p_pl or p_pl is null)
   and td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week
);

v_msg_body long;
v_mail_hdr varchar2(500);
curr_week varchar2(25);

begin
select dim_year||'-'||lpad(dim_week,2,'0') into curr_week from time_dim where dim_date = trunc(sysdate);

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=22></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=22>MyGK Account Creation Metrics - '||sysdate||case when p_pl is not null then ' - Prod Line: '||p_pl end||'</th></tr>';
v_msg_body := v_msg_body||'<tr align="center"><th>&nbsp</th><th colspan=3>Public Classroom</th><th colspan=3>Public Virtual</th><th colspan=3>Public Total</th>';
v_msg_body := v_msg_body||'<th colspan=3>Private Classroom</th><th colspan=3>Private Virtual</th><th colspan=3>Private Total</th>';
v_msg_body := v_msg_body||'<th colspan=3>All Modalities</th></tr>';
v_msg_body := v_msg_body||'<tr align="center"><th>Week</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th>';
v_msg_body := v_msg_body||'<th>Enroll</th><th>MyGK</th><th>MyGK%</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th><th>Enroll</th><th>MyGK</th><th>MyGK%</th></tr>';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=22></th></tr>';

for r1 in c1 loop
  if r1.dim_week = curr_week then
    v_msg_body := v_msg_body||'<tr align=right bgcolor=yellow>';
  else
    v_msg_body := v_msg_body||'<tr align=right>';
  end if;
  v_msg_body := v_msg_body||'<td align=left>'||r1.dim_week||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.c_enroll_cnt||'</td><td>'||r1.c_mygk_cnt||'</td><td>'||r1.c_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.l_enroll_cnt||'</td><td>'||r1.l_mygk_cnt||'</td><td>'||r1.l_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.p_enroll_cnt||'</td><td>'||r1.p_mygk_cnt||'</td><td>'||r1.p_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.n_enroll_cnt||'</td><td>'||r1.n_mygk_cnt||'</td><td>'||r1.n_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.v_enroll_cnt||'</td><td>'||r1.v_mygk_cnt||'</td><td>'||r1.v_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.e_enroll_cnt||'</td><td>'||r1.e_mygk_cnt||'</td><td>'||r1.e_mygk_pct||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.enroll_cnt||'</td><td>'||r1.mygk_cnt||'</td><td>'||r1.mygk_pct||'</td>';
end loop;
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=22></th></tr>';
v_msg_body := v_msg_body||'</table><p>';

v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=5></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=5>MyGK Current Week Account Stats</th></tr>';
v_msg_body := v_msg_body||'<tr align="center" valign="bottom"><th>Total<br>Accounts</th><th>Logins</th><th>Accounts<br>Created</th><th>MyGK<br>Events</th><th>MyGK<br>Students</th></tr>';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=5></th></tr>';
for r2 in c2 loop
  v_msg_body := v_msg_body||'<tr align=center><td>'||r2.mygk_accounts||'</td><td>'||r2.curr_wk_login||'</td><td>'||r2.curr_wk_created||'</td><td>'||r2.mygk_curr_wk_events||'</td><td>'||r2.mygk_curr_wk_students||'</td></tr>';
end loop;
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=5></th></tr>';
v_msg_body := v_msg_body||'</table>';

v_mail_hdr := 'MyGK Account Metrics - '||to_char(sysdate,'DD-MON-YY');
send_mail('DW.Automation@globalknowledge.com','remon.eskandar@globalknowledge.com',v_mail_hdr,v_msg_body);

end;
/


