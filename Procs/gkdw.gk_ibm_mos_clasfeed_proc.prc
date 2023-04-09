DROP PROCEDURE GKDW.GK_IBM_MOS_CLASFEED_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_mos_clasfeed_proc as

cursor c_new is
select chr(9)||'<Class>'||chr(10)||
       chr(9)||chr(9)||'<Year4Digit>'||g.YEAR4DIGIT || '</Year4Digit>'||chr(10)||
       --chr(9)||chr(9)||'<Month2Digit>'|| g.MONTH2DIGIT||'</Month2Digit>'||chr(10)||
        chr(9)||chr(9)||'<Month2Digit>04</Month2Digit>'||chr(10)||
       chr(9)||chr(9)||'<CountryISO2Enrollment>'|| case 
                                                    when NVL (arc.country_code, g."CountryISO2Enrollment") = 'SLOVAKIA (SLOVAK REPUBLIC)'
                                                    then 'SK'  
                                                    when NVL (arc.country_code, g."CountryISO2Enrollment") = 'VIETNAM'
                                                    then 'VN'     
                                                    else  NVL (arc.country_code, g."CountryISO2Enrollment")               
                                                    end ||'</CountryISO2Enrollment>'||chr(10)||
       chr(9)||chr(9)||'<CourseCodeProvider>' || SUBSTR (g."CourseCodeProvider", 1,LENGTH (g."CourseCodeProvider") - 1)|| '</CourseCodeProvider>'||chr(10)||
       chr(9)||chr(9)||'<DerivativeWork>'||g."DerivativeWork"||'</DerivativeWork>'||chr(10)||
       chr(9)||chr(9)||'<Modality>'||g."Modality"||'</Modality>'||chr(10)||
       chr(9)||chr(9)||'<DurationHours>'||  CASE G."DurationHours"
                                            WHEN 0 THEN G.DURATION_HOURS
                                            ELSE G."DurationHours"
                                            END || '</DurationHours>'||chr(10)||
       chr(9)||chr(9)||'<CourseCodeIBMPri>'||case 
                                             when G.SHORT_NAME is not null
                                            then G.SHORT_NAME
                                            else g."CourseCodeIBMPri"
                                            end||'</CourseCodeIBMPri>'||chr(10)||
       chr(9)||chr(9)||'<CourseCodeIBMSec>'|| g."CourseCodeIBMSec" ||'</CourseCodeIBMSec>'||chr(10)||
       chr(9)||chr(9)||'<StudentsCustomer>'||SUM (G."StudentsCustomer")||'</StudentsCustomer>'||chr(10)||
       chr(9)||chr(9)||'<StudentsIBM>'||SUM (G."StudentsIBM")||'</StudentsIBM>'||chr(10)||
       chr(9)||chr(9)||'<StudentsIBMPartner>'||SUM (G."StudentsIBMPartner")||'</StudentsIBMPartner>'||chr(10)||
       chr(9)||chr(9)||'<FunctionFlag>A</FunctionFlag>'||chr(10)||       
       chr(9)||'</Class>'||chr(10) rss_line
            FROM GKDW.GK_IBM_CLASS_FEED_V G
                 LEFT JOIN AR_REMIT_TO_COUNTRY@r12prd arc
                    ON g."CountryISO2Enrollment" = UPPER (arc.country)
           WHERE     G.YEAR4DIGIT = '2015'
                 AND G.MONTH2DIGIT = '05'
                 --AND G."CourseCodeProvider" like '7196%'
                 and (G."CourseCodeProvider" not like '3639%'
                 and G."CourseCodeProvider" not like '0738%'
                 and G."CourseCodeProvider" not like '0741%'
                 and  G."CourseCodeProvider" not like '0748%'
                 )
        GROUP BY G."ProviderMonthlyClassFeed",
                 G."6",
                 G.YEAR4DIGIT,
                 G.MONTH2DIGIT,
                 case 
                 when NVL (arc.country_code, g."CountryISO2Enrollment") = 'SLOVAKIA (SLOVAK REPUBLIC)'
                 then 'SK'    
                 when NVL (arc.country_code, g."CountryISO2Enrollment") = 'VIETNAM'
                 then 'VN'        
                 else  NVL (arc.country_code, g."CountryISO2Enrollment")               
                 end,
                 G."Modality",
                 CASE G."DurationHours"
                    WHEN 0 THEN G.DURATION_HOURS
                    ELSE G."DurationHours"
                 END,
                                   case 
                  when G.SHORT_NAME is not null
                  then G.SHORT_NAME
                  else g."CourseCodeIBMPri"
                  end,
                 --G.SHORT_NAME,
                 G."CourseCodeIBMSec",
                 G."DerivativeWork",
                 SUBSTR (g."CourseCodeProvider",
                         1,
                         LENGTH (g."CourseCodeProvider") - 1),
                 G."FunctionFlag"                                  
        ORDER BY G.YEAR4DIGIT,
                 g.MONTH2DIGIT,
                case 
                 when NVL (arc.country_code, g."CountryISO2Enrollment") = 'SLOVAKIA (SLOVAK REPUBLIC)'
                 then 'SK'    
                 when NVL (arc.country_code, g."CountryISO2Enrollment") = 'VIETNAM'
                 then 'VN'        
                 else  NVL (arc.country_code, g."CountryISO2Enrollment")               
                 end,
                 G."Modality",
                 CASE G."DurationHours"
                    WHEN 0 THEN G.DURATION_HOURS
                    ELSE G."DurationHours"
                 END,
                                   case 
                  when G.SHORT_NAME is not null
                  then G.SHORT_NAME
                  else g."CourseCodeIBMPri"
                  end,
