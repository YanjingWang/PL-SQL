DROP PROCEDURE GKDW.GK_US_EVENT_XML_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_us_event_xml_proc as
cursor c0 is
select  chr(9)||'<event>'||chr(10)||
chr(9)||chr(9)||'<eventid>'||substr(ed.ops_country,1,2)||'-'||ed.event_id||'</eventid>'||chr(10)||
chr(9)||chr(9)||'<code>'||cd.course_code||'</code>'||chr(10)||
chr(9)||chr(9)||'<eventlistprice>'||cd.list_price||'</eventlistprice>'||chr(10)||
--chr(9)||chr(9)||'<currency>'||case when substr(cd.country,1,2) = 'US' then 'USD' when substr(cd.country,1,2) = 'CA' then 'CAD' end||'</currency>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||ed.facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||ed.city||'</location>'||chr(10)||
chr(9)||chr(9)||'<startdate>'||to_char(ed.start_date,'YYYY-MM-DD')||'</startdate>'||chr(10)||
chr(9)||chr(9)||'<enddate>'||to_char(ed.end_date,'YYYY-MM-DD')||'</enddate>'||chr(10)||
chr(9)||chr(9)||'<duration>'||ed.meeting_days||'</duration>'||chr(10)||
chr(9)||chr(9)||'<modalitycode>'||substr(ed.course_code,-1,1)||'</modalitycode>'||chr(10)||
chr(9)||chr(9)||'<modality>'||plm."description"||'</modality>'||chr(10)||
chr(9)||'</event>'||chr(10) xml_line 
from event_dim ed
inner join course_dim cd
on ed.course_id = cd.course_id and ed.ops_country = cd.country
left outer join "product_line_mode"@rms_prod plm on substr(ed.course_code,-1,1) = plm."mode"
where  ed.start_date >= trunc(sysdate)
and ed.status <> 'Cancelled'
and cd.ch_num <> 20
and substr(upper(ed.ops_country),1,2) = 'US'; -- 20 is private events

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file utl_file.file_type;

begin

-- generate US events file
select 'usevents22.xml',
       '/mnt/nc10s141_ibm/ww/rss-ibm/usevents22.xml'
  into v_file_name,v_file_name_full
  from dual;

v_file := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',v_file_name,'w');

utl_file.put_line(v_file,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_file,'<events>'||chr(10));

for r0 in c0 loop
  utl_file.put_line(v_file,r0.xml_line);
end loop;

utl_file.put_line(v_file,'</events>'||chr(10));

utl_file.fclose(v_file);
commit;

sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/usevents22.xml /mnt/emea_b2b/B2B_EMEA_LIVE/US/usevents22.xml');

exception
  when others then
    rollback;
  send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK US EVENT FEED XML Failed',SQLERRM);

end;
/


