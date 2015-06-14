psql -f clear.sql
psql -f create.sql
psql -f functions.sql
psql -f init_typy.sql

echo "press enter to continue"
read -n1

psql -f ./insert_dokumenty.sql
psql -f ./insert_places.sql
psql -f ./insert_wydarzenia.sql
psql -f ./insert_peoples.sql
psql -f ./insert_rest.sql
