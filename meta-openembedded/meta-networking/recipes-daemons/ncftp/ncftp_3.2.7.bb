DESCRIPTION = "A sophisticated console ftp client"
HOMEPAGE = "http://ncftp.com/"
SECTION = "net"
LICENSE = "ClArtistic"
LIC_FILES_CHKSUM = "file://ncftp/cmds.c;beginline=3;endline=4;md5=9c2390809f71465aa7ff76e03dc14d91"
DEPENDS = "ncurses"

SRC_URI = "https://www.ncftp.com/public_ftp/ncftp/${BP}-src.tar.xz \
           file://ncftp-configure-use-BUILD_CC-for-ccdv.patch \
           file://unistd.patch \
           file://0001-Forward-port-defining-PREFIX_BINDIR-to-use-new-autoc.patch \
           file://0001-ncftp-3.2.7-fix-gcc14.patch \
           file://0002-ncftp-3.2.7-fix-clang.patch \
           "
SRC_URI[sha256sum] = "d41c5c4d6614a8eae2ed4e4d7ada6b6d3afcc9fb65a4ed9b8711344bef24f7e8"

# Doesn't use automake
inherit autotools-brokensep pkgconfig

CFLAGS += "-DNO_SSLv2 -D_FILE_OFFSET_BITS=64 -Wall"

PACKAGECONFIG ??= ""
PACKAGECONFIG[ccdv] = "--enable-ccdv,--disable-ccdv,,"

EXTRA_AUTORECONF += "--exclude=aclocal -I ${S}/autoconf_local"
EXTRA_OECONF = "--disable-precomp --disable-universal ac_cv_path_TAR=tar"

do_install () {
    install -d ${D}${bindir} ${D}${sysconfdir} ${D}${mandir}
    oe_runmake 'prefix=${D}${prefix}' 'BINDIR=${D}${bindir}' \
        'SYSCONFDIR=${D}${sysconfdir}' 'mandir=${D}${mandir}' \
        install
}

# http://errors.yoctoproject.org/Errors/Details/766888/
# ncftp/3.2.7/ncftp-3.2.7/config.h:358:28: error: passing argument 2 of 'select' from incompatible pointer type [-Wincompatible-pointer-types]
CFLAGS += "-Wno-error=incompatible-pointer-types"
