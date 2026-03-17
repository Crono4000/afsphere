
if [ $# -ne 2 ]; then
    afsphere afs_error "The arguments aren't right."
    exit 1
fi
if ! afsphere is_number "$2"; then
    afsphere afs_error "The second argument needs to be a number."
    exit 1
fi
if [ ! -d "$1" ]; then
    afsphere afs_error "The directory doesn't exists."
    exit 1
fi
if ! [[ -r "$1" && -w "$1" ]]; then
    afsphere afs_error "The disk doesn't have the right permissions."
    exit 1
fi

if ! afsphere execute_sql "INSERT INTO disk(disk_limit, disk_path) VALUES ($2, '$1');"; then
    afsphere afs_error "Erro within sql query."
    exit 1
fi