--Codes for Audit table in PL/SQL:

--a. Create The Trigger Procedure

Create or replace procedure log_customer_audit ( 
p_event_type VARCHAR2, 
p_record_id NUMBER, 
p_old_values CLOB, 
p_new_values CLOB, 
p_changed_by VARCHAR2, 
p_changed_at TIMESTAMP, 
p_customer_id NUMBER, 
p_address_id NUMBER ) as
 
 Begin
    Insert into Audit ( audit_id, event_type, table_name, record_id, old_values, new_values, changed_by, changed_at, customer_id, address_id )
    Values ( 
Audit_seq.NEXTVAL, 
p_event_type,
'Customers', 
p_record_id,
p_old_values,
p_new_values, 
p_changed_by,
p_changed_at,
p_customer_id,
p_address_id );
 
 End;

-- b. Create the trigger on the customers table:

Create or replace trigger audit_customer_log
After insert or update or delete on customers
for each row
Begin 
     IF inserting then
          log_customer_audit(
‘Insert’, :new.Customer_id, Null, to_clob( ‘first_name:’ || :new.first_name || ‘, last_name:’ ||  :new.last_name || ‘, phone:’ ||  :new.phone || ‘, email:’ ||  :new.email || ‘, date_of_birth:’ ||  to_char(:new.date_of_birth, ‘yyyy-mm-dd’) || ‘, address_id:’ || :new:address_id), 
User, Systimestamp,  :new.customer_id, :new:address_id) ;

    ELSIF updating then
          log_customer_audit(
‘Update’, :old.Customer_id, 
to_clob( ‘first_name:’ || :old.first_name || ‘, last_name:’ ||  :old.last_name || ‘, phone:’ ||  :old.phone || ‘, email:’ ||  :old.email || ‘, date_of_birth:’ ||  to_char(:old.date_of_birth, ‘yyyy-mm-dd’) || ‘, address_id:’ || :old:address_id),
 to_clob( ‘first_name:’ || :new.first_name || ‘, last_name:’ ||  :new.last_name || ‘, phone:’ ||  :new.phone || ‘, email:’ ||  :new.email || ‘, date_of_birth:’ ||  to_char(:new.date_of_birth, ‘yyyy-mm-dd’) || ‘, address_id:’ || :new:address_id), 
User, Systimestamp,  :new.customer_id) ;

   ELSIF deleting them
          log_customer_audit(
‘Update’, :old.Customer_id, 
to_clob( ‘first_name:’ || :old.first_name || ‘, last_name:’ ||  :old.last_name || ‘, phone:’ ||  :old.phone || ‘, email:’ ||  :old.email || ‘, date_of_birth:’ ||  to_char(:old.date_of_birth, ‘yyyy-mm-dd’) || ‘, address_id:’ || :old:address_id),
Null, 
User, Systimestamp,  :old.customer_id);

    End if;
End;


--We can perform operations on the Customers table and check the Audit table for logs:

Insert into Customers(first_name, last_name, phone, email, date_of_birth, address_id)
values( ‘sss’, ‘ssssss’, ‘123456789’, ‘sss_ssssss@gmail.com’, to_char(‘2024-01-01’, ‘yyyy-mm-dd’), 1);

Update customers
set phone=’987654321’
where customer_id=1

Delete from customers
where customer_id=1;

