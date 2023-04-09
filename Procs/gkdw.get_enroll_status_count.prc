DROP PROCEDURE GKDW.GET_ENROLL_STATUS_COUNT;

CREATE OR REPLACE PROCEDURE GKDW.get_enroll_status_count(evxeventid_in varchar2,
                    enroll_status_in varchar2,
             enroll_count_out out number)
as

 enroll_count number;

begin

 if (evxeventid_in is null or enroll_status_in is null)
 then
  enroll_count_out:= 0;
  return;
 end if;

 SELECT count(nvl(h.enrollstatus,0))
 INTO enroll_count
 FROM slxdw.evxenrollhx h
 WHERE upper(enrollstatus) = upper(trim(enroll_status_in))
 and h.evxeventid = evxeventid_in
 group by h.evxeventid;

  enroll_count_out :=  nvl(enroll_count, 0);


    EXCEPTION
 WHEN NO_DATA_FOUND THEN
    enroll_count_out := 0;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