--                 G.SHORT_NAME,
                 SUBSTR (g."CourseCodeProvider",
                         1,
                         LENGTH (g."CourseCodeProvider") - 1);


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

begin


sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/ProviderMonthlyClassFeed.xml   /mnt/nc10s141_ibm/ww/rss-ibm/ProviderMonthlyClassFeed.'||to_char(sysdate,'yyyymmddhh24miss')||'.xml');

select 'ProviderMonthlyClassFeed.xml','/mnt/nc10s141_ibm/ww/rss-ibm/ProviderMonthlyClassFeed.xml'
  into xml_file_name,xml_file_name_full
  from dual;


/*** GENERATE US IBM MOS RSS FEED ***/

xml_file := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',xml_file_name,'w');
utl_file.put_line(xml_file,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||chr(10)); --||'<rss version="2.0" xmlns:atom="http://www.w3.org/2005/atom" xmlns:course="http://db.globalknowledge.com/ibm/ww/rss-ibm">'||chr(10) );
/*utl_file.put_line(xml_file,'<channel>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<title>Global Knowledge</title>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<link>http://db.globalknowledge.com/ibm/ww/rss-ibm</link>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<atom:link href="http://db.globalknowledge.com/ibm/ww/rss-ibm" rel="self" type="application/rss+xml" />'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<description>ProviderMonthlyClassFeedv2</description>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<language>en-gb</language>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<pubDate>'||to_char(sysdate,'Dy, DD Mon YYYY hh24:mi:ss')||' EDT</pubDate>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<lastBuildDate>'||to_char(sysdate,'Dy, DD Mon YYYY hh24:mi:ss')||' EDT</lastBuildDate>'||chr(10) );
*/
utl_file.put_line(xml_file,'<Feed>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<FeedName>ProviderMonthlyClassFeedv2</FeedName>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<ProviderID>6</ProviderID>'||chr(10) );
utl_file.put_line(xml_file,chr(9)||'<Version>2</Version>'||chr(10) );
    
for r_new in c_new loop
  utl_file.put_line(xml_file,r_new.rss_line);
  rss_new_flag := 'Y';
end loop;




--utl_file.put_line(xml_file,'</Feed></channel></rss>'||chr(10));
utl_file.put_line(xml_file,'</Feed>'||chr(10));

utl_file.fclose(xml_file);


if rss_new_flag = 'Y' then
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'alan.frelich@globalknowledge.com',
             Recipient => 'alan.frelich@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'IBM RSS MOS Classfeed XML',
             Body => 'GK_IBM_RSS_MOS_Classfeed_PROC Complete',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));
end if;


dbms_output.put_line('in Proc');

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_IBM_RSS_MOS_PROC Failed',SQLERRM);
          
end;
/


