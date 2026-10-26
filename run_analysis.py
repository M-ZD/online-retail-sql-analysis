
from pathlib import Path

import duckdb

PROJECT_DIR = Path(__file__).resolve().parent
DATABASE_FILE = PROJECT_DIR / "retail.duckdb"
SQL_DIR = PROJECT_DIR / "sql"

SQL_FILES = [
    "01_data_cleaning.sql",
    "02_sales_analysis.sql",
    "03_product_analysis.sql",
    "04_customer_segmentation.sql",
    "05_customer_retention.sql",
]

if not DATABASE_FILE.exists():
    raise FileNotFoundError(
        f"Database not found: {DATABASE_FILE}\n"
        "Run import_data.py first."
    )

con = duckdb.connect(str(DATABASE_FILE))

try:
    for filename in SQL_FILES:
        sql_file = SQL_DIR / filename

        if not sql_file.exists():
            raise FileNotFoundError(f"SQL file not found: {sql_file}")

        print(f"\nRunning {filename}...")

        sql_text = sql_file.read_text(encoding="utf-8")
        con.execute(sql_text)

        print(f"Completed {filename}")

    print("\nAll SQL scripts completed successfully.")

    print("\nFinal sales dataset validation:")
    print(
        con.execute("""
            SELECT
                COUNT(*) AS sales_lines,
                COUNT(DISTINCT invoice_no) AS invoices,
                COUNT(DISTINCT customer_id) AS customers_with_ids,
                ROUND(SUM(line_value), 2) AS qualifying_sales
            FROM sales_analysis
        """).fetchdf().to_string(index=False)
    )

finally:
    con.close()
