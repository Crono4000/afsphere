
if [[ $# -eq 2 ]]; then
    if [[ $2 = "file" ]]; then
        psql -q -t -A -h 127.0.0.1 -U pizzamozzarella -d afsphere -f "/afsphere/sql_scripts/$1" -w
    elif [[ $2 = "friendly" ]]; then
        psql -q -h 127.0.0.1 -U pizzamozzarella -d afsphere -c "$1" -w
    fi
else
    psql -q -t -A -h 127.0.0.1 -U pizzamozzarella -d afsphere -c "$1" -w
fi

if [ $? -eq 1 ]; then
    afsphere afs_error "Error in the following query: $1"
    exit 1
fi