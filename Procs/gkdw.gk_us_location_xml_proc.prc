DROP PROCEDURE GKDW.GK_US_LOCATION_XML_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_us_location_xml_proc as

cursor c1 is
select  chr(9)||'<address>'||chr(10)||
chr(9)||chr(9)||'<locationcode>'||facility_code||'</locationcode>'||chr(10)||
chr(9)||chr(9)||'<location>'||city||'</location>'||chr(10)||
chr(9)||chr(9)||'<address1>'||address1||'</address1>'||chr(10)||
chr(9)||chr(9)||'<address2>'||address2||'</address2>'||chr(10)||
chr(9)||chr(9)||'<address3>'||address3||'</address3>'||chr(10)||
chr(9)||chr(9)||'<address4>'||state||'</address4>'||chr(10)||
chr(9)||chr(9)||'<address5>'||country||'</address5>'||chr(10)||
chr(9)||chr(9)||'<postcode>'||zipcode||'</postcode>'||chr(10)||
chr(9)||'</address>'||chr(10) xml_line 
from(SELECT DISTINCT facility_code,
                city,
                address1,
                address2,
                address3,
                state,
                country,
                zipcode
  FROM (SELECT UPPER (ed.facility_code) facility_code,
               UPPER (ed.city) city,
               UPPER (ed.address1) address1,
               UPPER (ed.address2) address2,
               ed.address3,
               ed.state,
               ed.country,
               ed.zipcode,
               ROW_NUMBER ()
               OVER (
                  PARTITION BY UPPER (ed.facility_code)
                  ORDER BY UPPER (ed.facility_code))
                  rn
          FROM course_dim cd
               INNER JOIN event_dim ed
                  ON     ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
         WHERE     ed.start_date >= TRUNC (SYSDATE)
               AND ed.status <> 'Cancelled'
               AND cd.ch_num <> 20
               AND ed.facility_code IS NOT NULL
               AND substr(upper(ed.ops_country),1,2) = 'US'
               )
 WHERE rn = 1);

v_us_loc_file varchar2(50);
v_us_loc_file_full varchar2(250);
v_us_loc_file_1 utl_file.file_type;


begin

-- Generate US locations file
select 'uslocations22.xml',
       '/mnt/nc10s141_ibm/ww/rss-ibm/uslocations22.xml'
  into v_us_loc_file,v_us_loc_file_full
  from dual;

v_us_loc_file_1 := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',v_us_loc_file,'w');

utl_file.put_line(v_us_loc_file_1,'<?xml version="1.0" encoding="utf-8" ?>'||chr(10)); 
utl_file.put_line(v_us_loc_file_1,'<locations>'||chr(10));

for r1 in c1 loop
  utl_file.put_line(v_us_loc_file_1,r1.xml_line);
end loop;

utl_file.put_line(v_us_loc_file_1,'</locations>'||chr(10));

utl_file.fclose(v_us_loc_file_1);

sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/uslocations22.xml /mnt/emea_b2b/B2B_EMEA_LIVE/US/uslocations22.xml');


exception
  when others then
    rollback;
  send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK US LOCATION FEED XML Failed',SQLERRM);

end;
/


