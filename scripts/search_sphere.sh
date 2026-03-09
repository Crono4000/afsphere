
if [ $# -ne 1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
afsphere execute_sql -p "SELECT * FROM sphere WHERE sphere_name ILIKE '%$1%';"