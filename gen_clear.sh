#!/bin/bash
create_file="$1"

# echo "-- Skrypt usuwający wszystkie utworzone tabele --"

grep -iE 'CREATE' "$create_file" | sed -r 's/or\s+replace//i' | while read line; do
   cmd=$(echo $line | awk '{print tolower($2)}')

   case "$cmd" in
      "trigger") echo $line | sed -r 's/.*CREATE\s+(\w+)\s+(\w+).*ON\s+(\w+).*/DROP TRIGGER IF EXISTS \2 ON \3 CASCADE;/ig' ;;
      "function") echo "DROP FUNCTION IF EXISTS"\
                        $(echo $line | cut -d'(' -f1 | awk '{print $3}')\
                        $(echo $line | grep -Eo '\(\s*(.*)\s*\)' | sed -r 's/\s*\w+\s*(\w+)[^,]*(,|\))/\1\2 /ig')\
                        "CASCADE;" ;;
      *) echo $line | sed -r 's/.*CREATE\s+(\w+)\s+(\w+).*/DROP \1 IF EXISTS \2 CASCADE;/ig' ;;
   esac
done
