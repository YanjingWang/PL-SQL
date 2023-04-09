DROP PROCEDURE GKDW.GK_LOAD_CDW_INTERFACE;

CREATE OR REPLACE PROCEDURE GKDW.gk_load_CDW_INTERFACE is

begin

-- Make Backup
delete gk_cdw_interface_old;

insert into gk_cdw_interface_old
select * from gk_cdw_interface;

commit;
--select count(*) from GK_CDW_INTERFACE;

-- Start Loading table
delete GK_CDW_INTERFACE;

INSERT INTO GKDW.GK_CDW_INTERFACE (
   DW_ID,
   MODALITY, AUTH_CODE, RATE_TYPE,
   GK_COURSE_NUM, CISCO_OVERALL_SOURCE, LP_DUR,
   EFF_DUR, SPEL_RATE, ILT_RATE,
   GK_EXCEPTION, EXCEPT_ACCRUAL_RATE, EXCEPT_RATE_TYPE,
   SHORT_NAME, AVAILABILITY_DATE, EOL_DATE, dw_status
   )
select  dw."id", dw."delivery_type", dw."dw_auth_code", dw."rate_type",
    p."us_code", dw."overall_source_pctg", dw."lp_duration",
    dw."effective_course_duration", dw."applicable_royalty_pctg" spel_rate, dw."std_direct_royalty_rate" ilt_rate,
    case dw."payment_exception"
    when 'yes'
    then 'exclude'
    else null
    end gk_Exception, dw."exception_accrual_rate", dw."exception_accrual_type",
    p."product_code", dw."dw_availability_date", dw."dw_eol_date", dw."dw_status"
from "dworks_info"@rms_prod dw
    ,"product"@rms_prod p
where dw."product" = p."id"
 and (dw."dw_status" is not null  or dw."id" in (595));



/************* Fix Pct cols ************/
update GK_CDW_INTERFACE c
    set c.CISCO_OVERALL_SOURCE = c.CISCO_OVERALL_SOURCE/100
    ,c.SPEL_RATE = c.SPEL_RATE/100
where c.RATE_TYPE = 'Fixed % Rate';


/************* STrip extra chars in Modality ************/
update GK_CDW_INTERFACE c
set c.MODALITY = to_single_byte(c.modality);


commit;


end;
/


