
UPDATE=false

while getopts ":u" opt; do
  case $opt in
    u)
        UPDATE=true
        ;;
    :)
        echo "A flag -$OPTARG precisa de argumento"
        exit 1
        ;;
    \?)
        echo "Flag inválida: -$OPTARG"
        exit 1
        ;;
  esac
done

shift $((OPTIND - 1))

df="$(afsphere execute_sql "SELECT file_path FROM file WHERE file_name = '$1';")"
if [ $? -gt 0 ]; then
    afsphere afs_error "Error getting the path from the disk;"
    exit 1
fi
if [ -z "$df" ]; then
    afsphere afs_error "The file_name '$1' isn't in the database;"
    exit 1
fi
if [ $# -ne 2 ]; then
    afsphere afs_error "Invalid number of arguments;"
    exit 1
fi
file="$2"
if [ ! -f "$file" ]; then
    afsphere afs_error "The file $file doesn't exist;"
    exit 1
fi
if $UPDATE; then
    file_name="$(basename "$file")"
    afsphere execute_sql "UPDATE file SET file_name = '$file_name', file_size = $(stat -c%s "$file") WHERE file_name = '$1';"
    afsphere execute_sql "CALL update_disk_size(NULL, '$file_name', NULL);"
fi
cp "$file" "$df"