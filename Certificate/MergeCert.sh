#!/bin/bash

#This script merges all Certificates matching the CRT files located in your current folder.

vname="<add keyvault name>"

for file in *.crt; do # Whitespace-safe but not recursive.
    secretName=${file//./-}
    secretName=${secretName//-crt/}
    echo $secretName
    echo "Merge request \"$file\" with \"$secretName\""
    az keyvault certificate pending merge --file $file --name $secretName --vault-name $vname
done



