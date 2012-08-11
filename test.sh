#!/bin/bash
while read line; do n=$((++n)) &&  echo $line|sed -e 's/^/'$(($n))' /' | sed -e 's/$/ off/' ; done < patt
