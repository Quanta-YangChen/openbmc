FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
SRC_URI += " \
    file://minerva-cmm.cfg \
    file://aspeed-bmc-facebook-minerva-cmm.dts \
    file://0001-Support-LTC4286.patch \
    file://0002-i3c-support.patch \
"

do_configure:append(){
    cp ${WORKDIR}/aspeed-bmc-facebook-minerva-cmm.dts ${S}/arch/arm/boot/dts/aspeed
    echo "dtb-\$(CONFIG_ARCH_ASPEED) += aspeed-bmc-facebook-minerva-cmm.dtb" >> ${S}/arch/arm/boot/dts/aspeed/Makefile
}
