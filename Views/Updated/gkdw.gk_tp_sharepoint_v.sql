


Create Or Alter View Hold.Gk_Tp_Sharepoint_V
(
   Tab_Type,
   Sales_Rep,
   Sales_Rep_Email,
   Manager_Name,
   Manager_Email,
   Dim_Year,
   Dim_Month_Num,
   Book_Mo,
   Book_Date,
   Book_Amt,
   Customer_Parent,
   Sales_Team,
   Evxevenrollid,
   Eventid,
   Coursecode,
   Eventname,
   Startdate,
   Prepay_Card,
   Pack_Issued,
   Student_Postalcode,
   Province,
   Pack_Type,
   Eventcountry
)
As
   Select   Tp.*
     From      Gkdw.Gk_Tps_Data_Mv Tp
            Inner Join
               Gkdw.Time_Dim Td
            On Td.Dim_Date = Cast(Getutcdate() As Date)
    Where   Tp.Dim_Year = Td.Dim_Year And Tp.Dim_Month_Num = Td.Dim_Month_Num
            And Year(Tp.Book_Date) =
                  Year(Getutcdate())
            And Month(Tp.Book_Date) =
                  Month(Getutcdate());



