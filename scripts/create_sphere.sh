
afsphere execute_sql "INSERT INTO sphere (sphere_name) SELECT '$1' WHERE NOT EXISTS(SELECT * FROM sphere WHERE sphere_name = '$1');"