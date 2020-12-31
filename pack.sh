#!/bin/bash
#
# author: pan3yao@gmail.com
#
MKISOTOOL=$PWD/cdrtools-3.02/mkisofs/OBJ/x86_64-linux-cc/mkisofs
MKSQUASHFS=$PWD/squashfs4.3/squashfs-tools/mksquashfs

function precheck(){
	if [[ $EUID -ne 0 ]]; then
		echo "需要root权限" 1>&2
		exit 1
	fi

	insflg=no
	if [ ! -d "squashfs4.3" ]; then
		[ "ok" != isnflg ] && apt-get update && apt-get install -y build-essential zlib1g-dev && insflg=ok
		tar -zxf tools/squashfs4.3.tar.gz
		pushd squashfs4.3/squashfs-tools/
		make
		popd
	fi
	
	if [ ! -d "cdrtools-3.02" ]; then
		[ "ok" != isnflg ] && apt-get update && apt-get install -y build-essential zlib1g-dev && insflg=ok
		tar -zxf tools/cdrtools-3.02a07.tar.gz
		pushd cdrtools-3.02
		make
		popd
	fi
}

function mkrootfs(){
	[ -d "./squashfs-root" ] && rm -rf squashfs-root
	[ -f "./filesystem.squashfs" ] && rm ./filesystem.squashfs
	mkdir squashfs-root
	mount | awk '{print $3}' | grep "snap" > exfile
	rsync -av --exclude=$PWD --exclude=/tmp \
		--exclude=/media \
		--exclude=/dev \
		--exclude=/proc \
		--exclude=/run \
		--exclude=/sys \
		--exclude=/lost+found \
		--exclude=/swapfile \
		--exclude-from=./exfile \
		/ ./squashfs-root/
	mkdir -m 755 squashfs-root/media
	mkdir -m 755 squashfs-root/dev
	mkdir -m 555 squashfs-root/proc
	mkdir -m 755 squashfs-root/run
	mkdir -m 555 squashfs-root/sys
	mkdir -m 1777 squashfs-root/tmp
	cat exfile | xargs -i mkdir -p -m 755 squashfs-root{}
	$MKSQUASHFS squashfs-root/ ./filesystem.squashfs -comp gzip -b 1024k -always-use-fragments -no-duplicates
}

function geniso(){
	[ -d "./isofs" ] && rm -rf isofs
	[ -f "./test.iso" ] && rm ./test.iso
	tar -zxf tools/isofs.tgz
	cp filesystem.squashfs isofs/casper/ 
	$MKISOTOOL -iso-level 3 -r -V sblive -cache-inodes -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o test.iso isofs
}

precheck
mkrootfs
geniso
