-- RFM Analysis: Customer Segmentation
-- Business Goal: Identify high-value customers and churn risk
-- Date: January 2026

USE ecommerce_analysis;

-- Step 1: Calculate raw RFM metrics
WITH rfm_calc AS (
    SELECT 
        CustomerID,
        -- Recency: days since last purchase (lower = better)
        DATEDIFF('2011-12-09', MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))) as recency_days,
        -- Frequency: total number of orders
        COUNT(DISTINCT InvoiceNo) as frequency,
        -- Monetary: total amount spent
        ROUND(SUM(Quantity * UnitPrice), 2) as monetary_value
    FROM transactions
    WHERE Quantity > 0 AND UnitPrice > 0  -- Filter out returns/errors
    GROUP BY CustomerID
)
-- Step 2: Convert to 1-5 scores using quintiles
SELECT 
    CustomerID,
    recency_days,
    frequency,
    monetary_value,
    NTILE(5) OVER (ORDER BY recency_days DESC) as R_score,  -- Lower recency = higher score
    NTILE(5) OVER (ORDER BY frequency ASC) as F_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC) as M_score
FROM rfm_calc
LIMIT 10;