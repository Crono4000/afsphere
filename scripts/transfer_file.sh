
if [ $# -ne  1 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi

information="$(afsphere execute_sql "SELECT file_path FROM file WHERE file_name = '$1';")"
if [ -z "$information" ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi

name="$1"
file="$information"

cp "$file" "$name"