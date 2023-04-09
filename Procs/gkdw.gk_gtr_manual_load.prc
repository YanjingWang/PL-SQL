DROP PROCEDURE GKDW.GK_GTR_MANUAL_LOAD;

CREATE OR REPLACE PROCEDURE GKDW.gk_gtr_manual_load as

v_file utl_file.file_type;
fname varchar2(50);
rname varchar2(50);
rline varchar2(2000);
v_file_loc varchar2(50);
v_event_id varchar2(25);

cursor c0 is
  select filename,
         replace(filename,'.csv','_'||to_char(sysdate,'yymmddhh24miss')||'.csv') proc_filename,
         case when filename like '%0.CSV' then '0' else '3' end gtr_level 
    from dir_list where upper(filename) in ('GTR_EVALUATE.CSV','GTR_LEVEL_3.CSV','GTR_LEVEL_0.CSV');
    
begin

get_dir_list( '/mnt/nc10s038/gtr_interface');
for r0 in c0 loop
  dbms_output.put_line(r0.filename);

  v_file := utl_file.fopen('/mnt/nc10s038/gtr_interface',r0.filename,'r');
  
  loop
    begin
      utl_file.get_line(v_file,rline);
    exception
      when no_data_found then exit;
    end;

    select substr(rline,1,12)
      into v_event_id
      from dual;

    dbms_output.put_line(r0.filename||'-'||v_event_id);

    insert into gk_gtr_events
      select ed.ops_country,td.dim_year||'-'||lpad(td.dim_week,2,'0') start_week,
             ed.start_date,ed.event_id,ed.facility_region_metro metro,ed.facility_code,
             cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,cd.course_type,
             gn.inst_type,gn.inst_name,gn.revenue,gn.total_cost,gn.enroll_cnt,
             round(gn.margin*100,2) margin,sysdate gtr_create_date,r0.gtr_level
        from event_dim ed
             left outer join gk_go_nogo_v gn on ed.event_id = gn.event_id
             inner join time_dim td on ed.start_date = td.dim_date
             inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       where ed.event_id = v_event_id
         and not exists (select 1 from gk_gtr_events ge where gn.event_id = ge.event_id)
         and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id);
    commit;

  end loop; 
  utl_file.fclose(v_file);
  sys.system_run('mv /mnt/nc10s038/gtr_interface/'||r0.filename||' /mnt/nc10s038/gtr_interface/'||r0.proc_filename);

end loop;
commit;

exception
  when others then
    rollback;
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);

end;
/


