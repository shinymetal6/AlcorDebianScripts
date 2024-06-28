#!/bin/bash
SDNAME="../debian12/sdcard.img"

DBOFFSET="loop,offset=10485760"
BINARIES="Binaries"
MOUNTPOINT="mountpoint"

sudo mount -o ${DBOFFSET} ${SDNAME} ${MOUNTPOINT}
sudo cp ${BINARIES}/* ${MOUNTPOINT}/.
sync
sudo umount ${MOUNTPOINT}
