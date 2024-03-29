


Create Or Alter View Hold.Instructor_Event_V_Test
(
   Qg_Eventinstructorsid,
   Evxeventid,
   Contactid,
   Feecode,
   Firstname,
   Lastname,
   Account,
   Title,
   Accountid,
   Profilestatus,
   Profiletype,
   Email
)
As
   Select   Distinct Qg_Eventinstructorsid,
                     Evxeventid,
                     Qe.Contactid,
                     Feecode,
                     C.Firstname,
                     C.Lastname,
                     C.Account,
                     C.Title,
                     C.Accountid,
                     Isnull(Qp.Profilestatus, 'Active') Profilestatus,
                     Qp.Profiletype,
                     C.Email
     From         (Select   Feecode,
                            Evxeventid,
                            Qg_Eventinstructorsid,
                            Contactid
                     From   Base.Qg_Eventinstructorsqa) Qe
               Inner Join
                  Base.Contact C
               On Qe.Contactid = C.Contactid
            Left Outer Join
               Base.Qg_Accprofiletype Qp
            On C.Accountid = Qp.Accountid;



