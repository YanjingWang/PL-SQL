


Create Or Alter View Hold.Gk_Event_Freight_V
(
   Facilityregionmetro,
   Coursecode,
   Event_Cnt,
   Freight_Total,
   Freight_Avg
)
As
     Select   Facilityregionmetro,
              Coursecode,
              Count (Evxeventid) Event_Cnt,
              Round (Sum (Pl.Unit_Price * Pl.Quantity), 2) Freight_Total,
              Round (Sum (Pl.Unit_Price * Pl.Quantity) / Count (Evxeventid), 2)
                 Freight_Avg
       From               Gilmore.Freight_Order@Gkprod F
                       Inner Join
                          Event@Gkprod E
                       On F.De_Sess = E.Evxeventid
                    Inner Join
                       Gilmore.Freight_Po@Gkprod Fp
                    On F.Fr_Order_Num = Fp.Fr_Order_Num
                 Inner Join
                    Po_Headers_All@R12prd Ph
                 On Fp.Po_Num = Ph.Segment1
              Inner Join
                 Po_Lines_All@R12prd Pl
              On Ph.Po_Header_Id = Pl.Po_Header_Id
      Where   E.Startdate >= Cast(Getutcdate() As Date) - 365
   Group By   Facilityregionmetro, Coursecode;



