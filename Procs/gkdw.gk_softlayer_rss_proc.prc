DROP PROCEDURE GKDW.GK_SOFTLAYER_RSS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_softlayer_rss_proc as

cursor c_new is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||substr(cd.course_code,1,4)||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||replace(su.event_url,'&','&amp;')||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(cd.course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||substr(cd.course_code,1,4)||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>English</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)||
       chr(9)||chr(9)||'<course:Country>'||case when ed.country = 'USA' then 'USA' else initcap(ed.country) end||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num = '20' then 'ILO' else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||cd.duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>days</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||replace(su.event_url,'&','&amp;')||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
       left outer join gk_softlayer_url su on cd.course_code = su.course_code and ed.ops_country = su.ops_country
 where cd.course_pl = 'IBM'
   and substr(cd.course_code,1,4) in ('5947','5950','1459','3417','3573','5658','6885') --'0741','0748','6067','6080'
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
 group by ed.event_id,cd.course_code,cd.course_name,su.event_url,
          trim(replace(replace(initcap(cd.course_name),'&','&amp;'),chr(39),'&apos;')),ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end),
          ed.country,upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num = '20' then 'ILO' else 'CR' end,
          cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,
          et.offsetfromutc,start_time,end_time,ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;

cursor c_partner_new is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'English'
                                                      when upper(class_language)='JAPANESE' then 'Japanese'
                                                      else initcap(class_language)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||case when country = 'Virtual' then initcap(country)||' - '||initcap(city) else initcap(replace(city,chr(38)||'aacute;','a')) end||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||iso_country||'</course:ISOCtry>'||chr(10)||
       chr(9)||chr(9)||'<course:Country>'||country||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>days</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(start_time,'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||to_char(to_date(end_time,'hh:mi AM'),'hh24:mi')||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(trim(gtr_flag),'F') = 'T' then '1' else '0' end ||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then 'Partner Delivered' end||'</course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' GMT</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(course_url,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from gk_sl_portal_rss_mv p
 where upper(class_language) in ('ENGLISH','JAPANESE','SPANISH')
   and status = 'Open'
 order by country,start_date;
 
cursor c1 is
select pl.*,pl.end_date-pl.start_date+1 dur_days,
        case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end gtr
 from gk_sl_portal_load_mv pl
where not exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id and pl.line_id = es.line_id)
  and end_date >= trunc(sysdate);
  
cursor c2 is
select pl.event_schedule_id,es.gtr portal_gtr,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end new_gtr_flag
 from gk_sl_portal_load_mv pl
      inner join event_schedule@part_portals es on pl.event_id = es.event_id and pl.line_id = es.line_id
where pl.end_date >= trunc(sysdate)
  and case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end <> es.gtr;
          
xml_file utl_file.file_type;
xml_file_name varchar2(100);
xml_file_name_full varchar2(250); 
resp_file utl_file.file_type;
resp_file_name varchar2(100);
resp_file_name_full varchar2(250); 
emea_file utl_file.file_type;      
v_error number;
v_error_msg varchar2(500);
rss_new_flag varchar2(1) := 'N';
v_rss_line varchar2(4000);
v_item_flag varchar2(1) := 'N';
v_url varchar2(250);
v_curr_date varchar2(50);

begin

dbms_snapshot.refresh('gkdw.gk_sl_portal_rss_mv');
dbms_snapshot.refresh('gkdw.gk_sl_portal_load_mv');

select 'rss_softlayer.xml','/mnt/nc10s141_ibm/ww/rss-ibm/rss_softlayer.xml'
  into xml_file_name,xml_file_name_full
  from dual;


/*** GENERATE US IBM RSS FEED ***/
xml_file := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',xml_file_name,'w');
utl_file.put_line(xml_file,'<?xml version="1.0" encoding="ISO-8859-1"?>'||chr(10)||'<rss version="2.0" xmlns:atom="http://www.w3.org/2005/atom" xmlns:course="http://db.globalknowledge.com/ibm/rss-ibm">'||chr(10) );
utl_file.put_line(xml_file,'<channel>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<title>Global Knowledge</title>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<link>http://db.globalknowledge.com/ibm/ww/rss-ibm/rss_softlayer.xml</link>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<atom:link href="http://db.globalknowledge.com/ibm/ww/rss-ibm/rss_softlayer.xml" rel="self" type="application/rss+xml" />'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<description>A comprehensive list of IBM SoftLayer classes offered by Global Knowledge.</description>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<language>en-gb</language>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<pubDate>'||to_char(sysdate,'Dy, DD Mon YYYY hh24:mi:ss')||' EDT</pubDate>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<lastBuildDate>'||to_char(sysdate,'Dy, DD Mon YYYY hh24:mi:ss')||' EDT</lastBuildDate>'||chr(10) );

for r_new in c_new loop
  utl_file.put_line(xml_file,r_new.rss_line);
  rss_new_flag := 'Y';
end loop;

for r_partner_new in c_partner_new loop
  utl_file.put_line(xml_file,r_partner_new.rss_line);
  rss_new_flag := 'Y';
end loop;

utl_file.put_line(xml_file,'</channel></rss>'||chr(10));
utl_file.fclose(xml_file);

if rss_new_flag = 'Y' then
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'DW.Automation@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'SOFTLAYER RSS XML',
             Body => 'GK_SOFTLAYER_RSS_NEW_PROC Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));
end if;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_SOFTLAYER_RSS_PROC Failed',SQLERRM);
          
end;
/


