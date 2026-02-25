
if [ ! "$(id -u)" -eq 0 ]; then
    afsphere afs_error "Doesn't have admin permissions to execute this command"
    exit 1
fi
if [ ! -d "/home/$1" ]; then
    afsphere afs_error "The user doesn't exist"
    exit 1
fi

cp -r "$AFSPHERE_PATH/user_files/." "/home/$1"

for tt in $(ls -a "$AFSPHERE_PATH/user_files"); do
    if [[ "$tt" == ".." || "$tt" == "." ]]; then
        continue
    fi
    if [ ! -f "/home/$1/$tt" ]; then
        continue
    fi
    chown "$1" "/home/$1/$tt"
    chmod 600 "/home/$1/$tt"
done
