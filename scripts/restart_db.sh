
rm -r /afsphere/disks/disk1/files
mkdir /afsphere/disks/disk1/files

afsphere execute_sql "DROP SCHEMA public CASCADE;"
afsphere execute_sql "CREATE SCHEMA public;"
afsphere execute_sql start_db.sql file