#!/bin/bash

BLUESTACKS=/Applications/BlueStacks.app
ADB_PORT=5555
ARCH=arm64-v8a
BASE_DIR=$(pwd)
MAGISK_BIN_DIR=$BASE_DIR/magisk-bin
ROOTFS_PATH=$BLUESTACKS/Contents/img/Root.qcow2
ROOTFS_BACKUP=$ROOTFS_PATH.bak
INITRD_PATH=$BLUESTACKS/Contents/img/initrd_hvf.img
INITRD_BACKUP=$INITRD_PATH.bak

if [ -d "$BLUESTACKS" ]; then
  BS_VERSION_FILE=$(find "$BLUESTACKS" -maxdepth 1 -type f -name '[0-9].*')
  BS_VERSION=${BS_VERSION_FILE##*/}
  echo "[*] Found BlueStacks Air version $BS_VERSION"
else
  echo "[!] BlueStacks not found"
  exit 1
fi

echo '=================================================='
echo '**                                              **'
echo '**        BlueStacks Air Magisk Installer       **'
echo '**                                              **'
echo '=================================================='
echo ''
echo 'Checklist:'
echo '* You have started BlueStacks for the first time.'
echo '* BlueStacks is closed before proceeding.'
echo ''

echo '[*] Preparing magisk'
[[ -d magisk ]] && rm -rf magisk
unzip -q magisk.apk -d magisk

[[ -d $MAGISK_BIN_DIR ]] && rm -rf $MAGISK_BIN_DIR
mkdir $MAGISK_BIN_DIR

BIN_NAMES=("magisk32" "magisk64" "magiskinit" "magiskpolicy")
for BIN_NAME in ${BIN_NAMES[@]}; do
  SRC=magisk/lib/$ARCH/lib$BIN_NAME.so
  [[ -f $SRC ]] && cp $SRC $MAGISK_BIN_DIR/$BIN_NAME
done
cp magisk/assets/stub.apk $MAGISK_BIN_DIR/stub.apk

rm -rf magisk

[[ ! -d build ]] && mkdir build
cd build

echo '[*] Backing up rootfs'
[[ ! -f $ROOTFS_BACKUP ]] && cp $ROOTFS_PATH $ROOTFS_BACKUP
echo '[*] Backing up initrd'
[[ ! -f $INITRD_BACKUP ]] && cp $INITRD_PATH $INITRD_BACKUP

echo '[*] Patching initrd'
[[ -d initrd ]] && rm -rf initrd
mkdir initrd
cd initrd
cat $INITRD_BACKUP | cpio -i
zip -qj boot/magisk-bin.zip $MAGISK_BIN_DIR/*
cp $BASE_DIR/magisk.rc boot/magisk.rc
if [ -f $MAGISK_BIN_DIR/magisk32 ]; then
  sed -i '' -e 's/magisk64/magisk32/g' boot/magisk.rc
fi

# Mount filesystem as rw
sed -i '' -e 's/mount -o ro/mount -o rw/g' boot/init

# Install magisk to system
sed -i '' -e 's/exec \/init//' boot/stage2.sh
cat << EOF >> boot/stage2.sh
if [ -f /boot/magisk-bin.zip ]; then
  log_echo "Installing Magisk"
  unzip -q /boot/magisk-bin.zip -d /system/etc/init/magisk
  chmod 700 /system/etc/init/magisk/*
  cp /system/etc/init/bootanim.rc{,.bak}
  cat /boot/magisk.rc >> /system/etc/init/bootanim.rc
fi

exec /init
EOF


echo '[*] Repacking initrd'
find . | cpio -H newc -o | gzip > $INITRD_PATH

cd $BASE_DIR

# Cleanup
rm -rf build
rm -rf $MAGISK_BIN_DIR

echo '[*] Starting BlueStacks'
open -n $BLUESTACKS

echo '[*] Done'
echo '=================================================='
echo 'Next steps:'
echo '* Install magisk.apk'
echo '* Open Kitsune Mask app and proceed with additional setup'
echo '* Force quit BlueStacks'
echo '* Execute restore_initrd.sh'
