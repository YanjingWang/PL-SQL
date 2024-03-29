


Create Or Alter View Hold.Gk_Product_Int_Fac_Cost_V
(
   Period_Year,
   Cc_Num,
   Tc_Amt,
   Event_Days,
   Tc_Amt_Per_Event_Day
)
As
     Select   Fc.Period_Year,
              Fc.Cc_Num,
              Fc.Tc_Amt,
              Sum (End_Date - Start_Date + 1) Event_Days,
              Fc.Tc_Amt / Sum (End_Date - Start_Date + 1) Tc_Amt_Per_Event_Day
       From            Gk_Int_Fac_Cost_V@R12prd Fc
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Fc.Period_Year = Td.Dim_Year
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On Td.Dim_Date = Ed.Start_Date
              Inner Join
                 Gkdw.Gk_Facility_Cc_Dim Gc
              On Fc.Cc_Num = Gc.Cc_Num And Ed.Facility_Code = Gc.Facility_Code,
              Gk_Last_Closed_Period_V Lc
      Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, 0) Between '2004-01'
                                                                      And  Lc.Last_Period
              And Ed.Status != 'Cancelled'
              And Ed.Internalfacility = 'T'
   Group By   Fc.Period_Year, Fc.Cc_Num, Fc.Tc_Amt;



