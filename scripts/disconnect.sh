
if [ $# -ne 2 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if ! afsphere is_number "$1" || ! afsphere is_number "$2"; then
    afsphere afs_error "The arguments don't represent ids."
    exit 1
fi
afsphere execute_sql "DELETE FROM connection WHERE file_id = $1 AND sphere_id = $2;"