


Create Or Alter View Hold.Gk_Course_Prod_Lookup_V
(
   Ch_Num,
   Md_Num,
   Pl_Num,
   Act_Num,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type
)
As
   Select   Ch_Num,
            Md_Num,
            Pl_Num,
            Act_Num,
            Course_Ch,
            Course_Mod,
            Course_Pl,
            Course_Type
     From   (Select   Ch_Num,
                      Md_Num,
                      Pl_Num,
                      Act_Num,
                      Course_Ch,
                      Course_Mod,
                      Course_Pl,
                      Course_Type
               From   Gkdw.Course_Dim C1
              Where   Rowid =
                         (Select   Max (Rowid)
                            From   Gkdw.Course_Dim C2
                           Where       C1.Ch_Num = C2.Ch_Num
                                   And C1.Pl_Num = C2.Pl_Num
                                   And C1.Md_Num = C2.Md_Num
                                   And C1.Act_Num = C2.Act_Num)
             Union
             Select   Ch_Num,
                      Md_Num,
                      Pl_Num,
                      Act_Num,
                      Prod_Channel,
                      Prod_Modality,
                      Prod_Line,
                      Prod_Family
               From   Gkdw.Product_Dim P1
              Where   Rowid =
                         (Select   Max (Rowid)
                            From   Gkdw.Product_Dim P2
                           Where       P1.Ch_Num = P2.Ch_Num
                                   And P1.Pl_Num = P2.Pl_Num
                                   And P1.Md_Num = P2.Md_Num
                                   And P1.Act_Num = P2.Act_Num)) a1
--Select Distinct Short_Name,Course_Type,Ch_Num,Md_Num,Pl_Num,Act_Num,Course_Ch,Course_Mod,Course_Pl
--  From Gkdw.Course_Dim
-- Where Gkdw_Source = 'Slxdw'
-- And Inactive_Flag = 'F'
-- And Substr(Course_Code,5,1) Not In ('T','P')
-- And Md_Num Not In ('31')
-- And Course_Id Not In ('Q6uj9a0a7qb7','Q6uj9a3xy6j9','Q6uj9a3upowh','Q6uj9a3upowg','Q6uj9a04knc0','Q6uj9a072gnd')
-- And Isnull(Act_Num,'000000') != '000000'
--Union
--Select Distinct Prod_Name,Prod_Family,Ch_Num,Md_Num,Pl_Num,Act_Num,Prod_Channel,Prod_Modality,Prod_Line
--  From Gkdw.Product_Dim
-- Where Gkdw_Source = 'Slxdw'
--   And Status = 'Available'
--    And Isnull(Act_Num,'000000') != '000000'
--   And Product_Id Not In ('Y6uj9a0005ka');;



