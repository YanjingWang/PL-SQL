DROP PROCEDURE GKDW.PACK_BURN_FIX_PROC;

CREATE OR REPLACE PROCEDURE GKDW.pack_burn_fix_proc as

v_cnt number;
 RetVal NUMBER;
  P_ENV WB_RT_MAPAUDIT.WB_RT_NAME_VALUES;
  

begin

execute immediate 'truncate table missing_evxbillpayment';

insert into missing_evxbillpayment
SELECT ep.evxppcardid ,
       et.evxppcardid 
  FROM slxdw.evxppcard  ep
       INNER JOIN gkdw.ppcard_dim pp ON ep.EVXPPCARDID = pp.PPCARD_ID
       INNER JOIN slxdw.evxso eo ON ep.evxsoid = eo.evxsoid
       LEFT OUTER JOIN slxdw.evxppcard_tx et            ON ep.evxppcardid = et.evxppcardid AND et.transdesc != 'Purchase'
       LEFT OUTER JOIN slxdw.evxbillpayment eb           ON et.evxbillpaymentid = eb.evxbillpaymentid
       LEFT OUTER JOIN slxdw.qg_billingpayment qb           ON eb.evxbillpaymentid = qb.evxbillpaymentid
       LEFT OUTER JOIN slxdw.evxso es ON eb.evxsoid = es.evxsoid
      
WHERE     ep.cardstatus != 'Void'
       AND TRUNC (et.transdate) >= TO_DATE ('2020-05-13', 'yyyy-mm-dd')
       AND CASE
               WHEN UPPER (eo.billtocountry) = 'CANADA' THEN 'Canada'
               ELSE 'USA'
           END in ('USA', 'Canada')
           and eb.evxbillpaymentid is null
           and transdesc <> 'Expiry'
           
order by 1 ;

commit;

select count(*) into v_cnt from missing_evxbillpayment;

if v_cnt = 0 then

 send_mail('DW.Automation@globalknowledge.com','smaranika.baral@globalknowledge.com','No Pack Burn issues','No Issues Reported');
 
else

pack_burn_fix@SLXDW11G.REGRESS.RDBMS.DEV.US.ORACLE.COM;

slxdw.pack_burn_fix;

RetVal := OWB_order_fact.MAIN ( P_ENV );
  
 end if;
 
  send_mail('DW.Automation@globalknowledge.com','smaranika.baral@globalknowledge.com','Pack Burn fix completed','Pack Burn fix completed');

exception

when others then 

 send_mail('DW.Automation@globalknowledge.com','smaranika.baral@globalknowledge.com','Pack Burn fix failed',SQLERRM);
 

end;
/


