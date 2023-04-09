DROP PROCEDURE GKDW.GET_PP_SALES_ORDER_ID;

CREATE OR REPLACE PROCEDURE GKDW.get_pp_sales_order_id(enroll_id_in varchar2,
                 pp_sales_order_id_out out varchar2)
as

  evxsoid varchar2(50) ;

begin

 if (enroll_id_in is null )
 then
    pp_sales_order_id_out:= null;
    return;
 end if;


 SELECT pp.evxsoid
 INTO evxsoid
 FROM SLXDW.evxppeventpass ep
 join SLXDW.evxppcard pp on ep.EVXPPCARDID = pp.EVXPPCARDID
 WHERE ep.EVXEVENROLLID = enroll_id_in;

   pp_sales_order_id_out :=  evxsoid;


    EXCEPTION
 WHEN NO_DATA_FOUND THEN
    pp_sales_order_id_out := null;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


