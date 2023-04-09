DROP PROCEDURE GKDW.GK_IBM_RSS_PROC_BKP2;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_rss_proc_BKP2 as

cursor c_new is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
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
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
   and not exists (select 1 from ibm_rss_feed_tbl r where ed.event_id = r.event_id)
 group by ed.event_id,cd.course_code,cd.course_name,tx.coursecode,
          trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;')),ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,
          case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,cd.country,
          et.offsetfromutc,start_time,end_time,ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level
union
-- US virtual events added to Canadian IBM schedule
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||replace(ed.event_id,'Q6','CA')||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else replace(ed.event_id,'Q6','CA') end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('20','42') then null else 'CA' end||'</course:ISOCtry>'||chr(10)||-- SR 08/17
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
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
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country = 'USA'
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
   and not exists (select 1 from ibm_rss_feed_tbl r where replace(ed.event_id,'Q6','CA') = r.event_id)
 group by replace(ed.event_id,'Q6','CA'),cd.course_code,cd.course_name,tx.coursecode,
          trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;')),ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,
          case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,cd.country,
          et.offsetfromutc,start_time,end_time,ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;

cursor c_update is
select ed.event_id,tx.coursecode course_code,tx.title course_name,tx.coursecode ibm_ww_course_code,
       'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode course_url,
       ed.start_date,ed.end_date,
       initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end) city,
       case when cd.md_num in ('32','44') then null else upper(substr(ed.country,1,2)) end country,
       case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end state,
       case when cd.md_num in ('20','42') then 'ILO' 
            when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
            when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
            else 'CR' 
       end delivery_method,tx.duration_length,
       case when cd.ch_num='20' then 'Private' else 'Public' end class_type,
       case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end timezone,
       ed.start_time,ed.end_time,ue.gtr_flag,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)|| -- SR 08/17
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||       
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_update_event_v ue on ed.event_id = ue.event_id
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by ed.event_id,cd.course_code,cd.course_name,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),
          upper(substr(ed.country,1,2)),case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end,
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' 
          end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,ue.gtr_flag,gtr.gtr_level
union
-- Update US virtual events on the Canadian IBM schedule
select ed.event_id,tx.coursecode course_code,tx.title course_name,tx.coursecode ibm_ww_course_code,
       'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode course_url,
       ed.start_date,ed.end_date,
       initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end) city,
       'CA' country,null state,
       case when cd.md_num in ('20','42') then 'ILO' 
            when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
            when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
            else 'CR' 
       end delivery_method,tx.duration_length,
       case when cd.ch_num='20' then 'Private' else 'Public' end class_type,
       case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end timezone,
       ed.start_time,ed.end_time,ue.gtr_flag,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else replace(ed.event_id,'Q6','CA') end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('20','42') then null else 'CA' end||'</course:ISOCtry>'||chr(10)|| -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||       
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_update_event_v ue on replace(ed.event_id,'Q6','CA') = ue.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country = 'USA'
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by ed.event_id,cd.course_code,cd.course_name,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' 
          end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,ue.gtr_flag,gtr.gtr_level;

cursor c_cancel is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>4</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)|| -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||  
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_feed_tbl ft on ed.event_id = ft.event_id
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Cancelled'
   and ft.rss_status = 'Open'
   and cd.ch_num = '10'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by ed.event_id,cd.course_code,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level
union
-- Cancel US virtual events on the Canadian IBM schedule
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||replace(ed.event_id,'Q6','CA')||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>4</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else replace(ed.event_id,'Q6','CA') end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('20','42') then null else 'CA' end||'</course:ISOCtry>'||chr(10)|| -- SR 08/16/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||  
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_feed_tbl ft on replace(ed.event_id,'Q6','CA') = ft.event_id
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country = 'USA'
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Cancelled'
   and ft.rss_status = 'Open'
   and cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by replace(ed.event_id,'Q6','CA'),cd.course_code,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;
          
cursor c_comp is 
select ed.event_id,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>3</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)|| -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_feed_tbl ft on ed.event_id = ft.event_id
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country in ('USA','CANADA')
   and ed.status = 'Verified'
   and ft.rss_status = 'Open'
   and cd.ch_num = '10'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by ed.event_id,cd.course_code,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level
union
-- Completed US virtual events that are on the Canadian IBM schedule
select replace(ed.event_id,'Q6','CA') event_id,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||tx.coursecode||'-'||replace(ed.event_id,'Q6','CA')||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>3</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||tx.coursecode||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else replace(ed.event_id,'Q6','CA') end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('20','42') then null else 'CA' end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||tx.duration_length||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||tx.duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||case when cd.ch_num='20' then 'Private' else 'Public' end||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.start_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when cd.md_num in ('32','44') then null else to_char(to_date(ed.end_time,'hh:mi:ss AM'),'hh24:mi') end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when gtr.gtr_level is not null then '1' else '0' end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName>'||ie.firstname1||' '||ie.lastname1||'</course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail>'||ie.email1||'</course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName>Customer Service</course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone>800-COURSES</course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail>Contact@globalknowledge.com</course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents>'||sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents>'||sum(case when c1.acct_name like 'IBM%' then 1 else 0 end)||'</course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' UTC</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from event_dim ed
       inner join ibm_rss_feed_tbl ft on replace(ed.event_id,'Q6','CA') = ft.event_id
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM' and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and cd.country = 'USA'
   and ed.status = 'Verified'
   and ft.rss_status = 'Open'
   and cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.mfg_course_code,cd.short_name) is not null
 group by replace(ed.event_id,'Q6','CA'),cd.course_code,tx.coursecode,tx.title,ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),
          case when cd.md_num in ('20','42') then 'ILO' 
               when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
               when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
               else 'CR' end,
          tx.duration_length,tx.duration_unit,cd.md_num,cd.country,
          case when cd.ch_num='20' then 'Private' else 'Public' end,et.offsetfromutc,ed.start_time,ed.end_time,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;
 
cursor c_emea is
select * from dir_list where filename = 'IBMFeed_GKEMEA.xml';
-- Sruthi Reddy: updated the logic for external partner name 
cursor c_partner_new is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.country end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(to_char(DURATION_DAYS,'990.0'))||'</course:Duration>'||chr(10)|| -- SR 08/29/2016
       chr(9)||chr(9)||'<course:DurationUnits>'||duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
      chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(p.start_time,'00:00 AM','00 AM'),'30:00 AM','00 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(p.end_time,1,instr(p.end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(p.end_time,1,instr(p.end_time,':')-1))-12)||substr(p.end_time,instr(p.end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(p.end_time,'00:00','00'),'30:00','00'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when p.partner_legal_name in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else p.partner_legal_name end end||'</course:extPartner>'||chr(10)||
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
  from gk_ibm_portal_rss_mv p
 where status = 'Open' 
   and start_date >= trunc(sysdate)
   and not exists (select 1 from ibm_rss_feed_tbl r where p.event_id = r.event_id and p.country = r.isoctry)
