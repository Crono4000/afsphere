
for arg in "$@"; do
    afsphere execute_sql "INSERT INTO sphere (sphere_name) VALUES ('$arg');"
done