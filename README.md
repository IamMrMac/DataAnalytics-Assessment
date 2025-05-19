# DataAnalytics-Assessment

## Objective
The primary objective of this project is to solve real-world business problems by writing efficient, accurate, and well-documented SQL queries. It focuses on extracting actionable insights from users_customuser, savings_savingsaccount, plans_plan, and withdrawals_withdrawal data to support cross-selling, customer segmentation, operational monitoring, and marketing strategies.

## Table of Contents  
High-Value Customers with Multiple Products  
Transaction Frequency Analysis  
Accounts with No Inflow for Over a Year  
Customer Lifetime Value (CLV) Estimation  
Challenges & Resolutions  

## High-Value Customers with Multiple Products  
### Question:  
Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
### Approach:   
This query identifies customers who have both funded savings and investment plans. It counts the number of each plan type per customer and sums their total deposits (converted from kobo to Naira). Only customers with at least one funded savings plan and one funded investment plan are included, sorted by total deposits in descending order.
### Key Steps:  
Join users_customeuser, savings_savingsaccount, and plans_plan tables.  
Use conditional aggregation to count funded savings and investment plans.  
Filter using HAVING to ensure both product types are present.  
Convert deposit amounts from kobo to Naira for readability.  

## Transaction Frequency Analysis  
### Question:  
Calculate the average number of transactions per customer per month and categorize them:  
"High Frequency" (≥10 transactions/month)  
"Medium Frequency" (3-9 transactions/month)  
"Low Frequency" (≤2 transactions/month)  
### Approach:  
This query analyzes how frequently customers transact, categorizing them as High, Medium, or Low Frequency based on their average monthly transaction count. It calculates the number of months each customer has been active and divides their total transactions accordingly.
### Key Steps:  
Count total transactions per customer.  
Compute average transactions per month.  
Categorize customers using CASE logic.  

## Accounts with No Inflow for Over a Year  
### Questions:  
Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
### Approach:  
This query finds active savings and investment accounts that have not received any inflow (transaction) in the past 365 days. It identifies the most recent transaction date for each account and calculates the days since that transaction.  
### Key Steps:  
Find the latest transaction date per account.  
Calculate inactivity days using date difference functions.  
Filter for accounts with at least 365 days of inactivity or no transactions at all.  

## Customer Lifetime Value (CLV) Estimation  
### Question:  
For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:  
Account tenure (months since signup)  
Total transactions  
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)  
Order by estimated CLV from highest to lowest  
### Approach:  
This query estimates the Customer Lifetime Value (CLV) using account tenure, total transaction count, and an average profit per transaction (0.1% of transaction value). 
### Key Steps:  
Calculate tenure in months since account creation.  
Count total transactions and calculate their average value.  
Estimate profit using the provided formula and round for clarity.  
Handle customers with no transactions gracefully.  

## Challenges & Resolutions  
1. Handling Currency Units
Challenge: Transaction amounts are stored in kobo, requiring conversion to Naira for meaningful reporting.
Resolution: Consistently divided amounts by 100 (or 100.0) and highlighted this in comments and documentation.
2. Grouping and Aggregation Logic
Challenge: Ensuring accurate counts and sums when joining multiple tables, especially with conditional aggregation.
Resolution: Used COUNT(DISTINCT CASE ) with clear conditions to avoid double-counting or missing data.
3. Accounts with No Transactions
Challenge: Some accounts may never have had a transaction, resulting in NULLs for transaction dates.
Resolution: Used LEFT JOINs and COALESCE logic to include these accounts in results and handle calculations safely.

