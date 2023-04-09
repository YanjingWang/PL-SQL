DROP PROCEDURE GKDW.GET_QG_INSTRUCTOR_ID;

CREATE OR REPLACE PROCEDURE GKDW.get_qg_instructor_id(event_id_in varchar2,
                    instr_id_1_out out varchar2,
         instr_id_2_out out varchar2,
                   instr_id_3_out out varchar2)
as

instructor_id varchar2(12) := null;

CURSOR c_instr_id IS
SELECT q1.QG_EVENTINSTRUCTORSID
from slxdw.qg_eventinstructors q1
WHERE q1.evxeventid = event_id_in;

BEGIN

  instr_id_1_out := null;
  instr_id_2_out := null;
  instr_id_3_out := null;

  OPEN c_instr_id;
  LOOP
  FETCH c_instr_id INTO instructor_id;
  EXIT WHEN c_instr_id%NOTFOUND;

--DBMS_OUTPUT.PUT_LINE(instr_id) ;

    if (instructor_id is not null) then
    begin
    case
     when  (instr_id_1_out is null)
     then instr_id_1_out := instructor_id ;
   when (instr_id_2_out is null)
     then instr_id_2_out := instructor_id ;
     when (instr_id_3_out is null)
    then instr_id_3_out := instructor_id ;
     else
     exit;
   end case;
  end ;
  end if;

END LOOP;
CLOSE c_instr_id;

    EXCEPTION
     WHEN OTHERS THEN
   RAISE ;

END;
/


