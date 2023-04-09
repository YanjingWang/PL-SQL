create or replace PROCEDURE      run_gkdw_slx_packages as

  RetVal NUMBER;
  P_ENV WB_RT_MAPAUDIT.WB_RT_NAME_VALUES;

BEGIN 
  -- P_ENV := NULL;  Modify the code to initialize this parameter

/*-----------------------------------------------------------------------------------*/
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
  
  DBMS_OUTPUT.PUT_LINE('End of GK_TERRITORY run' || localtimestamp) ;
/*-----------------------------------------------------------------------------------*/

/********* CISCO DERIVATIVE WORKS  *****************************************************/
if trim((to_char(sysdate, 'DAY'))) = 'SUNDAY'
then
  DBMS_OUTPUT.PUT_LINE('Executing GK_LOAD_CDW_INTERFACE') ;
  GKDW.GK_LOAD_CDW_INTERFACE ;
  COMMIT;

end if;  
/*-----------------------------------------------------------------------------------*/

/********* GK COOOLER STUFF *********************************************************/
-- Taken out on 7/05/20011  
/*-----------------------------------------------------------------------------------*/  
  DBMS_OUTPUT.PUT_LINE('Start GDW_SLX run' || localtimestamp) ;
  
  DBMS_OUTPUT.PUT_LINE('Executing OWB_ACCOUNT_DIM_NEW') ;
  RetVal := GKDW.OWB_ACCOUNT_DIM_NEW.MAIN ( P_ENV );
  COMMIT;
  
 DBMS_OUTPUT.PUT_LINE('Executing OWB_CUST_DIM') ;
  RetVal := GKDW.OWB_CUST_DIM.MAIN ( P_ENV );
  COMMIT;
  
  
  /********* UPdate Cust DIM for Sales Terr/Reps *************/    
  DBMS_OUTPUT.PUT_LINE('Executing OWB_CUST_DIM_TERR_UPD') ;
  RetVal := GKDW.OWB_CUST_DIM_TERR_UPD.MAIN ( P_ENV );
  COMMIT;
  /******************************************************/
  

  DBMS_OUTPUT.PUT_LINE('Executing OWB_COURSE_DIM') ;
  RetVal := GKDW.OWB_COURSE_DIM.MAIN ( P_ENV );
  COMMIT;

  --- Check for Course Segment info created  in Oracle AFTER SLX  
  DBMS_OUTPUT.PUT_LINE('Executing Update_Course_Dim_Segments') ;
  GKDW.Update_Course_Dim_Segments;
  COMMIT;
  /*******************************/ 
  --Update the project actual finish date
  gk_course_dim_upd; 
    
  DBMS_OUTPUT.PUT_LINE('Executing OWB_EVENT_DIM') ;
  RetVal := GKDW.OWB_EVENT_DIM.MAIN ( P_ENV );
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Executing OWB_INSTRUCTOR_DIM') ;
  RetVal := GKDW.OWB_INSTRUCTOR_DIM.MAIN ( P_ENV );
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Executing OWB_PRODUCT_DIM') ;
  RetVal := GKDW.OWB_PRODUCT_DIM.MAIN ( P_ENV );
  COMMIT;

  -------------------------------------
  DBMS_OUTPUT.PUT_LINE('Executing Update_Product_Dim_Segments') ;
  GKDW.Update_Product_Dim_Segments;
  COMMIT;
  --------------------------------------

  DBMS_OUTPUT.PUT_LINE('Executing OWB_PPCARD_DIM') ;
  RetVal := GKDW.OWB_PPCARD_DIM.MAIN ( P_ENV );
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Executing OWB_OPPORTUNITY_DIM') ;
  RetVal := GKDW.OWB_OPPORTUNITY_DIM.MAIN ( P_ENV );
  COMMIT;
 
  DBMS_OUTPUT.PUT_LINE('Executing OWB_ORDER_FACT') ;
  RetVal := GKDW.OWB_ORDER_FACT.MAIN ( P_ENV );
  COMMIT;
      
  DBMS_OUTPUT.PUT_LINE('Executing OWB_SALES_ORDER_FACT') ;
  RetVal := GKDW.OWB_SALES_ORDER_FACT.MAIN ( P_ENV );
  COMMIT;

-- SR 12/14/2016: This is not needed anymore as the reversal of fee is taken care 
-- in SLX. Re enable it only when needed. Records deleted from 11/29/2016 onwards 
-- has been backed up.
-- SR 09/21/2017 Enabling this procedure as we now implemented SF stabilization
  DBMS_OUTPUT.PUT_LINE('Executing INSERT_ORDER_FACT_CANC') ;
  GKDW.INSERT_ORDER_FACT_CANC;
  COMMIT; 

   -------------------------------------------------------
  /******** Update Naional Territories ******************/
    
    update account_dim ad
    set ad.NATIONAL_TERR_ID = get_natl_terr_id(ad.ACCT_ID)
    where ad.NATIONAL_TERR_ID is not null;

    update account_dim ad
    set ad.NATIONAL_TERR_ID = get_natl_terr_id(ad.ACCT_ID)
    where ad.NATIONAL_TERR_ID is null;
    
    commit;
 
    /*********** Update Cust MTA *******************************/
    -- Taken out on 07/-05 -2011
    /************************************************************/
    -----------------------------------------------------------
/******  UPDATE OF TERR INFO IN ORDER_FACT *******/
gk_order_fact_terr_upd_proc;
--commit;  

/*********** Update for IPAD Promo Keycode *************************/
    update order_fact f
    set f.KEYCODE = 'IPAD2012P'
    where enroll_id in 
    (select et.evxevenrollid
    from evxev_Txfee et
    join qg_Evticket q on  et.EVXEVTICKETID = q.EVXEVTICKETID
    where  q.LEADSOURCEID = 'L6UJ9A000V3A'
    )
    and f.KEYCODE <> 'IPAD2012P';
    commit;

/***** Update event_dim.adj_meeting_days ******/
gk_upd_event_meeting_days; -- SR 03/02/2017
--update event_dim
--set adj_meeting_days = 
--case when (to_date(end_time,'hh:mi:ss pm')-to_date(start_time,'hh:mi:ss pm'))*24 <= 2 then .25
--     when (to_date(end_time,'hh:mi:ss pm')-to_date(start_time,'hh:mi:ss pm'))*24 <= 4 then .5
--     when (to_date(end_time,'hh:mi:ss pm')-to_date(start_time,'hh:mi:ss pm'))*24 <= 6 then .75
--     else 1
--end
--where adj_meeting_days is null
--and gkdw_source = 'SLXDW';
--commit;
    
  DBMS_OUTPUT.PUT_LINE('End of GDW_SLX run' || localtimestamp) ;
END;