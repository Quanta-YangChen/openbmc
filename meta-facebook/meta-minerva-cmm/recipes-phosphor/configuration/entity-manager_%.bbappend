FILESEXTRAPATHS:prepend:minerva-cmm := "${THISDIR}/${PN}:"

SRC_URI:append:minerva-cmm = " \
    file://minerva-cmm.json \
"

do_install:append:minerva-cmm () {
    install -m 644 ${WORKDIR}/minerva-cmm.json ${D}/usr/share/entity-manager/configurations/minerva-cmm.json
}
