


Create Or Alter View Hold.Gk_New_Isdb_Contacts_V
(
   Id,
   Import_Date,
   Source,
   First_Name,
   Last_Name,
   Title,
   Company,
   City,
   State,
   Zip,
   Keycode,
   Customer_Number,
   Time_Frame,
   Method,
   Findout,
   Keyword,
   Advertising,
   Int_Advertising,
   Import_Status,
   Slxid
)
As
   Select   [Id] Id,
            [Date] Import_Date,
            Format([Source]) Source,
            Format([Firstname]) First_Name,
            Format([Lastname]) Last_Name,
            Format([Title]) Title,
            Format([Company]) Company,
            Format([City]) City,
            Format([State]) State,
            Format([Zip]) Zip,
            Format([Keycode]) Keycode,
            Format([Customer_Number]) Customer_Number,
            Format([Timeframe]) Time_Frame,
            Format([Method]) Method,
            Format([Findout]) Findout,
            Format([Keyword]) Keyword,
            Format([Advertising]) Advertising,
            Format([Intadvertising]) Int_Advertising,
            Format([Importstatus]) Import_Status,
            [Slxid]
     From   Main@Mkt_Catalog Mc
    Where   [Slxid] Is Not Null And Format([Importstatus]) Like 'Imported%';



