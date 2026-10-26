# Online Retail Sales Analysis — SQL Portfolio Project

## Overview

This project uses SQL and DuckDB to analyse an online retail transaction dataset. The goal is to demonstrate data cleaning, sales reporting, product performance analysis, customer segmentation and repeat-purchase analysis.

## Tools

- SQL
- DuckDB
- Python for database setup and query execution
- macOS

## Business Questions

1. How do sales and order volumes change over time?
2. Which products generate the highest qualifying sales value?
3. Which customers contribute the most sales?
4. How are customers distributed across spending segments?
5. What percentage of customers return in the following month?
6. How sensitive are customer rankings to unusually large transactions?

## Analysis Files

| File | Purpose |
|---|---|
| `01_data_cleaning.sql` | Inspect source data and document cleaning |
| `02_sales_analysis.sql` | Monthly sales and month-over-month growth |
| `03_product_analysis.sql` | Rank products by sales value |
| `04_customer_segmentation.sql` | Group customers by qualifying sales |
| `05_customer_retention.sql` | Calculate next-month customer retention |

## Key Findings

- Qualifying positive sales lines totalled approximately £10.67 million.
- November 2011 was the strongest full month in the observed period, with approximately £1.51 million in qualifying sales.
- The initial customer segmentation identified 104 high-value customers, accounting for approximately £3.65 million, or 36.9% of qualifying sales associated with customers with known IDs.
- Two unusually large invoices contributed approximately £245,653 in qualifying sales and materially influenced the high-value customer segment.
- Among complete monthly transitions, next-month retention ranged from 31.21% to 45.60%.

## Data Preparation and Assumptions

- The source data was imported into DuckDB and cleaned into a typed table.
- `sales_analysis` includes positive quantities, positive unit prices and invoices not beginning with `C`.
- Sales value is calculated as quantity multiplied by unit price.
- The analysis excludes transactions without customer IDs when customer-level metrics are calculated.
- Product rankings exclude selected postage and manual-entry codes.
- Customer segments use initial thresholds of £1,000 and £10,000 in qualifying sales.
- The dataset ends on 9 December 2011, so December is incomplete.
- Unusually large transactions are flagged for investigation rather than automatically treated as errors.

## Limitations

Qualifying sales value is not the same as audited net revenue. The analysis does not fully reconcile returns, credit notes, adjustments or all non-product transaction types. Customer retention is measured using customers with known IDs and observed monthly purchases.

## Reproducibility

### Requirements
- Python
- DuckDB Python package
- The UCI Online Retail dataset

### Setup
1. Download the Online Retail dataset from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail).
2. Create a DuckDB database and import the source data into a table named `raw_retail`. The raw table should contain the original eight columns: `InvoiceNo`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `UnitPrice`, `CustomerID` and `Country`.
3. Run the SQL scripts in the following order:
   - `01_data_cleaning.sql` — creates `retail_clean`.
   - `02_sales_analysis.sql` — creates `sales_analysis` and runs monthly sales analysis.
   - `03_product_analysis.sql` — analyses product performance.
   - `04_customer_segmentation.sql` — segments customers by qualifying sales.
   - `05_customer_retention.sql` — calculates next-month retention.

### Validation
The current analytical dataset contains 530,104 sales lines and approximately £10.67 million in qualifying positive sales value. These are baseline checks for the existing database, not a guarantee that every fresh import will produce identical results.

The scripts have been developed and checked against the existing DuckDB database. Full end-to-end execution from a fresh environment remains a final validation step before describing the project as fully reproducible.