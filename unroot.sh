#!/bin/bash

BLUESTACKS=/Applications/BlueStacks.app
ROOTFS_PATH=$BLUESTACKS/Contents/img/Root.qcow2
ROOTFS_BACKUP=$ROOTFS_PATH.bak

INITRD_PATH=$BLUESTACKS/Contents/img/initrd_hvf.img
INITRD_BACKUP=$INITRD_PATH.bak

if [ -f "$INITRD_BACKUP" ]; then
  echo '[*] Restoring initrd'
  cp $INITRD_BACKUP $INITRD_PATH
  rm $INITRD_BACKUP
else
  echo '[!] initrd backup not found'
fi

if [ ! -f "$ROOTFS_BACKUP" ]; then
  echo '[!] rootfs backup not found'
  exit 1
fi

echo '[*] Restoring rootfs'
cp $ROOTFS_BACKUP $ROOTFS_PATH
rm $ROOTFS_BACKUP

echo '[*] Starting BlueStacks'
open -n $BLUESTACKS
echo '[*] Done'
