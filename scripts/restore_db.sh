
if [ $# -ne  1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if [ ! -d "$1" ]; then
    afsphere afs_error "The argument isn't a folder;"
    exit 1
fi
if [ ! -d "$1/files" ]; then
    afsphere afs_error "The folder '$1/files' doesn't exist;"
    exit 1
fi

dir=$(realpath -s "$1")
ls "$dir/files" | while IFS= read -r line; do
    if ! afsphere insert_file "$dir/files/$line"; then
        afsphere afs_error "Wasn't able to insert the file '$line'"
        exit 1
    fi
done

cat "$dir/spheres.txt" | awk -v yy="afsphere create_sphere \"" '{ system(yy $0 "\"") }'
cat "$dir/connections.txt" | awk -F'|' -v yy="afsphere connect_by_name \"" '{ system(yy $1 "\" \"" $2 "\"") }'
