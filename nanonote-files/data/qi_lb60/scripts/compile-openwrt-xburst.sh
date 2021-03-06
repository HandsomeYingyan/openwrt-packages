#!/bin/bash

# This script file is using in build host, Xiangfu <xiangfu@openmobilefree.net>
# $1: full_system  minimal  xbboot

OPENWRT_DIR_NAME="openwrt-xburst."$1
OPENWRT_DIR="/home/xiangfu/tmp/${OPENWRT_DIR_NAME}/"
CONFIG_FILE_TYPE="config."$1

MAKE_VARS=" V=s IGNORE_ERRORS=m "

########################################################################
DATE=$(date "+%Y-%m-%d")
DATE_TIME=`date +"%Y%m%d-%H%M"`

GET_FEEDS_VERSION_SH="/home/xiangfu/bin/get-feeds-revision.sh"
PATCH_OPENWRT_SH="/home/xiangfu/bin/patch-openwrt.sh"

IMAGES_URL="http://pertain.qi-hardware.com/~xiangfu/build-nanonote"
IMAGES_DIR_BASE="/home/xiangfu/tmp/building/Nanonote/Ben"
IMAGES_DIR="${IMAGES_DIR_BASE}/${OPENWRT_DIR_NAME}-${DATE_TIME}/"
DEST_DIR="/home/xiangfu/tmp/build-nanonote"
mkdir -p ${IMAGES_DIR}
mkdir -p ${DEST_DIR}

BUILD_LOG="${IMAGES_DIR}/BUILD_LOG"
VERSIONS_FILE="${IMAGES_DIR}/VERSIONS"

########################################################################
if [ ! -d ${OPENWRT_DIR} ]; then
  git clone git://projects.qi-hardware.com/openwrt-xburst.git ${OPENWRT_DIR}
fi
cd ${OPENWRT_DIR}


echo "make distclean..."
make distclean 


echo "updating git repo..."
git fetch -a
git reset --hard origin/master
if [ "$?" != "0" ]; then
    echo "ERROR: updating openwrt-xburst failed"
    exit 1
fi


echo "update and install feeds..."
cp /home/xiangfu/bin/feeds.conf ./
./scripts/feeds update -a && ./scripts/feeds install -a
if [ "$?" != "0" ]; then
    echo "ERROR: update and install feeds failed"
    exit 1
fi
cp feeds/qipackages/nanonote-files/data/qi_lb60/conf/${CONFIG_FILE_TYPE} \
    .config
sed -i '/CONFIG_ALL/s/.*/CONFIG_ALL=y/' .config 
yes "" | make oldconfig > /dev/null


echo "getting version numbers of used repositories..."
HEAD_NEW=`${GET_FEEDS_VERSION_SH} ${OPENWRT_DIR}`
HEAD_OLD=`cat ${IMAGES_DIR}/../${OPENWRT_DIR_NAME}.VERSIONS`
if [ "${HEAD_NEW}" == "${HEAD_OLD}" ]; then
	echo "No new commit, ignore build"
	rm -f ${BUILD_LOG} ${VERSIONS_FILE}
	rmdir ${IMAGES_DIR}
	exit 0
fi
${GET_FEEDS_VERSION_SH} ${OPENWRT_DIR} > ${VERSIONS_FILE}
cp ${VERSIONS_FILE} ${IMAGES_DIR}/../${OPENWRT_DIR_NAME}.VERSIONS

echo "copy files, create VERSION, link dl folder, last prepare..."
rm -f files && ln -s feeds/qipackages/nanonote-files/files/
if [ ! -d /home/xiangfu/tmp/dl ]; then
  mkdir -p /home/xiangfu/tmp/dl
fi
rm -f dl    && ln -s /home/xiangfu/tmp/dl/
mkdir -p files/etc && echo ${DATE} > files/etc/VERSION
mkdir -p files/etc/uci-defaults && \
    echo -e "\0043\0041/bin/sh \ndate --set `date +"%Y%m%d%H%M"`\n  \
hwclock --systohc" > files/etc/uci-defaults/99-set-time


echo "patch openwrt..."
${PATCH_OPENWRT_SH} ${OPENWRT_DIR}


echo "starting compiling - this may take several hours..."
time make ${MAKE_VARS} > ${IMAGES_DIR}/BUILD_LOG 2>&1
MAKE_RET="$?"


echo "copy all files to IMAGES_DIR..."
cp .config ${IMAGES_DIR}/config
cp build_dir/linux-xburst_qi_lb60/linux-*/.config ${IMAGES_DIR}/kernel.config
cp feeds.conf ${IMAGES_DIR}/
cp -a bin/xburst/* ${IMAGES_DIR} 2>/dev/null
mkdir -p ${IMAGES_DIR}/files
cp -a files/* ${IMAGES_DIR}/files/

(cd ${IMAGES_DIR} && \
    grep -E "ERROR:\ package.*failed to build" BUILD_LOG | \
    grep -v "package/kernel" > failed_packages.txt; \

)

if [ "$1" == "minimal" ]; then
    cp ${IMAGES_DIR}/failed_packages.txt /home/xiangfu/tmp/building/Nanonote/Ben/
fi

if [ "${MAKE_RET}" == "0" ]; then
    (cd ${IMAGES_DIR} && \
        bzip2 -z openwrt-xburst-qi_lb60-root.ubi; \
	bzip2 -z BUILD_LOG; \
    )
    mv ${IMAGES_DIR} ${DEST_DIR}

    MSG="The build was successful: ${IMAGES_URL}/${OPENWRT_DIR_NAME}-${DATE_TIME}"
    echo -e "say #qi-hardware ${MSG} \nclose" \
        | nc turandot.qi-hardware.com 3858
else
    (cd ${IMAGES_DIR} && \
	tail -n 100 BUILD_LOG > BUILD_LOG.last100; \
	bzip2 -z BUILD_LOG; \
    )

    echo "ERROR: Build failed! please refer to the BUILD_LOG file"
fi


echo "Done"
