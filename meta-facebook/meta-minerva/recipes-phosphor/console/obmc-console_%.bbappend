FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
OBMC_CONSOLE_TTYS = "ttyS0"

OBMC_CONSOLE_INST_CNT = "16"
OBMC_CONSOLE_INST = "${@' '.join(['{}'.format(i) for i in range(int(OBMC_CONSOLE_INST_CNT))])}"

SRC_URI:append = " file://server.ttyS0.conf \
                   file://client.2200.conf \
                   file://select-uart-mux"

CLIENT_SERVICE_FILES_FMT = "file://${BPN}-ttyS0-ssh-mtia-blade{0}@.service \
                            file://${BPN}-ttyS0-ssh-mtia-blade{0}.socket"


SRC_URI:append = " ${@compose_list(d, 'CLIENT_SERVICE_FILES_FMT', 'OBMC_CONSOLE_INST')} "

CLIENT_SERVICE_FMT = "${PN}-ttyS0-ssh-mtia-blade{0}@.service \
                      ${PN}-ttyS0-ssh-mtia-blade{0}.socket"

SYSTEMD_SERVICE:${PN}:append = " ${@compose_list(d, 'CLIENT_SERVICE_FMT', 'OBMC_CONSOLE_INST')} "

SRC_URI:remove = "file://${BPN}.conf"

SYSTEMD_SERVICE:${PN}:remove = "obmc-console-ssh.socket"
SYSTEMD_SERVICE:${PN}:remove = "obmc-console-ssh@.service"

PACKAGECONFIG:append = " concurrent-servers"

do_install:append() {
        # Install the server configuration
        install -m 0755 -d ${D}${sysconfdir}/${BPN}
        install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}/${BPN}/
        # Remove upstream-provided server configuration
        rm -f ${D}${sysconfdir}/${BPN}/server.ttyVUART0.conf
}

do_install:append() {
        install -m 0644 ${WORKDIR}/${BPN}-ttyS0-ssh-mtia-blade*@.service ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/${BPN}-ttyS0-ssh-mtia-blade*.socket ${D}${systemd_system_unitdir}
        install -m 0744 ${WORKDIR}/select-uart-mux ${D}${bindir}

        rm -rf ${D}${systemd_system_unitdir}/obmc-console-ssh@.service.d/
        rm -f ${D}${systemd_system_unitdir}/${BPN}-ssh@.service
        rm -f ${D}${systemd_system_unitdir}/${BPN}-ssh.socket
}
