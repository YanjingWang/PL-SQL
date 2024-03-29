


Create Or Alter View Hold.Gk_Instructor_Cert_V
(
   Instructor_Rms_Id,
   Person_Rms_Id,
   Firstname,
   Lastname,
   Country,
   City,
   State,
   Slx_Contact_Id,
   Vendor_Name,
   Certificate_Num,
   Cert_Product
)
As
     Select   F.[Id] Instructor_Rms_Id,
              P.[Id] Person_Rms_Id,
              P.[Firstname] Firstname,
              P.[Lastname] Lastname,
              A.[Country] Country,
              A.[City] City,
              S.[Abbr] State,
              F.[Slx_Contact_Id] Slx_Contact_Id,
              V.[Name] Vendor_Name,
              Iv.[Certificate_Number] Certificate_Num,
              C.[Product_Code] Cert_Product
       From                        Base.Rms_Instructor_Func F
                                Inner Join
                                   Base.Rms_Person P
                                On F.[Person] = P.[Id]
                             Inner Join
                                Base.Rms_Address A
                             On P.[Address] = A.[Id]
                          Inner Join
                             Base.Rms_State S
                          On A.[State] = S.[Id]
                       Inner Join
                          Base.Rms_Instructor_Vendor Iv
                       On F.[Id] = Iv.[Instructor]
                    Inner Join
                       Base.Rms_Vendor V
                    On Iv.[Vendor] = V.[Id]
                 Inner Join
                    Base.Rms_Instructor_Certificate Ic
                 On F.[Id] = Ic.[Instructor]
              Inner Join
                 Base.Rms_Certificate C
              On Ic.[Certificate] = C.[Id] And V.[Id] = C.[Vendor]
   ;



