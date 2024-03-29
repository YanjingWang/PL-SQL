


Create Or Alter View Hold.Gk_Prepay_Cust_Count_V
(
   Ppcard_Id,
   Issued_To_Cust_Id,
   Old_Cards,
   Old_Cust
)
As
     Select   New.Ppcard_Id,
              New.Issued_To_Cust_Id,
              Count (Distinct Old.Ppcard_Id) Old_Cards,
              Case
                 When Count (Distinct Old.Ppcard_Id) = 0 Then 'N'
                 When Count (Distinct Old.Ppcard_Id) > 0 Then 'Y'
              End
                 Old_Cust
       From      Gkdw.Ppcard_Dim New
              Left Outer Join
                 Gkdw.Ppcard_Dim Old
              On New.Issued_To_Cust_Id = Old.Issued_To_Cust_Id
                 And Trunc (New.Creation_Date) > Trunc (Old.Creation_Date)
   Group By   New.Ppcard_Id, New.Issued_To_Cust_Id;



