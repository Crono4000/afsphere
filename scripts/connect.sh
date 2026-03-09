
if [ $# -ne 2 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if ! afsphere is_number "$1" || ! afsphere is_number "$2"; then
    afsphere afs_error "The arguments don't represent ids."
    exit 1
fi
afsphere execute_sql "INSERT INTO connection (file_id, sphere_id) VALUES ($1, $2);"