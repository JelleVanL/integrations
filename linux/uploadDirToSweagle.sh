#!/usr/bin/env bash

##########################################################################
#############
#############   UPLOAD A DIRECTORY OR FILE TO SWEAGLE IN SPECIFIC PATH
#############
############# Input: 1- Path to upload to, defined by each of the node names separated by ,
############# Input: 2- Config Directory or file to upload
############# Input: 3- Optional: file extension to filter files to read
############# supported extensions are json, xml, yaml, yml, others are considered as property files
############# Output: 0 if no errors, 1 + Details of errors if any
##########################################################################
if [ "$#" -lt "2" ]; then
    echo "********** ERROR: NOT ENOUGH ARGUMENTS SUPPLIED"
    echo "********** YOU SHOULD PROVIDE 1-NODEPATH AND 2-DIRECTORY OR FILE TO UPLOAD"
    echo "********** (OPTIONAL) YOU MAY PROVIDE ALSO 3- FILE EXTENSION TO FILTER DIRECTORY"
    exit 1
fi
argNodePath=$1

sweagleScriptDir="$PWD"/$(dirname "$0")

if [[ -f "$2" ]] ; then
  # the arg is a file, call the upload script only once
  $sweagleScriptDir/uploadFileToSweagle.sh "$argNodePath" "$2"
elif [[ -d "$2" ]] ; then
  # The arg is a directory, call the api for all files
  cd "$2"
  if [ ! -z "$3" ]; then
    # Use file extension as filter for the loop
    argFileExtension="$3"
    for file in *.${argFileExtension}; do
      # filename without extension if you want to add it to node path
      filename=$(basename "${file%.*}")
      # remove case where there is no result and "*" is returned
      if [ "$filename" == "*" ]; then
        echo "********** No file with extension: $argFileExtension"
        echo "********** In directory: $2"
        echo "********** Exiting without error"
        exit 0
      fi
      $sweagleScriptDir/uploadFileToSweagle.sh "$argNodePath,$filename" "$file"
    done
  else
    # No file extension provided as arg
    for file in *; do
      #filename without extension if you want to add it to node path
      filename=$(basename "${file%.*}")
      $sweagleScriptDir/uploadFileToSweagle.sh "$argNodePath,$filename" "$file"
    done
  fi

else
    echo "********** ERROR: Argument $2 is not a directory or file, exiting";
    exit 1
fi
