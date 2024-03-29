


Create Or Alter View Hold.Gk_Cdw_Spel_Except_V
(
   Except_Grp,
   Period_Name,
   Batch_Name,
   Je_Category,
   Je_Source,
   Je_Line_Num,
   Description,
   Ops_Country,
   Ch,
   Md,
   Product_Num,
   Prod_Name,
   Gross_Revenue
)
As
   Select   'Ex-Spel_Not_On_Master' Except_Grp,
            J.Period_Name,
            B.Name Batch_Name,
            H.Je_Category,
            H.Je_Source,
            J.Je_Line_Num,
            J.Description,
            Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End
               Ops_Country,
            Gcc.Segment4 Ch,
            Gcc.Segment5 Md,
            Case
               When Substring(Gcc.Segment7, 1,  1) = '0'
               Then
                  Substring(Gcc.Segment7, 3,  4) + 'S'
               Else
                  Gcc.Segment7
            End
               Product_Num,
            Pd.Prod_Name,
            Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0) Gross_Revenue
     From                  Gl_Je_Lines@R12prd J
                        Inner Join
                           Gl_Je_Headers@R12prd H
                        On J.Je_Header_Id = H.Je_Header_Id
                     Inner Join
                        Gl_Je_Batches@R12prd B
                     On H.Je_Batch_Id = B.Je_Batch_Id
                  Inner Join
                     Gl_Code_Combinations@R12prd Gcc
                  On J.Code_Combination_Id = Gcc.Code_Combination_Id
               Left Outer Join
                  Gkdw.Gk_Cdw_Interface C
               On Gcc.Segment7 =
                     Case
                        When Substring(Gcc.Segment7, 1,  1) = '0'
                        Then
                           Lpad (Substring(C.Gk_Course_Num, 1,  4), 6, '00')
                        Else
                           C.Gk_Course_Num
                     End
                  And C.Spel_Rate Is Not Null
            Left Outer Join
               Gkdw.Product_Dim Pd
            On Gk_Course_Num = Pd.Prod_Num And Pd.Status = 'Available'
    Where       Gcc.Segment3 = '41105'
            And Gcc.Segment5 = '31'
            And Gcc.Segment6 = '04'
            And C.Gk_Course_Num Is Null
   Union
   Select   'Ex-Spel_Not_On_Master',
            J.Period_Name,
            B.Name Batch_Name,
            H.Je_Category,
            H.Je_Source,
            J.Je_Line_Num,
            J.Description,
            Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End
               Ops_Country,
            Gcc.Segment4 Ch,
            Gcc.Segment5 Md,
            Case
               When Substring(Gcc.Segment7, 1,  1) = '0'
               Then
                  Substring(Gcc.Segment7, 3,  4) + 'W'
               Else
                  Gcc.Segment7 + 'W'
            End
               Product_Num,
            Cd.Short_Name,
            Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0) Gross_Revenue
     From                  Gl_Je_Lines@R12prd J
                        Inner Join
                           Gl_Je_Headers@R12prd H
                        On J.Je_Header_Id = H.Je_Header_Id
                     Inner Join
                        Gl_Je_Batches@R12prd B
                     On H.Je_Batch_Id = B.Je_Batch_Id
                  Inner Join
                     Gl_Code_Combinations@R12prd Gcc
                  On J.Code_Combination_Id = Gcc.Code_Combination_Id
               Left Outer Join
                  Gkdw.Gk_Cdw_Interface C
               On Gcc.Segment7 =
                     Case
                        When Substring(Gcc.Segment7, 1,  1) = '0'
                        Then
                           Lpad (Substring(C.Gk_Course_Num, 1,  4), 6, '00')
                        Else
                           C.Gk_Course_Num
                     End
                  And C.Spel_Rate Is Not Null
            Left Outer Join
               Gkdw.Course_Dim Cd
            On Case
                  When Substring(Gcc.Segment7, 1,  1) = '0'
                  Then
                     Substring(Gcc.Segment7, 3,  4) + 'W'
                  Else
                     Gcc.Segment7 + 'W'
               End = Cd.Course_Code
               And Case
                     When Gcc.Segment1 = '220' Then 'Canada'
                     Else 'Usa'
                  End = Cd.Country
    Where       Gcc.Segment3 = '41105'
            And Gcc.Segment5 = '32'
            And Gcc.Segment6 = '04'
            And C.Gk_Course_Num Is Null
--   Select 'Ex-Spel_Not_On_Master', J.Period_Name, B.Name Batch_Name,
--          H.Je_Category, H.Je_Source, J.Je_Line_Num, J.Description,
--          Case
--             When Gcc.Segment1 = '220'
--                Then 'Can'
--             Else 'Usa'
--          End Ops_Country, Gcc.Segment4 Ch, Gcc.Segment5 Md,
--          Case
--             When Substring(Gcc.Segment7, 1,  1) = '0'
--                Then Substring(Gcc.Segment7, 3,  4) + 'W'
--             Else Gcc.Segment7 + 'W'
--          End Product_Num,
--          Pd.Prod_Name,
--          Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0) Gross_Revenue
--     From Gl_Je_Lines@R12prd J Inner Join Gl_Je_Headers@R12prd H
--          On J.Je_Header_Id = H.Je_Header_Id
--          Inner Join Gl_Je_Batches@R12prd B On H.Je_Batch_Id = B.Je_Batch_Id
--          Inner Join Gl_Code_Combinations@R12prd Gcc
--          On J.Code_Combination_Id = Gcc.Code_Combination_Id
--          Left Outer Join Gkdw.Gk_Cdw_Interface C
--          On Gcc.Segment7 =
--               Case
--                  When Substring(Gcc.Segment7, 1,  1) = '0'
--                     Then Lpad (Substring(C.Gk_Course_Num, 1,  4), 6, '00')
--                  Else C.Gk_Course_Num
--               End
--        And C.Spel_Rate Is Not Null
--          Left Outer Join Gkdw.Product_Dim Pd
--          On Gk_Course_Num = Pd.Prod_Num And Pd.Status = 'Available'
--    Where Gcc.Segment3 = '41105'
--      And Gcc.Segment5 = '32'
--      And Gcc.Segment6 = '04'
--      And C.Gk_Course_Num Is Null;;;



