


Create Or Alter View Hold.Gk_Course_Rev_Rank_V
(
   Course_Code,
   Rev_Amt,
   Rev_Rank
)
As
     Select   Cd.Course_Code,
              Sum (Book_Amt) Rev_Amt,
              Rank () Over (Order By Sum (Book_Amt) Desc) Rev_Rank
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Ed.Start_Date >= Cast(Getutcdate() As Date) - 365
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20', '41', '42')
   Group By   Cd.Course_Code
   ;



