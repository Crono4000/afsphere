
if [ $# -ne  1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if [ ! -f "$1" ]; then
    afsphere afs_error "The argument isn't a valid file;"
    exit 1
fi

file="$1"
file_name="$(basename "$file")"
if ! afsphere execute_sql "CALL insert_file('$file_name', $(stat -c%s "$file"), NULL);"; then
    afsphere afs_error "Error inserting the file in the table."
    exit 1
fi
afsphere update_file "$file_name" "$file"