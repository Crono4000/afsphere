
if [ $# -ne  2 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
if [ ! -d "$2" ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi

information="$(afsphere execute_sql "SELECT file_path, file_name FROM file WHERE file_id = $1;" | head -n 1)"

file="$(echo $information | awk -F'\\|' '{print $1}')"
name="$(echo $information | awk -F'\\|' '{print $2}')"

name="$2/$name"
cp "$file" "$name"