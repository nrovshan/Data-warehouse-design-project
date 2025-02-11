# Data-warehouse-design-project

In this project, I applied the concepts of data modeling to design a comprehensive data warehouse schema for the banking sector. After improving my skills in this area, I realized the importance of defining measures, grains, and dimensions as a foundation for effective design. Here’s how I approached the solution:


## Defining Measures and Grains:

I identified four key measures—Loans, Cards, Transactions, and Payments. Initially, I considered combining all of these into a single fact table under the "Transactions" umbrella, which would also include deposit, transfer, and withdrawal transaction types. However, each transaction type has unique measures, which would result in sparsely populated columns (many null values). For instance, card transactions would have nulls in loan-related fields, making the design inefficient.


Fact Table Design:

To avoid sparsity and maintain clarity, I opted to create separate fact tables for each major transactional process:
Loan_Fact: One row per loan, capturing loan-specific measures like loan amount, interest rate, and start/end dates.
Payment_Fact: One row per payment, detailing payment type, amount, and associated accounts.
Card_Fact: One row per card transaction, capturing card-specific attributes like card type, expiration date, and transaction amounts.
Transaction_Fact: Capturing financial movements through deposits, transfers, and withdrawals, with their respective measures.


Dimension Tables:

For each of the fact tables, I created related dimension tables to handle the descriptive data:
Customer Dimension: Storing customer details such as name, contact information, and address.
Account Dimension: Capturing account details like account type, balance, and status.
Branch Dimension: Storing information on bank branches, including location and manager details.
Time Dimension: Enabling time-based analysis with attributes for day, month, quarter, and year.
By defining the grain for each fact table (e.g., one row per loan, one row per payment), I ensured clarity in the design. This design adheres to the principles of a galaxy schema, allowing for comprehensive reporting and analytics while maintaining efficiency and flexibility.



## Explanation of tables:

* Transaction_fact: Stores detailed information about customer transactions; columns track transaction specifics like amount, type, and references to related customers, accounts, branches, and time.

* Loan_fact: This table records loan-specific information such as loan_type, loan_amount, interest_rate, and the loan's start_date and end_date. It links to customers and accounts through foreign keys and is part of tracking loan activities over time.

Payment_fact: Holds records of payments made, storing data like payment_type, payment_amount, and links to customer_id, account_id, and branch_id. Payments could be for loans or other services.

Card_fact: Stores transactional data related to credit or debit card usage. It references the Card_dim table (which stores the card details) and links transactions to specific customers and accounts.

Card_dim: This dimension table holds details about the credit or debit cards, including card_type, card_number, expiration_date, and cvv. It links to customers and accounts, and is used in the Card_fact table to store transaction-related card information.

Customers: This table stores all customer-related data, including personal information like name, phone number, email, and date of birth. It connects to other tables like Accounts, Loan_fact, Card_fact, and more via customer_id, which is used to track all the customer's related activities in the banking system.

Accounts: Stores information about bank accounts such as account_type (e.g., checking, savings), balance, open_date, and account status. Each account links to customers via account_id and is involved in other transactions like loans and card payments.

AccountCard_Bridge: A bridge table that links Accounts and Card_fact, establishing many-to-many relationships between accounts and cards. Links accounts to cards, capturing relationships between a customer’s accounts and their cards.

EmployeesBranches_Bridge: Another bridge table that links branches to employees, facilitating many-to-many relationships between employees and their branches. 

Time: Stores time-related data, with individual columns for date, month, and year, used for tracking when events occur.

Employees: Stores employee details such as name, phone, email, salary, and branch_id (linking each employee to the branch they work at). Employees may also have roles in overseeing transactions, loans, or managing customer relationships.

Branches: The Branches table is meant to store information about the bank branches. It likely contains details such as: branch location, contact information and manager information.
The purpose of this table is to identify where customer accounts are being managed, to track transactions at specific branches, and to organize branch-level operations.

Audit: Used for tracking changes made to other tables. It records events like event_type (e.g., insert, update), the table_name being changed, record_id, old_values, new_values, changed_by, and the timestamp of the change. This helps ensure accountability and track data integrity over time.

Transaction_type: This table stores details about different transaction types to classify and analyze transactions effectively. Type of transaction (e.g., deposit, withdrawal, transfer) and detailed description of the transaction type.

Channel: This table captures information on the channels through which transactions are made, useful for channel-specific analysis. Name of the transaction channel (e.g., online, ATM, branch), location for in-person transactions (for physical channels) and description or further details of the transaction channel.
Loan_type: This dimension provides classification for different loan types, aiding in loan-specific analysis.

Payment_method: This table helps track the different methods used for payments, useful for analyzing payment trends and associated fees. Name of the payment method (e.g., credit card, bank transfer), fees associated with using the payment method and payment provider, if applicable (e.g., Visa, PayPal).

Payment_currency: For systems handling multiple currencies, this dimension allows tracking of currency types and exchange rates. ISO code for the currency (e.g., USD, EUR), exchange rate relative to a base currency and currency symbol (e.g., $, €).



## Cardinalities between the tables:

