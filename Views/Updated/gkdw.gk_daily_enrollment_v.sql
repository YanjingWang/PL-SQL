


Create Or Alter View Hold.Gk_Daily_Enrollment_V
(
   Evxevenrollid,
   Evxeventid,
   Contactid,
   Createdate,
   Quantity,
   Enroll_Amt,
   Feetype,
   Currencytype,
   Opportunityid,
   Enrollstatus,
   Firstname,
   Lastname,
   Address1,
   Address2,
   City,
   State,
   County,
   Postalcode,
   Country,
   Workphone,
   Email,
   Attendeetype,
   Account
)
As
   Select   [Evxevenrollid] Evxevenrollid,
            [Evxeventid] Evxeventid,
            [Contactid] Contactid,
            [Createdate] Createdate,
            [Quantity] Quantity,
            [Enroll_Amt] Enroll_Amt,
            [Feetype] Feetype,
            [Currencytype] Currencytype,
            [Opportunityid] Opportunityid,
            [Enrollstatus] Enrollstatus,
            [Firstname] Firstname,
            [Lastname] Lastname,
            [Address1] Address1,
            [Address2] Address2,
            [City] City,
            [State] State,
            [County] County,
            [Postalcode] Postalcode,
            [Country] Country,
            [Workphone] Workphone,
            [Email] Email,
            [Attendeetype] Attendeetype,
            [Account] Account
     From   Base.Gk_Daily_Enrollment_V;



