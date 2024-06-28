#!/bin/bash

MOUNTPOINT="mountpoint"
BINARIES="Binaries"

clone_repos() {
	git clone https://github.com/shinymetal6/AlcorDebianPatches
	git clone --branch lf-6.1.y https://github.com/nxp-imx/linux-imx
	mv linux-imx linux-imx-lf-6.1.y
	git clone --branch imx_v2019.04_4.19.35_1.1.0 https://github.com/nxp-imx/uboot-imx
	mv uboot-imx uboot-imx_v2019.04_4.19.35_1.1.0
	git clone https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
	git clone --branch lf-6.1.55_2.2.0 https://github.com/nxp-imx/imx-mkimage
	mv imx-mkimage imx-mkimage-lf-6.1.55
	wget https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-8.10.1.bin
	chmod +x firmware-imx-8.10.1.bin
	./firmware-imx-8.10.1.bin --force --auto-accept
}

get_gcc() {
	
	[ ! -f arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz ] && wget -O arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=cf8baa0ef2e54e9286f0409cdda4f66c&hash=4E1BA6BFC2C09EA04DBD36C393C9DD3A"
	[ ! -d arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu ] && tar xvf arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
	echo "export ARCH=arm64" > SourceMe64
	echo "export PATH=$PATH:/Devel/DebianBootKernel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin" >> SourceMe64
	echo "export CROSS_COMPILE=aarch64-none-linux-gnu-" >> SourceMe64
}

cd ..
get_gcc
clone_repos
mkdir ${MOUNTPOINT} ${BINARIES}
