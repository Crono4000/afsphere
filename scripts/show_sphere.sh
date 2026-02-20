
if afsphere is_number $1; then 
    afsphere execute_sql "SELECT file.file_id, file_name, file_path, rank FROM file, connection WHERE file.file_id = connection.file_id AND connection.sphere_id = $1 ORDER BY rank DESC;" friendly
else
    afsphere execute_sql "SELECT file.file_id, file_name, file_path, rank FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = '$1' ORDER BY rank DESC;" friendly
fi