FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

CHASSIS_DEFAULT_TARGETS:remove = " \
    obmc-chassis-powerreset@{}.target.requires/phosphor-reset-chassis-on@{}.service \
    obmc-chassis-powerreset@{}.target.requires/phosphor-reset-chassis-running@{}.service \
    obmc-chassis-poweroff@{}.target.requires/obmc-power-stop@{}.service \
    obmc-chassis-poweron@{}.target.requires/obmc-power-start@{}.service \
"

PACKAGECONFIG:remove = "only-allow-boot-when-bmc-ready"

RDEPENDS:${PN}:append = " bash"

SRC_URI:append:minerva = " \
    file://chassis-powercycle \
    file://chassis-powercycle@.service \
    file://chassis-poweron-init \
    file://state-chassis.conf \
    "

do_install:append:minerva() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}/

    install -d ${D}${libexecdir}/${PN}
    install -m 0755 ${WORKDIR}/chassis-powercycle ${D}${libexecdir}/${PN}/
    install -m 0755 ${WORKDIR}/chassis-poweron-init ${D}${libexecdir}/${PN}/
}

SYSTEMD_OVERRIDE:${PN}-chassis += "state-chassis.conf:xyz.openbmc_project.State.Chassis@.service.d/state-chassis.conf"
