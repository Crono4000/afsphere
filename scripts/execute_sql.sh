
FILE=false
FRIENDLY=false

while getopts ":fp" opt; do
  case $opt in
    p)
        FRIENDLY=true
        ;;
    f)
        FILE=true
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
if [ $FILE = true -o $FRIENDLY = true ]; then
    if $FILE; then
        if [ ! -f "$AFSPHERE_PATH/sql_scripts/$1" ]; then
            afsphere afs_error "The file $AFSPHERE_PATH/sql_scripts/$1 doesn't exist or isn't a file"
            exit 1
        fi
        psql -q -t -A -h 127.0.0.1 -U pizzamozzarella -d afsphere -f "$AFSPHERE_PATH/sql_scripts/$1" -w
    else
        psql -q -h 127.0.0.1 -U pizzamozzarella -d afsphere -c "$1" -w
    fi
else
    psql -q -t -A -h 127.0.0.1 -U pizzamozzarella -d afsphere -c "$1" -w
fi

if [ $? -eq 1 ]; then
    afsphere afs_error "Error in the following query: $1"
    exit 1
fi
