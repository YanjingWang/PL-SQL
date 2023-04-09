DROP PROCEDURE GKDW.ORDER_FACT_ADDR_UPD_PROC_SB;

CREATE OR REPLACE PROCEDURE GKDW.order_fact_addr_upd_proc_sb as
cursor c1 is
select f.creation_date,f.last_update_date,f.enroll_id,f.acct_id,f.cust_id,upper(ac.account) acct_name,upper(ad1.address1) acct_address1,upper(ad1.address2) acct_address2,upper(ad1.city) acct_city,upper(ad1.state) acct_state,ad1.postalcode acct_zipcode,
       upper(ad1.country) acct_country,upper(ad1.county) acct_county,upper(c.firstname) cust_first_name,upper(c.lastname) cust_last_name,lower(c.email) cust_email,upper(ad2.address1) cust_address1,
       upper(ad2.address2) cust_address2,upper(ad2.city) cust_city,upper(ad2.state) cust_state,ad2.postalcode cust_zipcode,upper(ad2.country) cust_country,upper(ad2.county) cust_county
  from order_fact f
       inner join slxdw.contact c on f.cust_id = c.contactid
       inner join slxdw.address ad2 on c.addressid = ad2.addressid
       inner join slxdw.account ac on c.accountid = ac.accountid
       inner join slxdw.address ad1 on ac.addressid = ad1.addressid
 where rev_date >= trunc(sysdate-3)-1 or book_date >= trunc(sysdate-3)-1
 minus
select f.creation_date,f.last_update_date,f.enroll_id,f.acct_id,f.cust_id,f.acct_name,upper(f.acct_address1),upper(f.acct_address2),upper(f.acct_city),upper(f.acct_state),f.acct_zipcode,upper(f.acct_country),upper(f.acct_county),
       upper(f.cust_first_name),upper(f.cust_last_name),lower(f.cust_email),upper(f.cust_address1),upper(f.cust_address2),upper(f.cust_city),upper(f.cust_state),f.cust_zipcode,upper(f.cust_country),
       upper(f.cust_county)
  from order_fact f
 where rev_date >= trunc(sysdate-2)-1 or book_date >= trunc(sysdate-2)-1;

begin
for r1 in c1 loop
  update order_fact
     set acct_name = r1.acct_name,
         acct_address1 = r1.acct_address1,
         acct_address2 = r1.acct_address2,
         acct_city = r1.acct_city,
         acct_state = r1.acct_state,
         acct_zipcode = r1.acct_zipcode,
         acct_country = r1.acct_country,
         acct_county = r1.acct_county,
         cust_first_name = r1.cust_first_name,
         cust_last_name = r1.cust_last_name,
         cust_email = r1.cust_email,
         cust_address1 = r1.cust_address1,
         cust_address2 = r1.cust_address2,
         cust_city = r1.cust_city,
         cust_state = r1.cust_state,
         cust_zipcode = r1.cust_zipcode,
         cust_country = r1.cust_country,
         cust_county = r1.cust_county
   where enroll_id = r1.enroll_id;
  commit;
end loop;
commit;

end;
/


