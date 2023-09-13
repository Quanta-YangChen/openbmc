FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI +=" \
    file://minerva-cmc.cfg \
    file://0001-modify-u-boot-dts.patch \
"
