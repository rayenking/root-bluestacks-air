#!/bin/bash

BLUESTACKS=/Applications/BlueStacks.app
INITRD_PATH=$BLUESTACKS/Contents/img/initrd_hvf.img
INITRD_BACKUP=$INITRD_PATH.bak

if [ ! -f "$INITRD_BACKUP" ]; then
  echo '[!] initrd backup not found'
  exit 1
fi

echo '[*] Restoring initrd'
cp $INITRD_BACKUP $INITRD_PATH
echo '[*] Done'
