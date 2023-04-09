DROP PROCEDURE GKDW.GK_EVENT_PROMO_LOAD;

CREATE OR REPLACE PROCEDURE GKDW.gk_event_promo_load as

v_file utl_file.file_type;
v_line varchar2(2000);
v_cell owa_util.ident_arr;
v_file_loc varchar2(50);
v_event_id varchar2(15);
v_course_code varchar2(10);
v_promo_code varchar2(50);
v_discount_pct number;
v_discount_price number;

cursor c0 is
  select filename,replace(filename,'.csv','_'||to_char(sysdate,'yymmddhh24miss')||'.csv') proc_filename
    from dir_list 
   where upper(filename) in ('PROMO_EVENTS_US.CSV','PROMO_EVENTS_CA.CSV')
   order by 1;
   
cursor c1 is
  select ll.evxeventid,ll.coursecode,ll.promocode,to_number(ll.disc_pct) disc_pct,
         to_number(ll.disc_price) disc_price,substr(ll.promo_active,1,1) promo_active 
    from gk_event_promo_lu_load ll
         inner join event_dim ed on ll.evxeventid = ed.event_id
   where not exists (select 1 from gk_event_promo_lu ep where ll.evxeventid = ep.evxeventid and ll.promocode = ep.promocode);
    
begin

get_dir_list( '/mnt/nc10s038/gk_event_promos');

for r0 in c0 loop
  dbms_output.put_line(r0.filename);
  
  v_file := utl_file.fopen('/mnt/nc10s038/gk_event_promos',r0.filename,'r');
  
  sys.system_run('cp /mnt/nc10s038/gk_event_promos/'||r0.filename||' /d01/gkdw_load/gk_event_promo_load.csv');
  
  for r1 in c1 loop    
    insert into gk_event_promo_lu
      select r1.evxeventid,r1.coursecode,r1.promocode,r1.disc_pct,r1.disc_price,r1.promo_active from dual;
  end loop;

  utl_file.fclose(v_file);
  sys.system_run('mv /mnt/nc10s038/gk_event_promos/'||r0.filename||' /mnt/nc10s038/gk_event_promos/'||r0.proc_filename);
  
  dbms_output.put_line('file renamed');

end loop;
commit;

exception
when others then
  rollback;
  utl_file.fclose(v_file);
  dbms_output.put_line(SQLERRM);

end;
/


