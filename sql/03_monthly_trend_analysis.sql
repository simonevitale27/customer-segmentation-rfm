-- Analisi dei trend dei ricavi mensili

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') as year_months,
        ROUND(SUM(Quantity * UnitPrice), 2) as monthly_revenue,
        COUNT(DISTINCT CustomerID) as active_customers,
        COUNT(DISTINCT InvoiceNo) as total_orders
    FROM transactions
    WHERE Quantity > 0 AND UnitPrice > 0
    GROUP BY DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m')
)
SELECT 
    year_months,
    monthly_revenue,
    active_customers,
    total_orders,
    ROUND(monthly_revenue / active_customers, 2) as avg_revenue_per_customer,
    LAG(monthly_revenue, 1) OVER (ORDER BY year_months) as prev_month_revenue,
    ROUND(((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY year_months)) / 
           LAG(monthly_revenue, 1) OVER (ORDER BY year_months)) * 100, 2) as mom_growth_pct
FROM monthly_revenue
ORDER BY year_months;
