


Create Or Alter View Hold.Gk_Cw_Freight_V
(
   Address1,
   City,
   State,
   Total_Qty,
   Total_Freight,
   Freight_Qty
)
As
     Select   Address1,
              City,
              State,
              Sum (
                 Case When Part_Num = 'Gk201-1' Then 0 Else To_Number (Qty) End
              )
                 Total_Qty,
              Sum (Freight_Cost) Total_Freight,
              Case
                 When Sum (Case When Part_Num = 'Gk201-1' Then 0 Else Qty End) =
                         0
                 Then
                    0
                 Else
                    Sum (Freight_Cost)
                    / Sum (Case When Part_Num = 'Gk201-1' Then 0 Else Qty End)
              End
                 Freight_Qty
       From   Gkdw.Gk_Courseware_Tax_Out L
      Where   Upper (Part_Num) Not Like 'Duty%Brokerage'
              And Upper (Part_Num) Not Like 'Order%Manage%'
   Group By   Address1, City, State
--Select Address1,City,State,
--       Sum(Case When Part_Id = 'Gk201-1' Then 0 Else Qty End) Total_Qty,
--       Sum(Freight_Cost) Total_Freight,
--       Case When Sum(Case When Part_Id = 'Gk201-1' Then 0 Else Qty End)= 0 Then 0
--            Else Sum(Freight_Cost)/Sum(Case When Part_Id = 'Gk201-1' Then 0 Else Qty End)
--       End Freight_Qty
-- From Gkdw.Gk_Gilmore_Tax_Load
-- Where Upper(Part_Id) Not Like 'Duty%Brokerage'
--   And Upper(Part_Id) Not Like 'Order%Manage%'
--Group By Address1,City,State;



