
/*
 * Question 1: High-Value Customers with Multiple Products
 * 
 * This query identifies customers who have both savings plans and investment plans,
 * counts how many of each they have, and calculates their total deposits.
 * 
 * Notes:
 * - Savings plans are identified by is_regular_savings = 1
 * - Investment plans are identified by is_a_fund = 1
 * - Amount fields are in kobo (need to convert to standard currency)
 * - We join users, savings accounts, and plans tables to get the complete picture
 */

SELECT 
    cu.id AS owner_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,
     -- Count distinct savings and investments plans that are funded (confirmed_amount > 0)
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN p.id END) AS investment_count,
    -- Sum all confirmed deposits for the customer, converting from kobo to main currency (Naira)
    SUM(sa.confirmed_amount) / 100 AS total_deposits
-- join the three tables
FROM 
    users_customuser cu    
    JOIN savings_savingsaccount sa 
		ON sa.owner_id = cu.id
    JOIN plans_plan p 
		ON sa.plan_id = p.id
-- Group results by customer
GROUP BY 
    cu.id  

HAVING 
    -- Only include customers with at least one funded savings plan
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 
        AND sa.confirmed_amount > 0 THEN p.id END) >= 1
    -- And at least one funded investment plan
    AND COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 
        AND sa.confirmed_amount > 0 THEN p.id END) >= 1
-- Sort results by total deposits in descending order
ORDER BY 
    total_deposits DESC;  