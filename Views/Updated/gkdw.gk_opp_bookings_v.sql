


Create Or Alter View Hold.Gk_Opp_Bookings_V (Opportunityid, Book_Amt)
As
     Select   O.Opportunityid, Sum (Book_Amt) Book_Amt
       From               Base.Opportunity O
                       Inner Join
                          Base.Qg_Oppcourses Qo
                       On O.Opportunityid = Qo.Opportunityid
                    Inner Join
                       Base.Gk_Sales_Opportunity So
                    On Qo.Gk_Sales_Opportunityid = So.Gk_Sales_Opportunityid
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On So.Gk_Sales_Opportunityid = Ed.Opportunity_Id
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
   Group By   O.Opportunityid
   Union
     Select   O.Opportunityid, Sum (Book_Amt) Book_Amt
       From         Base.Opportunity O
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On O.Opportunityid = Ed.Opportunity_Id
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
   Group By   O.Opportunityid;



