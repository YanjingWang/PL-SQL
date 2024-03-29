


Create Or Alter View Hold.Gk_Inst_Course_Rate_V
(
   Evxcourseid,
   Rate_Plan,
   Instructor_Id,
   Rate,
   Start_Date,
   End_Date
)
As
   Select   Ic.Evxcourseid,
            Rp.Rate_Plan,
            Ir.Instructor_Id,
            Rate,
            Start_Date,
            Isnull(End_Date, Cast(Getutcdate() As Date) + 365) End_Date
     From            Inst_Course_Rate@Gkprod Ic
                  Inner Join
                     Inst_Rate_Plan@Gkprod Rp
                  On Ic.Rate_Plan_Id = Rp.Rate_Plan_Id
               Inner Join
                  Inst_Rate_Plan_Line@Gkprod Rpl
               On Rp.Rate_Plan_Id = Rpl.Rate_Plan_Id
            Inner Join
               Inst_Instructor_Rate@Gkprod Ir
            On Rp.Rate_Plan_Id = Ir.Rate_Plan_Id
    Where   Rpl.Flat_Rate = 'Y' And Ir.Rate > 0
   Union
   Select   Ic.Evxcourseid,
            Rp.Rate_Plan,
            Ir.Instructor_Id,
            Rate,
            Start_Date,
            Isnull(End_Date, Cast(Getutcdate() As Date) + 365) End_Date
     From            Inst_Course_Rate@Gkprod Ic
                  Inner Join
                     Inst_Rate_Plan@Gkprod Rp
                  On Ic.Rate_Plan_Id = Rp.Rate_Plan_Id
               Inner Join
                  Inst_Rate_Plan_Line@Gkprod Rpl
               On Rp.Rate_Plan_Id = Rpl.Rate_Plan_Id
            Inner Join
               Inst_Instructor_Rate@Gkprod Ir
            On Rp.Rate_Plan_Id = Ir.Rate_Plan_Id
    Where   Rpl.Flat_Rate = 'N' And Rpl.Pct_Rate = 100 And Ir.Rate > 0;



