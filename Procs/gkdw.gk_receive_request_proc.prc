DROP PROCEDURE GKDW.GK_RECEIVE_REQUEST_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_receive_request_proc(v_sid varchar2) is

l_req_id number;

begin

if v_sid = 'R12PRD' then
  fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;
  
  /*l_req_id := FND_REQUEST.submit_request@r12prd(
                   application => 'PO',
                   program     => 'RVCTP',
                   description => NULL,
                   argument1   => 'BATCH',
                   argument2   => '',
                   argument3   => '');*/
  l_req_id := fnd_request.submit_request@r12prd('PO','RVCTP','Receving Transaction Processor','',FALSE,
  'BATCH','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

  fnd_global_apps_init@r12prd(1111,50248,201,'PO',86) ;
  
    /*l_req_id := FND_REQUEST.submit_request@r12prd(
                   application => 'PO',
                   program     => 'RVCTP',
                   description => NULL,
                   argument1   => 'BATCH',
                   argument2   => '',
                   argument3   => '');*/
  l_req_id := fnd_request.submit_request@r12prd('PO','RVCTP','Receving Transaction Processor','',FALSE,
  'BATCH','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;
else
  fnd_global_apps_init@r12dev(1111,20707,201,'PO',84) ;
    /*l_req_id := FND_REQUEST.submit_request@r12dev(
                   application => 'PO',
                   program     => 'RVCTP',
                   description => NULL,
                   argument1   => 'BATCH',
                   argument2   => '',
                   argument3   => '');*/
  l_req_id := fnd_request.submit_request@r12dev('PO','RVCTP','Receving Transaction Processor','',FALSE,
  'BATCH','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

  fnd_global_apps_init@r12dev(1111,50248,201,'PO',86) ;
  
    /*l_req_id := FND_REQUEST.submit_request@r12dev(
                   application => 'PO',
                   program     => 'RVCTP',
                   description => NULL,
                   argument1   => 'BATCH',
                   argument2   => '',
                   argument3   => '');*/
  l_req_id := fnd_request.submit_request@r12dev('PO','RVCTP','Receving Transaction Processor','',FALSE,
  'BATCH','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
  '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

end if;

--dbms_output.put_line(l_req_id);

end;
/


