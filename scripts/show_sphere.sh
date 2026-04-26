
if [ $# -ne 1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if afsphere is_number "$1"; then 
    afsphere execute_sql -p "SELECT file.file_id, file_name, rank FROM file, connection WHERE file.file_id = connection.file_id AND connection.sphere_id = $1 ORDER BY rank DESC;"
else
    afsphere execute_sql -p "SELECT file.file_id, file_name, rank FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = '$1' ORDER BY rank DESC;"
fi