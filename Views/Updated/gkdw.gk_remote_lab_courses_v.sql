


Create Or Alter View Hold.Gk_Remote_Lab_Courses_V
(
   Course_Id,
   Rms_Product_Id,
   Rms_Mode_Id,
   Lab_Type,
   Bandwidth,
   Internet_Type,
   Remote_Lab_Provider,
   Special_Setup
)
As
   Select   Pmm.[Slx_Id] Course_Id,
            Pmm.[Product] Rms_Product_Id,
            Pmm.[Product_Line_Mode] Rms_Mode_Id,
            Pml.[Lab_Request] Lab_Type,
            Pmc.[Bandwidth] Bandwidth,
            Pmc.[Internet_Type] Internet_Type,
            'Remote Lab' Remote_Lab_Provider,
            Pmc.[Special_Setup] Special_Setup
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
    --     Inner Join Base.Rms_Room_Req_Additional_Fields Rr On Pmm.[Product] = Rr.[Product] And Pmm.[Product_Line_Mode] = Rr.[Mode_Id]
    Where   Pml.[Lab_Request] = 'Remote Lab';



