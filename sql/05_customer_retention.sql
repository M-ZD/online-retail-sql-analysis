
-- Project: Online Retail SQL Analysis
-- Purpose: Calculate month-to-month customer retention.
-- Source table: sales_analysis
--
-- Retention definition:
-- Percentage of customers purchasing in one month who
-- also purchase in the immediately following month.
--
-- The final month has no observable following month and
-- is therefore reported as NULL.

WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', invoice_date)::DATE AS purchase_month
    FROM sales_analysis
    WHERE customer_id IS NOT NULL
),
monthly_retention AS (
    SELECT
        previous.purchase_month AS cohort_month,
        COUNT(DISTINCT previous.customer_id)
            AS previous_month_customers,
        COUNT(DISTINCT current.customer_id)
            AS retained_customers
    FROM customer_months previous
    LEFT JOIN customer_months current
        ON current.customer_id = previous.customer_id
       AND current.purchase_month =
           previous.purchase_month + INTERVAL '1 month'
    GROUP BY previous.purchase_month
),
last_month AS (
    SELECT MAX(purchase_month) AS max_month
    FROM customer_months
)
SELECT
    r.cohort_month,
    r.previous_month_customers,
    CASE
        WHEN r.cohort_month = l.max_month THEN NULL
        ELSE r.retained_customers
    END AS retained_customers,
    CASE
        WHEN r.cohort_month = l.max_month THEN NULL
        ELSE ROUND(
            100.0 * r.retained_customers
            / NULLIF(r.previous_month_customers, 0),
            2
        )
    END AS next_month_retention_pct
FROM monthly_retention r
CROSS JOIN last_month l
ORDER BY r.cohort_month;
