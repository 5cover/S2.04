#!/usr/bin/env bash

set -euo pipefail

pg_format -w 120 -u 1 -U 1 -f 1 -p 'WbImport(.|\n)*?;\n' populate_college2_db.sql > populate_college2_db-clean.sql