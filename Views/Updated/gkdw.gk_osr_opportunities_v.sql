


Create Or Alter View Hold.Gk_Osr_Opportunities_V
(
   Opportunity_Id,
   Description,
   Closed,
   Stage,
   Sales_Potential,
   Close_Probability,
   Weighted_Sales,
   Estimated_Close,
   Status,
   Department,
   Region,
   Division,
   Username,
   Acct_Name,
   State,
   Territory_Id,
   Notes,
   Actual_Close,
   Actual_Amount,
   Est_Close_Month_Num,
   Est_Close_Period_Name,
   Est_Close_Year,
   Est_Close_Week,
   Est_Close_Quarter,
   Est_Close_Yyyymm,
   Act_Close_Yyyymm,
   Act_Close_Month_Num,
   Act_Close_Period_Name,
   Act_Close_Year,
   Act_Close_Week,
   Act_Clost_Quarter
)
As
   Select   Od.Opportunity_Id,
            Od.Description,
            Od.Closed,
            Od.Stage,
            Od.Sales_Potential,
            (Od.Close_Probability / 100) Close_Probability,
            ( (Od.Close_Probability / 100) * Od.Sales_Potential)
               Weighted_Sales,
            Od.Estimated_Close,
            Od.Status,
            U.Department,
            U.Region,
            U.Division,
            U.Username,
            Ad.Acct_Name,
            Ad.State,
            Gt.Territory_Id,
            Od.Notes,
            Actual_Close,
            Actual_Amount,
            Td.Dim_Month_Num Est_Close_Month_Num,
            Td.Dim_Period_Name Est_Close_Period_Name,
            Td.Dim_Year Est_Close_Year,
            Td.Dim_Week Est_Close_Week,
            Td.Dim_Quarter Est_Close_Quarter,
            Td.Dim_Year + '-' + Td.Dim_Month_Num Est_Close_Yyyymm,
            Td2.Dim_Year + '-' + Td2.Dim_Month_Num Act_Close_Yyyymm,
            Td2.Dim_Month_Num Act_Close_Month_Num,
            Td2.Dim_Period_Name Act_Close_Period_Name,
            Td2.Dim_Year Act_Close_Year,
            Td2.Dim_Week Act_Close_Week,
            Td2.Dim_Quarter Act_Clost_Quarter
     From                  Gkdw.Opportunity_Dim Od
                        Inner Join
                           Base.Userinfo U
                        On Od.Account_Manager_Id = U.Userid
                           And Department = 'Osr'
                     Left Outer Join
                        Gkdw.Account_Dim Ad
                     On Od.Account_Id = Ad.Acct_Id
                  Left Outer Join
                     Gkdw.Gk_Territory Gt
                  On Ad.Zipcode Between Gt.Zip_Start And Gt.Zip_End
                     And Gt.Territory_Type = 'Osr'
               Left Outer Join
                  Gkdw.Time_Dim Td
               On Format(Od.Estimated_Close, 'Dd-Mon-Yyyy') = Td.Dim_Date
            Left Outer Join
               Gkdw.Time_Dim Td2
            On Format(Od.Actual_Close, 'Dd-Mon-Yyyy') = Td2.Dim_Date;



