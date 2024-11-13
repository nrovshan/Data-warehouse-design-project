--Creating Materialized View


--I created a materialized view to summarize total transaction amounts by customer and account for:
--Reduce computation time for frequently used aggregations 
--Improve query performance by eliminating the need to join and aggregate data from multiple tables every time.
--Enable quick reporting on summarized information, which is useful for customer and account-level insights.

CREATE MATERIALIZED VIEW CustomerAccountTransactionSummary 
BUILD IMMEDIATE 
REFRESH COMPLETE
START WITH sysdate
NEXT sysdate+1
AS
   SELECT c.customer_id, c.first_name, c.last_name, a.account_id, 
                  SUM(tf.amount) AS total_transaction_amount 
   FROM Customers c 
             JOIN Accounts a ON c.customer_id = a.customer_id 
             JOIN Transaction_fact tf ON a.account_id = tf.account_id 
   GROUP BY c.customer_id, c.first_name, c.last_name, a.account_id;

--This materialized view will automatically refresh every 24 hours.
