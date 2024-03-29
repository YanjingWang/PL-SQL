


Create Or Alter View Hold.Gk_Gsa_Pricelist_V
(
   Id,
   Product_Country,
   Product_Line_Mode,
   Price_Type,
   Price
)
As
   Select   Pcp1.[Id] Id,
            Pcp1.[Product_Country] Product_Country,
            Pcp1.[Product_Line_Mode] Product_Line_Mode,
            Pcp1.[Price_Type] Price_Type,
            Pcp1.[Price] Price
     From   Base.Rms_Product_Country_Price Pcp1
    Where   Pcp1.[Price_Type] = 29
            And Pcp1.[Id] In
                     (Select   Max (Pcp.[Id])
                        From   Base.Rms_Product_Country_Price Pcp
                       Where   Pcp.[Product_Country] = Pcp1.[Product_Country]
                               And Pcp.[Product_Line_Mode] =
                                     Pcp1.[Product_Line_Mode]
                               And Pcp.[Price_Type] = Pcp1.[Price_Type]);



