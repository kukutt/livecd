#!/bin/bash
#
# author: pan3yao@gmail.com
#
function root_need(){
    if [[ $EUID -ne 0 ]]; then
        echo "需要root权限" 1>&2
        exit 1
    fi
}
ret=ok
# 检查系统工具是否安装
function isExist(){
	if ! type $1 >/dev/null 2>&1; then
		echo "$1 未安装,尝试以下命令";
		echo "sudo apt-get update";
		echo "sudo apt-get install -y build-essential zlib1g-dev";
		ret=error;
	fi
}
[ "ok" == $ret ] && isExist make;
[ "ok" == $ret ] && isExist gcc;
[ "ok" != $ret ] && exit;

MKISOTOOL=$PWD/cdrtools/mkisofs/OBJ/x86_64-linux-cc/mkisofs
MKSQUASHFS=$PWD/squashfs/squashfs-tools/mksquashfs
function mkrootfs(){
	[ -d "./squashfs-root" ] && rm -rf squashfs-root
	[ -f "./filesystem.squashfs" ] && rm ./filesystem.squashfs
	mkdir squashfs-root
	cp -raf squashfs-root-bk/* squashfs-root/
	$MKSQUASHFS squashfs-root/ ./filesystem.squashfs -comp gzip -b 1024k -always-use-fragments -no-duplicates
}

function geniso(){
	[ -d "./isofs" ] && rm -rf isofs
	[ -f "./test.iso" ] && rm ./test.iso
	tar -zxf isofs.tgz
	cp filesystem.squashfs isofs/casper/ 
	$MKISOTOOL -iso-level 3 -r -V sblive -cache-inodes -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o test.iso isofs
}

root_need
mkrootfs
geniso
