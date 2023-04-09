DROP PROCEDURE GKDW.GK_MONTHLYINSTCOMMENTFEED;

CREATE OR REPLACE PROCEDURE GKDW.gk_MonthlyInstCommentFeed(p_month varchar2) as

cursor c1(p_month varchar2) is
select   chr(9)||chr(9)|| '<Year4Digit>'|| M.YEAR4DIGIT || '</Year4Digit>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<Month2Digit>'|| M.MONTH2DIGIT || '</Month2Digit>' || chr(13) || chr(10) || 
    chr(9)||chr(9)|| '<CountryISO2Enrollment>'|| M.COUNTRYISO2ENROLLMENT || '</CountryISO2Enrollment>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<CourseCodeProvider>'|| M.COURSECODEPROVIDER || '</CourseCodeProvider>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<CourseCodeIBMPri>'|| M.COURSECODEIBMPri || '</CourseCodeIBMPri>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<CourseCodeIBMSec>'|| M.COURSECODEIBMSEC || '</CourseCodeIBMSec>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<DerivativeWork>'|| M.DerivativeWork || '</DerivativeWork>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<Modality>'|| M."Modality" || '</Modality>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<InstrComments>' v_xml_line,
    '</InstrComments>' || chr(13) || chr(10) ||
    chr(9)||chr(9)|| '<FunctionFlag>'|| 'A' || '</FunctionFlag>' v_xml_line1,
    M.COUNTRYISO2ENROLLMENT country,
    M.COURSECODEIBMPRI ibm_coursecode  , m.DerivativeWork, m."Modality"
 from 
   (     select * from  gk_mtm_instcomments m
)m
group by m.YEAR4DIGIT, m.MONTH2DIGIT, m.CountryISO2Enrollment, m.COURSECODEIBMPRI, m.COURSECODEIBMSEC, m.DerivativeWork, m."Modality", m.COURSECODEPROVIDER
ORDER BY  m.CountryISO2Enrollment, m.COURSECODEIBMPRI, DerivativeWork, "Modality" ;


cursor c2(country_in varchar2, coursecode_in varchar2, modality_in varchar2, derivative_Work_in varchar2) is
SELECT  distinct 
   chr(9)||chr(9)||  M.instcomments    instcomments
from 
   (            
         select distinct  
                  CountryISO2Enrollment
,CourseCodeIBMPri
, CourseCodeIBMSec
 , DerivativeWork
  , "Modality", 
   instcomments instcomments
    from gk_mtm_instcomments    
)m
where M.COUNTRYISO2ENROLLMENT = country_in
and M.COURSECODEIBMPRI = coursecode_in 
and m."Modality" = modality_in 
and m.Derivativework = derivative_Work_in ;


xml_file utl_file.file_type;
xml_file_name varchar2(100);
xml_file_name_full varchar2(250);
v_xml_hdr varchar2(1000);
v_error number;
v_error_msg varchar2(500);
r1 c1%rowtype;
r2 c2%rowtype;
v_date varchar2(10);
comments varchar2(4000) ;

begin
  v_date := p_month;

open c1(v_date); fetch c1 into r1;

if c1%found then
  close c1;
  
  select 'ProviderMonthlyInstFeed.xml','/usr/tmp/ProviderMonthlyInstFeed.xml'
      into xml_file_name,xml_file_name_full
      from dual;
      
  xml_file := utl_file.fopen('/usr/tmp',xml_file_name,'w',32767);
  
  select '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'|| chr(13)||chr(10)||
         '<Feed>'|| chr(13)||chr(10)||
         chr(9)|| '<FeedName>ProviderMonthlyInstCommentFeedV3</FeedName>'|| chr(13)||chr(10)||
         chr(9)|| '<ProviderID>6</ProviderID>'||chr(13)||chr(10)||
         chr(9)|| '<Version>2015091</Version>'       
    into v_xml_hdr
    from dual;
    
  utl_file.put_line(xml_file,v_xml_hdr);
  
  for r1 in c1(v_date) loop
  
    select chr(9) ||'<Course>'
    into v_xml_hdr
    from dual;
    utl_file.put_line(xml_file,v_xml_hdr);
      
    
    DBMS_OUTPUT.PUT_LINE(r1.v_xml_line);
  --  DBMS_OUTPUT.PUT_LINE(r1.country);
--    DBMS_OUTPUT.PUT_LINE(r1.ibm_coursecode);
    
    utl_file.put_line(xml_file,r1.v_xml_line);
    
    for r2 in c2(r1.country, r1.ibm_coursecode, r1."Modality", r1.Derivativework) 
    loop
                     
        if r2.instcomments is not null then 
        DBMS_OUTPUT.PUT_LINE(r2.instcomments);
            utl_file.put_line(xml_file, r2.instcomments) ;
        end if;
           
    end loop;
    --DBMS_OUTPUT.PUT_LINE('out of lopp2');
    
    DBMS_OUTPUT.PUT_LINE(r1.v_xml_line1);
    utl_file.put_line(xml_file,r1.v_xml_line1);
    
     select chr(9) || '</Course>'
    into v_xml_hdr
    from dual;
    
    DBMS_OUTPUT.PUT_LINE(v_xml_hdr);
    
    utl_file.put_line(xml_file,v_xml_hdr);
    
  end loop;
  
  --DBMS_OUTPUT.PUT_LINE('Out of lopp1');
  
  select '</Feed>' ||chr(13)||chr(10)
    into v_xml_hdr
    from dual;
    
   DBMS_OUTPUT.PUT_LINE(v_xml_hdr);
     
  utl_file.put_line(xml_file,v_xml_hdr);
  utl_file.fclose(xml_file);

  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'DW.Automation@globalknowledge.com',
            Recipient => 'alan.frelich@globalknowledge.com',
            CcRecipient => '',
            BccRecipient => '',
            Subject   => 'ProviderMonthlyQualFeedV3  XML',
            Body => 'ProviderMonthlyQualFeedV3  XML',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(xml_file_name_full));
            

end if;

  EXCEPTION
  WHEN OTHERS THEN RAISE ;
end;
/


