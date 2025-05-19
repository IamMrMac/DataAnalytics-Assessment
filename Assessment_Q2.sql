
/*
 * Question 2: Transaction Frequency Analysis
 * 
 * This query analyzes transaction patterns and categorizes customers by frequency:
 * - High Frequency: ≥10 transactions/month
 * - Medium Frequency: 3-9 transactions/month
 * - Low Frequency: ≤2 transactions/month
 * 
 * We calculate the average number of transactions per month for each customer,
 * then group them into the appropriate categories.
 */

-- First, create a CTE to calculate transactions per month for each customer
WITH TransactionCount AS (
    SELECT 
        cu.id AS customer_id,  
        COUNT(ss.id) AS total_transactions,  
        -- Calculate average transactions per month:
        COALESCE(
            COUNT(ss.id) / (TIMESTAMPDIFF(MONTH, MIN(ss.transaction_date), CURRENT_DATE) + 1), 
            0
        ) AS avg_transactions_per_month
    FROM 
        users_customuser cu
        -- Left join savings accounts to users
        LEFT JOIN savings_savingsaccount ss ON cu.id = ss.owner_id
    GROUP BY 
        cu.id  -- Group by customer to aggregate their transactions
)
-- Categorize customers results
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(customer_id) AS customer_count, -- count the number of customers in each frequency category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month -- Determine the average transactions per month for each category
FROM 
    TransactionCount
-- Group results by frequency category
GROUP BY 
    frequency_category
-- Show categories with highest average first
ORDER BY 
    avg_transactions_per_month DESC;