Let’s list the cardinalities between key tables:

Customers → Accounts:

Cardinality: One-to-Many (One customer can have multiple accounts, but an account must belong to one customer).
Relationship: Mandatory on the account side, because every account must belong to a customer.

Accounts → Transactions:

Cardinality: One-to-Many (One account can have multiple transactions, but each transaction belongs to a single account).
Relationship: Optional on the transaction side, as an account can exist without any transactions yet.

Accounts → Loans:

Cardinality: One-to-Many (One account can have multiple loans, but each loan must be associated with one account).
Relationship: Optional on the loan side, because not every account has a loan.

Branches → Accounts:

Cardinality: One-to-Many (A branch can manage many accounts, but each account is managed by a specific branch).
Relationship: Mandatory on the branch side since every account must be managed by a branch.

Customers → Cards:

Cardinality: One-to-Many (One customer can have multiple cards, but each card belongs to one customer).
Relationship: Mandatory on the card side because every card must be linked to a customer.

Time → Transaction_fact, Loan_fact, Card_fact, Payment_fact:

Cardinality: One-to-Many (A single date in the Time table can have many transactions, payments, loans, or card activities).
Relationship: Mandatory on the fact table side, as every event needs a timestamp.



## Differences between the first design and the last one:

1. Missing fact table and unclear granularity
The first design includes several transaction-related entities, but doesn’t explicitly represent a fact table. The transaction table could potentially be a fact table but would need clearer granularity and alignment with dimension tables.
In the first case, the grain could be at the transaction level. The granularity isn’t clear in this design. For example, Loan, payment and card tables are related to customers and transactions, but their relationship to the main transactional flow isn’t granular enough. 

2. Created 2 new tables for the M-N relationship
Account-Card (M-N) (Edge Case):
In most cases, a Card is linked to one Account, and an Account can have multiple Cards (1-M relationship). However, this design allows one Card to be linked to multiple Accounts (e.g., business accounts), this could be an M-N relationship.
Employee-Branch (M-N):
This design allows employees to work across multiple branches, there could be an M-N relationship between Employees and Branches.
Solution: For each potential M-N relationship, I introduced bridge tables to handle the many-to-many mapping effectively. 

3. To eliminate Deposit, Transfer and Withdrawal tables (prevent over-normalization)
In designing the OLAP model with denormalized fact tables and dimension tables, I decided to eliminate the Deposit, Withdrawal, and Transfer tables to avoid over-normalization, ensuring a more streamlined fact and dimension structure aligned with the galaxy schema.

4. An Audit (log_customer_audit) table for the Customers table is to track and log changes.
The primary goal of the Audit table for the Customers table is to provide a detailed record of all modifications to customer data. 
The audit table logs every change (insert, update, delete) made to customer records. This ensures that there is a trail of who made the changes, what the changes were, and when they were made.
The audit table stores both the old and new values for changes made in updates, allowing to keep a history of how customer data has evolved over time.
Note: Codes are in the log_customer.sql file

5. To add time dimension table

The Time Dimension allows to manage and analyze date-related data across different fact tables (e.g., for transactions, loans, payments, cards) without duplicating date fields in each table. It provides consistency and simplifies querying.
By having a Time Dimension, we can easily break down data into different granularities—like day, month, quarter, and year. This is useful for reporting and analysis, such as tracking trends over time or performing period comparisons.


6. Adding new dimension tables to fact tables:

These new tables are dimension tables—designed to provide descriptive context for the fact data.
Each new dimension table is created to capture attributes specific to its related fact table, such as transaction types, loan terms, and card types. These details would otherwise need to be duplicated in each row of the fact table, leading to redundancy. By separating them, each dimension encapsulates only unique information, which aligns with the goal of avoiding redundancy.
I created these dimension tables:

Transaction_type: This table stores details about different transaction types to classify and analyze transactions effectively. Type of transaction (e.g., deposit, withdrawal, transfer) and detailed description of the transaction type.

Channel: This table captures information on the channels through which transactions are made, useful for channel-specific analysis. Name of the transaction channel (e.g., online, ATM, branch), location for in-person transactions (for physical channels) and description or further details of the transaction channel.

Loan_type: This dimension provides classification for different loan types, aiding in loan-specific analysis.

Payment_method: This table helps track the different methods used for payments, useful for analyzing payment trends and associated fees. Name of the payment method (e.g., credit card, bank transfer), fees associated with using the payment method and payment provider, if applicable (e.g., Visa, PayPal).

Payment_currency: For systems handling multiple currencies, this dimension allows tracking of currency types and exchange rates. ISO code for the currency (e.g., USD, EUR), exchange rate relative to a base currency and currency symbol (e.g., $, €).


7. Creating Materialized View

I created a materialized view to summarize total transaction amounts by customer and account for:
Reduce computation time for frequently used aggregations 
Improve query performance by eliminating the need to join and aggregate data from multiple tables every time.
Enable quick reporting on summarized information, which is useful for customer and account-level insights.
This materialized view will automatically refresh every 24 hours.
Note: Codes are in the mat_view.sql file
