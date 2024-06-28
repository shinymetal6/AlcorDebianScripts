#!/bin/bash
DEBIAN_DIR="../../debian12"
SDNAME="sdcard.img"

DBOFFSET="loop,offset=10485760"
BINARIES="../Binaries"
MOUNTPOINT="../mountpoint"

sudo mount -o ${DBOFFSET} ${DEBIAN_DIR}/${SDNAME} ${MOUNTPOINT}
sudo cp ${BINARIES}/* ${MOUNTPOINT}/.
sync
sudo umount ${MOUNTPOINT}
