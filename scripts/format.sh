
afsphere execute_sql "DROP SCHEMA IF EXISTS public CASCADE;"
afsphere execute_sql "CREATE SCHEMA public;"
afsphere execute_sql -f start_schema.sql
