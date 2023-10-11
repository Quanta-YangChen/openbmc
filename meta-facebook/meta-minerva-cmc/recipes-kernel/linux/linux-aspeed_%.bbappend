FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
SRC_URI += " \
    file://minerva-cmc.cfg \
    file://aspeed-bmc-facebook-minerva-cmc.dts \
"

do_configure:append(){
    cp ${WORKDIR}/aspeed-bmc-facebook-minerva-cmc.dts ${S}/arch/arm/boot/dts/aspeed
    echo "dtb-\$(CONFIG_ARCH_ASPEED) += aspeed-bmc-facebook-minerva-cmc.dtb" >> ${S}/arch/arm/boot/dts/aspeed/Makefile

}
