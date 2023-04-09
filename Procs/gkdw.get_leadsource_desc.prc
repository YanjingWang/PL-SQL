DROP PROCEDURE GKDW.GET_LEADSOURCE_DESC;

CREATE OR REPLACE PROCEDURE GKDW.get_leadsource_desc(evxevticketid_in char,
               leadsource_desc_out out varchar2)
as

 abbrev_desc varchar2(50) ;

begin

 if (evxevticketid_in is null )
 then
    leadsource_desc_out:= null;
    return;
 end if;

 SELECT abbrevdesc
 INTO abbrev_desc
 FROM slxdw.leadsource l,
   slxdw.qg_evticket q
 WHERE q.evxevticketid = evxevticketid_in
 and l.leadsourceid = q.leadsourceid;

  leadsource_desc_out :=  abbrev_desc;


    EXCEPTION
 WHEN NO_DATA_FOUND THEN
    leadsource_desc_out := null;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


