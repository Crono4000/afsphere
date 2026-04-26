
if [ $# -ne  1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if [ ! -d "$1" ]; then
    afsphere afs_error "The argument isn't a folder;"
    exit 1
fi
if [ ! -d "$1/files" ]; then
    mkdir "$1/files"
fi

afsphere execute_sql "SELECT file_name, file_path FROM file;" | awk -F'|' -v di="$1/files" '{ system("cp \"" $2 "\" \"" di "/" $1 "\"") }'
afsphere execute_sql "SELECT sphere_name FROM sphere;" > "$1/spheres.txt"
afsphere execute_sql "SELECT CONCAT_WS('|', file_name, sphere_name) FROM sphere, connection, file WHERE sphere.sphere_id = connection.sphere_id AND file.file_id = connection.file_id;" > "$1/connections.txt"
