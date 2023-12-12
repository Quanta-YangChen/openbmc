FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://phosphor-multi-gpio-monitor.json \
    file://blade-present@.service \    
    file://blade-not-present@.service \
    file://record_blade_present_log.sh \
    file://mgmt-sfp-present.service \
    file://mgmt-sfp-not-present.service \
    file://mgmt_sfp_present.sh \
"

SYSTEMD_SERVICE:${PN} += "\
    blade-not-present@.service \
    blade-present@.service \
    mgmt-sfp-not-present.service \
    mgmt-sfp-present.service \
"

FILES:${PN} += " ${systemd_system_unitdir}/*.service"

do_install:append:() {
    install -d ${D}${datadir}/phosphor-gpio-monitor
    install -m 0644 ${WORKDIR}/phosphor-multi-gpio-monitor.json ${D}${datadir}/phosphor-gpio-monitor/

    install -d ${D}${libexecdir}/phosphor-gpio-monitor
    install -m 0777 ${WORKDIR}/record_blade_present_log.sh ${D}${libexecdir}/phosphor-gpio-monitor/
    install -m 0777 ${WORKDIR}/mgmt_sfp_present.sh ${D}${libexecdir}/phosphor-gpio-monitor/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}
}
