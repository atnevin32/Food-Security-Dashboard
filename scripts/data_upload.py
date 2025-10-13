from sqlalchemy import create_engine, types as sql_types
from urllib.parse import urlencode, urljoin
from datetime import *
import pycountry
import pandas as pd
import requests
import sys

def build_url():
        BASEURL = "https://hapi.humdata.org/api/v2/"
        ENDPOINT = sys.argv[3]

        params = {
                "app_identifier": #INSERT API KEY HERE, 
                "start_date": "2020-01-01",
                "end_date": date.today(),
                "output_format":"json",
                "offset":"0",
                "location_code": pycountry.countries.get(name=sys.argv[1]).alpha_3 
                }
        full_path = BASEURL + ENDPOINT + "?" + urlencode(params)
        return full_path

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
        try:
                datetime.fromisoformat(dt_str)
        except:
                return False
        return True

# Step 1: Fetch JSON from API
#url = "https://api.example.com/data"  # Replace with your actual API
if (sys.argv[2] == "json"):
	if ("worldbank" in sys.argv[3]):
		url=sys.argv[3]
	else:
		url=build_url()
	response = requests.get(url)
	response.raise_for_status()
	raw_data = response.json()

	# Step 2: Normalize nested JSON
	# Adjust the path if your data is nested under a key like "data"
	if isinstance(raw_data, dict):
		records = raw_data.get("data", raw_data)
	else:
		records = raw_data
	if(type(records) == list and "worldbank" in sys.argv[3]):
		records = records[1]	
	df = pd.json_normalize(records)
	tableName = sys.argv[4]

elif (sys.argv[2] == "csv"):
	df = pd.read_csv(sys.argv[3])
	tableName = sys.argv[4]
else: 
	exit()

try:
	for col in df.columns:
		if datetime_valid(df[col][0]):
			df[col] = pd.to_datetime(df[col].str.replace("Z", "+00:00"), errors='coerce')
except (AttributeError, ValueError, TypeError):
	pass  # Leave column as-is if conversion fail


dtype_mapping = {col: map_dtype(df[col].dtype) for col in df.columns}

# Step 4: Connect to MySQL using SQLAlchemy
username = #INSERT DB USERNAME HERE 
password = #INSERT DB PASSWORD HERE 
host = #INSERT DB HOSTNAME HERE 
database = #INSERT DB NAME HERE 
table_name = tableName


engine = create_engine(f"mysql+mysqldb://{username}:{password}@{host}/{database}")

# Step 5: Create table and insert data
df.to_sql(name=table_name, con=engine, if_exists='replace', index=False, dtype=dtype_mapping)

print("Table created and data inserted successfully!")
