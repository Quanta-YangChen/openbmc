SUMMARY = "Phosphor systemd configuration overrides"
DESCRIPTION = "Overrides for systemd and its applications"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
DEPENDS += "systemd"
PR = "r1"

SRC_URI += "file://service-restart-policy.conf"
SRC_URI += "file://journald-maxlevel-policy.conf"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

do_install() {
        install -m 644 -D ${UNPACKDIR}/service-restart-policy.conf ${D}${systemd_unitdir}/system.conf.d/service-restart-policy.conf
        install -m 644 -D ${UNPACKDIR}/journald-maxlevel-policy.conf ${D}${systemd_unitdir}/journald.conf.d/journald-maxlevel-policy.conf
}

FILES:${PN} += "${systemd_unitdir}/system.conf.d/service-restart-policy.conf"
FILES:${PN} += "${systemd_unitdir}/journald.conf.d/journald-maxlevel-policy.conf"
