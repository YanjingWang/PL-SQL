


Create Or Alter View Hold.Gk_Gross_Pipeline_V
(
   Opportunityid,
   Accountid,
   Account,
   Description,
   Stage,
   Closeprobability,
   Opp_Status,
   Opp_Stage,
   Ent_Potential_Amount,
   Salespotential,
   Salesprocess_Name,
   Username,
   User_Manager,
   Department,
   Sales_Group,
   Sales_Team,
   Opp_Create_Date,
   Dim_Year,
   Dim_Quarter,
   Dim_Month_Num,
   Dim_Period_Name,
   Dim_Week,
   Est_Close_Date,
   Rolling_3_Mo,
   Rolling_12_Mo,
   Book_Amt,
   Gross_Pipeline,
   Close_Ge_50,
   Close_Ge_70,
   Lob,
   Sector,
   Subsector,
   Weighted_Amt,
   Age,
   Age_Category,
   Unweighted_Category,
   Weighted_Category
)
As
   Select   O.Opportunityid,
            O.Accountid,
            Ac.Account,
            O.Description,
            O.Stage,
            Lpad (Isnull(Spa.Probability, 0), 3, '0') + '%' Closeprobability,
            O.Status Opp_Status,
               Lpad (Isnull(Spa.Stageorder, '99'), 2, '0')
            + '-'
            + Spa.Stagename
            + '('
            + Spa.Probability
            + '%)'
               Opp_Stage,
            Isnull(Qo.Ent_Potential_Amount, 0) Ent_Potential_Amount,
            Isnull(Salespotential, 0) Salespotential,
            Sp.Name Salesprocess_Name,
            Ui1.Username,
            Um.Username User_Manager,
            Ui1.Department,
            Ui1.Region Sales_Group,
            Ui1.Division Sales_Team,
            O.Createdate Opp_Create_Date,
            Td.Dim_Year,
            Case
               When Td.Dim_Year Is Null Then Null
               Else Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter, 2, '0')
            End
               Dim_Quarter,
            Case
               When Td.Dim_Year Is Null Then Null
               Else Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
            End
               Dim_Month_Num,
            Td.Dim_Period_Name,
            Case
               When Td.Dim_Year Is Null Then Null
               Else Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0')
            End
               Dim_Week,
            Trunc (O.Estimatedclose) Est_Close_Date,
            Case
               When Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td2.Dim_Year
                                                                                  + '-'
                                                                                  + Lpad (
                                                                                        Td2.Dim_Month_Num,
                                                                                        2,
                                                                                        '0'
                                                                                     )
                                                                              And  Td3.Dim_Year
                                                                                   + '-'
                                                                                   + Lpad (
                                                                                         Td3.Dim_Month_Num,
                                                                                         2,
                                                                                         '0'
                                                                                      )
               Then
                  'Y'
               Else
                  'N'
            End
               Rolling_3_Mo,
            Case
               When Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td2.Dim_Year
                                                                                  + '-'
                                                                                  + Lpad (
                                                                                        Td2.Dim_Month_Num,
                                                                                        2,
                                                                                        '0'
                                                                                     )
                                                                              And  Td4.Dim_Year
                                                                                   + '-'
                                                                                   + Lpad (
                                                                                         Td4.Dim_Month_Num,
                                                                                         2,
                                                                                         '0'
                                                                                      )
               Then
                  'Y'
               Else
                  'N'
            End
               Rolling_12_Mo,
            Ob.Book_Amt,
            Case
               When Qo.Ent_Potential_Amount Is Null
               Then
                  Isnull(O.Salespotential, 0)
               When Qo.Ent_Potential_Amount = 0
               Then
                  Isnull(O.Salespotential, 0)
               Else
                  Qo.Ent_Potential_Amount
            End
               Gross_Pipeline,
            --       Isnull(Qo.Ent_Potential_Amount,O.Salespotential) Gross_Pipeline,
            Case When Spa.Probability >= 50 Then 'Y' Else 'N' End Close_Ge_50,
            Case When Spa.Probability >= 70 Then 'Y' Else 'N' End Close_Ge_70,
            Qo.Knowledge_Center Lob,
            Qa.Sector,
            Qa.Subsector,
            (O.Salespotential * Spa.Probability) / 100 Weighted_Amt,
            Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 Age,
            Case
               When Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 <= 30
               Then
                  '30'
               When Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 <= 60
               Then
                  '60'
               When Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 <= 90
               Then
                  '90'
               When Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 <= 120
               Then
                  '120'
               When Cast(Getutcdate() As Date) - Trunc (O.Createdate) + 1 > 120
               Then
                  '120+'
            End
               Age_Category,
            Case
               When O.Salespotential < 2000 Then '$0-1999'
               When O.Salespotential < 10000 Then '$2000-9999'
               When O.Salespotential < 20000 Then '$10000-19999'
               When O.Salespotential < 40000 Then '$20000-39999'
               When O.Salespotential < 50000 Then '$40000-49999'
               When O.Salespotential >= 50000 Then '$50000+'
            End
               Unweighted_Category,
            Case
               When (O.Salespotential * Spa.Probability) / 100 < 2000
               Then
                  '$0-1999'
               When (O.Salespotential * Spa.Probability) / 100 < 10000
               Then
                  '$2000-9999'
               When (O.Salespotential * Spa.Probability) / 100 < 20000
               Then
                  '$10000-19999'
               When (O.Salespotential * Spa.Probability) / 100 < 40000
               Then
                  '$20000-39999'
               When (O.Salespotential * Spa.Probability) / 100 < 50000
               Then
                  '$40000-49999'
               When (O.Salespotential * Spa.Probability) / 100 >= 50000
               Then
                  '$50000+'
            End
               Weighted_Category
     --       Case When Isnull(Qo.Ent_Potential_Amount,0)-Isnull(Ob.Book_Amt,0) < 0 Then 0
     --            Else Isnull(Qo.Ent_Potential_Amount,0)-Isnull(Ob.Book_Amt,0)
     --       End Gross_Pipeline
     From                                          Base.Opportunity O
                                                Inner Join
                                                   Base.Qg_Opportunity Qo
                                                On O.Opportunityid =
                                                      Qo.Opportunityid
                                             Inner Join
                                                Base.Userinfo Ui1
                                             On O.Accountmanagerid =
                                                   Ui1.Userid
                                          Inner Join
                                             Base.Usersecurity Us
                                          On Ui1.Userid = Us.Userid
                                       Inner Join
                                          Base.Userinfo Um
                                       On Us.Managerid = Um.Userid
                                    Inner Join
                                       Base.Account Ac
                                    On O.Accountid = Ac.Accountid
                                 Inner Join
                                    Base.Qg_Account Qa
                                 On Ac.Accountid = Qa.Accountid
                              Left Outer Join
                                 Gkdw.Time_Dim Td
                              On Trunc (O.Estimatedclose) = Td.Dim_Date
                           Left Outer Join
                              Base.Salesprocesses Sp
                           On O.Opportunityid = Sp.Entityid
                        Left Outer Join
                           Base.Salesprocessaudit Spa
                        On Sp.Salesprocessesid = Spa.Salesprocessid
                           And O.Stage =
                                 Spa.Stageorder + '-' + Spa.Stagename
                           And Spa.Processtype = 'Stage'
                     Inner Join
                        Gkdw.Time_Dim Td2
                     On Td2.Dim_Date = Cast(Getutcdate() As Date)
                  Inner Join
                     Gkdw.Time_Dim Td3
                  On Td3.Dim_Date = Cast(Getutcdate() As Date) + 90
               Inner Join
                  Gkdw.Time_Dim Td4
               On Td4.Dim_Date = Cast(Getutcdate() As Date) + 365
            Left Outer Join
               Gkdw.Gk_Opp_Bookings_V Ob
            On O.Opportunityid = Ob.Opportunityid
    Where       Td.Dim_Year >= 2009
            And O.Status = 'Open'
            And Upper (Ui1.Department) Like '%Enterprise%';





