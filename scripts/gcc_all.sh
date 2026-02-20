
files=$(ls -1 /afsphere/c_scripts)

for tt in $files; do
    name="$(echo "$tt" | sed s/.c//).out"
    gcc "/afsphere/c_scripts/$tt" -o "/afsphere/scripts/$name"
done