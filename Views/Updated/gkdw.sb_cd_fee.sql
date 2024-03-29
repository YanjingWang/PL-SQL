


Create Or Alter View Hold.Sb_Cd_Fee
(
   Prod_Code,
   Prod_Mod,
   Course_Id,
   Prod_Name,
   Short_Name,
   Prod_Line,
   Fee_Type,
   Fee_Status,
   Content_Type,
   Payment_Unit,
   Fee_Rate,
   Cisco_Dur_Days,
   Dw_Auth_Code,
   From_Date,
   To_Date,
   Vendor_Num,
   Vendor_Name,
   Payment_Curr,
   Vendor_Site_Code,
   Primary_Poc,
   Primary_Poc_Email,
   Product_Manager,
   Pm_Email
)
As
   Select   P.[Us_Code] Prod_Code,
            Plm.[Mode] Prod_Mod,
            Pmm.[Slx_Id] Course_Id,
            P.[Description] Prod_Name,
            P.[Product_Code] Short_Name,
            Pla.[Area] Prod_Line,
            Cf.[Fee_Type] Fee_Type,
            Cf.[Status] Fee_Status,
            Cf.[Content_Type] Content_Type,
            Cf.[Payment_Unit] Payment_Unit,
            To_Number (Cf.[Rate_Amount]) Fee_Rate,
            To_Number (Cf.[Cisco_Dur_Days]) Cisco_Dur_Days,
            Cf.[Dw_Auth_Code] Dw_Auth_Code,
            Cf.[From_Date] From_Date,
            Cf.[To_Date] To_Date,
            V.[Oracle_Supplier_Num] Vendor_Num,
            V.[Vendor_Name] Vendor_Name,
            V.[Payment_Currency] Payment_Curr,
            V.[Vendor_Site_Code] Vendor_Site_Code,
            V.[Primary_Poc_Name] Primary_Poc,
            V.[Primary_Poc_Email] Primary_Poc_Email,
            Pmg.[Name] Product_Manager,
            Pmg.[Product_Manager_Email] Pm_Email
     From                        Base.Rms_Course_Fee Cf
                              Inner Join
                                 Base.Rms_Vendor_Data V
                              On Cf.[Vendor] = V.[Vendor]
                           Inner Join
                              Base.Rms_Product_Modality_Mode Pmm
                           On Cf.[Product_Modality_Mode] = Pmm.[Id]
                        Inner Join
                           Base.Rms_Product_Line_Mode Plm
                        On Pmm.[Product_Line_Mode] = Plm.[Id]
                     Inner Join
                        Base.Rms_Product P
                     On Cf.[Product] = P.[Id]
                  Left Join
                     Base.Rms_Product_Product_Line_Area Ppla
                  On P.[Id] = Ppla.[Product]
               Left Join
                  Base.Rms_Product_Line_Area Pla
               On Ppla.[Product_Line_Area] = Pla.[Id]
            Left Join
               Base.Rms_Product_Manager Pmg
            On P.[Product_Manager] = Pmg.[Id]
    Where   Cf.[Fee_Type] In
                  ('Course Director Fee',
                   'Vendor Royalty Fee',
                   'Derivative Works',
                   'Misc Fee',
                   'Courseware',
                   'Courseware Bundle',
                   'Labs',
                   'Vouchers',
                   'Reseller Fee')
            And Upper (Isnull(Cf.[Vendor_Royalty], 'Yes')) = Upper ('Yes');



