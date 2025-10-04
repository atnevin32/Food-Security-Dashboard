#ARGV 1 is the start date
#ARGV 2 is the endpoint
#ARGV 3 is the table name

import pandas as pd
from sqlalchemy import create_engine, types as sql_types
from datetime import * 
import sys


def map_dtype(dtype):
    if pd.api.types.is_integer_dtype(dtype):
        return sql_types.INTEGER()
    elif pd.api.types.is_float_dtype(dtype):
        return sql_types.FLOAT()
    elif pd.api.types.is_datetime64_any_dtype(dtype):
        return sql_types.DATETIME()
    elif datetime_valid(dtype): 
        return sql_types.DATETIME()
    else:
        return sql_types.VARCHAR(length=255)

def datetime_valid(dt_str):
	print(dt_str)
	try:
		datetime.fromisoformat(dt_str)
	except:
		return False
	return True

if(len(sys.argv) < 2):
	print("Not enough arguments provided")
	print("python3 load.py <filename> <table_name>")
	print("python3 load.py ConsumerPriceIndicesgrep.csv ConsumerPriceIndices")
	sys.exit("")

df = pd.read_csv(sys.argv[1])

for col in df.columns:
	try:
		if datetime_valid(df[col][0]):
			print("True")
			df[col] = pd.to_datetime(df[col].str.replace("Z", "+00:00"), errors='coerce')
	except (AttributeError, ValueError, TypeError):
		pass  # Leave column as-is if conversion fail


dtype_mapping = {col: map_dtype(df[col].dtype) for col in df.columns}

# Step 4: Connect to MySQL using SQLAlchemy
username = "alex"
password = "Food_Sec_334"
host = "localhost"
database = "grafana_data"
table_name = sys.argv[2] 

engine = create_engine(f"mysql+mysqldb://{username}:{password}@{host}/{database}")

# Step 5: Create table and insert data
df.to_sql(name=table_name, con=engine, if_exists='replace', index=False, dtype=dtype_mapping)

print("Table created and data inserted successfully!")

