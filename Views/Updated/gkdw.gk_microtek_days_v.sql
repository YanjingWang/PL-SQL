


Create Or Alter View Hold.Gk_Microtek_Days_V
(
   Microtek_Days
)
As
   Select   Isnull(Sum (Ed.End_Date - Ed.Start_Date + 1), 1) Microtek_Days
     From                  Gkdw.Event_Dim Ed
                        Inner Join
                           Gkdw.Course_Dim Cd
                        On Ed.Course_Id = Cd.Course_Id
                           And Ed.Ops_Country = Cd.Country
                     Inner Join
                        Rmsdw.Rms_Event Re
                     On Ed.Event_Id = Re.Slx_Event_Id
                  Inner Join
                     Gkdw.Gk_Microtek_Location Ml
                  On Ed.Location_Id = Ml.Location_Id
               Inner Join
                  Gkdw.Time_Dim Td
               On Ed.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Time_Dim Td2
            On Td2.Dim_Date = Cast(Getutcdate() As Date) + 7
    Where       Status In ('Open', 'Verified')
            And Td.Dim_Year = Td2.Dim_Year
            And Ed.End_Date <= Cast(Getutcdate() As Date);



