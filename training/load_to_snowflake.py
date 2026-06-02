import snowflake.connector
import pandas as pd
from dotenv import load_dotenv
import os
from snowflake.connector.pandas_tools import write_pandas

load_dotenv()

# Connect to Snowflake
conn = snowflake.connector.connect(
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    user=os.getenv("SNOWFLAKE_USER"),
    token=os.getenv("SNOWFLAKE_TOKEN"),
    authenticator="programmatic_access_token",
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE")
)

# Load CSV
df = pd.read_csv("data/WA_Fn-UseC_-Telco-Customer-Churn.csv")
print(f"Loaded {len(df)} rows from CSV")

# Uppercase all column names to match Snowflake convention
df.columns = [col.upper() for col in df.columns]

# Upload to Snowflake
success, nchunks, nrows, _ = write_pandas(
    conn, df, "CUSTOMERS",
    database="CHURN_MLOPS",
    schema="RAW",
    auto_create_table=True,
    overwrite=True
)

print(f"✅ Successfully loaded {nrows} rows to Snowflake RAW.CUSTOMERS")

conn.close()