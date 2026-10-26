
-- Project: Online Retail SQL Analysis
-- Purpose: Identify the best-selling products.
-- Source table: sales_analysis
--
-- Initial exclusions:
-- DOT, M and POST are postage/manual-entry codes.
-- BANK-prefixed codes are also excluded.
-- These are analytical rules, not universal classifications.

SELECT
    stock_code,
    MAX(description) AS product_description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice_no) AS invoices,
    ROUND(SUM(line_value), 2) AS sales_value
FROM sales_analysis
WHERE stock_code NOT IN ('DOT', 'M', 'POST')
  AND stock_code NOT LIKE 'BANK%'
GROUP BY stock_code
ORDER BY sales_value DESC
LIMIT 10;
