FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://logging.sh \
    file://phosphor-multi-gpio-monitor.json \
    file://rpu-ready-assert.service \
    file://rpu-ready-deassert.service \
    file://toggle-switch-assert.service \
    file://toggle-switch-deassert.service \
    file://mgmt-sfp-prsnt-assert.service \
    file://mgmt-sfp-prsnt-deassert.service \
    file://blade-prsnt-assert@.service \    
    file://blade-prsnt-deassert@.service \
    file://blade-pwrok-assert@.service \
    file://blade-pwrok-deassert@.service \
    file://cable-prsnt-assert@.service \
    file://cable-prsnt-deassert@.service \
    file://leak-detect-assert@.service \
    file://leak-detect-deassert@.service \
    file://mgmt-sfp-rx-los-assert.service\
    file://mgmt-sfp-rx-los-deassert.service\
    file://mgmt-sfp-tx-fault-assert.service \
    file://mgmt-sfp-tx-fault-deassert.service \
"

SYSTEMD_SERVICE:${PN} += "\
    rpu-ready-assert.service \
    rpu-ready-deassert.service \
    toggle-switch-assert.service \
    toggle-switch-deassert.service \
    mgmt-sfp-prsnt-assert.service \
    mgmt-sfp-prsnt-deassert.service \
    blade-prsnt-assert@.service \    
    blade-prsnt-deassert@.service \
    blade-pwrok-assert@.service \
    blade-pwrok-deassert@.service \
    cable-prsnt-assert@.service \
    cable-prsnt-deassert@.service \
    leak-detect-assert@.service \
    leak-detect-deassert@.service \
    mgmt-sfp-rx-los-assert.service\
    mgmt-sfp-rx-los-deassert.service\
    mgmt-sfp-tx-fault-assert.service \
    mgmt-sfp-tx-fault-deassert.service \
"

FILES:${PN} += " ${systemd_system_unitdir}/*.service"

do_install:append:() {
    install -d ${D}${datadir}/phosphor-gpio-monitor
    install -m 0644 ${WORKDIR}/phosphor-multi-gpio-monitor.json ${D}${datadir}/phosphor-gpio-monitor/

    install -d ${D}${libexecdir}/phosphor-gpio-monitor
    install -m 0777 ${WORKDIR}/logging.sh ${D}${libexecdir}/phosphor-gpio-monitor/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}
}
