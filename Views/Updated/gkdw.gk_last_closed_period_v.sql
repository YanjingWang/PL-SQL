


Create Or Alter View Hold.Gk_Last_Closed_Period_V (Last_Period)
As
   Select   Max (Period_Year + '-' + Lpad (Period_Num, 2, '0')) Last_Period
     From   Gl_Periods@R12prd
    Where   End_Date < Cast(Getutcdate() As Date) And Period_Set_Name = 'Gknet Acctg';



