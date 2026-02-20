
information="$(afsphere execute_sql "SELECT file_path, file_name FROM file WHERE file_id = $1;" | head -n 1)"

file="$(echo $information | awk -F'\\|' '{print $1}')"
name="$(echo $information | awk -F'\\|' '{print $2}')"

if [ $# -eq  2 ]; then
    if [ -d "$2" ]; then
        name="$2/$name"
    fi
fi

cp "$file" "$name"