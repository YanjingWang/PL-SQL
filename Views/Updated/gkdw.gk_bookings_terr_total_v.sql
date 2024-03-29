


Create Or Alter View Hold.Gk_Bookings_Terr_Total_V
(
   Terr_Id,
   Total_Bookings_2009,
   Total_Bookings_2008,
   Total_Bookings_2007
)
As
     Select   Terr_Id,
              Sum (Case When Book_Year = 2009 Then Total_Bookings Else 0 End)
                 Total_Bookings_2009,
              Sum (Case When Book_Year = 2008 Then Total_Bookings Else 0 End)
                 Total_Bookings_2008,
              Sum (Case When Book_Year = 2007 Then Total_Bookings Else 0 End)
                 Total_Bookings_2007
       From   Gkdw.Gk_Bookings_Terr_Year_Mv
   Group By   Terr_Id;



