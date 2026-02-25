
if [ "$(id -u)" -eq 0 ]; then
    cp "$AFSPHERE_PATH/afsphere" /bin/afsphere
    exit 0
else
    afsphere afs_error "Doesn't have admin permissions to execute this command"
    exit 1
fi