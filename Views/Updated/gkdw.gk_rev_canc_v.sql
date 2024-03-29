


Create Or Alter View Hold.Gk_Rev_Canc_V
(
   Ops_Country,
   Event_Modality,
   Book_Period,
   Rev_Period,
   Canc_Count,
   Canc_Amt
)
As
     Select   E.Ops_Country,
              E.Event_Modality,
              Lpad (Tb.Dim_Month_Num, 2, '0') + '-' + Tb.Dim_Period_Name
                 Book_Period,
              Lpad (Tr.Dim_Month_Num, 2, '0') + '-' + Tr.Dim_Period_Name
                 Rev_Period,
              Count (Enroll_Id) Canc_Count,
              Sum (F.Book_Amt) Canc_Amt
       From            Gkdw.Order_Fact F
                    Inner Join
                       Gkdw.Event_Dim E
                    On F.Event_Id = E.Event_Id
                 Inner Join
                    Gkdw.Time_Dim Tr
                 On F.Rev_Date = Tr.Dim_Date
              Inner Join
                 Gkdw.Time_Dim Tb
              On F.Book_Date = Tb.Dim_Date
      Where       Enroll_Status_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
              And E.Event_Channel = 'Individual/Public'
              And Enroll_Status = 'Cancelled'
              And Book_Amt < 0
   Group By   E.Ops_Country,
              E.Event_Modality,
              Tb.Dim_Period_Name,
              Tb.Dim_Month_Num,
              Tr.Dim_Period_Name,
              Tr.Dim_Month_Num
   ;



