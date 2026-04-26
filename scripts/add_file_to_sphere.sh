
if [ $# -eq 2 ]; then
    file="$1"
    if [ ! -f "$file" ]; then
        afsphere afs_error "The file $file doesn't exist."
        exit 1
    fi
else
    afsphere afs_error "The arguments are invalid"
    exit 1
fi

if [ -z "$2" ]; then
    afsphere afs_error "The sphere name is invalid."
    exit 1
fi

file_name="$(basename "$file")"
if ! afsphere execute_sql "CALL add_file_with_sphere('$file_name', $(stat -c%s "$file"), '$2');"; then
    afsphere afs_error "Error inserting the file in the table."
    exit 1
fi
afsphere update_file "$file_name" "$file"
