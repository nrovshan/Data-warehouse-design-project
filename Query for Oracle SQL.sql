CREATE TABLE "Transaction_fact" (
  "transaction_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "amount" float,
  "customer_id" int,
  "account_id" int,
  "branch_id" int,
  "time_id" int,
  "transaction_type_id" int,
  "channel_id" int
);

CREATE TABLE "Transaction_type" (
  "transaction_type_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "transaction_type" varchar(25),
  "description" varchar(150)
);

CREATE TABLE "Channel" (
  "channel_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "channel_name" varchar9(25),
  "location_physical" varchar(50),
  "channel_desc" varchar(150)
);

CREATE TABLE "Accounts" (
  "account_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "account_type" varchar(25),
  "balance" float,
  "open_date" datetime,
  "status" varchar(15)
);

CREATE TABLE "Customers" (
  "customer_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "first_name" varchar(30),
  "last_name" varchar(50),
  "phone" varchar(50) NOT NULL,
  "email" varchar(50) NOT NULL,
  "dateofbirth" date,
  "address" varchar(50)
);

CREATE TABLE "Card_fact" (
  "cardfact_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "transaction_amount" float,
  "customer_id" int,
  "account_id" int,
  "branch_id" int,
  "time_id" int,
  "card_id" int
);

CREATE TABLE "Card_dim" (
  "card_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "card_type" varchar(25),
  "card_number" varchar(50) NOT NULL,
  "expiration_date" varchar(10) NOT NULL,
  "cvv" int NOT NULL,
  "customer_id" int,
  "account_id" int
);

CREATE TABLE "Loan_fact" (
  "loan_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "loan_amount" float,
  "interest_rate" decimal,
  "customer_id" int,
  "account_id" int,
  "branch_id" int,
  "time_id" int,
  "loantype_id" int
);

CREATE TABLE "Loan_type" (
  "loantype_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "loan_type" varchar(15),
  "loan_desc" varchar(150)
);

CREATE TABLE "Payment_fact" (
  "payment_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "payment_amount" float,
  "customer_id" int,
  "account_id" int,
  "branch_id" int,
  "time_id" int,
  "payment_method_id" int,
  "currency_id" int
);

CREATE TABLE "Payment_method" (
  "payment_method_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "method_name" varchar(25),
  "processing_fees" float,
  "provider" varchar(15)
);

CREATE TABLE "Payment_currency" (
  "currency_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "currency_code" varchar(15),
  "exchange_rate" float,
  "symbol" varchar(5)
);

CREATE TABLE "Branches" (
  "branch_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "branc_name" varchar(50),
  "address" varchar(50),
  "phone" varchar(50),
  "manager_id" int
);

CREATE TABLE "Employees" (
  "employee_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "name" varchar(50),
  "address" varchar(100),
  "phone" varchar(50) NOT NULL,
  "email" varchar(50) NOT NULL,
  "salary" int,
  "position" varchar(50),
  "hire_date" date,
  "branch_id" int
);

CREATE TABLE "Audit" (
  "audit_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "event_type" varchar(10) NOT NULL,
  "table_name" varchar(50) NOT NULL,
  "record_id" int NOT NULL,
  "old_values" jsonb,
  "new_values" jsonb,
  "changed_by" varchar(50) NOT NULL,
  "changed_at" timestamp DEFAULT current_timestamp,
  "customer_id" int
);

CREATE TABLE "Time" (
  "time_id" int GENERATED AS IDENTITY PRIMARY KEY,
  "Date" date,
  "Month" int,
  "Year" int
);

CREATE TABLE "AccountCard_Bridge" (
  "cardfact_id" int,
  "account_id" int
);

CREATE TABLE "EmployeesBranches_Bridge" (
  "employee_id" int,
  "branch_id" int
);

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("time_id") REFERENCES "Time" ("time_id");

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("transaction_type_id") REFERENCES "Transaction_type" ("transaction_type_id");

ALTER TABLE "Transaction_fact" ADD FOREIGN KEY ("channel_id") REFERENCES "Channel" ("channel_id");

ALTER TABLE "Card_fact" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "Card_fact" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "Card_fact" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");

ALTER TABLE "Card_fact" ADD FOREIGN KEY ("time_id") REFERENCES "Time" ("time_id");

ALTER TABLE "Card_fact" ADD FOREIGN KEY ("card_id") REFERENCES "Card_dim" ("card_id");

ALTER TABLE "Card_dim" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "Card_dim" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "Loan_fact" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "Loan_fact" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "Loan_fact" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");

ALTER TABLE "Loan_fact" ADD FOREIGN KEY ("time_id") REFERENCES "Time" ("time_id");

ALTER TABLE "Loan_fact" ADD FOREIGN KEY ("loantype_id") REFERENCES "Loan_type" ("loantype_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("time_id") REFERENCES "Time" ("time_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("payment_method_id") REFERENCES "Payment_method" ("payment_method_id");

ALTER TABLE "Payment_fact" ADD FOREIGN KEY ("currency_id") REFERENCES "Payment_currency" ("currency_id");

ALTER TABLE "Employees" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");

ALTER TABLE "Audit" ADD FOREIGN KEY ("customer_id") REFERENCES "Customers" ("customer_id");

ALTER TABLE "AccountCard_Bridge" ADD FOREIGN KEY ("cardfact_id") REFERENCES "Card_fact" ("cardfact_id");

ALTER TABLE "AccountCard_Bridge" ADD FOREIGN KEY ("account_id") REFERENCES "Accounts" ("account_id");

ALTER TABLE "EmployeesBranches_Bridge" ADD FOREIGN KEY ("employee_id") REFERENCES "Employees" ("employee_id");

ALTER TABLE "EmployeesBranches_Bridge" ADD FOREIGN KEY ("branch_id") REFERENCES "Branches" ("branch_id");
