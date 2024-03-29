


Create Or Alter View Hold.Gk_Managed_Program_V
(
   Managed_Program_Id,
   Event_Id,
   Course_Code,
   Short_Name,
   Event_Desc,
   Start_Date,
   End_Date,
   Location_Name,
   City,
   State,
   Country,
   Po_Num,
   Creation_Date,
   Po_Header_Id,
   Po_Line_Id,
   Line_Num,
   Po_Distribution_Id,
   Code_Combination_Id,
   Segment1,
   Le_Desc,
   Segment2,
   Fe_Desc,
   Segment3,
   Acct_Desc,
   Segment4,
   Ch_Desc,
   Segment5,
   Md_Desc,
   Segment6,
   Pl_Desc,
   Segment7,
   Act_Desc,
   Segment8,
   Cc_Desc,
   Po_Amt,
   Invoice_Id,
   Invoice_Num,
   Invoice_Currency_Code,
   Invoice_Amount,
   Invoice_Description,
   Invoice_Distribution_Id,
   Description,
   Unit_Price,
   Quantity_Invoiced,
   Amount
)
As
     Select   Ed.Managed_Program_Id,
              Ed.Event_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Ed.Event_Desc,
              Ed.Start_Date,
              Ed.End_Date,
              Ed.Location_Name,
              Ed.City,
              Ed.State,
              Ed.Country,
              Ph.Segment1 Po_Num,
              Ph.Creation_Date,
              Ph.Po_Header_Id,
              Pl.Po_Line_Id,
              Pl.Line_Num,
              Pd.Po_Distribution_Id,
              Pd.Code_Combination_Id,
              Gcc.Segment1,
              L.Le_Desc,
              Gcc.Segment2,
              F.Fe_Desc,
              Gcc.Segment3,
              A.Acct_Desc,
              Gcc.Segment4,
              C.Ch_Desc,
              Gcc.Segment5,
              M.Md_Desc,
              Gcc.Segment6,
              P.Pl_Desc,
              Gcc.Segment7,
              Ac.Act_Desc,
              Gcc.Segment8,
              Cc.Cc_Desc,
              Sum (Pd.Quantity_Ordered * Pl.Unit_Price) Po_Amt,
              Ai.Invoice_Id,
              Ai.Invoice_Num,
              Ai.Invoice_Currency_Code,
              Ai.Invoice_Amount,
              Ai.Description Invoice_Description,
              Aid.Invoice_Distribution_Id,
              Aid.Description,
              Aid.Unit_Price,
              Aid.Quantity_Invoiced,
              Aid.Amount
       From                                                Gkdw.Event_Dim Ed
                                                        Inner Join
                                                           Gkdw.Course_Dim Cd
                                                        On Ed.Course_Id =
                                                              Cd.Course_Id
                                                           And Ed.Ops_Country =
                                                                 Cd.Country
                                                     Left Outer Join
                                                        Po_Distributions_All@R12prd Pd
                                                     On Ed.Event_Id =
                                                           Pd.Attribute2
                                                  Left Outer Join
                                                     Po_Lines_All@R12prd Pl
                                                  On Pd.Po_Line_Id =
                                                        Pl.Po_Line_Id
                                               Left Outer Join
                                                  Po_Headers_All@R12prd Ph
                                               On Pl.Po_Header_Id =
                                                     Ph.Po_Header_Id
                                            Left Outer Join
                                               Gl_Code_Combinations@R12prd Gcc
                                            On Pd.Code_Combination_Id =
                                                  Gcc.Code_Combination_Id
                                         Left Outer Join
                                            Ap_Invoice_Distributions_All@R12prd Aid
                                         On Pd.Po_Distribution_Id =
                                               Aid.Po_Distribution_Id
                                            And Isnull(Aid.Reversal_Flag, 'N') =
                                                  'N'
                                      Left Outer Join
                                         Ap_Invoices_All@R12prd Ai
                                      On Aid.Invoice_Id = Ai.Invoice_Id
                                   Left Outer Join
                                      Gkdw.Le_Dim L
                                   On Gcc.Segment1 = L.Le_Value
                                Left Outer Join
                                   Gkdw.Fe_Dim F
                                On Gcc.Segment2 = F.Fe_Value
                             Left Outer Join
                                Gkdw.Acct_Dim A
                             On Gcc.Segment3 = A.Acct_Value
                          Left Outer Join
                             Gkdw.Ch_Dim C
                          On Gcc.Segment4 = C.Ch_Value
                       Left Outer Join
                          Gkdw.Md_Dim M
                       On Gcc.Segment5 = M.Md_Value
                    Left Outer Join
                       Gkdw.Pl_Dim P
                    On Gcc.Segment6 = P.Pl_Value
                 Left Outer Join
                    Gkdw.Act_Dim Ac
                 On Gcc.Segment7 = Ac.Act_Value
              Left Outer Join
                 Gkdw.Cc_Dim Cc
              On Gcc.Segment8 = Cc.Cc_Value
      Where   Ed.Managed_Program_Id Is Not Null
   Group By   Ed.Managed_Program_Id,
              Ed.Event_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Ed.Event_Desc,
              Ed.Start_Date,
              Ed.End_Date,
              Ed.Location_Name,
              Ed.City,
              Ed.State,
              Ed.Country,
              Ph.Segment1,
              Ph.Creation_Date,
              Ph.Po_Header_Id,
              Pl.Po_Line_Id,
              Pl.Line_Num,
              Pd.Po_Distribution_Id,
              Pd.Code_Combination_Id,
              Gcc.Segment1,
              L.Le_Desc,
              Gcc.Segment2,
              F.Fe_Desc,
              Gcc.Segment3,
              A.Acct_Desc,
              Gcc.Segment4,
              C.Ch_Desc,
              Gcc.Segment5,
              M.Md_Desc,
              Gcc.Segment6,
              P.Pl_Desc,
              Gcc.Segment7,
              Ac.Act_Desc,
              Gcc.Segment8,
              Cc.Cc_Desc,
              Ai.Invoice_Id,
              Ai.Invoice_Num,
              Ai.Invoice_Currency_Code,
              Ai.Invoice_Amount,
              Ai.Description,
              Aid.Invoice_Distribution_Id,
              Aid.Description,
              Aid.Unit_Price,
              Aid.Quantity_Invoiced,
              Aid.Amount
   ;



