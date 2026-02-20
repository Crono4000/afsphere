
if afsphere is_number $1; then 
    lines=$(afsphere execute_sql "SELECT file.file_id FROM file, connection WHERE file.file_id = connection.file_id AND connection.sphere_id = $1 ORDER BY rank DESC;")
    sphere="$(afsphere execute_sql "SELECT sphere_name FROM sphere WHERE sphere_id = $1;")"
else
    lines="$(afsphere execute_sql "SELECT file.file_id FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = '$1' ORDER BY rank DESC;")"
    sphere="$1"
fi

sphere="${sphere## }"
mkdir "$sphere"

for tt in $lines; do
    afsphere transfer_file_from_db $tt "$sphere"
done

echo "$sphere"