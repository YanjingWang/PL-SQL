


Create Or Alter View Hold.Gk_Po_Vendors_V
(
   Vendor_Id,
   Vendor_Number,
   Vendor_Name,
   Country,
   Vendor_Site_Code,
   Invoice_Currency_Code,
   Payment_Currency_Code,
   Payment_Method
)
As
   Select   P.Vendor_Id,
            P.Segment1 Vendor_Number,
            Vendor_Name,
            Ps.Country,
            Ps.Vendor_Site_Code,
            Ps.Invoice_Currency_Code,
            Ps.Payment_Currency_Code,
            Ps.Payment_Method_Lookup_Code
     From      Po_Vendors@R12prd P
            Inner Join
               Po_Vendor_Sites_All@R12prd Ps
            On P.Vendor_Id = Ps.Vendor_Id
    Where   P.Enabled_Flag = 'Y'
            And (Ps.Inactive_Date Is Null
                 Or Ps.Inactive_Date >= Cast(Getutcdate() As Date));





