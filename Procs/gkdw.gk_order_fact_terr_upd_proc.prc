DROP PROCEDURE GKDW.GK_ORDER_FACT_TERR_UPD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_order_fact_terr_upd_proc as

begin


update gkdw.order_Fact   cd
set
( cd.OB_NATIONAL_TERR_NUM  ,
  cd.OB_NATIONAL_REP_ID          ,
  cd.OB_TERR_NUM                 ,
  cd.OB_REP_ID                   ,
  cd.OSR_TERR_NUM                ,
  cd.OSR_ID                      ,
  cd.ENT_NATIONAL_TERR_NUM       ,
  cd.ENT_NATIONAL_REP_ID         ,
  cd.ENT_INSIDE_TERR_NUM         ,
  cd.ENT_INSIDE_REP_ID           ,
  cd.ENT_FEDERAL_TERR_NUM        ,
  cd.ENT_FEDERAL_REP_ID          ,
  cd.BTSR_TERR_NUM               ,
  cd.BTSR_REP_ID                 ,
  cd.BTA_TERR_NUM                ,
  cd.BTA_REP_ID
 ) =
 (select qc.OB_NATIONAL_TERR_NUM  ,
  qc.OB_NATIONAL_REP_ID          ,
  qc.OB_TERR_NUM                 ,
  qc.OB_REP_ID                   ,
  qc.OSR_TERR_NUM                ,
  qc.OSR_ID                      ,
  qc.ENT_NATIONAL_TERR_NUM       ,
  qc.ENT_NATIONAL_REP_ID         ,
  qc.ENT_INSIDE_TERR_NUM         ,
  qc.ENT_INSIDE_REP_ID           ,
  qc.ENT_FEDERAL_TERR_NUM        ,
  qc.ENT_FEDERAL_REP_ID          ,
  qc.BTSR_TERR_NUM               ,
  qc.BTSR_REP_ID                 ,
  qc.BTA_TERR_NUM                ,
  qc.BTA_REP_ID
from qg_contact qc
where qc.CONTACTID = cd.cust_id
)
where cd.creation_date >= trunc(sysdate)-1
or cd.LAST_UPDATE_DATE >= trunc(sysdate)-1;
commit;

update gkdw.order_fact f
set f.BTA_REP_NAME = gkdw.get_user_name(f.BTA_REP_ID)
   ,f.BTSR_REP_NAME = gkdw.get_user_name(f.BTSR_REP_ID)
   ,f.ENT_FEDERAL_REP_NAME = gkdw.get_user_name(f.ENT_FEDERAL_REP_ID)
   ,f.ENT_INSIDE_REP_NAME = gkdw.get_user_name(f.ENT_INSIDE_REP_ID)
   ,f.ENT_NATIONAL_REP_NAME = gkdw.get_user_name(f.ENT_NATIONAL_REP_ID)
   ,f.OB_NATIONAL_REP_NAME = gkdw.get_user_name(f.OB_NATIONAL_REP_ID)
   ,f.OB_REP_NAME = gkdw.get_user_name(f.OB_REP_ID)
   ,f.OSR_REP_NAME = gkdw.get_user_name(f.OSR_ID)
where f.GKDW_SOURCE = 'SLXDW'
and (f.creation_date >= trunc(sysdate)-1
or f.LAST_UPDATE_DATE >= trunc(sysdate)-1);
commit;

update gkdw.ppcard_dim  pd
set
( pd.icamprepay,
  pd.icamuserid,
  pd.camprepay,
  pd.camuserid,
  pd.obprepay,
  pd.obuserid,
  pd.osrprepay,
  pd.osr_userid,
  pd.fsdprepay,
  pd.fsduserid,
  pd.iamprepay,
  pd.iamuserid,
  pd.tamprepay,
  pd.tamuserid,
  pd.namprepay,
  pd.namuserid
 ) =
 (select 
  ep.icamprepay,
  ep.icamuserid,
  ep.camprepay,
  ep.camuserid,
  ep.obprepay,
  ep.obuserid,
  ep.osrprepay,
  ep.osruserid,
  ep.fsdprepay,
  ep.fsduserid,
  ep.iamprepay,
  ep.iamuserid,
  ep.tamprepay,
  ep.tamuserid,
  ep.namprepay,
  ep.namuserid
from evxppcard@slx ep
where pd.ppcard_id = ep.evxppcardid
)
where pd.creation_date >= trunc(sysdate)-1
or pd.LAST_UPDATE_DATE >= trunc(sysdate)-1;
commit;

update gkdw.ppcard_dim pd
set pd.osr_rep_name = gkdw.get_user_name(pd.osr_userid)
   ,pd.cam_rep_name = gkdw.get_user_name(pd.camuserid)
   ,pd.ob_rep_name = gkdw.get_user_name(pd.obuserid)
   ,pd.icam_rep_name = gkdw.get_user_name(pd.icamuserid)
   ,pd.iam_rep_name = gkdw.get_user_name(pd.iamuserid)
   ,pd.tam_rep_name = gkdw.get_user_name(pd.tamuserid)
   ,pd.nam_rep_name = gkdw.get_user_name(pd.namuserid)
   ,pd.fsd_rep_name = gkdw.get_user_name(pd.fsduserid)
where pd.creation_date >= trunc(sysdate)-1
or pd.LAST_UPDATE_DATE >= trunc(sysdate)-1;
commit;
gk_order_fact_named_acct;  -- New proc. Rewritten to fix the performance issue
--gk_order_fact_named_acct_proc;  --Updates ORDER_FACT for orders after 2/8/16 

end;
/


