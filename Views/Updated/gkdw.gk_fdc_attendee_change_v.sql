


Create Or Alter View Hold.Gk_Fdc_Attendee_Change_V
(
   Gk_Onsitereq_Fdcid,
   Createdate,
   New_Numattendees
)
As
   Select   F1.Gk_Onsitereq_Fdcid, F1.Createdate, F1.New_Numattendees
     From   Base.Gk_Onsitereq_Fdcchange F1
    Where   F1.Numattendees_Change = 'Y'
            And F1.Createdate =
                  (Select   Max (Createdate)
                     From   Base.Gk_Onsitereq_Fdcchange F2
                    Where   F1.Gk_Onsitereq_Fdcid = F2.Gk_Onsitereq_Fdcid);



