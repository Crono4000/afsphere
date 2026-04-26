
dir="$(dirname "$1")"
if [[ -r "$dir" && -w "$dir" ]]; then
    exit 0
else
    exit 1
fi