
ls "$1" | while IFS= read -r line; do
    echo "line:$line"
done 
