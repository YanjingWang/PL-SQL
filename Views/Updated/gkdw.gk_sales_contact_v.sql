


Create Or Alter View Hold.Gk_Sales_Contact_V
(
   Cust_Id,
   Cust_Name,
   Acct_Id,
   Acct_Name,
   Min_Enroll_Date,
   Enroll_Cnt,
   Contact_Act_Cnt,
   Account_Act_Cnt
)
As
     Select   Q3.Cust_Id,
              Q3.Cust_Name,
              Q3.Acct_Id,
              Q3.Acct_Name,
              Q3.Min_Enroll_Date,
              Q3.Enroll_Cnt,
              Q3.Contact_Act_Cnt,
              Sum (Isnull(Q4.Account_Act_Cnt, 0)) Account_Act_Cnt
       From      (  Select   Q1.Cust_Id,
                             Q1.Cust_Name,
                             Q1.Acct_Id,
                             Q1.Acct_Name,
                             Q1.Min_Enroll_Date,
                             Q1.Enroll_Cnt,
                             Sum (Isnull(Q2.Contact_Act_Cnt, 0)) Contact_Act_Cnt
                      From      (  Select   F.Cust_Id,
                                            Cd.Cust_Name,
                                            Cd.Acct_Id,
                                            Cd.Acct_Name,
                                            Min (Enroll_Date) Min_Enroll_Date,
                                            Count (Distinct F.Enroll_Id) Enroll_Cnt
                                     From      Gkdw.Order_Fact F
                                            Inner Join
                                               Gkdw.Cust_Dim Cd
                                            On F.Cust_Id = Cd.Cust_Id
                                    Where   F.Cust_Id In
                                                  ('C6uj9a03m7cp',
                                                   'C6uj9a03jyzx',
                                                   'C6uj9a03eax1',
                                                   'C6uj9a03e02j',
                                                   'C6uj9a03berq',
                                                   'C6uj9a03d9uw',
                                                   'C6uj9a03c4r4',
                                                   'C6uj9a03e9xa',
                                                   'C6uj9a02s8d1')
                                 Group By   F.Cust_Id,
                                            Cd.Cust_Name,
                                            Cd.Acct_Id,
                                            Cd.Acct_Name) Q1
                             Left Outer Join
                                (  Select   H.Contactid,
                                            Trunc (H.Createdate) Act_Date,
                                            Count (Distinct H.Activityid)
                                               Contact_Act_Cnt
                                     From   Base.History H
                                    Where   Contactid In
                                                  ('C6uj9a03m7cp',
                                                   'C6uj9a03jyzx',
                                                   'C6uj9a03eax1',
                                                   'C6uj9a03e02j',
                                                   'C6uj9a03berq',
                                                   'C6uj9a03d9uw',
                                                   'C6uj9a03c4r4',
                                                   'C6uj9a03e9xa',
                                                   'C6uj9a02s8d1')
                                 Group By   H.Contactid, Trunc (H.Createdate)) Q2
                             On Q1.Cust_Id = Q2.Contactid
                                And Q1.Min_Enroll_Date >= Q2.Act_Date
                  Group By   Q1.Cust_Id,
                             Q1.Cust_Name,
                             Q1.Acct_Id,
                             Q1.Acct_Name,
                             Q1.Min_Enroll_Date,
                             Q1.Enroll_Cnt) Q3
              Left Outer Join
                 (  Select   H.Accountid,
                             Trunc (H.Createdate) Act_Date,
                             Count (Distinct H.Activityid) Account_Act_Cnt
                      From      Gkdw.Cust_Dim Cd
                             Inner Join
                                Base.History H
                             On Cd.Acct_Id = H.Accountid
                     Where   Cd.Cust_Id In
                                   ('C6uj9a03m7cp',
                                    'C6uj9a03jyzx',
                                    'C6uj9a03eax1',
                                    'C6uj9a03e02j',
                                    'C6uj9a03berq',
                                    'C6uj9a03d9uw',
                                    'C6uj9a03c4r4',
                                    'C6uj9a03e9xa',
                                    'C6uj9a02s8d1')
                  Group By   H.Accountid, Trunc (H.Createdate)) Q4
              On Q3.Acct_Id = Q4.Accountid
                 And Q3.Min_Enroll_Date >= Q4.Act_Date
   Group By   Q3.Cust_Id,
              Q3.Cust_Name,
              Q3.Acct_Id,
              Q3.Acct_Name,
              Q3.Min_Enroll_Date,
              Q3.Enroll_Cnt,
              Q3.Contact_Act_Cnt;



