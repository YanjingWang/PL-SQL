


Create Or Alter View Hold.Gk_Enroll_Promo_Cost_V
(
   Enroll_Id,
   Contactid,
   Leadsourceid,
   Description,
   Keycode,
   Item_Cost
)
As
     Select   Itemid Enroll_Id,
              Contactid,
              Cl.Leadsourceid,
              L.Description,
              L.Abbrevdesc Keycode,
              Max (Mfg_Price) Item_Cost
       From         Base.Qg_Contactleadsource Cl
                 Inner Join
                    Base.Leadsource L
                 On Cl.Leadsourceid = L.Leadsourceid
              Inner Join
                 Gkdw.Gk_Ipad_Promo_Keycode K
              On L.Abbrevdesc = K.Keycode
   Group By   Itemid,
              Contactid,
              Cl.Leadsourceid,
              L.Description,
              L.Abbrevdesc;



