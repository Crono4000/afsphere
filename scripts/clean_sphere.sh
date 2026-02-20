
folders=$(ls -1 "/afsphere/spheres/$1")
for tt in $folders; do
    echo "$tt"
    original="$(readlink "/afsphere/spheres/$1/$tt")"
    if [ ! -f $original ]; then
        echo "11"
        rm "/afsphere/spheres/$1/$tt"
        continue
    fi
    nome="$(basename "$original")"
    if [ "$tt" ~= "$nome" ]; then
        echo "22"
        mv "/afsphere/spheres/$1/$tt" "/afsphere/spheres/$1/$nome"
    fi
done