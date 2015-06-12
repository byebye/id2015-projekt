#!/bin/bash

echo "-- Skryept usuwający wszystkie utworzone tabele --"
grep -iE 'CREATE' create.sql | sed -r 's/.*CREATE\s+(\w+)\s+(\w+)\s*\(.*/DROP \1 IF EXISTS \2 CASCADE;/g'
