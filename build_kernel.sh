#!/bin/bash
KERNEL_DIR="linux-imx-lf-6.1.y"
PANEL_SRC="AlcorDebianPatches/kernel_6.1_mipi_drv"
PANEL_DEST="drivers/gpu/drm/panel"
PANEL_FILES="Kconfig  Makefile  panel-tricomtek_ips1024600.c"

DTS_SRC="AlcorDebianPatches/kernel_6.1_dts"
DTS_DEST="arch/arm64/boot/dts/freescale"
DTS_FILES="alcor.dts alcor.dtsi Makefile"

CONFIG_SRC="AlcorDebianPatches/alcor_linux_6.1.x_dsi_defconfig"
CONFIG_DEST="arch/arm64/configs"

DEBIAN_DIR="debian12"
SDNAME="sdcard.img"
DBOFFSET="loop,offset=629145600"
MOUNTPOINT="mountpoint"

BINARIES="Binaries"

MANDATORY_DIRS="firmware-imx-8.10.1 imx-mkimage-lf-6.1.55 linux-imx-lf-6.1.y trusted-firmware-a uboot-imx_v2019.04_4.19.35_1.1.0 arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu"

patch_kernel() {
	for i in ${PANEL_FILES}; do
		cp ${PANEL_SRC}/${i} ${KERNEL_DIR}/${PANEL_DEST}/.
	done

	for i in ${DTS_FILES}; do
		cp ${DTS_SRC}/${i} ${KERNEL_DIR}/${DTS_DEST}/.
	done
	cp ${CONFIG_SRC} ${KERNEL_DIR}/${CONFIG_DEST}/.
}

mount_debian() {
	echo "sudo mount -o ${DBOFFSET} ../${DEBIAN_DIR}/${SDNAME} ${MOUNTPOINT}"
	sudo mount -o ${DBOFFSET} ../${DEBIAN_DIR}/${SDNAME} ${MOUNTPOINT}
	sync
}

umount_debian() {
	sync
	sudo umount ${MOUNTPOINT}
	sync
}

build_kernel() {
	cd ${KERNEL_DIR}
	make alcor_linux_6.1.x_dsi_defconfig
	make -j32 Image
	make -j32 modules
	make -j32 dtbs
	cp arch/arm64/boot/Image ../${BINARIES}/.
	cp arch/arm64/boot/dts/freescale/alcor.dtb ../${BINARIES}/.
	cd ..
}

install_kernel_modules() {
	cd ${KERNEL_DIR}
	sudo make INSTALL_MOD_PATH="../${MOUNTPOINT}" modules_install
	cd ..
}

HERE=`pwd`
cd ..
for i in ${MANDATORY_DIRS}; do
	if [ ! -d ${i} ]; then
		echo "${i} not present"
		exit -1
	fi
done

if [ ! -f ./SourceMe64 ]; then
	echo "Compiler not present"
	exit -1
fi
. ./SourceMe64

[ ! -d ${MOUNTPOINT} ] && mkdir ${MOUNTPOINT}
[ ! -d ${BINARIES} ] && mkdir ${BINARIES}

patch_kernel
build_kernel
mount_debian
install_kernel_modules
umount_debian

