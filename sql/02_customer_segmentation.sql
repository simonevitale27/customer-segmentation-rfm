-- Anlaisi RFM: Segmentazione della clientela

WITH rfm_calc AS (
    SELECT 
        CustomerID,
        DATEDIFF('2011-12-09', MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))) as recency_days,
        COUNT(DISTINCT InvoiceNo) as frequency,
        ROUND(SUM(Quantity * UnitPrice), 2) as monetary_value
    FROM transactions
    WHERE Quantity > 0 AND UnitPrice > 0
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    recency_days,
    frequency,
    monetary_value,
    NTILE(5) OVER (ORDER BY recency_days DESC) as R_score,
    NTILE(5) OVER (ORDER BY frequency ASC) as F_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC) as M_score
FROM rfm_calc
LIMIT 10;



WITH rfm_calc AS (
    SELECT 
        CustomerID,
        DATEDIFF('2011-12-09', MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))) as recency_days,
        COUNT(DISTINCT InvoiceNo) as frequency,
        ROUND(SUM(Quantity * UnitPrice), 2) as monetary_value
    FROM transactions
    WHERE Quantity > 0 AND UnitPrice > 0
    GROUP BY CustomerID
),
rfm_scores AS (
    SELECT 
        CustomerID,
        recency_days,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency_days DESC) as R,
        NTILE(5) OVER (ORDER BY frequency ASC) as F,
        NTILE(5) OVER (ORDER BY monetary_value ASC) as M
    FROM rfm_calc
)
SELECT 
    CustomerID,
    R, F, M,
    recency_days,
    frequency,
    monetary_value,
    CASE 
        WHEN R = 5 AND F = 5 AND M = 5 THEN 'Champions'
        WHEN R >= 4 AND F >= 4 THEN 'Loyal'
        WHEN R <= 2 AND F >= 4 THEN 'At Risk'
        WHEN R = 1 AND F <= 2 THEN 'Lost'
        WHEN R >= 4 AND F <= 2 THEN 'Promising'
        ELSE 'Others'
    END as segment
FROM rfm_scores
ORDER BY monetary_value DESC
LIMIT 20;



WITH rfm_calc AS (
    SELECT 
        CustomerID,
        DATEDIFF('2011-12-09', MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))) as recency_days,
        COUNT(DISTINCT InvoiceNo) as frequency,
        ROUND(SUM(Quantity * UnitPrice), 2) as monetary_value
    FROM transactions
    WHERE Quantity > 0 AND UnitPrice > 0
    GROUP BY CustomerID
),
rfm_scores AS (
    SELECT 
        CustomerID,
        recency_days,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency_days DESC) as R,
        NTILE(5) OVER (ORDER BY frequency ASC) as F,
        NTILE(5) OVER (ORDER BY monetary_value ASC) as M
    FROM rfm_calc
),
segments AS (
    SELECT 
        CustomerID,
        monetary_value,
        CASE 
            WHEN R = 5 AND F = 5 AND M = 5 THEN 'Champions'
            WHEN R >= 4 AND F >= 4 THEN 'Loyal'
            WHEN R <= 2 AND F >= 4 THEN 'At Risk'
            WHEN R = 1 AND F <= 2 THEN 'Lost'
            WHEN R >= 4 AND F <= 2 THEN 'Promising'
            ELSE 'Others'
        END as segment
    FROM rfm_scores
)
SELECT 
    segment,
    COUNT(*) as num_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM segments), 2) as pct_customers,
    ROUND(SUM(monetary_value), 2) as total_revenue,
    ROUND(AVG(monetary_value), 2) as avg_revenue
FROM segments
GROUP BY segment
ORDER BY total_revenue DESC;
