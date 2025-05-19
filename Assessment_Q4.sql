

/*
 * Question 4: Customer Lifetime Value (CLV) Estimation
 *
 * This query calculates an estimated Customer Lifetime Value based on:
 * - Account tenure (months since signup)
 * - Total transactions
 * - Average profit per transaction (0.1% of transaction value)
 *
 * Formula: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
 */
 
SELECT 
    cu.id AS customer_id,  -- Unique identifier for each customer
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,  -- Customer's full name
    -- Calculate account tenure in months (including the current month)
    TIMESTAMPDIFF(MONTH, cu.date_joined, CURRENT_DATE) + 1 AS tenure_months,
    COUNT(s.id) AS total_transactions,  -- Total number of transactions for the customer
    -- Calculate estimated CLV:
    -- (transactions per month) * 12 * (average profit per transaction)
    -- where profit per transaction is 0.1% (0.001) of the transaction value
    ROUND(
        COALESCE(
            (COUNT(s.id) / (TIMESTAMPDIFF(MONTH, cu.date_joined, CURRENT_DATE) + 1)) * 12 *
            (AVG(s.confirmed_amount) /100 * 0.001),
            0
        ),
        2
    ) AS estimated_clv
FROM 
    users_customuser cu
    -- Join with savings_savingsaccount to get transactions for each customer
    LEFT JOIN savings_savingsaccount s ON cu.id = s.owner_id
WHERE 
    cu.is_active = 1  -- Only include active customers
    AND cu.is_account_deleted = 0  -- Exclude deleted accounts
GROUP BY 
    cu.id, cu.first_name, cu.last_name, cu.date_joined  -- Group by customer details
ORDER BY 
    estimated_clv DESC;  -- Show customers with the highest estimated CLV first