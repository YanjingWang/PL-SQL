


Create Or Alter View Hold.Gk_Enroll_Leadsource_V
(
   Enroll_Id,
   Txfee_Id,
   Keycode,
   Itemid,
   Abbrevdesc
)
As
   Select   Enroll_Id,
            Txfee_Id,
            Keycode,
            Cl.Itemid,
            L.Abbrevdesc
     From         Gkdw.Order_Fact F
               Join
                  Base.Qg_Contactleadsource Cl
               On Cl.Itemid = F.Enroll_Id
            Join
               Base.Leadsource L
            On Cl.Leadsourceid = L.Leadsourceid
    Where       Enroll_Date >= '01-Jan-2014'
            And F.Gkdw_Source = 'Slxdw'
            And F.Keycode <> L.Abbrevdesc;



