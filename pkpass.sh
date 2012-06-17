#!/bin/bash

# First parameter is a directory to be 

if [ $1 ]
then
   echo Packaging directory $1
   cd $1
  
   # Opening statement 
   echo "{" > manifest.json

   # Iterating over files in the specified directory
   
   first="true"
   
   for file in `find .`
   do
     if [ -f $file ]
     then
            
      # Creating filename without "./" prefix
      fname=$(echo $file | colrm 1 2)

      if [ "$fname" != "manifest.json" ]
        then
        if [ "$first" == "true" ]
          then
            first="false" 
          else
            echo "," >> manifest.json
        fi
        echo FILE = $fname 
        checksum=$(openssl sha1 $fname | awk '{print $2}')
        echo -n "\"$fname\" : \"$checksum\"" >> manifest.json
      fi
     fi
   done
   
   # Closing statement
   echo >> manifest.json
   echo "}" >> manifest.json
    
else
   echo FORMAT: $0 dir
fi
