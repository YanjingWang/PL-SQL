DROP PROCEDURE GKDW.GDW_LOAD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gdw_load_proc as

cursor c1(v_date date) is
select rta_iid,rta_lob_name,rta_select,rta_insert,rta_update,rta_delete,
       rta_merge,rta_errors,rta_elapse,rta_status,
       to_char(creation_date,'mm/dd/yy hh24:mi:ss') creation_date,
       to_char(last_update_date,'mm/dd/yy hh24:mi:ss') last_update_date
  from owbrep.wb_rt_audit
 where creation_date >= v_date
   --and rta.RTA_ERRORS > 0
 order by creation_date,rta_iid desc;

v_msg_body long;
v_sdate date;
v_edate date;

begin

select sysdate into v_sdate from dual;

/*************** LOAD SLXDW TABLES ***************/

slxdw.run_slxdw_owb_packages_1;
slxdw.run_slxdw_owb_packages_2;
slxdw.run_oracle_tx_history;
--slxdw.run_nexient_batch;

/*************** LOAD GKDW TABLES ****************/
gkdw.run_gkdw_slx_packages;
gkdw.run_order_fact;
--gkdw.ORDER_FACT_ORDER_HDR_UPD; -- SR 11/14/2016 -- SR 09/26/2017 COmmented as it is not needed after SF stabilization
gkdw.gk_order_fact_upd; -- SR 01/24/2017

/************* Update oracle_trx_num for orders processed in oracle on a future date*********/
update order_fact 
set oracle_trx_num = GET_ORA_TRX_NUM(txfee_id),
last_update_date = sysdate
where trunc(creation_date) >= trunc(sysdate) -7
and oracle_trx_num is null;
commit;

/******  UPDATE OF TERR INFO IN ORDER_FACT *******/
--gk_order_fact_terr_upd_proc;
/*************** LOAD RMSDW TABLES ***************/
rmsdw.run_rmsdw_jobs;

gkdw.Update_Course_Dim_rms_course;

/**** CAMPAIGN TARGET Tables  ***/
--slxdw.run_slxdw_owb_packages_3; -- disabled on 10/24/2018

select sysdate into v_edate from dual;

v_msg_body := '<html><head></head><body>';
v_msg_body := v_msg_body||'<table border=1 cellspacing=2 cellpadding=2 style="font-size: 7pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th colspan=12 align=left>GDW Load Time: '||to_char(v_sdate,'mm/dd/yy hh24:mi:ss')||' - '||to_char(v_edate,'mm/dd/yy hh24:mi:ss')||'</th></tr>';
v_msg_body := v_msg_body||'<tr><th>RTA ID</th><th>RTA LOB NAME</th><th>SELECT</th><th>INSERT</th><th>UPDATE</th><th>DELETE</th><th>MERGE</th>';
v_msg_body := v_msg_body||'<th>ERRORS</th><th>ELAPSE</th><th>STATUS</th><th>START</th><th>COMPLETE</th></tr>';

for r1 in c1(v_sdate) loop
  if r1.rta_errors > 0 then
    v_msg_body:= v_msg_body||'<tr align=right bgcolor=red>';
  else
    v_msg_body:= v_msg_body||'<tr align=right>';
  end if;
  v_msg_body := v_msg_body||'<td>'||r1.rta_iid||'</td><td align=left>'||r1.rta_lob_name||'</td><td>'||r1.rta_select||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.rta_insert||'</td><td>'||r1.rta_update||'</td><td>'||r1.rta_delete||'</td><td>'||r1.rta_merge||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.rta_errors||'</td><td>'||r1.rta_elapse||'</td><td>'||r1.rta_status||'</td>';
  v_msg_body := v_msg_body||'<td align=left>'||r1.creation_date||'</td><td align=left>'||r1.last_update_date||'</td></tr>';
end loop;
v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';

send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GDW OWB Load Status',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','alan.frelich@globalknowledge.com','GDW OWB Load Status',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','Smaranika.baral@globalknowledge.com','GDW OWB Load Status',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','Bala.Subramanian@globalknowledge.com','GDW OWB Load Status',v_msg_body);

/****EXCLUDE I COURSES FROM STAT LOAD PROCESS******/
insert into gk_stats_exclude_v
select distinct course_id,course_code from course_dim cd
where course_code like '%I'
and gkdw_source = 'SLXDW'
and not exists (select 1 from gk_stats_exclude_v e where cd.course_id = e.course_id);
commit;

-- Connected C and Connected V to C updates to EVENT_DIM
gk_update_connected_Events;

/****** LOAD SLXDW.USERINFO *********/
delete from slxdw.userinfo;
commit;
insert into slxdw.userinfo
select userid,username,title,lastname,firstname,middlename,region,division,department,email,phone,direct,fax,mobile from userinfo@slx;
commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GDW_LOAD_PROC FAILED',SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','Bala.Subramanian@globalknowledge.com','GDW_LOAD_PROC FAILED',SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','Smaranika.baral@globalknowledge.com','GDW_LOAD_PROC FAILED',SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','Alan.Frelich@globalknowledge.com','GDW_LOAD_PROC FAILED',SQLERRM);
end;
/


GRANT EXECUTE ON GKDW.GDW_LOAD_PROC TO DWHREAD;

