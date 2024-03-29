


Create Or Alter View Hold.Gk_Payment_Detail_V
(
   Enroll_Id,
   Event_Id,
   Fee_Type,
   Enroll_Date,
   Book_Date,
   Start_Date,
   Enroll_Status,
   Pmt_Date,
   Book_Amt,
   Pmt_Amt,
   Bal_Due
)
As
   Select   F.Enroll_Id,
            E.Event_Id,
            F.Fee_Type,
            F.Enroll_Date,
            F.Book_Date,
            E.Start_Date,
            F.Enroll_Status,
            P.Createdate Pmt_Date,
            Round (Book_Amt, 2) Book_Amt,
            Isnull(P.Appliedamount, 0) Pmt_Amt,
            Round (F.Book_Amt, 2) - Isnull(P.Appliedamount, 0) Bal_Due
     From            Gkdw.Order_Fact F
                  Inner Join
                     Gkdw.Event_Dim E
                  On F.Event_Id = E.Event_Id
               Inner Join
                  Base.Evxev_Txfee T
               On F.Txfee_Id = T.Evxev_Txfeeid
            Left Outer Join
               Base.Evxpmtapplied P
            On T.Evxbillingid = P.Evxbillingid
    Where   Enroll_Status != 'Cancelled'
            And E.Event_Channel = 'Individual/Public';



