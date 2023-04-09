DROP PROCEDURE GKDW.CALL_REST_WEBSERVICE;

CREATE OR REPLACE PROCEDURE GKDW.call_rest_webservice
as
  t_http_req     utl_http.req;
  t_http_resp    utl_http.resp;
  t_request_body varchar2(500);
  t_respond      varchar2(2000);
  t_start_pos    integer := 1;
  t_output       varchar2(2000);

begin

  t_request_body := '{'||chr(39)||'Add'||chr(39)||': '||chr(39)||'[{"ACCOUNTID":"A6UJ9A00S15D","ACCOUNTNAME":"Northrop Grumman","STATUS":"","PRICE":"","FIRSTNAME":"Pete","LASTNAME":"Stoyankavich","EMAIL":"pstoy@whoisthat.com","ADDRESS1":"7040 Troy Hill Dr","ADDRESS2":"Ste B","CITY":"Elkridge","STATE":"MD","POSTALCODE":"21075-7063","COUNTRY":"USA","PHONE":"","EVXEVENTID":"Q6UJ9APY0O48"}]'||chr(39)||'}';


--dbms_output.put_line(t_request_body);


  t_http_req:= utl_http.begin_request( 'http://dbslx8dev.globalknowledge.com/SLXEnrollment/Websvc.asmx/Add_Onsite_Enrollments'
                                     , 'POST'
                                     , 'HTTP/1.1');

--  utl_http.set_authentication(t_http_req,'username','password');                                     

  /*Describe in the request-header what kind of data is send*/
  utl_http.set_header(t_http_req, 'Content-Type', 'text/xml charset=UTF-8');

  /*Describe in the request-header the lengt of the data*/
  utl_http.set_header(t_http_req, 'Content-Length', length(t_request_body));

  /*Put the data in de body of the request*/
  utl_http.write_text(t_http_req, t_request_body);

  /*make the actual request to the webservice en catch the responce in a
    variable*/
  t_http_resp:= utl_http.get_response(t_http_req);

  /*Read the body of the response, so you can find out if the information was
    received ok by the webservice.
    Go to the documentation of the webservice for what kind of responce you
    should expect. In my case it was:
    <responce>
      <status>ok</status>
    </responce>
  */
  utl_http.read_text(t_http_resp, t_respond);

  /*Some closing?1 Releasing some memory, i think....*/
  utl_http.end_response(t_http_resp);
end;
/


