#!/bin/bash
#
# author: pan3yao@gmail.com
#
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
function runmain(){
	[ -d "./isofs" ] && chmod -R 777 ./isofs && rm -rf isofs
	[ -f "./test.iso" ] && rm ./test.iso
	tar -zxf isofs.tgz
	cp filesystem.squashfs isofs/casper/ 
	$MKISOTOOL -iso-level 3 -r -V sblive -cache-inodes -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o test.iso isofs
}

runmain
