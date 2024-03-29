


Create Or Alter View Hold.Gk_Mtm_Instructor_V
(
   Evxeventid,
   Contactid,
   Firstname,
   Lastname
)
As
   Select   Evxeventid,
            Contactid,
            Firstname,
            Lastname
     From   Gkdw.Instructor_Event_V
    Where   Feecode = 'Ss' And Isnull(Profilestatus, 'Active') = 'Active'
   Union
   Select   Evxeventid,
            Contactid,
            Firstname,
            Lastname
     From   Gkdw.Instructor_Event_V Ie1
    Where   Feecode = 'Si' And Isnull(Profilestatus, 'Active') = 'Active'
            And Not Exists
                  (Select   1
                     From   Gkdw.Instructor_Event_V Ie2
                    Where   Ie1.Evxeventid = Ie2.Evxeventid
                            And Feecode = 'Ss')
   Union
   Select   Evxeventid,
            Contactid,
            Firstname,
            Lastname
     From   Gkdw.Instructor_Event_V Ie1
    Where   Feecode = 'Ins' And Isnull(Profilestatus, 'Active') = 'Active';



