


Create Or Alter View Hold.Gk_Channel_Conf_Pull_V
(
   Evxevenrollid,
   Createdate,
   Evxeventid,
   Coursecode,
   Startdate,
   Starttime,
   Enddate,
   Endtime,
   Eventname,
   Contactid,
   Firstname,
   Lastname,
   Email,
   Evxfacilityid,
   Enrollstatus,
   Channel_Keycode,
   Eventtype,
   Facilityname,
   Facilityaddress1,
   Facilityaddress2,
   Facilitycity,
   Facilitystate,
   Facilitypostal,
   Evxevticketid,
   Hvxuserid,
   Enrollstatusdate,
   Enrollstatusdesc,
   Channel_Email,
   Channel_Phone,
   Channel_Cc1_Email,
   Channel_Cc2_Email
)
As
   Select   Ce.*,
            Cp.Channel_Email,
            Cp.Channel_Phone,
            Cp.Channel_Cc1_Email,
            Cp.Channel_Cc2_Email
     From      Gkdw.Gk_Channel_Conf_Email_Mv Ce
            Inner Join
               Gkdw.Gk_Channel_Partner_Conf Cp
            On Ce.Channel_Keycode = Cp.Channel_Keycode
    Where   Not Exists (Select   1
                          From   Gkdw.Gk_Hp_Onsite_Lookup Hl
                         Where   Ce.Evxeventid = Hl.Evxeventid)
   Union
   Select   Ce.Evxevenrollid,
            Ce.Createdate,
            Ce.Evxeventid,
            Ce.Coursecode,
            Ce.Startdate,
            Ce.Starttime,
            Ce.Enddate,
            Ce.Endtime,
            Ce.Eventname,
            Ce.Contactid,
            Ce.Firstname,
            Ce.Lastname,
            Ce.Email,
            Ce.Evxfacilityid,
            Ce.Enrollstatus,
            'C09901018' Channel_Keycode,
            Ce.Eventtype,
            Ce.Facilityname,
            Ce.Facilityaddress1,
            Ce.Facilityaddress2,
            Ce.Facilitycity,
            Ce.Facilitystate,
            Ce.Facilitypostal,
            Ce.Evxevticketid,
            Ce.Hvxuserid,
            Ce.Enrollstatusdate,
            Ce.Enrollstatusdesc,
            Cp.Channel_Email,
            Cp.Channel_Phone,
            Cp.Channel_Cc1_Email,
            Cp.Channel_Cc2_Email
     From         Gkdw.Gk_Channel_Conf_Email_Mv Ce
               Inner Join
                  Gkdw.Gk_Hp_Onsite_Lookup Hl
               On Ce.Evxeventid = Hl.Evxeventid
            Inner Join
               Gkdw.Gk_Channel_Partner_Conf Cp
            On Cp.Channel_Keycode = 'C09901018';



