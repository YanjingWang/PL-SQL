


Create Or Alter View Hold.Ibm_Rss_Update_Event_V
(
   Event_Id,
   Course_Code,
   Course_Name,
   Ibm_Course_Code,
   Course_Url,
   Start_Date,
   End_Date,
   City,
   Isoctry,
   State_Abbrv,
   Modality,
   Duration_Days,
   Classtype,
   Offsetfromutc,
   Start_Time,
   End_Time,
   Inst_Name,
   Inst_Email,
   External_Students,
   Ibm_Students,
   Gtr_Flag
)
As
     Select   Ed.Event_Id,
              Cd.Course_Code,
              Cd.Course_Name,
              Cd.Mfg_Course_Code Ibm_Course_Code,
              'Http://Www.Globalknowledge.Com/Training/Olm/Ibmgo.Aspx?Coursecode='
              + Tx.Coursecode
                 Course_Url,
              Ed.Start_Date,
              Ed.End_Date,
              Initcap (Case
                          When Cd.Md_Num In ('32', '44') Then Null
                          When Cd.Md_Num = '20' Then 'Virtual Eastern'
                          Else Upper (Ed.City)
                       End)
                 City,
              Upper (Substring(Ed.Country, 1,  2)) Isoctry,
              Upper (Ed.State) State_Abbrv,
              Case
                 When Cd.Md_Num In ('20', '42')
                 Then
                    'Ilo'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Spvc%'
                 Then
                    'Spvc'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Wbt%'
                 Then
                    'Wbt'
                 Else
                    'Cr'
              End
                 Modality,
              Cd.Duration_Days,
              Case When Cd.Ch_Num = '20' Then 'Private' Else 'Public' End
                 Classtype,
              Format(Et.Offsetfromutc) Offsetfromutc,
              Ed.Start_Time,
              Ed.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1 Inst_Name,
              Ie.Email1 Inst_Email,
              Sum (Case When C1.Acct_Name Not Like 'Ibm%' Then 1 Else 0 End)
                 External_Students,
              Sum (Case When C1.Acct_Name Like 'Ibm%' Then 1 Else 0 End)
                 Ibm_Students,
              Case When Gtr.Gtr_Level Is Not Null Then '1' Else '0' End
                 Gtr_Flag
       From                                    Gkdw.Event_Dim Ed
                                            Inner Join
                                               Gkdw.Ibm_Rss_Feed_Tbl Rf
                                            On Ed.Event_Id = Rf.Event_Id
                                         Left Outer Join
                                            Gkdw.Gk_State_Abbrev A
                                         On Upper (Ed.State) = A.State_Abbrv
                                      Inner Join
                                         Gkdw.Course_Dim Cd
                                      On Ed.Course_Id = Cd.Course_Id
                                         And Ed.Ops_Country = Cd.Country
                                   Inner Join
                                      Gkdw.Ibm_Tier_Xml Tx
                                   On Isnull(Cd.Mfg_Course_Code, Cd.Short_Name) =
                                         Tx.Coursecode
                                Inner Join
                                   Gkdw.Gk_Course_Url_Mv Cu
                                On Cd.Course_Code = Cu.Course_Code
                                   And Cd.Country = Cu.Country
                             Inner Join
                                Base.Evxevent Ev
                             On Ed.Event_Id = Ev.Evxeventid
                          Inner Join
                             Gkdw.Gk_All_Event_Instr_Mv Ie
                          On Ed.Event_Id = Ie.Event_Id
                       Left Outer Join
                          Base.Evxtimezone Et
                       On Ev.Evxtimezoneid = Et.Evxtimezoneid
                    Left Outer Join
                       Gkdw.Order_Fact F
                    On Ed.Event_Id = F.Event_Id
                       And F.Enroll_Status = 'Confirmed'
                 Left Outer Join
                    Gkdw.Cust_Dim C1
                 On F.Cust_Id = C1.Cust_Id
              Left Outer Join
                 Gkdw.Gk_Gtr_Events Gtr
              On Ed.Event_Id = Gtr.Event_Id
      Where       Cd.Course_Pl = 'Ibm'
              And Cd.Country In ('Usa', 'Canada')
              And Ed.End_Date >= Cast(Getutcdate() As Date)
              And Ed.Status = 'Open'
              And Cd.Ch_Num = '10'
              And Cd.Mfg_Course_Code Is Not Null
   Group By   Ed.Event_Id,
              Cd.Course_Code,
              Cd.Course_Name,
              Cd.Mfg_Course_Code,
              Ed.Start_Date,
              Ed.End_Date,
              Initcap (Case
                          When Cd.Md_Num In ('32', '44') Then Null
                          When Cd.Md_Num = '20' Then 'Virtual Eastern'
                          Else Upper (Ed.City)
                       End),
              Upper (Substring(Ed.Country, 1,  2)),
              Upper (Ed.State),
              Case
                 When Cd.Md_Num In ('20', '42')
                 Then
                    'Ilo'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Spvc%'
                 Then
                    'Spvc'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Wbt%'
                 Then
                    'Wbt'
                 Else
                    'Cr'
              End,
              Cd.Duration_Days,
              Case When Cd.Ch_Num = '20' Then 'Private' Else 'Public' End,
              Et.Offsetfromutc,
              Ed.Start_Time,
              Ed.End_Time,
              Ie.Firstname1,
              Ie.Lastname1,
              Ie.Email1,
              Tx.Coursecode,
              Gtr.Gtr_Level
   Union
     Select   Replace (Ed.Event_Id, 'Q6', 'Ca') Event_Id,
              Cd.Course_Code,
              Cd.Course_Name,
              Cd.Mfg_Course_Code Ibm_Course_Code,
              'Http://Www.Globalknowledge.Com/Training/Olm/Ibmgo.Aspx?Coursecode='
              + Tx.Coursecode
                 Course_Url,
              Ed.Start_Date,
              Ed.End_Date,
              Initcap (Case
                          When Cd.Md_Num In ('32', '44') Then Null
                          When Cd.Md_Num = '20' Then 'Virtual Eastern'
                          Else Upper (Ed.City)
                       End)
                 City,
              'Ca' Isoctry,
              Null State_Abbrv,
              Case
                 When Cd.Md_Num In ('20', '42')
                 Then
                    'Ilo'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Spvc%'
                 Then
                    'Spvc'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Wbt%'
                 Then
                    'Wbt'
                 Else
                    'Cr'
              End
                 Modality,
              Cd.Duration_Days,
              Case When Cd.Ch_Num = '20' Then 'Private' Else 'Public' End
                 Classtype,
              Format(Et.Offsetfromutc) Offsetfromutc,
              Ed.Start_Time,
              Ed.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1 Inst_Name,
              Ie.Email1 Inst_Email,
              Sum (Case When C1.Acct_Name Not Like 'Ibm%' Then 1 Else 0 End)
                 External_Students,
              Sum (Case When C1.Acct_Name Like 'Ibm%' Then 1 Else 0 End)
                 Ibm_Students,
              Case When Gtr.Gtr_Level Is Not Null Then '1' Else '0' End
                 Gtr_Flag
       From                                    Gkdw.Event_Dim Ed
                                            Inner Join
                                               Gkdw.Ibm_Rss_Feed_Tbl Rf
                                            On Replace (Ed.Event_Id,
                                                        'Q6',
                                                        'Ca') = Rf.Event_Id
                                         Left Outer Join
                                            Gkdw.Gk_State_Abbrev A
                                         On Upper (Ed.State) = A.State_Abbrv
                                      Inner Join
                                         Gkdw.Course_Dim Cd
                                      On Ed.Course_Id = Cd.Course_Id
                                         And Ed.Ops_Country = Cd.Country
                                   Inner Join
                                      Gkdw.Ibm_Tier_Xml Tx
                                   On Isnull(Cd.Mfg_Course_Code, Cd.Short_Name) =
                                         Tx.Coursecode
                                Inner Join
                                   Gkdw.Gk_Course_Url_Mv Cu
                                On Cd.Course_Code = Cu.Course_Code
                                   And Cd.Country = Cu.Country
                             Inner Join
                                Base.Evxevent Ev
                             On Ed.Event_Id = Ev.Evxeventid
                          Inner Join
                             Gkdw.Gk_All_Event_Instr_Mv Ie
                          On Ed.Event_Id = Ie.Event_Id
                       Left Outer Join
                          Base.Evxtimezone Et
                       On Ev.Evxtimezoneid = Et.Evxtimezoneid
                    Left Outer Join
                       Gkdw.Order_Fact F
                    On Ed.Event_Id = F.Event_Id
                       And F.Enroll_Status = 'Confirmed'
                 Left Outer Join
                    Gkdw.Cust_Dim C1
                 On F.Cust_Id = C1.Cust_Id
              Left Outer Join
                 Gkdw.Gk_Gtr_Events Gtr
              On Ed.Event_Id = Gtr.Event_Id
      Where       Cd.Course_Pl = 'Ibm'
              And Cd.Country = 'Usa'
              And Ed.End_Date >= Cast(Getutcdate() As Date)
              And Ed.Status = 'Open'
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '20'
              And Cd.Mfg_Course_Code Is Not Null
   Group By   Replace (Ed.Event_Id, 'Q6', 'Ca'),
              Cd.Course_Code,
              Cd.Course_Name,
              Cd.Mfg_Course_Code,
              Ed.Start_Date,
              Ed.End_Date,
              Initcap (Case
                          When Cd.Md_Num In ('32', '44') Then Null
                          When Cd.Md_Num = '20' Then 'Virtual Eastern'
                          Else Upper (Ed.City)
                       End),
              Upper (Substring(Ed.Country, 1,  2)),
              Upper (Ed.State),
              Case
                 When Cd.Md_Num In ('20', '42')
                 Then
                    'Ilo'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Spvc%'
                 Then
                    'Spvc'
                 When Cd.Md_Num In ('32', '44') And Tx.Modality Like '%Wbt%'
                 Then
                    'Wbt'
                 Else
                    'Cr'
              End,
              Cd.Duration_Days,
              Case When Cd.Ch_Num = '20' Then 'Private' Else 'Public' End,
              Et.Offsetfromutc,
              Ed.Start_Time,
              Ed.End_Time,
              Ie.Firstname1,
              Ie.Lastname1,
              Ie.Email1,
              Tx.Coursecode,
              Gtr.Gtr_Level
   Except
   Select   Event_Id,
            Course_Code,
            Course_Name,
            Ibm_Course_Code,
            Format(Course_Url),
            Start_Date,
            End_Date,
            City,
            Isoctry,
            State_Abbrv,
            Modality,
            Duration_Days,
            Classtype,
            Offsetfromutc,
            Start_Time,
            End_Time,
            Inst_Name,
            Inst_Email,
            External_Students,
            Ibm_Students,
            Gtr_Flag
     From   Gkdw.Ibm_Rss_Feed_Tbl;



