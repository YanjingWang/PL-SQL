


Create Or Alter View Hold.Gk_Instructor_Rate_V
(
   Instructor_Id,
   Ins_Name,
   Account,
   Pay_Curr_Code,
   Var_Exempt,
   Third_Party_Vendor,
   Spec_Inst,
   Bootcamp_Rate,
   Bootcamp_Start,
   Daily_Rate,
   Daily_Start,
   Enterprise_Rate,
   Enterprise_Start,
   Minicamp_Rate,
   Minicamp_Start,
   Vcl_Full_Rate,
   Vcl_Full_Start,
   Vcl_Half_Rate,
   Vcl_Half_Start,
   Variable_Rate,
   Variable_Start,
   Ms_Standard_Rate,
   Ms_Standard_Start,
   Ms_Advanced_Rate,
   Ms_Advanced_Start,
   Vcl_Bootcamp_Rate,
   Vcl_Bootcamp_Start
)
As
   Select   [Instructor_Id],
            [Ins_Name],
            [Account],
            [Pay_Curr_Code],
            [Var_Exempt],
            [Third_Party_Vendor],
            [Spec_Inst],
            [Bootcamp_Rate],
            [Bootcamp_Start],
            [Daily_Rate],
            [Daily_Start],
            [Enterprise_Rate],
            [Enterprise_Start],
            [Minicamp_Rate],
            [Minicamp_Start],
            [Vcl_Full_Rate],
            [Vcl_Full_Start],
            [Vcl_Half_Rate],
            [Vcl_Half_Start],
            [Variable_Rate],
            [Variable_Start],
            [Ms_Standard_Rate],
            [Ms_Standard_Start],
            [Ms_Advanced_Rate],
            [Ms_Advanced_Start],
            [Vcl_Bootcamp_Rate],
            [Vcl_Bootcamp_Start]
     From   Gk_Instructor_Rate_V@Gkprod;





