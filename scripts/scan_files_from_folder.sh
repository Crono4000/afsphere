
for folder in "$1"/*; do
    if [ ! -d "$folder" ]; then
        continue
    fi
    if [ "$(ls -1 "$folder" | wc -l)" -eq 0 ]; then
        continue
    fi

    for file in "$folder"/*; do
        if afsphere simple_add_sphere "$file" "$(basename "$folder")"; then
            afsphere afs_success "Added file $file to sphere $(basename "$folder") with success!"
        else
            afsphere afs_error "Failed to add file $file to sphere $(basename "$folder")"
        fi
    done
done