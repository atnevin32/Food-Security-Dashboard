import mysql.connector

try:
    database_name = "grafana_data"

    mydb = mysql.connector.connect(
        host='localhost',
        user='data_feed',
        passwd='D@T@F33d'
    )


    print("MySQL Connection successful!")

except mysql.connector.Error as err:
    print(f"Error connecting to MySQL: {err}")

try:
    cursor = mydb.cursor()
    cursor.execute(f"CREATE DATABASE {database_name}")
    print(f"Database '{database_name}' created successfully")

except mysql.connector.Error as err:
    print(f"Error creating database: {err}")
