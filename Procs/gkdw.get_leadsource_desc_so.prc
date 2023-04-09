DROP PROCEDURE GKDW.GET_LEADSOURCE_DESC_SO;

CREATE OR REPLACE PROCEDURE GKDW.get_leadsource_desc_so(evxsoid_in char,
               leadsource_desc_out out varchar2)
as

 abbrev_desc varchar2(50) ;

begin

 if (evxsoid_in is null )
 then
    leadsource_desc_out:= null;
    return;
 end if;

 SELECT abbrevdesc
 INTO abbrev_desc
 FROM slxdw.QG_CONTACTLEADSOURCE cls
     LEFT JOIN slxdw.LEADSOURCE LS ON cLS.LEADSOURCEID=LS.LEADSOURCEID
 WHERE cls.ITEMID = evxsoid_in;
 --and l.leadsourceid = q.leadsourceid;

  leadsource_desc_out :=  abbrev_desc;


    EXCEPTION
 WHEN NO_DATA_FOUND THEN
    leadsource_desc_out := null;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


