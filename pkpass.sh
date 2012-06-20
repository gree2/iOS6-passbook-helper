#!/bin/bash

# First parameter is a directory to be 

if [ $2 ]
then
   echo Packaging directory $2
   
   # remmember current directory  
   olddir=$(pwd)

   cd $2


  rm -rf .DS_Store
 
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

   # Packagine must be done here
   cd $olddir  
   
   echo "Extracting keys from certificate"

   openssl pkcs12 -in $1 -clcerts -nokeys -passin "pass:$3" -out certificate.pem 
   openssl pkcs12 -in $1 -nocerts -out key.pem -passin "pass:$3" -passout pass:simplepassword

   echo "SIGNING ITSELF"

   openssl smime -binary -sign -signer certificate.pem -inkey key.pem -passin pass:simplepassword -in "$2/manifest.json" -out "$2/signature" -outform DER
   
   echo "Cleaning up"

   rm -f certificate.pem
   rm -f key.pem
  
   echo "Compressing"

   cd $2

   outname="out.pkpass"
   
   if [ $4 ] 
    then
     outname="$4.pkpass"
   fi


   zip -r $outname  * -x *.DS_Store

   cp $outname "$olddir/"

   rm -f $outname
   rm -f signature
   rm -f manifest.json
else
   echo FORMAT: $0 certificate.p12 path/to/package/content password [PackageName]
fi
