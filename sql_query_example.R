library(RODBC)

# the connection string for Azure SQL server. May vary depending on
# your server details. This can be found from vendor. 
# Uid example: myusername@abcdb1 where server is 'abcdb1.database.windows.net'
# Database name example: master/salesData/ContactTable etc
connectionString <- "Driver={ODBC Driver 13 for SQL Server};Server=tcp:<YOUR DATABASE NAME/IP>,1433;Database=<YOUR DATABSE NAME>,Uid=<YOUR USER NAME>@<FIRST PART OF YOUR SERVER NAME>;Pwd=<YOUR PASSWORD>;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"

# your query
q <- "SELECT 
         ... 
      FROM ...
      WHERE ...
      INNER JOIN ... ON ..."
# establish connection to the database in specified server
conn <- odbcDriverConnect(connectionString)

# execute the SQL on the DB and fetch the result in a dataframe
df <- RODBC::sqlQuery(conn, q, stringsAsFactors = FALSE) # change the stringasfactor if needed

# remember to close the connection
RODBC::odbcClose(conn)




