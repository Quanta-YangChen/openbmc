FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://ipmb-channels.json"

deltask ipmb_channels

do_install:append(){
    install -m 0644 -D ${WORKDIR}/ipmb-channels.json \
                   ${D}${datadir}/ipmbbridge/
}
