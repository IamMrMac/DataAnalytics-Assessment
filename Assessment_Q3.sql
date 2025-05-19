
/*
 * Question 3: Accounts with no inflow for over a year
 *
 * This query identifies active accounts with no transactions in the last 365 days.
 * We find the most recent transaction date for each account and calculate 
 * the number of days since that transaction.
 * 
 * Only accounts with inactivity greater than 365 days are included.
 */

SELECT 
    p.id AS plan_id,
    p.owner_id,
    -- Determine plan type: 'Savings' or 'Investment'
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    -- Find the most recent transaction date for each plan
    MAX(s.transaction_date) AS last_transaction_date,
    -- Calculate days since the last transaction
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
-- Join plans_plan to savings_savingsaccount table
FROM 
    plans_plan p
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
-- Determine active accounts (Not deleted or Archived)
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.is_deleted = 0
    AND p.is_archived = 0
    
GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
-- Find and only include accounts with no activity for the last 365 days
HAVING 
    inactivity_days >= 365
    OR last_transaction_date IS NULL
-- Show the most inactive plans first
ORDER BY 
    inactivity_days DESC;