
disk=$(afsphere get_disk)

if [ $# -eq 2 ]; then
    file="$1"
    if [ ! -f "$file" ]; then
        afsphere afs_error "The file $file doesn't exist."
        exit 1
    fi
elif [ $# -eq 3 ]; then
    file="$1"
    if [ ! -f "$file"]; then
        afsphere afs_error "The file $file doesn't exist."
        exit 1
    fi

    disk="/afsphere/disks/$3"
    if [ ! -d $disk ]; then
        afsphere afs_error "The disk $disk doesn't exist."
        exit 1
    fi
else
    eafsphere afs_error "The arguments are invalid"
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
afsphere execute_sql "CALL add_file_with_sphere('$file_name', '$path', '$2');"
