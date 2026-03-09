
if [ $# -ne 1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if ! afsphere is_number "$1"; then 
    afsphere afs_error "The argument isn't a number;"
    exit 1
fi
afsphere execute_sql -p "SELECT sphere.sphere_id, sphere_name FROM connection, sphere WHERE connection.sphere_id = sphere.sphere_id AND file_id = $1;"
