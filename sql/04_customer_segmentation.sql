
-- Project: Online Retail SQL Analysis
-- Purpose: Segment customers by qualifying sales value.
-- Source table: sales_analysis
--
-- Thresholds:
-- High value:   >= 10,000
-- Medium value: >= 1,000 and < 10,000
-- Low value:    < 1,000
--
-- These thresholds are initial analytical assumptions.

WITH customer_sales AS (
    SELECT
        customer_id,
        MAX(country) AS country,
        COUNT(DISTINCT invoice_no) AS invoice_count,
        SUM(line_value) AS total_spend
    FROM sales_analysis
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_spend >= 10000 THEN 'High value'
        WHEN total_spend >= 1000 THEN 'Medium value'
        ELSE 'Low value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_spend), 2) AS sales_value,
    ROUND(AVG(total_spend), 2) AS avg_customer_spend,
    ROUND(AVG(invoice_count), 2) AS avg_invoices_per_customer
FROM customer_sales
GROUP BY 1
ORDER BY
    CASE customer_segment
        WHEN 'High value' THEN 1
        WHEN 'Medium value' THEN 2
        ELSE 3
    END;
