
if [ $# -ne 2 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
afsphere execute_sql "CALL connect_by_name('$1', '$2');"