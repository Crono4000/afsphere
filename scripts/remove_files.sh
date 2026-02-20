
afsphere execute_sql "SELECT file_id, file_path FROM file WHERE $1;" | awk -F'|' 'NF >= 2 { system("rm \"" $2 "\"") }'
afsphere execute_sql "DELETE FROM file WHERE $1;"