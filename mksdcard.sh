#!/bin/bash
DISK="/dev/sdb"
DEBIAN_DIR="../../debian12"
SDNAME="sdcard.img"

sudo dd if=${DEBIAN_DIR}/${SDNAME} of=${DISK} bs=16M status=progress
