#!/bin/bash
DEBIAN_DIR="../../debian12"
SDNAME="sdcard.img"
SD_OFFSET=33
MOUNTPOINT="../mountpoint"
BINARIES="../Binaries"
UBOOT_IMAGE="uboot.bin"
LOOPDEV="/dev/loop12"

sudo losetup ${LOOPDEV} ./${DEBIAN_DIR}/${SDNAME}
sudo dd if=${BINARIES}/${UBOOT_IMAGE} of=${LOOPDEV} bs=1k seek=${SD_OFFSET} conv=fsync
sudo losetup -d ${LOOPDEV}

