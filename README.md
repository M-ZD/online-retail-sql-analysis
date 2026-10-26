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

- Python 3
- DuckDB, pandas, and openpyxl
- [UCI Online Retail dataset](https://archive.ics.uci.edu/dataset/352/online+retail)

### Setup

1. Download the Online Retail dataset from the UCI Machine Learning Repository.
2. Extract the Excel file and save it as `data/Online Retail.xlsx` inside the project folder.
3. Open Terminal in the project folder and install the required packages:

   ```bash
   python -m pip install duckdb pandas openpyxl
   ```

4. Import the dataset into DuckDB:

   ```bash
   python import_data.py
   ```

5. Run all five SQL analysis scripts:

   ```bash
   python run_analysis.py
   ```

The analysis scripts execute in sequence, starting with data cleaning and continuing through sales analysis, product analysis, customer segmentation, and customer retention.

### Validation

The project was successfully executed locally using DuckDB and Python.

The resulting analytical dataset contained:

- **530,104** qualifying sales lines
- **19,960** invoices
- **4,338** customers with known IDs
- **£10,666,684.54** in qualifying positive sales value

These results exclude cancellation invoices, non-positive quantities, and non-positive unit prices. They represent qualifying positive sales rather than fully reconciled net revenue.

The original Excel dataset and generated DuckDB database are excluded from GitHub. Users can recreate the database by following the steps above.
