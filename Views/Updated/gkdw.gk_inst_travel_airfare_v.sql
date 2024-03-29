


Create Or Alter View Hold.Gk_Inst_Travel_Airfare_V
(
   Facility_Region_Metro,
   Fac_Zip_3,
   Inst_Zip_3,
   Total_Airfare,
   Total_Flights,
   Avg_Airfare
)
As
     Select   Ed.Facility_Region_Metro,
              Substring(Ed.Zipcode, 1,  3) Fac_Zip_3,
              Substring(Zipcode, 1,  3) Inst_Zip_3,
              Sum (Air_Cost) Total_Airfare,
              Count ( * ) Total_Flights,
              Round (Sum (Air_Cost) / Count ( * )) Avg_Airfare
       From            Gk_Inst_Airfare_V@Gkprod A
                    Inner Join
                       Gkdw.Event_Dim Ed
                    On A.Evxeventid = Ed.Event_Id
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Cust_Dim C
              On A.Instructor_Id = C.Cust_Id
      Where       Cd.Ch_Num In ('10')
              And Cd.Md_Num In ('10', '20')
              And Air_Cost > 99
              And Ed.Start_Date > Getutcdate() - 547
   Group By   Ed.Facility_Region_Metro,
              Substring(Ed.Zipcode, 1,  3),
              Substring(Zipcode, 1,  3);