union
-- Expanded country partner offerings for new events
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||p.ibm_ww_course_code||'-'||p.iso_ctry||substr(event_id,3)||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(p.course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||p.ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.iso_ctry||substr(event_id,3)||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(p.class_language)='ENGLISH' then 'EN'
                                                      when upper(p.class_language)='SPANISH' then 'ES'
                                                      when upper(p.class_language)='PORTUGUESE' then 'PT'
                                                      when upper(p.class_language)='TURKISH' then 'TR'
                                                      when upper(p.class_language)='ITALIAN' then 'IT'
                                                      when upper(p.class_language)='POLISH' then 'PL'
                                                      when upper(p.class_language)='RUSSIAN' then 'RU'
                                                      when upper(p.class_language)='CZECH' then 'CS'
                                                      when upper(p.class_language)='SLOVAK' then 'SK'
                                                      when upper(p.class_language)='SERBIAN' then 'SR'
                                                      when upper(p.class_language)='ENGLISH' then 'EN'
                                                      when upper(p.class_language)='HUNGARIAN' then 'HU'
                                                      when upper(p.class_language)='GERMAN' then 'DE'
                                                      else substr(upper(p.class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(p.start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(p.end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(p.city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_ctry end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(p.delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(case when p.duration_days is not null then to_char(p.duration_days,'990.0') else tx.duration_length end)||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(p.event_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(p.time_zone,'UTC','')||'</course:TimeZone>'||chr(10)||
      chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(p.start_time,'00:00','00'),'30:00','30'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(p.end_time,1,instr(p.end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(p.end_time,1,instr(p.end_time,':')-1))-12)||substr(p.end_time,instr(p.end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(p.end_time,'00:00','00'),'30:00','00'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' GMT</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(p.course_url,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from gk_ibm_portal_exp_co_mv p 
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
 where p.status = 'Open' and substr(p.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and p.is_active = 'T'
   and start_date > trunc(sysdate)
   and not exists (select 1 from ibm_rss_feed_tbl r where p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry)
union
-- Expanded country partner offerings for existing events
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||p.ibm_ww_course_code||'-'||p.iso_ctry||substr(event_id,3)||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(p.course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(tx.title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||p.ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.iso_ctry||substr(event_id,3)||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(p.class_language)='ENGLISH' then 'EN'
                                                      when upper(p.class_language)='SPANISH' then 'ES'
                                                      when upper(p.class_language)='PORTUGUESE' then 'PT'
                                                      when upper(p.class_language)='TURKISH' then 'TR'
                                                      when upper(p.class_language)='ITALIAN' then 'IT'
                                                      when upper(p.class_language)='POLISH' then 'PL'
                                                      when upper(p.class_language)='RUSSIAN' then 'RU'
                                                      when upper(p.class_language)='CZECH' then 'CS'
                                                      when upper(p.class_language)='SLOVAK' then 'SK'
                                                      when upper(p.class_language)='SERBIAN' then 'SR'
                                                      when upper(p.class_language)='ENGLISH' then 'EN'
                                                      when upper(p.class_language)='HUNGARIAN' then 'HU'
                                                      when upper(p.class_language)='GERMAN' then 'DE'
                                                      else substr(upper(p.class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(p.start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(p.end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(p.city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_ctry end||'</course:ISOCtry>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(p.delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(case when p.duration_days is not null then to_char(p.duration_days,'990.0') else tx.duration_length end)||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(p.event_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(p.time_zone,'UTC','')||'</course:TimeZone>'||chr(10)||
      chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(p.start_time,'00:00 AM','00 AM'),'30:00 AM','00 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(p.end_time,1,instr(p.end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(p.end_time,1,instr(p.end_time,':')-1))-12)||substr(p.end_time,instr(p.end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(p.end_time,'00:00','00'),'30:00','00'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' GMT</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(p.course_url,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
       inner join ibm_rss_feed_tbl r on p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry and r.rss_status = 'Cancelled'
 where p.status = 'Open' and substr(p.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and p.is_active = 'T'
   and start_date > trunc(sysdate);
-- Sruthi Reddy: updated the logic for external partner name 
cursor c_partner_update is
select event_id,course_code,course_name,ibm_ww_course_code,start_date,end_date,replace(city,chr(38)||'atilde;','a') city,country,state,delivery_method,duration_length,class_type,
       timezone,start_time,end_time,course_url,class_language,duration_unit,gtr,ext_partner,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(course_name),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else country end||'</course:ISOCtry>'||chr(10)||   -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(to_char(duration_length,'990.0'))||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(start_time,'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(end_time,'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||gtr||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||ext_partner||'</course:extPartner>'||chr(10)||
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
  from (
 select p.event_id,p.course_code,tx.title course_name,p.ibm_ww_course_code,p.start_date,p.end_date,replace(p.city,chr(38)||'atilde;','a') city,p.country,p.state,p.delivery_method,to_number(p.duration_days) duration_length,p.class_type,
        p.timezone,
        replace(replace(p.start_time,'00:00','00'),'30:00','30') start_time,
        replace(replace(p.end_time,'00:00','00'),'30:00','30') end_time,
        p.course_url,p.class_language,p.duration_unit,
        case when country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when p.partner_legal_name in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else p.partner_legal_name end end ext_partner,
        case when trim(p.gtr) is null then '0'
             when trim(p.gtr) = 'F' then '0'
             when trim(p.gtr) = 'T' then '1'
             else '0'
        end gtr
   from gk_ibm_portal_rss_mv p
        inner join ibm_rss_feed_tbl r on p.event_id = r.event_id and p.country = r.isoctry
        inner join ibm_tier_xml tx on p.ibm_ww_course_code = tx.coursecode
  where upper(p.status) = 'OPEN' and substr(p.ibm_ww_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
    and p.start_date >= trunc(sysdate)
 union all
 select p.iso_ctry||substr(p.event_id,3),p.course_code,r.course_name,p.ibm_ww_course_code,p.start_date,p.end_date,replace(p.city,chr(38)||'atilde;','a') city,p.iso_ctry country,p.state,p.delivery_method,
        to_number(nvl(p.duration_days,tx.duration_length)) duration_length,p.event_type,
       p.time_zone,
       replace(replace(p.start_time,'00:00','00'),'30:00','30') start_time,
       replace(replace(p.end_time,'00:00','00'),'30:00','30') end_time,
       p.course_url,p.class_language,duration_unit,
       null ext_partner,
       case when trim(p.gtr) is null then '0'
            when trim(p.gtr) = 'F' then '0'
            when trim(p.gtr) = 'T' then '1'
            else '0'
       end gtr
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_rss_feed_tbl r on p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
 where upper(p.status) = 'OPEN' and substr(p.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and p.is_active = 'T'
   and p.start_date > trunc(sysdate)
 minus
 select event_id,course_code,course_name,ibm_course_code,start_date,end_date,city,isoctry,state_abbrv,modality,duration_days,classtype,
        offsetfromutc,
        replace(replace(start_time,'00:00','00'),'30:00','30') start_time,
        replace(replace(end_time,'00:00','00'),'30:00','30') end_time,
        to_char(course_url),class_language,duration_unit,case when ext_partner in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else ext_partner end ext_partner,gtr_flag
   from ibm_rss_feed_tbl
 order by country,start_date,ibm_ww_course_code
);
-- Sruthi Reddy: updated the logic for external partner name
cursor c_partner_comp is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>3</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.country end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(to_char(duration_days,'990.0'))||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(start_time,'00:00 AM','00 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(end_time,'00:00 PM','00 PM'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when p.partner_legal_name in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else p.partner_legal_name end end||'</course:extPartner>'||chr(10)||
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
  from gk_ibm_portal_rss_mv p
 where (upper(status) = 'VERIFIED' or (end_date <= trunc(sysdate) and upper(status) = 'OPEN'))
   and exists (select 1 from ibm_rss_feed_tbl r where p.event_id = r.event_id and p.country = r.isoctry and r.rss_status = 'Open')
   and substr(p.ibm_ww_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
-- Expanded country partner offerings
 union
 select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||p.iso_ctry||substr(event_id,3)||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(title),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>3</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.iso_ctry||substr(event_id,3)||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&eacute;','e'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_ctry end||'</course:ISOCtry>'||chr(10)||   -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(case when p.duration_days is not null then to_char(p.duration_days,'990.0') else tx.duration_length end)||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(event_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(time_zone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(start_time,'00:00 AM','00 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(end_time,'00:00 PM','00 PM'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
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
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
 where (upper(status) = 'VERIFIED' or (end_date <= trunc(sysdate) and upper(status) = 'OPEN'))
    and substr(p.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and is_active = 'T'
   and exists (select 1 from ibm_rss_feed_tbl r where p.iso_ctry||substr(p.event_id,3) = r.event_id and p.country = r.isoctry and r.rss_status = 'Open');

cursor c_partner_cancel1 is
select event_id,isoctry,ibm_course_code,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(course_name),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>4</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when modality = 'ILO' then null else isoctry end||'</course:ISOCtry>'||chr(10)|| -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(modality,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(classtype,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(offsetfromutc,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(start_time,'00:00 AM','00 AM'),'30:00 AM','30 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(end_time,'00:00 PM','00 PM'),'30:00 PM','30 PM'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||r.gtr_flag||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when r.isoctry not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when r.ext_partner in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else r.ext_partner end  end||'</course:extPartner>'||chr(10)||
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
  from ibm_rss_feed_tbl r
 where r.event_id not in ('2807201730', -- SR 09/06/2017
 '201201754',
'201201761',
'201201766') 
and r.rss_status = 'Open'
   and substr(r.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and isoctry not in ('US','CA')
   and start_date > trunc(sysdate)
   and not exists (select 1 from gk_ibm_portal_rss_mv p where r.event_id = p.event_id and r.isoctry = p.country)
   and not exists (select 1 from gk_ibm_portal_exp_co_mv pe where pe.iso_ctry||substr(pe.event_id,3) = r.event_id and pe.iso_ctry = r.isoctry)
   and not exists (select 1 from  GK_SL_PORTAL_IBM_RSS_MV pi where r.event_id = pi.event_id and r.isoctry = pi.iso_country);
   
cursor c_partner_cancel2 is
select event_id,country,ibm_ww_course_code,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(course_name),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>4</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'),'&Aacute;','A'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.country end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(to_char(duration_days,'990.0'))||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||duration_unit||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(start_time,'00:00 AM','00 AM'),'30:00 AM','30 AM'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(end_time,'00:00 PM','00 PM'),'30:00 PM','30 PM'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when p.partner_legal_name in ('Global Knowledge S.A. de C.V.','Global Knowledge Asia PTE Ltd.') then null else p.partner_legal_name end end||'</course:extPartner>'||chr(10)||
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
  from gk_ibm_portal_rss_mv p
 where upper(status) = 'CANCELLED' and substr(p.ibm_ww_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and exists (select 1 from ibm_rss_feed_tbl r where p.event_id = r.event_id and p.country = r.isoctry and r.rss_status = 'Open');

cursor c_partner_cancel3 is
select p.iso_ctry||substr(event_id,3) event_id,p.iso_ctry country,ibm_ww_course_code,
       chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||ibm_ww_course_code||'-'||p.iso_ctry||substr(p.event_id,3)||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(course_name),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>4</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||ibm_ww_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.iso_ctry||substr(p.event_id,3)||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(replace(replace(city,chr(38)||'atilde;','a'),'&oacute;','o'))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_ctry end||'</course:ISOCtry>'||chr(10)||  -- SR 08/17/2016
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||nvl(delivery_method,'CR')||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||trim(case when p.duration_days is not null then to_char(p.duration_days,'990.0') else tx.duration_length end)||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(event_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(time_zone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(replace(replace(start_time,'00:00','00'),'30:00','30'),'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||case when lpad(substr(end_time,1,instr(end_time,':')-1),2,'0') > '12'
                                                       then to_char(to_date(to_char(to_number(substr(end_time,1,instr(end_time,':')-1))-12)||substr(end_time,instr(end_time,':')),'hh:mi AM'),'hh24:mi')
                                                       else to_char(to_date(replace(replace(end_time,'00:00','00'),'30:00','30'),'hh:mi AM'),'hh24:mi')
                                                  end||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(p.gtr,'F') = 'T' then 1 else 0 end||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
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
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
       inner join ibm_rss_feed_tbl r on p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry and r.rss_status = 'Open'
 where (is_active = 'F' or upper(p.status) = 'CANCELLED')    and substr(p.ibm_course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
 ;

cursor c14_rss_softlater is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||su.ibm_course_code||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||replace(su.event_url,'&','&amp;')||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(cd.course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||su.ibm_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)||
    --   chr(9)||chr(9)||'<course:Country>'||case when ed.country = 'USA' then 'USA' else initcap(ed.country) end||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num = '20' then 'ILO' else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||cd.duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
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
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
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
 where cd.course_pl = 'IBM'    and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and substr(cd.course_code,1,4) in ('5947','5950','3573','6207')
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and not exists (select 1 from IBM_RSS_FEED_TBL r where replace(ed.event_id,'Q6','CA') = r.event_id)
 group by ed.event_id,su.ibm_course_Code,cd.course_code,cd.course_name,su.event_url,
          trim(replace(replace(initcap(cd.course_name),'&','&amp;'),chr(39),'&apos;')),ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end),
          ed.country,upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num = '20' then 'ILO' else 'CR' end,
          cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,
          et.offsetfromutc,start_time,end_time,ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level; 

cursor c14_rss_sl_cancel is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||su.ibm_course_code||'-'||ed.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||replace(su.event_url,'&','&amp;')||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(cd.course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||su.ibm_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||case when cd.md_num in ('32','44') then null else ed.event_id end||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>EN</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.start_date,'YYYY-MM-DD') end||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||case when cd.md_num in ('32','44') then null else to_char(ed.end_date,'YYYY-MM-DD') end||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end)||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end||'</course:ISOCtry>'||chr(10)||
    --   chr(9)||chr(9)||'<course:Country>'||case when ed.country = 'USA' then 'USA' else initcap(ed.country) end||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1>'||case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||case when cd.md_num = '20' then 'ILO' else 'CR' end||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||cd.duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
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
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
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
 where cd.course_pl = 'IBM'  and substr(cd.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and substr(cd.course_code,1,4) in ('5947','5950','3573','6207')
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and exists (select 1 from IBM_RSS_FEED_TBL r where replace(ed.event_id,'Q6','CA') = r.event_id)
 group by ed.event_id,su.ibm_course_Code,cd.course_code,cd.course_name,su.event_url,
          trim(replace(replace(initcap(cd.course_name),'&','&amp;'),chr(39),'&apos;')),ed.start_date,ed.end_date,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end),
          ed.country,upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num = '20' then 'ILO' else 'CR' end,
          cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,
          et.offsetfromutc,start_time,end_time,ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;
          
cursor c_15_softlayer_new is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||st.ibm_course_Code||'-'||p.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(p.course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(p.course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>1</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||st.ibm_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(p.start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(p.end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||case when p.country = 'Virtual' then initcap(p.country)||' - '||initcap(p.city) else initcap(replace(p.city,chr(38)||'aacute;','a')) end||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_country end||'</course:ISOCtry>'||chr(10)||
      -- chr(9)||chr(9)||'<course:Country>'||country||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||delivery_method||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||p.duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(p.class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(p.timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(p.start_time,'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||to_char(to_date(p.end_time,'hh:mi AM'),'hh24:mi')||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(trim(p.gtr_flag),'F') = 'T' then '1' else '0' end ||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when PARTNER_LEGAL_NAME in ('Global Knowledge EMEA','Global Knowledge S.A. de C.V.') then null else PARTNER_LEGAL_NAME end end||'</course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' GMT</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(p.course_url,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from GK_SL_PORTAL_IBM_RSS_MV p
  left outer join softlayer_tier_xml st on p.course_code = st.course_code and p.delivery_method = st.modality
 where upper(p.class_language) in ('ENGLISH','JAPANESE')
   and p.status = 'Open'
   and substr(p.course_code,1,4) in ('5947','5950','3573','6207','5658','6067','6080')  and substr(p.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and not exists (select 1 from IBM_RSS_FEED_TBL r where replace(p.event_id,'Q6','CA') = r.event_id)
 order by p.country,p.start_date;

cursor c_15_sl_cancel is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||st.ibm_course_Code||'-'||p.event_id||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(p.course_url,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(replace(replace(initcap(p.course_name),'Ibm ','IBM '),'&','&amp;'),chr(39),'&apos;'),'Softlayer','SoftLayer'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>2</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||st.ibm_course_code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||p.event_id||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end ||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(p.start_date,'yyyy-mm-dd')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(p.end_date,'yyyy-mm-dd')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||case when p.country = 'Virtual' then initcap(p.country)||' - '||initcap(p.city) else initcap(replace(p.city,chr(38)||'aacute;','a')) end||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||case when delivery_method = 'ILO' then null else p.iso_country end||'</course:ISOCtry>'||chr(10)||
      -- chr(9)||chr(9)||'<course:Country>'||country||'</course:Country>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL1></course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2></course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||delivery_method||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||p.duration_days||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>D</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>0</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||initcap(replace(nvl(p.class_type,'Public'),chr(13),''))||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone>'||replace(p.timezone,'UTC','')||'</course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime>'||to_char(to_date(p.start_time,'hh:mi AM'),'hh24:mi')||'</course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime>'||to_char(to_date(p.end_time,'hh:mi AM'),'hh24:mi')||'</course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||case when nvl(trim(p.gtr_flag),'F') = 'T' then '1' else '0' end ||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner>'||case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when PARTNER_LEGAL_NAME in ('Global Knowledge EMEA','Global Knowledge S.A. de C.V.') then null else PARTNER_LEGAL_NAME end end||'</course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||to_char(sysdate+4/24,'Dy, DD MON YYYY HH:MI:SS')||' GMT</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(p.course_url,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from GK_SL_PORTAL_IBM_RSS_MV p
  left outer join softlayer_tier_xml st on p.course_code = st.course_code and p.delivery_method = st.modality
 where upper(p.class_language) in ('ENGLISH','JAPANESE')
   and p.status = 'Open'
   and substr(p.course_code,1,4) in ('5947','5950','3573','6207','5658','6067','6080')  and substr(p.course_code,-1,1) <> 'W' -- Exclude IBM W modalities FP# 146429
   and exists (select 1 from IBM_RSS_FEED_TBL r where replace(p.event_id,'Q6','CA') = r.event_id)
 order by p.country,p.start_date;

-- Genuine Genius/Xvoucher Product data to be added to IBM Feed  SR 04/24/2018          
cursor c_16_IBM_products is
select chr(9)||'<item>'||chr(10)||
       chr(9)||chr(9)||'<title>'||cl.title||'</title>'||chr(10)||
       chr(9)||chr(9)||'<link>'||trim(replace(cl.link,'&','&amp;'))||'</link>'||chr(10)||
       chr(9)||chr(9)||'<description>'||trim(replace(replace(initcap(cl.description),'&','&amp;'),chr(39),'&apos;'))||'</description>'||chr(10)||
       chr(9)||chr(9)||'<course:classStatus>'||cl.classstatus||'</course:classStatus>'||chr(10)||
       chr(9)||chr(9)||'<course:code>'||cl.code||'</course:code>'||chr(10)||
       chr(9)||chr(9)||'<course:classNum>'||cl.classNum||'</course:classNum>'||chr(10)||
       chr(9)||chr(9)||'<course:classLanguage>'||cl.language||'</course:classLanguage>'||chr(10)||
       chr(9)||chr(9)||'<course:classStartDate>'||to_char(cl.classstartdate,'YYYY-MM-DD')||'</course:classStartDate>'||chr(10)||
       chr(9)||chr(9)||'<course:classEndDate>'||to_char(cl.classenddate,'YYYY-MM-DD')||'</course:classEndDate>'||chr(10)||
       chr(9)||chr(9)||'<course:city>'||initcap(upper(cl.city))||'</course:city>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOCtry>'||upper(substr(cl.ISOCTRY,1,2))||'</course:ISOCtry>'||chr(10)||  -- SR 08/17
       chr(9)||chr(9)||'<course:ISOSUBL1>'||cl.ISOSUBL1||'</course:ISOSUBL1>'||chr(10)||
       chr(9)||chr(9)||'<course:ISOSUBL2>'||cl.ISOSUBL2||'</course:ISOSUBL2>'||chr(10)||
       chr(9)||chr(9)||'<course:Modality>'||cl.modality||'</course:Modality>'||chr(10)||
       chr(9)||chr(9)||'<course:Duration>'||to_number(cl.duration)||'</course:Duration>'||chr(10)||
       chr(9)||chr(9)||'<course:DurationUnits>'||cl.durationunits||'</course:DurationUnits>'||chr(10)||
       chr(9)||chr(9)||'<course:IRLPSupport>0</course:IRLPSupport>'||chr(10)||
       chr(9)||chr(9)||'<course:VirtualWorkstationRequired>'||cl.VirtualWorkstationRequired||'</course:VirtualWorkstationRequired>'||chr(10)||
       chr(9)||chr(9)||'<course:ClassType>'||cl.classtype||'</course:ClassType>'||chr(10)||
       chr(9)||chr(9)||'<course:TimeZone></course:TimeZone>'||chr(10)||
       chr(9)||chr(9)||'<course:StartTime></course:StartTime>'||chr(10)||
       chr(9)||chr(9)||'<course:LastDayEndTime></course:LastDayEndTime>'||chr(10)||
       chr(9)||chr(9)||'<course:gtr>'||cl.gtr||'</course:gtr>'||chr(10)||
       chr(9)||chr(9)||'<course:extPartner></course:extPartner>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorName></course:instructorName>'||chr(10)||
       chr(9)||chr(9)||'<course:instructorEmail></course:instructorEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactName></course:siteContactName>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactPhone></course:siteContactPhone>'||chr(10)||
       chr(9)||chr(9)||'<course:siteContactEmail></course:siteContactEmail>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofExternalStudents></course:confirmedNumberofExternalStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:confirmedNumberofIBMStudents></course:confirmedNumberofIBMStudents>'||chr(10)||
       chr(9)||chr(9)||'<course:comments></course:comments>'||chr(10)||
       chr(9)||chr(9)||'<pubDate>'||cl.pubdate5||'</pubDate>'||chr(10)||
       chr(9)||chr(9)||'<guid>'||trim(replace(cl.guid,'&','&amp;'))||'</guid>'||chr(10)||
       chr(9)||'</item>'||chr(10) rss_line
  from GK_IBM_RSS_CATALOG cl;

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
r_emea c_emea%rowtype;
v_url varchar2(250);

begin

delete from GK_IBM_RSS_CATALOG;

insert into GK_IBM_RSS_CATALOG
select * from GK_IBM_RSS_CATALOG_LOAD where upper(title) not like '%TITLE%';
commit;

delete from ibm_tier_xml;

insert into ibm_tier_xml(COURSECODE,TITLE,OVERVIEW,KEYWORD,AUDIENCE_TEXT,PREREQUISITS,SKILL_LEVEL,ABSTRACT,CERTIFICATION_PROG,     
                         TOPIC,OBJECTIVE,REMARKS,DURATION_LENGTH,DURATION_UNIT,NEWUPDATEDIND,MKTCATEGORY_NAME,OS_NAME,TASK_NAME,              
                         PRODUCT_L1_NAME,PRODUCT_L2_NAME,PRODUCT_L3_NAME,PRODUCT_L4_NAME,PRODUCT_L5_NAME,MODALITY,IRLP_LAB_FLAG,          
                         IRLP_SERVICE_UNIT_ID,IRLP_NAME,IRLP_DESCRIPTION,IRLP_PRICE_UNIT,IRLP_STUDENT_MAX,ISDR_FLAG,ISDR_ID,
                         ISDR_DESCRIPTION,EXPIRE_DATE,BRAND,--FOLLOW_ON,
                         ESTABLISHED_BASE,CERTIFICATION_PATH,INSTRUCTOR_SKILL,
                         AVAILABLE_TEACH_DATE,RETIRE_REASON,THIRD_PARTY_SOFTWARE,REPLACED_BY_COURSE,CONTENT_AVAILABILITY,
                         FREE_FLAG,ISO_COUNTRY_EXCLUSION)                 
select *
  from xmltable('/ROWSET/ROW'
                passing xmltype(bfilename('GKDW_DATA','ibm_tier_file.xml'),nls_charset_id('CHAR_CS'))
                columns coursecode varchar2(25) path 'COURSECODE',
                        title varchar2(4000) path 'TITLE',
                        overview xmltype path 'OVERVIEW',
                        keyword varchar2(4000) path 'KEYWORD',
                        audience_text varchar2(4000) path 'AUDIENCE_TEXT',
                        prerequisits varchar2(4000) path 'PREREQUISITS',
                        skill_level varchar2(2000) path 'SKILLLEVEL',
                        abstract varchar2(4000) path 'ABSTRACT',
                        certification_prog varchar2(4000) path 'CERTIFICATION_PROG',
                        topic xmltype path 'TOPIC',
                        objective xmltype path 'OBJECTIVE',
                        remarks xmltype path 'REMARKS',
                        duration_length varchar2(25) path 'DURATION_LENGTH',
                        duration_unit varchar2(25) path 'DURATION_UNIT',
                        newupdatedind varchar2(25) path 'NEWUPDATEDIND',
                        mktcategory_name varchar2(500) path 'MKTCATEGORY_NAME',
                        os_name varchar2(500) path 'OS_NAME',
                        task_name varchar2(2000) path 'TASK_NAME',
                        product_l1_name varchar2(500) path 'PRODUCT_L1_NAME',
                        product_l2_name varchar2(500) path 'PRODUCT_L2_NAME',
                        product_l3_name varchar2(500) path 'PRODUCT_L3_NAME',
                        product_l4_name varchar2(500) path 'PRODUCT_L4_NAME',
                        product_l5_name varchar2(500) path 'PRODUCT_L5_NAME',
                        modality varchar2(25) path 'MODALITY',
                        irlp_lab_flag varchar2(25) path 'IRLP_LAB_FLAG',
                        irlp_service_unit_id varchar2(25) path 'IRLP_SERVICE_UNIT_ID',
                        irlp_name varchar2(2000) path 'NAME',
                        irlp_description varchar2(4000) path 'DESCRIPTION[1]',
                        irlp_price_unit varchar2(25) path 'PRICE_UNIT',
                        irlp_student_max varchar2(25) path 'IRLP_STUDENT_MAX',
                        isdr_flag varchar2(25) path 'ISDR_FLAG',
                        isdr_id varchar2(25) path 'ISDR_ID',
                        isdr_description varchar2(4000) path 'ISDR_DESCRIPTION',
                        expire_date varchar2(50) path 'EXPIREDATE',
                        brand varchar2(500) path 'BRAND',
--                        follow_on varchar2(250) path 'FOLLOW_ON',
                        established_base varchar2(250) path 'ESTABLISHED_BASE',
                        certification_path varchar2(250) path 'CERTIFICATION_PATH',
                        instructor_skill varchar2(250) path 'INSTRUCTOR_SKILL',
                        available_teach_date varchar2(250) path 'AVAILABLE_TEACH_DATE',
                        retire_reason varchar2(250) path 'RETIRE_REASON',
                        third_party_software varchar2(250) path 'THIRD_PARTY_SOFTWARE',
                        replaced_by_course varchar2(250) path 'REPLACED_BY_COURSE',
                        content_availability varchar2(250) path 'CONTENT_AVAILABILITY',
                        free_flag varchar2(250) path 'FREE_FLAG',
                        iso_country_exclusion varchar2(250) path 'ISO_COUNTRY_EXCLUSION'
                   );
commit;

/** GK IBM DERIVATIVE WORK COURSES **/
insert into ibm_tier_xml(coursecode,title,modality,duration_length,duration_unit,product_l1_name,product_l2_name,tier_description)
select distinct mfg_course_code,course_name,'CR',trim(to_char(duration_days,'99.0')) duration_length,'D' duration_unit,line_of_business,course_type,
       'Derivative' 
  from course_dim cd,
       "product"@rms_prod p
 where p."us_code" = substr(cd.course_code,1,4)
   and p."derivative_elligible" = 'Y'
   and cd.pl_num = '19'
 group by mfg_course_code,course_name,trim(to_char(duration_days,'99.0')),line_of_business,course_type;
commit;

insert into ibm_tier_xml(coursecode,title,modality,duration_length,duration_unit) values ('GSISPVC01','IBM SPEL EXTENSION (SPVC)','SPVC',1,'D');
insert into ibm_tier_xml(coursecode,title,modality,duration_length,duration_unit) values ('GSIWBT01','IBM SPEL EXTENSION (WBT)','WBT',1,'D');
commit;

dbms_snapshot.refresh('gk_ibm_portal_rss_mv');
dbms_snapshot.refresh('gk_ibm_portal_exp_co_mv');
dbms_snapshot.refresh('GK_SL_PORTAL_IBM_RSS_MV');

sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/ww_rss_ibm.xml /mnt/nc10s141_ibm/ww/rss-ibm/ww_rss_ibm.'||to_char(sysdate,'yyyymmddhh24miss')||'.xml');

select 'ww_rss_ibm.xml','/mnt/nc10s141_ibm/ww/rss-ibm/ww_rss_ibm.xml'
  into xml_file_name,xml_file_name_full
  from dual;


/*** GENERATE US IBM RSS FEED ***/
xml_file := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',xml_file_name,'w');
utl_file.put_line(xml_file,'<?xml version="1.0" encoding="ISO-8859-1"?>'||chr(10)||'<rss version="2.0" xmlns:atom="http://www.w3.org/2005/atom" xmlns:course="http://db.globalknowledge.com/ibm/ww/rss-ibm">'||chr(10) );
utl_file.put_line(xml_file,'<channel>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<title>Global Knowledge</title>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<link>http://db.globalknowledge.com/ibm/ww/rss-ibm</link>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<atom:link href="http://db.globalknowledge.com/ibm/ww/rss-ibm" rel="self" type="application/rss+xml" />'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<description>A comprehensive list of IBM classes offered by Global Knowledge.</description>'||chr(10) );
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

for r_update in c_update loop
  utl_file.put_line(xml_file,r_update.rss_line);
  rss_new_flag := 'Y';
   
  update ibm_rss_feed_tbl
     set course_code = r_update.course_code,
         course_name = r_update.course_name,
         ibm_course_code = r_update.ibm_ww_course_code,
         course_url = r_update.course_url,
         start_date = r_update.start_date,
         end_date = r_update.end_date,
         city = r_update.city,
         isoctry = r_update.country,
         state_abbrv = r_update.state,
         modality = r_update.delivery_method,
         duration_days = r_update.duration_length,
         classtype = r_update.class_type,
         offsetfromutc = r_update.timezone,
         start_time = r_update.start_time,
         end_time = r_update.end_time,
         rss_modify_date = sysdate,
         gtr_flag = r_update.gtr_flag
   where event_id = r_update.event_id
     and nvl(isoctry,'NONE') = nvl(r_update.country,'NONE');
     
end loop;

for r_partner_update in c_partner_update loop
 
  utl_file.put_line(xml_file,r_partner_update.rss_line);
  rss_new_flag := 'Y';
  
  update ibm_rss_feed_tbl
     set course_code = r_partner_update.course_code,
         course_name = r_partner_update.course_name,
         ibm_course_code = r_partner_update.ibm_ww_course_code,
         course_url = r_partner_update.course_url,
         start_date = r_partner_update.start_date,
         end_date = r_partner_update.end_date,
         city = r_partner_update.city,
         isoctry = r_partner_update.country,
         state_abbrv = r_partner_update.state,
         modality = r_partner_update.delivery_method,
         duration_days = r_partner_update.duration_length,
         classtype = r_partner_update.class_type,
         offsetfromutc = r_partner_update.timezone,
         start_time = r_partner_update.start_time,
         end_time = r_partner_update.end_time,
         class_language = r_partner_update.class_language,
         duration_unit = r_partner_update.duration_unit,
         rss_modify_date = sysdate,
         ext_partner = r_partner_update.ext_partner,
         gtr_flag = r_partner_update.gtr
   where event_id = r_partner_update.event_id
     and nvl(isoctry,'NONE') = nvl(r_partner_update.country,'NONE');
     
end loop;
commit;

for r_cancel in c_cancel loop
  utl_file.put_line(xml_file,r_cancel.rss_line);
  rss_new_flag := 'Y'; 
end loop;

for r_partner_cancel in c_partner_cancel1 loop
  utl_file.put_line(xml_file,r_partner_cancel.rss_line);
  rss_new_flag := 'Y';
  
  update ibm_rss_feed_tbl
     set rss_status = 'Cancelled',
         rss_modify_date = sysdate
   where event_id = r_partner_cancel.event_id
     and nvl(isoctry,'NONE') = nvl(r_partner_cancel.isoctry,'NONE');
       
end loop;

for r_partner_cancel in c_partner_cancel2 loop
  utl_file.put_line(xml_file,r_partner_cancel.rss_line);
  rss_new_flag := 'Y';
  
  update ibm_rss_feed_tbl
     set rss_status = 'Cancelled',
         rss_modify_date = sysdate
   where event_id = r_partner_cancel.event_id
     and nvl(isoctry,'NONE') = nvl(r_partner_cancel.country,'NONE');
       
end loop;

-- Expanded country partner offerings
for r_partner_cancel in c_partner_cancel3 loop
  utl_file.put_line(xml_file,r_partner_cancel.rss_line);
  rss_new_flag := 'Y';

  delete from ibm_rss_feed_tbl
   where event_id = r_partner_cancel.event_id
     and nvl(isoctry,'NONE') = nvl(r_partner_cancel.country,'NONE'); 
     
--  update ibm_rss_feed_tbl
--     set rss_status = 'Cancelled',
--         rss_modify_date = sysdate
--   where event_id = r_partner_cancel.event_id
--     and nvl(isoctry,'NONE') = nvl(r_partner_cancel.country,'NONE');
       
end loop;

for r_comp in c_comp loop
  utl_file.put_line(xml_file,r_comp.rss_line);
  rss_new_flag := 'Y';
end loop;

for r_partner_comp in c_partner_comp loop
  utl_file.put_line(xml_file,r_partner_comp.rss_line);
  rss_new_flag := 'Y';
end loop;

for r14_rss_softlayer in c14_rss_softlater loop
  utl_file.put_line(xml_file,r14_rss_softlayer.rss_line);
  rss_new_flag := 'Y';
end loop;

for r14_rss_sl_cancel in c14_rss_sl_cancel loop
utl_file.put_line(xml_file,r14_rss_sl_cancel.rss_line);
rss_new_flag := 'Y';
end loop;

for r15_softlayer_new in c_15_softlayer_new loop
  utl_file.put_line(xml_file,r15_softlayer_new.rss_line);
  rss_new_flag := 'Y';
end loop;

for r_15_sl_cancel in c_15_sl_cancel loop
  utl_file.put_line(xml_file,r_15_sl_cancel.rss_line);
      rss_new_flag := 'Y';
end loop;

commit;

get_dir_list( '/mnt/emea-gk/IBM-RSS/Production');

open c_emea;fetch c_emea into r_emea;
if c_emea%found then
  emea_file := utl_file.fopen('EMEA_RSS','IBMFeed_GKEMEA.xml', 'r');
  v_item_flag := 'N';
  
  loop 
    begin 
      utl_file.get_line(emea_file,v_rss_line); 
      exception 
        when no_data_found then utl_file.fclose(emea_file); 
      exit; 
    end;
    
    if v_rss_line like '%<item>%' then 
      v_item_flag := 'Y';
    elsif v_rss_line like '%</channel>%' then
      v_item_flag := 'N';
    end if;
    
    if v_item_flag = 'Y' then
      utl_file.put_line(xml_file,v_rss_line);
    end if;
  end loop;
    
  select 'GKUSReceipt_'||to_char(sysdate,'yyyymmddhh24miss')||'.txt'
    into resp_file_name
    from dual;

  sys.system_run('mv /mnt/emea-gk/IBM-RSS/Production/IBMFeed_GKEMEA.xml /mnt/emea-gk/IBM-RSS/Production/IBMFeed_GKEMEA.xml.'||to_char(sysdate,'yyyymmddhh24miss'));

  resp_file := utl_file.fopen('/mnt/emea-gk/IBM-RSS/Production',resp_file_name,'w');
  utl_file.put_line(resp_file,'EMEA RSS file has been processed.');
  utl_file.fclose(resp_file);

end if;
close c_emea;

for r_16_IBM_products in c_16_IBM_products loop
  utl_file.put_line(xml_file,r_16_IBM_products.rss_line);
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
             Subject   => 'IBM RSS XML',
             Body => 'GK_IBM_RSS_NEW_PROC Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));
			 

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'erica.loring@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'IBM RSS XML',
             Body => 'GK_IBM_RSS_NEW_PROC Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));

v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'Chris.Pichler@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'IBM RSS XML',
             Body => 'GK_IBM_RSS_NEW_PROC Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));	
end if;

delete from ibm_rss_feed_tbl
where event_id in (select event_id from ibm_rss_update_event_v);

update ibm_rss_feed_tbl
   set rss_status = 'Cancelled',
       rss_modify_date = sysdate
 where rss_status != 'Cancelled'
   and event_id in (select ed.event_id
                      from event_dim ed
                           inner join ibm_rss_feed_tbl ft on ed.event_id = ft.event_id and ed.status = 'Cancelled');
                          
update ibm_rss_feed_tbl
   set rss_status = 'Complete',
       rss_modify_date = sysdate
 where rss_status != 'Complete'
   and event_id in (select ed.event_id
                      from event_dim ed
                           inner join ibm_rss_feed_tbl ft on ed.event_id = ft.event_id and ed.status = 'Verified');
                           
update ibm_rss_feed_tbl
   set rss_status = 'Complete',
       rss_modify_date = sysdate
 where rss_status != 'Complete'
   and event_id in (select event_id from gk_ibm_portal_rss_mv p where (status = 'Verified' or (end_date <= trunc(sysdate) and status = 'Open')));
   
update ibm_rss_feed_tbl
   set rss_status = 'Complete',
       rss_modify_date = sysdate
 where rss_status != 'Complete'
   and event_id in (select p.iso_ctry||substr(p.event_id,3) from gk_ibm_portal_exp_co_mv p
                                      inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
                     where (status = 'Verified' or (end_date <= trunc(sysdate) and status = 'Open'))
                       and is_active = 'T');

insert into ibm_rss_feed_tbl
select ed.event_id,cd.course_code,cd.course_name,cd.mfg_course_code ibm_course_code,
       'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode course_url,
       ed.start_date,ed.end_date,initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end) city,
       upper(substr(ed.country,1,2)) ISOCtry,upper(ed.state) state_abbrv,
       case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end modality,
       cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end classtype,
       et.offsetfromutc,start_time,end_time,ie.firstname1||' '||ie.lastname1 inst_name,ie.email1 inst_email,
       sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end) external_students,
       sum(case when c1.acct_name like 'IBM%' then 1 else 0 end) ibm_students,
       null rss_line,
       'Open',sysdate,'English','D',sysdate,
       case when gtr.gtr_level is not null then '1' else '0' end gtr_flag,null
  from event_dim ed
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM'
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and cd.mfg_course_code is not null
   and not exists (select 1 from ibm_rss_feed_tbl r where ed.event_id = r.event_id)
 group by ed.event_id,cd.course_code,cd.course_name,cd.mfg_course_code,ed.start_date,ed.end_date,tx.coursecode,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end,
          cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,
          et.offsetfromutc,start_time,end_time,cd.course_code,cd.country,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level
union
select replace(ed.event_id,'Q6','CA') event_id,cd.course_code,cd.course_name,cd.mfg_course_code ibm_course_code,
       'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='||tx.coursecode course_url,
       ed.start_date,ed.end_date,initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end) city,
       'CA' ISOCtry,null state_abbrv,
       case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end modality,
       cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end classtype,
       et.offsetfromutc,start_time,end_time,ie.firstname1||' '||ie.lastname1 inst_name,ie.email1 inst_email,
       sum(case when c1.acct_name not like 'IBM%' then 1 else 0 end) external_students,
       sum(case when c1.acct_name like 'IBM%' then 1 else 0 end) ibm_students,
       null rss_line,
       'Open',sysdate,'English','D',sysdate,
       case when gtr.gtr_level is not null then '1' else '0' end gtr_flag,null
  from event_dim ed
       left outer join gk_state_abbrev a on upper(ed.state) = a.state_abbrv
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join ibm_tier_xml tx on nvl(cd.mfg_course_code,cd.short_name) = tx.coursecode
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join gk_all_event_instr_mv ie on ed.event_id = ie.event_id
       left outer join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join cust_dim c1 on f.cust_id = c1.cust_id
       left outer join gk_gtr_events gtr on ed.event_id = gtr.event_id
 where cd.course_pl = 'IBM'
   and cd.country = 'USA'
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and cd.md_num = '20'
   and cd.mfg_course_code is not null
   and not exists (select 1 from ibm_rss_feed_tbl r where replace(ed.event_id,'Q6','CA') = r.event_id)
 group by replace(ed.event_id,'Q6','CA'),cd.course_code,cd.course_name,cd.mfg_course_code,ed.start_date,ed.end_date,tx.coursecode,
          initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'VIRTUAL EASTERN' else upper(ed.city) end),upper(substr(ed.country,1,2)),upper(ed.state),
          case when cd.md_num in ('20','42') then 'ILO' 
                                                 when cd.md_num in ('32','44') and tx.modality like '%SPVC%' then 'SPVC'
                                                 when cd.md_num in ('32','44') and tx.modality like '%WBT%' then 'WBT' 
                                                 else 'CR' end,
          cd.duration_days,case when cd.ch_num='20' then 'Private' else 'Public' end,cd.md_num,
          et.offsetfromutc,start_time,end_time,cd.course_code,cd.country,
          ie.firstname1,ie.lastname1,ie.email1,gtr.gtr_level;
commit;

-- US PARTNER NEW EVENTS
insert into ibm_rss_feed_tbl
select event_id,course_code,course_name,ibm_ww_course_code,course_url,start_date,end_date,replace(city,chr(38)||'atilde;','a') city,country,state,delivery_method,to_number(DURATION_DAYS) duration_length,class_type, -- RS 08/29/2016
       timezone,replace(start_time,'00:00 AM','00 AM') start_time,replace(end_time,'00:00 PM','00 PM') end_time,null inst_name,null inst_email,null external_students,null ibm_students,
       null rss_line,
       'Open',sysdate,class_language,duration_unit,sysdate,'0' gtr_flag,
       case when country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then p.partner_legal_name end
  from gk_ibm_portal_rss_mv p
 where status = 'Open'
   and start_date >= trunc(sysdate)
   and not exists (select 1 from ibm_rss_feed_tbl r where p.event_id = r.event_id and p.country = r.isoctry)
union all
-- EXPANDED PARTNER EVENTS
select iso_ctry||substr(event_id,3) event_id,course_code,course_name,ibm_ww_course_code,course_url,start_date,end_date,replace(city,chr(38)||'atilde;','a') city,iso_ctry,state,delivery_method,
       to_number(case when p.duration_days is not null then p.duration_days else tx.duration_length end) duration_length,event_type,
       time_zone,replace(start_time,'00:00 AM','00 AM') start_time,replace(end_time,'00:00 PM','00 PM') end_time,null inst_name,null inst_email,null external_students,null ibm_students,
       null rss_line,
       'Open',sysdate,class_language,duration_unit,sysdate,'0' gtr_flag,
       null
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode 
 where status = 'Open'
   and is_active = 'T'
   and start_date > trunc(sysdate)
   and not exists (select 1 from ibm_rss_feed_tbl r where p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry)
 order by country,start_date,ibm_ww_course_code;
 
-- UPDATE EXPANDED PARTNER EVENTS THAT ARE RE-ACTIVATED
update ibm_rss_feed_tbl
   set rss_status = 'Open',
       rss_modify_date = sysdate
 where event_id in (
       select r.event_id
  from gk_ibm_portal_exp_co_mv p
       inner join ibm_tier_xml tx on p.ibm_course_code = tx.coursecode
       inner join ibm_rss_feed_tbl r on p.iso_ctry||substr(p.event_id,3) = r.event_id and p.iso_ctry = r.isoctry and r.rss_status = 'Cancelled'
 where p.status = 'Open'
   and p.is_active = 'T'
   and start_date > trunc(sysdate)
 );

insert into ibm_rss_feed_tbl
select distinct ed.event_id,cd.course_code,cd.course_name,su.ibm_course_code,su.event_url,ed.start_date,ed.end_date,
initcap(case when cd.md_num in ('32','44') then null when cd.md_num='20' then 'Cary - Virtual' else initcap(ed.city) end) city,
case when cd.md_num in ('32','44','20','42') then null else upper(substr(ed.country,1,2)) end country,
case when cd.md_num in ('32','44') then null else case when upper(substr(ed.country,1,2)) = 'US' then 'US-' else null end||upper(ed.state) end state,
case when cd.md_num = '20' then 'ILO' else 'CR' end delivery_method,
to_number(DURATION_DAYS) duration_length,case when cd.ch_num='20' then 'Private' else 'Public' end class_type,
case when cd.md_num in ('32','44') then null when trunc(et.offsetfromutc) <> et.offsetfromutc then trunc(et.offsetfromutc)||':30' else trunc(et.offsetfromutc)||':00' end timezone,
to_char(to_date(start_time,'hh:mi:ss AM'),'hh24:mi') start_time,to_char(to_date(end_time,'hh:mi:ss AM'),'hh24:mi') end_time
,null inst_name,null inst_email,null external_students,null ibm_students,
       null rss_line,'Open',sysdate,'English' class_language,'D' duration_unit,sysdate,
case when gtr.gtr_level is not null then '1' else '0' end gtr,null extPartner--'Global Knowledge Training LLC'
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
   and substr(cd.course_code,1,4) in ('5947','5950','3573')
   and cd.country in ('USA','CANADA')
   and ed.end_date >= trunc(sysdate)
   and ed.status = 'Open'
   and cd.ch_num = '10'
   and not exists (select 1 from ibm_rss_feed_tbl r where ed.event_id = r.event_id);

insert into ibm_rss_feed_tbl
select distinct p.event_id,p.course_code,p.course_name,st.ibm_course_code,p.course_url,
p.start_date,p.end_date,case when p.country = 'Virtual' then initcap(p.country)||' - '||initcap(p.city) else initcap(replace(p.city,chr(38)||'aacute;','a')) end city,
case when delivery_method = 'ILO' then null else substr(upper(p.country),1,2) end country,
null state,delivery_method,to_number(p.DURATION_DAYS) duration_length,initcap(replace(nvl(p.class_type,'Public'),chr(13),'')) ClassType,
replace(p.timezone,'UTC','') TimeZone,
to_char(to_date(p.start_time,'hh:mi AM'),'hh24:mi') start_time,to_char(to_date(p.end_time,'hh:mi AM'),'hh24:mi') End_Time,
null inst_name,null inst_email,null external_students,null ibm_students,
null rss_line,'Open',sysdate,case when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='SPANISH' then 'ES'
                                                      when upper(class_language)='PORTUGUESE' then 'PT'
                                                      when upper(class_language)='TURKISH' then 'TR'
                                                      when upper(class_language)='ITALIAN' then 'IT'
                                                      when upper(class_language)='POLISH' then 'PL'
                                                      when upper(class_language)='RUSSIAN' then 'RU'
                                                      when upper(class_language)='CZECH' then 'CS'
                                                      when upper(class_language)='SLOVAK' then 'SK'
                                                      when upper(class_language)='SERBIAN' then 'SR'
                                                      when upper(class_language)='ENGLISH' then 'EN'
                                                      when upper(class_language)='HUNGARIAN' then 'HU'
                                                      when upper(class_language)='GERMAN' then 'DE'
                                                      else substr(upper(class_language),1,2)
                                                 end language,
'D' duration_unit,sysdate,case when nvl(trim(p.gtr_flag),'F') = 'T' then '1' else '0' end gtr,
case when p.country not in ('MX','CL','PE','CO','SG','MY','ID','TH','KR') then case when PARTNER_LEGAL_NAME in ('Global Knowledge EMEA','Global Knowledge S.A. de C.V.') then null else PARTNER_LEGAL_NAME end end extPartner
  from GK_SL_PORTAL_IBM_RSS_MV p
  left outer join softlayer_tier_xml st on p.course_code = st.course_code and p.delivery_method = st.modality
 where upper(p.class_language) in ('ENGLISH','JAPANESE')
   and p.status = 'Open'
   and substr(p.course_code,1,4) in ('5947','5950','3573')
   and not exists (select 1 from ibm_rss_feed_tbl r where p.event_id = r.event_id); 
commit;

gk_partner_portal_load_proc('IBM');
gk_partner_portal_load_proc('SL');
gk_softlayer_instructor_proc;


exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_IBM_RSS_PROC Failed',SQLERRM);
          
end;
/


