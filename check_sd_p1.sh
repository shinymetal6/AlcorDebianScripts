#!/bin/bash
DEBIAN_DIR="../../debian12"
SDNAME="sdcard.img"
OFFSET="loop,offset=10485760"
MOUNTPOINT="../mountpoint"

sudo mount -o ${OFFSET} ${DEBIAN_DIR}/${SDNAME} ${MOUNTPOINT}
