
if [ $# -ne 2 ]; then
    afsphere afs_error "The arguments aren't right."
    exit 1
fi

if ! afsphere execute_sql "INSERT INTO app_user(password, username) VALUES ('$2', '$1');"; then
    afsphere afs_error "Erro within sql query."
    exit 1
fi