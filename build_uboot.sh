#!/bin/bash
IMX_CONTAINER="boot_files"
UBOOT_DIR="uboot-imx_v2019.04_4.19.35_1.1.0"
ATF_DIR="trusted-firmware-a"
FIRMWARE_DIR="firmware-imx-8.10.1"
MKIMAGE_DIR="imx-mkimage-lf-6.1.55"
BINARIES="Binaries"

BOOT_SCRIPT_IN="AlcorDebianPatches/boot_script"
BOOT_SCRIPT_OUT="${BINARIES}/boot.scr"

MANDATORY_DIRS="arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu firmware-imx-8.10.1 imx-mkimage-lf-6.1.55 linux-imx-lf-6.1.y trusted-firmware-a uboot-imx_v2019.04_4.19.35_1.1.0"

make_uboot() {
	cd ${HERE}
	cd ${UBOOT_DIR}
	make clean
	make imx8mm_evk_defconfig
	make
	cd ${HERE}
}

make_atf() {
	cd ${HERE}
	cd ${ATF_DIR}
	unset LDFLAGS
	make distclean
	make PLAT=imx8mm bl31
	cd ${HERE}
}

run_mkimage() {
	cd ${HERE}
	cd ${MKIMAGE_DIR}
	cp ../${UBOOT_DIR}/spl/u-boot-spl.bin iMX8M/.
	cp ../${UBOOT_DIR}/u-boot-nodtb.bin iMX8M/.
	cp ../${UBOOT_DIR}/arch/arm/dts/fsl-imx8mm-evk.dtb iMX8M/.
	cp ../${ATF_DIR}/build/imx8mm/release/bl31.bin iMX8M/.
	cp ../${FIRMWARE_DIR}/firmware/ddr/synopsys/lpddr4_pmu_train_* iMX8M/.
	cp ../${UBOOT_DIR}/tools/mkimage iMX8M/mkimage_uboot
	cp ../${UBOOT_DIR}/arch/arm/dts/fsl-imx8mm-evk.dtb iMX8M/.
	make SOC=iMX8MM flash_evk
	cp ./iMX8M/flash.bin ../${BINARIES}/uboot.bin
	cd ${HERE}
}

make_boot_scr() {
	cd ${HERE}
	echo `pwd`
	echo "mkimage -C none -A arm -T script -d ${BOOT_SCRIPT_IN} ${BOOT_SCRIPT_OUT}"
	mkimage -C none -A arm -T script -d ${BOOT_SCRIPT_IN} ${BOOT_SCRIPT_OUT}
}

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
HERE=`pwd`
#make_uboot
#make_atf
#run_mkimage
make_boot_scr
