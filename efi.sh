#!/bin/bash
# 
# author: pan3yao@gmail.com
#
if [ n$1 == n"" ];then
	echo "sudo fdisk /dev/sdX"
	echo "sudo mkfs.vfat /dev/sdX1"
	echo "make sure disk is vfat first!"
	exit 1
fi


TARGETDIR=./aa
BOOTDIR=$TARGETDIR/EFI/BOOT/

# mount
mkdir -p $TARGETDIR
mount $1 $TARGETDIR

# gen syslinux
mkdir -p $BOOTDIR

find ./syslinux/efi64/ -name *.c32 | xargs -i cp -raf {} $BOOTDIR
cp -raf ./syslinux/efi64/com32/elflink/ldlinux/ldlinux.e64 $BOOTDIR/
cp -raf ./syslinux/efi64/efi/syslinux.efi $BOOTDIR/bootx64.efi
cp -raf ./isofs/isolinux/isolinux.cfg $BOOTDIR/syslinux.cfg

#cp -raf ./usr/lib/syslinux/efi64/* $BOOTDIR/
#mv $BOOTDIR/syslinux.efi $BOOTDIR/bootx64.efi
#cp -raf ./isofs/isolinux/isolinux.cfg $BOOTDIR/syslinux.cfg

ls -l $BOOTDIR

# umount
umount $TARGETDIR

#sudo efibootmgr --create --disk /dev/sdb --part 1 --loader /EFI/BOOT/syslinux.efi --label "Syslinux" --verbose
#sudo efibootmgr --create --disk /dev/sdb --part 1 --loader /EFI/syslinux/syslinux.efi --label "Syslinux" --verbose  
