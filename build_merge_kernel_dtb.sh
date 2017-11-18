#!/bin/bash
echo "WAFF WAFF WAFF WAFF WAFF WAFF WAFF WAFF"
echo "########### LOBO UTILIDADES ###########"
echo "WAFF WAFF WAFF WAFF WAFF WAFF WAFF WAFF"
echo ""
#echo "> Copiando archivo de configuracion"
#cp ../boot_stock_kernel/stock_defconfig .config
echo "> Copiando ramdisk a arch/arm64/boot"
cp ../boot_aosp_caf_booted/initramfs.cpio.gz arch/arm64/boot/boot.img-ramdisk.cpio.gz
echo "> Abriendo archivo de configuracion"
CFLAGS="-mtune=cortex-a53" ARCH=arm64 CROSS_COMPILE=../../aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android- make menuconfig
echo "> Iniciando compilacion del kernel usando .config"
CFLAGS="-mtune=cortex-a53" ARCH=arm64 CROSS_COMPILE=../../aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android- make -j4
echo "> COMPILANDO santoni.dts en santoni.dtb"
dtc -I dts -O dtb -o arch/arm64/boot/santoni-fdt.dtb ../boot_stock_kernel/santoni-fdt.dts
#echo "> Copiando santoni-fdt.dtb a arhc/arm64/boot/"
#cp ../boot_stock_kernel/santoni_stock.fdt arch/arm64/boot/santoni-fdt.dtb
echo "> COMBINANDO Kernel con DTB en kernel.img-dtb"
cat arch/arm64/boot/Image.gz arch/arm64/boot/santoni-fdt.dtb > arch/arm64/boot/kernel.img-dtb
echo ""
echo "> EMPAQUETANDO Kernel..."
./../mkbootimg/mkbootimg --kernel arch/arm64/boot/Image.gz-dtb --ramdisk arch/arm64/boot/boot.img-ramdisk.cpio.gz --cmdline 'sched_enable_hmp=1 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive buildvariant=userdebug androidboot.emmc=true androidboot.verifiedbootstate=orange androidboot.veritymode=enforcing androidboot.keymaster=1 androidboot.serialno=4d44ca9e7cf4 device_locked=0 androidboot.baseband=msm ' --pagesize 2048 --base 0x80000000 --ramdiskaddr 0x81000000 -o arch/arm64/boot/boot.img
echo "> ELIMINANDO MODULOS ANTERIORES"
rm -rf /media/psf/Home/Desktop/kmodules
mkdir /media/psf/Home/Desktop/kmodules
echo "> COPIANDO MODULOS A /media/psf/Home/Desktop/kmodules"
find . -type f -name "*.ko" -exec cp -fv {} /media/psf/Home/Desktop/kmodules/. \;
echo "> COPIANDO boot.img a /media/psf/Home/Desktop/"
cp arch/arm64/boot/boot.img /media/psf/Home/Desktop/.
echo "WAAAAAAAF IS DONE"
