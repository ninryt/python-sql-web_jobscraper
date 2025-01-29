import pyodbc  # Libary to connect with SQL
import pandas as pd  # Libary to work with data

# Connection details
server = 'your.database.windows.net'  # Server name
database = 'yourdatabasename'  # Database name
username = 'sqlusername'  # SQL username
password = 'yourpassword'  # SQL password
driver = '{ODBC Driver 17 for SQL Server}'  # ODBC Driver

try:
    # Establish the connection
    conn = pyodbc.connect(
        f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
    )
    print("Connection successful!")

#Query data from DimTravel
    query = "SELECT * FROM DimTravel;"
    df = pd.read_sql(query, conn)

    print("All data from DimTravel table:")
    print(df.head())

    conn.close()
    print("Connection closed.")

except Exception as e:
    print("An error occured:", e)
