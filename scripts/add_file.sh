
disk=$(afsphere get_disk)
file="$1"
i=1

if [ ! -f "$file" ]; then
  afsphere afs_error "The file $file doesn't exist."
  exit 1
fi

file_name="$(echo "$file" | awk -F'/' '{ print $NF}')"
number=$(ls -1 $disk/files | wc -l)
path="$disk/files/$number"
while [ -f "$path" ]; do
  number=$(($number+1))
  path="$disk/files/$number"
done

cp "$file" "$path"
chmod 777 "$path"

for sphere in "$@"; do
  if [ $i -gt 1 ]; then
    sphere_id=$(afsphere execute_sql "SELECT sphere_id FROM sphere WHERE sphere_name = '$sphere';")
    if [ -z "$sphere_id" ]; then
      afsphere afs_error "The sphere $sphere doesn't exist."
    else
      afsphere execute_sql "INSERT INTO connection (sphere_id, file_id) VALUES ($sphere_id, $file_id);"
    fi
  else
    file_id=$(afsphere execute_sql "INSERT INTO file (file_name, file_path) VALUES ('$file_name', '$path') RETURNING file_id;")
    if [ $? -eq 1 ]; then
        afsphere afs_error "Error in the following query: $1"
    fi
    i=$(($i + 1))
  fi
done

rm "$file"