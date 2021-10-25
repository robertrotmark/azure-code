#!/bin/bash

#This script merges all Certificates matching the CRT files located in your current folder.

#vault-name
vname="<add keyvault name>"

for file in *.crt; do # Whitespace-safe but not recursive.
    secretName=${file//./-}
    secretName=${secretName//-crt/}
    kubectl get secrets --all-namespaces |grep $secretName
done
