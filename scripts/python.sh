
if [ $# -ne 1 ]; then
    afsphere afs_error "The arguments are invalid"
    exit 1
fi
if [ ! -f "$AFSPHERE_PATH/python/$1.py" ]; then
    afsphere afs_error "The file doesn't exit"
    exit 1
fi
if [ ! -x "$AFSPHERE_PATH/python/$1.py" ]; then
    afsphere afs_error "Execution permission denied"
    exit 1
fi
python3 "$AFSPHERE_PATH/python/$1.py"