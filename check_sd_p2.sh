#!/bin/bash
DEBIAN_DIR="../../debian12"
SDNAME="sdcard.img"
OFFSET="loop,offset=629145600"
MOUNTPOINT="../mountpoint"

sudo mount -o ${OFFSET} ${DEBIAN_DIR}/${SDNAME} ${MOUNTPOINT}
