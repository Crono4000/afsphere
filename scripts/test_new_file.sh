
disk=$(afsphere get_disk)
number=$(ls -1 $disk/files | wc -l)
path="$disk/files/$number"
while [ -f "$path" ]; do
  number=$(($number+1))
  path="$disk/files/$number"
done

echo "$path"