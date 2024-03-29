


Create Or Alter View Hold.Gk_Citrix_Ons_Price_V
(
   Event_Id,
   Numstudents,
   Citrix_List_Price
)
As
   Select   Ed.Event_Id,
            Isnull(Fdc.Numstudents, Ed.Capacity) Numstudents,
            20000 Citrix_List_Price    /** Requested Change By John Nealis **/
     --       Case When Isnull(Fdc.Numstudents,Ed.Capacity) <= 10 Then 21250
     --            Else 25500
     --       End Citrix_List_Price
     From            Gkdw.Event_Dim Ed
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Ed.Course_Id = Cd.Course_Id
                     And Ed.Ops_Country = Cd.Country
               Left Outer Join
                  Base.Gk_Sales_Opportunity So
               On Ed.Opportunity_Id = So.Gk_Sales_Opportunityid
            Left Outer Join
               Base.Gk_Onsitereq_Fdc Fdc
            On So.Current_Idr = Fdc.Gk_Onsitereq_Idrid
               And Fdc.Status Not In ('Rejected', 'Discarded')
    Where   Cd.Pl_Num = '14' And Cd.Ch_Num = '20'
--Select Ed.Event_Id,
--       Case When Substr(Cd.Course_Code,1,4) In ('8614','8615','8557','8558','8268') Then 8
--            Else 8
--       End Numstudents,
--       Case When Substr(Cd.Course_Code,1,4) = '8270' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 4995
--                    When Substr(Cd.Course_Code,1,4) = '8558' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 3195
--                    When Substr(Cd.Course_Code,1,4) = '8269' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 4995
--                    When Substr(Cd.Course_Code,1,4) = '8278' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 3195
--                    When Substr(Cd.Course_Code,1,4) = '8614' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 4995
--                    When Substr(Cd.Course_Code,1,4) = '8615' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 4995
--                    When Substr(Cd.Course_Code,1,4) = '8268' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 3995
--                    When Substr(Cd.Course_Code,1,4) = '8557' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 3195
--                    When Substr(Cd.Course_Code,1,4) = '8673' And Ed.Start_Date < To_Date('01/01/2012','Mm/Dd/Yyyy') Then 3195
--                    Else Cd2.List_Price
--               End*Case When Substr(Cd.Course_Code,1,4) In ('8614','8615','8557','8558','8268') Then 8
--                        Else 8
--                   End Citrix_List_Price
--  From Gkdw.Event_Dim Ed
--       Inner Join Gkdw.Course_Dim Cd On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
--       Inner Join Gkdw.Course_Dim Cd2 On Substr (Cd.Course_Code, 1, 4) + 'C' = Cd2.Course_Code And Cd.Country = Cd2.Country
-- Where Upper (Cd.Course_Type) = 'Citrix' And Cd.Ch_Num = '20';;;



