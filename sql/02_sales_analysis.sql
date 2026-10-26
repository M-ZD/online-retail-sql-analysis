
-- Project: Online Retail SQL Analysis
-- Purpose: Create the analytical sales dataset and
-- analyse monthly sales performance.
-- Input: retail_clean
-- Output: sales_analysis

-- 1. Create the analytical dataset.
-- Exclude cancellation invoices, non-positive quantities,
-- and non-positive unit prices.
-- Keep retail_clean unchanged for auditability.

CREATE OR REPLACE TABLE sales_analysis AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    quantity * unit_price AS line_value
FROM retail_clean
WHERE invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;

-- 2. Validate the analytical dataset.

SELECT
    COUNT(*) AS sales_lines,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    COUNT(DISTINCT customer_id) AS customers_with_ids,
    ROUND(SUM(line_value), 2) AS qualifying_sales_value
FROM sales_analysis;


-- Project: Online Retail SQL Analysis
-- Purpose: Analyse monthly sales and month-over-month growth.
-- Source table: sales_analysis

-- 1. Monthly sales performance.
SELECT
    DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
    COUNT(DISTINCT invoice_no) AS invoices,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(line_value), 2) AS sales_value
FROM sales_analysis
GROUP BY 1
ORDER BY 1;

-- 2. Month-over-month sales growth.
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
        ROUND(SUM(line_value), 2) AS sales_value
    FROM sales_analysis
    GROUP BY 1
),
sales_comparison AS (
    SELECT
        sales_month,
        sales_value,
        LAG(sales_value) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    sales_value,
    previous_month_sales,
    ROUND(
        sales_value - previous_month_sales,
        2
    ) AS sales_change,
    ROUND(
        100.0 * (sales_value - previous_month_sales)
        / NULLIF(previous_month_sales, 0),
        2
    ) AS growth_pct
FROM sales_comparison
ORDER BY sales_month;
