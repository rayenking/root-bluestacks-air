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
  PLIST_FILE=$BLUESTACKS/Contents/Info.plist
  BS_VERSION=$(defaults read $PLIST_FILE CFBundleShortVersionString 2>/dev/null)
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

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 0

echo '[*] Preparing magisk'
[[ -d magisk ]] && rm -rf magisk
unzip -oq magisk.apk -d magisk

[[ -d $MAGISK_BIN_DIR ]] && rm -rf $MAGISK_BIN_DIR
mkdir $MAGISK_BIN_DIR

BIN_NAMES=("magisk64" "magiskinit" "magiskpolicy")
for BIN_NAME in ${BIN_NAMES[@]}; do
  SRC=magisk/lib/$ARCH/lib$BIN_NAME.so
  [[ -f $SRC ]] && cp $SRC $MAGISK_BIN_DIR/$BIN_NAME
done
cp magisk/assets/stub.apk $MAGISK_BIN_DIR/stub.apk

rm -rf magisk

echo '[*] Backing up rootfs'
[[ ! -f $ROOTFS_BACKUP ]] && cp $ROOTFS_PATH $ROOTFS_BACKUP
echo '[*] Backing up initrd'
[[ ! -f $INITRD_BACKUP ]] && cp $INITRD_PATH $INITRD_BACKUP

[[ ! -d build ]] && mkdir build
cd build

echo '[*] Patching initrd'
[[ -d initrd ]] && rm -rf initrd
mkdir initrd
cd initrd
cat $INITRD_BACKUP | cpio -id
cp -r $MAGISK_BIN_DIR boot/magisk
chmod 700 boot/magisk/*
cp $BASE_DIR/magisk.rc boot/magisk.rc
if [ -f $MAGISK_BIN_DIR/magisk32 ]; then
  sed -i '' -e 's/magisk64/magisk32/g' boot/magisk.rc
fi

# Install magisk to system
sed -i '' -e 's/exec \/init//' boot/stage2.sh
cat << EOF >> boot/stage2.sh
log_echo "Installing magisk.rc"
cat /boot/magisk.rc >> /init.bst.rc
die_if_error "Cannot install magisk.rc"

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
echo ''
echo '=================================================='
echo ''
echo 'Next steps:'
echo '* Install magisk.apk'
echo '* Open Kitsune Mask app and proceed with additional setup'
echo '* Quit BlueStacks'
