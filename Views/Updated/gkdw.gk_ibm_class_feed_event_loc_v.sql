


Create Or Alter View Hold.Gk_Ibm_Class_Feed_Event_Loc_V
(
   [Providermonthlyclassfeed],
   [6],
   Year4digit,
   Month2digit,
   [Countryiso2enrollment],
   [Coursecodeprovider],
   [Derivativework],
   Course_Mod,
   Course_Code_Mod,
   [Modality],
   [Durationhours],
   Duration_Hours,
   [Coursecodeibmpri],
   Short_Name,
   [Coursecodeibmsec],
   [Studentscustomer],
   [Studentsibm],
   [Studentsibmpartner],
   [Functionflag],
   Enroll_Id,
   Payment_Method
)
As
   Select   Distinct
            'Providermonthlyclassfeed' [Providermonthlyclassfeed],
            '6' [6],
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'W' Then Format(O.Rev_Date, 'Yyyy')
               Else Format(O.Event_Start_Date, 'Yyyy')
            End
               Year4digit,
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'W' Then Format(O.Rev_Date, 'Mm')
               Else Format(O.Event_Start_Date, 'Mm')
            End
               Month2digit,
            O.Country [Countryiso2enrollment], --,  O.Cust_Country                                             ,
            O.Course_Code [Coursecodeprovider],
            'N' [Derivativework],
            O.Course_Mod,
            Substring(O.Course_Code, Len(O.Course_Code),  1) Course_Code_Mod,
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'C' Then 'Cr'
               When 'N' Then 'Cr'
               When 'L' Then 'Ilo'
               When 'V' Then 'Ilo'
               When 'W' Then 'Dl'
               Else 'Na'
            End
               [Modality],
            (Cd.Duration_Days * 8) [Durationhours],
            Qc.Duration_Hours,
            Cd.Mfg_Course_Code [Coursecodeibmpri],
            Cd.Short_Name,                         -- Ibmc.Ibm_Ww_Course_Code,
            Null [Coursecodeibmsec],
            Case
               When (O.Payment_Method Not In
                           ('Talent At Ibm',
                            'Talent At Ibm',
                            'Ibm Partner Rewards',
                            'Ibm Storage Systems',
                            'Ibm System I Voucher')
                     Or O.Payment_Method Is Null)
               Then
                  1
               Else
                  0
            End
               [Studentscustomer],
            Case When O.Payment_Method = 'Talent At Ibm' Then 1
               Else 0
            End
               [Studentsibm],
            Case
               When O.Payment_Method In
                          ('Ibm Partner Rewards',
                           'Ibm Storage Systems',
                           'Ibm System I Voucher')
               Then
                  1
               Else
                  0
            End
               [Studentsibmpartner],
            'A' [Functionflag],
            O.Enroll_Id,
            O.Payment_Method
     From            Gkdw.Gk_All_Orders_Mv O
                  Join
                     Gkdw.Event_Dim Ed
                  On O.Event_Id = Ed.Event_Id
               Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
            Join
               Gkdw.Qg_Course Qc
            On Cd.Course_Id = Qc.Evxcourseid
    Where       O.Enroll_Status Not In ('Cancelled', 'Did Not Attend')
            And O.Course_Pl = 'Ibm'
            And O.Fee_Type <> 'Ons - Base';



