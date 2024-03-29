


Create Or Alter View Hold.Gk_Pmp_V
(
   Course_Id,
   Course_Code,
   Event_Id,
   Start_Date,
   Cust_Id,
   Cust_Name,
   Acct_Id,
   Acct_Name,
   Enroll_Date,
   Enroll_Status,
   Sales_Rep
)
As
     Select   Distinct Cd.Course_Id,
                       Cd.Course_Code,
                       Ed.Event_Id,
                       Ed.Start_Date,
                       C.Cust_Id,
                       C.Cust_Name,
                       C.Acct_Id,
                       C.Acct_Name,
                       F.Enroll_Date,
                       F.Enroll_Status,
                       F.Sales_Rep
       From            Gkdw.Course_Dim Cd
                    Inner Join
                       Gkdw.Event_Dim Ed
                    On Cd.Course_Id = Ed.Course_Id
                       And Cd.Country = Ed.Ops_Country
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id --And F.Enroll_Status In ('Confirmed','Attended')
              Inner Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Cd.Course_Code In (  Select   Course_Code From Gkdw.Gk_Pmp_Guided)
              And F.Enroll_Date >= Cast(Getutcdate() As Date) - 150
   ;



