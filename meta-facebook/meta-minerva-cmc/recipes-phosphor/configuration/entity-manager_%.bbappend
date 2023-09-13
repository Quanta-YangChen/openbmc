FILESEXTRAPATHS:prepend:minerva-cmc := "${THISDIR}/${PN}:"

SRC_URI:append:minerva-cmc = " \
    file://minerva-cmc.json \
"

do_install:append:minerva-cmc () {
    install -m 644 ${WORKDIR}/minerva-cmc.json ${D}/usr/share/entity-manager/configurations/minerva-cmc.json
}
