DROP PROCEDURE GKDW.GK_RESELLER_EVENT_CAP_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_reseller_event_cap_proc as

cursor c1 is
    select "evxeventid" evxeventid,"currenrollment" curr_enrollment
    from gk_reseller_event_caps_v@slx r;
    
v_modify_date varchar2(50);
    
begin
rms_link_set_proc;

select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') into v_modify_date from dual;

for r1 in c1 loop

    update "schedule"@rms_prod
    set "maxpart" = r1.curr_enrollment,
        "changed" = v_modify_date
    where "slx_id" = r1.evxeventid;
    
end loop;
commit;
end;
/


