


Create Or Alter View Hold.Gk_Product_Desc_V
(
   Us_Code,
   Product_Code,
   Description,
   Event_Prod_Line
)
As
     Select   P.[Us_Code] Us_Code,
              P.[Product_Code] Product_Code,
              P.[Description] Description,
              Cd.Course_Pl Event_Prod_Line
       From   Base.Rms_Product P,
              Base.Rms_Product_Modality_Mode Mm,
              Gkdw.Course_Dim Cd
      Where       P.[Id] = Mm.[Product]
              And Mm.[Slx_Id] = Cd.Course_Id
              And Cd.Gkdw_Source = 'Slxdw'
              And Cd.Course_Pl Is Not Null
              And Cd.Inactive_Flag = 'F'
              And P.[Active_Course_Master] = 'Yes'
   Group By   P.[Us_Code],
              P.[Product_Code],
              P.[Description],
              Cd.Course_Pl;



