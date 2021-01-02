#!/bin/bash
# 
# author: pan3yao@gmail.com
#

echo "git clone git://git.kernel.org/pub/scm/boot/syslinux/syslinux.git"
echo "sudo apt-get install nasm uuid-dev"
echo "sudo apt-get install libc6-dev-i386"
echo "mkfs.vat usb"
echo "mount usb"

echo "sudo bash -c \"printf '\\x1' | cat ./syslinux/bios/mbr/altmbr.bin - | dd bs=440 count=1 iflag=fullblock of=/dev/sdb\""

read -p "you are sure you wang to xxxxxx?[y/n]" input
if [ n$input != n"y" ];then
	echo "not ok "
	exit 1
fi

TARGETDIR=aa
BOOTDIR=$TARGETDIR/boot/syslinux/

mkdir -p $BOOTDIR
cp -raf ./isofs/isolinux/splash.png $BOOTDIR
cp -raf ./isofs/isolinux/isolinux.cfg $BOOTDIR/syslinux.cfg
cp -raf ./syslinux/bios/core/isolinux.bin $BOOTDIR/syslinux.bin
cp -raf ./syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 $BOOTDIR
cp -raf ./syslinux/bios/com32/lib/libcom32.c32 $BOOTDIR
cp -raf ./syslinux/bios/com32/libutil/libutil.c32 $BOOTDIR
cp -raf ./syslinux/bios/com32/menu/vesamenu.c32 $BOOTDIR
./syslinux/bios/extlinux/extlinux --install $BOOTDIR

#sudo ./syslinux/bios/linux/syslinux -d /syslinux/ /dev/sdb
#sudo ./syslinux/bios/linux/syslinux --install  /dev/sdb

#sudo dd if=./syslinux/bios/mbr/mbr.bin of=/dev/sdb
#sudo ./syslinux/bios/extlinux/extlinux --install ./aa/boot/syslinux/

