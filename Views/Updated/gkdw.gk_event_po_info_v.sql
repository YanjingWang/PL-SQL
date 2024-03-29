


Create Or Alter View Hold.Gk_Event_Po_Info_V
(
   [Product Line],
   [Fiscal Year],
   [Fiscal Month],
   [Fiscal Week],
   Event_Id,
   Course_Code,
   Short_Name,
   Course_Type,
   Start_Date,
   End_Date,
   [Meeting Days],
   Managed_Program_Id,
   Contactid1,
   [Instructor Name],
   [Instructor Company],
   [Channel],
   [Modality],
   [Connected C],
   [V Connected To C],
   [# Attendees],
   [Po #],
   [Vendor Name],
   [Po Line #],
   [Po Line Category],
   [Po Line Description],
   [Po Line Quantity],
   [Po Line Unit Price],
   [Po Line Amount]
)
As
   Select   Cd.Course_Pl [Product Line],
            Td.Dim_Year [Fiscal Year],
            Td.Dim_Month [Fiscal Month],
            Td.Dim_Week [Fiscal Week],
            Ed.Event_Id,
            Ed.Course_Code,
            Cd.Short_Name,
            Cd.Course_Type,
            Ed.Start_Date,
            Ed.End_Date,
            Ed.Meeting_Days [Meeting Days],
            Ed.Managed_Program_Id,
            Gae.Contactid1,
            Gae.Firstname1 + ' ' + Gae.Lastname1 [Instructor Name],
            Iev.Account [Instructor Company],
            Cd.Course_Ch [Channel],
            Cd.Course_Mod [Modality],
            Case When Ed.Connected_C Is Null Then 'N' Else 'Y' End
               [Connected C],
            Case When Ed.Connected_V_To_C Is Null Then 'N' Else 'Y' End
               [V Connected To C],
            Ed.Attend_Enrollments [# Attendees],
            Poh.Segment1 [Po #],
            Pv.Vendor_Name [Vendor Name],
            Pol.Line_Num [Po Line #],
            Mc.Segment1 [Po Line Category],
            Pol.Item_Description [Po Line Description],
            Pol.Quantity [Po Line Quantity],
            Pol.Unit_Price [Po Line Unit Price],
            Pol.Quantity * Pol.Unit_Price [Po Line Amount]
     From                              Gkdw.Event_Dim Ed
                                    Left Join
                                       Gkdw.Course_Dim Cd
                                    On Ed.Course_Id = Cd.Course_Id
                                       And Ed.Country = Cd.Country
                                 Left Join
                                    Gkdw.Gk_All_Event_Instr_V Gae
                                 On Ed.Event_Id = Gae.Event_Id
                              Inner Join
                                 Gkdw.Instructor_Event_V Iev
                              On Gae.Contactid1 = Iev.Contactid
                                 And Ed.Event_Id = Iev.Evxeventid
                           Left Join
                              Gkdw.Time_Dim Td
                           On Ed.Start_Date = Td.Dim_Date
                        Left Join
                           Po_Distributions_All@R12prd Pod
                        On Ed.Event_Id = Pod.Attribute2
                     Left Join
                        Po_Lines_All@R12prd Pol
                     On Pod.Po_Line_Id = Pol.Po_Line_Id
                  Left Join
                     Mtl_Categories@R12prd Mc
                  On Pol.Category_Id = Mc.Category_Id
               Left Join
                  Po_Headers_All@R12prd Poh
               On Pod.Po_Header_Id = Poh.Po_Header_Id
            Left Join
               Po_Vendors@R12prd Pv
            On Poh.Vendor_Id = Pv.Vendor_Id
    Where   Ed.Start_Date > '31-Dec-2012'
            And Pod.Creation_Date > '31-Dec-2012';



