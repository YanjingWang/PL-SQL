


Create Or Alter View Hold.Gk_Us_Gtr_V
(
   Ops_Country,
   Start_Week,
   Start_Date,
   Event_Id,
   Metro,
   Facility_Code,
   Course_Code,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Inst_Type,
   Inst_Name,
   Revenue,
   Total_Cost,
   Enroll_Cnt,
   Margin,
   Gtr_Level
)
As
   Select   Gn.Ops_Country,
            Gn.Start_Week,
            Gn.Start_Date,
            Gn.Event_Id,
            Gn.Metro,
            Gn.Facility_Code,
            Gn.Course_Code,
            Gn.Course_Ch,
            Gn.Course_Mod,
            Gn.Course_Pl,
            Gn.Course_Type,
            Gn.Inst_Type,
            Gn.Inst_Name,
            Gn.Revenue,
            Case
               When Gn.Facility_Cost = 0 And F.Audit_Rate Is Not Null
               Then
                  Total_Cost
                  + F.Audit_Rate * (Ed.End_Date - Ed.Start_Date + 1)
               Else
                  Gn.Total_Cost
            End
               Total_Cost,
            Gn.Enroll_Cnt,
            Case
               When Revenue = 0
               Then
                  0
               When Gn.Facility_Cost = 0 And F.Audit_Rate Is Not Null
               Then
                  (Revenue
                   - (Total_Cost
                      + F.Audit_Rate * (Ed.End_Date - Ed.Start_Date + 1)))
                  / Revenue
               Else
                  Gn.Margin
            End
               Margin,
            Case
               When Gn.Start_Date Between Cast(Getutcdate() As Date)
                                      And  Cast(Getutcdate() As Date) + 14
               Then
                  '1'
               Else
                  '2'
            End
               Gtr_Level
     From            Gkdw.Gk_Go_Nogo_V Gn
                  Inner Join
                     Gkdw.Event_Dim Ed
                  On Gn.Event_Id = Ed.Event_Id
               Inner Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
            Left Outer Join
               Gkdw.Gk_Facility_Cc_Dim F
            On Ed.Facility_Code = F.Facility_Code
    Where   (    Gn.Ops_Country = 'Usa'
             And Case
                   When Revenue = 0
                   Then
                      0
                   When Gn.Facility_Cost = 0 And F.Audit_Rate Is Not Null
                   Then
                      (Revenue
                       - (Total_Cost
                          + F.Audit_Rate * (Ed.End_Date - Ed.Start_Date + 1)))
                      / Revenue
                   Else
                      Gn.Margin
                End >= .35
             And Enroll_Cnt >= 4
             And Gn.Start_Date >= Cast(Getutcdate() As Date)
             And Inst_Cost > 0
             And Isnull(Ed.Plan_Type, 'None') != 'Sales Request'
             And Isnull(Cd.Course_Type, 'None') != 'Virtual Short Course'
             And Cd.Course_Pl Not In ('Other - Nest; Security-Emea', 'Rsa')
             And (   F.Audit_Rate Is Not Null
                  Or Gn.Facility_Cost > 0
                  Or Gn.Metro = 'Vcl'))
            Or (Gn.Ops_Country = 'Usa'
                And Gn.Start_Date Between Cast(Getutcdate() As Date)
                                      And  Cast(Getutcdate() As Date) + 14
                And Cd.Course_Pl != 'Other - Nest; Security-Emea');



