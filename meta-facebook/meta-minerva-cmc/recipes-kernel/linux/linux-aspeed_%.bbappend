FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
SRC_URI += " \
    file://minerva-cmc.cfg \
    file://0001-modify-dts.patch \
    file://0002-Add-BAT-DETECT-GPIO.patch \
"
