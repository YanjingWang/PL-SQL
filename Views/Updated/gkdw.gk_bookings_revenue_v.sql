


Create Or Alter View Hold.Gk_Bookings_Revenue_V
(
   Gk_Dim_Year,
   Gk_Dim_Quarter,
   Gk_Dim_Period_Name,
   Gk_Dim_Week,
   Gk_Dim_Date,
   Gk_Curr_Code,
   Gk_Event_Channel,
   Gk_Event_Modality,
   Gk_Event_Prod_Line,
   Gk_Book_Amt,
   Gk_Rev_Amt
)
As
     Select   Gk_Dim_Year,
              Gk_Dim_Quarter,
              Gk_Dim_Period_Name,
              Gk_Dim_Week,
              Gk_Dim_Date,
              Gk_Curr_Code,
              Gk_Event_Channel,
              Gk_Event_Modality,
              Gk_Event_Prod_Line,
              Sum (Gk_Book_Amt) Gk_Book_Amt,
              Sum (Gk_Rev_Amt) Gk_Rev_Amt
       From   (Select   T.Dim_Year Gk_Dim_Year,
                        T.Dim_Quarter Gk_Dim_Quarter,
                        T.Dim_Period_Name Gk_Dim_Period_Name,
                        T.Dim_Week Gk_Dim_Week,
                        T.Dim_Date Gk_Dim_Date,
                        Curr_Code Gk_Curr_Code,
                        E.Event_Channel Gk_Event_Channel,
                        E.Event_Modality Gk_Event_Modality,
                        E.Event_Prod_Line Gk_Event_Prod_Line,
                        F.Book_Amt Gk_Book_Amt,
                        0 Gk_Rev_Amt
                 From         Gkdw.Order_Fact F
                           Inner Join
                              Gkdw.Event_Dim E
                           On F.Event_Id = E.Event_Id
                        Inner Join
                           Gkdw.Time_Dim T
                        On F.Book_Date = T.Dim_Date
                Where   T.Dim_Year >= 2007
               Union All
               Select   T.Dim_Year,
                        T.Dim_Quarter,
                        T.Dim_Period_Name,
                        T.Dim_Week,
                        T.Dim_Date,
                        Curr_Code,
                        E.Event_Channel,
                        E.Event_Modality,
                        E.Event_Prod_Line,
                        0 Book_Amt,
                        F.Book_Amt
                 From         Gkdw.Order_Fact F
                           Inner Join
                              Gkdw.Event_Dim E
                           On F.Event_Id = E.Event_Id
                        Inner Join
                           Gkdw.Time_Dim T
                        On F.Rev_Date = T.Dim_Date
                Where   T.Dim_Year >= 2007) a1
   Group By   Gk_Dim_Year,
              Gk_Dim_Quarter,
              Gk_Dim_Period_Name,
              Gk_Dim_Week,
              Gk_Dim_Date,
              Gk_Curr_Code,
              Gk_Event_Channel,
              Gk_Event_Modality,
              Gk_Event_Prod_Line
   ;



