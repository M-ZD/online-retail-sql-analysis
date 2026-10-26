
from pathlib import Path

import duckdb
import pandas as pd

PROJECT_DIR = Path(__file__).resolve().parent
DATA_FILE = PROJECT_DIR / "data" / "Online Retail.xlsx"
DATABASE_FILE = PROJECT_DIR / "retail.duckdb"

if not DATA_FILE.exists():
    raise FileNotFoundError(
        f"Dataset not found: {DATA_FILE}\n"
        "Download the UCI Online Retail dataset and place "
        "Online Retail.xlsx in the data folder."
    )

print("Reading Excel dataset...")
df = pd.read_excel(DATA_FILE, dtype=str)

print(f"Rows loaded: {len(df):,}")

con = duckdb.connect(str(DATABASE_FILE))

con.register("source_dataframe", df)

con.execute("""
    CREATE OR REPLACE TABLE raw_retail AS
    SELECT
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        UnitPrice,
        CustomerID,
        Country
    FROM source_dataframe
""")

row_count = con.execute(
    "SELECT COUNT(*) FROM raw_retail"
).fetchone()[0]

print(f"Created raw_retail with {row_count:,} rows.")

con.close()
