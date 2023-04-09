


Create Or Alter View Hold.Gk_Total_Pipeline_Dates_V
(
   Dim_Date,
   Dim_Day,
   Dim_Week,
   Dim_Month_Num,
   Week_Num
)
As
     Select   Dim_Date,
              Dim_Day,
              Dim_Week,
              Dim_Month_Num,
              Case
                 When Dim_Month_Num <= 3
                 Then
                    Dim_Week - (Dim_Month_Num - 1) * 4
                 When Dim_Month_Num <= 6
                 Then
                    (Dim_Week - 1) - (Dim_Month_Num - 1) * 4
                 When Dim_Month_Num <= 9
                 Then
                    (Dim_Week - 2) - (Dim_Month_Num - 1) * 4
                 When Dim_Month_Num <= 12
                 Then
                    (Dim_Week - 3) - (Dim_Month_Num - 1) * 4
              End
                 Week_Num
       From   Gkdw.Time_Dim
      Where       Dim_Year >= 2011
              And Dim_Day = 'Tuesday'
              And Case
                    When Dim_Month_Num <= 3
                    Then
                       Dim_Week - (Dim_Month_Num - 1) * 4
                    When Dim_Month_Num <= 6
                    Then
                       (Dim_Week - 1) - (Dim_Month_Num - 1) * 4
                    When Dim_Month_Num <= 9
                    Then
                       (Dim_Week - 2) - (Dim_Month_Num - 1) * 4
                    When Dim_Month_Num <= 12
                    Then
                       (Dim_Week - 3) - (Dim_Month_Num - 1) * 4
                 End = 2
   ;



