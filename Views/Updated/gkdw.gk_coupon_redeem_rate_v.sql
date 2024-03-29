


Create Or Alter View Hold.Gk_Coupon_Redeem_Rate_V
(
   Course_Id,
   Issued_Cnt,
   Redeem_Cnt,
   Redeem_Rate
)
As
     Select   Cd.Course_Id,
              Count ( * ) Issued_Cnt,
              Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
                 Redeem_Cnt,
              Round (
                 (Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
                  / Count ( * ))
                 + .1,
                 2
              )
                 Redeem_Rate
       From         Gk_Coupon@Gkprod Gc
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On Gc.Evxeventid = Ed.Event_Id
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
   Group By   Cd.Course_Id
   Union
     Select   Pd.Product_Id,
              Count ( * ) Issued_Cnt,
              Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
                 Redeem_Cnt,
              Round (
                 (Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
                  / Count ( * ))
                 + .1,
                 2
              )
                 Redeem_Rate
       From      Gk_Coupon@Gkprod Gc
              Inner Join
                 Gkdw.Product_Dim Pd
              On Gc.Evxeventid = Pd.Product_Id
   Group By   Pd.Product_Id;



