#!/bin/bash

# usage: ./identity-to-hashcat.sh AGKcecrgyBNHkgjKqDlQPW7YlimD+VXPfpAx+gLSR0n1cOdIxFHaxKEF8SgAoaEtqQ==
# the hash can be version 2 or version 3
# discussion: https://forum.hashkiller.co.uk/topic-view.aspx?t=13850&m=102670

input=$1

kind=$(echo $1 | base64 -d | xxd -p -l 1 -s 0)

if [ 01 == $kind ]
then
  salt=$(echo $1 | base64 -d | xxd -p -c 32 -l 16 -s $((1+4+4+4)) | xxd -r -p | base64 -w 0)
  subkey=$(echo $1 | base64 -d | xxd -p -c 32 -l 32 -s $((1+4+4+4+16)) | xxd -r -p | base64 -w 0)
  iter=$(echo $1 | base64 -d | xxd -p -g 1 -l 4 -s $((1+4)))
  hash=sha256
elif [ 00 == $kind ]
then
  salt=$(echo $1 | base64 -d | xxd -p -c 32 -l 16 -s $((1)) | xxd -r -p | base64 -w 0)
  subkey=$(echo $1 | base64 -d | xxd -p -c 32 -l 32 -s $((1+16)) | xxd -r -p | base64 -w 0)
  iter=3e8
  hash=sha1
else
  echo Unsupported hash, exiting.
  exit
fi

echo "$hash:$(printf '%d' 0x$iter):$salt:$subkey"
