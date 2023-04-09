DROP PROCEDURE GKDW.RUN_GK_TERRITORY;

CREATE OR REPLACE PROCEDURE GKDW.run_gk_territory as

  RetVal NUMBER;
  P_ENV WB_RT_MAPAUDIT.WB_RT_NAME_VALUES;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('Start run_gk_territory ' || localtimestamp) ;
 
  DBMS_OUTPUT.PUT_LINE('Executing OWB_GK_TERRITORY ') ;
  RetVal := GKDW.OWB_GK_TERRITORY.MAIN ( P_ENV );
  COMMIT;
 
    update market_dim md 
    set md.TERRITORY = null,
    md.REGION =  null, 
    md.SALES_REP = null,
    md.REGION_MGR = null,
    md.SALES_REP_ID = null
    where md.TERRITORY is not null;
     
    commit;

  DBMS_OUTPUT.PUT_LINE('Executing OWB_MARKET_DIM') ;
  RetVal := GKDW.OWB_MARKET_DIM.MAIN ( P_ENV );
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Executing OWB_GK_CHANNEL_PARTNER') ;
  RetVal := GKDW.OWB_GK_CHANNEL_PARTNER.MAIN ( P_ENV );
  COMMIT;
  
/*
  DBMS_OUTPUT.PUT_LINE('Executing OWB_GK_INSIDE_ENTERPRISE') ;
   RetVal := GKDW.OWB_GK_INSIDE_ENTERPRISE.MAIN ( P_ENV );
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Executing OWB_GK_OSR_ZIPCODES') ;
   RetVal := GKDW.OWB_GK_OSR_ZIPCODES.MAIN ( P_ENV );
  COMMIT;
*/  
  
  DBMS_OUTPUT.PUT_LINE('End of GK_TERRITORY run' || localtimestamp) ;
END;
/


