


Create Or Alter View Hold.Gk_Terillian_Courses_V
(
   Course_Id,
   Lab_Type
)
As
   Select   Pmm.[Slx_Id] Course_Id, 'Terillian' Lab_Type
     From            Base.Rms_Product_Modality_Mode Pmm
                  Inner Join
                     Base.Rms_Product_Line_Mode Plm
                  On Pmm.[Product_Line_Mode] = Plm.[Id]
               Inner Join
                  Base.Rms_Product_Modality_Category Pmc
               On Pmm.[Product] = Pmc.[Product]
                  And Plm.[Category] = Pmc.[Category]
            Inner Join
               Base.Rms_Product_Modality_Lab_Request Pml
            On Pmc.[Product] = Pml.[Product]
               And Pmc.[Category] = Pml.[Product_Line_Category]
    Where   Pml.[Lab_Request] = 'Remote Lab'
            And Pmc.[Special_Setup] Like '%Hosted Remote Labs%';



