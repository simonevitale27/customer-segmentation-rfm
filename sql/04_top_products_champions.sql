-- Analisi Prodotti per Segmento Clienti

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
        NTILE(5) OVER (ORDER BY recency_days DESC) as R,
        NTILE(5) OVER (ORDER BY frequency ASC) as F,
        NTILE(5) OVER (ORDER BY monetary_value ASC) as M
    FROM rfm_calc
),
customer_segments AS (
    SELECT 
        CustomerID,
        CASE 
            WHEN R = 5 AND F = 5 AND M = 5 THEN 'Champions'
            WHEN R >= 4 AND F >= 4 THEN 'Loyal'
            WHEN R <= 2 AND F >= 4 THEN 'At Risk'
            WHEN R = 1 AND F <= 2 THEN 'Lost'
            ELSE 'Others'
        END as segment
    FROM rfm_scores
)
SELECT 
    cs.segment,
    t.Description,
    COUNT(*) as purchase_count,
    ROUND(SUM(t.Quantity * t.UnitPrice), 2) as total_revenue
FROM customer_segments cs
JOIN transactions t ON cs.CustomerID = t.CustomerID
WHERE t.Quantity > 0 AND t.UnitPrice > 0
    AND cs.segment = 'Champions' -- Focus su custmer di alto valore
    AND t.Description IS NOT NULL
GROUP BY cs.segment, t.Description
HAVING purchase_count > 10 -- Filtro i prodotti con volume significativo
ORDER BY cs.segment, total_revenue DESC
LIMIT 3; -- Top 3 prodotti