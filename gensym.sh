#!/bin/sh

BASE="/var/www/fhaven/htdocs"

cd $BASE || exit 1

DIR="de it"

for i in $DIR; do
  for j in `ls -1 $i`; do
    ln -s $i/$j .
  done
done

