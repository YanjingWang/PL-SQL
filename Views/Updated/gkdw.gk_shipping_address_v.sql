


Create Or Alter View Hold.Gk_Shipping_Address_V
(
   Entityid,
   Addressid,
   Max_Modifydate,
   Address_Rank
)
As
   Select   Entityid,
            Addressid,
            Max_Modifydate,
            Address_Rank
     From   (  Select   Upper (Entityid) Entityid,
                        Addressid,
                        Max (Modifydate) Max_Modifydate,
                        Rank ()
                           Over (
                              Partition By Upper (Entityid)
                              Order By Max (Modifydate) Desc, Max (Addressid)
                           )
                           Address_Rank
                 From   Base.Address
                Where   Ismailing = 'T'
             Group By   Upper (Entityid), Addressid
             ) a1
    Where   Address_Rank = 1;



