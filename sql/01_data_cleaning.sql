
-- Project: Online Retail SQL Analysis
-- Database: DuckDB
-- Purpose: Inspect raw data and document the cleaning process.
-- Input: raw_retail
-- Output: retail_clean

-- 1. Inspect sample source records.
SELECT *
FROM raw_retail
LIMIT 10;

-- 2. Check the raw row count.
SELECT COUNT(*) AS raw_row_count
FROM raw_retail;

-- 3. Check blank or missing customer IDs.
-- Raw columns are VARCHAR, so empty strings must be
-- treated separately from SQL NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE CustomerID IS NULL
           OR TRIM(CustomerID) = ''
    ) AS missing_customer_ids
FROM raw_retail;

-- 4. Create the cleaned table.
-- Excel serial dates are converted using the Excel
-- date origin 1899-12-30.
CREATE OR REPLACE TABLE retail_clean AS
SELECT
    NULLIF(TRIM(InvoiceNo), '') AS invoice_no,
    NULLIF(TRIM(StockCode), '') AS stock_code,
    NULLIF(TRIM(Description), '') AS description,
    TRY_CAST(NULLIF(TRIM(Quantity), '') AS INTEGER) AS quantity,
    TIMESTAMP '1899-12-30'
        + TRY_CAST(NULLIF(TRIM(InvoiceDate), '') AS DOUBLE)
        * INTERVAL '1 day' AS invoice_date,
    TRY_CAST(NULLIF(TRIM(UnitPrice), '') AS DECIMAL(12,4)) AS unit_price,
    TRY_CAST(NULLIF(TRIM(CustomerID), '') AS BIGINT) AS customer_id,
    NULLIF(TRIM(Country), '') AS country
FROM raw_retail;

-- 5. Validate the cleaned table.
SELECT COUNT(*) AS cleaned_row_count
FROM retail_clean;

-- 6. Check for invalid converted values.
SELECT
    COUNT(*) FILTER (WHERE invoice_date IS NULL)
        AS invalid_dates,
    COUNT(*) FILTER (WHERE quantity IS NULL)
        AS invalid_quantities,
    COUNT(*) FILTER (WHERE unit_price IS NULL)
        AS invalid_unit_prices,
    COUNT(*) FILTER (WHERE customer_id IS NULL)
        AS missing_customer_ids
FROM retail_clean;

-- Note:
-- The cleaned table preserves cancellation records,
-- negative quantities, and non-positive prices.
-- Business-analysis filters are applied separately.
