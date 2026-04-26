
if [ $# -ne 1 ]; then
    afsphere afs_error "The arguments are invalid"
    exit 1
fi
afsphere execute_sql "CALL delete_file('$1')"