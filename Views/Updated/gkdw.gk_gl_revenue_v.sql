


Create Or Alter View Hold.Gk_Gl_Revenue_V
(
   Acct,
   Ch,
   Md,
   Pl,
   Period_Name,
   Period_Num,
   Period_Year,
   Gl_Amt
)
As
     Select   X.Segment3 Acct,
              X.Segment4 Ch,
              X.Segment5 Md,
              X.Segment6 Pl,
              Y.Period_Name,
              Y.Period_Num,
              Y.Period_Year,
              Sum (Y.Period_Net_Cr - Y.Period_Net_Dr) Gl_Amt
       From      Gl_Code_Combinations@R12prd X
              Inner Join
                 Gl_Balances@R12prd Y
              On X.Code_Combination_Id = Y.Code_Combination_Id
      --Inner Join Gkdw.Fnd_Flex_Values Z On X.Segment6 = Z.Flex_Value And Z.Flex_Value_Set_Id = 1007699
      Where       X.Segment1 = '210'
              And X.Segment3 Between '40000' And '49999'
              And X.Segment3 Not In ('41315', '41210')
              --And X.Segment3 = '41105'
              --And X.Segment6 = '04'
              And Y.Period_Year = '2012'
              And Y.Currency_Code = 'Usd'
              And Actual_Flag = 'A'
              --And Y.Set_Of_Books_Id = 2
              And X.Segment4 = '10'
   --And X.Segment5 = '31'
   Group By   Y.Period_Year,
              Y.Period_Num,
              Y.Period_Name,
              X.Segment3,
              X.Segment6,
              X.Segment5,
              X.Segment4
     Having   Sum (Y.Period_Net_Cr - Y.Period_Net_Dr) <> 0
   ;









