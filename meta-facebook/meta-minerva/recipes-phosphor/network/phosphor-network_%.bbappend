FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " sync-mac"

EXTRA_OEMESON = "-Dforce-sync-mac=true"

SRC_URI += " \
    file://config.json \
    file://20-vlan7.netdev \
    file://20-vlan8.netdev \
    file://30-eth0.7.network \
    file://30-eth0.8.network \
    "
FILES:${PN} += "\
    ${datadir}/network/*.json \
    ${systemd_unitdir}/network/* \
    "

do_install:append() {
    install -d ${D}${datadir}/network/
    install -d ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/config.json ${D}${datadir}/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/*.netdev ${D}${systemd_unitdir}/network/
}
