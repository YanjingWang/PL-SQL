


Create Or Alter View Hold.Gk_Student_Cw_Shipping_V
(
   Facilityregionmetro,
   Coursecode,
   Total_Shipped,
   Total_Shipping,
   Avg_Shipping
)
As
     Select   E.Facilityregionmetro,
              E.Coursecode,
              Sum (Ft.Qty_Shipped) Total_Shipped,
              Sum (Ft.Ship_Cost) Total_Shipping,
              Round (Sum (Ft.Ship_Cost) / Sum (Ft.Qty_Shipped), 2) Avg_Shipping
       From         Cw_Fulfillment@Gkprod Cf
                 Inner Join
                    Cw_Fulfillment_Tracking@Gkprod Ft
                 On Cf.Gk_Ref_Num = Ft.Gk_Ref_Num
                    And Cf.Part_Number = Ft.Part_Number
              Inner Join
                 Event@Gkprod E
              On Cf.Event_Id = E.Evxeventid
      Where   Ship_Cost > 0 And Ft.Ship_Date >= Cast(Getutcdate() As Date) - 365
   Group By   E.Facilityregionmetro, E.Coursecode;



