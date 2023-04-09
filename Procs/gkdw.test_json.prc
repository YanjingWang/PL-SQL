DROP PROCEDURE GKDW.TEST_JSON;

CREATE OR REPLACE PROCEDURE GKDW.test_json
AS
  http_resp utl_http.resp;
  req_msg      CLOB;
  resp_msg     CLOB;
  v_clob_length  binary_integer;
  v_amount       pls_integer := 16383;
  v_offset       pls_integer := 1;
  v_buffer       varchar2(32767);
  json_msg     CLOB;
  http_req   utl_http.req;

begin

 
  json_msg := '{"Add": {"ACCOUNTID":"A6UJ9A00S15D","ACCOUNTNAME":"Northrop Grumman","STATUS":"","PRICE":"","FIRSTNAME":"Pete","LASTNAME":"Stoyankavich","EMAIL":"pstoy@whoisthat.com","ADDRESS1":"7040 Troy Hill Dr","ADDRESS2":"Ste B","CITY":"Elkridge","STATE":"MD","POSTALCODE":"21075-7063","COUNTRY":"USA","PHONE":"","EVXEVENTID":"Q6UJ9APY0O48"} }';

  http_req := utl_http.begin_request('http://dbslx8dev.globalknowledge.com/SLXEnrollment/Websvc.asmx/Add_Onsite_Enrollments', 'POST');
  utl_http.set_body_charset(http_req, 'UTF-8');
  utl_http.set_header(http_req, 'Content-Type', 'application/json');

  utl_http.write_text(http_req, dbms_lob.substr(json_msg,dbms_lob.getLength(json_msg),1));

  http_resp := utl_http.get_response(http_req);

  utl_http.read_text(http_resp, resp_msg);

--  dbms_output.put_line(resp_msg);


 utl_http.end_response(http_resp);
 
 dbms_output.put_line('Complete.');

 exception when utl_http.end_of_body then  dbms_output.put_line('Success.');utl_http.end_response(http_resp);
 when utl_http.request_failed then dbms_output.put_line('Response Failed.'); utl_http.end_response(http_resp);
 when others then dbms_output.put_line('Unknown Error!.'); utl_http.end_response(http_resp);
END;
/


