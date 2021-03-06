#!/usr/bin/env bash

##########################################################################
#############
#############   EXTRACT USEFUL CONFIG FROM PEM FILES AND PUT IT IN INI FORMAT
#############
############# Output: 0 if no errors, 1 + Details of errors if any
##########################################################################
if [ "$#" -lt "2" ]; then
    echo "********** ERROR: NOT ENOUGH ARGUMENTS SUPPLIED"
    echo "********** YOU SHOULD PROVIDE 1-DIRECTORY OF PEM FILES AND 2-OUTPUT FILE"
    exit 1
fi
argDir=$1
output=$2
argFileExtension="pem"

# Check if input is a directory
if [[ -d "$argDir" ]]; then
  dir=$(dirname "${output}")
  mkdir -p $dir
  echo "" > $output

  for file in "$argDir"/*.${argFileExtension}; do
    filename=$(basename "${file%.*}")
    # remove case where there is no result and "*" is returned
    if [ "$filename" == "*" ]; then
      echo "********** No file with extension: $argFileExtension"
      echo "********** In directory: $argDir"
      echo "********** Exiting without error"
      exit 0
    fi
    #echo "*** Store config of file: $filename"
    echo "[$filename]" >> $output
    echo file=$file  >> $output
    echo $(openssl x509 -noout -nameopt utf8 -issuer -in $file) >> $output
    echo $(openssl x509 -noout -nameopt utf8 -subject -in $file) >> $output
    echo "notAfter=$(date --date="$(openssl x509 -enddate -noout -in "$file"|cut -d= -f 2)" --iso-8601)" >> $output
    #echo "notAfter=$(date --date="$(openssl x509 -enddate -noout -in "$file"|cut -d= -f 2)" --iso-8601=seconds)" >> $output
    #echo $(openssl x509 -enddate -noout -in $file) >> $output
    echo >> $output
  done
else
  echo "********** Input $argDir is not a directory"
  exit 1
fi
