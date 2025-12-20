/* a
SELECT * FROM account WHERE balance > 500;
*/

/* b
SELECT borrower.customer_name AS "nome", customer.customer_city AS "cidade" FROM borrower
JOIN loan ON borrower.loan_number = loan.loan_number
JOIN customer ON borrower.customer_name = customer.customer_name
WHERE amount BETWEEN 1000 AND 2000;
*/

/* c
SELECT ROUND(balance * 1.1) AS "cash money" FROM account WHERE branch_name = 'Downtown'
*/

/* d
SELECT SUM(balance) FROM account
JOIN depositor ON account.account_number = depositor.account_number
JOIN borrower ON depositor.customer_name = borrower.customer_name AND borrower.loan_number = 'L-15'
*/

/* e
SELECT branch_name AS "agência" FROM account 
JOIN depositor ON account.account_number = depositor.account_number AND depositor.customer_name LIKE 'J%n'
*/

/* f
SELECT loan.amount FROM customer 
JOIN borrower ON borrower.customer_name = customer.customer_name AND length(customer_city) = 6
JOIN loan ON loan.loan_number = borrower.loan_number
*/

/* g
SELECT loan.amount FROM customer 
JOIN borrower ON borrower.customer_name = customer.customer_name AND customer_city LIKE '% %'
JOIN loan ON loan.loan_number = borrower.loan_number
*/

/* h
SELECT assets FROM branch
JOIN account ON account.branch_name = branch.branch_name
JOIN depositor ON depositor.account_number = account.account_number AND customer_name = 'Johnson'
*/

/* i
SELECT customer.customer_name AS "customer" from customer
JOIN borrower ON borrower.customer_name = customer.customer_name
JOIN loan ON loan.loan_number = borrower.loan_number
JOIN branch ON branch.branch_name = loan.Branch_name AND branch.branch_city = customer.customer_city
*/

/* j
SELECT account.balance FROM account
JOIN branch ON branch.branch_name = account.branch_name AND branch.branch_city = 'Lisbon'
*/

/* k
SELECT customer.customer_name,customer.customer_city, branch.branch_city from customer
JOIN depositor ON depositor.customer_name = customer.customer_name
JOIN account ON account.account_number = depositor.account_number
JOIN branch ON branch.branch_name = account.Branch_name AND customer.customer_city = branch.branch_city
*/