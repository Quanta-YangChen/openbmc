FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " use-lamp-test"

SRC_URI += " \
    file://led-group-config.json \
    "
do_install:append() {
    install -m 0644 ${WORKDIR}/led-group-config.json ${D}${datadir}/phosphor-led-manager/
}
