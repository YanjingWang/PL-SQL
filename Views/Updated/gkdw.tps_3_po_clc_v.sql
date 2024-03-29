


Create Or Alter View Hold.Tps_3_Po_Clc_V
(
   Osr_Purch_Ordid,
   Createuser,
   Sales_Rep_Email,
   Manager_Name,
   Manager_Email,
   Createdate,
   Modifyuser,
   Modifydate,
   Ponumber,
   Amount,
   Status,
   Inactivedate,
   Inactiveuser,
   Amountspent,
   Associated_Osr,
   Accountid,
   Ordertype,
   Account,
   Department,
   Firstname,
   Lastname,
   Region,
   Username,
   Division,
   Country
)
As
     Select   Po.Osr_Purch_Ordid,
              Po.Createuser,
              Case
                 When Ui.Email Is Null And Ui.Firstname Is Null
                 Then
                    Replace (Ui.Lastname, ' ', '') + '@Globalknowledge.Com'
                 When Ui.Email Is Null
                 Then
                       Replace (Ui.Firstname, ' ', '')
                    + '.'
                    + Replace (Ui.Lastname, ' ', '')
                    + '@Globalknowledge.Com'
                 Else
                    Ui.Email
              End
                 Sales_Rep_Email,
              Um.Username Manager_Name,
              Case
                 When Um.Email Is Null And Um.Firstname Is Null
                 Then
                    Replace (Um.Lastname, ' ', '') + '@Globalknowledge.Com'
                 When Um.Email Is Null
                 Then
                       Replace (Um.Firstname, ' ', '')
                    + '.'
                    + Replace (Um.Lastname, ' ', '')
                    + '@Globalknowledge.Com'
                 Else
                    Um.Email
              End
                 Manager_Email,
              Po.Createdate,
              Po.Modifyuser,
              Po.Modifydate,
              Po.Ponumber,
              Po.Amount,
              Po.Status,
              Po.Inactivedate,
              Po.Inactiveuser,
              Po.Amountspent,
              Po.Associated_Osr,
              Po.Accountid,
              Po.Ordertype,
              A.Account,
              Ui.Department,
              Ui.Firstname,
              Ui.Lastname,
              Ui.Region,
              Ui.Username,
              Ui.Division,
              Ad.Country
       From                  Base.Osr_Purch_Ord Po
                          Inner Join
                             Base.Account A
                          On Po.Accountid = A.Accountid
                       Inner Join
                          Base.Address Ad
                       On A.Addressid = Ad.Addressid
                    Inner Join
                       Base.Userinfo Ui
                    On Po.Associated_Osr = Ui.Userid
                 Inner Join
                    Base.Usersecurity Us
                 On Ui.Userid = Us.Userid And Us.Enabled = 'T'
              Left Outer Join
                 Base.Userinfo Um
              On Us.Managerid = Um.Userid
      Where   Ui.Region = 'Tam' And Po.Createdate >= '01-Jan-2014'
   ;



