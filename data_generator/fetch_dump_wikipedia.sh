#!/bin/sh

mkdir -p downloads && cd downloads

curl -O http://dumps.wikimedia.org/jawiki/20141017/jawiki-20141017-langlinks.sql.gz
curl -O http://dumps.wikimedia.org/jawiki/20141017/jawiki-20141017-page.sql.gz

gunzip *.gz
./wikipedia_langlinks_sql_to_csv.rb jawiki-20141017-langlinks.sql > ../../data/jawiki-20141017-langlinks.csv
./wikipedia_page_sql_to_csv.rb jawiki-20141017-page.sql.gz > ../../data/jawiki-20141017-page.csv
